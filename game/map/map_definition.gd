class_name MapDefinition
extends RefCounted

const RUNTIME_STATUSES: Array[StringName] = [&"VALIDATED", &"SHIPPED"]
const SELF_SCRIPT_PATH := "res://game/map/map_definition.gd"

var map_id: StringName = &""
var map_revision: int = 0
var map_seed: int = 0
var generator_version: StringName = &""
var ruleset_version: StringName = &""
var validation_status: StringName = &"DRAFT"
var start_cell: Vector2i = Vector2i.ZERO
var incoming_cell: Vector2i = Vector2i.ZERO
var graph_signature: String = ""
var station_signature: String = ""
var initial_pickup_signature: String = ""
var layout_signature: String = ""
var content_signature: String = ""
var used_fallback: bool = false


static func create(data: Dictionary) -> Variant:
	var value: Variant = load(SELF_SCRIPT_PATH).new()
	value.map_id = StringName(data.get("map_id", &""))
	value.map_revision = int(data.get("map_revision", 0))
	value.map_seed = int(data.get("map_seed", 0))
	value.generator_version = StringName(data.get("generator_version", &""))
	value.ruleset_version = StringName(data.get("ruleset_version", &""))
	value.validation_status = StringName(data.get("validation_status", &"DRAFT"))
	value.start_cell = _read_cell(data.get("start_cell", []))
	value.incoming_cell = _read_cell(data.get("incoming_cell", []))
	value.graph_signature = str(data.get("graph_signature", ""))
	value.station_signature = str(data.get("station_signature", ""))
	value.initial_pickup_signature = str(data.get("initial_pickup_signature", ""))
	value.layout_signature = str(data.get("layout_signature", ""))
	value.content_signature = str(data.get("content_signature", ""))
	value.used_fallback = bool(data.get("used_fallback", false))
	return value


func identity_key() -> String:
	return "%s@%d" % [map_id, map_revision]


func validation_errors() -> Array[String]:
	var errors: Array[String] = []
	if map_id == &"":
		errors.append("map_id is required")
	if map_revision <= 0:
		errors.append("map_revision must be positive")
	if generator_version == &"":
		errors.append("generator_version is required")
	if ruleset_version == &"":
		errors.append("ruleset_version is required")
	if start_cell == incoming_cell:
		errors.append("incoming_cell must differ from start_cell")
	if graph_signature.is_empty():
		errors.append("graph_signature is required")
	if station_signature.is_empty():
		errors.append("station_signature is required")
	if initial_pickup_signature.is_empty():
		errors.append("initial_pickup_signature is required")
	if layout_signature.is_empty():
		errors.append("layout_signature is required")
	if content_signature.is_empty():
		errors.append("content_signature is required")
	return errors


func is_runtime_eligible() -> bool:
	return (
		validation_errors().is_empty()
		and not used_fallback
		and validation_status in RUNTIME_STATUSES
	)


func to_manifest_entry() -> Dictionary:
	return {
		"map_id": str(map_id),
		"map_revision": map_revision,
		"map_seed": map_seed,
		"generator_version": str(generator_version),
		"ruleset_version": str(ruleset_version),
		"validation_status": str(validation_status),
		"start_cell": [start_cell.x, start_cell.y],
		"incoming_cell": [incoming_cell.x, incoming_cell.y],
	}


func to_dictionary() -> Dictionary:
	var data := to_manifest_entry()
	data["graph_signature"] = graph_signature
	data["station_signature"] = station_signature
	data["initial_pickup_signature"] = initial_pickup_signature
	data["layout_signature"] = layout_signature
	data["content_signature"] = content_signature
	data["used_fallback"] = used_fallback
	return data


func to_public_dictionary() -> Dictionary:
	return {
		"map_id": str(map_id),
		"map_revision": map_revision,
		"validation_status": str(validation_status),
	}


static func _read_cell(raw: Variant) -> Vector2i:
	if raw is Vector2i:
		return raw
	if raw is Array and raw.size() == 2:
		return Vector2i(int(raw[0]), int(raw[1]))
	if raw is Dictionary and raw.has("x") and raw.has("y"):
		return Vector2i(int(raw.x), int(raw.y))
	return Vector2i.ZERO
