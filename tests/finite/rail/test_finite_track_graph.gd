extends "res://tests/test_case.gd"

const DEFINITION_PATH := "res://game/finite/map/finite_map_definition.gd"
const PIECE_PATH := "res://game/finite/build/track_piece.gd"
const LAYOUT_PATH := "res://game/finite/build/track_layout.gd"
const BUILDER_PATH := "res://game/finite/rail/finite_track_graph_builder.gd"
const GRAPH_PATH := "res://game/finite/rail/finite_track_graph.gd"
const SWITCH_PATH := "res://game/finite/rail/finite_track_switch.gd"


func run() -> void:
	var builder_exists := ResourceLoader.exists(BUILDER_PATH, "Script")
	var graph_exists := ResourceLoader.exists(GRAPH_PATH, "Script")
	var switch_exists := ResourceLoader.exists(SWITCH_PATH, "Script")
	assert_true(builder_exists, "finite track graph builder must exist")
	assert_true(graph_exists, "finite track graph must exist")
	assert_true(switch_exists, "finite track switch must exist")
	if not builder_exists or not graph_exists or not switch_exists:
		return

	var definition_script: Script = load(DEFINITION_PATH)
	var piece_script: Script = load(PIECE_PATH)
	var layout_script: Script = load(LAYOUT_PATH)
	var builder_script: Script = load(BUILDER_PATH)
	var definition: Variant = definition_script.create({
		"definition_schema_version": 2,
		"map_id": "FP_GRAPH_TEST",
		"map_revision": 1,
		"ruleset_version": "fp_core_v1",
		"board_size": [10, 8],
		"start_cell": [1, 0],
		"incoming_cell": [0, 0],
		"buildable_cells": [
			[2, 3], [3, 2], [3, 3], [3, 4], [4, 3],
			[5, 3], [6, 2], [6, 3], [7, 3]
		],
		"blocked_cells": [],
		"station_placements": [{
			"cell": [8, 7],
			"cargo_type": "RED_STAR",
			"rail_anchor": {"geometry": "STRAIGHT", "rotation_quarters": 0},
		}],
		"cargo_placements": [{
			"cell": [9, 7],
			"cargo_type": "RED_STAR",
			"rail_anchor": {"geometry": "STRAIGHT", "rotation_quarters": 0},
		}],
		"time_limit_seconds": 90.0,
	})
	assert_equal(definition.validation_errors(), [], "graph fixture definition must be valid")

	var layout: Variant = layout_script.new()
	layout.put_piece(piece_script.create(Vector2i(2, 3), &"STRAIGHT", 0, Vector2i.ZERO))
	layout.put_piece(piece_script.create(Vector2i(3, 2), &"STRAIGHT", 1, Vector2i.ZERO))
	layout.put_piece(piece_script.create(Vector2i(3, 3), &"CROSSING", 0, Vector2i.ZERO))
	layout.put_piece(piece_script.create(Vector2i(3, 4), &"STRAIGHT", 1, Vector2i.ZERO))
	layout.put_piece(piece_script.create(Vector2i(4, 3), &"STRAIGHT", 0, Vector2i.ZERO))
	layout.put_piece(piece_script.create(Vector2i(5, 3), &"STRAIGHT", 0, Vector2i.ZERO))
	layout.put_piece(piece_script.create(Vector2i(6, 2), &"STRAIGHT", 1, Vector2i.ZERO))
	layout.put_piece(piece_script.create(Vector2i(6, 3), &"SWITCH", 0, Vector2i.RIGHT))
	layout.put_piece(piece_script.create(Vector2i(7, 3), &"STRAIGHT", 0, Vector2i.ZERO))

	var graph: Variant = builder_script.build(definition, layout)
	assert_not_null(graph, "valid pieces must build a graph")
	if graph == null:
		return

	assert_true(graph.has_cell(Vector2i(3, 3)), "crossing cell must exist")
	assert_true(graph.has_cell(Vector2i(6, 3)), "switch cell must exist")
	assert_true(graph.neighbors(Vector2i(3, 3)).has(Vector2i(2, 3)), "crossing must expose west physical neighbor")
	assert_true(graph.neighbors(Vector2i(3, 3)).has(Vector2i(3, 2)), "crossing must expose north physical neighbor")

	assert_equal(
		graph.next_cell(Vector2i(3, 3), Vector2i(2, 3)),
		Vector2i(4, 3),
		"west entry must exit east"
	)
	assert_equal(
		graph.next_cell(Vector2i(3, 3), Vector2i(3, 2)),
		Vector2i(3, 4),
		"north entry must exit south"
	)
	assert_not_equal(
		graph.next_cell(Vector2i(3, 3), Vector2i(2, 3)),
		Vector2i(3, 2),
		"crossing must never turn west entry north"
	)

	var switch_cell := Vector2i(6, 3)
	var approach_cell := Vector2i(5, 3)
	var right_exit := Vector2i(7, 3)
	var up_exit := Vector2i(6, 2)
	var first_exit: Vector2i = graph.next_cell(switch_cell, approach_cell)
	assert_equal(first_exit, right_exit, "switch initial exit must match authored state")
	assert_true(graph.cycle_switch(switch_cell), "unoccupied switch must cycle")
	var second_exit: Vector2i = graph.next_cell(switch_cell, approach_cell)
	assert_equal(second_exit, up_exit, "cycled switch must select the other exit")
	assert_not_equal(first_exit, second_exit, "switch state must change")
	graph.commit_switch_passage(switch_cell)
	assert_equal(
		graph.next_cell(switch_cell, approach_cell),
		second_exit,
		"passage must not auto-reset"
	)
	assert_equal(
		graph.next_cell(switch_cell, right_exit),
		approach_cell,
		"right exit entry must merge to approach"
	)
	assert_equal(
		graph.next_cell(switch_cell, up_exit),
		approach_cell,
		"upper exit entry must merge to approach"
	)
	assert_not_equal(
		graph.next_cell(switch_cell, right_exit),
		up_exit,
		"one exit must never cross directly to the other"
	)

	graph.set_switch_locked_cell(switch_cell)
	assert_false(graph.cycle_switch(switch_cell), "occupied switch must lock")
	assert_equal(graph.next_cell(switch_cell, approach_cell), second_exit, "locked switch state must persist")
	graph.set_switch_locked_cell(Vector2i(-1, -1))
	assert_true(graph.cycle_switch(switch_cell), "clearing occupied cell must unlock switch")
	graph.reset_switch_states()
	assert_equal(
		graph.next_cell(switch_cell, approach_cell),
		right_exit,
		"reset must restore authored initial exit"
	)
	assert_equal(graph.switch_cells(), [switch_cell], "switch cells must be deterministic and sorted")

	var preview: Array[Vector2i] = graph.preview_route(Vector2i(3, 3), Vector2i(2, 3), 4)
	assert_equal(preview[0], Vector2i(4, 3), "preview must begin with the next cell")
	assert_equal(preview[1], Vector2i(5, 3), "preview must preserve entry-aware crossing direction")
