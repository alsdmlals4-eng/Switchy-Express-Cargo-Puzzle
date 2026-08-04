extends "res://tests/test_case.gd"

const FIELD_PATH := "res://game/finite/cargo/fixed_cargo_field.gd"
const EVENT_PATH := "res://game/finite/delivery/finite_delivery_event.gd"
const LOOP_PATH := "res://game/finite/delivery/finite_delivery_loop.gd"
const INPUT_PATH := "res://game/finite/input/finite_gameplay_input_state.gd"
const STACK_PATH := "res://game/finite/cargo/unlimited_cargo_stack.gd"
const StationScript := preload("res://game/station/station.gd")

const A: StringName = &"RED_STAR"
const B: StringName = &"BLUE_DIAMOND"


func run() -> void:
	var required: Array[String] = [FIELD_PATH, EVENT_PATH, LOOP_PATH]
	for path: String in required:
		assert_true(ResourceLoader.exists(path, "Script"), "%s must exist" % path)
	if not _all_exist(required):
		return

	var field_script: Script = load(FIELD_PATH)
	var loop_script: Script = load(LOOP_PATH)
	var input_script: Script = load(INPUT_PATH)
	var stack_script: Script = load(STACK_PATH)
	var cargo_cells: Array[Vector2i] = [
		Vector2i(2, 1), Vector2i(3, 1), Vector2i(4, 1), Vector2i(5, 1),
	]
	var field: Variant = field_script.new([
		{"cell": [2, 1], "cargo_type": A},
		{"cell": [3, 1], "cargo_type": B},
		{"cell": [4, 1], "cargo_type": A},
		{"cell": [5, 1], "cargo_type": A},
	])
	var input: Variant = input_script.new()
	var stack: Variant = stack_script.new()
	var station_a := StationScript.new(Vector2i(8, 1), A)
	var station_b := StationScript.new(Vector2i(9, 1), B)
	var loop: Variant = loop_script.new(field, input, stack, [station_a, station_b])

	var skipped: Variant = loop.handle_cell_entered(cargo_cells[0], 1.0)
	assert_false(skipped.picked_up, "inactive manual input must leave cargo")
	assert_true(field.has_cargo(cargo_cells[0]), "skipped cargo must remain on map")
	assert_equal(skipped.remaining_map_cargo, 4, "skipped contact must not change map cargo")
	assert_equal(skipped.stack_size, 0, "skipped contact must not change stack")

	input.set_manual_load_active(true)
	var expected_types: Array[StringName] = [A, B, A, A]
	for index: int in range(cargo_cells.size()):
		var event: Variant = loop.handle_cell_entered(cargo_cells[index], 2.0 + float(index))
		assert_true(event.picked_up, "held input must collect cargo %d" % index)
		assert_equal(event.pickup_type, expected_types[index], "pickup type must preserve authored order")
		assert_equal(event.cell, cargo_cells[index], "event cell must match contact")
		assert_equal(event.event_time, 2.0 + float(index), "event time must be preserved")
		assert_equal(event.remaining_map_cargo, 3 - index, "remaining map cargo must decrease")
		assert_equal(event.stack_size, index + 1, "stack size must increase")
	assert_equal(stack.load_order(), [A, B, A, A], "contact order must create A/B/A/A TOP stack")

	var mismatch: Variant = loop.handle_cell_entered(station_b.cell, 10.0)
	assert_equal(mismatch.unload_count, 0, "mismatched B station must not unload TOP A")
	assert_false(mismatch.stop_requested, "mismatched station must not request a stop")
	assert_equal(mismatch.stack_size, 4, "mismatched station must preserve stack")

	var first_a: Variant = loop.handle_cell_entered(station_a.cell, 11.0)
	assert_equal(first_a.unload_count, 2, "first A visit must unload consecutive TOP As")
	assert_equal(first_a.unloaded_items, [A, A], "first A unload order must be explicit")
	assert_true(first_a.stop_requested, "matching station must request a stop")
	assert_equal(stack.load_order(), [A, B], "B must block the earlier A")

	var b_event: Variant = loop.handle_cell_entered(station_b.cell, 12.0)
	assert_equal(b_event.unload_count, 1, "B station must unload B after top As")
	assert_equal(b_event.unloaded_items, [B], "B unload item must be explicit")
	assert_equal(stack.load_order(), [A], "earlier A must remain")

	var final_a: Variant = loop.handle_cell_entered(station_a.cell, 13.0)
	assert_equal(final_a.unload_count, 1, "A revisit must unload final A")
	assert_equal(final_a.unloaded_items, [A], "final unload item must be explicit")
	assert_equal(final_a.stack_size, 0, "final A must empty stack")
	assert_equal(final_a.remaining_map_cargo, 0, "all map cargo must remain collected")

	var repeated: Variant = loop.handle_cell_entered(cargo_cells[0], 14.0)
	assert_false(repeated.picked_up, "collected cargo contact must not respawn")
	assert_equal(repeated.pickup_type, &"", "empty contact must have blank pickup type")

	loop.reset()
	assert_equal(field.remaining_count(), 4, "reset must restore fixed cargo field")
	assert_equal(stack.size(), 0, "reset must clear stack")
	assert_false(input.is_manual_load_active(), "reset must restore manual mode inactive")
	assert_false(input.is_auto_load_enabled(), "reset must restore auto mode disabled")

	assert_true(input.toggle_auto_load(), "auto mode must enable")
	var auto_pickup: Variant = loop.handle_cell_entered(cargo_cells[0], 20.0)
	assert_true(auto_pickup.picked_up, "auto mode must collect without hold")


func _all_exist(paths: Array[String]) -> bool:
	for path: String in paths:
		if not ResourceLoader.exists(path, "Script"):
			return false
	return true
