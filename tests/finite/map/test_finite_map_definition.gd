extends "res://tests/test_case.gd"

const DEFINITION_PATH := "res://game/finite/map/finite_map_definition.gd"
const LOADER_PATH := "res://game/finite/map/finite_map_loader.gd"


func run() -> void:
	var definition_exists := ResourceLoader.exists(DEFINITION_PATH, "Script")
	assert_true(definition_exists, "finite map definition must exist")
	if not definition_exists:
		return

	var definition_script: Script = load(DEFINITION_PATH)
	var definition: Variant = definition_script.create({
		"definition_schema_version": 3,
		"map_id": "FP_TEST",
		"map_revision": 1,
		"ruleset_version": "fp_core_v1",
		"board_size": [7, 5],
		"start_cell": [1, 2],
		"incoming_cell": [0, 2],
		"buildable_cells": [[2, 1], [2, 2], [2, 3]],
		"blocked_cells": [[4, 2]],
		"caution_track_cells": [[2, 2]],
		"board_decorations": [{
			"kind": "FOREST_CLUSTER",
			"cell": [4, 2],
		}],
		"station_placements": [{
			"cell": [5, 1],
			"cargo_type": "RED_STAR",
		}],
		"cargo_placements": [{
			"cell": [3, 1],
			"cargo_type": "RED_STAR",
			"rail_anchor": {"geometry": "STRAIGHT", "rotation_quarters": 0},
		}],
		"time_limit_seconds": 90.0,
	})
	assert_equal(definition.validation_errors(), [], "valid authored definition must pass")
	assert_equal(definition.identity_key(), "FP_TEST@1", "map identity must exclude player layout")
	assert_equal(definition.definition_schema_version, 3, "finite pipeline must require schema v3")
	var serialized: Dictionary = definition.to_dictionary()
	assert_true(
		serialized.has("caution_track_cells"),
		"authored caution track cells must be retained by the map definition"
	)
	assert_equal(
		serialized.get("caution_track_cells"),
		[[2, 2]],
		"caution track cells must survive retry serialization"
	)
	assert_true(
		serialized.has("board_decorations"),
		"blocked-cell board decorations must be retained by the map definition"
	)
	assert_equal(
		serialized.get("board_decorations"),
		[{"kind": "FOREST_CLUSTER", "cell": [4, 2]}],
		"board decorations must survive retry serialization"
	)
	assert_equal(definition.required_cargo_cells(), [Vector2i(3, 1)], "only cargo requires exact contact")
	assert_equal(
		definition.station_service_cells(Vector2i(5, 1)),
		[Vector2i(5, 0), Vector2i(6, 1), Vector2i(5, 2), Vector2i(4, 1)],
		"station service cells must be deterministic cardinal neighbors"
	)
	assert_equal(
		definition.station_service_cells(Vector2i(0, 0)),
		[Vector2i(1, 0), Vector2i(0, 1)],
		"station service cells must clip at board edges"
	)

	var legacy: Variant = definition_script.create({"definition_schema_version": 2})
	assert_true(
		legacy.validation_errors().has("definition_schema_version must equal 3"),
		"schema v2 must not be silently reinterpreted as v3"
	)

	var anchored_station: Variant = definition_script.create({
		"definition_schema_version": 3,
		"map_id": "FP_ANCHORED_STATION",
		"map_revision": 1,
		"ruleset_version": "fp_core_v2",
		"board_size": [7, 5],
		"start_cell": [1, 2],
		"incoming_cell": [0, 2],
		"buildable_cells": [[2, 2]],
		"blocked_cells": [],
		"station_placements": [{
			"cell": [5, 1],
			"cargo_type": "RED_STAR",
			"rail_anchor": {"geometry": "STRAIGHT", "rotation_quarters": 0},
		}],
		"cargo_placements": [],
		"time_limit_seconds": 90.0,
	})
	assert_true(
		anchored_station.validation_errors().has("station placement rail_anchor is forbidden"),
		"v3 stations must remain off-track even when legacy anchor data is supplied"
	)

	var overlapping_services: Variant = definition_script.create({
		"definition_schema_version": 3,
		"map_id": "FP_OVERLAP",
		"map_revision": 1,
		"ruleset_version": "fp_core_v2",
		"board_size": [7, 5],
		"start_cell": [1, 2],
		"incoming_cell": [0, 2],
		"buildable_cells": [[2, 2]],
		"blocked_cells": [],
		"station_placements": [
			{"cell": [3, 2], "cargo_type": "RED_STAR"},
			{"cell": [5, 2], "cargo_type": "BLUE_DIAMOND"},
		],
		"cargo_placements": [],
		"time_limit_seconds": 90.0,
	})
	assert_true(
		overlapping_services.validation_errors().has("station service cells must not overlap"),
		"station service ownership must fail closed"
	)

	var loader_exists := ResourceLoader.exists(LOADER_PATH, "Script")
	assert_true(loader_exists, "finite map loader must exist")
	if loader_exists:
		var loader_script: Script = load(LOADER_PATH)
		var loaded: Variant = loader_script.load_from_dictionary({
			"definition_schema_version": 3,
			"map_id": "FP_LOADER_V3",
			"map_revision": 1,
			"ruleset_version": "fp_core_v2",
			"board_size": [7, 5],
			"start_cell": [1, 2],
			"incoming_cell": [0, 2],
			"marker_tracks_player_built": true,
			"buildable_rects": [{"minimum": [0, 0], "maximum": [6, 4]}],
			"blocked_cells": [],
			"station_placements": [{"cell": [4, 2], "cargo_type": "RED_STAR"}],
			"cargo_placements": [{
				"cell": [3, 2],
				"cargo_type": "BLUE_DIAMOND",
				"rail_anchor": {"geometry": "STRAIGHT", "rotation_quarters": 0},
			}],
			"time_limit_seconds": 90.0,
		})
		assert_false(loaded.buildable_cells.has(Vector2i(4, 2)), "v3 station footprint must be non-buildable")
		assert_true(loaded.buildable_cells.has(Vector2i(3, 2)), "cargo contact cell must stay buildable")

	var invalid: Variant = definition_script.create({
		"definition_schema_version": 3,
		"map_id": "FP_INVALID",
		"map_revision": 1,
		"ruleset_version": "fp_core_v1",
		"board_size": [4, 4],
		"start_cell": [1, 1],
		"incoming_cell": [1, 1],
		"buildable_cells": [[2, 2]],
		"blocked_cells": [[2, 2]],
		"station_placements": [],
		"cargo_placements": [],
		"time_limit_seconds": 0.0,
	})
	var errors: Array[String] = invalid.validation_errors()
	assert_true(errors.has("incoming_cell must differ from start_cell"), "equal start and incoming must fail")
	assert_true(errors.has("buildable_cells and blocked_cells must not overlap"), "surface overlap must fail")
	assert_true(errors.has("time_limit_seconds must be positive"), "non-positive time limit must fail")

	var missing_cell: Variant = definition_script.create({
		"definition_schema_version": 3,
		"map_id": "FP_MISSING_CELL",
		"map_revision": 1,
		"ruleset_version": "fp_core_v1",
		"board_size": [7, 5],
		"start_cell": [1, 2],
		"incoming_cell": [0, 2],
		"buildable_cells": [[2, 2]],
		"blocked_cells": [],
		"station_placements": [{
			"cargo_type": "RED_STAR",
		}],
		"cargo_placements": [],
		"time_limit_seconds": 90.0,
	})
	assert_true(
		missing_cell.validation_errors().has("station placement cell is required"),
		"missing placement cell must not silently become board origin"
	)

	var fractional: Variant = definition_script.create({
		"definition_schema_version": 3,
		"map_id": "FP_FRACTIONAL",
		"map_revision": 1,
		"ruleset_version": "fp_core_v1",
		"board_size": [7, 5],
		"start_cell": [1.5, 2],
		"incoming_cell": [0, 2],
		"buildable_cells": [[2, 2]],
		"blocked_cells": [],
		"station_placements": [{
			"cell": [5, 1],
			"cargo_type": "RED_STAR",
		}],
		"cargo_placements": [],
		"time_limit_seconds": 90.0,
	})
	var fractional_errors: Array[String] = fractional.validation_errors()
	assert_true(
		fractional_errors.has("start_cell is required"),
		"fractional coordinates must not be truncated into valid cells"
	)

	var invalid_wayside_content: Variant = definition_script.create({
		"definition_schema_version": 3,
		"map_id": "FP_INVALID_WAYSIDE_CONTENT",
		"map_revision": 1,
		"ruleset_version": "fp_core_v3",
		"board_size": [7, 5],
		"start_cell": [1, 2],
		"incoming_cell": [0, 2],
		"buildable_cells": [[2, 1], [2, 2], [2, 3]],
		"blocked_cells": [[4, 2]],
		"caution_track_cells": [[4, 2]],
		"board_decorations": [{
			"kind": "UNKNOWN_DECORATION",
			"cell": [2, 2],
		}],
		"station_placements": [{
			"cell": [5, 1],
			"cargo_type": "RED_STAR",
		}],
		"cargo_placements": [],
		"time_limit_seconds": 90.0,
	})
	var invalid_wayside_errors: Array[String] = invalid_wayside_content.validation_errors()
	assert_true(
		invalid_wayside_errors.has("caution_track_cells must be buildable"),
		"caution cells outside the playable rail surface must fail closed"
	)
	assert_true(
		invalid_wayside_errors.has("board decoration kind must be valid"),
		"unknown board decoration kinds must fail closed"
	)
	assert_true(
		invalid_wayside_errors.has("board decoration cells must be blocked"),
		"board decorations must not consume a playable rail cell"
	)

	var valid_disposal: Variant = definition_script.create({
		"definition_schema_version": 3,
		"map_id": "FP_VALID_DISPOSAL",
		"map_revision": 1,
		"ruleset_version": "fp_core_v3",
		"board_size": [7, 5],
		"start_cell": [1, 2],
		"incoming_cell": [0, 2],
		"buildable_cells": [[2, 1], [2, 2], [2, 3]],
		"blocked_cells": [],
		"station_placements": [{
			"cell": [5, 1],
			"cargo_type": "WASTE_CRATE",
			"destination_kind": "DISPOSAL_YARD",
		}],
		"cargo_placements": [{
			"cell": [3, 1],
			"cargo_type": "WASTE_CRATE",
			"rail_anchor": {"geometry": "STRAIGHT", "rotation_quarters": 0},
		}],
		"time_limit_seconds": 90.0,
	})
	assert_equal(
		valid_disposal.validation_errors(),
		[],
		"a waste crate and disposal yard must form a valid authored pair"
	)

	var invalid_disposal_destinations: Variant = definition_script.create({
		"definition_schema_version": 3,
		"map_id": "FP_INVALID_DISPOSAL_DESTINATIONS",
		"map_revision": 1,
		"ruleset_version": "fp_core_v3",
		"board_size": [9, 7],
		"start_cell": [1, 3],
		"incoming_cell": [0, 3],
		"buildable_cells": [[2, 2], [2, 3], [2, 4]],
		"blocked_cells": [],
		"station_placements": [
			{"cell": [5, 1], "cargo_type": "WASTE_CRATE"},
			{
				"cell": [5, 5],
				"cargo_type": "RED_STAR",
				"destination_kind": "DISPOSAL_YARD",
			},
		],
		"cargo_placements": [],
		"time_limit_seconds": 90.0,
	})
	var invalid_disposal_errors: Array[String] = invalid_disposal_destinations.validation_errors()
	assert_true(
		invalid_disposal_errors.has("WASTE_CRATE stations must be DISPOSAL_YARD"),
		"waste crates must not target a normal station"
	)
	assert_true(
		invalid_disposal_errors.has("DISPOSAL_YARD must accept WASTE_CRATE"),
		"a disposal yard must not accept ordinary delivery cargo"
	)

	var fractional_metadata: Variant = definition_script.create({
		"definition_schema_version": 3.5,
		"map_id": "FP_FRACTIONAL_META",
		"map_revision": 1.5,
		"ruleset_version": "fp_core_v1",
		"board_size": [7, 5],
		"start_cell": [1, 2],
		"incoming_cell": [0, 2],
		"buildable_cells": [[2, 2]],
		"blocked_cells": [],
		"station_placements": [],
		"cargo_placements": [],
		"time_limit_seconds": 90.0,
	})
	var metadata_errors: Array[String] = fractional_metadata.validation_errors()
	assert_true(
		metadata_errors.has("definition_schema_version must be an integer"),
		"fractional schema version must not be truncated"
	)
	assert_true(
		metadata_errors.has("map_revision must be an integer"),
		"fractional map revision must not be truncated"
	)
