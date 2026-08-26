extends "res://tests/test_case.gd"

const MAP_PATH := "res://data/maps/vs_demo_01.json"
const MapLoaderScript := preload("res://game/finite/map/finite_map_loader.gd")
const BuildSessionScript := preload("res://game/finite/build/finite_build_session.gd")
const ControllerScript := preload("res://game/finite/main/finite_slice_session_controller.gd")
const AlphaSolutionScript := preload("res://tests/fixtures/finite/vs_demo_solution_alpha.gd")


func run() -> void:
	var definition: Variant = MapLoaderScript.load_from_path(MAP_PATH)
	assert_not_null(definition, "demo map must load")
	if definition == null:
		return

	assert_true(
		definition.has_method("marker_tracks_are_player_built"),
		"demo map definition must expose marker-track ownership"
	)
	if not definition.has_method("marker_tracks_are_player_built"):
		return
	assert_true(
		definition.marker_tracks_are_player_built(),
		"station and cargo tracks must be player-built in the product demo"
	)

	var station_cells: Array[Vector2i] = _placement_cells(definition.station_placements)
	var cargo_cells: Array[Vector2i] = _placement_cells(definition.cargo_placements)
	assert_equal(station_cells.size(), 2, "demo map must expose two station service objects")
	assert_equal(cargo_cells.size(), 4, "demo map must expose four cargo contact cells")
	for placement: Dictionary in definition.station_placements:
		assert_false(placement.has("rail_anchor"), "stations must not carry prelaid track data")
	for placement: Dictionary in definition.cargo_placements:
		assert_false(placement.has("rail_anchor"), "cargo must not carry prelaid track data")
	for cell: Vector2i in station_cells:
		assert_false(definition.buildable_cells.has(cell), "station footprints must be off-track and non-buildable")
	for cell: Vector2i in cargo_cells:
		assert_true(definition.buildable_cells.has(cell), "cargo contact cells must remain buildable")

	var complete_layout: Array[Variant] = AlphaSolutionScript.pieces()
	var marker_pieces: Array[Variant] = []
	for piece: Variant in complete_layout:
		if cargo_cells.has(piece.cell):
			marker_pieces.append(piece)
	assert_equal(marker_pieces.size(), 4, "authored solution must include four cargo-cell tracks")
	if marker_pieces.size() != 4:
		return

	var edit_session: Variant = BuildSessionScript.new(definition)
	for piece: Variant in marker_pieces:
		var place_result: Variant = edit_session.place_piece(piece)
		assert_true(
			place_result != null and bool(place_result.success),
			"every cargo contact cell must accept player track placement"
		)

	var edit_cell: Vector2i = marker_pieces[0].cell
	var rotate_result: Variant = edit_session.rotate_piece(edit_cell, 1)
	assert_true(
		rotate_result != null and bool(rotate_result.success),
		"a player track on a cargo contact cell must rotate"
	)
	var remove_result: Variant = edit_session.remove_piece(edit_cell)
	assert_true(
		remove_result != null and bool(remove_result.success),
		"a player track on a cargo contact cell must be removable"
	)
	var restore_result: Variant = edit_session.place_piece(marker_pieces[0])
	assert_true(
		restore_result != null and bool(restore_result.success),
		"a removed marker-cell track must be placeable again"
	)

	var controller: RefCounted = ControllerScript.new()
	assert_true(controller.initialize(MAP_PATH), "demo controller must initialize")
	assert_true(
		controller.install_layout_for_test(complete_layout),
		"complete route including marker-cell tracks must install"
	)
	controller.request_command(&"START")
	assert_equal(controller.phase(), &"RUNNING", "complete route must pass preflight and start")
	if controller.phase() != &"RUNNING":
		return
	controller.request_command(&"AUTO_TOGGLE")

	for _step: int in range(5000):
		var phase: StringName = controller.phase()
		if phase == &"SUCCESS" or phase == &"FAILURE":
			break
		controller.advance_time(0.05)

	assert_equal(
		controller.phase(),
		&"SUCCESS",
		"authored player-built route must complete pickup and delivery within the limit"
	)
	var summary: Variant = controller.current_summary()
	assert_not_null(summary, "successful demo route must expose a summary")
	if summary != null:
		assert_true(
			summary.final_delivery_commit_time <= summary.time_limit_seconds,
			"final delivery must commit within the authored time limit"
		)


static func _placement_cells(placements: Array[Dictionary]) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for placement: Dictionary in placements:
		result.append(_read_cell(placement.get("cell", [])))
	return result


static func _read_cell(raw: Variant) -> Vector2i:
	if raw is Vector2i:
		return raw
	if raw is Array and raw.size() == 2:
		return Vector2i(int(raw[0]), int(raw[1]))
	if raw is Dictionary:
		return Vector2i(int(raw.get("x", 0)), int(raw.get("y", 0)))
	return Vector2i(-1, -1)
