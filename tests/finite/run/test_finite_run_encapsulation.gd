extends "res://tests/test_case.gd"

const CONTROLLER_PATH := "res://game/finite/run/finite_run_controller.gd"
const EVENT_PATH := "res://game/finite/delivery/finite_delivery_event.gd"
const INPUT_PATH := "res://game/finite/input/finite_gameplay_input_state.gd"
const A: StringName = &"RED_STAR"


class FakeTrain:
	extends RefCounted

	signal cell_entered(cell: Vector2i)

	var speed: float = 0.0

	func set_speed(value: float) -> void:
		speed = value

	func advance_time(_delta_seconds: float) -> int:
		return 0

	func seconds_to_next_cell() -> float:
		return INF

	func can_advance() -> bool:
		return true


class FakeDeliveryLoop:
	extends RefCounted

	func handle_cell_entered(_cell: Vector2i, _event_time: float) -> Variant:
		return null


func run() -> void:
	var controller_script: Script = load(CONTROLLER_PATH)
	var event_script: Script = load(EVENT_PATH)
	var input_script: Script = load(INPUT_PATH)
	var controller: Variant = controller_script.new()
	controller.configure(FakeTrain.new(), FakeDeliveryLoop.new(), input_script.new(), 90.0, 2.0)
	assert_true(controller.start(), "encapsulation fixture must start")

	var items: Array[StringName] = [A, A]
	var event: Variant = event_script.new(Vector2i(8, 1), 10.0, false, &"", items, true, 0, 0)
	assert_true(controller.accept_delivery_event(event), "encapsulation fixture must begin unloading")
	var internal_remaining_before: float = controller.unload_sequence().remaining_seconds()
	var exposed_sequence: Variant = controller.unload_sequence()
	exposed_sequence.advance_time(internal_remaining_before)
	assert_almost_equal(
		controller.unload_sequence().remaining_seconds(),
		internal_remaining_before,
		0.000001,
		"external sequence access must not mutate controller-owned unload progress"
	)

	controller.advance_time(internal_remaining_before)
	var summary: Variant = controller.summary()
	assert_not_null(summary, "completed final unload must freeze summary")
	var original_outcome: StringName = summary.outcome
	var original_failure_reason: StringName = summary.failure_reason
	var original_completion: float = summary.completion_time
	summary.outcome = &"FAILURE"
	summary.failure_reason = &"ROUTE_END"
	summary.completion_time = 999.0
	assert_equal(summary.outcome, original_outcome, "summary outcome must remain immutable")
	assert_equal(summary.failure_reason, original_failure_reason, "summary failure reason must remain immutable")
	assert_almost_equal(summary.completion_time, original_completion, 0.000001, "summary timing must remain immutable")

	var state_controller: Variant = controller_script.new()
	state_controller.configure(FakeTrain.new(), FakeDeliveryLoop.new(), input_script.new(), 90.0, 2.0)
	assert_true(state_controller.start(), "state snapshot fixture must start")
	var exposed_state: Variant = state_controller.run_state()
	assert_true(exposed_state.fail(), "exposed state copy may be mutated independently")
	assert_equal(
		state_controller.run_state().phase(),
		&"RUNNING",
		"external run-state access must not mutate controller-owned phase"
	)
