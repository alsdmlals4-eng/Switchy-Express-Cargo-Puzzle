class_name PreflightValidator
extends RefCounted

const FiniteTrackGraphBuilderScript := preload("res://game/finite/rail/finite_track_graph_builder.gd")
const PreflightResultScript := preload("res://game/finite/build/preflight_result.gd")

const EMPTY_LAYOUT: StringName = &"EMPTY_LAYOUT"
const INVALID_START: StringName = &"INVALID_START"
const DANGLING_EDGE: StringName = &"DANGLING_EDGE"
const DISCONNECTED_REQUIRED_POINT: StringName = &"DISCONNECTED_REQUIRED_POINT"
const INVALID_CROSSING: StringName = &"INVALID_CROSSING"
const INVALID_SWITCH_EXIT: StringName = &"INVALID_SWITCH_EXIT"
const PERMANENT_TRAP: StringName = &"PERMANENT_TRAP"
const PASS: StringName = &"PASS"


func validate(definition: Variant, layout: Variant) -> Variant:
	if definition == null or layout == null or layout.pieces().is_empty():
		return _failed(EMPTY_LAYOUT, [], "place at least one player track piece")

	var graph: Variant = FiniteTrackGraphBuilderScript.build(definition, layout)
	if graph == null:
		return _failed(INVALID_START, [definition.start_cell], "finite graph could not be built")

	if not _has_valid_start(definition, graph):
		return _failed(INVALID_START, [definition.start_cell], "start must lead into the player network")

	if not _allows_open_terminals(definition):
		var dangling_cells := _dangling_cells(definition, graph)
		if not dangling_cells.is_empty():
			return _failed(DANGLING_EDGE, dangling_cells, "ordinary track ports must connect reciprocally")

	var search: Dictionary = _search_reachable_states(definition, graph)
	var disconnected_cells := _disconnected_required_cells(definition, search["reachable_cells"])
	if not disconnected_cells.is_empty():
		return _failed(
			DISCONNECTED_REQUIRED_POINT,
			disconnected_cells,
			"start must reach every station and cargo anchor"
		)

	var invalid_crossings := _invalid_crossing_cells(graph)
	if not invalid_crossings.is_empty():
		return _failed(INVALID_CROSSING, invalid_crossings, "crossings require four reciprocal ports")

	var invalid_switches := _invalid_switch_cells(graph)
	if not invalid_switches.is_empty():
		return _failed(INVALID_SWITCH_EXIT, invalid_switches, "every switch exit must remain structurally usable")

	if not _allows_open_terminals(definition):
		var trap_cells := _permanent_trap_cells(graph, search["states"])
		if not trap_cells.is_empty():
			return _failed(PERMANENT_TRAP, trap_cells, "reachable traversal states must have a forward successor")

	return PreflightResultScript.new(true, PASS, [], "structural preflight passed", graph)


func _has_valid_start(definition: Variant, graph: Variant) -> bool:
	if not graph.has_cell(definition.start_cell) or not graph.has_cell(definition.incoming_cell):
		return false
	if not graph.neighbors(definition.start_cell).has(definition.incoming_cell):
		return false
	return graph.next_cell(definition.start_cell, definition.incoming_cell) != definition.start_cell


func _dangling_cells(definition: Variant, graph: Variant) -> Array[Vector2i]:
	var problem_cells: Array[Vector2i] = []
	var external_incoming_port: Vector2i = definition.incoming_cell - definition.start_cell
	for cell: Vector2i in graph.all_cells():
		var piece: Variant = graph.piece_at(cell)
		if piece == null or piece.geometry == &"CROSSING" or piece.geometry == &"SWITCH":
			continue
		for port: Vector2i in piece.ports():
			if cell == definition.incoming_cell and port == external_incoming_port:
				continue
			if not graph.neighbors(cell).has(cell + port):
				problem_cells.append(cell)
	return _sorted_unique(problem_cells)


func _disconnected_required_cells(
	definition: Variant,
	reachable_cells: Dictionary
) -> Array[Vector2i]:
	var problem_cells: Array[Vector2i] = []
	for cell: Vector2i in definition.required_anchor_cells():
		if cell == definition.incoming_cell:
			continue
		if not reachable_cells.has(cell):
			problem_cells.append(cell)
	return _sorted_unique(problem_cells)


func _invalid_crossing_cells(graph: Variant) -> Array[Vector2i]:
	var problem_cells: Array[Vector2i] = []
	for cell: Vector2i in graph.all_cells():
		var piece: Variant = graph.piece_at(cell)
		if piece != null and piece.geometry == &"CROSSING" and graph.neighbors(cell).size() != 4:
			problem_cells.append(cell)
	return _sorted_unique(problem_cells)


func _invalid_switch_cells(graph: Variant) -> Array[Vector2i]:
	var problem_cells: Array[Vector2i] = []
	for cell: Vector2i in graph.switch_cells():
		var piece: Variant = graph.piece_at(cell)
		if piece == null or graph.neighbors(cell).size() != 3:
			problem_cells.append(cell)
			continue
		for exit_port: Vector2i in piece.switch_exits():
			var exit_cell := cell + exit_port
			if _structural_successors(graph, cell, exit_cell).is_empty():
				problem_cells.append(cell)
				break
	return _sorted_unique(problem_cells)


func _permanent_trap_cells(graph: Variant, states: Array[Dictionary]) -> Array[Vector2i]:
	var problem_cells: Array[Vector2i] = []
	for state: Dictionary in states:
		var previous: Vector2i = state["previous"]
		var current: Vector2i = state["current"]
		if _structural_successors(graph, previous, current).is_empty():
			problem_cells.append(current)
	return _sorted_unique(problem_cells)


func _search_reachable_states(definition: Variant, graph: Variant) -> Dictionary:
	var states: Array[Dictionary] = []
	var reachable_cells: Dictionary = {}
	var visited: Dictionary = {}
	var queue: Array[Dictionary] = [{
		"previous": definition.incoming_cell,
		"current": definition.start_cell,
	}]

	while not queue.is_empty():
		var state: Dictionary = queue.pop_front()
		var previous: Vector2i = state["previous"]
		var current: Vector2i = state["current"]
		var key := _state_key(previous, current)
		if visited.has(key):
			continue
		visited[key] = true
		states.append(state)
		reachable_cells[current] = true

		for next_cell: Vector2i in _structural_successors(graph, previous, current):
			queue.append({"previous": current, "current": next_cell})

	return {"states": states, "reachable_cells": reachable_cells}


func _structural_successors(
	graph: Variant,
	previous: Vector2i,
	current: Vector2i
) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	var piece: Variant = graph.piece_at(current)
	if piece == null or not graph.neighbors(current).has(previous):
		return result

	var incoming_port := previous - current
	var outgoing_ports: Array[Vector2i] = []
	match piece.geometry:
		&"STRAIGHT", &"CURVE":
			var ports: Array[Vector2i] = piece.ports()
			if ports.size() == 2 and ports.has(incoming_port):
				outgoing_ports.append(ports[1] if ports[0] == incoming_port else ports[0])
		&"CROSSING":
			if piece.ports().has(incoming_port):
				for port: Vector2i in piece.ports():
					if port != incoming_port:
						outgoing_ports.append(port)
		&"SWITCH":
			if incoming_port == piece.approach_port():
				outgoing_ports.append_array(piece.switch_exits())
			elif piece.switch_exits().has(incoming_port):
				outgoing_ports.append(piece.approach_port())

	for outgoing_port: Vector2i in outgoing_ports:
		var next_cell := current + outgoing_port
		if graph.neighbors(current).has(next_cell) and not result.has(next_cell):
			result.append(next_cell)
	result.sort_custom(_cell_precedes)
	return result


static func _allows_open_terminals(definition: Variant) -> bool:
	return (
		definition != null
		and definition.has_method("allows_open_terminals_after_required")
		and bool(definition.allows_open_terminals_after_required())
	)


static func _state_key(previous: Vector2i, current: Vector2i) -> String:
	return "%d,%d>%d,%d" % [previous.x, previous.y, current.x, current.y]


static func _sorted_unique(cells: Array[Vector2i]) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for cell: Vector2i in cells:
		if not result.has(cell):
			result.append(cell)
	result.sort_custom(_cell_precedes)
	return result


static func _cell_precedes(first: Vector2i, second: Vector2i) -> bool:
	if first.y != second.y:
		return first.y < second.y
	return first.x < second.x


static func _failed(
	code: StringName,
	problem_cells: Array[Vector2i],
	message: String
) -> Variant:
	return PreflightResultScript.new(false, code, _sorted_unique(problem_cells), message, null)
