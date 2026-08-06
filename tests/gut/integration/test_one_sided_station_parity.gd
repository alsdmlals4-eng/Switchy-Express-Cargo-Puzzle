extends GutTest

const FiniteMapDefinitionScript := preload("res://game/finite/map/finite_map_definition.gd")
const TrackPieceScript := preload("res://game/finite/build/track_piece.gd")
const TrackLayoutScript := preload("res://game/finite/build/track_layout.gd")
const PreflightValidatorScript := preload("res://game/finite/build/preflight_validator.gd")
const FiniteRunSessionFactoryScript := preload("res://game/finite/run/finite_run_session_factory.gd")


func test_red_star_one_sided_station_finishes_successfully() -> void:
	_assert_one_sided_station_success(&"RED_STAR")


func test_blue_diamond_one_sided_station_finishes_successfully() -> void:
	_assert_one_sided_station_success(&"BLUE_DIAMOND")


func _assert_one_sided_station_success(cargo_type: StringName) -> void:
	var definition: Variant = FiniteMapDefinitionScript.create({
		"definition_schema_version": 2,
		"map_id": "GUT_ONE_SIDED_%s" % cargo_type,
		"map_revision": 1,
		"ruleset_version": "fp_core_v1",
		"marker_tracks_player_built": true,
		"allow_open_terminals_after_required": true,
		"board_size": [7, 3],
		"start_cell": [1, 1],
		"incoming_cell": [0, 1],
		"buildable_cells": [[2, 1], [3, 1], [4, 1], [5, 1]],
		"blocked_cells": [],
		"station_placements": [{"cell": [5, 1], "cargo_type": cargo_type}],
		"cargo_placements": [{"cell": [3, 1], "cargo_type": cargo_type}],
		"time_limit_seconds": 20.0,
	})
	assert_not_null(definition, "%s definition must be created" % cargo_type)
	if definition == null:
		return
	assert_eq(definition.validation_errors(), [], "%s definition must be valid" % cargo_type)

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
	assert_true(preflight.passed, "%s one-sided station must pass preflight" % cargo_type)
	if not preflight.passed or preflight.graph == null:
		return
	assert_eq(
		preflight.graph.neighbors(Vector2i(5, 1)),
		[Vector2i(4, 1)],
		"station must have exactly one reciprocal rail connection"
	)

	var snapshot := {
		"definition_identity": definition.identity_key(),
		"ruleset_version": str(definition.ruleset_version),
		"layout_signature": layout.layout_signature(),
		"layout": layout,
	}
	var factory: RefCounted = FiniteRunSessionFactoryScript.new()
	assert_true(factory.configure(definition, snapshot, 2.0), "station route must configure")
	var attempt: Dictionary = factory.create_attempt()
	assert_true(bool(attempt.get("success", false)), "station attempt must be created")
	var session: Variant = attempt.get("session")
	assert_not_null(session, "station session must exist")
	if session == null:
		return

	assert_true(session.input_state.toggle_auto_load(), "auto load must enable")
	assert_true(session.run_controller.start(), "station run must start")
	for _step: int in range(1000):
		var phase: StringName = session.run_controller.run_state().phase()
		if phase == &"SUCCESS" or phase == &"FAILURE":
			break
		session.run_controller.advance_time(0.05)

	assert_eq(
		session.run_controller.run_state().phase(),
		&"SUCCESS",
		"final delivery must resolve before terminal route exhaustion"
	)
