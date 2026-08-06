extends "res://tests/test_case.gd"

const MAP_PATH := "res://data/maps/vs_demo_01.json"
const MapLoaderScript := preload("res://game/finite/map/finite_map_loader.gd")
const BuildSessionScript := preload("res://game/finite/build/finite_build_session.gd")
const TrackPieceScript := preload("res://game/finite/build/track_piece.gd")
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

	var marker_pieces: Array[Variant] = _marker_pieces(definition)
	assert_equal(marker_pieces.size(), 6, "demo route must include six editable marker cells")
	if marker_pieces.size() != 6:
		return

	var edit_session: Variant = BuildSessionScript.new(definition)
	for piece: Variant in marker_pieces:
		var place_result: Variant = edit_session.place_piece(piece)
		assert_true(
			place_result != null and bool(place_result.success),
			"every station and cargo cell must accept player track placement"
		)

	var edit_cell: Vector2i = marker_pieces[0].cell
	var rotate_result: Variant = edit_session.rotate_piece(edit_cell, 1)
	assert_true(
		rotate_result != null and bool(rotate_result.success),
		"a player track on a station or cargo cell must rotate"
	)
	var remove_result: Variant = edit_session.remove_piece(edit_cell)
	assert_true(
		remove_result != null and bool(remove_result.success),
		"a player track on a station or cargo cell must be removable"
	)
	var restore_result: Variant = edit_session.place_piece(marker_pieces[0])
	assert_true(
		restore_result != null and bool(restore_result.success),
		"a removed marker-cell track must be placeable again"
	)

	var complete_layout: Array[Variant] = AlphaSolutionScript.pieces()
	complete_layout.append_array(marker_pieces)
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


static func _marker_pieces(definition: Variant) -> Array[Variant]:
	var result: Array[Variant] = []
	var placements: Array = []
	placements.append_array(definition.station_placements)
	placements.append_array(definition.cargo_placements)
	for value: Variant in placements:
		if not value is Dictionary:
			return []
		var placement: Dictionary = value
		var anchor_value: Variant = placement.get("rail_anchor", null)
		if not anchor_value is Dictionary:
			return []
		var anchor: Dictionary = anchor_value
		var cell := _read_cell(placement.get("cell", []))
		var geometry := StringName(anchor.get("geometry", &""))
		var rotation := int(anchor.get("rotation_quarters", 0))
		var switch_exit := Vector2i.ZERO
		if geometry == &"SWITCH":
			switch_exit = _rotate_clockwise(Vector2i.RIGHT, rotation)
		var piece: Variant = TrackPieceScript.create(cell, geometry, rotation, switch_exit)
		if piece == null:
			return []
		result.append(piece)
	return result


static func _read_cell(raw: Variant) -> Vector2i:
	if raw is Vector2i:
		return raw
	if raw is Array and raw.size() == 2:
		return Vector2i(int(raw[0]), int(raw[1]))
	if raw is Dictionary:
		return Vector2i(int(raw.get("x", 0)), int(raw.get("y", 0)))
	return Vector2i(-1, -1)


static func _rotate_clockwise(direction: Vector2i, quarter_turns: int) -> Vector2i:
	var result := direction
	for _index: int in range(posmod(quarter_turns, 4)):
		result = Vector2i(-result.y, result.x)
	return result
