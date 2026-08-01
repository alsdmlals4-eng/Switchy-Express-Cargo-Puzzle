class_name DeliveryLoop
extends RefCounted

const TIME_EPSILON := 0.000001

var _train: Variant
var _cargo_stack: Variant
var _cargo_spawner: Variant
var _input_state: Variant
var _stations_by_cell: Dictionary = {}
var _elapsed_time: float = 0.0
var _last_spawn_status: StringName = &"WAITING"
var _current_events: Array[Dictionary] = []


func configure(
	train: Variant,
	cargo_stack: Variant,
	cargo_spawner: Variant,
	input_state: Variant,
	stations: Array
) -> void:
	var callback := Callable(self, "_on_cell_entered")
	if _train != null and _train.cell_entered.is_connected(callback):
		_train.cell_entered.disconnect(callback)

	_train = train
	_cargo_stack = cargo_stack
	_cargo_spawner = cargo_spawner
	_input_state = input_state
	_stations_by_cell.clear()
	for station: Variant in stations:
		assert(not _stations_by_cell.has(station.cell), "one rail cell may contain only one station")
		_stations_by_cell[station.cell] = station

	_elapsed_time = 0.0
	_last_spawn_status = &"WAITING"
	_current_events.clear()
	_train.cell_entered.connect(callback)


func advance_time(delta_seconds: float) -> Array[Dictionary]:
	assert(_train != null, "DeliveryLoop must be configured before advancing")
	_current_events.clear()
	var remaining_time := maxf(delta_seconds, 0.0)

	if remaining_time > 0.0:
		if _train.speed <= 0.0:
			_elapsed_time += remaining_time
		else:
			_advance_train(remaining_time)

	_last_spawn_status = _cargo_spawner.process(
		_elapsed_time,
		_train.train_cells(),
		_train.forward_cells(2)
	)
	return _current_events.duplicate(true)


func handle_cell_entered(cell: Vector2i, event_time: float) -> Dictionary:
	var event := {
		"cell": cell,
		"time": event_time,
		"picked_up": false,
		"pickup_type": &"",
		"unloaded": false,
		"unload_result": {},
	}

	var pickup_type: StringName = _cargo_spawner.cargo_at(cell)
	if pickup_type != &"" and _cargo_stack.try_load(pickup_type, _input_state):
		var collected_type: StringName = _cargo_spawner.collect(cell, event_time)
		assert(collected_type == pickup_type, "loaded cargo and removed map pickup must match")
		event.picked_up = true
		event.pickup_type = pickup_type

	if _stations_by_cell.has(cell):
		var unload_result: Dictionary = _stations_by_cell[cell].try_unload(_cargo_stack)
		event.unload_result = unload_result
		event.unloaded = int(unload_result.count) > 0

	return event


func elapsed_time() -> float:
	return _elapsed_time


func last_spawn_status() -> StringName:
	return _last_spawn_status


func _advance_train(delta_seconds: float) -> void:
	var remaining_time := delta_seconds
	while remaining_time > TIME_EPSILON:
		var distance_to_boundary := 1.0 - float(_train.movement_progress())
		var time_to_boundary := distance_to_boundary / float(_train.speed)
		if time_to_boundary <= remaining_time + TIME_EPSILON:
			var step_time := minf(time_to_boundary, remaining_time)
			_elapsed_time += step_time
			var crossed_cells: int = _train.advance_time(step_time)
			if crossed_cells == 0:
				_train.advance_one_cell()
			remaining_time = maxf(remaining_time - step_time, 0.0)
		else:
			_elapsed_time += remaining_time
			_train.advance_time(remaining_time)
			remaining_time = 0.0


func _on_cell_entered(cell: Vector2i) -> void:
	_current_events.append(handle_cell_entered(cell, _elapsed_time))
