extends "res://tests/test_case.gd"

const RendererScript := preload("res://game/demo/presentation/product_board_renderer.gd")


func run() -> void:
	var renderer: Control = RendererScript.new()
	renderer.size = Vector2(1100.0, 900.0)
	renderer.apply_snapshot({
		"map_id": &"VS_DEMO_01",
		"board_size": Vector2i(11, 9),
		"buildable_cells": _all_cells(Vector2i(11, 9)),
		"blocked_cells": [Vector2i(5, 4)],
		"layout_pieces": [],
		"station_placements": [],
		"cargo_placements": [],
		"problem_cells": [],
		"selected_cell": Vector2i(-1, -1),
		"selected_geometry": &"STRAIGHT",
		"phase": &"BUILD",
		"train_cell": Vector2i(-1, -1),
		"train_next_cell": Vector2i(-1, -1),
		"switch_cells": [],
		"stack_tokens": [],
	})

	assert_true(renderer.has_method("ghost_descriptor_for_test"), "renderer must expose ghost state for verification")
	if not renderer.has_method("ghost_descriptor_for_test"):
		renderer.free()
		return

	_move_mouse(renderer, Vector2i(5, 4))
	var blocked: Dictionary = renderer.ghost_descriptor_for_test()
	assert_equal(blocked.get("cell"), Vector2i(5, 4), "ghost tracks the exact hovered cell")
	assert_equal(blocked.get("geometry"), &"STRAIGHT", "ghost preserves selected geometry")
	assert_false(bool(blocked.get("valid", true)), "blocked cell ghost must be invalid")

	_move_mouse(renderer, Vector2i(2, 4))
	var buildable: Dictionary = renderer.ghost_descriptor_for_test()
	assert_equal(buildable.get("cell"), Vector2i(2, 4), "ghost moves with hover")
	assert_true(bool(buildable.get("valid", false)), "buildable cell ghost must be valid")

	var running_snapshot: Dictionary = renderer.snapshot_for_test()
	running_snapshot["phase"] = &"RUNNING"
	renderer.apply_snapshot(running_snapshot)
	assert_true(renderer.ghost_descriptor_for_test().is_empty(), "ghost disappears outside BUILD")

	renderer.free()


func _move_mouse(renderer: Control, cell: Vector2i) -> void:
	var event := InputEventMouseMotion.new()
	event.position = _local_for_cell(renderer, cell, Vector2i(11, 9))
	renderer._gui_input(event)


func _local_for_cell(renderer: Control, cell: Vector2i, board_size: Vector2i) -> Vector2:
	const PADDING := 24.0
	var available := renderer.size - Vector2(PADDING * 2.0, PADDING * 2.0)
	var cell_size := Vector2(
		available.x / float(board_size.x),
		available.y / float(board_size.y)
	)
	return Vector2(PADDING, PADDING) + (Vector2(cell) + Vector2(0.5, 0.5)) * cell_size


func _all_cells(board_size: Vector2i) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for y: int in range(board_size.y):
		for x: int in range(board_size.x):
			result.append(Vector2i(x, y))
	return result
