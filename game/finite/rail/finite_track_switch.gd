class_name FiniteTrackSwitch
extends RefCounted

const CARDINAL_DIRECTIONS: Array[Vector2i] = [
	Vector2i.UP,
	Vector2i.RIGHT,
	Vector2i.DOWN,
	Vector2i.LEFT,
]

var _approach_port: Vector2i = Vector2i.ZERO
var _exit_ports: Array[Vector2i] = []
var _initial_exit: Vector2i = Vector2i.ZERO
var _selected_exit: Vector2i = Vector2i.ZERO


func _init(
	approach_port: Vector2i = Vector2i.ZERO,
	exit_ports: Array[Vector2i] = [],
	initial_exit: Vector2i = Vector2i.ZERO
) -> void:
	configure(approach_port, exit_ports, initial_exit)


func configure(
	approach_port: Vector2i,
	exit_ports: Array[Vector2i],
	initial_exit: Vector2i
) -> bool:
	if approach_port == Vector2i.ZERO or exit_ports.size() != 2:
		return false
	if exit_ports[0] == Vector2i.ZERO or exit_ports[1] == Vector2i.ZERO:
		return false
	if exit_ports[0] == exit_ports[1] or exit_ports.has(approach_port):
		return false
	if not exit_ports.has(initial_exit):
		return false
	_approach_port = approach_port
	_exit_ports = exit_ports.duplicate()
	_initial_exit = initial_exit
	_selected_exit = initial_exit
	return true


func approach_port() -> Vector2i:
	return _approach_port


func exit_ports() -> Array[Vector2i]:
	return _exit_ports.duplicate()


func connected_ports() -> Array[Vector2i]:
	var result: Array[Vector2i] = [_approach_port]
	result.append_array(_exit_ports)
	result.sort_custom(func(first: Vector2i, second: Vector2i) -> bool:
		return _direction_rank(first) < _direction_rank(second)
	)
	return result


func selected_exit() -> Vector2i:
	return _selected_exit


func exit_for(incoming_port: Vector2i) -> Vector2i:
	if not connected_ports().has(incoming_port):
		return Vector2i.ZERO
	return _selected_exit


func select_exit(port: Vector2i) -> bool:
	if not connected_ports().has(port):
		return false
	_selected_exit = port
	return true


func cycle() -> bool:
	var ports: Array[Vector2i] = connected_ports()
	if ports.size() != 3:
		return false
	var current_index := ports.find(_selected_exit)
	if current_index < 0:
		return false
	_selected_exit = ports[(current_index + 1) % ports.size()]
	return true


func reset() -> void:
	_selected_exit = _initial_exit


static func _direction_rank(direction: Vector2i) -> int:
	var index := CARDINAL_DIRECTIONS.find(direction)
	return index if index >= 0 else CARDINAL_DIRECTIONS.size()
