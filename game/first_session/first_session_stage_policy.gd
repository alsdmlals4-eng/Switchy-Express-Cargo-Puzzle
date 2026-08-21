class_name FirstSessionStagePolicy
extends RefCounted

const SELF_SCRIPT_PATH := "res://game/first_session/first_session_stage_policy.gd"
const TERMINAL_COMMANDS: Array[StringName] = [&"RETRY_SAME_LAYOUT", &"EDIT_LAYOUT"]

var _context_key: StringName = &""
var _visible_features: Dictionary = {}
var _allowed_build_tools: Dictionary = {}
var _allowed_build_commands: Dictionary = {}
var _allowed_run_commands: Dictionary = {}


static func create(lesson: Dictionary) -> Variant:
	if lesson.is_empty():
		return null
	var instance: Variant = load(SELF_SCRIPT_PATH).new()
	instance._context_key = StringName(lesson.get("context_key", &""))
	instance._visible_features = _to_set(lesson.get("visible_features", []))
	instance._allowed_build_tools = _to_set(lesson.get("allowed_build_tools", []))
	instance._allowed_build_commands = _to_set(lesson.get("allowed_build_commands", []))
	instance._allowed_run_commands = _to_set(lesson.get("allowed_run_commands", []))
	return instance


func allows_command(command: StringName, phase: StringName, payload: Variant = null) -> bool:
	if phase == &"SUCCESS" or phase == &"FAILURE":
		return TERMINAL_COMMANDS.has(command)
	if command == &"BUILD_TOOL":
		return (
			phase == &"BUILD"
			and _allowed_build_commands.has(command)
			and _allowed_build_tools.has(StringName(payload))
		)
	match phase:
		&"BUILD":
			return _allowed_build_commands.has(command)
		&"RUNNING", &"UNLOADING":
			return _allowed_run_commands.has(command)
		&"PAUSED":
			return command == &"RESUME" and _allowed_run_commands.has(command)
		_:
			return false


func feature_visible(feature: StringName) -> bool:
	return _visible_features.has(feature)


func visible_features() -> Array[StringName]:
	var result: Array[StringName] = []
	for value: Variant in _visible_features.keys():
		result.append(StringName(value))
	return result


func context_key() -> StringName:
	return _context_key


static func _to_set(values: Variant) -> Dictionary:
	var result: Dictionary = {}
	if values is Array:
		for value: Variant in values:
			var key := StringName(value)
			if key != &"":
				result[key] = true
	return result
