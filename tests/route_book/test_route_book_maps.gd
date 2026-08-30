extends "res://tests/test_case.gd"

const MapLoader := preload("res://game/finite/map/finite_map_loader.gd")

const MAPS: Array[Dictionary] = [
	{
		"path": "res://data/maps/route_book/rb01_service_sidings.json",
		"id": &"RB01_SERVICE_SIDINGS",
		"size": Vector2i(9, 7),
		"start": Vector2i(1, 3),
		"time": 90.0,
		"blocked": [],
		"cargo": [[Vector2i(3, 3), &"BLUE_DIAMOND"], [Vector2i(4, 4), &"RED_STAR"]],
		"stations": [[Vector2i(6, 2), &"RED_STAR"], [Vector2i(7, 5), &"BLUE_DIAMOND"]],
	},
	{
		"path": "res://data/maps/route_book/rb02_reverse_order.json",
		"id": &"RB02_REVERSE_ORDER",
		"size": Vector2i(11, 7),
		"start": Vector2i(1, 3),
		"time": 105.0,
		"blocked": [],
		"cargo": [[Vector2i(3, 3), &"BLUE_DIAMOND"], [Vector2i(5, 3), &"RED_STAR"]],
		"stations": [[Vector2i(7, 1), &"RED_STAR"], [Vector2i(9, 5), &"BLUE_DIAMOND"]],
	},
	{
		"path": "res://data/maps/route_book/rb03_return_manifest.json",
		"id": &"RB03_RETURN_MANIFEST",
		"size": Vector2i(12, 9),
		"start": Vector2i(1, 4),
		"time": 120.0,
		"blocked": [],
		"cargo": [[Vector2i(4, 4), &"RED_STAR"], [Vector2i(5, 4), &"BLUE_DIAMOND"]],
		"stations": [[Vector2i(8, 2), &"RED_STAR"], [Vector2i(7, 7), &"BLUE_DIAMOND"]],
	},
	{
		"path": "res://data/maps/route_book/rb04_load_window.json",
		"id": &"RB04_LOAD_WINDOW",
		"size": Vector2i(12, 9),
		"start": Vector2i(1, 4),
		"time": 120.0,
		"blocked": [],
		"cargo": [[Vector2i(3, 4), &"RED_STAR"], [Vector2i(4, 4), &"RED_STAR"], [Vector2i(6, 4), &"BLUE_DIAMOND"]],
		"stations": [[Vector2i(9, 2), &"RED_STAR"], [Vector2i(9, 7), &"BLUE_DIAMOND"]],
	},
	{
		"path": "res://data/maps/route_book/rb05_fork_lock.json",
		"id": &"RB05_FORK_LOCK",
		"size": Vector2i(13, 9),
		"start": Vector2i(1, 4),
		"time": 120.0,
		"blocked": [],
		"cargo": [[Vector2i(4, 4), &"BLUE_DIAMOND"], [Vector2i(8, 2), &"RED_STAR"]],
		"stations": [[Vector2i(11, 2), &"RED_STAR"], [Vector2i(11, 6), &"BLUE_DIAMOND"]],
	},
	{
		"path": "res://data/maps/route_book/rb06_port_circuit.json",
		"id": &"RB06_PORT_CIRCUIT",
		"size": Vector2i(15, 11),
		"start": Vector2i(1, 5),
		"time": 165.0,
		"blocked": [Vector2i(6, 3), Vector2i(8, 3), Vector2i(6, 7), Vector2i(8, 7)],
		"cargo": [[Vector2i(4, 5), &"BLUE_DIAMOND"], [Vector2i(7, 4), &"YELLOW_TRIANGLE"], [Vector2i(9, 7), &"RED_STAR"]],
		"stations": [[Vector2i(12, 2), &"RED_STAR"], [Vector2i(12, 5), &"YELLOW_TRIANGLE"], [Vector2i(12, 8), &"BLUE_DIAMOND"]],
	},
]


func run() -> void:
	for expected: Dictionary in MAPS:
		var definition: Variant = MapLoader.load_from_path(str(expected["path"]))
		assert_not_null(definition, "%s marker map must load" % expected["id"])
		if definition == null:
			continue
		assert_equal(definition.validation_errors(), [], "%s map schema is valid" % expected["id"])
		assert_equal(definition.map_id, expected["id"], "%s id is exact" % expected["id"])
		assert_equal(definition.map_revision, 1, "%s map revision is one" % expected["id"])
		assert_equal(definition.board_size, expected["size"], "%s board size is exact" % expected["id"])
		assert_equal(definition.start_cell, expected["start"], "%s start is exact" % expected["id"])
		assert_equal(definition.incoming_cell, definition.start_cell + Vector2i.LEFT, "%s enters from the left" % expected["id"])
		assert_almost_equal(definition.time_limit_seconds, float(expected["time"]), 0.001, "%s time limit is exact" % expected["id"])
		assert_true(definition.marker_tracks_are_player_built(), "%s player authors track" % expected["id"])
		assert_true(definition.allows_open_terminals_after_required(), "%s preserves finite open-terminal rule" % expected["id"])
		assert_equal(definition.blocked_cells, expected["blocked"], "%s blocked cells are exact" % expected["id"])
		assert_equal(_placements(definition.cargo_placements), expected["cargo"], "%s cargo markers are exact" % expected["id"])
		assert_equal(_placements(definition.station_placements), expected["stations"], "%s station markers are exact" % expected["id"])
		for placement: Dictionary in definition.station_placements:
			assert_false(
				definition.buildable_cells.has(_cell(placement["cell"])),
				"%s station footprint is off-track" % expected["id"],
			)


func _placements(values: Array[Dictionary]) -> Array:
	var result: Array = []
	for value: Dictionary in values:
		result.append([_cell(value["cell"]), StringName(value["cargo_type"])])
	return result


func _cell(raw: Variant) -> Vector2i:
	if raw is Vector2i:
		return raw
	if raw is Array and raw.size() == 2:
		return Vector2i(int(raw[0]), int(raw[1]))
	return Vector2i.ZERO
