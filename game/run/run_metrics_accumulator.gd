class_name RunMetricsAccumulator
extends RefCounted

var _pickup_count: int = 0
var _delivery_count: int = 0
var _total_unloaded: int = 0
var _max_combo: int = 0
var _total_score_awarded: int = 0
var _total_fuel_awarded: int = 0
var _boost_seconds: float = 0.0
var _last_delivery_time: float = -1.0


func reset() -> void:
	_pickup_count = 0
	_delivery_count = 0
	_total_unloaded = 0
	_max_combo = 0
	_total_score_awarded = 0
	_total_fuel_awarded = 0
	_boost_seconds = 0.0
	_last_delivery_time = -1.0


func record_pickup() -> void:
	_pickup_count += 1


func record_delivery(
	combo_count: int,
	score_awarded: int,
	fuel_awarded: int,
	event_time: float
) -> void:
	if combo_count <= 0:
		return
	_delivery_count += 1
	_total_unloaded += combo_count
	_max_combo = maxi(_max_combo, combo_count)
	_total_score_awarded += maxi(score_awarded, 0)
	_total_fuel_awarded += maxi(fuel_awarded, 0)
	_last_delivery_time = maxf(event_time, 0.0)


func record_boost_time(delta_seconds: float) -> void:
	_boost_seconds += maxf(delta_seconds, 0.0)


func seconds_since_last_delivery(event_time: float) -> float:
	if _last_delivery_time < 0.0:
		return -1.0
	return maxf(event_time - _last_delivery_time, 0.0)


func pickup_count() -> int:
	return _pickup_count


func delivery_count() -> int:
	return _delivery_count


func total_unloaded() -> int:
	return _total_unloaded


func max_combo() -> int:
	return _max_combo


func total_score_awarded() -> int:
	return _total_score_awarded


func total_fuel_awarded() -> int:
	return _total_fuel_awarded


func boost_seconds() -> float:
	return _boost_seconds


func last_delivery_time() -> float:
	return _last_delivery_time
