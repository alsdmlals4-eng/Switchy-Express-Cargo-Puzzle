class_name DifficultyDirector
extends RefCounted

const DifficultyForecastScript := preload("res://game/difficulty/difficulty_forecast.gd")
const DifficultyEventScript := preload("res://game/difficulty/difficulty_event.gd")
const TIME_EPSILON := 0.000001

var _step_seconds: float = 30.0
var _warning_lead_seconds: float = 5.0
var _elapsed_seconds: float = 0.0
var _current_level: int = 0
var _next_commit_time: float = 30.0


func reset(step_seconds: float = 30.0, warning_lead_seconds: float = 5.0) -> void:
	_step_seconds = maxf(step_seconds, TIME_EPSILON)
	_warning_lead_seconds = clampf(warning_lead_seconds, 0.0, _step_seconds)
	_elapsed_seconds = 0.0
	_current_level = 0
	_next_commit_time = _step_seconds


func advance(delta_seconds: float) -> Array:
	var events: Array = []
	if delta_seconds <= 0.0:
		return events

	var target_time := _elapsed_seconds + delta_seconds
	while _next_commit_time <= target_time + TIME_EPSILON:
		var next_level := _current_level + 1
		events.append(
			DifficultyEventScript.new(
				_current_level,
				next_level,
				_next_commit_time
			)
		)
		_current_level = next_level
		_next_commit_time += _step_seconds
	_elapsed_seconds = target_time
	return events


func forecast() -> Variant:
	return DifficultyForecastScript.new(
		_current_level,
		_current_level + 1,
		_next_commit_time,
		seconds_to_next_boundary(),
		_warning_lead_seconds
	)


func seconds_to_next_boundary() -> float:
	return maxf(_next_commit_time - _elapsed_seconds, 0.0)


func pressure_band() -> StringName:
	if _current_level >= 4:
		return &"INTENSE"
	if _current_level >= 2:
		return &"BUSY"
	return &"CALM"


func elapsed_seconds() -> float:
	return _elapsed_seconds


func current_level() -> int:
	return _current_level
