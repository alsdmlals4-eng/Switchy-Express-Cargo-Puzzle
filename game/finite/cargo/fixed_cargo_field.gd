class_name FixedCargoField
extends RefCounted

const CargoTypeScript := preload("res://game/cargo/cargo_type.gd")

var _authored_by_cell: Dictionary = {}
var _remaining_by_cell: Dictionary = {}
var _validation_errors: Array[String] = []


func _init(placements: Array = []) -> void:
	var seen: Dictionary = {}
	for placement: Variant in placements:
		if not placement is Dictionary:
			_validation_errors.append("cargo placement must be a dictionary")
			continue
		var cell_raw: Variant = placement.get("cell", null)
		var cell: Variant = _read_cell(cell_raw)
		if cell == null:
			_validation_errors.append("cargo placement cell is required")
			continue
		if seen.has(cell):
			_validation_errors.append("cargo placement cells must be unique")
			continue
		seen[cell] = true
		var cargo_type := StringName(placement.get("cargo_type", &""))
		if not CargoTypeScript.is_valid(cargo_type):
			_validation_errors.append("cargo placement cargo_type must be valid")
			continue
		_authored_by_cell[cell] = cargo_type
	reset()


func validation_errors() -> Array[String]:
	return _validation_errors.duplicate()


func has_cargo(cell: Vector2i) -> bool:
	return _remaining_by_cell.has(cell)


func cargo_type_at(cell: Vector2i) -> StringName:
	return StringName(_remaining_by_cell.get(cell, &""))


func collect(cell: Vector2i) -> StringName:
	if not _remaining_by_cell.has(cell):
		return &""
	var cargo_type := StringName(_remaining_by_cell[cell])
	_remaining_by_cell.erase(cell)
	return cargo_type


func remaining_count() -> int:
	return _remaining_by_cell.size()


func remaining_cells() -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for cell: Variant in _remaining_by_cell.keys():
		result.append(cell)
	result.sort_custom(_cell_precedes)
	return result


func advance_time(_delta: float) -> void:
	pass


func reset() -> void:
	_remaining_by_cell = _authored_by_cell.duplicate()


static func _read_cell(raw: Variant) -> Variant:
	if raw is Vector2i:
		return raw
	if raw is Array and raw.size() == 2:
		if _is_integer_number(raw[0]) and _is_integer_number(raw[1]):
			return Vector2i(int(raw[0]), int(raw[1]))
	if raw is Dictionary and raw.has("x") and raw.has("y"):
		if _is_integer_number(raw.get("x")) and _is_integer_number(raw.get("y")):
			return Vector2i(int(raw["x"]), int(raw["y"]))
	return null


static func _is_integer_number(value: Variant) -> bool:
	if typeof(value) == TYPE_INT:
		return true
	if typeof(value) == TYPE_FLOAT:
		return is_finite(value) and value == floor(value)
	return false


static func _cell_precedes(first: Vector2i, second: Vector2i) -> bool:
	if first.y != second.y:
		return first.y < second.y
	return first.x < second.x
