class_name RouteBookDefinition
extends RefCounted

const SCHEMA_VERSION := 1
const BOOK_ID: StringName = &"ROUTE_BOOK_01"
const SELF_SCRIPT_PATH := "res://game/route_book/route_book_definition.gd"
const REQUIRED_IDS: Array[StringName] = [
	&"RB01_SERVICE_SIDINGS",
	&"RB02_REVERSE_ORDER",
	&"RB03_RETURN_MANIFEST",
	&"RB04_LOAD_WINDOW",
	&"RB05_FORK_LOCK",
	&"RB06_PORT_CIRCUIT",
]
const ARRAY_FIELDS: Array[StringName] = [
	&"visible_features",
	&"allowed_build_tools",
	&"allowed_build_commands",
	&"allowed_run_commands",
]

var _stages: Dictionary = {}


static func load_from_path(path: String) -> Variant:
	if not FileAccess.file_exists(path):
		return null
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return null
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		return null
	return create(parsed)


static func create(data: Dictionary) -> Variant:
	if int(data.get("schema_version", -1)) != SCHEMA_VERSION:
		return null
	if StringName(data.get("book_id", &"")) != BOOK_ID:
		return null
	var values: Variant = data.get("stages", [])
	if not values is Array or values.size() != REQUIRED_IDS.size():
		return null

	var instance: Variant = load(SELF_SCRIPT_PATH).new()
	for index: int in range(REQUIRED_IDS.size()):
		var value: Variant = values[index]
		if not value is Dictionary:
			return null
		var stage: Dictionary = value
		var stage_id := StringName(stage.get("stage_id", &""))
		if stage_id != REQUIRED_IDS[index] or instance._stages.has(stage_id):
			return null
		if not _has_required_text(stage, &"map_path"):
			return null
		if not str(stage.get("map_path", "")).begins_with("res://data/maps/route_book/"):
			return null
		if not _has_required_text(stage, &"title_key") or not _has_required_text(stage, &"objective_key"):
			return null
		for field: StringName in ARRAY_FIELDS:
			var array_value: Variant = stage.get(field, null)
			if not array_value is Array:
				return null
		if (stage.get("visible_features", []) as Array).has("RECOMMENDED_LAYOUT"):
			return null
		instance._stages[stage_id] = stage.duplicate(true)
	return instance


func book_id() -> StringName:
	return BOOK_ID


func stage_ids() -> Array[StringName]:
	return REQUIRED_IDS.duplicate()


func stage_count() -> int:
	return REQUIRED_IDS.size()


func stage(stage_id: StringName) -> Dictionary:
	var value: Variant = _stages.get(stage_id, {})
	return value.duplicate(true) if value is Dictionary else {}


static func _has_required_text(stage: Dictionary, key: StringName) -> bool:
	return not str(stage.get(key, "")).is_empty()
