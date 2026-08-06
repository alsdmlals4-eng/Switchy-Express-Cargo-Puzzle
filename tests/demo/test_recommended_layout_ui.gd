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

	var tree := Engine.get_main_loop() as SceneTree
	assert_not_null(tree, "recommended layout UI test requires SceneTree")
	if tree == null:
		return
	var product: Control = PRODUCT_SCENE.instantiate()
	tree.root.add_child(product)
	assert_true(product.has_method("apply_recommended_layout"), "product slice exposes recommended layout application")
	var controller: RefCounted = product.session_controller()
	var recommend_button := product.get_node("HUD/BuildToolbar/RecommendButton") as Button
	recommend_button.pressed.emit()
	assert_true(bool(controller.model().get("start_enabled", false)), "button installs a startable route")
	assert_true(controller.model().get("problem_cells", []).is_empty(), "button clears all red route warnings")
	assert_true(controller.render_snapshot().get("layout_pieces", []).size() >= 30, "button installs the complete route")
	product.free()
