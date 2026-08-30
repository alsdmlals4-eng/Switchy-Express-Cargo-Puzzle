class_name RouteBookDirector
extends RefCounted

var _definition: Variant = null
var _stage_ids: Array[StringName] = []
var _index: int = -1


func configure(definition: Variant) -> bool:
	if definition == null or not definition.has_method("stage_ids"):
		return false
	var values: Variant = definition.stage_ids()
	if not values is Array or values.is_empty():
		return false
	_definition = definition
	_stage_ids.clear()
	for value: Variant in values:
		_stage_ids.append(StringName(value))
	reset()
	return true


func reset() -> void:
	_index = -1


func select_stage(stage_id: StringName) -> bool:
	var selected_index := _stage_ids.find(stage_id)
	if selected_index < 0:
		return false
	_index = selected_index
	return true


func current_stage_id() -> StringName:
	if _index < 0 or _index >= _stage_ids.size():
		return &""
	return _stage_ids[_index]


func current_stage_number() -> int:
	return _index + 1 if current_stage_id() != &"" else 0


func stage_count() -> int:
	return _stage_ids.size()


func stage_ids() -> Array[StringName]:
	return _stage_ids.duplicate()


func stage(stage_id: StringName) -> Dictionary:
	if _definition == null:
		return {}
	return _definition.stage(stage_id)


func current_stage() -> Dictionary:
	return stage(current_stage_id())


func has_next_stage() -> bool:
	return _index >= 0 and _index + 1 < _stage_ids.size()


func select_next_stage() -> bool:
	if not has_next_stage():
		return false
	_index += 1
	return true
