extends "res://tests/test_case.gd"

const TrackPieceScript := preload("res://game/finite/build/track_piece.gd")
const GraphScript := preload("res://game/finite/rail/finite_track_graph.gd")


func run() -> void:
	var pieces: Array[Variant] = [
		TrackPieceScript.create(Vector2i(1, 1), &"CROSSING", 0, Vector2i.ZERO),
		TrackPieceScript.create(Vector2i(0, 1), &"STRAIGHT", 0, Vector2i.ZERO),
		TrackPieceScript.create(Vector2i(2, 1), &"STRAIGHT", 0, Vector2i.ZERO),
		TrackPieceScript.create(Vector2i(1, 0), &"STRAIGHT", 1, Vector2i.ZERO),
		TrackPieceScript.create(Vector2i(1, 2), &"STRAIGHT", 1, Vector2i.ZERO),
		TrackPieceScript.create(Vector2i(4, 1), &"SWITCH", 0, Vector2i.RIGHT),
		TrackPieceScript.create(Vector2i(3, 1), &"STRAIGHT", 0, Vector2i.ZERO),
		TrackPieceScript.create(Vector2i(5, 1), &"STRAIGHT", 0, Vector2i.ZERO),
		TrackPieceScript.create(Vector2i(4, 0), &"STRAIGHT", 1, Vector2i.ZERO),
	]
	var graph: RefCounted = GraphScript.new(pieces)
	assert_true(graph.has_method("route_control_cells"), "graph must expose all interactive route controls")
	assert_true(graph.has_method("cycle_route_control"), "graph must cycle switch and crossing routes")
	assert_true(graph.has_method("route_control_states"), "graph must expose renderer-ready route states")
	if not graph.has_method("route_control_cells"):
		return

	assert_true(graph.route_control_cells().has(Vector2i(1, 1)), "crossing must be interactive")
	assert_true(graph.route_control_cells().has(Vector2i(4, 1)), "switch must remain interactive")
	assert_equal(graph.next_cell(Vector2i(1, 1), Vector2i(0, 1)), Vector2i(2, 1), "crossing starts in straight mode")
	assert_true(graph.cycle_route_control(Vector2i(1, 1)), "crossing click must change route")
	assert_equal(graph.next_cell(Vector2i(1, 1), Vector2i(0, 1)), Vector2i(1, 2), "first crossing click turns right")
	assert_true(graph.cycle_route_control(Vector2i(1, 1)), "crossing must cycle again")
	assert_equal(graph.next_cell(Vector2i(1, 1), Vector2i(0, 1)), Vector2i(1, 0), "second crossing click turns left")

	var states: Array = graph.route_control_states()
	assert_equal(states.size(), 2, "switch and crossing states must both be exposed")
	var crossing_state: Dictionary = _state_at(states, Vector2i(1, 1))
	var switch_state: Dictionary = _state_at(states, Vector2i(4, 1))
	assert_equal(crossing_state.get("kind"), &"CROSSING", "crossing state identifies its kind")
	assert_equal(crossing_state.get("mode"), &"LEFT", "crossing state exposes active route")
	assert_equal(switch_state.get("kind"), &"SWITCH", "switch state identifies its kind")
	assert_true(switch_state.has("selected_exit"), "switch state exposes selected exit")


static func _state_at(states: Array, cell: Vector2i) -> Dictionary:
	for value: Variant in states:
		if value is Dictionary and value.get("cell") == cell:
			return value
	return {}
