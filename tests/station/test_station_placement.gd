extends "res://tests/test_case.gd"

const GENERATOR_PATH := "res://game/rail/rail_generator.gd"
const TYPE_PATH := "res://game/cargo/cargo_type.gd"
const STATION_PATH := "res://game/station/station.gd"
const PLACER_PATH := "res://game/station/station_placer.gd"


func run() -> void:
	var station_exists := ResourceLoader.exists(STATION_PATH, "Script")
	var placer_exists := ResourceLoader.exists(PLACER_PATH, "Script")
	assert_true(station_exists, "Station script must exist")
	assert_true(placer_exists, "StationPlacer script must exist")
	if not station_exists or not placer_exists:
		return

	var generator: Variant = load(GENERATOR_PATH).new()
	var cargo_type: Script = load(TYPE_PATH)
	var placer_script: Script = load(PLACER_PATH)

	for seed: int in range(1, 101):
		var graph: Variant = generator.generate(seed)
		var start_cell: Vector2i = graph.all_cells()[0]
		var result: Dictionary = placer_script.new().place(graph, start_cell, seed)
		assert_true(result.success, "seed %d station placement must succeed" % seed)
		var stations: Array = result.stations
		assert_equal(stations.size(), 6, "seed %d must place exactly six stations" % seed)
		var station_cells: Dictionary = {}
		for station: Variant in stations:
			assert_true(graph.has_cell(station.cell), "seed %d station must use a rail cell" % seed)
			assert_false(graph.switch_cells().has(station.cell), "seed %d station must not occupy a switch" % seed)
			assert_false(station.cell == start_cell, "seed %d station must not occupy train start" % seed)
			station_cells[station.cell] = true
		assert_equal(station_cells.size(), stations.size(), "seed %d stations must occupy unique cells" % seed)

		for type: StringName in cargo_type.all_types():
			var typed_stations: Array = stations.filter(func(station: Variant) -> bool:
				return station.cargo_type == type
			)
			assert_equal(typed_stations.size(), 2, "seed %d must place two stations for %s" % [seed, type])
			assert_greater_equal(
				graph.shortest_path_distance(typed_stations[0].cell, typed_stations[1].cell),
				5,
				"seed %d same-type stations must be at least five graph cells apart" % seed
			)

	var first_graph: Variant = generator.generate(42)
	var first_start: Vector2i = first_graph.all_cells()[0]
	var first_signature: String = placer_script.new().place(first_graph, first_start, 77).signature
	var repeat_signature: String = placer_script.new().place(first_graph, first_start, 77).signature
	assert_equal(repeat_signature, first_signature, "same graph/start/seed must place identical stations")

	var failure_result: Dictionary = placer_script.new().place(first_graph, first_start, 77, 0)
	assert_false(failure_result.success, "zero candidate attempts must return explicit placement failure")
	assert_equal(failure_result.status, &"PLACEMENT_FAILED", "failure result must carry a stable status")
	assert_equal(failure_result.stations.size(), 0, "failed placement must not return partial stations")
