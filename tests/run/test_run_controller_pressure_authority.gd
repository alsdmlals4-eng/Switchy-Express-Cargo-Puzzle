extends "res://tests/test_case.gd"

const CONTROLLER_PATH := "res://game/run/run_controller.gd"
const INPUT_PATH := "res://game/input/gameplay_input_state.gd"
const BALANCE_PATH := "res://game/run/run_balance.gd"


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

	var _size: int

	func _init(size: int = 0) -> void:
		_size = size

	func size() -> int:
		return _size


func run() -> void:
	var controller: Variant = load(CONTROLLER_PATH).new()
	var train := FakeTrain.new()
	controller.configure(
		train,
		FakeDeliveryLoop.new(),
		FakeCargoStack.new(4),
		load(INPUT_PATH).new(),
		1000.0,
		1000.0
	)
	controller.difficulty_director().reset(10.0, 20.0, 2.0)
	assert_true(controller.start(), "pressure authority fixture must start")

	var balance: Variant = load(BALANCE_PATH).new()
	assert_almost_equal(
		train.speed,
		balance.effective_speed_for_pressure(4, 0, false),
		0.0001,
		"initial motion must consume zero pressure snapshot"
	)
	controller.advance_time(10.0)
	assert_equal(controller.difficulty_director().current_snapshot().speed_step(), 1, "director commits injected speed boundary")
	assert_almost_equal(
		train.speed,
		balance.effective_speed_for_pressure(4, 1, false),
		0.0001,
		"controller speed must follow director snapshot instead of elapsed thirty-second wrapper"
	)

	var fuel_at_ten: float = controller.run_state().fuel()
	controller.advance_time(10.0)
	assert_equal(controller.difficulty_director().current_snapshot().speed_step(), 2, "combined boundary advances speed")
	assert_equal(controller.difficulty_director().current_snapshot().fuel_step(), 1, "combined boundary advances fuel")
	assert_almost_equal(
		train.speed,
		balance.effective_speed_for_pressure(4, 2, false),
		0.0001,
		"combined snapshot must drive speed"
	)
	assert_almost_equal(
		fuel_at_ten - controller.run_state().fuel(),
		10.0 * balance.effective_fuel_rate_for_pressure(4, 0, false),
		0.0001,
		"fuel step commits at boundary and must not retroactively affect prior interval"
	)

	controller.advance_time(1.0)
	assert_almost_equal(
		1000.0 - controller.run_state().fuel(),
		20.0 * balance.effective_fuel_rate_for_pressure(4, 0, false)
		+ balance.effective_fuel_rate_for_pressure(4, 1, false),
		0.0001,
		"post-boundary fuel drain must consume committed fuel snapshot"
	)

	assert_true(controller.pause(), "controller must pause")
	var director_time: float = controller.difficulty_director().elapsed_seconds()
	var fuel_before_pause: float = controller.run_state().fuel()
	controller.advance_time(100.0)
	assert_almost_equal(controller.difficulty_director().elapsed_seconds(), director_time, 0.0001, "pause must freeze difficulty authority")
	assert_almost_equal(controller.run_state().fuel(), fuel_before_pause, 0.0001, "pause must freeze pressure consumption")
	assert_true(controller.resume(), "controller must resume")
