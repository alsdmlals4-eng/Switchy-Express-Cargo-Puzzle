extends "res://tests/test_case.gd"

const STATE_PATH := "res://game/run/run_state.gd"
const SUMMARY_PATH := "res://game/run/run_summary.gd"
const METRICS_PATH := "res://game/run/run_metrics_accumulator.gd"


func run() -> void:
	var state_exists := ResourceLoader.exists(STATE_PATH, "Script")
	var summary_exists := ResourceLoader.exists(SUMMARY_PATH, "Script")
	var metrics_exists := ResourceLoader.exists(METRICS_PATH, "Script")
	assert_true(state_exists, "RunState script must exist")
	assert_true(summary_exists, "RunSummary script must exist")
	assert_true(metrics_exists, "RunMetricsAccumulator script must exist")
	if not state_exists or not summary_exists or not metrics_exists:
		return

	var state: Variant = load(STATE_PATH).new()
	var metrics: Variant = load(METRICS_PATH).new()
	_test_lifecycle_and_clamps(state)
	_test_delivery_and_metrics(state, metrics)
	_test_summary_snapshot(state, metrics)


func _test_lifecycle_and_clamps(state: Variant) -> void:
	state.reset(100.0, 65.0)
	assert_true(state.is_ready(), "reset state must be ready")
	assert_almost_equal(state.fuel(), 65.0, 0.0001, "reset must use configured starting fuel")
	assert_true(state.start(), "ready state must start exactly once")
	assert_false(state.start(), "active state must not start twice")
	assert_true(state.is_active(), "started state must be active")

	state.advance_clock(2.5)
	state.apply_fuel_delta(-10.0)
	assert_almost_equal(state.elapsed_seconds(), 2.5, 0.0001, "active state must advance elapsed time")
	assert_almost_equal(state.fuel(), 55.0, 0.0001, "fuel delta must mutate active fuel")

	assert_true(state.pause(), "active state must enter pause")
	state.advance_clock(10.0)
	state.apply_fuel_delta(-10.0)
	assert_almost_equal(state.elapsed_seconds(), 2.5, 0.0001, "paused state must not advance authoritative time")
	assert_almost_equal(state.fuel(), 55.0, 0.0001, "paused state must not drain fuel")
	assert_true(state.resume(), "paused state must resume")

	state.apply_fuel_delta(1000.0)
	assert_almost_equal(state.fuel(), 100.0, 0.0001, "fuel must clamp to configured maximum")
	state.apply_fuel_delta(-1000.0)
	assert_almost_equal(state.fuel(), 0.0, 0.0001, "fuel must clamp to zero")
	assert_true(state.end_once(&"FUEL_ZERO"), "first end request must succeed")
	assert_false(state.end_once(&"FUEL_ZERO"), "duplicate end request must be ignored")
	assert_true(state.is_ended(), "ended state must report ended")
	assert_equal(state.end_reason(), &"FUEL_ZERO", "first end reason must remain authoritative")

	state.advance_clock(5.0)
	state.apply_fuel_delta(50.0)
	state.apply_delivery(3, 540, 21)
	assert_almost_equal(state.elapsed_seconds(), 2.5, 0.0001, "ended state must not advance")
	assert_almost_equal(state.fuel(), 0.0, 0.0001, "ended state must not receive fuel")
	assert_equal(state.score(), 0, "ended state must not receive score")


func _test_delivery_and_metrics(state: Variant, metrics: Variant) -> void:
	state.reset(100.0, 65.0)
	metrics.reset()
	state.start()
	metrics.record_pickup()
	metrics.record_pickup()
	state.apply_delivery(3, 540, 21)
	metrics.record_delivery(3, 540, 21, 4.0)
	state.apply_delivery(1, 100, 5)
	metrics.record_delivery(1, 100, 5, 10.0)
	metrics.record_boost_time(1.25)

	assert_equal(state.score(), 640, "delivery scores must accumulate")
	assert_equal(state.last_combo(), 1, "last Combo must be the current unload group size")
	assert_equal(state.max_combo(), 3, "max Combo must track the largest unload group")
	assert_almost_equal(state.fuel(), 91.0, 0.0001, "delivery fuel rewards must accumulate within fuel max")
	assert_equal(metrics.pickup_count(), 2, "pickup metrics must count authoritative pickups")
	assert_equal(metrics.delivery_count(), 2, "delivery metrics must count valid unload groups")
	assert_equal(metrics.total_unloaded(), 4, "metrics must count unloaded cargo items")
	assert_equal(metrics.max_combo(), 3, "metrics must preserve max unload group")
	assert_almost_equal(metrics.boost_seconds(), 1.25, 0.0001, "boost duration must accumulate")
	assert_almost_equal(metrics.seconds_since_last_delivery(14.0), 4.0, 0.0001, "delivery recency must use authoritative event time")


func _test_summary_snapshot(state: Variant, metrics: Variant) -> void:
	state.advance_clock(7.0)
	assert_true(state.end_once(&"FUEL_ZERO"), "active run must freeze once")
	var summary: Variant = state.freeze_summary(metrics, 2, false)
	assert_almost_equal(summary.elapsed_seconds(), 7.0, 0.0001, "summary must capture elapsed time")
	assert_equal(summary.score(), 640, "summary must capture score")
	assert_equal(summary.max_combo(), 3, "summary must capture max Combo")
	assert_equal(summary.delivery_count(), 2, "summary must capture delivery count")
	assert_equal(summary.pickup_count(), 2, "summary must capture pickup count")
	assert_equal(summary.difficulty_level(), 2, "summary must capture committed difficulty level")
	assert_false(summary.is_assisted(), "summary must preserve assist eligibility flag")
	assert_equal(summary.end_reason(), &"FUEL_ZERO", "summary must capture end reason")

	state.reset(100.0, 20.0)
	metrics.reset()
	assert_equal(summary.score(), 640, "summary must remain unchanged after live state reset")
	assert_equal(summary.delivery_count(), 2, "summary metrics must be immutable snapshots")
