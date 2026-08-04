extends RefCounted

const MAP_PATH := "res://data/maps/fp_core_proof_01.json"
const LOADER_PATH := "res://game/finite/map/finite_map_loader.gd"
const BUILD_SESSION_PATH := "res://game/finite/build/finite_build_session.gd"
const ALPHA_PATH := "res://tests/fixtures/finite/fp_core_solution_alpha.gd"


static func sealed_inputs() -> Dictionary:
	var loader_script: Script = load(LOADER_PATH)
	var build_session_script: Script = load(BUILD_SESSION_PATH)
	var alpha_script: Script = load(ALPHA_PATH)
	var definition: Variant = loader_script.load_from_path(MAP_PATH)
	var build_session: Variant = build_session_script.new(definition)
	for piece: Variant in alpha_script.pieces():
		var result: Variant = build_session.place_piece(piece)
		if not result.success:
			return {}
	var preflight: Variant = build_session.begin_run()
	if preflight == null or not preflight.passed:
		return {}
	return {
		"definition": definition,
		"sealed": build_session.sealed_snapshot(),
	}
