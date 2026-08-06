extends "res://tests/test_case.gd"

const FlowScript := preload("res://game/demo/demo_flow_controller.gd")


func run() -> void:
	var flow: Control = FlowScript.new()
	assert_equal(flow.state(), &"TITLE", "demo flow must boot at TITLE")

	flow.begin_build()
	assert_equal(flow.state(), &"TITLE", "TITLE cannot skip directly to GAMEPLAY")

	flow.open_controls()
	assert_equal(flow.state(), &"CONTROLS", "controls overlay opens from TITLE")
	flow.close_controls()
	assert_equal(flow.state(), &"TITLE", "controls overlay returns to TITLE")

	flow.start_demo()
	assert_equal(flow.state(), &"BRIEFING", "start opens BRIEFING")
	flow.begin_build()
	assert_equal(flow.state(), &"GAMEPLAY", "briefing begins GAMEPLAY")

	flow.set_paused(true)
	assert_equal(flow.state(), &"PAUSED", "pause overlays GAMEPLAY")
	flow.set_paused(false)
	assert_equal(flow.state(), &"GAMEPLAY", "resume returns to GAMEPLAY")

	flow.show_result({"outcome": &"SUCCESS"})
	assert_equal(flow.state(), &"RESULT", "terminal summary opens RESULT")
	flow.start_demo()
	assert_equal(flow.state(), &"RESULT", "RESULT cannot restart without returning to title")

	flow.return_to_title()
	assert_equal(flow.state(), &"TITLE", "result returns to TITLE")
	flow.free()
