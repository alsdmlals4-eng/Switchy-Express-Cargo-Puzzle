class_name FiniteRunSummary
extends RefCounted

var _outcome: StringName = &""
var _failure_reason: StringName = &""
var _completion_time: float = 0.0
var _final_delivery_commit_time: float = -1.0
var _time_limit_seconds: float = 0.0
var _remaining_map_cargo: int = 0
var _stack_size: int = 0

var outcome: StringName:
	get:
		return _outcome
	set(_value):
		pass

var failure_reason: StringName:
	get:
		return _failure_reason
	set(_value):
		pass

var completion_time: float:
	get:
		return _completion_time
	set(_value):
		pass

var final_delivery_commit_time: float:
	get:
		return _final_delivery_commit_time
	set(_value):
		pass

var time_limit_seconds: float:
	get:
		return _time_limit_seconds
	set(_value):
		pass

var remaining_map_cargo: int:
	get:
		return _remaining_map_cargo
	set(_value):
		pass

var stack_size: int:
	get:
		return _stack_size
	set(_value):
		pass


func _init(
	final_outcome: StringName = &"",
	finished_at: float = 0.0,
	final_commit_at: float = -1.0,
	time_limit: float = 0.0,
	map_cargo_remaining: int = 0,
	current_stack_size: int = 0,
	final_failure_reason: StringName = &""
) -> void:
	_outcome = final_outcome
	_failure_reason = final_failure_reason if final_outcome == &"FAILURE" else &""
	_completion_time = maxf(finished_at, 0.0)
	_final_delivery_commit_time = final_commit_at
	_time_limit_seconds = maxf(time_limit, 0.0)
	_remaining_map_cargo = maxi(map_cargo_remaining, 0)
	_stack_size = maxi(current_stack_size, 0)
