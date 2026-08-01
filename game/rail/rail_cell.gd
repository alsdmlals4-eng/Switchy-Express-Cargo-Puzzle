class_name RailCell
extends RefCounted

var position: Vector2i
var connections: Array[Vector2i] = []


func _init(cell_position: Vector2i = Vector2i.ZERO) -> void:
	position = cell_position


func connect_to(neighbor: Vector2i) -> void:
	if not connections.has(neighbor):
		connections.append(neighbor)


func degree() -> int:
	return connections.size()
