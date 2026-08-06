extends "res://tests/test_case.gd"

const DemoScene := preload("res://game/demo/vertical_slice_demo.tscn")


func run() -> void:
	var tree := Engine.get_main_loop() as SceneTree
	assert_not_null(tree, "flow keyboard test requires SceneTree")
	if tree == null:
		return

	var demo: Control = DemoScene.instantiate()
	tree.root.add_child(demo)
	assert_true(
		demo.has_method("dispatch_flow_action_for_test"),
		"Demo Shell exposes a deterministic flow input seam"
	)
	if not demo.has_method("dispatch_flow_action_for_test"):
		demo.free()
		return

	assert_true(demo.dispatch_flow_action_for_test(&"demo_confirm", true), "Enter is accepted on TITLE")
	assert_equal(demo.state(), &"BRIEFING", "Enter starts the briefing")
	assert_true(demo.dispatch_flow_action_for_test(&"demo_cancel", true), "Esc is accepted on BRIEFING")
	assert_equal(demo.state(), &"TITLE", "Esc returns briefing to title")

	demo.open_controls()
	assert_equal(demo.state(), &"CONTROLS", "controls overlay opens")
	assert_true(demo.dispatch_flow_action_for_test(&"demo_cancel", true), "Esc closes controls")
	assert_equal(demo.state(), &"TITLE", "controls return to title")

	demo.start_demo()
	assert_true(demo.dispatch_flow_action_for_test(&"demo_confirm", true), "Enter confirms briefing")
	assert_equal(demo.state(), &"GAMEPLAY", "Enter begins gameplay")
	assert_false(
		demo.dispatch_flow_action_for_test(&"demo_confirm", false),
		"key release does not trigger a second flow action"
	)

	demo.free()
