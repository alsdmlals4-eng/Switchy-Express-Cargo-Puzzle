extends "res://tests/test_case.gd"

const MAP_PATH := "res://data/maps/fp_core_proof_01.json"
const Loader := preload("res://game/finite/map/finite_map_loader.gd")
const Session := preload("res://game/finite/build/finite_build_session.gd")
const Alpha := preload("res://tests/fixtures/finite/fp_core_solution_alpha.gd")


func run() -> void:
	var definition: Variant = Loader.load_from_path(MAP_PATH)
	var session: Variant = Session.new(definition)
	for piece: Variant in Alpha.pieces():
		assert_true(session.place_piece(piece).success, "alpha piece must be accepted")
	var expected_signature: String = session.layout_signature()
	assert_true(session.begin_run().passed, "alpha must seal successfully")

	var exposed: Dictionary = session.sealed_snapshot()
	exposed["layout"].clear()
	exposed["layout_signature"] = "tampered"

	var reread: Dictionary = session.sealed_snapshot()
	assert_equal(reread["layout_signature"], expected_signature, "snapshot fields must resist caller mutation")
	assert_equal(
		reread["layout"].layout_signature(),
		expected_signature,
		"snapshot layout must be returned as an independent copy"
	)
