class_name TrackPiece
extends RefCounted

const SELF_SCRIPT_PATH := "res://game/finite/build/track_piece.gd"
const VALID_GEOMETRIES: Array[StringName] = [
	&"STRAIGHT",
	&"CURVE",
	&"SWITCH",
	&"CROSSING",
]

var cell: Vector2i = Vector2i.ZERO
var geometry: StringName = &""
var rotation_quarters: int = 0
var switch_initial_exit: Vector2i = Vector2i.ZERO


static func create(
	piece_cell: Vector2i,
	piece_geometry: StringName,
	piece_rotation_quarters: int,
	piece_switch_initial_exit: Vector2i
) -> Variant:
	if not VALID_GEOMETRIES.has(piece_geometry):
		return null
	if piece_rotation_quarters < 0 or piece_rotation_quarters > 3:
		return null

	var canonical_rotation := piece_rotation_quarters
	if piece_geometry == &"STRAIGHT":
		canonical_rotation %= 2
	elif piece_geometry == &"CROSSING":
		canonical_rotation = 0

	var value: Variant = load(SELF_SCRIPT_PATH).new()
	value.cell = piece_cell
	value.geometry = piece_geometry
	value.rotation_quarters = canonical_rotation
	value.switch_initial_exit = Vector2i.ZERO

	if piece_geometry == &"SWITCH":
		var valid_exits: Array[Vector2i] = value.switch_exits()
		if not valid_exits.has(piece_switch_initial_exit):
			return null
		value.switch_initial_exit = piece_switch_initial_exit
	elif piece_switch_initial_exit != Vector2i.ZERO:
		return null

	return value


func ports() -> Array[Vector2i]:
	match geometry:
		&"STRAIGHT":
			return _rotated_ports([Vector2i.LEFT, Vector2i.RIGHT])
		&"CURVE":
			return _rotated_ports([Vector2i.UP, Vector2i.RIGHT])
		&"SWITCH":
			return [approach_port()] + switch_exits()
		&"CROSSING":
			return [Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT]
		_:
			return []


func approach_port() -> Vector2i:
	if geometry != &"SWITCH":
		return Vector2i.ZERO
	return _rotate_clockwise(Vector2i.LEFT, rotation_quarters)


func switch_exits() -> Array[Vector2i]:
	if geometry != &"SWITCH":
		return []
	return _rotated_ports([Vector2i.RIGHT, Vector2i.UP])


func build_cost() -> int:
	match geometry:
		&"STRAIGHT", &"CURVE":
			return 100
		&"SWITCH", &"CROSSING":
			return 200
		_:
			return 0


func canonical_string() -> String:
	return "%d,%d:%s:%d:%d,%d" % [
		cell.x,
		cell.y,
		str(geometry),
		rotation_quarters,
		switch_initial_exit.x,
		switch_initial_exit.y,
	]


func duplicate_piece() -> Variant:
	return create(cell, geometry, rotation_quarters, switch_initial_exit)


func _rotated_ports(base_ports: Array[Vector2i]) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for port: Vector2i in base_ports:
		result.append(_rotate_clockwise(port, rotation_quarters))
	return result


static func _rotate_clockwise(direction: Vector2i, quarter_turns: int) -> Vector2i:
	var result := direction
	for _index: int in range(quarter_turns):
		result = Vector2i(-result.y, result.x)
	return result
