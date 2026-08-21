class_name FirstSessionStarterLayouts
extends RefCounted

const PieceScript := preload("res://game/finite/build/track_piece.gd")


static func pieces(layout_id: StringName) -> Array[Variant]:
	if layout_id != &"TUT_04" and layout_id != &"TUT_05":
		return []
	return [
		_piece(2, 4, &"STRAIGHT", 0),
		_piece(3, 4, &"STRAIGHT", 0),
		_piece(4, 4, &"CROSSING", 0),
		_piece(5, 4, &"STRAIGHT", 0),
		_piece(6, 4, &"STRAIGHT", 0),
		_piece(7, 4, &"STRAIGHT", 0),
		_piece(8, 4, &"CURVE", 3),
		_piece(8, 3, &"STRAIGHT", 1),
		_piece(8, 2, &"CURVE", 2),
		_piece(7, 2, &"STRAIGHT", 0),
		_piece(6, 2, &"STRAIGHT", 0),
		_piece(5, 2, &"STRAIGHT", 0),
		_piece(4, 2, &"CURVE", 1),
		_piece(4, 3, &"STRAIGHT", 1),
		_piece(4, 5, &"STRAIGHT", 1),
		_piece(4, 6, &"STRAIGHT", 1),
		_piece(4, 7, &"CURVE", 0),
		_piece(5, 7, &"STRAIGHT", 0),
		_piece(6, 7, &"STRAIGHT", 0),
		_piece(7, 7, &"STRAIGHT", 0),
	]


static func _piece(x: int, y: int, geometry: StringName, rotation: int) -> Variant:
	return PieceScript.create(Vector2i(x, y), geometry, rotation, Vector2i.ZERO)
