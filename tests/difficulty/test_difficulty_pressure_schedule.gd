extends "res://tests/test_case.gd"

const SNAPSHOT_PATH := "res://game/difficulty/difficulty_pressure_snapshot.gd"
const DIRECTOR_PATH := "res://game/difficulty/difficulty_director.gd"


func run() -> void:
	_test_snapshot()
	_test_union_schedule()
	_test_forecast_sequence()
	_test_large_delta_order()


func _test_snapshot() -> void:
	var exists := ResourceLoader.exists(SNAPSHOT_PATH, "Script")
	assert_true(exists, "pressure snapshot script must exist")
	if not exists:
		return
	var script: Script = load(SNAPSHOT_PATH)
	var snapshot: Variant = script.new(2, 1, 90.0)
	assert_equal(snapshot.speed_step(), 2, "speed step")
	assert_equal(snapshot.fuel_step(), 1, "fuel step")
	assert_almost_equal(snapshot.effective_at(), 90.0, 0.0001, "effective time")
	assert_true(snapshot.equals(script.new(2, 1, 90.0)), "equal snapshots")
	assert_false(snapshot.equals(script.new(3, 1, 90.0)), "different snapshots")


func _test_union_schedule() -> void:
	var director: Variant = load(DIRECTOR_PATH).new()
	director.reset(30.0, 45.0, 5.0)
	assert_equal(director.current_snapshot().speed_step(), 0, "speed pressure starts at zero")
	assert_equal(director.current_snapshot().fuel_step(), 0, "fuel pressure starts at zero")
	var events: Array = director.advance(90.0)
	assert_equal(events.size(), 4, "30, 45, 60, and 90 must commit")
	if events.size() != 4:
		return
	assert_equal(events[0].changed_axes(), [&"SPEED"], "30 changes speed")
	assert_equal(events[1].changed_axes(), [&"FUEL"], "45 changes fuel")
	assert_equal(events[2].changed_axes(), [&"SPEED"], "60 changes speed")
	assert_equal(events[3].changed_axes(), [&"SPEED", &"FUEL"], "90 combines axes")
	assert_equal(director.current_snapshot().speed_step(), 3, "speed step at 90")
	assert_equal(director.current_snapshot().fuel_step(), 2, "fuel step at 90")
	assert_almost_equal(director.current_snapshot().effective_at(), 90.0, 0.0001, "snapshot effective time")
	assert_equal(director.current_level(), 3, "compatibility level follows speed pressure")


func _test_forecast_sequence() -> void:
	var director: Variant = load(DIRECTOR_PATH).new()
	director.reset(30.0, 45.0, 5.0)
	director.advance(25.0)
	var forecast: Variant = director.forecast()
	assert_true(forecast.is_within_warning_window(), "30-second warning window")
	assert_equal(forecast.changed_axes(), [&"SPEED"], "first forecast axis")
	assert_equal(forecast.from_snapshot().speed_step(), 0, "forecast from speed step")
	assert_equal(forecast.to_snapshot().speed_step(), 1, "forecast to speed step")
	director.advance(5.0)
	forecast = director.forecast()
	assert_almost_equal(forecast.commit_time(), 45.0, 0.0001, "next boundary is 45")
	assert_equal(forecast.changed_axes(), [&"FUEL"], "second forecast axis")


func _test_large_delta_order() -> void:
	var director: Variant = load(DIRECTOR_PATH).new()
	director.reset(30.0, 45.0, 5.0)
	var events: Array = director.advance(180.0)
	var times: Array[float] = []
	for event: Variant in events:
		times.append(event.committed_at())
	assert_equal(times, [30.0, 45.0, 60.0, 90.0, 120.0, 135.0, 150.0, 180.0], "ordered unique union boundaries")
	assert_equal(events[-1].changed_axes(), [&"SPEED", &"FUEL"], "180 must combine axes once")
