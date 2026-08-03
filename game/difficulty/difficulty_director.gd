class_name DifficultyDirector
extends RefCounted

const DifficultyPressureSnapshotScript := preload("res://game/difficulty/difficulty_pressure_snapshot.gd")
const DifficultyForecastScript := preload("res://game/difficulty/difficulty_forecast.gd")
const DifficultyEventScript := preload("res://game/difficulty/difficulty_event.gd")
const TIME_EPSILON := 0.000001

var _speed_step_seconds: float = 30.0
var _fuel_step_seconds: float = 45.0
var _warning_lead_seconds: float = 5.0
var _elapsed_seconds: float = 0.0
var _current_snapshot: Variant
var _next_speed_time: float = 30.0
var _next_fuel_time: float = 45.0


func _init() -> void:
	reset()


func reset(
	speed_step_seconds: float = 30.0,
	fuel_step_seconds: float = 45.0,
	warning_lead_seconds: float = 5.0
) -> void:
	_speed_step_seconds = maxf(speed_step_seconds, TIME_EPSILON)
	_fuel_step_seconds = maxf(fuel_step_seconds, TIME_EPSILON)
	_warning_lead_seconds = clampf(
		warning_lead_seconds,
		0.0,
		minf(_speed_step_seconds, _fuel_step_seconds)
	)
	_elapsed_seconds = 0.0
	_current_snapshot = DifficultyPressureSnapshotScript.new(0, 0, 0.0)
	_next_speed_time = _speed_step_seconds
	_next_fuel_time = _fuel_step_seconds


func advance(delta_seconds: float) -> Array:
	var events: Array = []
	if delta_seconds <= 0.0:
		return events

	var target_time := _elapsed_seconds + delta_seconds
	while _next_boundary_time() <= target_time + TIME_EPSILON:
		var commit_time := _next_boundary_time()
		var from_snapshot: Variant = _current_snapshot
		var speed_step: int = from_snapshot.speed_step()
		var fuel_step: int = from_snapshot.fuel_step()
		var changed_axes: Array[StringName] = []

		if absf(_next_speed_time - commit_time) <= TIME_EPSILON:
			speed_step += 1
			_next_speed_time += _speed_step_seconds
			changed_axes.append(&"SPEED")
		if absf(_next_fuel_time - commit_time) <= TIME_EPSILON:
			fuel_step += 1
			_next_fuel_time += _fuel_step_seconds
			changed_axes.append(&"FUEL")

		var to_snapshot: Variant = DifficultyPressureSnapshotScript.new(
			speed_step,
			fuel_step,
			commit_time
		)
		events.append(
			DifficultyEventScript.new(
				from_snapshot,
				to_snapshot,
				changed_axes,
				commit_time
			)
		)
		_current_snapshot = to_snapshot

	_elapsed_seconds = target_time
	return events


func current_snapshot() -> Variant:
	return _current_snapshot


func next_snapshot() -> Variant:
	var commit_time := _next_boundary_time()
	var speed_step: int = _current_snapshot.speed_step()
	var fuel_step: int = _current_snapshot.fuel_step()
	if absf(_next_speed_time - commit_time) <= TIME_EPSILON:
		speed_step += 1
	if absf(_next_fuel_time - commit_time) <= TIME_EPSILON:
		fuel_step += 1
	return DifficultyPressureSnapshotScript.new(speed_step, fuel_step, commit_time)


func forecast() -> Variant:
	var upcoming: Variant = next_snapshot()
	return DifficultyForecastScript.new(
		_current_snapshot,
		upcoming,
		_changed_axes_between(_current_snapshot, upcoming),
		upcoming.effective_at(),
		seconds_to_next_boundary(),
		_warning_lead_seconds
	)


func seconds_to_next_boundary() -> float:
	return maxf(_next_boundary_time() - _elapsed_seconds, 0.0)


func pressure_band() -> StringName:
	var level := current_level()
	if level >= 4:
		return &"INTENSE"
	if level >= 2:
		return &"BUSY"
	return &"CALM"


func elapsed_seconds() -> float:
	return _elapsed_seconds


func current_level() -> int:
	return int(_current_snapshot.speed_step())


func _next_boundary_time() -> float:
	return minf(_next_speed_time, _next_fuel_time)


func _changed_axes_between(from_snapshot: Variant, to_snapshot: Variant) -> Array[StringName]:
	var axes: Array[StringName] = []
	if to_snapshot.speed_step() != from_snapshot.speed_step():
		axes.append(&"SPEED")
	if to_snapshot.fuel_step() != from_snapshot.fuel_step():
		axes.append(&"FUEL")
	return axes
