class_name CompactWagonTokenState
extends RefCounted

var _cargo_stack: Variant
var _front_to_rear_types: Array[StringName] = []
var _revision: int = 0


func configure(cargo_stack: Variant) -> void:
	assert(cargo_stack != null, "CompactWagonTokenState requires a CargoStack")
	_cargo_stack = cargo_stack
	_front_to_rear_types = _cargo_stack.load_order()
	_revision = 0


func sync_from_stack() -> bool:
	assert(_cargo_stack != null, "CompactWagonTokenState must be configured before synchronization")
	var next_types: Array[StringName] = _cargo_stack.load_order()
	if next_types == _front_to_rear_types:
		return false
	_front_to_rear_types = next_types.duplicate()
	_revision += 1
	return true


func token_count() -> int:
	return _front_to_rear_types.size()


func front_to_rear_types() -> Array[StringName]:
	return _front_to_rear_types.duplicate()


func rear_type() -> StringName:
	if _front_to_rear_types.is_empty():
		return &""
	return _front_to_rear_types[_front_to_rear_types.size() - 1]


func revision() -> int:
	return _revision
