extends "res://tests/test_case.gd"

const GENERATOR_PATH := "res://game/rail/rail_generator.gd"
const TYPE_PATH := "res://game/cargo/cargo_type.gd"
const PLACER_PATH := "res://game/station/station_placer.gd"
const SPAWNER_PATH := "res://game/cargo/cargo_spawner.gd"


func run() -> void:
	var spawner_exists := ResourceLoader.exists(SPAWNER_PATH, "Script")
	assert_true(spawner_exists, "CargoSpawner script must exist")
	if not spawner_exists:
		return

	var generator: Variant = load(GENERATOR_PATH).new()
	var cargo_type: Script = load(TYPE_PATH)
	var placer_script: Script = load(PLACER_PATH)
	var spawner_script: Script = load(SPAWNER_PATH)
	var graph: Variant = generator.generate(31)
	var start_cell: Vector2i = graph.all_cells()[0]
	var station_result: Dictionary = placer_script.new().place(graph, start_cell, 51)
	var stations: Array = station_result.stations
	var station_cells: Array[Vector2i] = []
	for station: Variant in stations:
		station_cells.append(station.cell)

	var train_cells: Array[Vector2i] = [start_cell, graph.neighbors(start_cell)[0]]
	var forward_cells: Array[Vector2i] = graph.preview_route(start_cell, train_cells[1], 2)
	var spawner: Variant = spawner_script.new()
	spawner.configure(graph, stations, 77)
	assert_equal(
		spawner.ensure_all_minimum(4, train_cells, forward_cells),
		&"SPAWNED",
		"initial population must fill every cargo type"
	)

	for type: StringName in cargo_type.all_types():
		assert_equal(spawner.count(type), 4, "map must contain four pickups for %s" % type)
	assert_equal(spawner.pickup_cells().size(), 12, "initial map must contain exactly twelve pickups")

	var unique_pickups: Dictionary = {}
	for cell: Vector2i in spawner.pickup_cells():
		unique_pickups[cell] = true
		assert_false(train_cells.has(cell), "cargo must not spawn on locomotive or wagon cells")
		assert_false(forward_cells.has(cell), "cargo must not spawn in the locomotive's next two cells")
		assert_false(station_cells.has(cell), "cargo must not spawn on stations")
		assert_false(graph.switch_cells().has(cell), "cargo must not spawn on switches")
	assert_equal(unique_pickups.size(), spawner.pickup_cells().size(), "one rail cell may hold at most one pickup")

	var repeat_spawner: Variant = spawner_script.new()
	repeat_spawner.configure(graph, stations, 77)
	repeat_spawner.ensure_all_minimum(4, train_cells, forward_cells)
	assert_equal(repeat_spawner.signature(), spawner.signature(), "same seed and occupancy must create same pickups")

	var red: StringName = cargo_type.RED_STAR
	var collected_cell := Vector2i(-1, -1)
	for cell: Vector2i in spawner.pickup_cells():
		if spawner.cargo_at(cell) == red:
			collected_cell = cell
			break
	assert_true(collected_cell != Vector2i(-1, -1), "test setup must find a red pickup")
	assert_equal(spawner.collect(collected_cell, 10.0), red, "collect must return removed cargo type")
	assert_equal(spawner.count(red), 3, "collected cargo must leave map population")
	assert_equal(spawner.process(10.99, train_cells, forward_cells), &"WAITING", "respawn must wait one full second")
	assert_equal(spawner.count(red), 3, "population must remain low before respawn delay")
	assert_equal(spawner.process(11.0, train_cells, forward_cells), &"SPAWNED", "due pickup must respawn")
	assert_equal(spawner.count(red), 4, "respawn must restore minimum red population")
	assert_false(spawner.pickup_cells().has(collected_cell), "pickup must not immediately respawn at its previous cell")

	var blocked_spawner: Variant = spawner_script.new()
	blocked_spawner.configure(graph, stations, 99)
	var all_cells: Array[Vector2i] = graph.all_cells()
	assert_equal(
		blocked_spawner.ensure_minimum(red, 4, all_cells, [], Vector2i(-1, -1)),
		&"SPAWN_DEFERRED",
		"no eligible cell must return SPAWN_DEFERRED"
	)
	assert_equal(blocked_spawner.pickup_cells().size(), 0, "deferred spawn must not overwrite forbidden cells")
