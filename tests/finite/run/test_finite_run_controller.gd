extends "res://tests/test_case.gd"

const CONTROLLER_PATH := "res://game/finite/run/finite_run_controller.gd"
const SUMMARY_PATH := "res://game/finite/run/finite_run_summary.gd"
const EVENT_PATH := "res://game/finite/delivery/finite_delivery_event.gd"
const INPUT_PATH := "res://game/finite/input/finite_gameplay_input_state.gd"

const A: StringName = &"RED_STAR"


class FakeTrain:
	extends RefCounted

	signal cell_entered(cell: Vector2i)

	var speed: float = 0.0
	var advanced_seconds: float = 0.0

	func set_speed(value: float) -> void:
		speed = value

	func advance_time(delta_seconds: float) -> int:
		advanced_seconds += maxf(delta_seconds, 0.0)
		return 0

	func seconds_to_next_cell() -> float:
		return INF


class FakeDeliveryLoop:
	extends RefCounted

	func handle_cell_entered(_cell: Vector2i, _event_time: float) -> Variant:
		return null


func run() -> void:
	var required: Array[String] = [CONTROLLER_PATH, SUMMARY_PATH]
	for path: String in required:
		assert_true(ResourceLoader.exists(path, "Script"), "%s must exist" % path)
	if not _all_exist(required):
		return

	var controller_script: Script = load(CONTROLLER_PATH)
	var event_script: Script = load(EVENT_PATH)
	var input_script: Script = load(INPUT_PATH)

	var base: Dictionary = _configured(controller_script, input_script)
	var controller: Variant = base["controller"]
	var train: FakeTrain = base["train"]
	assert_true(controller.start(), "configured controller must start")
	assert_equal(controller.run_state().phase(), &"RUNNING", "start must enter RUNNING")
	assert_almost_equal(train.speed, 2.0, 0.000001, "start must apply base train speed")
	var no_items: Array[StringName] = []
	var mismatch: Variant = event_script.new(Vector2i(9, 1), 10.0, false, &"", no_items, false, 1, 0)
	assert_false(controller.accept_delivery_event(mismatch), "mismatched station event must not begin unloading")
	assert_equal(controller.run_state().phase(), &"RUNNING", "mismatch must remain RUNNING")
	assert_almost_equal(train.speed, 2.0, 0.000001, "mismatch must not change train speed")

	var timeout_case: Dictionary = _configured(controller_script, input_script)
	var timeout_controller: Variant = timeout_case["controller"]
	assert_true(timeout_controller.start(), "timeout controller must start")
	timeout_controller.advance_time(90.0)
	assert_equal(timeout_controller.run_state().phase(), &"FAILURE", "time expiry with unfinished cargo must fail")
	assert_equal(timeout_controller.summary().outcome, &"FAILURE", "timeout summary must record failure")
	assert_almost_equal(timeout_controller.summary().completion_time, 90.0, 0.000001, "timeout must commit at the exact limit")

	_assert_final_delivery_case(controller_script, event_script, input_script, 89.999, &"SUCCESS")
	_assert_final_delivery_case(controller_script, event_script, input_script, 90.0, &"SUCCESS")
	_assert_final_delivery_case(controller_script, event_script, input_script, 90.001, &"FAILURE")

	var paused_case: Dictionary = _configured(controller_script, input_script)
	var paused_controller: Variant = paused_case["controller"]
	var paused_input: Variant = paused_case["input"]
	assert_true(paused_controller.start(), "pause case must start")
	var two_items: Array[StringName] = [A, A]
	var final_event: Variant = event_script.new(Vector2i(8, 1), 10.0, false, &"", two_items, true, 0, 0)
	assert_true(paused_controller.accept_delivery_event(final_event), "matching final event must begin unload")
	assert_equal(paused_controller.run_state().phase(), &"UNLOADING", "matching event must enter UNLOADING")
	assert_true(paused_controller.pause(), "UNLOADING must pause")
	assert_true(paused_input.is_paused(), "controller pause must pause finite input")
	var elapsed_before: float = paused_controller.run_state().elapsed_seconds()
	var remaining_before: float = paused_controller.unload_sequence().remaining_seconds()
	paused_controller.advance_time(5.0)
	assert_almost_equal(paused_controller.run_state().elapsed_seconds(), elapsed_before, 0.000001, "pause must freeze finite clock")
	assert_almost_equal(paused_controller.unload_sequence().remaining_seconds(), remaining_before, 0.000001, "pause must freeze unload animation")
	assert_true(paused_controller.resume(), "paused unload must resume")
	assert_false(paused_input.is_paused(), "resume must restore finite input")
	paused_controller.advance_time(remaining_before)
	assert_equal(paused_controller.run_state().phase(), &"SUCCESS", "resumed final unload must finish success")

	var non_final_case: Dictionary = _configured(controller_script, input_script)
	var non_final_controller: Variant = non_final_case["controller"]
	var non_final_train: FakeTrain = non_final_case["train"]
	assert_true(non_final_controller.start(), "non-final case must start")
	var one_item: Array[StringName] = [A]
	var non_final_event: Variant = event_script.new(Vector2i(8, 1), 5.0, false, &"", one_item, true, 1, 0)
	assert_true(non_final_controller.accept_delivery_event(non_final_event), "non-final match must begin unload")
	non_final_controller.advance_time(0.12)
	assert_equal(non_final_controller.run_state().phase(), &"RUNNING", "non-final unload must resume running")
	assert_almost_equal(non_final_train.speed, 2.0, 0.000001, "non-final unload must restore base speed")
	assert_equal(non_final_controller.summary(), null, "non-final unload must not freeze summary")


func _assert_final_delivery_case(
	controller_script: Script,
	event_script: Script,
	input_script: Script,
	commit_time: float,
	expected_outcome: StringName
) -> void:
	var case: Dictionary = _configured(controller_script, input_script)
	var controller: Variant = case["controller"]
	var train: FakeTrain = case["train"]
	assert_true(controller.start(), "final delivery case must start")
	var item: Array[StringName] = [A]
	var event: Variant = event_script.new(Vector2i(8, 1), commit_time, false, &"", item, true, 0, 0)
	assert_true(controller.accept_delivery_event(event), "final matching event must be accepted")
	assert_equal(controller.run_state().phase(), &"UNLOADING", "final commit must wait in UNLOADING")
	assert_almost_equal(train.speed, 0.0, 0.000001, "unloading must stop the train")
	assert_almost_equal(controller.final_delivery_commit_time(), commit_time, 0.000001, "final commit timestamp must be retained")
	assert_equal(controller.summary(), null, "summary must wait for unload animation")
	controller.advance_time(0.12)
	assert_equal(controller.run_state().phase(), expected_outcome, "final animation must resolve timestamp eligibility")
	var summary: Variant = controller.summary()
	assert_not_null(summary, "terminal outcome must freeze a summary")
	assert_equal(summary.outcome, expected_outcome, "summary outcome must match exact-limit rule")
	assert_almost_equal(summary.final_delivery_commit_time, commit_time, 0.000001, "summary must retain commit timestamp")
	assert_almost_equal(summary.time_limit_seconds, 90.0, 0.000001, "summary must retain limit")
	assert_true(summary.completion_time >= commit_time, "presentation completion may follow domain commit")
	assert_false("fuel" in summary, "finite summary must not expose fuel")
	assert_false("score" in summary, "finite summary must not expose endless score")
	assert_false("boost_seconds" in summary, "finite summary must not expose BOOST")


func _configured(controller_script: Script, input_script: Script) -> Dictionary:
	var train := FakeTrain.new()
	var input: Variant = input_script.new()
	var controller: Variant = controller_script.new()
	controller.configure(train, FakeDeliveryLoop.new(), input, 90.0, 2.0)
	return {"controller": controller, "train": train, "input": input}


func _all_exist(paths: Array[String]) -> bool:
	for path: String in paths:
		if not ResourceLoader.exists(path, "Script"):
			return false
	return true
