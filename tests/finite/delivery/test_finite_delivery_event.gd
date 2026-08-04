extends "res://tests/test_case.gd"

const EVENT_PATH := "res://game/finite/delivery/finite_delivery_event.gd"
const A: StringName = &"RED_STAR"


func run() -> void:
	var event_exists := ResourceLoader.exists(EVENT_PATH, "Script")
	assert_true(event_exists, "finite delivery event must exist")
	if not event_exists:
		return

	var event_script: Script = load(EVENT_PATH)
	var authored_items: Array[StringName] = [A, A]
	var event: Variant = event_script.new(
		Vector2i(2, 3),
		4.5,
		true,
		A,
		authored_items,
		true,
		7,
		2
	)

	var leaked_items: Array[StringName] = event.unloaded_items
	var replacement_items: Array[StringName] = []
	leaked_items.clear()
	event.cell = Vector2i(9, 9)
	event.event_time = 99.0
	event.picked_up = false
	event.pickup_type = &"BLUE_DIAMOND"
	event.unload_count = 0
	event.unloaded_items = replacement_items
	event.stop_requested = false
	event.remaining_map_cargo = 0
	event.stack_size = 0

	assert_equal(event.cell, Vector2i(2, 3), "event cell must be immutable")
	assert_equal(event.event_time, 4.5, "event time must be immutable")
	assert_true(event.picked_up, "pickup result must be immutable")
	assert_equal(event.pickup_type, A, "pickup type must be immutable")
	assert_equal(event.unload_count, 2, "unload count must be immutable")
	assert_equal(event.unloaded_items, [A, A], "unloaded items must be immutable and copy-safe")
	assert_true(event.stop_requested, "stop request must be immutable")
	assert_equal(event.remaining_map_cargo, 7, "remaining cargo count must be immutable")
	assert_equal(event.stack_size, 2, "stack size must be immutable")
