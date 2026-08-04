class_name PreflightResult
extends RefCounted

var passed: bool = false
var primary_code: StringName = &""
var problem_cells: Array[Vector2i] = []
var message: String = ""
var graph: Variant = null


func _init(
	result_passed: bool = false,
	result_primary_code: StringName = &"",
	result_problem_cells: Array[Vector2i] = [],
	result_message: String = "",
	result_graph: Variant = null
) -> void:
	passed = result_passed
	primary_code = result_primary_code
	problem_cells = result_problem_cells.duplicate()
	message = result_message
	graph = result_graph
