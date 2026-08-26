extends "res://tests/test_case.gd"

const DEFINITION_PATH := "res://game/finite/map/finite_map_definition.gd"
const EXPECTED_ERROR := "incoming_cell must be immediately left of start_cell"


func run() -> void:
	var definition_script: Script = load(DEFINITION_PATH)
	var vertical: Variant = definition_script.create(_definition_data([1, 2], [1, 1]))
	assert_true(
		vertical.validation_errors().has(EXPECTED_ERROR),
		"vertical incoming direction must be rejected before graph building"
	)

	var distant: Variant = definition_script.create(_definition_data([2, 1], [0, 1]))
	assert_true(
		distant.validation_errors().has(EXPECTED_ERROR),
		"non-adjacent incoming direction must be rejected before graph building"
	)


func _definition_data(start_cell: Array, incoming_cell: Array) -> Dictionary:
	return {
		"definition_schema_version": 3,
		"map_id": "FP_START_DIRECTION",
		"map_revision": 1,
		"ruleset_version": "fp_core_v1",
		"board_size": [5, 4],
		"start_cell": start_cell,
		"incoming_cell": incoming_cell,
		"buildable_cells": [[3, 1]],
		"blocked_cells": [],
		"station_placements": [],
		"cargo_placements": [],
		"time_limit_seconds": 90.0,
	}
