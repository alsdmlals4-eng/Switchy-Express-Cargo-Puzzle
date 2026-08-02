extends "res://tests/test_case.gd"

const CONTROLLER_PATH := "res://game/run/run_controller.gd"
const INPUT_PATH := "res://game/input/gameplay_input_state.gd"


class FakeTrain:
	extends RefCounted

	var speed: float = 0.0

	func set_speed(requested_speed: float) -> void:
		speed = requested_speed

	func seconds_to_next_cell() -> float:
		return 1000.0


class FakeDeliveryLoop:
	extends RefCounted

	func advance_time(_delta_seconds: float) -> Array[Dictionary]:
		return []


class FakeCargoStack:
	extends RefCounted

	func size() -> int:
		return 0


func run() -> void:
	var controller_exists := ResourceLoader.exists(CONTROLLER_PATH, "Script")
	assert_true(controller_exists, "RunController script must exist")
	if not controller_exists:
		return

	var controller: Variant = load(CONTROLLER_PATH).new()
	assert_true(
		controller.has_signal("difficulty_committed"),
		"RunController must forward authoritative difficulty commit events"
	)
	if not controller.has_signal("difficulty_committed"):
		return

	var committed_events: Array = []
	var observed_run_times: Array[float] = []
	controller.difficulty_committed.connect(func(event: Variant) -> void:
		committed_events.append(event)
		observed_run_times.append(controller.run_state().elapsed_seconds())
	)
	controller.configure(
		FakeTrain.new(),
		FakeDeliveryLoop.new(),
		FakeCargoStack.new(),
		load(INPUT_PATH).new(),
		1000.0,
		1000.0
	)
	controller.start()
	controller.advance_time(29.999)
	assert_equal(committed_events.size(), 0, "difficulty event must not emit before the authoritative boundary")
	controller.advance_time(0.001)
	assert_equal(committed_events.size(), 1, "difficulty boundary must emit one committed event")
	assert_equal(committed_events[0].from_level(), 0, "forwarded event must preserve previous level")
	assert_equal(committed_events[0].to_level(), 1, "forwarded event must preserve committed level")
	assert_almost_equal(committed_events[0].committed_at(), 30.0, 0.0001, "forwarded event must preserve commit timestamp")
	assert_almost_equal(observed_run_times[0], 30.0, 0.0001, "event consumers must observe the same authoritative run time as the commit")
	controller.advance_time(30.0)
	assert_equal(committed_events.size(), 2, "each later boundary must emit exactly one event")
	assert_almost_equal(observed_run_times[1], 60.0, 0.0001, "later commit signals must preserve cross-authority time consistency")
