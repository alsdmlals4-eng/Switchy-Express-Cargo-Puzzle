class_name FirstSessionDefinition
extends RefCounted

const SCHEMA_VERSION := 1
const SELF_SCRIPT_PATH := "res://game/first_session/first_session_definition.gd"
const REQUIRED_IDS: Array[StringName] = [&"T1", &"T2", &"T3", &"T4", &"T5", &"T6", &"CAPSTONE"]
const ARRAY_FIELDS: Array[StringName] = [
	&"visible_features",
	&"allowed_build_tools",
	&"allowed_build_commands",
	&"allowed_run_commands",
]

var _lessons: Dictionary = {}


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
	var values: Variant = data.get("lessons", [])
	if not values is Array or values.size() != REQUIRED_IDS.size():
		return null

	var instance: Variant = load(SELF_SCRIPT_PATH).new()
	for index: int in range(REQUIRED_IDS.size()):
		var value: Variant = values[index]
		if not value is Dictionary:
			return null
		var lesson: Dictionary = value
		var lesson_id := StringName(lesson.get("lesson_id", &""))
		if lesson_id != REQUIRED_IDS[index] or instance._lessons.has(lesson_id):
			return null
		if str(lesson.get("map_path", "")).is_empty():
			return null
		for field: StringName in ARRAY_FIELDS:
			if not lesson.get(field, null) is Array:
				return null
		instance._lessons[lesson_id] = lesson.duplicate(true)

	if instance.lesson(&"T1").get("map_path") != instance.lesson(&"T2").get("map_path"):
		return null
	if instance.lesson(&"CAPSTONE").get("map_path") != "res://data/maps/vs_demo_01.json":
		return null
	return instance


func lesson_ids() -> Array[StringName]:
	return REQUIRED_IDS.duplicate()


func lesson(lesson_id: StringName) -> Dictionary:
	var value: Variant = _lessons.get(lesson_id, {})
	return value.duplicate(true) if value is Dictionary else {}
