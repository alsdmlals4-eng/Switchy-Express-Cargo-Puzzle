extends "res://tests/test_case.gd"

const PRODUCT_SCENE := preload("res://game/demo/product_finite_slice.tscn")
const CROSSING_CELL := Vector2i(8, 5)


func run() -> void:
	var tree := Engine.get_main_loop() as SceneTree
	assert_not_null(tree, "route control UI test requires SceneTree")
	if tree == null:
		return

	var product: Control = PRODUCT_SCENE.instantiate()
	tree.root.add_child(product)
	assert_true(product.apply_recommended_layout(), "recommended route must install before runtime control test")
	var controller: RefCounted = product.session_controller()
	product.request_command_for_test(&"START")
	assert_equal(controller.phase(), &"RUNNING", "route control test requires an active run")
	if controller.phase() != &"RUNNING":
		product.free()
		return

	var session: Variant = controller.active_run_session_for_test()
	assert_not_null(session, "active run session must be exposed")
	if session == null:
		product.free()
		return
	assert_equal(
		session.graph.next_cell(CROSSING_CELL, Vector2i(7, 5)),
		Vector2i(9, 5),
		"crossing begins in straight mode"
	)

	product.request_command_for_test(&"BOARD_CELL", CROSSING_CELL)
	assert_equal(
		session.graph.next_cell(CROSSING_CELL, Vector2i(7, 5)),
		Vector2i(8, 6),
		"first runtime click changes the crossing to the right turn"
	)
	var right_state: Dictionary = _route_state(
		controller.render_snapshot().get("route_controls", []),
		CROSSING_CELL
	)
	assert_equal(right_state.get("mode"), &"RIGHT", "snapshot exposes the clicked right-turn state")
	var overlay: Control = product.get_node("RouteControlOverlay")
	var overlay_state: Dictionary = _route_state(
		overlay.snapshot_for_test().get("route_controls", []),
		CROSSING_CELL
	)
	assert_equal(overlay_state.get("mode"), &"RIGHT", "visible overlay receives the right-turn state")

	product.request_command_for_test(&"BOARD_CELL", CROSSING_CELL)
	assert_equal(
		session.graph.next_cell(CROSSING_CELL, Vector2i(7, 5)),
		Vector2i(8, 4),
		"second runtime click changes the crossing to the left turn"
	)
	var left_state: Dictionary = _route_state(
		controller.render_snapshot().get("route_controls", []),
		CROSSING_CELL
	)
	assert_equal(left_state.get("mode"), &"LEFT", "snapshot exposes the clicked left-turn state")
	product.free()


static func _route_state(states: Array, cell: Vector2i) -> Dictionary:
	for value: Variant in states:
		if value is Dictionary and value.get("cell") == cell:
			return value
	return {}
