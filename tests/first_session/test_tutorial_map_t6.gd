extends "res://tests/test_case.gd"

const LoaderScript := preload("res://game/finite/map/finite_map_loader.gd")
const BuildSessionScript := preload("res://game/finite/build/finite_build_session.gd")
const FactoryScript := preload("res://game/finite/run/finite_run_session_factory.gd")
const Solution := preload("res://tests/fixtures/first_session/tut_06_solution_driver.gd")

const SWITCH_CELL := Vector2i(3, 3)


func run() -> void:
	var definition: Variant = LoaderScript.load_from_path(
		"res://data/maps/tutorial/tut_06_switch.json"
	)
	assert_not_null(definition, "T6 map must load")
	if definition == null:
		return
	var build: Variant = BuildSessionScript.new(definition)
	for piece: Variant in Solution.pieces():
		var placement: Variant = build.place_piece(piece)
		assert_true(placement.success, "T6 fixture piece must place")
	var preflight: Variant = build.begin_run()
	assert_true(preflight != null and preflight.passed, "T6 fixture passes preflight")
	if preflight == null or not preflight.passed:
		return

	var factory: Variant = FactoryScript.new()
	assert_true(factory.configure(definition, build.sealed_snapshot(), 3.0), "T6 factory configures")
	var attempt: Dictionary = factory.create_attempt(1)
	assert_true(bool(attempt.get("success", false)), "T6 attempt creates")
	if not bool(attempt.get("success", false)):
		return
	var session: Variant = attempt["session"]
	var states: Array = session.graph.route_control_states()
	assert_equal(states.size(), 1, "T6 introduces one player route control")
	assert_equal(states[0].get("kind"), &"SWITCH", "T6 control is a switch")
	assert_equal(states[0].get("selected_exit"), Vector2i.UP, "T6 starts on the non-delivery branch")
	assert_true(session.graph.select_switch_exit(SWITCH_CELL, Vector2i.RIGHT), "preselection changes route")
	assert_equal(
		session.graph.next_cell(SWITCH_CELL, SWITCH_CELL + Vector2i.LEFT),
		SWITCH_CELL + Vector2i.RIGHT,
		"selected exit changes next route"
	)

	session.input_state.set_manual_load_active(true)
	session.run_controller.start()
	var lock_observed := false
	for _step: int in range(2000):
		var phase: StringName = session.run_controller.run_state().phase()
		if phase == &"SUCCESS" or phase == &"FAILURE":
			break
		if session.train.current_cell() == SWITCH_CELL:
			lock_observed = true
			assert_false(
				session.graph.select_switch_exit(SWITCH_CELL, Vector2i.UP),
				"occupied switch rejects route change"
			)
		session.run_controller.advance_time(0.05)
	assert_true(lock_observed, "train occupancy lock is observed")
	assert_equal(session.run_controller.run_state().phase(), &"SUCCESS", "legal preselection succeeds")
	assert_equal(
		session.graph.route_control_states()[0].get("selected_exit"),
		Vector2i.RIGHT,
		"switch selection persists and never auto-resets"
	)
