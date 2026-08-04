extends RefCounted

const TrackPieceScript := preload("res://game/finite/build/track_piece.gd")


static func pieces(first_exit: Vector2i) -> Array[Variant]:
	var specs: Array[Dictionary] = [
		_spec(Vector2i(2, 4), &"STRAIGHT", 0),
		_spec(Vector2i(3, 4), &"SWITCH", 0, first_exit),
		_spec(Vector2i(4, 4), &"STRAIGHT", 0),
		_spec(Vector2i(5, 4), &"STRAIGHT", 0),
		_spec(Vector2i(6, 4), &"STRAIGHT", 0),
		_spec(Vector2i(7, 4), &"CROSSING", 0),
		_spec(Vector2i(8, 4), &"SWITCH", 2, Vector2i.LEFT),
		_spec(Vector2i(10, 4), &"CURVE", 2),
		_spec(Vector2i(8, 7), &"SWITCH", 1, Vector2i.DOWN),
		_spec(Vector2i(8, 6), &"STRAIGHT", 1),
		_spec(Vector2i(3, 3), &"STRAIGHT", 1),
		_spec(Vector2i(3, 2), &"CURVE", 1),
		_spec(Vector2i(4, 2), &"STRAIGHT", 0),
		_spec(Vector2i(5, 2), &"STRAIGHT", 0),
		_spec(Vector2i(6, 2), &"STRAIGHT", 0),
		_spec(Vector2i(7, 2), &"CURVE", 2),
		_spec(Vector2i(7, 3), &"STRAIGHT", 1),
		_spec(Vector2i(7, 5), &"STRAIGHT", 1),
		_spec(Vector2i(7, 6), &"STRAIGHT", 1),
		_spec(Vector2i(7, 7), &"STRAIGHT", 1),
		_spec(Vector2i(7, 8), &"CURVE", 0),
		_spec(Vector2i(8, 8), &"CURVE", 3),
	]
	var result: Array[Variant] = []
	for spec: Dictionary in specs:
		var piece: Variant = TrackPieceScript.create(
			spec["cell"],
			spec["geometry"],
			spec["rotation"],
			spec["initial_exit"]
		)
		if piece == null:
			return []
		result.append(piece)
	return result


static func _spec(
	cell: Vector2i,
	geometry: StringName,
	rotation: int,
	initial_exit: Vector2i = Vector2i.ZERO
) -> Dictionary:
	return {
		"cell": cell,
		"geometry": geometry,
		"rotation": rotation,
		"initial_exit": initial_exit,
	}
