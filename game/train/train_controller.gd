class_name TrainController
extends RefCounted

const TrainStateScript := preload("res://game/train/train_state.gd")

var speed: float = 0.0
var _graph: Variant
var _state: Variant


func configure(
	graph: Variant,
	start_cell: Vector2i,
	incoming_cell: Vector2i,
	max_wagons: int = 8
) -> void:
	_graph = graph
	_state = TrainStateScript.new()
	_state.configure(graph, start_cell, incoming_cell, max_wagons)


func set_speed(cells_per_second: float) -> void:
	speed = maxf(cells_per_second, 0.0)


func advance_one_cell() -> Vector2i:
	assert(_state != null, "TrainController must be configured before movement")
	var departing_cell: Vector2i = _state.current_cell
	var incoming_cell: Vector2i = _state.previous_cell
	var next: Vector2i = _graph.next_cell(departing_cell, incoming_cell)
	assert(next != incoming_cell, "train movement must not reverse immediately")
	_state.advance(next)
	if _graph.switch_cells().has(departing_cell):
		_graph.commit_switch_passage(departing_cell)
	return next


func set_wagon_count(requested_count: int) -> void:
	_state.set_wagon_count(requested_count)


func wagon_count() -> int:
	return _state.wagon_count()


func current_cell() -> Vector2i:
	return _state.current_cell


func previous_cell() -> Vector2i:
	return _state.previous_cell


func wagon_cells() -> Array[Vector2i]:
	return _state.wagon_cells()


func train_cells() -> Array[Vector2i]:
	return _state.train_cells()


func history_size() -> int:
	return _state.history_size()
