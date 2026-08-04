class_name FiniteMapDefinition
extends RefCounted

const CargoTypeScript := preload("res://game/cargo/cargo_type.gd")

const SCHEMA_VERSION := 2
const VALID_ANCHOR_GEOMETRIES: Array[StringName] = [
	&"STRAIGHT",
	&"CURVE",
	&"SWITCH",
	&"CROSSING",
]

var definition_schema_version: int = 0
var map_id: StringName = &""
var map_revision: int = 0
var ruleset_version: StringName = &""
var board_size: Vector2i = Vector2i.ZERO
var start_cell: Vector2i = Vector2i.ZERO
var incoming_cell: Vector2i = Vector2i.ZERO
var buildable_cells: Array[Vector2i] = []
var blocked_cells: Array[Vector2i] = []
var station_placements: Array[Dictionary] = []
var cargo_placements: Array[Dictionary] = []
var time_limit_seconds: float = 0.0


static func create(data: Dictionary) -> Variant:
	var value := FiniteMapDefinition.new()
	value.definition_schema_version = int(data.get("definition_schema_version", 0))
	value.map_id = StringName(data.get("map_id", &""))
	value.map_revision = int(data.get("map_revision", 0))
	value.ruleset_version = StringName(data.get("ruleset_version", &""))
	value.board_size = _read_cell(data.get("board_size", []))
	value.start_cell = _read_cell(data.get("start_cell", []))
	value.incoming_cell = _read_cell(data.get("incoming_cell", []))
	value.buildable_cells = _read_cells(data.get("buildable_cells", []))
	value.blocked_cells = _read_cells(data.get("blocked_cells", []))
	value.station_placements = _read_placements(data.get("station_placements", []))
	value.cargo_placements = _read_placements(data.get("cargo_placements", []))
	value.time_limit_seconds = float(data.get("time_limit_seconds", 0.0))
	return value


func identity_key() -> String:
	return "%s@%d" % [map_id, map_revision]


func required_anchor_cells() -> Array[Vector2i]:
	var result: Array[Vector2i] = [start_cell, incoming_cell]
	for placement: Dictionary in station_placements:
		result.append(_read_cell(placement.get("cell", [])))
	for placement: Dictionary in cargo_placements:
		result.append(_read_cell(placement.get("cell", [])))
	return result


func validation_errors() -> Array[String]:
	var errors: Array[String] = []
	if definition_schema_version != SCHEMA_VERSION:
		errors.append("definition_schema_version must equal 2")
	if map_id == &"":
		errors.append("map_id is required")
	if map_revision <= 0:
		errors.append("map_revision must be positive")
	if ruleset_version == &"":
		errors.append("ruleset_version is required")
	if board_size.x <= 0 or board_size.y <= 0:
		errors.append("board_size must be positive")
	if time_limit_seconds <= 0.0:
		errors.append("time_limit_seconds must be positive")
	if start_cell == incoming_cell:
		errors.append("incoming_cell must differ from start_cell")

	_validate_surface(errors)
	_validate_placements(station_placements, "station", errors)
	_validate_placements(cargo_placements, "cargo", errors)
	_validate_required_anchor_uniqueness(errors)
	_validate_fixed_anchor_surface_exclusion(errors)
	return errors


func to_dictionary() -> Dictionary:
	return {
		"definition_schema_version": definition_schema_version,
		"map_id": str(map_id),
		"map_revision": map_revision,
		"ruleset_version": str(ruleset_version),
		"board_size": _cell_to_array(board_size),
		"start_cell": _cell_to_array(start_cell),
		"incoming_cell": _cell_to_array(incoming_cell),
		"buildable_cells": _cells_to_arrays(buildable_cells),
		"blocked_cells": _cells_to_arrays(blocked_cells),
		"station_placements": station_placements.duplicate(true),
		"cargo_placements": cargo_placements.duplicate(true),
		"time_limit_seconds": time_limit_seconds,
	}


func _validate_surface(errors: Array[String]) -> void:
	if not _inside_board(start_cell):
		errors.append("start_cell must be inside board")
	if not _inside_board(incoming_cell):
		errors.append("incoming_cell must be inside board")

	var buildable_seen: Dictionary = {}
	for cell: Vector2i in buildable_cells:
		if not _inside_board(cell):
			errors.append("buildable_cells must be inside board")
		if buildable_seen.has(cell):
			errors.append("buildable_cells must not contain duplicates")
		buildable_seen[cell] = true

	var blocked_seen: Dictionary = {}
	for cell: Vector2i in blocked_cells:
		if not _inside_board(cell):
			errors.append("blocked_cells must be inside board")
		if blocked_seen.has(cell):
			errors.append("blocked_cells must not contain duplicates")
		blocked_seen[cell] = true
		if buildable_seen.has(cell):
			errors.append("buildable_cells and blocked_cells must not overlap")


func _validate_placements(
	placements: Array[Dictionary],
	placement_kind: String,
	errors: Array[String]
) -> void:
	var seen_cells: Dictionary = {}
	for placement: Dictionary in placements:
		var cell := _read_cell(placement.get("cell", []))
		if not _inside_board(cell):
			errors.append("%s placement cell must be inside board" % placement_kind)
		if seen_cells.has(cell):
			errors.append("%s placements must not contain duplicate cells" % placement_kind)
		seen_cells[cell] = true

		var cargo_type := StringName(placement.get("cargo_type", &""))
		if not CargoTypeScript.is_valid(cargo_type):
			errors.append("%s placement cargo_type must be valid" % placement_kind)

		var anchor: Variant = placement.get("rail_anchor", null)
		if not anchor is Dictionary:
			errors.append("%s placement rail_anchor is required" % placement_kind)
			continue
		var geometry := StringName(anchor.get("geometry", &""))
		if not VALID_ANCHOR_GEOMETRIES.has(geometry):
			errors.append("%s placement rail_anchor geometry must be valid" % placement_kind)
		var rotation := int(anchor.get("rotation_quarters", -1))
		if rotation < 0 or rotation > 3:
			errors.append("%s placement rail_anchor rotation_quarters must be 0..3" % placement_kind)


func _validate_required_anchor_uniqueness(errors: Array[String]) -> void:
	var seen: Dictionary = {}
	for cell: Vector2i in required_anchor_cells():
		if seen.has(cell):
			errors.append("required anchor cells must be unique")
			return
		seen[cell] = true


func _validate_fixed_anchor_surface_exclusion(errors: Array[String]) -> void:
	var buildable: Dictionary = {}
	for cell: Vector2i in buildable_cells:
		buildable[cell] = true
	var blocked: Dictionary = {}
	for cell: Vector2i in blocked_cells:
		blocked[cell] = true

	for cell: Vector2i in required_anchor_cells():
		if buildable.has(cell):
			errors.append("fixed anchor cells must not be buildable")
			break
	for cell: Vector2i in required_anchor_cells():
		if blocked.has(cell):
			errors.append("fixed anchor cells must not be blocked")
			break


func _inside_board(cell: Vector2i) -> bool:
	return (
		cell.x >= 0
		and cell.y >= 0
		and cell.x < board_size.x
		and cell.y < board_size.y
	)


static func _read_cell(raw: Variant) -> Vector2i:
	if raw is Vector2i:
		return raw
	if raw is Array and raw.size() == 2:
		return Vector2i(int(raw[0]), int(raw[1]))
	if raw is Dictionary and raw.has("x") and raw.has("y"):
		return Vector2i(int(raw.get("x", 0)), int(raw.get("y", 0)))
	return Vector2i.ZERO


static func _read_cells(raw: Variant) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	if not raw is Array:
		return result
	for item: Variant in raw:
		result.append(_read_cell(item))
	return result


static func _read_placements(raw: Variant) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	if not raw is Array:
		return result
	for item: Variant in raw:
		if item is Dictionary:
			result.append(item.duplicate(true))
		else:
			result.append({})
	return result


static func _cell_to_array(cell: Vector2i) -> Array[int]:
	return [cell.x, cell.y]


static func _cells_to_arrays(cells: Array[Vector2i]) -> Array[Array]:
	var result: Array[Array] = []
	for cell: Vector2i in cells:
		result.append(_cell_to_array(cell))
	return result
