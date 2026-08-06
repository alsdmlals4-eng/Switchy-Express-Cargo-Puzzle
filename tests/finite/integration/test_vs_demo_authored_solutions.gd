extends "res://tests/test_case.gd"

const LoaderScript := preload("res://game/finite/map/finite_map_loader.gd")
const BuildSessionScript := preload("res://game/finite/build/finite_build_session.gd")
const RunFactoryScript := preload("res://game/finite/run/finite_run_session_factory.gd")
const ALPHA_PATH := "res://tests/fixtures/finite/vs_demo_solution_alpha.gd"
const BETA_PATH := "res://tests/fixtures/finite/vs_demo_solution_beta.gd"
const MAP_PATH := "res://data/maps/vs_demo_01.json"


func run() -> void:
	var alpha: Dictionary = _run_solution(ALPHA_PATH)
	var beta: Dictionary = _run_solution(BETA_PATH)

	assert_true(bool(alpha.get("success", false)), "alpha authored route must complete")
	assert_true(bool(beta.get("success", false)), "beta authored route must complete")
	if not bool(alpha.get("success", false)) or not bool(beta.get("success", false)):
		return

	assert_not_equal(
		alpha["solution_identity"],
		beta["solution_identity"],
		"authored route variants must retain distinct solution identities"
	)
	assert_equal(alpha["pickup_order"], [&"RED_STAR", &"BLUE_DIAMOND", &"RED_STAR", &"RED_STAR"], "alpha pickup order")
	assert_equal(beta["pickup_order"], [&"RED_STAR", &"BLUE_DIAMOND", &"RED_STAR", &"RED_STAR"], "beta pickup order")
	assert_equal(alpha["unload_counts"], [2, 1, 1], "alpha LIFO groups")
	assert_equal(beta["unload_counts"], [2, 1, 1], "beta LIFO groups")


func _run_solution(fixture_path: String) -> Dictionary:
	var definition: Variant = LoaderScript.load_from_path(MAP_PATH)
	if definition == null:
		return {}
	var fixture: Script = load(fixture_path)
	if fixture == null:
		return {}

	var build_session: Variant = BuildSessionScript.new(definition)
	for piece: Variant in fixture.pieces():
		var placement: Variant = build_session.place_piece(piece)
		if not placement.success:
			return {}
	var preflight: Variant = build_session.begin_run()
	if preflight == null or not preflight.passed:
		return {}

	var factory: Variant = RunFactoryScript.new()
	if not factory.configure(definition, build_session.sealed_snapshot(), 2.0):
		return {}
	var result: Dictionary = factory.create_attempt(1)
	if not bool(result.get("success", false)):
		return {}

	var session: Variant = result["session"]
	var history: Array = []
	session.delivery_loop.delivery_event_created.connect(
		func(event: Variant) -> void: history.append(event)
	)
	session.input_state.toggle_auto_load()
	session.run_controller.start()
	for _step: int in range(4800):
		var phase: StringName = session.run_controller.run_state().phase()
		if phase == &"SUCCESS" or phase == &"FAILURE":
			break
		session.run_controller.advance_time(0.05)

	if session.run_controller.run_state().phase() != &"SUCCESS":
		return {}

	var pickup_order: Array[StringName] = []
	var unload_counts: Array[int] = []
	for event: Variant in history:
		if event.picked_up:
			pickup_order.append(event.pickup_type)
		if event.unload_count > 0:
			unload_counts.append(event.unload_count)

	return {
		"success": true,
		"solution_identity": session.solution_identity(),
		"pickup_order": pickup_order,
		"unload_counts": unload_counts,
	}
