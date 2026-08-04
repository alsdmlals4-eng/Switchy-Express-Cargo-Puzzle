class_name FiniteDeliveryEvent
extends RefCounted

var _cell: Vector2i = Vector2i.ZERO
var _event_time: float = 0.0
var _picked_up: bool = false
var _pickup_type: StringName = &""
var _unload_count: int = 0
var _unloaded_items: Array[StringName] = []
var _stop_requested: bool = false
var _remaining_map_cargo: int = 0
var _stack_size: int = 0

var cell: Vector2i:
	get:
		return _cell
	set(_value):
		pass

var event_time: float:
	get:
		return _event_time
	set(_value):
		pass

var picked_up: bool:
	get:
		return _picked_up
	set(_value):
		pass

var pickup_type: StringName:
	get:
		return _pickup_type
	set(_value):
		pass

var unload_count: int:
	get:
		return _unload_count
	set(_value):
		pass

var unloaded_items: Array[StringName]:
	get:
		return _unloaded_items.duplicate()
	set(_value):
		pass

var stop_requested: bool:
	get:
		return _stop_requested
	set(_value):
		pass

var remaining_map_cargo: int:
	get:
		return _remaining_map_cargo
	set(_value):
		pass

var stack_size: int:
	get:
		return _stack_size
	set(_value):
		pass


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
	_cell = event_cell
	_event_time = timestamp
	_picked_up = did_pick_up
	_pickup_type = picked_type
	_unloaded_items = items_unloaded.duplicate()
	_unload_count = _unloaded_items.size()
	_stop_requested = should_stop
	_remaining_map_cargo = map_cargo_remaining
	_stack_size = current_stack_size
