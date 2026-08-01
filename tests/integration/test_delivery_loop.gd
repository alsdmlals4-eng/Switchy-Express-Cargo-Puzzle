extends "res://tests/test_case.gd"

const GENERATOR_PATH := "res://game/rail/rail_generator.gd"
const TRAIN_PATH := "res://game/train/train_controller.gd"
const STACK_PATH := "res://game/cargo/cargo_stack.gd"
const INPUT_PATH := "res://game/input/gameplay_input_state.gd"
const SPAWNER_PATH := "res://game/cargo/cargo_spawner.gd"
const STATION_PLACER_PATH := "res://game/station/station_placer.gd"
const LOOP_PATH := "res://game/delivery/delivery_loop.gd"


func run() -> void:
	var loop_exists := ResourceLoader.exists(LOOP_PATH, "Script")
	assert_true(loop_exists, "DeliveryLoop script must exist")
	if not loop_exists:
		return

	var graph: Variant = load(GENERATOR_PATH).new().generate(71)
	var stations: Array = load(STATION_PLACER_PATH).new().place(
		graph,
		graph.all_cells()[0],
		91
	).stations
	var spawner: Variant = load(SPAWNER_PATH).new()
	spawner.configure(graph, stations, 111)
	assert_equal(spawner.ensure_all_minimum(4, [], []), &"SPAWNED", "integration setup must spawn cargo")

	var pickup_cell: Vector2i = spawner.pickup_cells()[0]
	var pickup_type: StringName = spawner.cargo_at(pickup_cell)
	var pickup_approach: Dictionary = _find_approach(graph, pickup_cell)
	assert_true(pickup_approach.success, "integration setup must find a route into pickup cell")
	if not pickup_approach.success:
		return

	var input_state: Variant = load(INPUT_PATH).new()
	var timing_stack: Variant = load(STACK_PATH).new(8)
	var timing_train: Variant = _new_train(graph, pickup_approach)
	timing_train.set_speed(2.0)
	var timing_loop: Variant = load(LOOP_PATH).new()
	timing_loop.configure(timing_train, timing_stack, spawner, input_state, stations)
	var timing_events: Array = timing_loop.advance_time(1.0)
	assert_equal(timing_events.size(), 2, "speed two for one second must produce two cell-entry events")
	assert_equal(timing_events[0].time, 0.5, "first crossed cell must use its exact half-second event time")
	assert_equal(timing_events[1].time, 1.0, "second crossed cell must use the frame-end event time")
	assert_equal(spawner.cargo_at(pickup_cell), pickup_type, "timing probe must not collect while LOAD is inactive")

	var stack: Variant = load(STACK_PATH).new(8)
	var first_train: Variant = _new_train(graph, pickup_approach)
	var first_loop: Variant = load(LOOP_PATH).new()
	first_loop.configure(first_train, stack, spawner, input_state, stations)
	var ignored_events: Array = first_loop.advance_time(1.0)
	assert_equal(ignored_events.size(), 1, "crossing one cell must produce one delivery event")
	assert_equal(stack.size(), 0, "pickup must remain ignored while LOAD is inactive")
	assert_equal(spawner.cargo_at(pickup_cell), pickup_type, "ignored pickup must remain on the map")
	assert_false(ignored_events[0].picked_up, "inactive LOAD event must report no pickup")

	input_state.set_load_requested(true)
	var loading_train: Variant = _new_train(graph, pickup_approach)
	var loading_loop: Variant = load(LOOP_PATH).new()
	loading_loop.configure(loading_train, stack, spawner, input_state, stations)
	var pickup_events: Array = loading_loop.advance_time(1.0)
	assert_equal(stack.size(), 1, "active LOAD crossing must add cargo to stack")
	assert_equal(stack.peek(), pickup_type, "loaded cargo type must match map pickup")
	assert_equal(spawner.cargo_at(pickup_cell), &"", "loaded pickup must be removed from map")
	assert_true(pickup_events[0].picked_up, "active LOAD event must report pickup")
	assert_equal(pickup_events[0].pickup_type, pickup_type, "event pickup type must match stack")
	assert_equal(spawner.count(pickup_type), 3, "pickup collection must temporarily lower map population")

	input_state.set_load_requested(false)
	loading_loop.advance_time(1.0)
	assert_equal(spawner.count(pickup_type), 4, "delivery runtime must restore minimum population after one second")
	assert_false(spawner.pickup_cells().has(pickup_cell), "runtime respawn must avoid the collected cell")
	for occupied_cell: Vector2i in loading_train.train_cells():
		assert_false(spawner.pickup_cells().has(occupied_cell), "runtime respawn must avoid current train cells")
	for forward_cell: Vector2i in loading_train.forward_cells(2):
		assert_false(spawner.pickup_cells().has(forward_cell), "runtime respawn must avoid the next two route cells")
	assert_equal(loading_loop.last_spawn_status(), &"SPAWNED", "delivery loop must expose runtime spawn result")

	var matching_station: Variant = null
	for station: Variant in stations:
		if station.cargo_type == pickup_type:
			matching_station = station
			break
	assert_not_null(matching_station, "integration setup must find matching station")
	if matching_station == null:
		return

	var station_approach: Dictionary = _find_approach(graph, matching_station.cell)
	assert_true(station_approach.success, "integration setup must find a route into matching station")
	if not station_approach.success:
		return

	var station_train: Variant = _new_train(graph, station_approach)
	var station_loop: Variant = load(LOOP_PATH).new()
	station_loop.configure(station_train, stack, spawner, input_state, stations)
	var station_events: Array = station_loop.advance_time(1.0)
	assert_equal(station_events.size(), 1, "station crossing must produce one delivery event")
	assert_true(station_events[0].unloaded, "matching station event must report unloading")
	assert_equal(station_events[0].unload_result.count, 1, "matching station must unload loaded cargo")
	assert_equal(station_events[0].unload_result.items, [pickup_type], "unload event must preserve cargo type")
	assert_true(stack.is_empty(), "integrated station unloading must mutate actual stack")


func _new_train(graph: Variant, approach: Dictionary) -> Variant:
	if graph.switch_cells().has(approach.start):
		graph.configure_switch_approach(approach.start, approach.incoming)
		for _state: int in range(3):
			if graph.next_cell(approach.start, approach.incoming) == approach.destination:
				break
			graph.cycle_switch(approach.start, approach.incoming)
	var train: Variant = load(TRAIN_PATH).new()
	train.configure(graph, approach.start, approach.incoming, 8)
	train.set_speed(1.0)
	return train


func _find_approach(graph: Variant, destination: Vector2i) -> Dictionary:
	for start: Vector2i in graph.neighbors(destination):
		for incoming: Vector2i in graph.neighbors(start):
			if incoming == destination:
				continue
			if graph.switch_cells().has(start):
				graph.configure_switch_approach(start, incoming)
				for _state: int in range(3):
					if graph.next_cell(start, incoming) == destination:
						return {
							"success": true,
							"start": start,
							"incoming": incoming,
							"destination": destination,
						}
					graph.cycle_switch(start, incoming)
			elif graph.next_cell(start, incoming) == destination:
				return {
					"success": true,
					"start": start,
					"incoming": incoming,
					"destination": destination,
				}
	return {
		"success": false,
		"start": Vector2i.ZERO,
		"incoming": Vector2i.ZERO,
		"destination": destination,
	}
