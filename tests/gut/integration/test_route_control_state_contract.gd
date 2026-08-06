extends GutTest

const TrackPieceScript := preload("res://game/finite/build/track_piece.gd")
const GraphScript := preload("res://game/finite/rail/finite_track_graph.gd")
const OverlayScript := preload("res://game/demo/presentation/route_control_overlay.gd")
const SWITCH_CELL := Vector2i(4, 1)
const CROSSING_CELL := Vector2i(1, 1)


func test_occupied_route_control_rejects_input_and_reports_lock() -> void:
	var graph: Variant = _graph()
	var before: Dictionary = _state_at(graph.route_control_states(), SWITCH_CELL)
	graph.set_route_control_locked_cell(SWITCH_CELL)
	assert_false(graph.cycle_route_control(SWITCH_CELL), "occupied switch must reject route input")
	var after: Dictionary = _state_at(graph.route_control_states(), SWITCH_CELL)
	assert_eq(after.get("selected_exit"), before.get("selected_exit"))
	assert_true(bool(after.get("locked", false)), "renderer state must expose occupancy lock")


func test_route_control_states_round_trip_through_overlay_snapshot() -> void:
	var graph: Variant = _graph()
	var states: Array = graph.route_control_states()
	var switch_state: Dictionary = _state_at(states, SWITCH_CELL)
	var crossing_state: Dictionary = _state_at(states, CROSSING_CELL)
	assert_eq(switch_state.get("kind"), &"SWITCH")
	assert_true(switch_state.has("approach_port"))
	assert_true(switch_state.has("selected_exit"))
	assert_eq(crossing_state.get("kind"), &"CROSSING")
	assert_true(crossing_state.has("mode"))

	var overlay: Control = OverlayScript.new()
	var snapshot := {"board_size": Vector2i(7, 3), "route_controls": states}
	overlay.apply_snapshot(snapshot)
	assert_eq(overlay.snapshot_for_test(), snapshot, "overlay must preserve renderer/input state")
	overlay.free()


func _graph() -> Variant:
	var pieces: Array[Variant] = [
		TrackPieceScript.create(CROSSING_CELL, &"CROSSING", 0, Vector2i.ZERO),
		TrackPieceScript.create(Vector2i(0, 1), &"STRAIGHT", 0, Vector2i.ZERO),
		TrackPieceScript.create(Vector2i(2, 1), &"STRAIGHT", 0, Vector2i.ZERO),
		TrackPieceScript.create(Vector2i(1, 0), &"STRAIGHT", 1, Vector2i.ZERO),
		TrackPieceScript.create(Vector2i(1, 2), &"STRAIGHT", 1, Vector2i.ZERO),
		TrackPieceScript.create(SWITCH_CELL, &"SWITCH", 0, Vector2i.RIGHT),
		TrackPieceScript.create(Vector2i(3, 1), &"STRAIGHT", 0, Vector2i.ZERO),
		TrackPieceScript.create(Vector2i(5, 1), &"STRAIGHT", 0, Vector2i.ZERO),
		TrackPieceScript.create(Vector2i(4, 0), &"STRAIGHT", 1, Vector2i.ZERO),
	]
	return GraphScript.new(pieces)


static func _state_at(states: Array, cell: Vector2i) -> Dictionary:
	for value: Variant in states:
		if value is Dictionary and value.get("cell") == cell:
			return value
	return {}
