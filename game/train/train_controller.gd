class_name TrainController
extends RefCounted

signal cell_entered(cell: Vector2i)

const TrainStateScript := preload("res://game/train/train_state.gd")
const NO_LOCKED_SWITCH := Vector2i(-1, -1)

var speed: float = 0.0
var _movement_progress: float = 0.0
var _target_cell: Vector2i = Vector2i.ZERO
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
	_set_switch_lock(NO_LOCKED_SWITCH)
	if _route_control_cells().has(start_cell):
		_set_switch_lock(start_cell)
	_refresh_target()


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


func seconds_to_next_cell() -> float:
	assert(_state != null, "TrainController must be configured before boundary lookup")
	if speed <= 0.0:
		return INF
	return maxf((1.0 - _movement_progress) / speed, 0.0)


func target_cell() -> Vector2i:
	assert(_state != null, "TrainController must be configured before target lookup")
	return _target_cell


func forward_cells(step_count: int) -> Array[Vector2i]:
	assert(_state != null, "TrainController must be configured before route lookup")
	var result: Array[Vector2i] = []
	if step_count <= 0:
		return result

	result.append(_target_cell)
	if step_count == 1:
		return result

	result.append_array(
		_graph.preview_route(
			_target_cell,
			_state.current_cell,
			step_count - 1
		)
	)
	return result


func route_history_cells() -> Array[Vector2i]:
	assert(_state != null, "TrainController must be configured before history lookup")
	var result: Array[Vector2i] = []
	result.append_array(_state.route_history)
	return result


func locomotive_position(cell_size: Vector2 = Vector2.ONE) -> Vector2:
	var from_position := _scaled_cell(current_cell(), cell_size)
	var to_position := _scaled_cell(target_cell(), cell_size)
	return from_position.lerp(to_position, _movement_progress)


func sample_trailing_position(
	trailing_distance_cells: float,
	cell_size: Vector2 = Vector2.ONE
) -> Vector2:
	assert(_state != null, "TrainController must be configured before path sampling")
	var points: Array[Vector2] = []
	points.append(Vector2(current_cell()).lerp(Vector2(target_cell()), _movement_progress))
	for cell: Vector2i in _state.route_history:
		points.append(Vector2(cell))

	var remaining := maxf(trailing_distance_cells, 0.0)
	for index: int in range(points.size() - 1):
		var from_point: Vector2 = points[index]
		var to_point: Vector2 = points[index + 1]
		var segment_length := from_point.distance_to(to_point)
		if segment_length <= 0.000001:
			continue
		if remaining <= segment_length:
			return from_point.lerp(to_point, remaining / segment_length) * cell_size
		remaining -= segment_length
	return points[points.size() - 1] * cell_size


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
	var next: Vector2i = _target_cell
	assert(_graph.neighbors(departing_cell).has(next), "locked train target must remain connected")
	assert(next != incoming_cell, "train movement must not reverse immediately")
	if _route_control_cells().has(departing_cell):
		_graph.commit_switch_passage(departing_cell)
		_set_switch_lock(NO_LOCKED_SWITCH)
	_state.advance(next)
	if _route_control_cells().has(next):
		_set_switch_lock(next)
	_refresh_target()
	cell_entered.emit(next)
	return next


func _refresh_target() -> void:
	_target_cell = _graph.next_cell(_state.current_cell, _state.previous_cell)


func _set_switch_lock(cell: Vector2i) -> void:
	if _graph == null:
		return
	if _graph.has_method("set_route_control_locked_cell"):
		_graph.set_route_control_locked_cell(cell)
	elif _graph.has_method("set_switch_locked_cell"):
		_graph.set_switch_locked_cell(cell)


func _route_control_cells() -> Array[Vector2i]:
	if _graph == null:
		return []
	if _graph.has_method("route_control_cells"):
		return _graph.route_control_cells()
	return _graph.switch_cells()


func _scaled_cell(cell: Vector2i, cell_size: Vector2) -> Vector2:
	return Vector2(cell) * cell_size
