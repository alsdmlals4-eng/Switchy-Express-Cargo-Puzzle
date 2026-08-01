class_name Station
extends RefCounted

var cell: Vector2i = Vector2i.ZERO
var cargo_type: StringName = &""


func _init(station_cell: Vector2i = Vector2i.ZERO, accepted_type: StringName = &"") -> void:
	cell = station_cell
	cargo_type = accepted_type


func try_unload(cargo_stack: Variant) -> Dictionary:
	var unloaded: Array = cargo_stack.pop_matching_group(cargo_type)
	return {
		"station_cell": cell,
		"cargo_type": cargo_type,
		"items": unloaded,
		"count": unloaded.size(),
	}
