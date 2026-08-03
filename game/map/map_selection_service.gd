class_name MapSelectionService
extends RefCounted

const MapSelectionReceiptScript := preload("res://game/map/map_selection_receipt.gd")
const MapSelectionResultScript := preload("res://game/map/map_selection_result.gd")
const MapSelectionRequestScript := preload("res://game/map/map_selection_request.gd")

var _catalog: Variant
var _discovery: Variant
var _issued_receipts: Dictionary = {}
var _issued_snapshots: Dictionary = {}
var _used_request_ids: Dictionary = {}


func configure(catalog: Variant, discovery_state: Variant) -> void:
	assert(catalog != null and catalog.has_method("resolve_latest"), "MapSelectionService requires catalog")
	assert(discovery_state != null and discovery_state.has_method("commit_receipt"), "MapSelectionService requires discovery state")
	_catalog = catalog
	_discovery = discovery_state
	_issued_receipts.clear()
	_issued_snapshots.clear()
	_used_request_ids.clear()


func select(request: Variant) -> Variant:
	if _catalog == null or _discovery == null:
		return MapSelectionResultScript.failed(&"NOT_CONFIGURED", "selection service must be configured")
	if request == null:
		return MapSelectionResultScript.failed(&"INVALID_REQUEST", "selection request required")
	var errors: Array[String] = request.validation_errors()
	if not errors.is_empty():
		return MapSelectionResultScript.failed(&"INVALID_REQUEST", "; ".join(errors))
	if _used_request_ids.has(request.request_id):
		return MapSelectionResultScript.failed(&"DUPLICATE_REQUEST", "selection request id was already issued")

	match request.mode:
		MapSelectionRequestScript.MODE_AUTO_NEW_RUN:
			return _select_automatic(request)
		MapSelectionRequestScript.MODE_SELECT_DISCOVERED:
			return _select_manual(request)
		MapSelectionRequestScript.MODE_RESTART:
			return _select_restart(request)
		_:
			return MapSelectionResultScript.failed(&"INVALID_REQUEST", "unsupported selection mode")


func commit_started(receipt: Variant) -> bool:
	if _discovery == null or receipt == null:
		return false
	var receipt_id := str(receipt.receipt_id)
	if receipt_id.is_empty() or not _issued_receipts.has(receipt_id):
		return false
	if _issued_receipts[receipt_id] != receipt:
		_discard_issued(receipt_id)
		return false
	var snapshot: Dictionary = _issued_snapshots.get(receipt_id, {})
	if not _receipt_matches_snapshot(receipt, snapshot):
		_discard_issued(receipt_id)
		return false
	var committed: bool = _discovery.commit_receipt(receipt)
	_discard_issued(receipt_id)
	return committed


func _select_automatic(request: Variant) -> Variant:
	var phase: StringName
	var map_id: StringName
	if _discovery.undiscovered_remaining_count() > 0:
		phase = &"UNDISCOVERED"
		map_id = _discovery.peek_undiscovered()
	else:
		phase = &"REPLAY"
		map_id = _discovery.peek_replay()
	if map_id == &"":
		return MapSelectionResultScript.failed(&"NO_ELIGIBLE_MAP", "no automatic map is eligible")
	var definition: Variant = _catalog.resolve_latest(map_id)
	if definition == null:
		return MapSelectionResultScript.failed(&"MAP_UNAVAILABLE", "selected map is unavailable")
	return _issue(request, phase, definition)


func _select_manual(request: Variant) -> Variant:
	if not _discovery.is_discovered(request.requested_map_id):
		return MapSelectionResultScript.failed(&"MAP_NOT_DISCOVERED", "manual selection requires discovered map")
	var definition: Variant = _catalog.resolve_latest(request.requested_map_id)
	if definition == null:
		return MapSelectionResultScript.failed(&"MAP_UNAVAILABLE", "requested map is unavailable")
	return _issue(request, &"MANUAL", definition)


func _select_restart(request: Variant) -> Variant:
	var previous_identity: Variant = request.previous_run_identity
	var previous_definition: Variant = previous_identity.map_definition
	var definition: Variant = _catalog.resolve(
		previous_definition.map_id,
		previous_definition.map_revision
	)
	if definition == null:
		return MapSelectionResultScript.failed(&"RESTART_MAP_UNAVAILABLE", "exact restart map revision is unavailable")
	if definition.content_signature != previous_definition.content_signature:
		return MapSelectionResultScript.failed(&"RESTART_SIGNATURE_MISMATCH", "exact restart map content changed")
	if not _discovery.is_discovered(definition.map_id):
		return MapSelectionResultScript.failed(&"MAP_NOT_DISCOVERED", "restart requires a previously started map")
	return _issue(request, &"RESTART", definition)


func _issue(request: Variant, phase: StringName, definition: Variant) -> Variant:
	var receipt: Variant = MapSelectionReceiptScript.create(request, phase, definition)
	var receipt_id := str(receipt.receipt_id)
	_used_request_ids[request.request_id] = true
	_issued_receipts[receipt_id] = receipt
	_issued_snapshots[receipt_id] = _snapshot(receipt)
	return MapSelectionResultScript.succeeded(receipt)


func _snapshot(receipt: Variant) -> Dictionary:
	return {
		"receipt_id": str(receipt.receipt_id),
		"request_id": str(receipt.request_id),
		"selection_mode": StringName(receipt.selection_mode),
		"selection_phase": StringName(receipt.selection_phase),
		"map_id": StringName(receipt.map_id),
		"map_revision": int(receipt.map_revision),
		"content_signature": str(receipt.content_signature),
		"definition_identity": receipt.map_definition.identity_key(),
		"definition_content": str(receipt.map_definition.content_signature),
	}


func _receipt_matches_snapshot(receipt: Variant, snapshot: Dictionary) -> bool:
	if snapshot.is_empty() or receipt.map_definition == null:
		return false
	return (
		str(receipt.receipt_id) == str(snapshot.get("receipt_id", ""))
		and str(receipt.request_id) == str(snapshot.get("request_id", ""))
		and StringName(receipt.selection_mode) == StringName(snapshot.get("selection_mode", &""))
		and StringName(receipt.selection_phase) == StringName(snapshot.get("selection_phase", &""))
		and StringName(receipt.map_id) == StringName(snapshot.get("map_id", &""))
		and int(receipt.map_revision) == int(snapshot.get("map_revision", 0))
		and str(receipt.content_signature) == str(snapshot.get("content_signature", ""))
		and receipt.map_definition.identity_key() == str(snapshot.get("definition_identity", ""))
		and str(receipt.map_definition.content_signature) == str(snapshot.get("definition_content", ""))
	)


func _discard_issued(receipt_id: String) -> void:
	_issued_receipts.erase(receipt_id)
	_issued_snapshots.erase(receipt_id)
