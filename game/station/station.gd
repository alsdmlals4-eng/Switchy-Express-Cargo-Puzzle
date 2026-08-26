class_name Station
extends RefCounted

const CARDINAL_DIRECTIONS: Array[Vector2i] = [
	Vector2i.UP,
	Vector2i.RIGHT,
	Vector2i.DOWN,
	Vector2i.LEFT,
]

var cell: Vector2i = Vector2i.ZERO
var cargo_type: StringName = &""


func _init(station_cell: Vector2i = Vector2i.ZERO, accepted_type: StringName = &"") -> void:
	cell = station_cell
	cargo_type = accepted_type


func service_cells() -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for direction: Vector2i in CARDINAL_DIRECTIONS:
		result.append(cell + direction)
	return result


func services(train_cell: Vector2i) -> bool:
	var delta := train_cell - cell
	return absi(delta.x) + absi(delta.y) == 1


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
