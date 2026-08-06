class_name ProductBoardRenderer
extends Control

signal cell_primary_requested(cell: Vector2i)
signal cell_secondary_requested(cell: Vector2i)
signal hover_changed(cell: Vector2i)

const Palette := preload("res://game/demo/presentation/demo_palette.gd")
const NO_CELL := Vector2i(-1, -1)

var _snapshot: Dictionary = {}
var _hover_cell: Vector2i = NO_CELL


func _init() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	focus_mode = Control.FOCUS_NONE


func apply_snapshot(snapshot: Dictionary) -> void:
	_snapshot = snapshot.duplicate(true)
	queue_redraw()


func snapshot_for_test() -> Dictionary:
	return _snapshot.duplicate(true)


func ghost_descriptor_for_test() -> Dictionary:
	return _ghost_descriptor()


func board_cell_from_local(local: Vector2, board_size: Vector2i) -> Vector2i:
	if board_size.x <= 0 or board_size.y <= 0:
		return NO_CELL
	var rect := _board_rect()
	if not rect.has_point(local):
		return NO_CELL
	var relative := local - rect.position
	var cell_size := Vector2(rect.size.x / float(board_size.x), rect.size.y / float(board_size.y))
	var cell := Vector2i(
		int(floor(relative.x / cell_size.x)),
		int(floor(relative.y / cell_size.y))
	)
	if cell.x < 0 or cell.y < 0 or cell.x >= board_size.x or cell.y >= board_size.y:
		return NO_CELL
	return cell


func request_primary_at(local: Vector2) -> void:
	var cell := board_cell_from_local(local, _board_size())
	if cell != NO_CELL:
		cell_primary_requested.emit(cell)


func request_secondary_at(local: Vector2) -> void:
	var cell := board_cell_from_local(local, _board_size())
	if cell != NO_CELL:
		cell_secondary_requested.emit(cell)


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_set_hover(board_cell_from_local(event.position, _board_size()))
		return
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			request_primary_at(event.position)
			accept_event()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			request_secondary_at(event.position)
			accept_event()
		return
	if event is InputEventScreenTouch and event.pressed:
		request_primary_at(event.position)
		accept_event()


func _notification(what: int) -> void:
	if what == NOTIFICATION_MOUSE_EXIT:
		_set_hover(NO_CELL)


func _draw() -> void:
	var board_size := _board_size()
	if board_size.x <= 0 or board_size.y <= 0:
		return
	var rect := _board_rect()
	draw_rect(rect.grow(4.0), Palette.BOARD_EDGE, true)
	draw_rect(rect, Palette.BOARD, true)
	_draw_grid(rect, board_size)
	_draw_blocked(rect, board_size)
	_draw_fixed_tracks(rect, board_size)
	_draw_layout(rect, board_size)
	_draw_fixed_markers(rect, board_size)
	_draw_start_marker(rect, board_size)
	_draw_state_overlays(rect, board_size)
	_draw_train(rect, board_size)


func _draw_grid(rect: Rect2, board_size: Vector2i) -> void:
	var cell_size := _cell_size(rect, board_size)
	for x: int in range(board_size.x + 1):
		var px := rect.position.x + cell_size.x * float(x)
		draw_line(Vector2(px, rect.position.y), Vector2(px, rect.end.y), Palette.GRID, 1.0)
	for y: int in range(board_size.y + 1):
		var py := rect.position.y + cell_size.y * float(y)
		draw_line(Vector2(rect.position.x, py), Vector2(rect.end.x, py), Palette.GRID, 1.0)


func _draw_blocked(rect: Rect2, board_size: Vector2i) -> void:
	for value: Variant in _snapshot.get("blocked_cells", []):
		var cell: Vector2i = snapshot_cell(value)
		if cell == NO_CELL:
			continue
		var cell_rect := _cell_rect(cell, rect, board_size).grow(-3.0)
		draw_rect(cell_rect, _alpha(Palette.BLOCKED, 0.38), true)
		draw_line(cell_rect.position, cell_rect.end, Palette.BLOCKED, 2.0)
		draw_line(
			Vector2(cell_rect.end.x, cell_rect.position.y),
			Vector2(cell_rect.position.x, cell_rect.end.y),
			Palette.BLOCKED,
			2.0
		)


func _draw_fixed_tracks(rect: Rect2, board_size: Vector2i) -> void:
	for descriptor: Dictionary in fixed_track_descriptors(_snapshot):
		_draw_track_piece(
			descriptor["cell"],
			descriptor["geometry"],
			descriptor["rotation_quarters"],
			rect,
			board_size,
			_alpha(Palette.RAIL_BED, 0.88),
			Palette.RAIL_METAL
		)


func _draw_layout(rect: Rect2, board_size: Vector2i) -> void:
	for value: Variant in _snapshot.get("layout_pieces", []):
		var piece: Dictionary = value
		var cell: Vector2i = snapshot_cell(piece.get("cell", NO_CELL))
		if cell == NO_CELL:
			continue
		_draw_track_piece(
			cell,
			StringName(piece.get("geometry", &"")),
			int(piece.get("rotation_quarters", 0)),
			rect,
			board_size,
			Palette.RAIL_BED,
			Palette.RAIL_METAL
		)


func _draw_track_piece(
	cell: Vector2i,
	geometry: StringName,
	rotation: int,
	rect: Rect2,
	board_size: Vector2i,
	bed_color: Color,
	rail_color: Color
) -> void:
	var center := _cell_rect(cell, rect, board_size).get_center()
	var half := _cell_size(rect, board_size) * 0.44
	var directions: Array[Vector2i] = []
	match geometry:
		&"STRAIGHT":
			directions = [Vector2i.LEFT, Vector2i.RIGHT]
		&"CURVE":
			directions = [Vector2i.RIGHT, Vector2i.DOWN]
		&"SWITCH":
			directions = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP]
		&"CROSSING":
			directions = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]
		_:
			return
	for direction: Vector2i in directions:
		var rotated := _rotate_direction(direction, rotation)
		var endpoint := center + Vector2(rotated.x * half.x, rotated.y * half.y)
		draw_line(center, endpoint, bed_color, Palette.RAIL_WIDTH, true)
		draw_line(center, endpoint, rail_color, Palette.RAIL_HIGHLIGHT_WIDTH, true)
	if geometry == &"SWITCH":
		draw_circle(center, minf(half.x, half.y) * 0.18, rail_color)


func _draw_fixed_markers(rect: Rect2, board_size: Vector2i) -> void:
	for value: Variant in _snapshot.get("station_placements", []):
		var placement: Dictionary = value
		_draw_marker(
			placement.get("cell", NO_CELL),
			StringName(placement.get("cargo_type", &"")),
			true,
			rect,
			board_size
		)
	for value: Variant in _snapshot.get("cargo_placements", []):
		var placement: Dictionary = value
		_draw_marker(
			placement.get("cell", NO_CELL),
			StringName(placement.get("cargo_type", &"")),
			false,
			rect,
			board_size
		)


func _draw_marker(
	cell_value: Variant,
	cargo_type: StringName,
	is_station: bool,
	rect: Rect2,
	board_size: Vector2i
) -> void:
	var cell := snapshot_cell(cell_value)
	if cell == NO_CELL:
		return
	var cell_rect := _cell_rect(cell, rect, board_size).grow(-5.0)
	var color: Color = Palette.cargo_color(cargo_type)
	if is_station:
		draw_rect(cell_rect, _alpha(color, 0.22), true)
		draw_rect(cell_rect, color, false, 4.0)
	else:
		draw_circle(cell_rect.get_center(), minf(cell_rect.size.x, cell_rect.size.y) * 0.27, Palette.BOARD_EDGE)
	_draw_cargo_shape(cell_rect.get_center(), cargo_type, minf(cell_rect.size.x, cell_rect.size.y) * 0.20, color)
	_draw_marker_label(cell_rect.get_center(), cargo_type)


func _draw_start_marker(rect: Rect2, board_size: Vector2i) -> void:
	var descriptor := start_marker_descriptor(_snapshot)
	if descriptor.is_empty():
		return
	var start_cell: Vector2i = descriptor["cell"]
	var incoming_cell: Vector2i = descriptor["incoming_cell"]
	var cell_rect := _cell_rect(start_cell, rect, board_size).grow(-8.0)
	var center := cell_rect.get_center()
	var direction := Vector2(start_cell - incoming_cell).normalized()
	if direction == Vector2.ZERO:
		direction = Vector2.RIGHT
	var perpendicular := Vector2(-direction.y, direction.x)
	var radius := minf(cell_rect.size.x, cell_rect.size.y) * 0.30
	draw_circle(center, radius, Palette.BOARD_EDGE)
	draw_circle(center, radius * 0.78, Palette.SELECTED)
	var tip := center + direction * radius * 0.66
	var base := center - direction * radius * 0.34
	draw_colored_polygon(PackedVector2Array([
		tip,
		base + perpendicular * radius * 0.42,
		base - perpendicular * radius * 0.42,
	]), Palette.TEXT_LIGHT)
	var font := ThemeDB.fallback_font
	var label := "START"
	var font_size := 12
	var text_size := font.get_string_size(label, HORIZONTAL_ALIGNMENT_LEFT, -1.0, font_size)
	draw_string(
		font,
		Vector2(center.x - text_size.x * 0.5, cell_rect.position.y - 3.0),
		label,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1.0,
		font_size,
		Palette.BOARD_EDGE
	)


func _draw_cargo_shape(center: Vector2, cargo_type: StringName, radius: float, color: Color) -> void:
	if cargo_type == &"RED_STAR":
		var points := PackedVector2Array()
		for index: int in range(10):
			var angle := -PI * 0.5 + PI * float(index) / 5.0
			var length := radius if index % 2 == 0 else radius * 0.46
			points.append(center + Vector2(cos(angle), sin(angle)) * length)
		draw_colored_polygon(points, color)
	else:
		draw_colored_polygon(PackedVector2Array([
			center + Vector2(0.0, -radius),
			center + Vector2(radius, 0.0),
			center + Vector2(0.0, radius),
			center + Vector2(-radius, 0.0),
		]), color)


func _draw_marker_label(center: Vector2, cargo_type: StringName) -> void:
	var font := ThemeDB.fallback_font
	var label := Palette.cargo_label(cargo_type)
	var font_size := 16
	var text_size := font.get_string_size(label, HORIZONTAL_ALIGNMENT_LEFT, -1.0, font_size)
	draw_string(
		font,
		center - Vector2(text_size.x * 0.5, -text_size.y * 0.28),
		label,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1.0,
		font_size,
		Palette.TEXT_LIGHT
	)


func _draw_state_overlays(rect: Rect2, board_size: Vector2i) -> void:
	_draw_ghost(rect, board_size)
	if _hover_cell != NO_CELL:
		draw_rect(_cell_rect(_hover_cell, rect, board_size).grow(-2.0), Palette.HOVER, false, 3.0)
	var selected: Vector2i = snapshot_cell(_snapshot.get("selected_cell", NO_CELL))
	if selected != NO_CELL:
		var selected_rect := _cell_rect(selected, rect, board_size).grow(-3.0)
		draw_rect(selected_rect, _alpha(Palette.SELECTED, 0.28), true)
		draw_rect(selected_rect, Palette.SELECTED, false, 4.0)
	for value: Variant in _snapshot.get("problem_cells", []):
		var problem: Vector2i = snapshot_cell(value)
		if problem != NO_CELL:
			draw_rect(_cell_rect(problem, rect, board_size).grow(-2.0), Palette.PROBLEM, false, 5.0)


func _draw_ghost(rect: Rect2, board_size: Vector2i) -> void:
	var descriptor := _ghost_descriptor()
	if descriptor.is_empty():
		return
	var valid := bool(descriptor.get("valid", false))
	var color: Color = Palette.GHOST_VALID if valid else Palette.GHOST_INVALID
	var cell: Vector2i = descriptor["cell"]
	draw_rect(_cell_rect(cell, rect, board_size).grow(-5.0), _alpha(color, 0.16), true)
	_draw_track_piece(
		cell,
		StringName(descriptor["geometry"]),
		int(descriptor.get("rotation_quarters", 0)),
		rect,
		board_size,
		_alpha(color, 0.58),
		color
	)


func _draw_train(rect: Rect2, board_size: Vector2i) -> void:
	var cell: Vector2i = snapshot_cell(_snapshot.get("train_cell", NO_CELL))
	if cell == NO_CELL:
		return
	var cell_rect := _cell_rect(cell, rect, board_size).grow(-8.0)
	draw_rect(cell_rect, Palette.TRAIN, true)
	draw_rect(cell_rect, Palette.TRAIN_ACCENT, false, 3.0)
	var next_cell: Vector2i = snapshot_cell(_snapshot.get("train_next_cell", NO_CELL))
	if next_cell != NO_CELL:
		var direction := Vector2(next_cell - cell).normalized()
		var nose := cell_rect.get_center() + direction * minf(cell_rect.size.x, cell_rect.size.y) * 0.38
		draw_circle(nose, 4.0, Palette.TRAIN_ACCENT)


func _ghost_descriptor() -> Dictionary:
	if StringName(_snapshot.get("phase", &"BUILD")) != &"BUILD":
		return {}
	var geometry := StringName(_snapshot.get("selected_geometry", &""))
	if _hover_cell == NO_CELL or geometry == &"":
		return {}
	var buildable: Array = _snapshot.get("buildable_cells", [])
	var blocked: Array = _snapshot.get("blocked_cells", [])
	return {
		"cell": _hover_cell,
		"geometry": geometry,
		"rotation_quarters": int(_snapshot.get("selected_rotation_quarters", 0)),
		"valid": (buildable.is_empty() or buildable.has(_hover_cell)) and not blocked.has(_hover_cell),
	}


func _set_hover(cell: Vector2i) -> void:
	if _hover_cell == cell:
		return
	_hover_cell = cell
	hover_changed.emit(cell)
	queue_redraw()


func _board_size() -> Vector2i:
	return snapshot_cell(_snapshot.get("board_size", Vector2i.ZERO))


func _board_rect() -> Rect2:
	return Rect2(
		Vector2(Palette.BOARD_PADDING, Palette.BOARD_PADDING),
		Vector2(
			maxf(size.x - Palette.BOARD_PADDING * 2.0, 0.0),
			maxf(size.y - Palette.BOARD_PADDING * 2.0, 0.0)
		)
	)


static func snapshot_cell(value: Variant) -> Vector2i:
	if value is Vector2i:
		return value
	if value is Vector2:
		return Vector2i(int(value.x), int(value.y))
	if value is Array and value.size() == 2:
		return Vector2i(int(value[0]), int(value[1]))
	if value is Dictionary and value.has("x") and value.has("y"):
		return Vector2i(int(value.get("x", -1)), int(value.get("y", -1)))
	return NO_CELL


static func fixed_track_descriptors(snapshot: Dictionary) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	var incoming := snapshot_cell(snapshot.get("incoming_cell", NO_CELL))
	if incoming != NO_CELL:
		result.append({
			"cell": incoming,
			"geometry": &"STRAIGHT",
			"rotation_quarters": 0,
			"kind": &"INCOMING",
		})
	var start := snapshot_cell(snapshot.get("start_cell", NO_CELL))
	if start != NO_CELL:
		result.append({
			"cell": start,
			"geometry": &"STRAIGHT",
			"rotation_quarters": 0,
			"kind": &"START",
		})
	_append_authored_tracks(result, snapshot.get("station_placements", []), &"STATION")
	_append_authored_tracks(result, snapshot.get("cargo_placements", []), &"CARGO")
	return result


static func start_marker_descriptor(snapshot: Dictionary) -> Dictionary:
	var start := snapshot_cell(snapshot.get("start_cell", NO_CELL))
	var incoming := snapshot_cell(snapshot.get("incoming_cell", NO_CELL))
	if start == NO_CELL or incoming == NO_CELL:
		return {}
	return {
		"cell": start,
		"incoming_cell": incoming,
	}


static func _append_authored_tracks(
	result: Array[Dictionary],
	placements_value: Variant,
	kind: StringName
) -> void:
	if not placements_value is Array:
		return
	for value: Variant in placements_value:
		if not value is Dictionary:
			continue
		var placement: Dictionary = value
		var anchor_value: Variant = placement.get("rail_anchor", null)
		if not anchor_value is Dictionary:
			continue
		var anchor: Dictionary = anchor_value
		var cell := snapshot_cell(placement.get("cell", NO_CELL))
		var geometry := StringName(anchor.get("geometry", &""))
		if cell == NO_CELL or geometry == &"":
			continue
		result.append({
			"cell": cell,
			"geometry": geometry,
			"rotation_quarters": int(anchor.get("rotation_quarters", 0)),
			"kind": kind,
		})


static func _cell_size(rect: Rect2, board_size: Vector2i) -> Vector2:
	return Vector2(rect.size.x / float(board_size.x), rect.size.y / float(board_size.y))


static func _cell_rect(cell: Vector2i, rect: Rect2, board_size: Vector2i) -> Rect2:
	var cell_size := _cell_size(rect, board_size)
	return Rect2(rect.position + Vector2(cell.x, cell.y) * cell_size, cell_size)


static func _rotate_direction(direction: Vector2i, quarters: int) -> Vector2i:
	var result := direction
	for _index: int in range(posmod(quarters, 4)):
		result = Vector2i(-result.y, result.x)
	return result


static func _alpha(color: Color, alpha: float) -> Color:
	return Color(color.r, color.g, color.b, alpha)
