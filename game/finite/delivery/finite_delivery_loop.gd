class_name FiniteDeliveryLoop
extends RefCounted

signal delivery_event_created(event: Variant)

const FiniteDeliveryEventScript := preload("res://game/finite/delivery/finite_delivery_event.gd")

var _cargo_field: Variant
var _input_state: Variant
var _cargo_stack: Variant
var _stations_by_service_cell: Dictionary = {}
var _configuration_errors: Array[String] = []


func _init(
	cargo_field: Variant = null,
	input_state: Variant = null,
	cargo_stack: Variant = null,
	stations: Array = []
) -> void:
	_cargo_field = cargo_field
	_input_state = input_state
	_cargo_stack = cargo_stack
	for station: Variant in stations:
		_index_station(station)


func handle_cell_entered(cell: Vector2i, event_time: float) -> Variant:
	var picked_up := false
	var pickup_type: StringName = &""
	var unloaded_items: Array[StringName] = []
	var stop_requested := false

	if (
		_cargo_field != null
		and _input_state != null
		and _cargo_stack != null
		and _cargo_field.has_cargo(cell)
		and _input_state.should_load_on_contact()
	):
		var candidate: StringName = _cargo_field.cargo_type_at(cell)
		if _cargo_stack.push(candidate):
			pickup_type = _cargo_field.collect(cell)
			picked_up = pickup_type != &""

	if _stations_by_service_cell.has(cell) and _cargo_stack != null:
		var unload_result: Dictionary = _stations_by_service_cell[cell].try_unload(_cargo_stack)
		for item: Variant in unload_result.get("items", []):
			unloaded_items.append(StringName(item))
		stop_requested = not unloaded_items.is_empty()

	var event: Variant = FiniteDeliveryEventScript.new(
		cell,
		event_time,
		picked_up,
		pickup_type,
		unloaded_items,
		stop_requested,
		_remaining_map_cargo(),
		_stack_size()
	)
	delivery_event_created.emit(event)
	return event


func reset() -> void:
	if _cargo_field != null:
		_cargo_field.reset()
	if _cargo_stack != null:
		_cargo_stack.clear()
	if _input_state != null:
		_input_state.reset()


func cargo_field() -> Variant:
	return _cargo_field


func cargo_stack() -> Variant:
	return _cargo_stack


func input_state() -> Variant:
	return _input_state


func validation_errors() -> Array[String]:
	return _configuration_errors.duplicate()


func is_valid() -> bool:
	return _configuration_errors.is_empty()


func _index_station(station: Variant) -> void:
	if station == null or not station.has_method("service_cells"):
		_configuration_errors.append("station service owner is invalid")
		return
	for service_cell: Vector2i in station.service_cells():
		if _stations_by_service_cell.has(service_cell):
			_configuration_errors.append("station service cells must not overlap")
			return
		_stations_by_service_cell[service_cell] = station


func _remaining_map_cargo() -> int:
	if _cargo_field == null:
		return 0
	return _cargo_field.remaining_count()


func _stack_size() -> int:
	if _cargo_stack == null:
		return 0
	return _cargo_stack.size()
