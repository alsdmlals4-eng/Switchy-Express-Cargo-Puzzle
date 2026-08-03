class_name MapSelectionReceipt
extends RefCounted

const SELF_SCRIPT_PATH := "res://game/map/map_selection_receipt.gd"

var receipt_id: String = ""
var request_id: String = ""
var selection_mode: StringName = &""
var selection_phase: StringName = &""
var map_id: StringName = &""
var map_revision: int = 0
var content_signature: String = ""
var map_definition: Variant


static func create(
	request: Variant,
	phase: StringName,
	definition: Variant
) -> Variant:
	assert(request != null and request.validation_errors().is_empty(), "valid selection request required")
	assert(definition != null and definition.is_runtime_eligible(), "eligible map definition required")
	var value: Variant = load(SELF_SCRIPT_PATH).new()
	value.receipt_id = "selection:%s" % request.request_id
	value.request_id = request.request_id
	value.selection_mode = request.mode
	value.selection_phase = phase
	value.map_id = definition.map_id
	value.map_revision = definition.map_revision
	value.content_signature = definition.content_signature
	value.map_definition = definition
	return value


func to_public_dictionary() -> Dictionary:
	return {
		"receipt_id": receipt_id,
		"request_id": request_id,
		"selection_mode": str(selection_mode),
		"selection_phase": str(selection_phase),
		"map_id": str(map_id),
		"map_revision": map_revision,
	}
