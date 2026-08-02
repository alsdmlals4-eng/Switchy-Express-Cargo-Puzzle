extends "res://tests/test_case.gd"

const DIRECTOR_PATH := "res://game/difficulty/difficulty_director.gd"
const FORECAST_PATH := "res://game/difficulty/difficulty_forecast.gd"
const EVENT_PATH := "res://game/difficulty/difficulty_event.gd"


func run() -> void:
	var director_exists := ResourceLoader.exists(DIRECTOR_PATH, "Script")
	var forecast_exists := ResourceLoader.exists(FORECAST_PATH, "Script")
	var event_exists := ResourceLoader.exists(EVENT_PATH, "Script")
	assert_true(director_exists, "DifficultyDirector script must exist")
	assert_true(forecast_exists, "DifficultyForecast script must exist")
	assert_true(event_exists, "DifficultyEvent script must exist")
	if not director_exists or not forecast_exists or not event_exists:
		return

	var director: Variant = load(DIRECTOR_PATH).new()
	_test_schedule_and_forecast(director)
	_test_multiple_boundaries_and_reset(director)


func _test_schedule_and_forecast(director: Variant) -> void:
	director.reset(30.0, 5.0)
	assert_equal(director.current_level(), 0, "difficulty must start at level zero")
	assert_equal(director.pressure_band(), &"CALM", "level zero must map to CALM")
	assert_almost_equal(director.seconds_to_next_boundary(), 30.0, 0.0001, "first commit boundary must be thirty seconds")

	var initial_forecast: Variant = director.forecast()
	assert_equal(initial_forecast.from_level(), 0, "forecast must identify current level")
	assert_equal(initial_forecast.to_level(), 1, "forecast must identify next level")
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
	assert_equal(events[0].from_level(), 0, "event must preserve prior level")
	assert_equal(events[0].to_level(), 1, "event must commit the next level")
	assert_almost_equal(events[0].committed_at(), 30.0, 0.0001, "event timestamp must equal authoritative boundary")
	assert_equal(director.current_level(), 1, "director must commit level one")
	assert_equal(director.pressure_band(), &"CALM", "level one must remain CALM")


func _test_multiple_boundaries_and_reset(director: Variant) -> void:
	var events: Array = director.advance(60.0)
	assert_equal(events.size(), 2, "large delta must emit every crossed difficulty boundary")
	assert_equal(events[0].to_level(), 2, "first crossed event must commit level two")
	assert_equal(events[1].to_level(), 3, "second crossed event must commit level three")
	assert_almost_equal(events[0].committed_at(), 60.0, 0.0001, "level two must commit at sixty seconds")
	assert_almost_equal(events[1].committed_at(), 90.0, 0.0001, "level three must commit at ninety seconds")
	assert_equal(director.current_level(), 3, "large delta must end at the latest crossed level")
	assert_equal(director.pressure_band(), &"BUSY", "levels two and three must map to BUSY")

	director.advance(30.0)
	assert_equal(director.current_level(), 4, "next boundary must reach level four")
	assert_equal(director.pressure_band(), &"INTENSE", "level four and above must map to INTENSE")

	director.reset(30.0, 5.0)
	assert_equal(director.current_level(), 0, "reset must clear committed level")
	assert_almost_equal(director.elapsed_seconds(), 0.0, 0.0001, "reset must clear authoritative elapsed time")
	assert_almost_equal(director.seconds_to_next_boundary(), 30.0, 0.0001, "reset must restore first boundary")
	assert_equal(director.advance(0.0).size(), 0, "zero delta must not mutate schedule")
	assert_equal(director.advance(-1.0).size(), 0, "negative delta must not mutate schedule")
