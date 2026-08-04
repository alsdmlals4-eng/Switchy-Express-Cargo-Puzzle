extends "res://tests/test_case.gd"

const STATE_PATH := "res://game/finite/run/finite_run_state.gd"


func run() -> void:
	var state_exists := ResourceLoader.exists(STATE_PATH, "Script")
	assert_true(state_exists, "finite run state must exist")
	if not state_exists:
		return

	var state_script: Script = load(STATE_PATH)
	var state: Variant = state_script.new(90.0)
	assert_equal(state.phase(), &"READY", "new finite run must begin READY")
	assert_almost_equal(state.elapsed_seconds(), 0.0, 0.000001, "new finite clock must begin at zero")
	assert_almost_equal(state.time_limit_seconds(), 90.0, 0.000001, "time limit must be retained")
	assert_false(state.pause(), "READY must reject pause")
	assert_false(state.resume(), "READY must reject resume")
	assert_false(state.begin_unloading(), "READY must reject unloading")
	assert_false(state.succeed(), "READY must reject success")
	assert_false(state.fail(), "READY must reject failure")

	assert_true(state.start(), "READY must start")
	assert_equal(state.phase(), &"RUNNING", "start must enter RUNNING")
	state.advance_clock(2.5)
	assert_almost_equal(state.elapsed_seconds(), 2.5, 0.000001, "RUNNING must advance the clock")

	assert_true(state.pause(), "RUNNING must pause")
	assert_equal(state.phase(), &"PAUSED", "pause must enter PAUSED")
	state.advance_clock(10.0)
	assert_almost_equal(state.elapsed_seconds(), 2.5, 0.000001, "PAUSED must freeze the clock")
	assert_true(state.resume(), "PAUSED must resume")
	assert_equal(state.phase(), &"RUNNING", "RUNNING pause must resume to RUNNING")

	assert_true(state.begin_unloading(), "RUNNING must enter UNLOADING")
	assert_equal(state.phase(), &"UNLOADING", "matching station must enter UNLOADING")
	assert_true(state.pause(), "UNLOADING must pause")
	assert_true(state.resume(), "paused unload must resume")
	assert_equal(state.phase(), &"UNLOADING", "paused unload must resume to UNLOADING")
	state.advance_clock(0.25)
	assert_almost_equal(state.elapsed_seconds(), 2.75, 0.000001, "UNLOADING must advance the clock")
	assert_true(state.finish_unloading(), "non-final unload must return to running")
	assert_equal(state.phase(), &"RUNNING", "finished non-final unload must enter RUNNING")

	assert_true(state.begin_unloading(), "RUNNING must begin another unload")
	assert_true(state.succeed(), "UNLOADING may finish SUCCESS")
	assert_equal(state.phase(), &"SUCCESS", "success must be terminal")
	var terminal_elapsed: float = state.elapsed_seconds()
	assert_false(state.start(), "SUCCESS must reject restart")
	assert_false(state.pause(), "SUCCESS must reject pause")
	assert_false(state.resume(), "SUCCESS must reject resume")
	assert_false(state.begin_unloading(), "SUCCESS must reject unloading")
	assert_false(state.finish_unloading(), "SUCCESS must reject unload finish")
	assert_false(state.fail(), "SUCCESS must reject failure mutation")
	state.advance_clock(10.0)
	assert_almost_equal(state.elapsed_seconds(), terminal_elapsed, 0.000001, "SUCCESS must freeze the clock")

	var failed: Variant = state_script.new(90.0)
	assert_true(failed.start(), "second state must start")
	assert_true(failed.fail(), "RUNNING may fail")
	assert_equal(failed.phase(), &"FAILURE", "failure must be terminal")
	assert_false(failed.succeed(), "FAILURE must reject success mutation")
