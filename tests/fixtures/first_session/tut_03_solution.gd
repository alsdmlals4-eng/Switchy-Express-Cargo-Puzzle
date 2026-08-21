extends RefCounted

const PieceScript := preload("res://game/finite/build/track_piece.gd")


static func pieces() -> Array[Variant]:
	var result: Array[Variant] = []
	for x: int in range(2, 8):
		result.append(PieceScript.create(Vector2i(x, 2), &"STRAIGHT", 0, Vector2i.ZERO))
	return result
