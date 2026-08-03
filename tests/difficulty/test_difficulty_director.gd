extends "res://tests/test_case.gd"

const DIRECTOR_PATH := "res://game/difficulty/difficulty_director.gd"
const FORECAST_PATH := "res://game/difficulty/difficulty_forecast.gd"
const EVENT_PATH := "res://game/difficulty/difficulty_event.gd"
const SNAPSHOT_PATH := "res://game/difficulty/difficulty_pressure_snapshot.gd"


func run() -> void:
	var director_exists := ResourceLoader.exists(DIRECTOR_PATH, "Script")
	var forecast_exists := ResourceLoader.exists(FORECAST_PATH, "Script")
	var event_exists := ResourceLoader.exists(EVENT_PATH, "Script")
	var snapshot_exists := ResourceLoader.exists(SNAPSHOT_PATH, "Script")
	assert_true(director_exists, "DifficultyDirector script must exist")
	assert_true(forecast_exists, "DifficultyForecast script must exist")
	assert_true(event_exists, "DifficultyEvent script must exist")
	assert_true(snapshot_exists, "DifficultyPressureSnapshot script must exist")
	if not director_exists or not forecast_exists or not event_exists or not snapshot_exists:
		return

	var director: Variant = load(DIRECTOR_PATH).new()
	_test_schedule_and_forecast(director)
	_test_multiple_boundaries_and_reset(director)


func _test_schedule_and_forecast(director: Variant) -> void:
	director.reset(30.0, 45.0, 5.0)
	assert_equal(director.current_level(), 0, "difficulty must start at level zero")
	assert_equal(director.pressure_band(), &"CALM", "level zero must map to CALM")
	assert_almost_equal(director.seconds_to_next_boundary(), 30.0, 0.0001, "first commit boundary must be thirty seconds")

	var initial_forecast: Variant = director.forecast()
	assert_equal(initial_forecast.from_level(), 0, "forecast must identify current speed level")
	assert_equal(initial_forecast.to_level(), 1, "forecast must identify next speed level")
	assert_equal(initial_forecast.changed_axes(), [&"SPEED"], "first forecast must change speed only")
	assert_almost_equal(initial_forecast.commit_time(), 30.0, 0.0001, "forecast commit time must be authoritative")
	assert_almost_equal(initial_forecast.seconds_until_commit(), 30.0, 0.0001, "forecast must expose remaining authoritative time")
	assert_false(initial_forecast.is_within_warning_window(), "initial forecast must not be inside warning lead")

	var events: Array = director.advance(24.999)
	assert_equal(events.size(), 0, "difficulty must not commit before boundary")
	assert_equal(director.current_level(), 0, "level must remain unchanged before boundary")
	assert_false(director.forecast().is_within_warning_window(), "warning must remain inactive before five-second lead")

	events = director.advance(0.001)
	assert_equal(events.size(), 0, "warning boundary must not commit difficulty")
	assert_true(director.forecast().is_within_warning_window(), "forecast must enter warning window at five seconds")

	events = director.advance(5.0)
	assert_equal(events.size(), 1, "exact commit boundary must emit one event")
	assert_equal(events[0].from_level(), 0, "event must preserve prior speed level")
	assert_equal(events[0].to_level(), 1, "event must commit the next speed level")
	assert_equal(events[0].changed_axes(), [&"SPEED"], "30-second event changes speed only")
	assert_almost_equal(events[0].committed_at(), 30.0, 0.0001, "event timestamp must equal authoritative boundary")
	assert_equal(director.current_level(), 1, "director must commit speed level one")
	assert_equal(director.pressure_band(), &"CALM", "speed level one must remain CALM")


func _test_multiple_boundaries_and_reset(director: Variant) -> void:
	var events: Array = director.advance(60.0)
	assert_equal(events.size(), 3, "large delta must emit fuel45, speed60, and combined90 boundaries")
	assert_almost_equal(events[0].committed_at(), 45.0, 0.0001, "fuel boundary at forty-five")
	assert_equal(events[0].changed_axes(), [&"FUEL"], "45-second boundary changes fuel")
	assert_almost_equal(events[1].committed_at(), 60.0, 0.0001, "speed boundary at sixty")
	assert_equal(events[1].changed_axes(), [&"SPEED"], "60-second boundary changes speed")
	assert_almost_equal(events[2].committed_at(), 90.0, 0.0001, "combined boundary at ninety")
	assert_equal(events[2].changed_axes(), [&"SPEED", &"FUEL"], "90-second boundary combines axes")
	assert_equal(director.current_level(), 3, "speed compatibility level at ninety")
	assert_equal(director.pressure_band(), &"BUSY", "speed levels two and three map to BUSY")

	director.advance(30.0)
	assert_equal(director.current_level(), 4, "next speed boundary must reach level four")
	assert_equal(director.pressure_band(), &"INTENSE", "speed level four and above maps to INTENSE")

	director.reset(30.0, 45.0, 5.0)
	assert_equal(director.current_level(), 0, "reset must clear committed speed level")
	assert_equal(director.current_snapshot().fuel_step(), 0, "reset must clear committed fuel level")
	assert_almost_equal(director.elapsed_seconds(), 0.0, 0.0001, "reset must clear authoritative elapsed time")
	assert_almost_equal(director.seconds_to_next_boundary(), 30.0, 0.0001, "reset must restore first union boundary")
	assert_equal(director.advance(0.0).size(), 0, "zero delta must not mutate schedule")
	assert_equal(director.advance(-1.0).size(), 0, "negative delta must not mutate schedule")
