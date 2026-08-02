class_name RunState
extends RefCounted

const RunSummaryScript := preload("res://game/run/run_summary.gd")

enum Phase {
	READY,
	ACTIVE,
	PAUSED,
	ENDED,
}

var _phase: Phase = Phase.READY
var _fuel_max: float = 100.0
var _fuel: float = 65.0
var _elapsed_seconds: float = 0.0
var _score: int = 0
var _last_combo: int = 0
var _max_combo: int = 0
var _end_reason: StringName = &""


func reset(fuel_maximum: float = 100.0, starting_fuel: float = 65.0) -> void:
	_fuel_max = maxf(fuel_maximum, 0.0)
	_fuel = clampf(starting_fuel, 0.0, _fuel_max)
	_elapsed_seconds = 0.0
	_score = 0
	_last_combo = 0
	_max_combo = 0
	_end_reason = &""
	_phase = Phase.READY


func start() -> bool:
	if _phase != Phase.READY:
		return false
	_phase = Phase.ACTIVE
	return true


func pause() -> bool:
	if _phase != Phase.ACTIVE:
		return false
	_phase = Phase.PAUSED
	return true


func resume() -> bool:
	if _phase != Phase.PAUSED:
		return false
	_phase = Phase.ACTIVE
	return true


func end_once(reason: StringName) -> bool:
	if _phase == Phase.ENDED or _phase == Phase.READY:
		return false
	_phase = Phase.ENDED
	_end_reason = reason
	return true


func advance_clock(delta_seconds: float) -> void:
	if _phase != Phase.ACTIVE:
		return
	_elapsed_seconds += maxf(delta_seconds, 0.0)


func apply_fuel_delta(delta_fuel: float) -> void:
	if _phase != Phase.ACTIVE:
		return
	_fuel = clampf(_fuel + delta_fuel, 0.0, _fuel_max)


func apply_delivery(combo_count: int, score_delta: int, fuel_reward: int) -> void:
	if _phase != Phase.ACTIVE or combo_count <= 0:
		return
	_last_combo = combo_count
	_max_combo = maxi(_max_combo, combo_count)
	_score += maxi(score_delta, 0)
	_fuel = clampf(_fuel + float(maxi(fuel_reward, 0)), 0.0, _fuel_max)


func freeze_summary(metrics: Variant, difficulty_level: int, assisted: bool) -> Variant:
	assert(_phase == Phase.ENDED, "RunSummary may only be frozen after run end")
	return RunSummaryScript.new(
		_elapsed_seconds,
		_fuel,
		_score,
		_last_combo,
		_max_combo,
		_end_reason,
		metrics.delivery_count(),
		metrics.pickup_count(),
		metrics.total_unloaded(),
		metrics.boost_seconds(),
		difficulty_level,
		assisted
	)


func phase() -> Phase:
	return _phase


func is_ready() -> bool:
	return _phase == Phase.READY


func is_active() -> bool:
	return _phase == Phase.ACTIVE


func is_paused() -> bool:
	return _phase == Phase.PAUSED


func is_ended() -> bool:
	return _phase == Phase.ENDED


func fuel_max() -> float:
	return _fuel_max


func fuel() -> float:
	return _fuel


func elapsed_seconds() -> float:
	return _elapsed_seconds


func score() -> int:
	return _score


func last_combo() -> int:
	return _last_combo


func max_combo() -> int:
	return _max_combo


func end_reason() -> StringName:
	return _end_reason
