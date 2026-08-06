class_name RecommendedLayoutProvider
extends RefCounted

const TrackPieceScript := preload("res://game/finite/build/track_piece.gd")


static func pieces_for_map(map_id: StringName, variant: StringName = &"ALPHA") -> Array[Variant]:
	if map_id != &"VS_DEMO_01":
		return []
	var first_exit := Vector2i.RIGHT if variant != &"BETA" else Vector2i.UP
	return _pieces_with_first_exit(first_exit)


static func _pieces_with_first_exit(first_exit: Vector2i) -> Array[Variant]:
	var specs: Array[Dictionary] = [
		{"cell": Vector2i(2, 5), "geometry": &"STRAIGHT", "rotation": 0, "exit": Vector2i.ZERO},
		{"cell": Vector2i(3, 5), "geometry": &"SWITCH", "rotation": 0, "exit": first_exit},
		{"cell": Vector2i(4, 5), "geometry": &"STRAIGHT", "rotation": 0, "exit": Vector2i.ZERO},
		{"cell": Vector2i(5, 5), "geometry": &"STRAIGHT", "rotation": 0, "exit": Vector2i.ZERO},
		{"cell": Vector2i(6, 5), "geometry": &"STRAIGHT", "rotation": 0, "exit": Vector2i.ZERO},
		{"cell": Vector2i(7, 5), "geometry": &"STRAIGHT", "rotation": 0, "exit": Vector2i.ZERO},
		{"cell": Vector2i(8, 5), "geometry": &"CROSSING", "rotation": 0, "exit": Vector2i.ZERO},
		{"cell": Vector2i(9, 5), "geometry": &"STRAIGHT", "rotation": 0, "exit": Vector2i.ZERO},
		{"cell": Vector2i(10, 5), "geometry": &"SWITCH", "rotation": 2, "exit": Vector2i.LEFT},
		{"cell": Vector2i(11, 5), "geometry": &"STRAIGHT", "rotation": 0, "exit": Vector2i.ZERO},
		{"cell": Vector2i(12, 5), "geometry": &"STRAIGHT", "rotation": 0, "exit": Vector2i.ZERO},
		{"cell": Vector2i(13, 5), "geometry": &"STRAIGHT", "rotation": 0, "exit": Vector2i.ZERO},
		{"cell": Vector2i(14, 5), "geometry": &"CURVE", "rotation": 2, "exit": Vector2i.ZERO},
		{"cell": Vector2i(14, 6), "geometry": &"STRAIGHT", "rotation": 1, "exit": Vector2i.ZERO},
		{"cell": Vector2i(14, 7), "geometry": &"STRAIGHT", "rotation": 1, "exit": Vector2i.ZERO},
		{"cell": Vector2i(14, 8), "geometry": &"STRAIGHT", "rotation": 1, "exit": Vector2i.ZERO},
		{"cell": Vector2i(14, 9), "geometry": &"CURVE", "rotation": 3, "exit": Vector2i.ZERO},
		{"cell": Vector2i(13, 9), "geometry": &"STRAIGHT", "rotation": 0, "exit": Vector2i.ZERO},
		{"cell": Vector2i(12, 9), "geometry": &"STRAIGHT", "rotation": 0, "exit": Vector2i.ZERO},
		{"cell": Vector2i(11, 9), "geometry": &"STRAIGHT", "rotation": 0, "exit": Vector2i.ZERO},
		{"cell": Vector2i(10, 9), "geometry": &"SWITCH", "rotation": 1, "exit": Vector2i.DOWN},
		{"cell": Vector2i(10, 8), "geometry": &"STRAIGHT", "rotation": 1, "exit": Vector2i.ZERO},
		{"cell": Vector2i(10, 7), "geometry": &"STRAIGHT", "rotation": 1, "exit": Vector2i.ZERO},
		{"cell": Vector2i(10, 6), "geometry": &"STRAIGHT", "rotation": 1, "exit": Vector2i.ZERO},
		{"cell": Vector2i(3, 4), "geometry": &"STRAIGHT", "rotation": 1, "exit": Vector2i.ZERO},
		{"cell": Vector2i(3, 3), "geometry": &"STRAIGHT", "rotation": 1, "exit": Vector2i.ZERO},
		{"cell": Vector2i(3, 2), "geometry": &"STRAIGHT", "rotation": 1, "exit": Vector2i.ZERO},
		{"cell": Vector2i(3, 1), "geometry": &"CURVE", "rotation": 1, "exit": Vector2i.ZERO},
		{"cell": Vector2i(4, 1), "geometry": &"STRAIGHT", "rotation": 0, "exit": Vector2i.ZERO},
		{"cell": Vector2i(5, 1), "geometry": &"STRAIGHT", "rotation": 0, "exit": Vector2i.ZERO},
		{"cell": Vector2i(6, 1), "geometry": &"STRAIGHT", "rotation": 0, "exit": Vector2i.ZERO},
		{"cell": Vector2i(7, 1), "geometry": &"STRAIGHT", "rotation": 0, "exit": Vector2i.ZERO},
		{"cell": Vector2i(8, 1), "geometry": &"CURVE", "rotation": 2, "exit": Vector2i.ZERO},
		{"cell": Vector2i(8, 2), "geometry": &"STRAIGHT", "rotation": 1, "exit": Vector2i.ZERO},
		{"cell": Vector2i(8, 3), "geometry": &"STRAIGHT", "rotation": 1, "exit": Vector2i.ZERO},
		{"cell": Vector2i(8, 4), "geometry": &"STRAIGHT", "rotation": 1, "exit": Vector2i.ZERO},
		{"cell": Vector2i(8, 6), "geometry": &"STRAIGHT", "rotation": 1, "exit": Vector2i.ZERO},
		{"cell": Vector2i(8, 7), "geometry": &"STRAIGHT", "rotation": 1, "exit": Vector2i.ZERO},
		{"cell": Vector2i(8, 8), "geometry": &"STRAIGHT", "rotation": 1, "exit": Vector2i.ZERO},
		{"cell": Vector2i(8, 9), "geometry": &"CURVE", "rotation": 0, "exit": Vector2i.ZERO},
		{"cell": Vector2i(9, 9), "geometry": &"STRAIGHT", "rotation": 0, "exit": Vector2i.ZERO},
	]
	var result: Array[Variant] = []
	for spec: Dictionary in specs:
		var piece: Variant = TrackPieceScript.create(
			spec["cell"],
			spec["geometry"],
			spec["rotation"],
			spec["exit"]
		)
		if piece == null:
			return []
		result.append(piece)
	return result
