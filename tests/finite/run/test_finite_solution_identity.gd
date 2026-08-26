extends "res://tests/test_case.gd"

const IDENTITY_PATH := "res://game/finite/run/finite_solution_identity.gd"
const DEFINITION_PATH := "res://game/finite/map/finite_map_definition.gd"
const LAYOUT_PATH := "res://game/finite/build/track_layout.gd"
const PIECE_PATH := "res://game/finite/build/track_piece.gd"


func run() -> void:
	var identity_exists := ResourceLoader.exists(IDENTITY_PATH, "Script")
	assert_true(identity_exists, "finite solution identity must exist")
	if not identity_exists:
		return

	var identity_script: Script = load(IDENTITY_PATH)
	var base_definition: Variant = _definition(1, &"fp_core_v1")
	var first_layout: Variant = _layout(false, &"STRAIGHT", 0, Vector2i.RIGHT)
	var same_final_layout: Variant = _layout(true, &"STRAIGHT", 0, Vector2i.RIGHT)
	var first: Variant = identity_script.create(base_definition, first_layout, 1)
	var retry: Variant = identity_script.create(base_definition, same_final_layout, 2)

	assert_equal(first.map_identity, "FP_ID_TEST@1", "map identity must use exact authored revision")
	assert_equal(first.solution_identity, retry.solution_identity, "same map and final layout must preserve solution identity")
	assert_not_equal(first.attempt_identity, retry.attempt_identity, "retry must change attempt identity")
	assert_equal(first.attempt_serial, 1, "first attempt serial must be retained")
	assert_equal(retry.attempt_serial, 2, "retry attempt serial must be retained")

	var changed_revision: Variant = identity_script.create(
		_definition(2, &"fp_core_v1"),
		first_layout,
		1
	)
	var changed_ruleset: Variant = identity_script.create(
		_definition(1, &"fp_core_v2"),
		first_layout,
		1
	)
	var changed_geometry: Variant = identity_script.create(
		base_definition,
		_layout(false, &"CURVE", 0, Vector2i.RIGHT),
		1
	)
	var changed_rotation: Variant = identity_script.create(
		base_definition,
		_layout(false, &"STRAIGHT", 1, Vector2i.RIGHT),
		1
	)
	var changed_switch_exit: Variant = identity_script.create(
		base_definition,
		_layout(false, &"STRAIGHT", 0, Vector2i.UP),
		1
	)

	assert_not_equal(first.solution_identity, changed_revision.solution_identity, "map revision must change solution identity")
	assert_not_equal(first.solution_identity, changed_ruleset.solution_identity, "ruleset version must change solution identity")
	assert_not_equal(first.solution_identity, changed_geometry.solution_identity, "piece geometry must change solution identity")
	assert_not_equal(first.solution_identity, changed_rotation.solution_identity, "piece rotation must change solution identity")
	assert_not_equal(first.solution_identity, changed_switch_exit.solution_identity, "switch initial exit must change solution identity")

	var leaked_attempt: String = first.attempt_identity
	first.attempt_identity = "tampered"
	first.solution_identity = "tampered"
	first.map_identity = "tampered"
	first.attempt_serial = 99
	assert_equal(first.attempt_identity, leaked_attempt, "attempt identity must be immutable")
	assert_equal(first.map_identity, "FP_ID_TEST@1", "map identity must be immutable")
	assert_equal(first.attempt_serial, 1, "attempt serial must be immutable")


func _definition(revision: int, ruleset: StringName) -> Variant:
	var definition_script: Script = load(DEFINITION_PATH)
	return definition_script.create({
		"definition_schema_version": 3,
		"map_id": "FP_ID_TEST",
		"map_revision": revision,
		"ruleset_version": str(ruleset),
		"board_size": [8, 6],
		"start_cell": [1, 2],
		"incoming_cell": [0, 2],
		"buildable_cells": [[2, 2], [3, 2]],
		"blocked_cells": [],
		"station_placements": [],
		"cargo_placements": [],
		"time_limit_seconds": 90.0,
	})


func _layout(
	reverse_order: bool,
	first_geometry: StringName,
	first_rotation: int,
	switch_exit: Vector2i
) -> Variant:
	var layout_script: Script = load(LAYOUT_PATH)
	var piece_script: Script = load(PIECE_PATH)
	var layout: Variant = layout_script.new()
	var first: Variant = piece_script.create(Vector2i(2, 2), first_geometry, first_rotation, Vector2i.ZERO)
	var second: Variant = piece_script.create(Vector2i(3, 2), &"SWITCH", 0, switch_exit)
	if reverse_order:
		layout.put_piece(second)
		layout.put_piece(first)
	else:
		layout.put_piece(first)
		layout.put_piece(second)
	return layout
