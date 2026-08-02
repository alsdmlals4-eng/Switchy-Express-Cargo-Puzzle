extends "res://tests/test_case.gd"

const CONTROLLER_PATH := "res://game/run/run_controller.gd"
const INPUT_PATH := "res://game/input/gameplay_input_state.gd"


class FakeTrain:
	extends RefCounted

	var speed: float = 0.0
	var calls: int = 0

	func set_speed(requested_speed: float) -> void:
		speed = requested_speed

	func seconds_to_next_cell() -> float:
		return 1000.0


class CountingDeliveryLoop:
	extends RefCounted

	var call_count: int = 0

	func advance_time(_delta_seconds: float) -> Array[Dictionary]:
		call_count += 1
		return []


class FakeCargoStack:
	extends RefCounted

	var _size: int

	func _init(size_value: int) -> void:
		_size = size_value

	func size() -> int:
		return _size


func run() -> void:
	var controller_script: Script = load(CONTROLLER_PATH)
	_test_cargo_slowdown_does_not_discount_fuel(controller_script)
	_test_end_guard_and_assisted_summary(controller_script)


func _test_cargo_slowdown_does_not_discount_fuel(controller_script: Script) -> void:
	var empty_train := FakeTrain.new()
	var empty_controller: Variant = controller_script.new()
	empty_controller.configure(
		empty_train,
		CountingDeliveryLoop.new(),
		FakeCargoStack.new(0),
		load(INPUT_PATH).new()
	)
	empty_controller.start()
	empty_controller.advance_time(1.0)

	var loaded_train := FakeTrain.new()
	var loaded_controller: Variant = controller_script.new()
	loaded_controller.configure(
		loaded_train,
		CountingDeliveryLoop.new(),
		FakeCargoStack.new(8),
		load(INPUT_PATH).new()
	)
	loaded_controller.start()
	loaded_controller.advance_time(1.0)

	assert_true(loaded_train.speed < empty_train.speed, "eight cargo must slow movement speed")
	assert_almost_equal(
		loaded_controller.run_state().fuel(),
		empty_controller.run_state().fuel(),
		0.0001,
		"cargo slowdown must not reduce time-based fuel drain"
	)


func _test_end_guard_and_assisted_summary(controller_script: Script) -> void:
	var train := FakeTrain.new()
	var delivery := CountingDeliveryLoop.new()
	var controller: Variant = controller_script.new()
	controller.configure(
		train,
		delivery,
		FakeCargoStack.new(0),
		load(INPUT_PATH).new(),
		100.0,
		0.25,
		true
	)
	controller.start()
	controller.advance_time(1.0)
	assert_true(controller.run_state().is_ended(), "fuel exhaustion must end the run")
	assert_true(controller.summary().is_assisted(), "summary must preserve assisted-run identity")
	var calls_at_end: int = delivery.call_count
	var metrics_at_end: int = controller.run_metrics().delivery_count()
	var events_after_end: Array = controller.advance_time(10.0)
	assert_equal(events_after_end.size(), 0, "ended run must return no later pickup or unload events")
	assert_equal(delivery.call_count, calls_at_end, "ended run must not call DeliveryLoop again")
	assert_equal(controller.run_metrics().delivery_count(), metrics_at_end, "ended run must not mutate delivery metrics")
