extends "res://tests/test_case.gd"

const DEFINITION_PATH := "res://game/finite/map/finite_map_definition.gd"


func run() -> void:
	var definition_exists := ResourceLoader.exists(DEFINITION_PATH, "Script")
	assert_true(definition_exists, "finite map definition must exist")
	if not definition_exists:
		return

	var definition_script: Script = load(DEFINITION_PATH)
	var definition: Variant = definition_script.create({
		"definition_schema_version": 2,
		"map_id": "FP_TEST",
		"map_revision": 1,
		"ruleset_version": "fp_core_v1",
		"board_size": [7, 5],
		"start_cell": [1, 2],
		"incoming_cell": [0, 2],
		"buildable_cells": [[2, 1], [2, 2], [2, 3]],
		"blocked_cells": [[4, 2]],
		"station_placements": [{
			"cell": [5, 1],
			"cargo_type": "RED_STAR",
			"rail_anchor": {"geometry": "STRAIGHT", "rotation_quarters": 0},
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
	assert_equal(definition.definition_schema_version, 2, "finite pipeline must require schema v2")
	assert_equal(definition.required_anchor_cells().size(), 4, "start, incoming, station, and cargo anchors are required")

	var legacy: Variant = definition_script.create({"definition_schema_version": 1})
	assert_true(
		legacy.validation_errors().has("definition_schema_version must equal 2"),
		"schema v1 must not be silently upgraded"
	)

	var invalid: Variant = definition_script.create({
		"definition_schema_version": 2,
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
		"definition_schema_version": 2,
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
			"rail_anchor": {"geometry": "STRAIGHT", "rotation_quarters": 0},
		}],
		"cargo_placements": [],
		"time_limit_seconds": 90.0,
	})
	assert_true(
		missing_cell.validation_errors().has("station placement cell is required"),
		"missing placement cell must not silently become board origin"
	)
