extends "res://tests/test_case.gd"

const GENERATOR_PATH := "res://game/rail/rail_generator.gd"
const TRAIN_PATH := "res://game/train/train_controller.gd"
const STACK_PATH := "res://game/cargo/cargo_stack.gd"
const INPUT_PATH := "res://game/input/gameplay_input_state.gd"
const SPAWNER_PATH := "res://game/cargo/cargo_spawner.gd"
const STATION_PLACER_PATH := "res://game/station/station_placer.gd"
const LOOP_PATH := "res://game/delivery/delivery_loop.gd"
const RUN_CONTROLLER_PATH := "res://game/run/run_controller.gd"


func run() -> void:
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
	input_state.set_load_requested(true)
	var stack: Variant = load(STACK_PATH).new(8)
	var pickup_train: Variant = _new_train(graph, pickup_approach)
	var pickup_loop: Variant = load(LOOP_PATH).new()
	pickup_loop.configure(pickup_train, stack, spawner, input_state, stations)
	var pickup_controller: Variant = load(RUN_CONTROLLER_PATH).new()
	pickup_controller.configure(pickup_train, pickup_loop, stack, input_state)
	pickup_controller.start()
	var pickup_events: Array = pickup_controller.advance_time(1.0)

	assert_equal(pickup_events.size(), 1, "RunController must preserve one actual cell-entry event")
	assert_true(pickup_events[0].picked_up, "actual DeliveryLoop pickup must pass through RunController")
	assert_equal(pickup_events[0].pickup_type, pickup_type, "actual pickup type must remain unchanged")
	assert_equal(stack.size(), 1, "actual pickup must mutate CargoStack once")
	assert_equal(pickup_controller.run_metrics().pickup_count(), 1, "RunController must count actual pickup once")
	assert_almost_equal(pickup_controller.run_state().elapsed_seconds(), 1.0, 0.0001, "RunController must preserve requested active time")

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

	input_state.set_load_requested(false)
	var station_train: Variant = _new_train(graph, station_approach)
	var station_loop: Variant = load(LOOP_PATH).new()
	station_loop.configure(station_train, stack, spawner, input_state, stations)
	var station_controller: Variant = load(RUN_CONTROLLER_PATH).new()
	station_controller.configure(station_train, station_loop, stack, input_state)
	station_controller.start()
	var station_events: Array = station_controller.advance_time(1.0)

	assert_equal(station_events.size(), 1, "RunController must preserve actual station cell event")
	assert_true(station_events[0].unloaded, "matching actual station must unload through RunController")
	assert_equal(station_events[0].combo_count, 1, "actual Combo must equal unload group count")
	assert_equal(station_events[0].score_awarded, 100, "actual unload must apply RunBalance score")
	assert_equal(station_events[0].fuel_awarded, 5, "actual unload must apply RunBalance fuel reward")
	assert_true(stack.is_empty(), "actual unload must mutate CargoStack once")
	assert_equal(station_controller.run_state().score(), 100, "actual unload score must reach RunState")
	assert_equal(station_controller.run_state().max_combo(), 1, "actual unload Combo must reach RunState")
	assert_equal(station_controller.run_metrics().delivery_count(), 1, "actual unload must count one delivery")


func _new_train(graph: Variant, approach: Dictionary) -> Variant:
	if graph.switch_cells().has(approach.start):
		graph.configure_switch_approach(approach.start, approach.incoming)
		for _state: int in range(3):
			if graph.next_cell(approach.start, approach.incoming) == approach.destination:
				break
			graph.cycle_switch(approach.start, approach.incoming)
	var train: Variant = load(TRAIN_PATH).new()
	train.configure(graph, approach.start, approach.incoming, 8)
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
