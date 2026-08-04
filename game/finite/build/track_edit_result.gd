class_name TrackEditResult
extends RefCounted

var success: bool = false
var code: StringName = &""
var message: String = ""
var affected_cells: Array[Vector2i] = []
var cost_before: int = 0
var cost_after: int = 0


func _init(
	result_success: bool = false,
	result_code: StringName = &"",
	result_message: String = "",
	result_affected_cells: Array[Vector2i] = [],
	result_cost_before: int = 0,
	result_cost_after: int = 0
) -> void:
	success = result_success
	code = result_code
	message = result_message
	affected_cells = result_affected_cells.duplicate()
	cost_before = result_cost_before
	cost_after = result_cost_after
