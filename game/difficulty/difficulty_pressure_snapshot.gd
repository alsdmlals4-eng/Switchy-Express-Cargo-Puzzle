class_name DifficultyPressureSnapshot
extends RefCounted

var _speed_step: int
var _fuel_step: int
var _effective_at: float


func _init(speed_step: int, fuel_step: int, effective_at: float) -> void:
	_speed_step = maxi(speed_step, 0)
	_fuel_step = maxi(fuel_step, 0)
	_effective_at = maxf(effective_at, 0.0)


func speed_step() -> int:
	return _speed_step


func fuel_step() -> int:
	return _fuel_step


func effective_at() -> float:
	return _effective_at


func equals(other: Variant) -> bool:
	return (
		other != null
		and other.has_method("speed_step")
		and other.has_method("fuel_step")
		and other.has_method("effective_at")
		and other.speed_step() == _speed_step
		and other.fuel_step() == _fuel_step
		and absf(float(other.effective_at()) - _effective_at) <= 0.000001
	)


func to_dictionary() -> Dictionary:
	return {
		"speed_step": _speed_step,
		"fuel_step": _fuel_step,
		"effective_at": _effective_at,
	}
