extends RefCounted

const AlphaFixture := preload("res://tests/fixtures/finite/vs_demo_solution_alpha.gd")


static func pieces() -> Array[Variant]:
	return AlphaFixture._pieces_with_first_exit(Vector2i.UP)
