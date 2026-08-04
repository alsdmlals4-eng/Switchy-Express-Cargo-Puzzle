class_name FiniteMapLoader
extends RefCounted

const FiniteMapDefinitionScript := preload("res://game/finite/map/finite_map_definition.gd")


static func load_from_path(path: String) -> Variant:
	if not FileAccess.file_exists(path):
		return null
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return null
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		return null
	return load_from_dictionary(parsed)


static func load_from_dictionary(source: Dictionary) -> Variant:
	var data: Dictionary = source.duplicate(true)
	var rects: Variant = data.get("buildable_rects", [])
	if not rects is Array:
		return null

	var excluded: Dictionary = {}
	_add_excluded_cell(excluded, data.get("start_cell", null))
	_add_excluded_cell(excluded, data.get("incoming_cell", null))
	for raw: Variant in data.get("blocked_cells", []):
		_add_excluded_cell(excluded, raw)
	for placement: Variant in data.get("station_placements", []):
		if placement is Dictionary:
			_add_excluded_cell(excluded, placement.get("cell", null))
	for placement: Variant in data.get("cargo_placements", []):
		if placement is Dictionary:
			_add_excluded_cell(excluded, placement.get("cell", null))

	var buildable: Dictionary = {}
	for rect: Variant in rects:
		if not rect is Dictionary:
			return null
		var minimum_raw: Variant = _read_cell(rect.get("minimum", null))
		var maximum_raw: Variant = _read_cell(rect.get("maximum", null))
		if minimum_raw == null or maximum_raw == null:
			return null
		var minimum: Vector2i = minimum_raw
		var maximum: Vector2i = maximum_raw
		if minimum.x > maximum.x or minimum.y > maximum.y:
			return null
		for y: int in range(minimum.y, maximum.y + 1):
			for x: int in range(minimum.x, maximum.x + 1):
				var cell := Vector2i(x, y)
				if not excluded.has(cell):
					buildable[cell] = true

	var cells: Array[Vector2i] = []
	for cell: Variant in buildable.keys():
		cells.append(cell)
	cells.sort_custom(_cell_precedes)
	data["buildable_cells"] = _cells_to_arrays(cells)
	data.erase("buildable_rects")
	return FiniteMapDefinitionScript.create(data)


static func _add_excluded_cell(excluded: Dictionary, raw: Variant) -> void:
	var cell: Variant = _read_cell(raw)
	if cell != null:
		excluded[cell] = true


static func _read_cell(raw: Variant) -> Variant:
	if raw is Vector2i:
		return raw
	if raw is Array and raw.size() == 2 and _is_integer_number(raw[0]) and _is_integer_number(raw[1]):
		return Vector2i(int(raw[0]), int(raw[1]))
	if raw is Dictionary and raw.has("x") and raw.has("y"):
		if _is_integer_number(raw.get("x")) and _is_integer_number(raw.get("y")):
			return Vector2i(int(raw["x"]), int(raw["y"]))
	return null


static func _is_integer_number(value: Variant) -> bool:
	if typeof(value) == TYPE_INT:
		return true
	if typeof(value) == TYPE_FLOAT:
		return is_finite(value) and value == floor(value)
	return false


static func _cells_to_arrays(cells: Array[Vector2i]) -> Array[Array]:
	var result: Array[Array] = []
	for cell: Vector2i in cells:
		result.append([cell.x, cell.y])
	return result


static func _cell_precedes(first: Vector2i, second: Vector2i) -> bool:
	if first.y != second.y:
		return first.y < second.y
	return first.x < second.x
