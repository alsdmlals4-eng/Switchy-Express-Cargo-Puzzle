class_name CargoSpawner
extends RefCounted

const CargoTypeScript := preload("res://game/cargo/cargo_type.gd")

const RESPAWN_DELAY_SECONDS := 1.0
const DEFAULT_MINIMUM_PER_TYPE := 4
const INVALID_CELL := Vector2i(-1, -1)

const STATUS_SPAWNED: StringName = &"SPAWNED"
const STATUS_WAITING: StringName = &"WAITING"
const STATUS_DEFERRED: StringName = &"SPAWN_DEFERRED"
const STATUS_SATISFIED: StringName = &"SATISFIED"

var _graph: Variant
var _stations: Array = []
var _seed: int = 0
var _spawn_sequence: int = 0
var _pickups: Dictionary = {}
var _pending_respawns: Array[Dictionary] = []


func configure(graph: Variant, stations: Array, seed: int) -> void:
	_graph = graph
	_stations = stations.duplicate()
	_seed = seed
	_spawn_sequence = 0
	_pickups.clear()
	_pending_respawns.clear()


func ensure_all_minimum(
	minimum_count: int = DEFAULT_MINIMUM_PER_TYPE,
	occupied_cells: Array = [],
	forward_cells: Array = []
) -> StringName:
	var spawned_any := false
	for cargo_type: StringName in CargoTypeScript.all_types():
		var status := ensure_minimum(
			cargo_type,
			minimum_count,
			occupied_cells,
			forward_cells,
			INVALID_CELL
		)
		if status == STATUS_DEFERRED:
			return STATUS_DEFERRED
		if status == STATUS_SPAWNED:
			spawned_any = true
	return STATUS_SPAWNED if spawned_any else STATUS_SATISFIED


func ensure_minimum(
	cargo_type: StringName,
	minimum_count: int = DEFAULT_MINIMUM_PER_TYPE,
	occupied_cells: Array = [],
	forward_cells: Array = [],
	last_position: Vector2i = INVALID_CELL
) -> StringName:
	if not CargoTypeScript.is_valid(cargo_type):
		return STATUS_DEFERRED

	var spawned_any := false
	while count(cargo_type) < maxi(minimum_count, 0):
		var spawn_cell := _select_spawn_cell(
			cargo_type,
			occupied_cells,
			forward_cells,
			last_position
		)
		if spawn_cell == INVALID_CELL:
			return STATUS_DEFERRED
		_pickups[spawn_cell] = cargo_type
		_spawn_sequence += 1
		spawned_any = true
	return STATUS_SPAWNED if spawned_any else STATUS_SATISFIED


func collect(cell: Vector2i, current_time: float) -> StringName:
	if not _pickups.has(cell):
		return &""
	var cargo_type: StringName = _pickups[cell]
	_pickups.erase(cell)
	_pending_respawns.append({
		"cargo_type": cargo_type,
		"due_time": current_time + RESPAWN_DELAY_SECONDS,
		"last_cell": cell,
	})
	return cargo_type


func process(
	current_time: float,
	occupied_cells: Array = [],
	forward_cells: Array = []
) -> StringName:
	var retained: Array[Dictionary] = []
	var had_due_request := false
	var spawned_any := false

	for request: Dictionary in _pending_respawns:
		if float(request.due_time) > current_time:
			retained.append(request)
			continue
		had_due_request = true
		var status := ensure_minimum(
			request.cargo_type,
			DEFAULT_MINIMUM_PER_TYPE,
			occupied_cells,
			forward_cells,
			request.last_cell
		)
		if status == STATUS_DEFERRED:
			retained.append(request)
		else:
			spawned_any = true

	_pending_respawns = retained
	if spawned_any:
		return STATUS_SPAWNED
	if had_due_request:
		return STATUS_DEFERRED
	return STATUS_WAITING


func count(cargo_type: StringName) -> int:
	var total := 0
	for pickup_type: Variant in _pickups.values():
		if pickup_type == cargo_type:
			total += 1
	return total


func cargo_at(cell: Vector2i) -> StringName:
	return _pickups.get(cell, &"")


func pickup_cells() -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	for cell: Variant in _pickups.keys():
		cells.append(cell)
	cells.sort_custom(func(first: Vector2i, second: Vector2i) -> bool:
		if first.y == second.y:
			return first.x < second.x
		return first.y < second.y
	)
	return cells


func signature() -> String:
	var parts: Array[String] = []
	for cell: Vector2i in pickup_cells():
		parts.append("%s@%d,%d" % [cargo_at(cell), cell.x, cell.y])
	return "|".join(parts)


func _select_spawn_cell(
	cargo_type: StringName,
	occupied_cells: Array,
	forward_cells: Array,
	last_position: Vector2i
) -> Vector2i:
	var forbidden: Dictionary = {}
	for cell: Variant in occupied_cells:
		forbidden[cell] = true
	for cell: Variant in forward_cells:
		forbidden[cell] = true
	for station: Variant in _stations:
		forbidden[station.cell] = true
	for switch_cell: Vector2i in _graph.switch_cells():
		forbidden[switch_cell] = true
	for pickup_cell: Variant in _pickups.keys():
		forbidden[pickup_cell] = true
	if last_position != INVALID_CELL:
		forbidden[last_position] = true

	var eligible: Array[Vector2i] = []
	for cell: Vector2i in _graph.all_cells():
		if not forbidden.has(cell):
			eligible.append(cell)
	if eligible.is_empty():
		return INVALID_CELL

	var random := RandomNumberGenerator.new()
	random.seed = _spawn_seed(cargo_type)
	return eligible[random.randi_range(0, eligible.size() - 1)]


func _spawn_seed(cargo_type: StringName) -> int:
	var type_index := CargoTypeScript.all_types().find(cargo_type)
	return _seed + _spawn_sequence * 7919 + maxi(type_index, 0) * 131
