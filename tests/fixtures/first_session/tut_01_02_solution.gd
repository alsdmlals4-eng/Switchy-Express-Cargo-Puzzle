extends RefCounted

const PieceScript := preload("res://game/finite/build/track_piece.gd")


static func pieces() -> Array[Variant]:
	return [
		PieceScript.create(Vector2i(2, 2), &"STRAIGHT", 0, Vector2i.ZERO),
		PieceScript.create(Vector2i(3, 2), &"STRAIGHT", 0, Vector2i.ZERO),
		PieceScript.create(Vector2i(4, 2), &"CURVE", 2, Vector2i.ZERO),
		PieceScript.create(Vector2i(4, 3), &"CURVE", 0, Vector2i.ZERO),
		PieceScript.create(Vector2i(5, 3), &"STRAIGHT", 0, Vector2i.ZERO),
	]
