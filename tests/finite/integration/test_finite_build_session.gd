extends "res://tests/test_case.gd"

const MAP_PATH := "res://data/maps/fp_core_proof_01.json"
const LOADER_PATH := "res://game/finite/map/finite_map_loader.gd"
const SESSION_PATH := "res://game/finite/build/finite_build_session.gd"
const ALPHA_PATH := "res://tests/fixtures/finite/fp_core_solution_alpha.gd"
const BETA_PATH := "res://tests/fixtures/finite/fp_core_solution_beta.gd"
const SCENE_PATH := "res://scenes/finite/finite_build_test.tscn"

const A: StringName = &"RED_STAR"
const B: StringName = &"BLUE_DIAMOND"


func run() -> void:
	var required_paths: Array[String] = [
		MAP_PATH, LOADER_PATH, SESSION_PATH, ALPHA_PATH, BETA_PATH, SCENE_PATH,
	]
	for path: String in required_paths:
		assert_true(ResourceLoader.exists(path) or FileAccess.file_exists(path), "%s must exist" % path)
	if not _all_paths_exist(required_paths):
		return

	var loader_script: Script = load(LOADER_PATH)
	var session_script: Script = load(SESSION_PATH)
	var definition: Variant = loader_script.load_from_path(MAP_PATH)
	assert_not_null(definition, "proof map must load")
	if definition == null:
		return

	assert_equal(definition.validation_errors(), [], "proof map definition must validate")
	assert_equal(definition.definition_schema_version, 2, "proof map schema must be v2")
	assert_equal(definition.map_id, &"FP_CORE_PROOF_01", "proof map id must be exact")
	assert_equal(definition.map_revision, 1, "proof map revision must be exact")
	assert_equal(definition.ruleset_version, &"fp_core_v1", "proof ruleset must be exact")
	assert_equal(definition.board_size, Vector2i(11, 9), "proof board size must be exact")
	assert_equal(definition.start_cell, Vector2i(1, 4), "proof start must be exact")
	assert_equal(definition.incoming_cell, Vector2i(0, 4), "proof incoming must be exact")
	assert_equal(definition.time_limit_seconds, 90.0, "proof time limit remains TEST_VALUE 90")
	assert_equal(
		definition.blocked_cells,
		[Vector2i(4, 3), Vector2i(6, 3), Vector2i(4, 5), Vector2i(6, 5)],
		"corrected blocked cells must be canonical y,x order"
	)
	assert_equal(definition.station_placements.size(), 2, "proof map must contain two stations")
	assert_equal(definition.cargo_placements.size(), 4, "proof map must contain four fixed cargo points")
	assert_equal(_placement_cells(definition.station_placements), [Vector2i(8, 5), Vector2i(10, 7)], "station cells must match correction")
	assert_equal(_placement_cells(definition.cargo_placements), [Vector2i(9, 4), Vector2i(10, 5), Vector2i(10, 6), Vector2i(9, 7)], "cargo order cells must match correction")
	assert_equal(_placement_types(definition.cargo_placements), [A, B, A, A], "proof cargo encounter contract must be A/B/A/A")
	assert_true(definition.buildable_cells.has(Vector2i(10, 8)), "corrected inclusive rect must reach x10,y8")
	for excluded: Vector2i in definition.required_anchor_cells() + definition.blocked_cells:
		assert_false(definition.buildable_cells.has(excluded), "fixed and blocked cells must not be buildable")
	assert_equal(definition.buildable_cells, _sorted_unique(definition.buildable_cells), "expanded buildable cells must be canonical")

	var scene: PackedScene = load(SCENE_PATH)
	assert_not_null(scene, "finite build test scene must load")
	if scene != null:
		var instance: Node = scene.instantiate()
		assert_not_null(instance.get_node_or_null("BoardPlaceholder"), "scene must expose board placeholder")
		assert_not_null(instance.get_node_or_null("Hud/Cost"), "scene must expose construction cost placeholder")
		assert_not_null(instance.get_node_or_null("Hud/Recommended"), "scene must expose recommended estimate placeholder")
		assert_not_null(instance.get_node_or_null("Hud/Status"), "scene must expose preflight status placeholder")
		instance.free()

	var signatures: Array[String] = []
	for fixture_path: String in [ALPHA_PATH, BETA_PATH]:
		var fixture_script: Script = load(fixture_path)
		var session: Variant = session_script.new(definition)
		for piece: Variant in fixture_script.pieces():
			var edit: Variant = session.place_piece(piece)
			assert_true(edit.success, "%s piece must be accepted" % fixture_path)
		var signature_before: String = session.layout_signature()
		var cost_before: int = session.current_cost()
		var preflight: Variant = session.begin_run()
		assert_true(preflight.passed, "%s must pass structural preflight" % fixture_path)
		assert_equal(session.phase(), &"RUN", "successful preflight must seal RUN phase")
		var snapshot: Dictionary = session.sealed_snapshot()
		assert_equal(snapshot["definition_identity"], "FP_CORE_PROOF_01@1", "snapshot must bind map identity")
		assert_equal(snapshot["layout_signature"], signature_before, "snapshot must bind layout identity")
		assert_equal(snapshot["construction_cost"], cost_before, "snapshot must bind final construction cost")
		assert_not_null(snapshot["graph"], "snapshot must carry the validated graph")
		var rejected: Variant = session.clear_layout()
		assert_false(rejected.success, "runtime phase must reject edits")
		assert_equal(rejected.code, &"PHASE_LOCKED", "sealed edit rejection must be stable")
		assert_equal(session.layout_signature(), signature_before, "rejected runtime edit must not mutate layout")
		var proof: Dictionary = _trace_proof(definition, snapshot["graph"], 96)
		assert_equal(proof["first_cargo_types"], [A, B, A, A], "%s must encounter A/B/A/A" % fixture_path)
		assert_true(proof["station_a_visits"] >= 2, "%s must permit A-station revisit" % fixture_path)
		signatures.append(signature_before)

	assert_not_equal(signatures[0], signatures[1], "alpha and beta must have distinct layout signatures")

	var failed_session: Variant = session_script.new(definition)
	var failed: Variant = failed_session.begin_run()
	assert_equal(failed.primary_code, &"EMPTY_LAYOUT", "empty build session must fail preflight")
	assert_equal(failed_session.phase(), &"BUILD", "failed preflight must remain editable")
	assert_true(failed_session.sealed_snapshot().is_empty(), "failed preflight must not create a snapshot")


func _trace_proof(definition: Variant, graph: Variant, step_limit: int) -> Dictionary:
	var cargo_by_cell: Dictionary = {}
	for placement: Dictionary in definition.cargo_placements:
		cargo_by_cell[_cell(placement["cell"])] = StringName(placement["cargo_type"])
	var station_a_cell := _cell(definition.station_placements[0]["cell"])
	var collected_cells: Dictionary = {}
	var first_cargo_types: Array[StringName] = []
	var station_a_visits := 0
	var previous: Vector2i = definition.incoming_cell
	var current: Vector2i = definition.start_cell
	for _step: int in range(step_limit):
		if cargo_by_cell.has(current) and not collected_cells.has(current):
			collected_cells[current] = true
			first_cargo_types.append(cargo_by_cell[current])
		if current == station_a_cell:
			station_a_visits += 1
		var next: Vector2i = graph.next_cell(current, previous)
		if next == current:
			break
		previous = current
		current = next
	return {
		"first_cargo_types": first_cargo_types,
		"station_a_visits": station_a_visits,
	}


func _placement_cells(placements: Array[Dictionary]) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for placement: Dictionary in placements:
		result.append(_cell(placement["cell"]))
	return result


func _placement_types(placements: Array[Dictionary]) -> Array[StringName]:
	var result: Array[StringName] = []
	for placement: Dictionary in placements:
		result.append(StringName(placement["cargo_type"]))
	return result


func _cell(raw: Variant) -> Vector2i:
	if raw is Vector2i:
		return raw
	return Vector2i(int(raw[0]), int(raw[1]))


func _all_paths_exist(paths: Array[String]) -> bool:
	for path: String in paths:
		if not ResourceLoader.exists(path) and not FileAccess.file_exists(path):
			return false
	return true


func _sorted_unique(cells: Array[Vector2i]) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for cell: Vector2i in cells:
		if not result.has(cell):
			result.append(cell)
	result.sort_custom(func(first: Vector2i, second: Vector2i) -> bool:
		if first.y != second.y:
			return first.y < second.y
		return first.x < second.x
	)
	return result
