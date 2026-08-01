class_name Station
extends RefCounted

var cell: Vector2i = Vector2i.ZERO
var cargo_type: StringName = &""


func _init(station_cell: Vector2i = Vector2i.ZERO, accepted_type: StringName = &"") -> void:
	cell = station_cell
	cargo_type = accepted_type


func try_unload(cargo_stack: Variant) -> Dictionary:
	var unload_order_before: Array = cargo_stack.unload_order()
	var top_before: StringName = cargo_stack.peek()
	var unloaded: Array = cargo_stack.pop_matching_group(cargo_type)
	var unload_order_after: Array = cargo_stack.unload_order()
	return {
		"station_cell": cell,
		"cargo_type": cargo_type,
		"top_before": top_before,
		"matched": not unloaded.is_empty(),
		"items": unloaded,
		"count": unloaded.size(),
		"unload_order_before": unload_order_before,
		"unload_order_after": unload_order_after,
	}
