class_name DifficultyForecast
extends RefCounted

var _from_snapshot: Variant
var _to_snapshot: Variant
var _changed_axes: Array[StringName] = []
var _commit_time: float
var _seconds_until_commit: float
var _warning_lead_seconds: float


func _init(
	from_snapshot: Variant,
	to_snapshot: Variant,
	changed_axes: Array,
	commit_time: float,
	seconds_until_commit: float,
	warning_lead_seconds: float
) -> void:
	_from_snapshot = from_snapshot
	_to_snapshot = to_snapshot
	for raw_axis: Variant in changed_axes:
		_changed_axes.append(StringName(raw_axis))
	_commit_time = commit_time
	_seconds_until_commit = maxf(seconds_until_commit, 0.0)
	_warning_lead_seconds = maxf(warning_lead_seconds, 0.0)


func from_snapshot() -> Variant:
	return _from_snapshot


func to_snapshot() -> Variant:
	return _to_snapshot


func changed_axes() -> Array[StringName]:
	return _changed_axes.duplicate()


func from_level() -> int:
	return int(_from_snapshot.speed_step())


func to_level() -> int:
	return int(_to_snapshot.speed_step())


func commit_time() -> float:
	return _commit_time


func seconds_until_commit() -> float:
	return _seconds_until_commit


func is_within_warning_window() -> bool:
	return _seconds_until_commit <= _warning_lead_seconds
