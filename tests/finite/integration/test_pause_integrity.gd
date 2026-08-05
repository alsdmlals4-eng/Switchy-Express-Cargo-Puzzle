extends "res://tests/test_case.gd"

const FACTORY_PATH := "res://game/finite/run/finite_run_session_factory.gd"
const FIXTURE_PATH := "res://tests/fixtures/finite/finite_retry_fixture.gd"


func run() -> void:
	var fixture_script: Script = load(FIXTURE_PATH)
	var inputs: Dictionary = fixture_script.sealed_inputs()
	assert_false(inputs.is_empty(), "pause integrity fixture must produce sealed inputs")
	if inputs.is_empty():
		return

	var factory_script: Script = load(FACTORY_PATH)
	var factory: Variant = factory_script.new()
	assert_true(factory.configure(inputs["definition"], inputs["sealed"], 2.0), "pause integrity factory must configure")
	var result: Dictionary = factory.create_attempt(1)
	assert_true(result["success"], "pause integrity attempt must be created")
	if not result["success"]:
		return
	var session: Variant = result["session"]
	assert_true(session.input_state.toggle_auto_load(), "pause fixture must enable auto load")
	assert_true(session.run_controller.start(), "pause fixture must start")

	session.run_controller.advance_time(0.75)
	var phase_before: StringName = session.run_controller.run_state().phase()
	var elapsed_before: float = session.run_controller.run_state().elapsed_seconds()
	var cell_before: Vector2i = session.train.current_cell()
	var target_before: Vector2i = session.train.target_cell()
	var progress_before: float = session.train.movement_progress()
	var stack_before: Array[StringName] = session.cargo_stack.load_order()
	var cargo_before: int = session.cargo_field.remaining_count()

	assert_true(session.run_controller.pause(), "running finite attempt must pause")
	for _repeat: int in range(5):
		session.run_controller.advance_time(2.0)
	assert_equal(session.run_controller.run_state().phase(), &"PAUSED", "repeated paused advancement must remain PAUSED")
	assert_almost_equal(session.run_controller.run_state().elapsed_seconds(), elapsed_before, 0.000001, "pause must freeze the finite clock")
	assert_equal(session.train.current_cell(), cell_before, "pause must freeze current train cell")
	assert_equal(session.train.target_cell(), target_before, "pause must preserve locked target cell")
	assert_almost_equal(session.train.movement_progress(), progress_before, 0.000001, "pause must freeze train interpolation")
	assert_equal(session.cargo_stack.load_order(), stack_before, "pause must not mutate LIFO stack")
	assert_equal(session.cargo_field.remaining_count(), cargo_before, "pause must not collect cargo")
	assert_false(session.input_state.should_load_on_contact(), "pause must suppress contact loading")
	assert_false(session.input_state.toggle_auto_load(), "pause must reject auto-mode changes")

	assert_true(session.run_controller.resume(), "paused finite attempt must resume")
	assert_equal(session.run_controller.run_state().phase(), phase_before, "resume must restore the prior runtime phase")
	assert_true(session.input_state.should_load_on_contact(), "resume must restore active auto loading")

	for _step: int in range(4000):
		var phase: StringName = session.run_controller.run_state().phase()
		if phase == &"SUCCESS" or phase == &"FAILURE":
			break
		session.run_controller.advance_time(0.05)
	assert_equal(session.run_controller.run_state().phase(), &"SUCCESS", "pause/resume must not prevent successful completion")
