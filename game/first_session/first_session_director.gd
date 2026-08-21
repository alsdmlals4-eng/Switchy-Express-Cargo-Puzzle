class_name FirstSessionDirector
extends RefCounted

const PolicyScript := preload("res://game/first_session/first_session_stage_policy.gd")

var _definition: Variant = null
var _lesson_ids: Array[StringName] = []
var _index: int = 0
var _sequence_complete: bool = false


func configure(definition: Variant) -> bool:
	if definition == null or not definition.has_method("lesson_ids"):
		return false
	var values: Variant = definition.lesson_ids()
	if not values is Array or values.is_empty():
		return false
	_definition = definition
	_lesson_ids.clear()
	for value: Variant in values:
		_lesson_ids.append(StringName(value))
	reset()
	return true


func current_lesson_id() -> StringName:
	if _lesson_ids.is_empty() or _index < 0 or _index >= _lesson_ids.size():
		return &""
	return _lesson_ids[_index]


func current_lesson() -> Dictionary:
	if _definition == null:
		return {}
	return _definition.lesson(current_lesson_id())


func current_policy() -> Variant:
	return PolicyScript.create(current_lesson())


func observe_model(model: Dictionary) -> Dictionary:
	if (
		current_lesson_id() == &"T1"
		and StringName(model.get("phase", &"")) == &"BUILD"
		and bool(model.get("start_enabled", false))
	):
		return _advance(true)
	return _unchanged()


func observe_terminal(summary: Variant) -> Dictionary:
	if StringName(_summary_value(summary, &"outcome", &"FAILURE")) != &"SUCCESS":
		return _unchanged()
	if current_lesson_id() == &"CAPSTONE":
		_sequence_complete = true
		return _unchanged()
	if current_lesson_id() == &"T1":
		return _unchanged()
	return _advance(false)


func reset() -> void:
	_index = 0
	_sequence_complete = false


func _advance(preserve_gameplay_instance: bool) -> Dictionary:
	var previous := current_lesson_id()
	if _index + 1 >= _lesson_ids.size():
		return _unchanged()
	_index += 1
	return {
		"changed": true,
		"sequence_complete": false,
		"preserve_gameplay_instance": preserve_gameplay_instance,
		"previous_lesson": previous,
		"current_lesson": current_lesson_id(),
	}


func _unchanged() -> Dictionary:
	return {
		"changed": false,
		"sequence_complete": _sequence_complete,
		"preserve_gameplay_instance": false,
		"previous_lesson": current_lesson_id(),
		"current_lesson": current_lesson_id(),
	}


static func _summary_value(summary: Variant, key: StringName, fallback: Variant) -> Variant:
	if summary == null:
		return fallback
	if summary is Dictionary:
		return summary.get(key, fallback)
	var value: Variant = summary.get(key)
	return fallback if value == null else value
