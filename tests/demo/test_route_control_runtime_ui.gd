extends "res://tests/test_case.gd"

const PRODUCT_SCENE := preload("res://game/demo/product_finite_slice.tscn")
const OverlayScript := preload("res://game/demo/presentation/route_control_overlay.gd")
const Palette := preload("res://game/demo/presentation/demo_palette.gd")
const CROSSING_CELL := Vector2i(8, 5)
const SWITCH_CELL := Vector2i(1, 1)


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

	var semantic_overlay: Control = OverlayScript.new()
	semantic_overlay.size = Vector2(600.0, 360.0)
	semantic_overlay.apply_snapshot(_switch_snapshot(false, Vector2i.RIGHT))
	var targets_before: Array[Dictionary] = semantic_overlay.direction_targets_for_test()
	assert_equal(targets_before.size(), 3, "semantic proof switch keeps exactly three procedural targets")
	assert_true(semantic_overlay.has_method("semantic_target_descriptors_for_test"), "route overlay must expose bounded semantic target diagnostics")
	if semantic_overlay.has_method("semantic_target_descriptors_for_test"):
		var semantic_targets: Array[Dictionary] = semantic_overlay.semantic_target_descriptors_for_test()
		assert_equal(semantic_targets.size(), targets_before.size(), "semantic target count cannot change direction geometry")
		var selected_semantic := _semantic_target_for(semantic_targets, Vector2i.RIGHT)
		var unselected_semantic := _semantic_target_for(semantic_targets, Vector2i.UP)
		assert_equal(selected_semantic.get("semantic_state", &""), &"selected", "selected direction resolves selected semantic state")
		assert_equal(
			selected_semantic.get("input_paths", []),
			["art/product_assets/ed_hybrid_v1/run/run_switch_state_selected_overlay_v01.png"],
			"selected direction uses exact approved RUN overlay"
		)
		assert_equal(unselected_semantic.get("semantic_state", &""), &"unselected", "other direction resolves unselected semantic state")
		assert_equal(
			unselected_semantic.get("input_paths", []),
			["art/product_assets/ed_hybrid_v1/run/run_switch_state_unselected_overlay_v01.png"],
			"unselected direction uses exact approved RUN overlay"
		)
	assert_equal(
		semantic_overlay.direction_targets_for_test(),
		targets_before,
		"semantic lookup must leave cell/port/selected/locked/cycle_count/hit_rect deeply unchanged"
	)

	semantic_overlay.apply_snapshot(_switch_snapshot(true, Vector2i.RIGHT))
	assert_equal(
		OverlayScript.crossing_visual_color_for_test({"locked": true}),
		Palette.ROUTE_LOCKED,
		"locked crossing must use the same red semantic state as a locked switch"
	)
	assert_equal(
		OverlayScript.crossing_visual_color_for_test({"locked": false}),
		Palette.SELECTED,
		"unlocked crossing must retain its selected-state color"
	)
	var locked_before: Array[Dictionary] = semantic_overlay.direction_targets_for_test()
	if semantic_overlay.has_method("semantic_target_descriptors_for_test"):
		var locked_semantic: Array[Dictionary] = semantic_overlay.semantic_target_descriptors_for_test()
		for target: Dictionary in locked_semantic:
			assert_equal(target.get("semantic_state", &""), &"occupied_locked", "locked target state outranks selected/unselected")
			assert_equal(
				target.get("input_paths", []),
				["art/product_assets/ed_hybrid_v1/run/run_switch_state_occupied_locked_overlay_v01.png"],
				"occupied lock resolves exact approved RUN overlay"
			)
	assert_equal(semantic_overlay.direction_targets_for_test(), locked_before, "locked semantic lookup cannot alter target geometry")

	semantic_overlay.free()
	product.free()


static func _switch_snapshot(locked: bool, selected: Vector2i) -> Dictionary:
	return {
		"phase": &"RUNNING",
		"board_size": Vector2i(3, 3),
		"route_controls": [{
			"cell": SWITCH_CELL,
			"kind": &"SWITCH",
			"available_exits": [Vector2i.UP, Vector2i.RIGHT, Vector2i.LEFT],
			"selected_exit": selected,
			"locked": locked,
		}],
	}


static func _semantic_target_for(targets: Array[Dictionary], port: Vector2i) -> Dictionary:
	for target: Dictionary in targets:
		if target.get("port") == port:
			return target
	return {}


static func _route_state(states: Array, cell: Vector2i) -> Dictionary:
	for value: Variant in states:
		if value is Dictionary and value.get("cell") == cell:
			return value
	return {}
