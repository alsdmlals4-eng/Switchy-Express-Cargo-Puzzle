extends RefCounted

const FiniteMapDefinitionScript := preload("res://game/finite/map/finite_map_definition.gd")
const TrackPieceScript := preload("res://game/finite/build/track_piece.gd")
const TrackLayoutScript := preload("res://game/finite/build/track_layout.gd")

const CASES: Array[Dictionary] = [
	{"name": &"empty_layout", "code": &"EMPTY_LAYOUT"},
	{"name": &"invalid_start", "code": &"INVALID_START"},
	{"name": &"dangling_edge", "code": &"DANGLING_EDGE"},
	{"name": &"disconnected_required_point", "code": &"DISCONNECTED_REQUIRED_POINT"},
	{"name": &"crossing_turned_as_junction", "code": &"INVALID_CROSSING"},
	{"name": &"switch_exit_dead_end", "code": &"INVALID_SWITCH_EXIT"},
	{"name": &"reachable_degree_one", "code": &"PERMANENT_TRAP"},
	{"name": &"closed_valid_network", "code": &"PASS"},
]


static func cases() -> Array[Dictionary]:
	return CASES.duplicate(true)


static func make(case_name: StringName) -> Dictionary:
	var specs: Array[Dictionary] = _base_specs()
	var station_cell := Vector2i(5, 4)
	var cargo_cell := Vector2i(9, 4)
	var expected_cells: Array[Vector2i] = []

	match case_name:
		&"empty_layout":
			specs.clear()
		&"invalid_start":
			_remove_cells(specs, [Vector2i(2, 4)])
			expected_cells = [Vector2i(1, 4)]
		&"dangling_edge":
			_remove_cells(specs, [Vector2i(4, 2)])
			expected_cells = [Vector2i(3, 2), Vector2i(5, 2)]
		&"disconnected_required_point":
			cargo_cell = Vector2i(1, 6)
			specs.append(_spec(Vector2i(9, 4), &"STRAIGHT", 0))
			specs.append_array(_disconnected_loop_specs())
			expected_cells = [cargo_cell]
		&"crossing_turned_as_junction":
			_remove_cells(specs, [
				Vector2i(7, 5), Vector2i(7, 6), Vector2i(7, 7),
				Vector2i(7, 8), Vector2i(8, 8),
			])
			expected_cells = [Vector2i(7, 4)]
		&"switch_exit_dead_end":
			_remove_cells(specs, [
				Vector2i(3, 3), Vector2i(3, 2), Vector2i(4, 2),
				Vector2i(5, 2), Vector2i(6, 2), Vector2i(7, 2),
				Vector2i(7, 3), Vector2i(7, 5), Vector2i(7, 6),
				Vector2i(7, 7), Vector2i(7, 8), Vector2i(8, 8),
			])
			_replace_spec(specs, _spec(Vector2i(7, 4), &"STRAIGHT", 0))
			expected_cells = [Vector2i(3, 4), Vector2i(8, 7)]
		&"reachable_degree_one":
			_remove_cells(specs, [Vector2i(2, 4), Vector2i(3, 3)])
			specs.append(_spec(Vector2i(2, 4), &"SWITCH", 0, Vector2i.RIGHT))
			specs.append(_spec(Vector2i(3, 3), &"SWITCH", 3, Vector2i.UP))
			specs.append(_spec(Vector2i(2, 3), &"CURVE", 1))
			expected_cells = [Vector2i(0, 4)]
		&"closed_valid_network":
			pass
		_:
			return {}

	var buildable_cells: Array[Vector2i] = []
	for spec: Dictionary in specs:
		var cell: Vector2i = spec["cell"]
		if not buildable_cells.has(cell):
			buildable_cells.append(cell)
	buildable_cells.sort_custom(_cell_precedes)

	var definition: Variant = FiniteMapDefinitionScript.create({
		"definition_schema_version": 2,
		"map_id": "PREFLIGHT_%s" % str(case_name).to_upper(),
		"map_revision": 1,
		"ruleset_version": "fp_core_v1",
		"board_size": [11, 9],
		"start_cell": [1, 4],
		"incoming_cell": [0, 4],
		"buildable_cells": _cells_to_arrays(buildable_cells),
		"blocked_cells": [],
		"station_placements": [{
			"cell": [station_cell.x, station_cell.y],
			"cargo_type": "RED_STAR",
			"rail_anchor": {"geometry": "STRAIGHT", "rotation_quarters": 0},
		}],
		"cargo_placements": [{
			"cell": [cargo_cell.x, cargo_cell.y],
			"cargo_type": "BLUE_DIAMOND",
			"rail_anchor": {"geometry": "STRAIGHT", "rotation_quarters": 0},
		}],
		"time_limit_seconds": 90.0,
	})
	var layout: Variant = TrackLayoutScript.new()
	for spec: Dictionary in specs:
		var piece: Variant = TrackPieceScript.create(
			spec["cell"],
			spec["geometry"],
			spec["rotation"],
			spec["initial_exit"]
		)
		if piece != null:
			layout.put_piece(piece)

	return {
		"definition": definition,
		"layout": layout,
		"expected_cells": expected_cells,
	}


static func _base_specs() -> Array[Dictionary]:
	return [
		_spec(Vector2i(2, 4), &"STRAIGHT", 0),
		_spec(Vector2i(3, 4), &"SWITCH", 0, Vector2i.RIGHT),
		_spec(Vector2i(4, 4), &"STRAIGHT", 0),
		_spec(Vector2i(6, 4), &"STRAIGHT", 0),
		_spec(Vector2i(7, 4), &"CROSSING", 0),
		_spec(Vector2i(8, 4), &"SWITCH", 2, Vector2i.LEFT),
		_spec(Vector2i(10, 4), &"CURVE", 2),
		_spec(Vector2i(10, 5), &"STRAIGHT", 1),
		_spec(Vector2i(10, 6), &"STRAIGHT", 1),
		_spec(Vector2i(10, 7), &"CURVE", 3),
		_spec(Vector2i(9, 7), &"STRAIGHT", 0),
		_spec(Vector2i(8, 7), &"SWITCH", 1, Vector2i.DOWN),
		_spec(Vector2i(8, 6), &"STRAIGHT", 1),
		_spec(Vector2i(8, 5), &"STRAIGHT", 1),
		_spec(Vector2i(3, 3), &"STRAIGHT", 1),
		_spec(Vector2i(3, 2), &"CURVE", 1),
		_spec(Vector2i(4, 2), &"STRAIGHT", 0),
		_spec(Vector2i(5, 2), &"STRAIGHT", 0),
		_spec(Vector2i(6, 2), &"STRAIGHT", 0),
		_spec(Vector2i(7, 2), &"CURVE", 2),
		_spec(Vector2i(7, 3), &"STRAIGHT", 1),
		_spec(Vector2i(7, 5), &"STRAIGHT", 1),
		_spec(Vector2i(7, 6), &"STRAIGHT", 1),
		_spec(Vector2i(7, 7), &"STRAIGHT", 1),
		_spec(Vector2i(7, 8), &"CURVE", 0),
		_spec(Vector2i(8, 8), &"CURVE", 3),
	]


static func _disconnected_loop_specs() -> Array[Dictionary]:
	return [
		_spec(Vector2i(0, 6), &"CURVE", 1),
		_spec(Vector2i(2, 6), &"CURVE", 2),
		_spec(Vector2i(2, 7), &"STRAIGHT", 1),
		_spec(Vector2i(2, 8), &"CURVE", 3),
		_spec(Vector2i(1, 8), &"STRAIGHT", 0),
		_spec(Vector2i(0, 8), &"CURVE", 0),
		_spec(Vector2i(0, 7), &"STRAIGHT", 1),
	]


static func _spec(
	cell: Vector2i,
	geometry: StringName,
	rotation: int,
	initial_exit: Vector2i = Vector2i.ZERO
) -> Dictionary:
	return {
		"cell": cell,
		"geometry": geometry,
		"rotation": rotation,
		"initial_exit": initial_exit,
	}


static func _remove_cells(specs: Array[Dictionary], cells: Array[Vector2i]) -> void:
	for index: int in range(specs.size() - 1, -1, -1):
		if cells.has(specs[index]["cell"]):
			specs.remove_at(index)


static func _replace_spec(specs: Array[Dictionary], replacement: Dictionary) -> void:
	_remove_cells(specs, [replacement["cell"]])
	specs.append(replacement)


static func _cells_to_arrays(cells: Array[Vector2i]) -> Array[Array]:
	var result: Array[Array] = []
	for cell: Vector2i in cells:
		result.append([cell.x, cell.y])
	return result


static func _cell_precedes(first: Vector2i, second: Vector2i) -> bool:
	if first.y != second.y:
		return first.y < second.y
	return first.x < second.x
