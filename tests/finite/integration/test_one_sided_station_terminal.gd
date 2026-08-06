extends "res://tests/test_case.gd"

const FiniteMapDefinitionScript := preload("res://game/finite/map/finite_map_definition.gd")
const TrackPieceScript := preload("res://game/finite/build/track_piece.gd")
const TrackLayoutScript := preload("res://game/finite/build/track_layout.gd")
const PreflightValidatorScript := preload("res://game/finite/build/preflight_validator.gd")
const FiniteRunSessionFactoryScript := preload("res://game/finite/run/finite_run_session_factory.gd")


func run() -> void:
	var definition: Variant = FiniteMapDefinitionScript.create({
		"definition_schema_version": 2,
		"map_id": "ONE_SIDED_STATION_TERMINAL",
		"map_revision": 1,
		"ruleset_version": "fp_core_v1",
		"marker_tracks_player_built": true,
		"allow_open_terminals_after_required": true,
		"board_size": [7, 3],
		"start_cell": [1, 1],
		"incoming_cell": [0, 1],
		"buildable_cells": [[2, 1], [3, 1], [4, 1], [5, 1]],
		"blocked_cells": [],
		"station_placements": [{
			"cell": [5, 1],
			"cargo_type": "RED_STAR",
		}],
		"cargo_placements": [{
			"cell": [3, 1],
			"cargo_type": "RED_STAR",
		}],
		"time_limit_seconds": 20.0,
	})
	assert_not_null(definition, "one-sided station definition must be created")
	if definition == null:
		return
	assert_equal(definition.validation_errors(), [], "one-sided station definition must be valid")

	var layout: Variant = TrackLayoutScript.new()
	for x: int in [2, 3, 4, 5]:
		var piece: Variant = TrackPieceScript.create(
			Vector2i(x, 1),
			&"STRAIGHT",
			0,
			Vector2i.ZERO
		)
		assert_not_null(piece, "terminal route piece must be created")
		if piece != null:
			assert_true(layout.put_piece(piece), "terminal route piece must be installed")

	var preflight: Variant = PreflightValidatorScript.new().validate(definition, layout)
	assert_true(preflight.passed, "a reachable station with one reciprocal neighbor must pass")
	assert_equal(preflight.primary_code, &"PASS", "one-sided station must not be disconnected")
	assert_equal(preflight.problem_cells, [], "one-sided station must not be highlighted")
	if not preflight.passed or preflight.graph == null:
		return

	var station_cell := Vector2i(5, 1)
	assert_equal(
		preflight.graph.neighbors(station_cell),
		[Vector2i(4, 1)],
		"terminal station must have exactly one reciprocal rail connection"
	)

	var snapshot := {
		"definition_identity": definition.identity_key(),
		"ruleset_version": str(definition.ruleset_version),
		"layout_signature": layout.layout_signature(),
		"layout": layout,
	}
	var factory: RefCounted = FiniteRunSessionFactoryScript.new()
	assert_true(factory.configure(definition, snapshot, 2.0), "terminal station route must configure")
	var attempt: Dictionary = factory.create_attempt()
	assert_true(bool(attempt.get("success", false)), "terminal station attempt must be created")
	var session: Variant = attempt.get("session")
	assert_not_null(session, "terminal station session must exist")
	if session == null:
		return

	assert_true(session.input_state.toggle_auto_load(), "auto load must enable")
	assert_true(session.run_controller.start(), "terminal station run must start")
	for _step: int in range(1000):
		var phase: StringName = session.run_controller.run_state().phase()
		if phase == &"SUCCESS" or phase == &"FAILURE":
			break
		session.run_controller.advance_time(0.05)

	assert_equal(
		session.run_controller.run_state().phase(),
		&"SUCCESS",
		"final delivery at a one-sided station must complete before terminal track exhaustion"
	)
