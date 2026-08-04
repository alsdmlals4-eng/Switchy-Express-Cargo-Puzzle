class_name FiniteRunController
extends RefCounted

const FiniteRunStateScript := preload("res://game/finite/run/finite_run_state.gd")
const UnloadSequenceScript := preload("res://game/finite/run/unload_sequence.gd")
const FiniteRunSummaryScript := preload("res://game/finite/run/finite_run_summary.gd")

const SUCCESS: StringName = &"SUCCESS"
const FAILURE: StringName = &"FAILURE"
const TIME_EPSILON := 0.000001

var _train: Variant
var _delivery_loop: Variant
var _input_state: Variant
var _run_state: Variant
var _base_speed: float = 0.0
var _unload_sequence: Variant
var _pending_outcome: StringName = &""
var _final_delivery_commit_time: float = -1.0
var _summary: Variant
var _remaining_map_cargo: int = 1
var _stack_size: int = 0


func configure(
	train: Variant,
	delivery_loop: Variant,
	input_state: Variant,
	time_limit_seconds: float,
	base_speed: float = 1.0,
	initial_remaining_map_cargo: int = 1
) -> void:
	assert(train != null, "FiniteRunController requires a train")
	assert(delivery_loop != null, "FiniteRunController requires a delivery loop")
	assert(input_state != null, "FiniteRunController requires finite gameplay input")
	assert(train.has_method("set_speed"), "finite train must expose set_speed")
	assert(train.has_method("advance_time"), "finite train must expose advance_time")
	assert(train.has_method("seconds_to_next_cell"), "finite train must expose seconds_to_next_cell")

	_train = train
	_delivery_loop = delivery_loop
	_input_state = input_state
	_base_speed = maxf(base_speed, 0.0)
	_run_state = FiniteRunStateScript.new(time_limit_seconds)
	_unload_sequence = null
	_pending_outcome = &""
	_final_delivery_commit_time = -1.0
	_summary = null
	_remaining_map_cargo = maxi(initial_remaining_map_cargo, 0)
	_stack_size = 0

	var entered_callable: Callable = Callable(self, "_on_train_cell_entered")
	if _train.has_signal("cell_entered") and not _train.is_connected("cell_entered", entered_callable):
		_train.connect("cell_entered", entered_callable)


func start() -> bool:
	assert(_run_state != null, "FiniteRunController must be configured before start")
	if not _run_state.start():
		return false
	_input_state.set_paused(false)
	_train.set_speed(_base_speed)
	return true


func pause() -> bool:
	assert(_run_state != null, "FiniteRunController must be configured before pause")
	if not _run_state.pause():
		return false
	_input_state.set_paused(true)
	_train.set_speed(0.0)
	return true


func resume() -> bool:
	assert(_run_state != null, "FiniteRunController must be configured before resume")
	if not _run_state.resume():
		return false
	_input_state.set_paused(false)
	_train.set_speed(_base_speed if _run_state.phase() == &"RUNNING" else 0.0)
	return true


func advance_time(delta_seconds: float) -> Array[StringName]:
	assert(_run_state != null, "FiniteRunController must be configured before advancing")
	var emitted_items: Array[StringName] = []
	if delta_seconds <= 0.0:
		return emitted_items
	if _run_state.phase() == &"READY" or _run_state.phase() == &"PAUSED" or _run_state.is_terminal():
		return emitted_items

	var remaining: float = delta_seconds
	while remaining > TIME_EPSILON and not _run_state.is_terminal():
		if _run_state.phase() == &"RUNNING":
			var until_limit: float = float(_run_state.time_limit_seconds()) - float(_run_state.elapsed_seconds())
			if until_limit <= TIME_EPSILON:
				_finish_terminal(FAILURE)
				break

			var segment: float = minf(remaining, until_limit)
			var until_cell: float = float(_train.seconds_to_next_cell())
			if is_finite(until_cell) and until_cell > TIME_EPSILON:
				segment = minf(segment, until_cell)
			if segment <= TIME_EPSILON:
				_finish_terminal(FAILURE)
				break

			_run_state.advance_clock(segment)
			_train.advance_time(segment)
			remaining = maxf(remaining - segment, 0.0)

			if (
				_run_state.phase() == &"RUNNING"
				and _run_state.elapsed_seconds() >= _run_state.time_limit_seconds() - TIME_EPSILON
			):
				_finish_terminal(FAILURE)
		elif _run_state.phase() == &"UNLOADING":
			if _unload_sequence == null:
				_resolve_unload_completion()
				continue

			var unload_segment: float = minf(remaining, float(_unload_sequence.remaining_seconds()))
			if _pending_outcome == &"":
				var unload_until_limit: float = (
					float(_run_state.time_limit_seconds()) - float(_run_state.elapsed_seconds())
				)
				if unload_until_limit <= TIME_EPSILON:
					_finish_terminal(FAILURE)
					break
				unload_segment = minf(unload_segment, unload_until_limit)

			if unload_segment <= TIME_EPSILON:
				_resolve_unload_completion()
				continue
			_run_state.advance_clock(unload_segment)
			emitted_items.append_array(_unload_sequence.advance_time(unload_segment))
			remaining = maxf(remaining - unload_segment, 0.0)

			if (
				_pending_outcome == &""
				and _run_state.elapsed_seconds() >= _run_state.time_limit_seconds() - TIME_EPSILON
			):
				_finish_terminal(FAILURE)
			elif _unload_sequence.is_complete():
				_resolve_unload_completion()
		else:
			break

	return emitted_items


func accept_delivery_event(event: Variant) -> bool:
	if event == null or _run_state == null or _run_state.phase() != &"RUNNING":
		return false
	_run_state.synchronize_elapsed(float(event.event_time))
	_remaining_map_cargo = maxi(int(event.remaining_map_cargo), 0)
	_stack_size = maxi(int(event.stack_size), 0)
	if int(event.unload_count) <= 0:
		return false

	var unloaded_items: Array[StringName] = event.unloaded_items
	_unload_sequence = UnloadSequenceScript.new(unloaded_items)
	if not _run_state.begin_unloading():
		_unload_sequence = null
		return false
	_train.set_speed(0.0)

	_pending_outcome = &""
	if _remaining_map_cargo == 0 and _stack_size == 0:
		_final_delivery_commit_time = float(event.event_time)
		_pending_outcome = (
			SUCCESS
			if _final_delivery_commit_time <= _run_state.time_limit_seconds() + TIME_EPSILON
			else FAILURE
		)
	elif float(event.event_time) > _run_state.time_limit_seconds() + TIME_EPSILON:
		_pending_outcome = FAILURE
	return true


func run_state() -> Variant:
	return _run_state


func unload_sequence() -> Variant:
	return _unload_sequence


func final_delivery_commit_time() -> float:
	return _final_delivery_commit_time


func summary() -> Variant:
	return _summary


func _on_train_cell_entered(cell: Vector2i) -> void:
	if _run_state == null or _run_state.phase() != &"RUNNING":
		return
	var event: Variant = _delivery_loop.handle_cell_entered(cell, _run_state.elapsed_seconds())
	if event != null:
		accept_delivery_event(event)


func _resolve_unload_completion() -> void:
	_unload_sequence = null
	if _pending_outcome != &"":
		var outcome: StringName = _pending_outcome
		_pending_outcome = &""
		_finish_terminal(outcome)
		return
	if _run_state.elapsed_seconds() >= _run_state.time_limit_seconds() - TIME_EPSILON:
		_finish_terminal(FAILURE)
		return
	if _run_state.finish_unloading():
		_train.set_speed(_base_speed)


func _finish_terminal(outcome: StringName) -> void:
	if _run_state == null or _run_state.is_terminal():
		return
	var changed: bool = bool(_run_state.succeed()) if outcome == SUCCESS else bool(_run_state.fail())
	if not changed:
		return
	_unload_sequence = null
	_train.set_speed(0.0)
	_input_state.set_paused(true)
	_summary = FiniteRunSummaryScript.new(
		outcome,
		_run_state.elapsed_seconds(),
		_final_delivery_commit_time,
		_run_state.time_limit_seconds(),
		_remaining_map_cargo,
		_stack_size
	)
