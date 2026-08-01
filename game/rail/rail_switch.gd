class_name RailSwitch
extends RefCounted

var cell: Vector2i = Vector2i.ZERO
var _neighbors: Array[Vector2i] = []
var _incoming: Vector2i = Vector2i(-1, -1)
var _state_index: int = 0


func configure(
	junction_cell: Vector2i,
	ordered_neighbors: Array,
	incoming_cell: Vector2i
) -> void:
	cell = junction_cell
	_neighbors.clear()
	for neighbor: Variant in ordered_neighbors:
		_neighbors.append(neighbor)
	set_approach(incoming_cell)


func set_approach(incoming_cell: Vector2i) -> void:
	assert(_neighbors.has(incoming_cell), "incoming cell must be connected to the switch")
	_incoming = incoming_cell
	_state_index = 0


func approach() -> Vector2i:
	return _incoming


func valid_exits_for(incoming_cell: Vector2i) -> Array[Vector2i]:
	var exits: Array[Vector2i] = []
	for neighbor: Vector2i in _neighbors:
		if neighbor != incoming_cell:
			exits.append(neighbor)
	return exits


func state_count() -> int:
	return valid_exits_for(_incoming).size()


func current_exit() -> Vector2i:
	var exits := valid_exits_for(_incoming)
	if exits.is_empty():
		return cell
	return exits[_state_index % exits.size()]


func current_exit_for(incoming_cell: Vector2i) -> Vector2i:
	if incoming_cell != _incoming:
		set_approach(incoming_cell)
	return current_exit()


func peek_exit_for(incoming_cell: Vector2i) -> Vector2i:
	var exits := valid_exits_for(incoming_cell)
	if exits.is_empty():
		return cell
	var preview_index := _state_index if incoming_cell == _incoming else 0
	return exits[preview_index % exits.size()]


func cycle_state() -> void:
	var count := state_count()
	if count > 0:
		_state_index = (_state_index + 1) % count


func reset_after_passage() -> void:
	_state_index = 0
