class_name WagonView
extends Node2D

var rail_cell: Vector2i = Vector2i.ZERO


func set_rail_cell(cell: Vector2i, cell_size: Vector2 = Vector2.ONE) -> void:
	rail_cell = cell
	position = Vector2(cell) * cell_size
