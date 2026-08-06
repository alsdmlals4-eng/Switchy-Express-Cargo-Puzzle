extends RefCounted

const ProviderScript := preload("res://game/demo/recommended_layout_provider.gd")


static func pieces() -> Array[Variant]:
	return ProviderScript.pieces_for_map(&"VS_DEMO_01", &"BETA")
