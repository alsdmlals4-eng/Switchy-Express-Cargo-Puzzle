extends RefCounted

const Common := preload("res://tests/fixtures/finite/fp_core_solution_common.gd")


static func pieces() -> Array[Variant]:
	return Common.pieces(Vector2i.RIGHT)
