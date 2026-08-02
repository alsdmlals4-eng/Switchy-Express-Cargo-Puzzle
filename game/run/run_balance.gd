class_name RunBalance
extends RefCounted

const FUEL_MAX := 100.0
const FUEL_START := 65.0
const SPEED_STEP_SECONDS := 30.0
const SPEED_STEP_AMOUNT := 0.08
const SPEED_START := 1.8
const SPEED_MAX := 3.4
const CARGO_SLOWDOWN_PER_ITEM := 0.045
const CARGO_MULTIPLIER_MIN := 0.64
const BOOST_SPEED_MULTIPLIER := 1.45
const FUEL_STEP_SECONDS := 45.0
const FUEL_STEP_AMOUNT := 0.12
const FUEL_DRAIN_START := 1.0
const BOOST_DRAIN_MULTIPLIER := 2.4
const SPEED_BONUS_WINDOW_SECONDS := 8.0
const SPEED_BONUS_MULTIPLIER := 1.25
const HEAVY_CARGO_THRESHOLD := 6
const HEAVY_BONUS_MULTIPLIER := 1.15


func base_speed(elapsed_seconds: float) -> float:
	var safe_elapsed := maxf(elapsed_seconds, 0.0)
	var step_count := int(floor(safe_elapsed / SPEED_STEP_SECONDS))
	return minf(SPEED_MAX, SPEED_START + SPEED_STEP_AMOUNT * float(step_count))


func cargo_multiplier(cargo_count: int) -> float:
	var bounded_count := maxi(cargo_count, 0)
	return maxf(CARGO_MULTIPLIER_MIN, 1.0 - CARGO_SLOWDOWN_PER_ITEM * float(bounded_count))


func current_speed(elapsed_seconds: float, cargo_count: int, boosting: bool) -> float:
	var boost_multiplier := BOOST_SPEED_MULTIPLIER if boosting else 1.0
	return base_speed(elapsed_seconds) * cargo_multiplier(cargo_count) * boost_multiplier


func base_fuel_drain(elapsed_seconds: float) -> float:
	var safe_elapsed := maxf(elapsed_seconds, 0.0)
	var step_count := int(floor(safe_elapsed / FUEL_STEP_SECONDS))
	return FUEL_DRAIN_START + FUEL_STEP_AMOUNT * float(step_count)


func fuel_drain_rate(elapsed_seconds: float, boosting: bool) -> float:
	var boost_multiplier := BOOST_DRAIN_MULTIPLIER if boosting else 1.0
	return base_fuel_drain(elapsed_seconds) * boost_multiplier


func unload_base_score(combo_count: int) -> int:
	match combo_count:
		1:
			return 100
		2:
			return 260
		3:
			return 540
		4:
			return 960
		_:
			return 300 * combo_count if combo_count >= 5 else 0


func unload_fuel_reward(combo_count: int) -> int:
	match combo_count:
		1:
			return 5
		2:
			return 12
		3:
			return 21
		4:
			return 32
		_:
			return 8 * combo_count if combo_count >= 5 else 0


func speed_bonus_multiplier(seconds_since_delivery: float) -> float:
	if seconds_since_delivery < 0.0:
		return 1.0
	return SPEED_BONUS_MULTIPLIER if seconds_since_delivery <= SPEED_BONUS_WINDOW_SECONDS else 1.0


func heavy_bonus_multiplier(cargo_count_before_unload: int) -> float:
	return HEAVY_BONUS_MULTIPLIER if cargo_count_before_unload >= HEAVY_CARGO_THRESHOLD else 1.0


func delivery_score(combo_count: int, seconds_since_delivery: float, cargo_count_before_unload: int) -> int:
	var base_score := unload_base_score(combo_count)
	if base_score <= 0:
		return 0
	var multiplied_score := (
		float(base_score)
		* speed_bonus_multiplier(seconds_since_delivery)
		* heavy_bonus_multiplier(cargo_count_before_unload)
	)
	return int(round(multiplied_score))
