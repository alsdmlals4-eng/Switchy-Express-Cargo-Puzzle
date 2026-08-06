extends "res://tests/test_case.gd"

const LoaderScript := preload("res://game/finite/map/finite_map_loader.gd")
const DEMO_MAP_PATH := "res://data/maps/vs_demo_01.json"
const PROOF_MAP_PATH := "res://data/maps/fp_core_proof_01.json"


func run() -> void:
	var definition: Variant = LoaderScript.load_from_path(DEMO_MAP_PATH)
	assert_not_null(definition, "demo map must load")
	if definition == null:
		return

	assert_equal(definition.identity_key(), "VS_DEMO_01@1", "demo map has independent identity")
	assert_equal(definition.board_size, Vector2i(11, 9), "demo board remains readable at 16:9")
	assert_equal(definition.time_limit_seconds, 120.0, "demo time limit supports first-play learning")
	assert_equal(definition.cargo_placements.size(), 4, "demo map has four authored cargo")
	assert_equal(definition.station_placements.size(), 2, "demo map has two station types")
	assert_true(definition.validation_errors().is_empty(), "demo map definition must validate")

	var proof: Variant = LoaderScript.load_from_path(PROOF_MAP_PATH)
	assert_not_null(proof, "proof map remains loadable")
	if proof != null:
		assert_equal(proof.map_id, &"FP_CORE_PROOF_01", "proof map identity remains unchanged")
		assert_not_equal(definition.map_id, proof.map_id, "demo and proof map identities remain separate")
		assert_equal(proof.time_limit_seconds, 90.0, "proof map timing remains unchanged")
