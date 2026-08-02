class_name DifficultyEvent
extends RefCounted

var _from_level: int
var _to_level: int
var _committed_at: float


func _init(from_level: int, to_level: int, committed_at: float) -> void:
	_from_level = from_level
	_to_level = to_level
	_committed_at = committed_at


func from_level() -> int:
	return _from_level


func to_level() -> int:
	return _to_level


func committed_at() -> float:
	return _committed_at
