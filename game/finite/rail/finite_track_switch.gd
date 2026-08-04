class_name FiniteTrackSwitch
extends RefCounted

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


func selected_exit() -> Vector2i:
	return _selected_exit


func exit_for(incoming_port: Vector2i) -> Vector2i:
	if incoming_port == _approach_port:
		return _selected_exit
	if _exit_ports.has(incoming_port):
		return _approach_port
	return Vector2i.ZERO


func cycle() -> bool:
	if _exit_ports.size() != 2:
		return false
	_selected_exit = _exit_ports[1] if _selected_exit == _exit_ports[0] else _exit_ports[0]
	return true


func reset() -> void:
	_selected_exit = _initial_exit
