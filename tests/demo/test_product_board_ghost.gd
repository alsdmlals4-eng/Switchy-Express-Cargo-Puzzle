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
		"selected_rotation_quarters": 0,
		"phase": &"BUILD",
		"train_cell": Vector2i(-1, -1),
		"train_next_cell": Vector2i(-1, -1),
		"switch_cells": [],
		"stack_tokens": [],
	})

	assert_true(renderer.has_method("ghost_descriptor_for_test"), "renderer must expose ghost state for verification")
	assert_true(renderer.has_method("semantic_build_descriptor_for_test"), "renderer must expose bounded semantic BUILD diagnostics")
	if not renderer.has_method("ghost_descriptor_for_test"):
		renderer.free()
		return

	_move_mouse(renderer, Vector2i(5, 4))
	var blocked: Dictionary = renderer.ghost_descriptor_for_test()
	assert_equal(blocked.get("cell"), Vector2i(5, 4), "ghost tracks the exact hovered cell")
	assert_equal(blocked.get("geometry"), &"STRAIGHT", "ghost preserves selected geometry")
	assert_false(bool(blocked.get("valid", true)), "blocked cell ghost must be invalid")
	if renderer.has_method("semantic_build_descriptor_for_test"):
		var blocked_semantic: Dictionary = renderer.semantic_build_descriptor_for_test()
		assert_equal(blocked_semantic.get("placement_state", &""), &"invalid", "invalid ghost selects invalid semantic reinforcement")
		assert_equal(
			blocked_semantic.get("placement_paths", []),
			["art/product_assets/ed_hybrid_v1/build/build_placement_invalid_overlay_v01.png"],
			"invalid ghost resolves exact BUILD semantic overlay"
		)

	_move_mouse(renderer, Vector2i(2, 4))
	var buildable: Dictionary = renderer.ghost_descriptor_for_test()
	assert_equal(buildable.get("cell"), Vector2i(2, 4), "ghost moves with hover")
	assert_true(bool(buildable.get("valid", false)), "buildable cell ghost must be valid")
	if renderer.has_method("semantic_build_descriptor_for_test"):
		var valid_semantic: Dictionary = renderer.semantic_build_descriptor_for_test()
		assert_equal(valid_semantic.get("placement_state", &""), &"valid", "ordinary valid ghost selects valid semantic state")
		assert_equal(
			valid_semantic.get("placement_paths", []),
			["art/product_assets/ed_hybrid_v1/build/build_placement_valid_overlay_v01.png"],
			"valid ghost resolves exact BUILD semantic overlay"
		)

	var rotated_snapshot: Dictionary = renderer.snapshot_for_test()
	rotated_snapshot["selected_rotation_quarters"] = 1
	rotated_snapshot["layout_pieces"] = []
	renderer.apply_snapshot(rotated_snapshot)
	_move_mouse(renderer, Vector2i(2, 4))
	assert_equal(renderer.ghost_descriptor_for_test().get("rotation_quarters"), 1, "procedural ghost keeps selected rotation")
	if renderer.has_method("semantic_build_descriptor_for_test"):
		assert_equal(
			renderer.semantic_build_descriptor_for_test().get("placement_state", &""),
			&"rotate_preview",
			"rotated valid ghost selects rotate-preview semantic state"
		)

	var replacement_snapshot: Dictionary = renderer.snapshot_for_test()
	replacement_snapshot["layout_pieces"] = [{
		"cell": Vector2i(2, 4),
		"geometry": &"CURVE",
		"rotation_quarters": 0,
	}]
	renderer.apply_snapshot(replacement_snapshot)
	_move_mouse(renderer, Vector2i(2, 4))
	assert_true(bool(renderer.ghost_descriptor_for_test().get("valid", false)), "replacement keeps existing procedural validity")
	if renderer.has_method("semantic_build_descriptor_for_test"):
		var replacement_semantic: Dictionary = renderer.semantic_build_descriptor_for_test()
		assert_equal(
			replacement_semantic.get("placement_state", &""),
			&"replacement_preview",
			"existing piece at ghost cell outranks rotation for semantic replacement state"
		)
		assert_equal(
			replacement_semantic.get("placement_paths", []),
			["art/product_assets/ed_hybrid_v1/build/build_placement_replacement_preview_overlay_v01.png"],
			"replacement resolves exact BUILD overlay"
		)

	var focused_snapshot: Dictionary = renderer.snapshot_for_test()
	focused_snapshot["problem_cells"] = [Vector2i(7, 4)]
	renderer.apply_snapshot(focused_snapshot)
	if renderer.has_method("semantic_build_descriptor_for_test"):
		var focused_semantic: Dictionary = renderer.semantic_build_descriptor_for_test()
		assert_equal(focused_semantic.get("preflight_focus_state", &""), &"focused_location", "existing problem cells enable focused preflight reinforcement")
		assert_equal(
			focused_semantic.get("preflight_focus_paths", []),
			[
				"art/product_assets/ed_hybrid_v1/build/build_preflight_shell_v01.png",
				"art/product_assets/ed_hybrid_v1/build/build_preflight_focused_location_marker_v01.png",
			],
			"focused preflight resolves exact approved composition"
		)
	assert_equal(renderer.snapshot_for_test()["problem_cells"], [Vector2i(7, 4)], "semantic lookup cannot mutate existing problem cells")

	var running_snapshot: Dictionary = renderer.snapshot_for_test()
	running_snapshot["phase"] = &"RUNNING"
	renderer.apply_snapshot(running_snapshot)
	assert_true(renderer.ghost_descriptor_for_test().is_empty(), "ghost disappears outside BUILD")
	if renderer.has_method("semantic_build_descriptor_for_test"):
		assert_equal(renderer.semantic_build_descriptor_for_test().get("placement_state", &""), &"", "non-BUILD has no placement semantic state")

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
