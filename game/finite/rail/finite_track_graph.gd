class_name FiniteTrackGraph
extends RefCounted

const SWITCH_SCRIPT_PATH := "res://game/finite/rail/finite_track_switch.gd"
const CROSSING_SCRIPT_PATH := "res://game/finite/rail/finite_track_crossing.gd"
const FiniteTrackSwitchScript := preload(SWITCH_SCRIPT_PATH)
const FiniteTrackCrossingScript := preload(CROSSING_SCRIPT_PATH)
const CARDINAL_DIRECTIONS: Array[Vector2i] = [
	Vector2i.UP,
	Vector2i.RIGHT,
	Vector2i.DOWN,
	Vector2i.LEFT,
]

var _pieces_by_cell: Dictionary = {}
var _switches_by_cell: Dictionary = {}
var _crossings_by_cell: Dictionary = {}
var _locked_route_control_cell: Vector2i = Vector2i(-1, -1)


func _init(pieces: Array[Variant] = []) -> void:
	for piece: Variant in pieces:
		_add_piece(piece)


func all_cells() -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for cell: Variant in _pieces_by_cell.keys():
		result.append(cell)
	result.sort_custom(_cell_precedes)
	return result


func has_cell(cell: Vector2i) -> bool:
	return _pieces_by_cell.has(cell)


func piece_at(cell: Vector2i) -> Variant:
	if not _pieces_by_cell.has(cell):
		return null
	return _pieces_by_cell[cell].duplicate_piece()


func neighbors(cell: Vector2i) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	var piece: Variant = _pieces_by_cell.get(cell)
	if piece == null:
		return result
	for port: Vector2i in piece.ports():
		if _is_connected(cell, port):
			result.append(cell + port)
	result.sort_custom(func(first: Vector2i, second: Vector2i) -> bool:
		return _direction_rank(cell, first) < _direction_rank(cell, second)
	)
	return result


func next_cell(current: Vector2i, previous: Vector2i) -> Vector2i:
	var piece: Variant = _pieces_by_cell.get(current)
	if piece == null:
		return current
	var incoming_port := previous - current
	if not _is_connected(current, incoming_port):
		return current

	var outgoing_port := Vector2i.ZERO
	match piece.geometry:
		&"STRAIGHT", &"CURVE":
			outgoing_port = _other_port(piece.ports(), incoming_port)
		&"CROSSING":
			var finite_crossing: Variant = _crossings_by_cell.get(current)
			if finite_crossing != null:
				outgoing_port = finite_crossing.outgoing_for(incoming_port)
		&"SWITCH":
			var finite_switch: Variant = _switches_by_cell.get(current)
			if finite_switch != null:
				outgoing_port = finite_switch.exit_for(incoming_port)
		_:
			return current

	if outgoing_port == Vector2i.ZERO or not _is_connected(current, outgoing_port):
		return current
	return current + outgoing_port


func preview_route(
	current: Vector2i,
	previous: Vector2i,
	step_count: int
) -> Array[Vector2i]:
	var preview: Array[Vector2i] = []
	var cursor := current
	var prior := previous
	for _step: int in range(maxi(step_count, 0)):
		var next := next_cell(cursor, prior)
		if next == cursor:
			break
		preview.append(next)
		prior = cursor
		cursor = next
	return preview


func switch_cells() -> Array[Vector2i]:
	return _sorted_cells(_switches_by_cell.keys())


func crossing_cells() -> Array[Vector2i]:
	return _sorted_cells(_crossings_by_cell.keys())


func route_control_cells() -> Array[Vector2i]:
	var result: Array[Vector2i] = switch_cells()
	for cell: Vector2i in crossing_cells():
		if not result.has(cell):
			result.append(cell)
	result.sort_custom(_cell_precedes)
	return result


func cycle_switch(cell: Vector2i) -> bool:
	if not _switches_by_cell.has(cell):
		return false
	return _cycle_control(_switches_by_cell[cell], cell)


func cycle_route_control(cell: Vector2i) -> bool:
	if _switches_by_cell.has(cell):
		return _cycle_control(_switches_by_cell[cell], cell)
	if _crossings_by_cell.has(cell):
		return _cycle_control(_crossings_by_cell[cell], cell)
	return false


func route_control_states() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for cell: Vector2i in route_control_cells():
		if _switches_by_cell.has(cell):
			var finite_switch: Variant = _switches_by_cell[cell]
			result.append({
				"cell": cell,
				"kind": &"SWITCH",
				"approach_port": finite_switch.approach_port(),
				"selected_exit": finite_switch.selected_exit(),
				"locked": cell == _locked_route_control_cell,
			})
		elif _crossings_by_cell.has(cell):
			var finite_crossing: Variant = _crossings_by_cell[cell]
			result.append({
				"cell": cell,
				"kind": &"CROSSING",
				"mode": finite_crossing.mode(),
				"locked": cell == _locked_route_control_cell,
			})
	return result


func set_switch_locked_cell(cell: Vector2i) -> void:
	set_route_control_locked_cell(cell)


func set_route_control_locked_cell(cell: Vector2i) -> void:
	_locked_route_control_cell = cell


func reset_switch_states() -> void:
	for finite_switch: Variant in _switches_by_cell.values():
		finite_switch.reset()
	for finite_crossing: Variant in _crossings_by_cell.values():
		finite_crossing.reset()
	_locked_route_control_cell = Vector2i(-1, -1)


func commit_switch_passage(_cell: Vector2i) -> void:
	pass


func _add_piece(piece: Variant) -> bool:
	if piece == null:
		return false
	var copy: Variant = piece.duplicate_piece()
	if copy == null or _pieces_by_cell.has(copy.cell):
		return false
	_pieces_by_cell[copy.cell] = copy
	if copy.geometry == &"SWITCH":
		var finite_switch: Variant = FiniteTrackSwitchScript.new(
			copy.approach_port(),
			copy.switch_exits(),
			copy.switch_initial_exit
		)
		_switches_by_cell[copy.cell] = finite_switch
	elif copy.geometry == &"CROSSING":
		_crossings_by_cell[copy.cell] = FiniteTrackCrossingScript.new()
	return true


func _cycle_control(control: Variant, cell: Vector2i) -> bool:
	if control == null or _locked_route_control_cell == cell:
		return false
	return bool(control.cycle())


func _is_connected(cell: Vector2i, port: Vector2i) -> bool:
	if not CARDINAL_DIRECTIONS.has(port):
		return false
	var piece: Variant = _pieces_by_cell.get(cell)
	if piece == null or not piece.ports().has(port):
		return false
	var neighbor_cell := cell + port
	var neighbor_piece: Variant = _pieces_by_cell.get(neighbor_cell)
	if neighbor_piece == null:
		return false
	return neighbor_piece.ports().has(-port)


static func _other_port(ports: Array[Vector2i], incoming_port: Vector2i) -> Vector2i:
	if ports.size() != 2 or not ports.has(incoming_port):
		return Vector2i.ZERO
	return ports[1] if ports[0] == incoming_port else ports[0]


static func _sorted_cells(values: Array) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for value: Variant in values:
		if value is Vector2i:
			result.append(value)
	result.sort_custom(_cell_precedes)
	return result


static func _cell_precedes(first: Vector2i, second: Vector2i) -> bool:
	if first.y != second.y:
		return first.y < second.y
	return first.x < second.x


static func _direction_rank(origin: Vector2i, neighbor: Vector2i) -> int:
	var direction := neighbor - origin
	var index := CARDINAL_DIRECTIONS.find(direction)
	return index if index >= 0 else CARDINAL_DIRECTIONS.size()
