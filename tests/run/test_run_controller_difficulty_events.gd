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
	var on_difficulty_committed := func(event: Variant) -> void:
		committed_events.append(event)
		observed_run_times.append(controller.run_state().elapsed_seconds())
	controller.difficulty_committed.connect(on_difficulty_committed)
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
	assert_equal(committed_events.size(), 1, "speed boundary must emit one committed event")
	assert_equal(committed_events[0].changed_axes(), [&"SPEED"], "first event changes speed")
	assert_equal(committed_events[0].from_level(), 0, "forwarded event must preserve previous speed level")
	assert_equal(committed_events[0].to_level(), 1, "forwarded event must preserve committed speed level")
	assert_almost_equal(committed_events[0].committed_at(), 30.0, 0.0001, "forwarded event must preserve commit timestamp")
	assert_almost_equal(observed_run_times[0], 30.0, 0.0001, "event consumers must observe the same authoritative run time as the commit")

	controller.advance_time(30.0)
	assert_equal(committed_events.size(), 3, "thirty additional seconds must emit fuel45 and speed60")
	assert_equal(committed_events[1].changed_axes(), [&"FUEL"], "45-second event changes fuel")
	assert_almost_equal(committed_events[1].committed_at(), 45.0, 0.0001, "fuel event timestamp")
	assert_almost_equal(observed_run_times[1], 45.0, 0.0001, "fuel commit signal must preserve cross-authority time consistency")
	assert_equal(committed_events[2].changed_axes(), [&"SPEED"], "60-second event changes speed")
	assert_almost_equal(committed_events[2].committed_at(), 60.0, 0.0001, "speed event timestamp")
	assert_almost_equal(observed_run_times[2], 60.0, 0.0001, "later speed commit signal must preserve cross-authority time consistency")

	controller.advance_time(30.0)
	assert_equal(committed_events.size(), 4, "ninety seconds must add one combined event")
	assert_equal(committed_events[3].changed_axes(), [&"SPEED", &"FUEL"], "90-second event must combine axes")
	assert_almost_equal(committed_events[3].committed_at(), 90.0, 0.0001, "combined event timestamp")
	assert_almost_equal(observed_run_times[3], 90.0, 0.0001, "combined commit signal must preserve cross-authority time consistency")
	controller.difficulty_committed.disconnect(on_difficulty_committed)
