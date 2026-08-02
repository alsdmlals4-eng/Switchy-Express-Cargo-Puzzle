extends "res://tests/test_case.gd"

const BALANCE_PATH := "res://game/run/run_balance.gd"


func run() -> void:
	var balance_exists := ResourceLoader.exists(BALANCE_PATH, "Script")
	assert_true(balance_exists, "RunBalance script must exist")
	if not balance_exists:
		return

	var balance: Variant = load(BALANCE_PATH).new()
	_test_speed_formula(balance)
	_test_fuel_formula(balance)
	_test_delivery_rewards(balance)


func _test_speed_formula(balance: Variant) -> void:
	assert_almost_equal(balance.base_speed(0.0), 1.8, 0.0001, "base speed must start at 1.8 cells per second")
	assert_almost_equal(balance.base_speed(29.999), 1.8, 0.0001, "base speed must not increase before the 30-second boundary")
	assert_almost_equal(balance.base_speed(30.0), 1.88, 0.0001, "base speed must increase by 0.08 at 30 seconds")
	assert_almost_equal(balance.base_speed(10000.0), 3.4, 0.0001, "base speed must cap at 3.4")

	assert_almost_equal(balance.cargo_multiplier(0), 1.0, 0.0001, "empty cargo must not slow the train")
	assert_almost_equal(balance.cargo_multiplier(4), 0.82, 0.0001, "four cargo must apply the confirmed slowdown")
	assert_almost_equal(balance.cargo_multiplier(8), 0.64, 0.0001, "eight cargo must clamp to the minimum multiplier")
	assert_almost_equal(balance.cargo_multiplier(99), 0.64, 0.0001, "cargo slowdown must remain bounded")

	assert_almost_equal(balance.current_speed(0.0, 0, false), 1.8, 0.0001, "normal current speed must combine base and cargo multipliers")
	assert_almost_equal(balance.current_speed(0.0, 0, true), 2.61, 0.0001, "BOOST must multiply current speed by 1.45")
	assert_almost_equal(balance.current_speed(0.0, 8, true), 1.6704, 0.0001, "BOOST and cargo slowdown must compose deterministically")


func _test_fuel_formula(balance: Variant) -> void:
	assert_almost_equal(balance.base_fuel_drain(0.0), 1.0, 0.0001, "base fuel drain must start at one per second")
	assert_almost_equal(balance.base_fuel_drain(44.999), 1.0, 0.0001, "fuel pressure must not increase before 45 seconds")
	assert_almost_equal(balance.base_fuel_drain(45.0), 1.12, 0.0001, "fuel pressure must increase by 0.12 at 45 seconds")
	assert_almost_equal(balance.fuel_drain_rate(0.0, false), 1.0, 0.0001, "normal drain must equal base drain")
	assert_almost_equal(balance.fuel_drain_rate(0.0, true), 2.4, 0.0001, "BOOST must cost 2.4 times fuel")
	assert_almost_equal(balance.fuel_drain_rate(45.0, true), 2.688, 0.0001, "BOOST drain must scale with time pressure")


func _test_delivery_rewards(balance: Variant) -> void:
	assert_equal(balance.unload_base_score(0), 0, "empty or mismatched station must award no score")
	assert_equal(balance.unload_base_score(1), 100, "Combo one base score must be 100")
	assert_equal(balance.unload_base_score(2), 260, "Combo two base score must be 260")
	assert_equal(balance.unload_base_score(3), 540, "Combo three base score must be 540")
	assert_equal(balance.unload_base_score(4), 960, "Combo four base score must be 960")
	assert_equal(balance.unload_base_score(5), 1500, "Combo five and above must use 300 per cargo")

	assert_equal(balance.unload_fuel_reward(0), 0, "empty or mismatched station must award no fuel")
	assert_equal(balance.unload_fuel_reward(1), 5, "Combo one fuel reward must be five")
	assert_equal(balance.unload_fuel_reward(2), 12, "Combo two fuel reward must be twelve")
	assert_equal(balance.unload_fuel_reward(3), 21, "Combo three fuel reward must be twenty-one")
	assert_equal(balance.unload_fuel_reward(4), 32, "Combo four fuel reward must be thirty-two")
	assert_equal(balance.unload_fuel_reward(5), 40, "Combo five and above must use eight fuel per cargo")

	assert_almost_equal(balance.speed_bonus_multiplier(-1.0), 1.0, 0.0001, "no previous delivery must not receive speed bonus")
	assert_almost_equal(balance.speed_bonus_multiplier(8.0), 1.25, 0.0001, "delivery within eight seconds must receive speed bonus")
	assert_almost_equal(balance.speed_bonus_multiplier(8.001), 1.0, 0.0001, "delivery after eight seconds must not receive speed bonus")
	assert_almost_equal(balance.heavy_bonus_multiplier(5), 1.0, 0.0001, "fewer than six cargo must not receive heavy bonus")
	assert_almost_equal(balance.heavy_bonus_multiplier(6), 1.15, 0.0001, "six or more cargo must receive heavy bonus")

	assert_equal(balance.delivery_score(2, 20.0, 2), 260, "plain delivery score must equal the base score")
	assert_equal(balance.delivery_score(2, 8.0, 2), 325, "speed bonus must round the multiplied score")
	assert_equal(balance.delivery_score(2, 20.0, 6), 299, "heavy bonus must round independently of Combo meaning")
	assert_equal(balance.delivery_score(2, 8.0, 6), 374, "speed and heavy bonuses must compose without changing Combo")
