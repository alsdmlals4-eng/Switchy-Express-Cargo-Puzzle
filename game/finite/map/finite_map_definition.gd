class_name FiniteMapDefinition
extends RefCounted

const CargoTypeScript := preload("res://game/cargo/cargo_type.gd")
const SELF_SCRIPT_PATH := "res://game/finite/map/finite_map_definition.gd"

const SCHEMA_VERSION := 3
const VALID_ANCHOR_GEOMETRIES: Array[StringName] = [
	&"STRAIGHT",
	&"CURVE",
	&"SWITCH",
	&"CROSSING",
]
const VALID_BOARD_DECORATION_KINDS: Array[StringName] = [
	&"FOREST_CLUSTER",
	&"MOSS_BOULDER",
	&"TIMBER_STACK",
	&"WATERWAY",
	&"LANTERN_FENCE",
]
const STATION_DESTINATION_KIND: StringName = &"STATION"
const DISPOSAL_YARD_DESTINATION_KIND: StringName = &"DISPOSAL_YARD"
const VALID_DESTINATION_KINDS: Array[StringName] = [
	STATION_DESTINATION_KIND,
	DISPOSAL_YARD_DESTINATION_KIND,
]
const CARDINAL_DIRECTIONS: Array[Vector2i] = [
	Vector2i.UP,
	Vector2i.RIGHT,
	Vector2i.DOWN,
	Vector2i.LEFT,
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
var caution_track_cells: Array[Vector2i] = []
var board_decorations: Array[Dictionary] = []
var station_placements: Array[Dictionary] = []
var cargo_placements: Array[Dictionary] = []
var marker_tracks_player_built: bool = false
var allow_open_terminals_after_required: bool = false
var time_limit_seconds: float = 0.0
var _source_errors: Array[String] = []


static func create(data: Dictionary) -> Variant:
	var value: Variant = load(SELF_SCRIPT_PATH).new()
	value._source_errors = _source_validation_errors(data)
	value.definition_schema_version = int(data.get("definition_schema_version", 0))
	value.map_id = StringName(data.get("map_id", &""))
	value.map_revision = int(data.get("map_revision", 0))
	value.ruleset_version = StringName(data.get("ruleset_version", &""))
	value.board_size = _read_cell(data.get("board_size", []))
	value.start_cell = _read_cell(data.get("start_cell", []))
	value.incoming_cell = _read_cell(data.get("incoming_cell", []))
	value.buildable_cells = _read_cells(data.get("buildable_cells", []))
	value.blocked_cells = _read_cells(data.get("blocked_cells", []))
	value.caution_track_cells = _read_cells(data.get("caution_track_cells", []))
	value.board_decorations = _read_placements(data.get("board_decorations", []))
	value.station_placements = _read_placements(data.get("station_placements", []))
	value.cargo_placements = _read_placements(data.get("cargo_placements", []))
	value.marker_tracks_player_built = bool(data.get("marker_tracks_player_built", false))
	value.allow_open_terminals_after_required = bool(
		data.get("allow_open_terminals_after_required", false)
	)
	value.time_limit_seconds = float(data.get("time_limit_seconds", 0.0))
	return value


func identity_key() -> String:
	return "%s@%d" % [map_id, map_revision]


func marker_tracks_are_player_built() -> bool:
	return marker_tracks_player_built


func allows_open_terminals_after_required() -> bool:
	return allow_open_terminals_after_required


func required_anchor_cells() -> Array[Vector2i]:
	var result: Array[Vector2i] = [start_cell, incoming_cell]
	result.append_array(required_cargo_cells())
	return result


func fixed_anchor_cells() -> Array[Vector2i]:
	var result: Array[Vector2i] = [start_cell, incoming_cell]
	if marker_tracks_player_built:
		return result
	result.append_array(required_cargo_cells())
	return result


func required_cargo_cells() -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for placement: Dictionary in cargo_placements:
		result.append(_read_cell(placement.get("cell", [])))
	return result


func station_service_cells(station_cell: Vector2i) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for direction: Vector2i in CARDINAL_DIRECTIONS:
		var candidate := station_cell + direction
		if _inside_board(candidate):
			result.append(candidate)
	return result


func station_service_cells_for_placement(placement: Dictionary) -> Array[Vector2i]:
	return station_service_cells(_read_cell(placement.get("cell", [])))


func validation_errors() -> Array[String]:
	var errors: Array[String] = _source_errors.duplicate()
	if definition_schema_version != SCHEMA_VERSION:
		errors.append("definition_schema_version must equal 3")
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
	if incoming_cell != start_cell + Vector2i.LEFT:
		errors.append("incoming_cell must be immediately left of start_cell")

	_validate_surface(errors)
	_validate_caution_track_cells(errors)
	_validate_board_decorations(errors)
	_validate_station_placements(errors)
	_validate_cargo_placements(errors)
	_validate_required_anchor_uniqueness(errors)
	_validate_fixed_anchor_surface_exclusion(errors)
	_validate_station_surface_exclusion(errors)
	_validate_station_service_ownership(errors)
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
		"caution_track_cells": _cells_to_arrays(caution_track_cells),
		"board_decorations": board_decorations.duplicate(true),
		"station_placements": station_placements.duplicate(true),
		"cargo_placements": cargo_placements.duplicate(true),
		"marker_tracks_player_built": marker_tracks_player_built,
		"allow_open_terminals_after_required": allow_open_terminals_after_required,
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


func _validate_caution_track_cells(errors: Array[String]) -> void:
	var buildable: Dictionary = {}
	for cell: Vector2i in buildable_cells:
		buildable[cell] = true

	var seen: Dictionary = {}
	for cell: Vector2i in caution_track_cells:
		if seen.has(cell):
			errors.append("caution_track_cells must not contain duplicates")
		seen[cell] = true
		if not buildable.has(cell):
			errors.append("caution_track_cells must be buildable")


func _validate_board_decorations(errors: Array[String]) -> void:
	var blocked: Dictionary = {}
	for cell: Vector2i in blocked_cells:
		blocked[cell] = true

	var gameplay_cells: Dictionary = {
		start_cell: true,
		incoming_cell: true,
	}
	for placement: Dictionary in station_placements:
		gameplay_cells[_read_cell(placement.get("cell", []))] = true
	for placement: Dictionary in cargo_placements:
		gameplay_cells[_read_cell(placement.get("cell", []))] = true

	var seen: Dictionary = {}
	for placement: Dictionary in board_decorations:
		var kind := StringName(placement.get("kind", &""))
		if not VALID_BOARD_DECORATION_KINDS.has(kind):
			errors.append("board decoration kind must be valid")
		var cell := _read_cell(placement.get("cell", []))
		if seen.has(cell):
			errors.append("board decoration cells must not contain duplicates")
		seen[cell] = true
		if not blocked.has(cell):
			errors.append("board decoration cells must be blocked")
		if gameplay_cells.has(cell):
			errors.append("board decorations must not overlap gameplay cells")


func _validate_station_placements(errors: Array[String]) -> void:
	_validate_placement_cells(station_placements, "station", errors)
	for placement: Dictionary in station_placements:
		var cargo_type := StringName(placement.get("cargo_type", &""))
		if not CargoTypeScript.is_valid(cargo_type):
			errors.append("station placement cargo_type must be valid")
		var destination_kind := StringName(
			placement.get("destination_kind", STATION_DESTINATION_KIND)
		)
		if not VALID_DESTINATION_KINDS.has(destination_kind):
			errors.append("station placement destination_kind must be valid")
		elif cargo_type == CargoTypeScript.WASTE_CRATE and destination_kind != DISPOSAL_YARD_DESTINATION_KIND:
			errors.append("WASTE_CRATE stations must be DISPOSAL_YARD")
		elif destination_kind == DISPOSAL_YARD_DESTINATION_KIND and cargo_type != CargoTypeScript.WASTE_CRATE:
			errors.append("DISPOSAL_YARD must accept WASTE_CRATE")
		if placement.has("rail_anchor") and placement.get("rail_anchor") != null:
			errors.append("station placement rail_anchor is forbidden")


func _validate_cargo_placements(errors: Array[String]) -> void:
	_validate_placement_cells(cargo_placements, "cargo", errors)
	for placement: Dictionary in cargo_placements:
		var cargo_type := StringName(placement.get("cargo_type", &""))
		if not CargoTypeScript.is_valid(cargo_type):
			errors.append("cargo placement cargo_type must be valid")

		var anchor: Variant = placement.get("rail_anchor", null)
		if marker_tracks_player_built and anchor == null:
			continue
		if not anchor is Dictionary:
			errors.append("cargo placement rail_anchor is required")
			continue
		var geometry := StringName(anchor.get("geometry", &""))
		if not VALID_ANCHOR_GEOMETRIES.has(geometry):
			errors.append("cargo placement rail_anchor geometry must be valid")
		var rotation := int(anchor.get("rotation_quarters", -1))
		if rotation < 0 or rotation > 3:
			errors.append("cargo placement rail_anchor rotation_quarters must be 0..3")


func _validate_placement_cells(
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

	for cell: Vector2i in fixed_anchor_cells():
		if buildable.has(cell):
			errors.append("fixed anchor cells must not be buildable")
			break
	for cell: Vector2i in fixed_anchor_cells():
		if blocked.has(cell):
			errors.append("fixed anchor cells must not be blocked")
			break


func _validate_station_surface_exclusion(errors: Array[String]) -> void:
	var buildable: Dictionary = {}
	for cell: Vector2i in buildable_cells:
		buildable[cell] = true
	for placement: Dictionary in station_placements:
		if buildable.has(_read_cell(placement.get("cell", []))):
			errors.append("station cells must not be buildable")
			return


func _validate_station_service_ownership(errors: Array[String]) -> void:
	var owners: Dictionary = {}
	for placement: Dictionary in station_placements:
		for service_cell: Vector2i in station_service_cells_for_placement(placement):
			if owners.has(service_cell):
				errors.append("station service cells must not overlap")
				return
			owners[service_cell] = true


func _inside_board(cell: Vector2i) -> bool:
	return (
		cell.x >= 0
		and cell.y >= 0
		and cell.x < board_size.x
		and cell.y < board_size.y
	)


static func _source_validation_errors(data: Dictionary) -> Array[String]:
	var errors: Array[String] = []
	if not _is_integer_number(data.get("definition_schema_version", null)):
		errors.append("definition_schema_version must be an integer")
	if not _is_integer_number(data.get("map_revision", null)):
		errors.append("map_revision must be an integer")
	if data.has("marker_tracks_player_built") and typeof(data.get("marker_tracks_player_built")) != TYPE_BOOL:
		errors.append("marker_tracks_player_built must be a boolean")
	if (
		data.has("allow_open_terminals_after_required")
		and typeof(data.get("allow_open_terminals_after_required")) != TYPE_BOOL
	):
		errors.append("allow_open_terminals_after_required must be a boolean")
	if not _is_cell_value(data.get("board_size", null)):
		errors.append("board_size is required")
	if not _is_cell_value(data.get("start_cell", null)):
		errors.append("start_cell is required")
	if not _is_cell_value(data.get("incoming_cell", null)):
		errors.append("incoming_cell is required")
	_validate_source_cell_list(data.get("buildable_cells", []), "buildable_cells", errors)
	_validate_source_cell_list(data.get("blocked_cells", []), "blocked_cells", errors)
	_validate_source_cell_list(data.get("caution_track_cells", []), "caution_track_cells", errors)
	_validate_source_placement_list(data.get("board_decorations", []), "board decoration", errors)
	_validate_source_placement_list(data.get("station_placements", []), "station", errors)
	_validate_source_placement_list(data.get("cargo_placements", []), "cargo", errors)
	return errors


static func _validate_source_cell_list(raw: Variant, field_name: String, errors: Array[String]) -> void:
	if not raw is Array:
		errors.append("%s must be an array" % field_name)
		return
	for item: Variant in raw:
		if not _is_cell_value(item):
			errors.append("%s entries must be valid cells" % field_name)


static func _validate_source_placement_list(
	raw: Variant,
	placement_kind: String,
	errors: Array[String]
) -> void:
	if not raw is Array:
		errors.append("%s placements must be an array" % placement_kind)
		return
	for item: Variant in raw:
		if not item is Dictionary:
			errors.append("%s placement must be a dictionary" % placement_kind)
			continue
		if not _is_cell_value(item.get("cell", null)):
			errors.append("%s placement cell is required" % placement_kind)
		var anchor: Variant = item.get("rail_anchor", null)
		if anchor is Dictionary:
			var raw_rotation: Variant = anchor.get("rotation_quarters", null)
			if not _is_integer_number(raw_rotation):
				errors.append(
					"%s placement rail_anchor rotation_quarters must be an integer"
					% placement_kind
				)


static func _is_cell_value(raw: Variant) -> bool:
	if raw is Vector2i:
		return true
	if raw is Array:
		return (
			raw.size() == 2
			and _is_integer_number(raw[0])
			and _is_integer_number(raw[1])
		)
	if raw is Dictionary:
		return (
			raw.has("x")
			and raw.has("y")
			and _is_integer_number(raw.get("x"))
			and _is_integer_number(raw.get("y"))
		)
	return false


static func _is_integer_number(value: Variant) -> bool:
	if typeof(value) == TYPE_INT:
		return true
	if typeof(value) == TYPE_FLOAT:
		return is_finite(value) and value == floor(value)
	return false


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
