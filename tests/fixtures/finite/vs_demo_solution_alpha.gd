extends RefCounted

const TrackPieceScript := preload("res://game/finite/build/track_piece.gd")


static func pieces() -> Array[Variant]:
	return _pieces_with_first_exit(Vector2i.RIGHT)


static func _pieces_with_first_exit(first_exit: Vector2i) -> Array[Variant]:
	var specs: Array[Dictionary] = [
		{"cell": Vector2i(2, 4), "geometry": &"STRAIGHT", "rotation": 0, "exit": Vector2i.ZERO},
		{"cell": Vector2i(3, 4), "geometry": &"SWITCH", "rotation": 0, "exit": first_exit},
		{"cell": Vector2i(4, 4), "geometry": &"STRAIGHT", "rotation": 0, "exit": Vector2i.ZERO},
		{"cell": Vector2i(5, 4), "geometry": &"STRAIGHT", "rotation": 0, "exit": Vector2i.ZERO},
		{"cell": Vector2i(6, 4), "geometry": &"STRAIGHT", "rotation": 0, "exit": Vector2i.ZERO},
		{"cell": Vector2i(7, 4), "geometry": &"CROSSING", "rotation": 0, "exit": Vector2i.ZERO},
		{"cell": Vector2i(8, 4), "geometry": &"SWITCH", "rotation": 2, "exit": Vector2i.LEFT},
		{"cell": Vector2i(9, 4), "geometry": &"STRAIGHT", "rotation": 0, "exit": Vector2i.ZERO},
		{"cell": Vector2i(10, 4), "geometry": &"CURVE", "rotation": 2, "exit": Vector2i.ZERO},
		{"cell": Vector2i(10, 5), "geometry": &"STRAIGHT", "rotation": 1, "exit": Vector2i.ZERO},
		{"cell": Vector2i(10, 6), "geometry": &"STRAIGHT", "rotation": 1, "exit": Vector2i.ZERO},
		{"cell": Vector2i(10, 7), "geometry": &"CURVE", "rotation": 3, "exit": Vector2i.ZERO},
		{"cell": Vector2i(9, 7), "geometry": &"STRAIGHT", "rotation": 0, "exit": Vector2i.ZERO},
		{"cell": Vector2i(8, 7), "geometry": &"SWITCH", "rotation": 1, "exit": Vector2i.DOWN},
		{"cell": Vector2i(8, 6), "geometry": &"STRAIGHT", "rotation": 1, "exit": Vector2i.ZERO},
		{"cell": Vector2i(8, 5), "geometry": &"STRAIGHT", "rotation": 1, "exit": Vector2i.ZERO},
		{"cell": Vector2i(3, 3), "geometry": &"STRAIGHT", "rotation": 1, "exit": Vector2i.ZERO},
		{"cell": Vector2i(3, 2), "geometry": &"CURVE", "rotation": 1, "exit": Vector2i.ZERO},
		{"cell": Vector2i(4, 2), "geometry": &"STRAIGHT", "rotation": 0, "exit": Vector2i.ZERO},
		{"cell": Vector2i(5, 2), "geometry": &"STRAIGHT", "rotation": 0, "exit": Vector2i.ZERO},
		{"cell": Vector2i(6, 2), "geometry": &"STRAIGHT", "rotation": 0, "exit": Vector2i.ZERO},
		{"cell": Vector2i(7, 2), "geometry": &"CURVE", "rotation": 2, "exit": Vector2i.ZERO},
		{"cell": Vector2i(7, 3), "geometry": &"STRAIGHT", "rotation": 1, "exit": Vector2i.ZERO},
		{"cell": Vector2i(7, 5), "geometry": &"STRAIGHT", "rotation": 1, "exit": Vector2i.ZERO},
		{"cell": Vector2i(7, 6), "geometry": &"STRAIGHT", "rotation": 1, "exit": Vector2i.ZERO},
		{"cell": Vector2i(7, 7), "geometry": &"STRAIGHT", "rotation": 1, "exit": Vector2i.ZERO},
		{"cell": Vector2i(7, 8), "geometry": &"CURVE", "rotation": 0, "exit": Vector2i.ZERO},
		{"cell": Vector2i(8, 8), "geometry": &"CURVE", "rotation": 3, "exit": Vector2i.ZERO},
	]
	var result: Array[Variant] = []
	for spec: Dictionary in specs:
		var piece: Variant = TrackPieceScript.create(
			spec["cell"], spec["geometry"], spec["rotation"], spec["exit"]
		)
		if piece == null:
			return []
		result.append(piece)
	return result
