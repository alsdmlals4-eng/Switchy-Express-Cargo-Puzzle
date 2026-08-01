class_name TrainController
extends RefCounted

const TrainStateScript := preload("res://game/train/train_state.gd")

var speed: float = 0.0
var _movement_progress: float = 0.0
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
	_movement_progress = 0.0


func set_speed(cells_per_second: float) -> void:
	speed = maxf(cells_per_second, 0.0)


func advance_time(delta_seconds: float) -> int:
	assert(_state != null, "TrainController must be configured before movement")
	if delta_seconds <= 0.0 or speed <= 0.0:
		return 0

	_movement_progress += delta_seconds * speed
	var crossed_cells := 0
	while _movement_progress >= 1.0:
		_movement_progress -= 1.0
		_commit_next_cell()
		crossed_cells += 1
	return crossed_cells


func advance_one_cell() -> Vector2i:
	assert(_state != null, "TrainController must be configured before movement")
	_movement_progress = 0.0
	return _commit_next_cell()


func movement_progress() -> float:
	return _movement_progress


func target_cell() -> Vector2i:
	assert(_state != null, "TrainController must be configured before target lookup")
	return _graph.next_cell(_state.current_cell, _state.previous_cell)


func locomotive_position(cell_size: Vector2 = Vector2.ONE) -> Vector2:
	var from_position := _scaled_cell(current_cell(), cell_size)
	var to_position := _scaled_cell(target_cell(), cell_size)
	return from_position.lerp(to_position, _movement_progress)


func wagon_positions(cell_size: Vector2 = Vector2.ONE) -> Array[Vector2]:
	var cells := train_cells()
	var positions: Array[Vector2] = []
	for index: int in range(1, cells.size()):
		var from_position := _scaled_cell(cells[index], cell_size)
		var to_position := _scaled_cell(cells[index - 1], cell_size)
		positions.append(from_position.lerp(to_position, _movement_progress))
	return positions


func train_positions(cell_size: Vector2 = Vector2.ONE) -> Array[Vector2]:
	var positions: Array[Vector2] = [locomotive_position(cell_size)]
	positions.append_array(wagon_positions(cell_size))
	return positions


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


func _commit_next_cell() -> Vector2i:
	var departing_cell: Vector2i = _state.current_cell
	var incoming_cell: Vector2i = _state.previous_cell
	var next: Vector2i = _graph.next_cell(departing_cell, incoming_cell)
	assert(next != incoming_cell, "train movement must not reverse immediately")
	_state.advance(next)
	if _graph.switch_cells().has(departing_cell):
		_graph.commit_switch_passage(departing_cell)
	return next


func _scaled_cell(cell: Vector2i, cell_size: Vector2) -> Vector2:
	return Vector2(cell) * cell_size
