extends "res://tests/test_case.gd"

const GENERATOR_PATH := "res://game/rail/rail_generator.gd"
const TRAIN_PATH := "res://game/train/train_controller.gd"
const STACK_PATH := "res://game/cargo/cargo_stack.gd"
const TOKEN_STATE_PATH := "res://game/train/compact_wagon_token_state.gd"
const FOOTPRINT_PATH := "res://game/train/train_footprint.gd"
const INPUT_PATH := "res://game/input/gameplay_input_state.gd"
const SPAWNER_PATH := "res://game/cargo/cargo_spawner.gd"
const STATION_PLACER_PATH := "res://game/station/station_placer.gd"
const LOOP_PATH := "res://game/delivery/delivery_loop.gd"


class OccupancyProbeSpawner:
	extends RefCounted

	var last_occupied: Array[Vector2i] = []
	var last_forward: Array[Vector2i] = []

	func process(_current_time: float, occupied_cells: Array = [], forward_cells: Array = []) -> StringName:
		last_occupied.clear()
		last_forward.clear()
		for cell: Variant in occupied_cells:
			last_occupied.append(cell)
		for cell: Variant in forward_cells:
			last_forward.append(cell)
		return &"WAITING"

	func cargo_at(_cell: Vector2i) -> StringName:
		return &""

	func collect(_cell: Vector2i, _current_time: float) -> StringName:
		return &""


func run() -> void:
	var loop_script: Script = load(LOOP_PATH)
	var configure_argument_count := _method_argument_count(loop_script.new(), &"configure")
	assert_equal(
		configure_argument_count,
		6,
		"DeliveryLoop.configure must add one optional occupancy-provider argument"
	)
	if configure_argument_count != 6:
		return

	_test_provider_seam(loop_script)
	_test_actual_respawn_and_event_sync(loop_script)


func _test_provider_seam(loop_script: Script) -> void:
	var graph: Variant = load(GENERATOR_PATH).new().generate(31)
	var start_cell: Vector2i = graph.all_cells()[20]
	var incoming_cell: Vector2i = graph.neighbors(start_cell)[0]
	var train: Variant = load(TRAIN_PATH).new()
	train.configure(graph, start_cell, incoming_cell, 8)
	train.set_wagon_count(8)

	var stack: Variant = load(STACK_PATH).new(8)
	for cargo_type: StringName in [&"RED_STAR", &"BLUE_DIAMOND", &"YELLOW_TRIANGLE", &"RED_STAR", &"BLUE_DIAMOND", &"YELLOW_TRIANGLE", &"RED_STAR", &"BLUE_DIAMOND"]:
		assert_true(stack.push(cargo_type), "provider test setup must load eight cargo")
	var token_state: Variant = load(TOKEN_STATE_PATH).new()
	token_state.configure(stack)
	var footprint: Variant = load(FOOTPRINT_PATH).new()
	footprint.configure(train, token_state)
	var probe := OccupancyProbeSpawner.new()
	var input_state: Variant = load(INPUT_PATH).new()
	var loop: Variant = loop_script.new()
	loop.configure(train, stack, probe, input_state, [], footprint)
	loop.advance_time(0.0)

	assert_equal(
		probe.last_occupied,
		footprint.occupied_cells(),
		"DeliveryLoop must pass the injected compressed footprint to CargoSpawner.process"
	)
	assert_not_equal(
		probe.last_occupied,
		train.train_cells(),
		"injected compact occupancy must not fall back to full-cell wagon occupancy"
	)
	assert_equal(probe.last_forward, train.forward_cells(2), "forward route exclusion must remain unchanged")


func _test_actual_respawn_and_event_sync(loop_script: Script) -> void:
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
	assert_true(pickup_approach.success, "integration setup must find a route into pickup")
	if not pickup_approach.success:
		return

	var stack: Variant = load(STACK_PATH).new(8)
	var token_state: Variant = load(TOKEN_STATE_PATH).new()
	token_state.configure(stack)
	var pickup_train: Variant = _new_train(graph, pickup_approach)
	pickup_train.set_wagon_count(8)
	var footprint: Variant = load(FOOTPRINT_PATH).new()
	footprint.configure(pickup_train, token_state)
	var input_state: Variant = load(INPUT_PATH).new()
	input_state.set_load_requested(true)
	var loop: Variant = loop_script.new()
	loop.configure(pickup_train, stack, spawner, input_state, stations, footprint)

	var pickup_events: Array = loop.advance_time(1.0)
	assert_true(pickup_events[0].picked_up, "active LOAD must collect the pickup")
	assert_equal(stack.size(), 1, "pickup must mutate actual CargoStack")
	assert_equal(token_state.token_count(), 1, "same pickup event must synchronize compact token state")
	assert_equal(token_state.revision(), 1, "pickup event must synchronize token state exactly once")
	assert_equal(footprint.maximum_trailing_distance_cells(), 0.22, "one pickup must expose one compact token distance")

	input_state.set_load_requested(false)
	loop.advance_time(1.0)
	assert_equal(spawner.count(pickup_type), 4, "runtime must restore the collected cargo population")
	for occupied_cell: Vector2i in footprint.occupied_cells():
		assert_false(spawner.pickup_cells().has(occupied_cell), "respawn must avoid compact occupied cells")
	for forward_cell: Vector2i in pickup_train.forward_cells(2):
		assert_false(spawner.pickup_cells().has(forward_cell), "respawn must avoid forward route cells")

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
	var station_footprint: Variant = load(FOOTPRINT_PATH).new()
	station_footprint.configure(station_train, token_state)
	var station_loop: Variant = loop_script.new()
	station_loop.configure(station_train, stack, spawner, input_state, stations, station_footprint)
	var station_events: Array = station_loop.advance_time(1.0)
	assert_true(station_events[0].unloaded, "matching station must unload the compact token cargo")
	assert_equal(stack.size(), 0, "station unload must empty the actual stack")
	assert_equal(token_state.token_count(), 0, "same unload event must synchronize compact token state")
	assert_equal(token_state.revision(), 2, "unload event must synchronize token state exactly once")
	assert_equal(station_footprint.occupied_cells(), [station_train.current_cell()], "empty stack must release trailing occupancy")


func _method_argument_count(instance: Variant, method_name: StringName) -> int:
	for method: Dictionary in instance.get_method_list():
		if StringName(method.name) == method_name:
			return method.args.size()
	return -1


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
						return {"success": true, "start": start, "incoming": incoming, "destination": destination}
					graph.cycle_switch(start, incoming)
			elif graph.next_cell(start, incoming) == destination:
				return {"success": true, "start": start, "incoming": incoming, "destination": destination}
	return {"success": false, "start": Vector2i.ZERO, "incoming": Vector2i.ZERO, "destination": destination}
