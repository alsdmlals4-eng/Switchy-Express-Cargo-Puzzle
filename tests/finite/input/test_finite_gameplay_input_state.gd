extends "res://tests/test_case.gd"

const INPUT_PATH := "res://game/finite/input/finite_gameplay_input_state.gd"


func run() -> void:
	var input_exists := ResourceLoader.exists(INPUT_PATH, "Script")
	assert_true(input_exists, "finite gameplay input state must exist")
	if not input_exists:
		return

	var input_script: Script = load(INPUT_PATH)
	var input: Variant = input_script.new()
	assert_false(input.is_manual_load_active(), "manual load defaults inactive")
	assert_false(input.is_auto_load_enabled(), "auto load defaults disabled")
	assert_false(input.should_load_on_contact(), "manual load defaults inactive")

	assert_true(input.set_manual_load_active(true), "manual hold must be accepted while running")
	assert_true(input.is_manual_load_active(), "manual state must reflect hold")
	assert_true(input.should_load_on_contact(), "hold must load")
	assert_true(input.set_manual_load_active(false), "manual release must be accepted")
	assert_false(input.should_load_on_contact(), "released manual mode must not load")

	assert_true(input.toggle_auto_load(), "auto toggle must succeed while running")
	assert_true(input.is_auto_load_enabled(), "auto mode must become enabled")
	assert_true(input.should_load_on_contact(), "auto mode must load without hold")

	input.set_manual_load_active(true)
	input.set_paused(true)
	assert_true(input.is_paused(), "pause flag must be visible")
	assert_false(input.is_manual_load_active(), "pause must clear transient manual hold")
	assert_false(input.should_load_on_contact(), "pause must suppress contact input")
	assert_false(input.toggle_auto_load(), "pause must reject mode changes")
	assert_true(input.is_auto_load_enabled(), "rejected pause toggle must preserve auto state")
	assert_false(input.set_manual_load_active(true), "pause must reject manual hold changes")
	assert_false(input.is_manual_load_active(), "rejected paused hold must remain inactive")

	input.set_paused(false)
	assert_false(input.is_paused(), "resume must clear pause flag")
	assert_true(input.should_load_on_contact(), "resume must restore preserved auto-load behavior")
	assert_true(input.toggle_auto_load(), "auto toggle must be accepted after resume")
	assert_false(input.is_auto_load_enabled(), "second accepted toggle must disable auto mode")
	assert_false(input.should_load_on_contact(), "both loading modes off must not load")
