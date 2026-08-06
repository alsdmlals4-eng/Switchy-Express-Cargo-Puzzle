extends "res://tests/test_case.gd"

const RendererScript := preload("res://game/demo/presentation/product_board_renderer.gd")


func run() -> void:
	var renderer: Control = RendererScript.new()
	renderer.size = Vector2(1100.0, 900.0)

	assert_equal(
		renderer.board_cell_from_local(Vector2(550.0, 450.0), Vector2i(11, 9)),
		Vector2i(5, 4),
		"board center must map to the center grid cell"
	)
	assert_equal(
		renderer.board_cell_from_local(Vector2(-1.0, 100.0), Vector2i(11, 9)),
		Vector2i(-1, -1),
		"positions outside the board must be rejected"
	)
	assert_equal(
		renderer.board_cell_from_local(Vector2(1099.0, 899.0), Vector2i(11, 9)),
		Vector2i(-1, -1),
		"outer padding must not dispatch a board cell"
	)

	assert_equal(
		RendererScript.snapshot_cell([4, 3]),
		Vector2i(4, 3),
		"JSON marker coordinates must normalize from Array to Vector2i"
	)
	assert_equal(
		RendererScript.snapshot_cell(Vector2i(6, 2)),
		Vector2i(6, 2),
		"typed marker coordinates must remain unchanged"
	)
	assert_equal(
		RendererScript.snapshot_cell([4]),
		Vector2i(-1, -1),
		"malformed marker coordinates must be rejected"
	)

	var source: Dictionary = {
		"map_id": &"VS_DEMO_01",
		"board_size": Vector2i(11, 9),
		"blocked_cells": [Vector2i(4, 3)],
		"layout_pieces": [],
		"station_placements": [],
		"cargo_placements": [],
		"problem_cells": [],
		"selected_cell": Vector2i(3, 4),
		"selected_geometry": &"STRAIGHT",
		"phase": &"BUILD",
		"train_cell": Vector2i(-1, -1),
		"train_next_cell": Vector2i(-1, -1),
		"switch_cells": [],
		"stack_tokens": [],
	}
	renderer.apply_snapshot(source)
	source["map_id"] = &"BROKEN"
	source["blocked_cells"].append(Vector2i(9, 9))
	var stored: Dictionary = renderer.snapshot_for_test()
	assert_equal(stored["map_id"], &"VS_DEMO_01", "renderer stores a deep snapshot copy")
	assert_equal(stored["blocked_cells"], [Vector2i(4, 3)], "source arrays cannot mutate renderer")

	var primary_cells: Array[Vector2i] = []
	var secondary_cells: Array[Vector2i] = []
	renderer.cell_primary_requested.connect(
		func(cell: Vector2i) -> void: primary_cells.append(cell)
	)
	renderer.cell_secondary_requested.connect(
		func(cell: Vector2i) -> void: secondary_cells.append(cell)
	)
	renderer.request_primary_at(Vector2(550.0, 450.0))
	renderer.request_secondary_at(Vector2(550.0, 450.0))
	assert_equal(primary_cells, [Vector2i(5, 4)], "primary requests preserve exact cell")
	assert_equal(secondary_cells, [Vector2i(5, 4)], "secondary requests preserve exact cell")

	renderer.free()
