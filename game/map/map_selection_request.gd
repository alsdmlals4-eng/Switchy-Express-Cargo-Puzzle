class_name MapSelectionRequest
extends RefCounted

const SELF_SCRIPT_PATH := "res://game/map/map_selection_request.gd"
const MODE_AUTO_NEW_RUN: StringName = &"AUTO_NEW_RUN"
const MODE_SELECT_DISCOVERED: StringName = &"SELECT_DISCOVERED"
const MODE_RESTART: StringName = &"RESTART"

var request_id: String = ""
var mode: StringName = &""
var requested_map_id: StringName = &""
var previous_run_identity: Variant


static func auto_new_run(request_id_value: String) -> Variant:
	return _create(request_id_value, MODE_AUTO_NEW_RUN, &"", null)


static func select_discovered(request_id_value: String, map_id: StringName) -> Variant:
	return _create(request_id_value, MODE_SELECT_DISCOVERED, map_id, null)


static func restart(request_id_value: String, identity: Variant) -> Variant:
	return _create(request_id_value, MODE_RESTART, &"", identity)


static func _create(
	request_id_value: String,
	mode_value: StringName,
	map_id: StringName,
	identity: Variant
) -> Variant:
	var value: Variant = load(SELF_SCRIPT_PATH).new()
	value.request_id = request_id_value
	value.mode = mode_value
	value.requested_map_id = map_id
	value.previous_run_identity = identity
	return value


func validation_errors() -> Array[String]:
	var errors: Array[String] = []
	if request_id.is_empty():
		errors.append("request_id is required")
	if mode not in [MODE_AUTO_NEW_RUN, MODE_SELECT_DISCOVERED, MODE_RESTART]:
		errors.append("unsupported selection mode")
	if mode == MODE_SELECT_DISCOVERED and requested_map_id == &"":
		errors.append("requested_map_id is required")
	if mode == MODE_RESTART and previous_run_identity == null:
		errors.append("previous_run_identity is required")
	return errors


func to_dictionary() -> Dictionary:
	var data := {
		"request_id": request_id,
		"mode": str(mode),
	}
	if requested_map_id != &"":
		data["requested_map_id"] = str(requested_map_id)
	if previous_run_identity != null:
		data["previous_map_id"] = str(previous_run_identity.map_definition.map_id)
		data["previous_run_id"] = str(previous_run_identity.run_id)
	return data
