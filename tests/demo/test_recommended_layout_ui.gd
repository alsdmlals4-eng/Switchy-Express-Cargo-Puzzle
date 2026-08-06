extends "res://tests/test_case.gd"

const HUD_SCENE := preload("res://game/demo/presentation/product_hud.tscn")
const PRODUCT_SCENE := preload("res://game/demo/product_finite_slice.tscn")


func run() -> void:
	var hud: Control = HUD_SCENE.instantiate()
	assert_true(hud.has_signal("recommended_layout_requested"), "HUD must expose recommended layout action")
	assert_true(hud.has_node("BuildToolbar/RecommendButton"), "build toolbar must include recommended layout button")
	if hud.has_node("BuildToolbar/RecommendButton"):
		assert_equal(
			(hud.get_node("BuildToolbar/RecommendButton") as Button).text,
			"권장 배치",
			"recommended button uses direct Korean wording"
		)
	hud.free()

	var product: Control = PRODUCT_SCENE.instantiate()
	assert_true(product.has_method("apply_recommended_layout"), "product slice must expose recommended layout application")
	product.free()
