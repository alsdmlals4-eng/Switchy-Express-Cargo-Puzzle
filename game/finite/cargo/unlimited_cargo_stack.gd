class_name UnlimitedCargoStack
extends RefCounted

const CargoTypeScript := preload("res://game/cargo/cargo_type.gd")

var _items: Array[StringName] = []


func push(cargo_type: StringName) -> bool:
	if not CargoTypeScript.is_valid(cargo_type):
		return false
	_items.append(cargo_type)
	return true


func peek() -> StringName:
	if _items.is_empty():
		return &""
	return _items[_items.size() - 1]


func pop_matching_group(cargo_type: StringName) -> Array[StringName]:
	var unloaded: Array[StringName] = []
	if not CargoTypeScript.is_valid(cargo_type) or peek() != cargo_type:
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


func clear() -> void:
	_items.clear()
