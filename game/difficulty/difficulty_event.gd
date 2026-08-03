class_name DifficultyEvent
extends RefCounted

var _from_snapshot: Variant
var _to_snapshot: Variant
var _changed_axes: Array[StringName] = []
var _committed_at: float


func _init(
	from_snapshot: Variant,
	to_snapshot: Variant,
	changed_axes: Array,
	committed_at: float
) -> void:
	_from_snapshot = from_snapshot
	_to_snapshot = to_snapshot
	for raw_axis: Variant in changed_axes:
		_changed_axes.append(StringName(raw_axis))
	_committed_at = committed_at


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


func committed_at() -> float:
	return _committed_at
