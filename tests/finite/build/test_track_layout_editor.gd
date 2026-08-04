extends "res://tests/test_case.gd"

const DEFINITION_PATH := "res://game/finite/map/finite_map_definition.gd"
const PIECE_PATH := "res://game/finite/build/track_piece.gd"
const LAYOUT_PATH := "res://game/finite/build/track_layout.gd"
const EDITOR_PATH := "res://game/finite/build/track_layout_editor.gd"
const RESULT_PATH := "res://game/finite/build/track_edit_result.gd"


func run() -> void:
	var editor_exists := ResourceLoader.exists(EDITOR_PATH, "Script")
	var result_exists := ResourceLoader.exists(RESULT_PATH, "Script")
	assert_true(editor_exists, "finite track layout editor must exist")
	assert_true(result_exists, "finite track edit result must exist")
	if not editor_exists or not result_exists:
		return

	var definition_script: Script = load(DEFINITION_PATH)
	var piece_script: Script = load(PIECE_PATH)
	var layout_script: Script = load(LAYOUT_PATH)
	var editor_script: Script = load(EDITOR_PATH)
	var definition: Variant = definition_script.create({
		"definition_schema_version": 2,
		"map_id": "FP_EDITOR_TEST",
		"map_revision": 1,
		"ruleset_version": "fp_core_v1",
		"board_size": [7, 5],
		"start_cell": [1, 2],
		"incoming_cell": [0, 2],
		"buildable_cells": [[2, 2], [3, 2], [3, 3], [5, 2]],
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
	assert_equal(definition.validation_errors(), [], "editor fixture definition must be valid")

	var layout: Variant = layout_script.new()
	var editor: Variant = editor_script.new(definition, layout)
	var before_signature: String = layout.layout_signature()
	var invalid: Variant = editor.place_piece(
		piece_script.create(Vector2i(4, 2), &"STRAIGHT", 0, Vector2i.ZERO)
	)
	assert_false(invalid.success, "blocked cell placement must fail")
	assert_equal(invalid.code, &"BLOCKED_CELL", "blocked reason must be stable")
	assert_equal(layout.layout_signature(), before_signature, "failed edit must not mutate layout")
	assert_equal(invalid.cost_before, 0, "failed edit must report prior cost")
	assert_equal(invalid.cost_after, 0, "failed edit must preserve cost")

	var placed: Variant = editor.place_piece(
		piece_script.create(Vector2i(2, 2), &"STRAIGHT", 0, Vector2i.ZERO)
	)
	assert_true(placed.success, "buildable placement must pass")
	assert_equal(placed.code, &"PASS", "successful edit code must be stable")
	assert_equal(placed.cost_after, 100, "place must add current cost")
	assert_equal(placed.affected_cells, [Vector2i(2, 2)], "place must report affected cell")

	var occupied_signature: String = layout.layout_signature()
	var occupied: Variant = editor.place_piece(
		piece_script.create(Vector2i(2, 2), &"CURVE", 0, Vector2i.ZERO)
	)
	assert_false(occupied.success, "duplicate placement must fail")
	assert_equal(occupied.code, &"OCCUPIED_CELL", "duplicate reason must be stable")
	assert_equal(layout.layout_signature(), occupied_signature, "duplicate failure must be transactional")

	var rotated: Variant = editor.rotate_piece(Vector2i(2, 2), 1)
	assert_true(rotated.success, "occupied buildable piece must rotate")
	assert_equal(layout.piece_at(Vector2i(2, 2)).rotation_quarters, 1, "rotation must commit once")
	assert_equal(rotated.cost_after, 100, "rotation must preserve cost")

	var replaced: Variant = editor.replace_piece(
		piece_script.create(Vector2i(2, 2), &"SWITCH", 0, Vector2i.RIGHT)
	)
	assert_true(replaced.success, "occupied buildable piece must be replaceable")
	assert_equal(replaced.cost_before, 100, "replace must report old cost")
	assert_equal(replaced.cost_after, 200, "replace must report new cost")

	var anchor: Variant = editor.place_piece(
		piece_script.create(Vector2i(1, 2), &"STRAIGHT", 0, Vector2i.ZERO)
	)
	assert_false(anchor.success, "authored start anchor must not be editable")
	assert_equal(anchor.code, &"AUTHORED_ANCHOR", "anchor reason must be stable")

	var outside: Variant = editor.place_piece(
		piece_script.create(Vector2i(8, 2), &"STRAIGHT", 0, Vector2i.ZERO)
	)
	assert_false(outside.success, "outside-board placement must fail")
	assert_equal(outside.code, &"OUTSIDE_BOARD", "outside reason must be stable")

	var not_buildable: Variant = editor.place_piece(
		piece_script.create(Vector2i(6, 2), &"STRAIGHT", 0, Vector2i.ZERO)
	)
	assert_false(not_buildable.success, "non-buildable placement must fail")
	assert_equal(not_buildable.code, &"NOT_BUILDABLE", "non-buildable reason must be stable")

	var invalid_piece: Variant = editor.place_piece(null)
	assert_false(invalid_piece.success, "invalid piece must fail")
	assert_equal(invalid_piece.code, &"INVALID_PIECE", "invalid piece reason must be stable")

	var empty_remove: Variant = editor.remove_piece(Vector2i(3, 2))
	assert_false(empty_remove.success, "removing an empty cell must fail")
	assert_equal(empty_remove.code, &"EMPTY_CELL", "empty reason must be stable")

	var removed: Variant = editor.remove_piece(Vector2i(2, 2))
	assert_true(removed.success, "remove must pass")
	assert_equal(removed.cost_after, 0, "remove must fully refund")

	editor.place_piece(piece_script.create(Vector2i(2, 2), &"STRAIGHT", 0, Vector2i.ZERO))
	editor.place_piece(piece_script.create(Vector2i(3, 2), &"CURVE", 0, Vector2i.ZERO))
	var cleared: Variant = editor.clear_layout()
	assert_true(cleared.success, "clear layout must pass")
	assert_equal(cleared.cost_before, 200, "clear must report prior cost")
	assert_equal(cleared.cost_after, 0, "clear must fully refund")
	assert_equal(layout.pieces().size(), 0, "clear must remove all player pieces")
