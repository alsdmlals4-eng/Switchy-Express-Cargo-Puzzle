extends "res://tests/test_case.gd"

const DemoScene := preload("res://game/demo/vertical_slice_demo.tscn")


func run() -> void:
	var tree := Engine.get_main_loop() as SceneTree
	assert_not_null(tree, "runtime interaction surface test requires SceneTree")
	if tree == null:
		return

	var demo: Control = DemoScene.instantiate()
	tree.root.add_child(demo)
	demo.set_anchors_preset(Control.PRESET_TOP_LEFT)
	demo.position = Vector2.ZERO
	demo.size = Vector2(1280.0, 720.0)
	demo.start_demo()
	demo.begin_build()
	_force_layout(demo)

	var product := demo.get_node_or_null("GameplayContainer/ProductFiniteSlice") as Control
	var board := demo.get_node_or_null("GameplayContainer/ProductFiniteSlice/BoardRenderer") as Control
	var hud := demo.get_node_or_null("GameplayContainer/ProductFiniteSlice/HUD") as Control
	var toolbar := demo.get_node_or_null(
		"GameplayContainer/ProductFiniteSlice/HUD/BuildToolbar"
	) as Control
	var straight_button := demo.get_node_or_null(
		"GameplayContainer/ProductFiniteSlice/HUD/BuildToolbar/StraightButton"
	) as Button

	assert_not_null(product, "gameplay product root must exist")
	assert_not_null(board, "gameplay board must exist")
	assert_not_null(hud, "gameplay HUD must exist")
	assert_not_null(toolbar, "BUILD toolbar must exist")
	assert_not_null(straight_button, "straight tool button must exist")

	if product != null and hud != null:
		assert_true(hud.is_visible_in_tree(), "HUD must be visible after entering BUILD")
		assert_true(hud.size.x >= product.size.x - 1.0, "HUD must fill product width")
		assert_true(hud.size.y >= product.size.y - 1.0, "HUD must fill product height")
	if board != null and hud != null:
		assert_true(hud.z_index > board.z_index, "HUD must render above the board explicitly")
	if toolbar != null:
		assert_true(toolbar.is_visible_in_tree(), "BUILD toolbar must be visible in BUILD")
		assert_true(toolbar.get_global_rect().size.y >= 48.0, "BUILD toolbar must have an input area")
	if straight_button != null:
		assert_true(straight_button.is_visible_in_tree(), "straight tool button must be visible")
		assert_false(straight_button.disabled, "straight tool button must be enabled")

	demo.free()


func _force_layout(node: Node) -> void:
	if node is Container:
		node.notification(Container.NOTIFICATION_SORT_CHILDREN)
	for child: Node in node.get_children():
		_force_layout(child)
