extends "res://tests/test_case.gd"

const FIELD_PATH := "res://game/finite/cargo/fixed_cargo_field.gd"


func run() -> void:
	var field_exists := ResourceLoader.exists(FIELD_PATH, "Script")
	assert_true(field_exists, "fixed finite cargo field must exist")
	if not field_exists:
		return

	var field_script: Script = load(FIELD_PATH)
	var placements: Array[Dictionary] = [
		{"cell": [2, 1], "cargo_type": "RED_STAR"},
		{"cell": [3, 1], "cargo_type": "BLUE_DIAMOND"},
	]
	var field: Variant = field_script.new(placements)
	assert_equal(field.validation_errors(), [], "valid fixed placements must pass")
	assert_equal(field.remaining_count(), 2, "all authored cargo must begin present")
	assert_true(field.has_cargo(Vector2i(2, 1)), "A cargo must exist")
	assert_equal(field.cargo_type_at(Vector2i(2, 1)), &"RED_STAR", "field must expose cargo type")
	assert_equal(field.cargo_type_at(Vector2i(9, 9)), &"", "empty cell must return blank type")

	field.advance_time(100000.0)
	assert_true(field.has_cargo(Vector2i(2, 1)), "time progression must not move or respawn cargo")
	assert_equal(field.collect(Vector2i(2, 1)), &"RED_STAR", "collect must return authored cargo")
	assert_false(field.has_cargo(Vector2i(2, 1)), "collected cargo must disappear")
	assert_equal(field.remaining_count(), 1, "collect must reduce remaining count")
	assert_equal(field.collect(Vector2i(2, 1)), &"", "same cargo cannot be collected twice")

	field.advance_time(100000.0)
	assert_false(field.has_cargo(Vector2i(2, 1)), "collected cargo must never respawn over time")
	assert_true(field.has_cargo(Vector2i(3, 1)), "uncollected cargo must remain fixed")

	field.reset()
	assert_equal(field.remaining_count(), 2, "reset must restore authored cargo set")
	assert_true(field.has_cargo(Vector2i(2, 1)), "reset must restore collected A")
	assert_true(field.has_cargo(Vector2i(3, 1)), "reset must retain B")

	var duplicate: Variant = field_script.new([
		{"cell": [2, 1], "cargo_type": "RED_STAR"},
		{"cell": [2, 1], "cargo_type": "BLUE_DIAMOND"},
	])
	assert_true(
		duplicate.validation_errors().has("cargo placement cells must be unique"),
		"duplicate cargo cells must be rejected"
	)
	var invalid: Variant = field_script.new([{"cell": [1, 1], "cargo_type": "INVALID"}])
	assert_true(
		invalid.validation_errors().has("cargo placement cargo_type must be valid"),
		"invalid cargo types must be rejected"
	)
