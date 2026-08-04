class_name FiniteDeliveryEvent
extends RefCounted

var cell: Vector2i = Vector2i.ZERO
var event_time: float = 0.0
var picked_up: bool = false
var pickup_type: StringName = &""
var unload_count: int = 0
var unloaded_items: Array[StringName] = []
var stop_requested: bool = false
var remaining_map_cargo: int = 0
var stack_size: int = 0


func _init(
	event_cell: Vector2i = Vector2i.ZERO,
	timestamp: float = 0.0,
	did_pick_up: bool = false,
	picked_type: StringName = &"",
	items_unloaded: Array[StringName] = [],
	should_stop: bool = false,
	map_cargo_remaining: int = 0,
	current_stack_size: int = 0
) -> void:
	cell = event_cell
	event_time = timestamp
	picked_up = did_pick_up
	pickup_type = picked_type
	unloaded_items = items_unloaded.duplicate()
	unload_count = unloaded_items.size()
	stop_requested = should_stop
	remaining_map_cargo = map_cargo_remaining
	stack_size = current_stack_size
