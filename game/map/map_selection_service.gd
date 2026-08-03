class_name MapSelectionService
extends RefCounted

const MapSelectionReceiptScript := preload("res://game/map/map_selection_receipt.gd")
const MapSelectionResultScript := preload("res://game/map/map_selection_result.gd")
const MapSelectionRequestScript := preload("res://game/map/map_selection_request.gd")

var _catalog: Variant
var _discovery: Variant


func configure(catalog: Variant, discovery_state: Variant) -> void:
	assert(catalog != null and catalog.has_method("resolve_latest"), "MapSelectionService requires catalog")
	assert(discovery_state != null and discovery_state.has_method("commit_receipt"), "MapSelectionService requires discovery state")
	_catalog = catalog
	_discovery = discovery_state


func select(request: Variant) -> Variant:
	if _catalog == null or _discovery == null:
		return MapSelectionResultScript.failed(&"NOT_CONFIGURED", "selection service must be configured")
	if request == null:
		return MapSelectionResultScript.failed(&"INVALID_REQUEST", "selection request required")
	var errors: Array[String] = request.validation_errors()
	if not errors.is_empty():
		return MapSelectionResultScript.failed(&"INVALID_REQUEST", "; ".join(errors))

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
	return _discovery != null and _discovery.commit_receipt(receipt)


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
	return MapSelectionResultScript.succeeded(
		MapSelectionReceiptScript.create(request, phase, definition)
	)


func _select_manual(request: Variant) -> Variant:
	if not _discovery.is_discovered(request.requested_map_id):
		return MapSelectionResultScript.failed(&"MAP_NOT_DISCOVERED", "manual selection requires discovered map")
	var definition: Variant = _catalog.resolve_latest(request.requested_map_id)
	if definition == null:
		return MapSelectionResultScript.failed(&"MAP_UNAVAILABLE", "requested map is unavailable")
	return MapSelectionResultScript.succeeded(
		MapSelectionReceiptScript.create(request, &"MANUAL", definition)
	)


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
	return MapSelectionResultScript.succeeded(
		MapSelectionReceiptScript.create(request, &"RESTART", definition)
	)
