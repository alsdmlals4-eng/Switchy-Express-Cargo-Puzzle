class_name CargoStack
extends RefCounted

const CargoTypeScript := preload("res://game/cargo/cargo_type.gd")
const CONFIRMED_CAPACITY := 8

var capacity: int = CONFIRMED_CAPACITY
var _items: Array[StringName] = []


func _init(requested_capacity: int = CONFIRMED_CAPACITY) -> void:
	capacity = clampi(requested_capacity, 0, CONFIRMED_CAPACITY)


func try_load(cargo_type: StringName, input_state: Variant) -> bool:
	if input_state == null or not input_state.is_loading():
		return false
	return push(cargo_type)


func push(cargo_type: StringName) -> bool:
	if not CargoTypeScript.is_valid(cargo_type):
		return false
	if _items.size() >= capacity:
		return false
	_items.append(cargo_type)
	return true


func peek() -> StringName:
	if _items.is_empty():
		return &""
	return _items[_items.size() - 1]


func pop_matching_group(cargo_type: StringName) -> Array[StringName]:
	var unloaded: Array[StringName] = []
	if peek() != cargo_type:
		return unloaded
	while not _items.is_empty() and peek() == cargo_type:
		unloaded.append(_items.pop_back())
	return unloaded


func load_order() -> Array[StringName]:
	return _items.duplicate()


func unload_order() -> Array[StringName]:
	var result: Array[StringName] = _items.duplicate()
	result.reverse()
	return result


func size() -> int:
	return _items.size()


func is_empty() -> bool:
	return _items.is_empty()


func is_full() -> bool:
	return _items.size() >= capacity
