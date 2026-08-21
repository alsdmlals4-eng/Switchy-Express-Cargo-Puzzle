extends RefCounted

const PieceScript := preload("res://game/finite/build/track_piece.gd")


static func pieces() -> Array[Variant]:
	return [
		PieceScript.create(Vector2i(2, 3), &"STRAIGHT", 0, Vector2i.ZERO),
		PieceScript.create(Vector2i(3, 3), &"SWITCH", 0, Vector2i.UP),
		PieceScript.create(Vector2i(3, 2), &"STRAIGHT", 1, Vector2i.ZERO),
		PieceScript.create(Vector2i(3, 1), &"STRAIGHT", 1, Vector2i.ZERO),
		PieceScript.create(Vector2i(4, 3), &"STRAIGHT", 0, Vector2i.ZERO),
		PieceScript.create(Vector2i(5, 3), &"STRAIGHT", 0, Vector2i.ZERO),
		PieceScript.create(Vector2i(6, 3), &"STRAIGHT", 0, Vector2i.ZERO),
	]
