extends "res://tests/test_case.gd"

const SNAPSHOT_PATH := "res://game/difficulty/difficulty_pressure_snapshot.gd"


func run() -> void:
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
	assert_equal(snapshot.to_dictionary(), {
		"speed_step": 2,
		"fuel_step": 1,
		"effective_at": 90.0,
	}, "snapshot serialization must be deterministic")
