class_name RailGraph
extends RefCounted

const RailSwitchScript := preload("res://game/rail/rail_switch.gd")

const CARDINAL_DIRECTIONS: Array[Vector2i] = [
	Vector2i.UP,
	Vector2i.RIGHT,
	Vector2i.DOWN,
	Vector2i.LEFT,
]

var width: int
var height: int
var used_fallback: bool = false

var _adjacency: Dictionary = {}
var _switches: Dictionary = {}


func _init(board_width: int = 15, board_height: int = 10) -> void:
	width = board_width
	height = board_height


func add_cell(cell: Vector2i) -> void:
	if not _adjacency.has(cell):
		var connections: Array[Vector2i] = []
		_adjacency[cell] = connections


func add_edge(first: Vector2i, second: Vector2i) -> void:
	assert(_inside_board(first), "first rail cell must be inside the board")
	assert(_inside_board(second), "second rail cell must be inside the board")
	assert(first.distance_to(second) == 1.0, "rail edges must join cardinally adjacent cells")
	add_cell(first)
	add_cell(second)
	_add_neighbor(first, second)
	_add_neighbor(second, first)


func all_cells() -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for cell: Variant in _adjacency.keys():
		result.append(cell)
	result.sort_custom(func(first: Vector2i, second: Vector2i) -> bool:
		if first.y == second.y:
			return first.x < second.x
		return first.y < second.y
	)
	return result


func has_cell(cell: Vector2i) -> bool:
	return _adjacency.has(cell)


func neighbors(cell: Vector2i) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for neighbor: Variant in _adjacency.get(cell, []):
		result.append(neighbor)
	result.sort_custom(func(first: Vector2i, second: Vector2i) -> bool:
		return _direction_rank(cell, first) < _direction_rank(cell, second)
	)
	return result


func finalize_switches() -> void:
	_switches.clear()
	for cell: Vector2i in all_cells():
		var connected := neighbors(cell)
		if connected.size() < 3:
			continue
		var rail_switch: Variant = RailSwitchScript.new()
		rail_switch.configure(cell, connected, connected[0])
		_switches[cell] = rail_switch


func switch_cells() -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for cell: Variant in _switches.keys():
		result.append(cell)
	result.sort_custom(func(first: Vector2i, second: Vector2i) -> bool:
		if first.y == second.y:
			return first.x < second.x
		return first.y < second.y
	)
	return result


func two_state_switch_count() -> int:
	return _switch_count_with_state_count(2)


func three_state_switch_count() -> int:
	return _switch_count_with_state_count(3)


func is_fully_connected() -> bool:
	var cells := all_cells()
	if cells.is_empty():
		return false

	var visited: Dictionary = {}
	var queue: Array[Vector2i] = [cells[0]]
	visited[cells[0]] = true

	while not queue.is_empty():
		var current: Vector2i = queue.pop_front()
		for neighbor: Vector2i in neighbors(current):
			if visited.has(neighbor):
				continue
			visited[neighbor] = true
			queue.append(neighbor)

	return visited.size() == cells.size()


func dead_end_count() -> int:
	var count := 0
	for cell: Vector2i in all_cells():
		if neighbors(cell).size() == 1:
			count += 1
	return count


func edge_count() -> int:
	var degree_total := 0
	for cell: Vector2i in all_cells():
		degree_total += neighbors(cell).size()
	return degree_total / 2


func cycle_rank() -> int:
	if not is_fully_connected():
		return 0
	return edge_count() - all_cells().size() + 1


func meaningful_switch_count(minimum_distinct_steps: int) -> int:
	var count := 0
	for junction: Vector2i in switch_cells():
		var connected := neighbors(junction)
		var incoming: Vector2i = connected[0]
		var exits: Array[Vector2i] = []
		for neighbor: Vector2i in connected:
			if neighbor != incoming:
				exits.append(neighbor)
		if exits.size() < 2:
			continue

		var all_routes_advance := true
		for exit_cell: Vector2i in exits:
			if not _can_advance(junction, exit_cell, minimum_distinct_steps):
				all_routes_advance = false
				break
		if all_routes_advance:
			count += 1
	return count


func configure_switch_approach(junction: Vector2i, incoming: Vector2i) -> void:
	assert(_switches.has(junction), "junction must contain a switch")
	_switches[junction].set_approach(incoming)


func cycle_switch(junction: Vector2i, incoming: Vector2i) -> void:
	assert(_switches.has(junction), "junction must contain a switch")
	var rail_switch: Variant = _switches[junction]
	if rail_switch.approach() != incoming:
		rail_switch.set_approach(incoming)
	rail_switch.cycle_state()


func commit_switch_passage(junction: Vector2i) -> void:
	assert(_switches.has(junction), "junction must contain a switch")
	_switches[junction].reset_after_passage()


func next_cell(current: Vector2i, previous: Vector2i) -> Vector2i:
	var connected := neighbors(current)
	if connected.is_empty():
		return current

	if _switches.has(current):
		return _switches[current].current_exit_for(previous)

	for neighbor: Vector2i in connected:
		if neighbor != previous:
			return neighbor
	return connected[0]


func preview_route(
	current: Vector2i,
	previous: Vector2i,
	step_count: int
) -> Array[Vector2i]:
	var preview: Array[Vector2i] = []
	var cursor := current
	var prior := previous

	for _step: int in range(maxi(step_count, 0)):
		var next := _peek_next_cell(cursor, prior)
		if next == cursor:
			break
		preview.append(next)
		prior = cursor
		cursor = next

	return preview


func signature() -> String:
	var parts: Array[String] = []
	for cell: Vector2i in all_cells():
		var neighbor_parts: Array[String] = []
		for neighbor: Vector2i in neighbors(cell):
			neighbor_parts.append("%d,%d" % [neighbor.x, neighbor.y])
		parts.append("%d,%d:%s" % [cell.x, cell.y, "/".join(neighbor_parts)])
	return "|".join(parts)


func _switch_count_with_state_count(expected_state_count: int) -> int:
	var count := 0
	for rail_switch: Variant in _switches.values():
		if rail_switch.state_count() == expected_state_count:
			count += 1
	return count


func _peek_next_cell(current: Vector2i, previous: Vector2i) -> Vector2i:
	var connected := neighbors(current)
	if connected.is_empty():
		return current
	if _switches.has(current):
		return _switches[current].peek_exit_for(previous)
	for neighbor: Vector2i in connected:
		if neighbor != previous:
			return neighbor
	return connected[0]


func _can_advance(
	junction: Vector2i,
	first_exit: Vector2i,
	minimum_steps: int
) -> bool:
	var prior := junction
	var cursor := first_exit

	for _step: int in range(1, maxi(minimum_steps, 1)):
		var candidates: Array[Vector2i] = []
		for neighbor: Vector2i in neighbors(cursor):
			if neighbor != prior:
				candidates.append(neighbor)
		if candidates.is_empty():
			return false
		prior = cursor
		cursor = candidates[0]
		if cursor == junction:
			return false
	return true


func _add_neighbor(cell: Vector2i, neighbor: Vector2i) -> void:
	var connected: Array = _adjacency[cell]
	if not connected.has(neighbor):
		connected.append(neighbor)
		_adjacency[cell] = connected


func _inside_board(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.x < width and cell.y >= 0 and cell.y < height


func _direction_rank(origin: Vector2i, neighbor: Vector2i) -> int:
	var delta := neighbor - origin
	var index := CARDINAL_DIRECTIONS.find(delta)
	return index if index >= 0 else CARDINAL_DIRECTIONS.size()
