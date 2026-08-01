class_name TrainState
extends RefCounted

const CONFIRMED_MAX_WAGONS := 8
const HISTORY_SAFETY_CELLS := 4

var current_cell: Vector2i = Vector2i.ZERO
var previous_cell: Vector2i = Vector2i.ZERO
var route_history: Array[Vector2i] = []
var _wagon_count: int = 0
var _capacity: int = CONFIRMED_MAX_WAGONS


func configure(
	graph: Variant,
	start_cell: Vector2i,
	incoming_cell: Vector2i,
	requested_capacity: int = CONFIRMED_MAX_WAGONS
) -> void:
	assert(graph.has_cell(start_cell), "train start cell must exist in RailGraph")
	assert(graph.neighbors(start_cell).has(incoming_cell), "incoming cell must connect to train start")
	_capacity = clampi(requested_capacity, 0, CONFIRMED_MAX_WAGONS)
	current_cell = start_cell
	previous_cell = incoming_cell
	_wagon_count = 0
	route_history = [current_cell, previous_cell]

	var primed_cells: Array[Vector2i] = graph.preview_route(
		previous_cell,
		current_cell,
		_capacity + HISTORY_SAFETY_CELLS
	)
	for cell: Vector2i in primed_cells:
		route_history.append(cell)
	_trim_history()


func advance(next_cell: Vector2i) -> void:
	previous_cell = current_cell
	current_cell = next_cell
	route_history.push_front(next_cell)
	_trim_history()


func set_wagon_count(requested_count: int) -> void:
	_wagon_count = clampi(requested_count, 0, _capacity)


func wagon_count() -> int:
	return _wagon_count


func wagon_cells() -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	var available := mini(_wagon_count, maxi(route_history.size() - 1, 0))
	for index: int in range(available):
		cells.append(route_history[index + 1])
	return cells


func train_cells() -> Array[Vector2i]:
	var cells: Array[Vector2i] = [current_cell]
	cells.append_array(wagon_cells())
	return cells


func history_size() -> int:
	return route_history.size()


func _trim_history() -> void:
	var maximum_size := _capacity + 1 + HISTORY_SAFETY_CELLS
	while route_history.size() > maximum_size:
		route_history.pop_back()
