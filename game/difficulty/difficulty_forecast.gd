class_name DifficultyForecast
extends RefCounted

var _from_level: int
var _to_level: int
var _commit_time: float
var _seconds_until_commit: float
var _warning_lead_seconds: float


func _init(
	from_level: int,
	to_level: int,
	commit_time: float,
	seconds_until_commit: float,
	warning_lead_seconds: float
) -> void:
	_from_level = from_level
	_to_level = to_level
	_commit_time = commit_time
	_seconds_until_commit = maxf(seconds_until_commit, 0.0)
	_warning_lead_seconds = maxf(warning_lead_seconds, 0.0)


func from_level() -> int:
	return _from_level


func to_level() -> int:
	return _to_level


func commit_time() -> float:
	return _commit_time


func seconds_until_commit() -> float:
	return _seconds_until_commit


func is_within_warning_window() -> bool:
	return _seconds_until_commit <= _warning_lead_seconds
