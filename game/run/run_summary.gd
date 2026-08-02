class_name RunSummary
extends RefCounted

var _elapsed_seconds: float
var _fuel_remaining: float
var _score: int
var _last_combo: int
var _max_combo: int
var _end_reason: StringName
var _delivery_count: int
var _pickup_count: int
var _total_unloaded: int
var _boost_seconds: float
var _difficulty_level: int
var _assisted: bool


func _init(
	elapsed_seconds: float,
	fuel_remaining: float,
	score: int,
	last_combo: int,
	max_combo: int,
	end_reason: StringName,
	delivery_count: int,
	pickup_count: int,
	total_unloaded: int,
	boost_seconds: float,
	difficulty_level: int,
	assisted: bool
) -> void:
	_elapsed_seconds = elapsed_seconds
	_fuel_remaining = fuel_remaining
	_score = score
	_last_combo = last_combo
	_max_combo = max_combo
	_end_reason = end_reason
	_delivery_count = delivery_count
	_pickup_count = pickup_count
	_total_unloaded = total_unloaded
	_boost_seconds = boost_seconds
	_difficulty_level = difficulty_level
	_assisted = assisted


func elapsed_seconds() -> float:
	return _elapsed_seconds


func fuel_remaining() -> float:
	return _fuel_remaining


func score() -> int:
	return _score


func last_combo() -> int:
	return _last_combo


func max_combo() -> int:
	return _max_combo


func end_reason() -> StringName:
	return _end_reason


func delivery_count() -> int:
	return _delivery_count


func pickup_count() -> int:
	return _pickup_count


func total_unloaded() -> int:
	return _total_unloaded


func boost_seconds() -> float:
	return _boost_seconds


func difficulty_level() -> int:
	return _difficulty_level


func is_assisted() -> bool:
	return _assisted
