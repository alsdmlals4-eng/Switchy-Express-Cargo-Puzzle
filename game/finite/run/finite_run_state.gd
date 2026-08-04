class_name FiniteRunState
extends RefCounted

const SELF_SCRIPT_PATH := "res://game/finite/run/finite_run_state.gd"
const READY: StringName = &"READY"
const RUNNING: StringName = &"RUNNING"
const UNLOADING: StringName = &"UNLOADING"
const PAUSED: StringName = &"PAUSED"
const SUCCESS: StringName = &"SUCCESS"
const FAILURE: StringName = &"FAILURE"

var _phase: StringName = READY
var _resume_phase: StringName = READY
var _elapsed_seconds: float = 0.0
var _time_limit_seconds: float = 0.0


func _init(time_limit: float = 0.0) -> void:
	_time_limit_seconds = maxf(time_limit, 0.0)


func start() -> bool:
	if _phase != READY:
		return false
	_phase = RUNNING
	return true


func begin_unloading() -> bool:
	if _phase != RUNNING:
		return false
	_phase = UNLOADING
	return true


func finish_unloading() -> bool:
	if _phase != UNLOADING:
		return false
	_phase = RUNNING
	return true


func pause() -> bool:
	if _phase != RUNNING and _phase != UNLOADING:
		return false
	_resume_phase = _phase
	_phase = PAUSED
	return true


func resume() -> bool:
	if _phase != PAUSED:
		return false
	_phase = _resume_phase
	_resume_phase = READY
	return true


func succeed() -> bool:
	if _phase != RUNNING and _phase != UNLOADING:
		return false
	_phase = SUCCESS
	_resume_phase = READY
	return true


func fail() -> bool:
	if _phase != RUNNING and _phase != UNLOADING:
		return false
	_phase = FAILURE
	_resume_phase = READY
	return true


func advance_clock(delta_seconds: float) -> void:
	if _phase != RUNNING and _phase != UNLOADING:
		return
	_elapsed_seconds += maxf(delta_seconds, 0.0)


func synchronize_elapsed(timestamp: float) -> void:
	if _phase != RUNNING and _phase != UNLOADING:
		return
	_elapsed_seconds = maxf(_elapsed_seconds, maxf(timestamp, 0.0))


func phase() -> StringName:
	return _phase


func elapsed_seconds() -> float:
	return _elapsed_seconds


func time_limit_seconds() -> float:
	return _time_limit_seconds


func is_terminal() -> bool:
	return _phase == SUCCESS or _phase == FAILURE


func duplicate_state() -> Variant:
	var copy: Variant = load(SELF_SCRIPT_PATH).new(_time_limit_seconds)
	copy._phase = _phase
	copy._resume_phase = _resume_phase
	copy._elapsed_seconds = _elapsed_seconds
	return copy
