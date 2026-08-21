extends "res://tests/test_case.gd"

const MainScene := preload("res://game/main/main.tscn")
const SummaryScript := preload("res://game/finite/run/finite_run_summary.gd")
const T12 := preload("res://tests/fixtures/first_session/tut_01_02_solution.gd")


func run() -> void:
	var tree := Engine.get_main_loop() as SceneTree
	var main: Control = MainScene.instantiate()
	tree.root.add_child(main)
	var flow := main.get_node("VerticalSliceDemo")
	flow.start_demo()
	flow.begin_build()
	var summary: Variant = SummaryScript.new(
		&"FAILURE", 18.0, -1.0, 90.0, 2, 1, &"ROUTE_END"
	)
	flow.show_result(summary)
	var body: String = (flow.get_node("ResultOverlay/Panel/Content/Body") as Label).text
	assert_true(body.contains("노선이 끝났습니다."), "result explains route end from summary truth")
	assert_true(body.contains("맵에 남은 화물: 2"), "result shows remaining map cargo")
	assert_true(body.contains("열차에 실린 화물: 1"), "result shows stack cargo")
	var lowered := body.to_lower()
	for forbidden: String in ["optimal", "recommended", "solution", "red_star", "blue_diamond"]:
		assert_false(lowered.contains(forbidden), "result must not invent %s" % forbidden)
	main.free()

	var retry_main: Control = MainScene.instantiate()
	tree.root.add_child(retry_main)
	var retry_flow := retry_main.get_node("VerticalSliceDemo")
	retry_flow.start_demo()
	retry_flow.begin_build()
	var product: Control = retry_flow.gameplay_instance()
	assert_true(product.install_layout_for_test(T12.pieces()), "T1 proof layout installs")
	assert_equal(retry_flow.current_lesson_id_for_test(), &"T2", "preflight opens T2")
	retry_flow.begin_build()
	product.request_command_for_test(&"START")
	for _step: int in range(3000):
		if retry_flow.state() == &"RESULT":
			break
		product.advance_time(0.05)
	assert_equal(retry_flow.state(), &"RESULT", "missing T2 pickup must reach failure result")
	var edit := retry_flow.get_node("ResultOverlay/Panel/Content/EditButton") as Button
	assert_false(edit.visible, "fixed-layout T2 failure must not offer a non-functional edit action")
	assert_true(
		retry_flow.dispatch_flow_action_for_test(&"demo_confirm", true),
		"confirm must invoke first-session retry",
	)
	assert_equal(retry_flow.state(), &"GAMEPLAY", "retry returns to gameplay")
	assert_equal(
		product.session_controller().phase(),
		&"RUNNING",
		"retry must create and start a fresh attempt with the same sealed layout",
	)
	retry_main.free()
