extends "res://tests/test_case.gd"

const PRODUCT_SCENE_PATH := "res://game/demo/product_finite_slice.tscn"


func run() -> void:
	var packed: PackedScene = load(PRODUCT_SCENE_PATH)
	assert_not_null(packed, "product finite slice scene must load")
	if packed == null:
		return

	var product: Control = packed.instantiate()
	var tree := Engine.get_main_loop() as SceneTree
	assert_not_null(tree, "product command test requires SceneTree")
	if tree == null:
		product.free()
		return
	tree.root.add_child(product)

	assert_true(product.has_method("session_controller"), "product slice exposes shared controller")
	assert_true(product.has_method("dispatch_action_for_test"), "product slice exposes desktop action test seam")
	assert_true(product.has_method("request_command_for_test"), "product slice exposes command test seam")
	if not product.has_method("session_controller"):
		product.free()
		return

	var controller: RefCounted = product.session_controller()
	assert_true(controller.domain_ready(), "product slice initializes the demo map")
	assert_equal(controller.render_snapshot()["map_id"], &"VS_DEMO_01", "product slice uses demo map")

	var hud := product.get_node("HUD")
	var renderer := product.get_node("BoardRenderer") as Control
	assert_not_null(hud, "product slice owns product HUD")
	assert_not_null(renderer, "product slice owns product board renderer")

	hud.get_node("BuildToolbar/StraightButton").pressed.emit()
	assert_equal(controller.last_command(), &"BUILD_TOOL", "HUD uses finite command path")
	assert_equal(controller.last_payload(), &"STRAIGHT", "HUD preserves geometry payload")

	renderer.set_anchors_preset(Control.PRESET_TOP_LEFT)
	renderer.position = Vector2.ZERO
	renderer.size = Vector2(1100.0, 900.0)
	renderer.request_primary_at(Vector2(550.0, 450.0))
	assert_equal(controller.last_command(), &"BOARD_CELL", "mouse/touch board path uses finite command")
	assert_equal(controller.last_payload(), Vector2i(5, 4), "board path preserves mapped cell")

	var result: Dictionary = product.dispatch_action_for_test(&"demo_tool_curve", true)
	assert_true(bool(result.get("accepted", false)), "desktop curve action must be accepted")
	assert_equal(controller.last_command(), &"BUILD_TOOL", "desktop adapter uses finite command path")
	assert_equal(controller.last_payload(), &"CURVE", "desktop adapter preserves geometry")

	product.request_command_for_test(&"CANCEL_SELECTION")
	assert_equal(controller.last_command(), &"CANCEL_SELECTION", "cancel uses controller command path")
	assert_equal(controller.render_snapshot()["selected_cell"], Vector2i(-1, -1), "cancel clears selected cell")

	product.free()
