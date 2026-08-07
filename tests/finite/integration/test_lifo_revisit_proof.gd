extends "res://tests/test_case.gd"

const FACTORY_PATH := "res://game/finite/run/finite_run_session_factory.gd"
const FIXTURE_PATH := "res://tests/fixtures/finite/finite_retry_fixture.gd"
const SwitchDriver := preload("res://tests/fixtures/finite/three_direction_switch_driver.gd")
const A: StringName = &"RED_STAR"
const B: StringName = &"BLUE_DIAMOND"


func run() -> void:
	var fixture_script: Script = load(FIXTURE_PATH)
	var inputs: Dictionary = fixture_script.sealed_inputs()
	assert_false(inputs.is_empty(), "LIFO revisit fixture must produce sealed inputs")
	if inputs.is_empty():
		return

	var factory_script: Script = load(FACTORY_PATH)
	var factory: Variant = factory_script.new()
	assert_true(factory.configure(inputs["definition"], inputs["sealed"], 2.0), "LIFO proof factory must configure")
	var result: Dictionary = factory.create_attempt(1)
	assert_true(result["success"], "LIFO proof attempt must be created")
	if not result["success"]:
		return
	var session: Variant = result["session"]
	assert_true(session.delivery_loop.has_signal("delivery_event_created"), "delivery loop must expose one immutable observation signal")
	if not session.delivery_loop.has_signal("delivery_event_created"):
		return

	var history: Array = []
	session.delivery_loop.delivery_event_created.connect(func(event: Variant) -> void: history.append(event))
	assert_true(session.input_state.toggle_auto_load(), "LIFO proof must enable auto load")
	assert_true(session.run_controller.start(), "LIFO proof controller must start")
	var branch_targets := SwitchDriver.capture_branch_targets(session.graph)

	for _step: int in range(4000):
		var phase: StringName = session.run_controller.run_state().phase()
		if phase == &"SUCCESS" or phase == &"FAILURE":
			break
		SwitchDriver.prepare_next_switch(session, branch_targets)
		session.run_controller.advance_time(0.05)

	assert_equal(session.run_controller.run_state().phase(), &"SUCCESS", "actual finite runtime must complete the proof route with explicit switch destinations")
	var pickup_order: Array[StringName] = []
	var station_cells: Array[Vector2i] = []
	var unload_counts: Array[int] = []
	var stack_sizes_after: Array[int] = []
	for event: Variant in history:
		if event.picked_up:
			pickup_order.append(event.pickup_type)
		if event.unload_count > 0:
			station_cells.append(event.cell)
			unload_counts.append(event.unload_count)
			stack_sizes_after.append(event.stack_size)

	assert_equal(pickup_order, [A, B, A, A], "actual runtime pickup order must remain A/B/A/A")
	assert_equal(unload_counts, [2, 1, 1], "actual runtime must prove LIFO 2→1→1 groups")
	assert_equal(stack_sizes_after, [2, 1, 0], "stack must shrink 4→2→1→0")
	assert_equal(station_cells.size(), 3, "proof must contain three unloading visits")
	if station_cells.size() >= 3:
		assert_equal(station_cells[0], station_cells[2], "A station must be revisited after B unload")
		assert_not_equal(station_cells[0], station_cells[1], "middle unload must occur at B station")
