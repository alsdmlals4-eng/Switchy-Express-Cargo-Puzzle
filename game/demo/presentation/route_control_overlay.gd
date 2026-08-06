class_name RouteControlOverlay
extends Control

const Palette := preload("res://game/demo/presentation/demo_palette.gd")
const NO_CELL := Vector2i(-1, -1)

var _snapshot: Dictionary = {}


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE


func apply_snapshot(snapshot: Dictionary) -> void:
	_snapshot = snapshot.duplicate(true)
	queue_redraw()


func snapshot_for_test() -> Dictionary:
	return _snapshot.duplicate(true)


func _draw() -> void:
	var board_size := _cell(_snapshot.get("board_size", Vector2i.ZERO))
	if board_size.x <= 0 or board_size.y <= 0:
		return
	var rect := _board_rect()
	for value: Variant in _snapshot.get("route_controls", []):
		if not value is Dictionary:
			continue
		var descriptor: Dictionary = value
		var cell := _cell(descriptor.get("cell", NO_CELL))
		if cell == NO_CELL:
			continue
		var kind := StringName(descriptor.get("kind", &""))
		if kind == &"SWITCH":
			_draw_switch(descriptor, cell, rect, board_size)
		elif kind == &"CROSSING":
			_draw_crossing(descriptor, cell, rect, board_size)


func _draw_switch(
	descriptor: Dictionary,
	cell: Vector2i,
	rect: Rect2,
	board_size: Vector2i
) -> void:
	var center := _cell_rect(cell, rect, board_size).get_center()
	var half := _cell_size(rect, board_size) * 0.39
	var approach := _cell(descriptor.get("approach_port", Vector2i.ZERO))
	var selected := _cell(descriptor.get("selected_exit", Vector2i.ZERO))
	if approach == NO_CELL or selected == NO_CELL:
		return
	var color := Palette.SELECTED
	if bool(descriptor.get("locked", false)):
		color = Palette.TRAIN_ACCENT
	var approach_end := center + Vector2(approach.x * half.x, approach.y * half.y)
	var selected_end := center + Vector2(selected.x * half.x, selected.y * half.y)
	draw_line(approach_end, center, color, 7.0, true)
	draw_line(center, selected_end, color, 7.0, true)
	_draw_arrow(center, selected_end, color)
	draw_circle(center, 5.0, color)


func _draw_crossing(
	descriptor: Dictionary,
	cell: Vector2i,
	rect: Rect2,
	board_size: Vector2i
) -> void:
	var cell_rect := _cell_rect(cell, rect, board_size).grow(-8.0)
	var center := cell_rect.get_center()
	var color := Palette.SELECTED
	if bool(descriptor.get("locked", false)):
		color = Palette.TRAIN_ACCENT
	draw_circle(center, minf(cell_rect.size.x, cell_rect.size.y) * 0.22, Palette.BOARD_EDGE)
	draw_circle(center, minf(cell_rect.size.x, cell_rect.size.y) * 0.17, color)
	var mode := StringName(descriptor.get("mode", &"STRAIGHT"))
	var label := "직"
	if mode == &"RIGHT":
		label = "우"
	elif mode == &"LEFT":
		label = "좌"
	var font := ThemeDB.fallback_font
	var font_size := 15
	var text_size := font.get_string_size(label, HORIZONTAL_ALIGNMENT_LEFT, -1.0, font_size)
	draw_string(
		font,
		center + Vector2(-text_size.x * 0.5, text_size.y * 0.34),
		label,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1.0,
		font_size,
		Palette.TEXT_LIGHT
	)


func _draw_arrow(from: Vector2, to: Vector2, color: Color) -> void:
	var direction := (to - from).normalized()
	if direction == Vector2.ZERO:
		return
	var perpendicular := Vector2(-direction.y, direction.x)
	var tip := to
	var base := tip - direction * 11.0
	draw_colored_polygon(
		PackedVector2Array([
			tip,
			base + perpendicular * 6.0,
			base - perpendicular * 6.0,
		]),
		color
	)


func _board_rect() -> Rect2:
	return Rect2(
		Vector2(Palette.BOARD_PADDING, Palette.BOARD_PADDING),
		Vector2(
			maxf(size.x - Palette.BOARD_PADDING * 2.0, 0.0),
			maxf(size.y - Palette.BOARD_PADDING * 2.0, 0.0)
		)
	)


static func _cell_rect(cell: Vector2i, rect: Rect2, board_size: Vector2i) -> Rect2:
	var size := _cell_size(rect, board_size)
	return Rect2(
		rect.position + Vector2(float(cell.x) * size.x, float(cell.y) * size.y),
		size
	)


static func _cell_size(rect: Rect2, board_size: Vector2i) -> Vector2:
	return Vector2(
		rect.size.x / float(board_size.x),
		rect.size.y / float(board_size.y)
	)


static func _cell(value: Variant) -> Vector2i:
	if value is Vector2i:
		return value
	if value is Vector2:
		return Vector2i(int(value.x), int(value.y))
	if value is Array and value.size() == 2:
		return Vector2i(int(value[0]), int(value[1]))
	if value is Dictionary and value.has("x") and value.has("y"):
		return Vector2i(int(value.get("x", -1)), int(value.get("y", -1)))
	return NO_CELL
