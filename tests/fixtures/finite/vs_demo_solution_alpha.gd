extends RefCounted

const ProviderScript := preload("res://game/demo/recommended_layout_provider.gd")


static func pieces() -> Array[Variant]:
	return ProviderScript.pieces_for_map(&"VS_DEMO_01", &"ALPHA")


static func _pieces_with_first_exit(first_exit: Vector2i) -> Array[Variant]:
	return ProviderScript.pieces_for_map(
		&"VS_DEMO_01",
		&"ALPHA" if first_exit == Vector2i.RIGHT else &"BETA"
	)
