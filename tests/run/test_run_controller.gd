extends "res://tests/test_case.gd"

const RUN_CONTROLLER_PATH := "res://game/run/run_controller.gd"
const TRAIN_CONTROLLER_PATH := "res://game/train/train_controller.gd"
const GENERATOR_PATH := "res://game/rail/rail_generator.gd"
const INPUT_PATH := "res://game/input/gameplay_input_state.gd"


class FakeTrain:
	extends RefCounted

	var speed: float = 0.0
	var crossings: int = 0
	var _seconds_until_cell: float = 1.0
	var _cell_interval: float = 1.0

	func set_speed(requested_speed: float) -> void:
		speed = requested_speed

	func seconds_to_next_cell() -> float:
		return _seconds_until_cell

	func consume(delta_seconds: float) -> bool:
		_seconds_until_cell -= delta_seconds
		if _seconds_until_cell > 0.000001:
			return false
		crossings += 1
		_seconds_until_cell = _cell_interval
		return true


class FakeDeliveryLoop:
	extends RefCounted

	var _train: FakeTrain
	var _elapsed: float = 0.0
	var _event: Dictionary = {}
	var _emit_on_crossing: int = -1
	var _emitted: bool = false

	func _init(train: FakeTrain, event: Dictionary = {}, emit_on_crossing: int = -1) -> void:
		_train = train
		_event = event.duplicate(true)
		_emit_on_crossing = emit_on_crossing

	func advance_time(delta_seconds: float) -> Array[Dictionary]:
		_elapsed += delta_seconds
		var crossed := _train.consume(delta_seconds)
		if crossed and not _emitted and _train.crossings == _emit_on_crossing:
			_emitted = true
			var emitted_event := _event.duplicate(true)
			emitted_event["time"] = _elapsed
			return [emitted_event]
		return []


class FakeCargoStack:
	extends RefCounted

	var _size: int = 0

	func _init(initial_size: int = 0) -> void:
		_size = initial_size

	func size() -> int:
		return _size


func run() -> void:
	var run_controller_exists := ResourceLoader.exists(RUN_CONTROLLER_PATH, "Script")
	assert_true(run_controller_exists, "RunController script must exist")
	assert_true(ResourceLoader.exists(TRAIN_CONTROLLER_PATH, "Script"), "TrainController script must exist")
	if not ResourceLoader.exists(TRAIN_CONTROLLER_PATH, "Script"):
		return

	_test_train_boundary_and_history_seams()
	if not run_controller_exists:
		return

	var controller_script: Script = load(RUN_CONTROLLER_PATH)
	_test_no_input_finite_survival(controller_script)
	_test_pause_and_boost(controller_script)
	_test_delivery_before_fuel_zero_tie(controller_script)
	_test_difficulty_integration(controller_script)


func _test_train_boundary_and_history_seams() -> void:
	var generator: Variant = load(GENERATOR_PATH).new()
	var graph: Variant = generator.generate(17)
	var start_cell: Vector2i = graph.all_cells()[20]
	var incoming_cell: Vector2i = graph.neighbors(start_cell)[0]
	var train: Variant = load(TRAIN_CONTROLLER_PATH).new()
	train.configure(graph, start_cell, incoming_cell, 2)
	assert_true(train.has_method("seconds_to_next_cell"), "TrainController must expose seconds_to_next_cell")
	assert_true(train.has_method("route_history_cells"), "TrainController must expose a read-only route history seam")
	assert_true(train.has_method("sample_trailing_position"), "TrainController must expose fractional trailing path sampling")
	if not train.has_method("seconds_to_next_cell") or not train.has_method("route_history_cells") or not train.has_method("sample_trailing_position"):
		return

	train.set_speed(2.0)
	assert_almost_equal(train.seconds_to_next_cell(), 0.5, 0.0001, "full segment at speed two must take half a second")
	train.advance_time(0.25)
	assert_almost_equal(train.seconds_to_next_cell(), 0.25, 0.0001, "half-completed segment must expose remaining boundary time")
	assert_equal(train.sample_trailing_position(0.0), train.locomotive_position(), "zero trailing distance must sample the locomotive")
	assert_equal(train.sample_trailing_position(0.5), Vector2(start_cell), "trailing sample must reach the current cell behind a half-progress locomotive")
	assert_equal(train.sample_trailing_position(1.5), Vector2(incoming_cell), "fractional history sampling must follow the prior connected segment")

	var history: Array[Vector2i] = train.route_history_cells()
	var original_size: int = train.history_size()
	history.clear()
	assert_equal(train.history_size(), original_size, "route history seam must return a defensive copy")
	train.set_speed(0.0)
	assert_true(train.seconds_to_next_cell() > 1000000.0, "stopped train must expose an unbounded next-cell time")


func _test_no_input_finite_survival(controller_script: Script) -> void:
	var train := FakeTrain.new()
	var delivery := FakeDeliveryLoop.new(train)
	var cargo := FakeCargoStack.new(0)
	var input: Variant = load(INPUT_PATH).new()
	var controller: Variant = controller_script.new()
	controller.configure(train, delivery, cargo, input)
	var ended_summaries: Array = []
	controller.run_ended.connect(func(summary: Variant) -> void:
		ended_summaries.append(summary)
	)
	assert_true(controller.start(), "configured run must start")

	while not controller.run_state().is_ended() and controller.run_state().elapsed_seconds() < 180.0:
		controller.advance_time(10.0)

	assert_true(controller.run_state().is_ended(), "no-input run must reach fuel zero within 180 seconds")
	assert_less_equal(controller.run_state().elapsed_seconds(), 180.0, "no-input survival must remain bounded")
	assert_equal(controller.run_state().score(), 0, "no-input movement must award no score")
	assert_equal(ended_summaries.size(), 1, "fuel zero must emit one summary")
	assert_equal(ended_summaries[0].end_reason(), &"FUEL_ZERO", "fuel-zero summary must preserve reason")

	var crossings_at_end := train.crossings
	controller.advance_time(30.0)
	assert_equal(train.crossings, crossings_at_end, "ended run must not move after fuel zero")
	assert_equal(ended_summaries.size(), 1, "ended run must not emit duplicate summaries")


func _test_pause_and_boost(controller_script: Script) -> void:
	var normal_train := FakeTrain.new()
	var normal_input: Variant = load(INPUT_PATH).new()
	var normal: Variant = controller_script.new()
	normal.configure(normal_train, FakeDeliveryLoop.new(normal_train), FakeCargoStack.new(4), normal_input)
	normal.start()
	assert_true(normal.pause(), "active controller must pause")
	normal.advance_time(10.0)
	assert_almost_equal(normal.run_state().elapsed_seconds(), 0.0, 0.0001, "pause must stop run clock")
	assert_almost_equal(normal.run_state().fuel(), 65.0, 0.0001, "pause must stop fuel drain")
	assert_equal(normal_train.crossings, 0, "pause must stop train movement")
	assert_true(normal.resume(), "paused controller must resume")
	normal.advance_time(1.0)

	var boost_train := FakeTrain.new()
	var boost_input: Variant = load(INPUT_PATH).new()
	boost_input.set_load_requested(true)
	boost_input.set_boost_requested(true)
	assert_false(boost_input.is_loading(), "BOOST request must keep LOAD blocked")
	var boosted: Variant = controller_script.new()
	boosted.configure(boost_train, FakeDeliveryLoop.new(boost_train), FakeCargoStack.new(4), boost_input)
	boosted.start()
	boosted.advance_time(1.0)

	assert_true(boost_train.speed > normal_train.speed, "BOOST must increase injected train speed")
	assert_true(boosted.run_state().fuel() < normal.run_state().fuel(), "BOOST must always cost extra fuel")
	assert_almost_equal(boosted.run_metrics().boost_seconds(), 1.0, 0.0001, "BOOST time must be tracked authoritatively")


func _test_delivery_before_fuel_zero_tie(controller_script: Script) -> void:
	var train := FakeTrain.new()
	var event := {
		"cell": Vector2i.ZERO,
		"picked_up": false,
		"pickup_type": &"",
		"unloaded": true,
		"unload_result": {
			"count": 1,
			"unload_order_before": [&"RED_STAR"],
		},
	}
	var delivery := FakeDeliveryLoop.new(train, event, 1)
	var controller: Variant = controller_script.new()
	controller.configure(train, delivery, FakeCargoStack.new(0), load(INPUT_PATH).new(), 100.0, 1.0)
	controller.start()
	var events: Array = controller.advance_time(1.0)

	assert_equal(events.size(), 1, "cell boundary delivery must be returned to consumers")
	assert_equal(events[0].combo_count, 1, "Combo must equal unload_result.count")
	assert_equal(events[0].score_awarded, 100, "delivery must apply base score")
	assert_equal(events[0].fuel_awarded, 5, "delivery must apply fuel reward")
	assert_equal(controller.run_state().max_combo(), 1, "max Combo must update from the unload group")
	assert_equal(controller.run_state().score(), 100, "delivery score must update run state")
	assert_almost_equal(controller.run_state().fuel(), 5.0, 0.0001, "delivery reward must apply before equal-timestamp fuel drain")
	assert_false(controller.run_state().is_ended(), "same-timestamp delivery reward must prevent premature fuel-zero end")

	controller.advance_time(10.0)
	assert_true(controller.run_state().is_ended(), "run must still end when rewarded fuel is later exhausted")


func _test_difficulty_integration(controller_script: Script) -> void:
	var train := FakeTrain.new()
	var controller: Variant = controller_script.new()
	controller.configure(train, FakeDeliveryLoop.new(train), FakeCargoStack.new(0), load(INPUT_PATH).new(), 1000.0, 1000.0)
	controller.start()
	controller.advance_time(30.0)
	assert_equal(controller.difficulty_director().current_level(), 1, "authoritative difficulty must commit at thirty seconds")
	assert_equal(controller.difficulty_director().pressure_band(), &"CALM", "level one must preserve CALM band")
