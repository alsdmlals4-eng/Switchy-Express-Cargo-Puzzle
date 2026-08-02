class_name RunController
extends RefCounted

signal run_ended(summary: Variant)
signal difficulty_committed(event: Variant)

const RunBalanceScript := preload("res://game/run/run_balance.gd")
const RunStateScript := preload("res://game/run/run_state.gd")
const RunMetricsAccumulatorScript := preload("res://game/run/run_metrics_accumulator.gd")
const DifficultyDirectorScript := preload("res://game/difficulty/difficulty_director.gd")

const MAX_SIMULATION_STEP_SECONDS := 0.25
const TIME_EPSILON := 0.000001
const FUEL_EPSILON := 0.000001

var _train: Variant
var _delivery_loop: Variant
var _cargo_stack: Variant
var _input_state: Variant
var _balance: Variant
var _run_state: Variant
var _run_metrics: Variant
var _difficulty_director: Variant
var _assisted: bool = false
var _summary: Variant


func configure(
	train: Variant,
	delivery_loop: Variant,
	cargo_stack: Variant,
	input_state: Variant,
	fuel_maximum: float = RunBalanceScript.FUEL_MAX,
	starting_fuel: float = RunBalanceScript.FUEL_START,
	assisted: bool = false
) -> void:
	assert(train != null, "RunController requires a train")
	assert(delivery_loop != null, "RunController requires a delivery loop")
	assert(cargo_stack != null, "RunController requires a cargo stack")
	assert(input_state != null, "RunController requires gameplay input")
	assert(train.has_method("seconds_to_next_cell"), "train must expose seconds_to_next_cell")

	_train = train
	_delivery_loop = delivery_loop
	_cargo_stack = cargo_stack
	_input_state = input_state
	_assisted = assisted
	_balance = RunBalanceScript.new()
	_run_state = RunStateScript.new()
	_run_metrics = RunMetricsAccumulatorScript.new()
	_difficulty_director = DifficultyDirectorScript.new()
	_run_state.reset(fuel_maximum, starting_fuel)
	_run_metrics.reset()
	_difficulty_director.reset()
	_summary = null


func start() -> bool:
	assert(_run_state != null, "RunController must be configured before start")
	return _run_state.start()


func pause() -> bool:
	assert(_run_state != null, "RunController must be configured before pause")
	return _run_state.pause()


func resume() -> bool:
	assert(_run_state != null, "RunController must be configured before resume")
	return _run_state.resume()


func advance_time(delta_seconds: float) -> Array[Dictionary]:
	assert(_run_state != null, "RunController must be configured before advancing")
	var emitted_events: Array[Dictionary] = []
	if delta_seconds <= 0.0 or not _run_state.is_active():
		return emitted_events

	var remaining_time := delta_seconds
	while remaining_time > TIME_EPSILON and _run_state.is_active():
		var boosting: bool = _input_state.is_boosting()
		var cargo_count: int = int(_cargo_stack.size())
		var elapsed_before: float = _run_state.elapsed_seconds()
		var speed: float = _balance.current_speed(elapsed_before, cargo_count, boosting)
		var fuel_drain_rate: float = _balance.fuel_drain_rate(elapsed_before, boosting)
		_train.set_speed(speed)

		var segment_seconds := _segment_duration(remaining_time, fuel_drain_rate)
		if segment_seconds <= TIME_EPSILON:
			_finish_if_fuel_empty()
			break

		var segment_events: Array[Dictionary] = _delivery_loop.advance_time(segment_seconds)
		for raw_event: Dictionary in segment_events:
			var applied_event := _apply_delivery_event(raw_event, segment_seconds)
			emitted_events.append(applied_event)

		var difficulty_events: Array = _difficulty_director.advance(segment_seconds)
		for difficulty_event: Variant in difficulty_events:
			difficulty_committed.emit(difficulty_event)

		_run_state.advance_clock(segment_seconds)
		if boosting:
			_run_metrics.record_boost_time(segment_seconds)
		_run_state.apply_fuel_delta(-fuel_drain_rate * segment_seconds)
		remaining_time = maxf(remaining_time - segment_seconds, 0.0)
		_finish_if_fuel_empty()

	return emitted_events


func run_state() -> Variant:
	return _run_state


func run_metrics() -> Variant:
	return _run_metrics


func difficulty_director() -> Variant:
	return _difficulty_director


func summary() -> Variant:
	return _summary


func _segment_duration(remaining_time: float, fuel_drain_rate: float) -> float:
	var segment_seconds := minf(remaining_time, MAX_SIMULATION_STEP_SECONDS)
	segment_seconds = minf(segment_seconds, float(_train.seconds_to_next_cell()))
	segment_seconds = minf(segment_seconds, _difficulty_director.seconds_to_next_boundary())
	if fuel_drain_rate > FUEL_EPSILON:
		segment_seconds = minf(segment_seconds, _run_state.fuel() / fuel_drain_rate)
	return maxf(segment_seconds, 0.0)


func _apply_delivery_event(raw_event: Dictionary, segment_seconds: float) -> Dictionary:
	var event := raw_event.duplicate(true)
	event["combo_count"] = 0
	event["score_awarded"] = 0
	event["fuel_awarded"] = 0
	event["speed_bonus_applied"] = false
	event["heavy_bonus_applied"] = false

	if bool(event.get("picked_up", false)):
		_run_metrics.record_pickup()

	if not bool(event.get("unloaded", false)):
		return event

	var unload_result: Dictionary = event.get("unload_result", {})
	var combo_count := int(unload_result.get("count", 0))
	if combo_count <= 0:
		return event

	var event_time := float(event.get("time", _run_state.elapsed_seconds() + segment_seconds))
	var seconds_since_delivery: float = _run_metrics.seconds_since_last_delivery(event_time)
	var unload_order_before: Array = unload_result.get("unload_order_before", [])
	var cargo_count_before_unload := unload_order_before.size()
	var score_awarded: int = _balance.delivery_score(
		combo_count,
		seconds_since_delivery,
		cargo_count_before_unload
	)
	var fuel_awarded: int = _balance.unload_fuel_reward(combo_count)

	_run_state.apply_delivery(combo_count, score_awarded, fuel_awarded)
	_run_metrics.record_delivery(
		combo_count,
		score_awarded,
		fuel_awarded,
		event_time
	)

	event["combo_count"] = combo_count
	event["score_awarded"] = score_awarded
	event["fuel_awarded"] = fuel_awarded
	event["speed_bonus_applied"] = _balance.speed_bonus_multiplier(seconds_since_delivery) > 1.0
	event["heavy_bonus_applied"] = _balance.heavy_bonus_multiplier(cargo_count_before_unload) > 1.0
	return event


func _finish_if_fuel_empty() -> void:
	if not _run_state.is_active() or _run_state.fuel() > FUEL_EPSILON:
		return
	if not _run_state.end_once(&"FUEL_ZERO"):
		return
	_summary = _run_state.freeze_summary(
		_run_metrics,
		_difficulty_director.current_level(),
		_assisted
	)
	run_ended.emit(_summary)
