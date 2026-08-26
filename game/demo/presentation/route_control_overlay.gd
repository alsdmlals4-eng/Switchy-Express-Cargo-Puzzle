class_name RouteControlOverlay
extends Control

const Palette := preload("res://game/demo/presentation/demo_palette.gd")
const SemanticAssetCatalogScript := preload("res://game/demo/presentation/semantic_asset_catalog.gd")
const SemanticRuntimeStateScript := preload("res://game/demo/presentation/semantic_runtime_state.gd")
const NO_CELL := Vector2i(-1, -1)
const MIN_DIRECTION_TARGET := 44.0

var _snapshot: Dictionary = {}
var _route_selection_requests: Array[Dictionary] = []
var _catalog: Variant


func _init() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_catalog = SemanticAssetCatalogScript.new()
	_catalog.load_default()


func _ready() -> void:
	_refresh_mouse_filter()


func apply_snapshot(snapshot: Dictionary) -> void:
	_snapshot = snapshot.duplicate(true)
	if not _is_active_phase():
		_route_selection_requests.clear()
	_refresh_mouse_filter()
	queue_redraw()


func snapshot_for_test() -> Dictionary:
	return _snapshot.duplicate(true)


func direction_targets_for_test() -> Array[Dictionary]:
	return _direction_targets()


func semantic_target_descriptors_for_test() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for target: Dictionary in _direction_targets():
		var semantic := target.duplicate(true)
		var state: StringName = SemanticRuntimeStateScript.route_target_state(target)
		var record: Dictionary = _semantic_record(state)
		semantic["semantic_state"] = state
		semantic["input_paths"] = _input_paths(record)
		result.append(semantic)
	return result


func consume_route_selection_requests() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for request: Dictionary in _route_selection_requests:
		result.append(request.duplicate(true))
	_route_selection_requests.clear()
	return result


func _gui_input(event: InputEvent) -> void:
	if not _is_active_phase():
		return
	if not event is InputEventMouseButton:
		return
	var mouse_event := event as InputEventMouseButton
	if mouse_event.button_index != MOUSE_BUTTON_LEFT or not mouse_event.pressed:
		return
	for target: Dictionary in _direction_targets():
		if bool(target.get("locked", false)):
			continue
		var hit_rect: Rect2 = target.get("hit_rect", Rect2())
		if not hit_rect.has_point(mouse_event.position):
			continue
		var cycle_count := int(target.get("cycle_count", 0))
		if cycle_count <= 0:
			accept_event()
			return
		_route_selection_requests.append({
			"cell": target.get("cell", NO_CELL),
			"cycle_count": cycle_count,
			"target_port": target.get("port", Vector2i.ZERO),
		})
		accept_event()
		return


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
	var cell_rect := _cell_rect(cell, rect, board_size)
	var center := cell_rect.get_center()
	var locked := bool(descriptor.get("locked", false))
	for target: Dictionary in _direction_targets_for_switch(descriptor, cell, cell_rect):
		var port: Vector2i = target.get("port", Vector2i.ZERO)
		var selected := bool(target.get("selected", false))
		var direction := Vector2(port)
		if direction == Vector2.ZERO:
			continue
		var arrow_end := center + direction * minf(cell_rect.size.x, cell_rect.size.y) * 0.39
		var color := Palette.SWITCH_ACTIVE if selected else Palette.SWITCH_INACTIVE
		if locked:
			color = Palette.ROUTE_LOCKED
		var width := 8.0 if selected else 4.0
		draw_line(center, arrow_end, color, width, true)
		_draw_arrow(center, arrow_end, color)
		if selected:
			draw_circle(center + direction * minf(cell_rect.size.x, cell_rect.size.y) * 0.18, 6.0, color)
		else:
			draw_arc(
				center + direction * minf(cell_rect.size.x, cell_rect.size.y) * 0.18,
				5.0,
				0.0,
				TAU,
				16,
				color,
				2.0,
				true
			)
		_draw_semantic_target(target)
	draw_circle(center, 5.0, Palette.ROUTE_LOCKED if locked else Palette.BOARD_EDGE)


func _draw_crossing(
	descriptor: Dictionary,
	cell: Vector2i,
	rect: Rect2,
	board_size: Vector2i
) -> void:
	var cell_rect := _cell_rect(cell, rect, board_size).grow(-8.0)
	var center := cell_rect.get_center()
	var color := crossing_visual_color_for_test(descriptor)
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


static func crossing_visual_color_for_test(descriptor: Dictionary) -> Color:
	return Palette.ROUTE_LOCKED if bool(descriptor.get("locked", false)) else Palette.SELECTED


func _direction_targets() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	var board_size := _cell(_snapshot.get("board_size", Vector2i.ZERO))
	if board_size.x <= 0 or board_size.y <= 0:
		return result
	var rect := _board_rect()
	for value: Variant in _snapshot.get("route_controls", []):
		if not value is Dictionary:
			continue
		var descriptor: Dictionary = value
		if StringName(descriptor.get("kind", &"")) != &"SWITCH":
			continue
		var cell := _cell(descriptor.get("cell", NO_CELL))
		if cell == NO_CELL:
			continue
		result.append_array(
			_direction_targets_for_switch(
				descriptor,
				cell,
				_cell_rect(cell, rect, board_size)
			)
		)
	return result


func _direction_targets_for_switch(
	descriptor: Dictionary,
	cell: Vector2i,
	cell_rect: Rect2
) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	var ports: Array[Vector2i] = []
	for value: Variant in descriptor.get("available_exits", []):
		var port := _cell(value)
		if port != NO_CELL and port != Vector2i.ZERO and not ports.has(port):
			ports.append(port)
	if ports.is_empty():
		return result

	var selected := _cell(descriptor.get("selected_exit", Vector2i.ZERO))
	var selected_index := ports.find(selected)
	var min_dimension := minf(cell_rect.size.x, cell_rect.size.y)
	var maximum_target := maxf(min_dimension * 0.72, 0.0)
	var target_size := MIN_DIRECTION_TARGET if maximum_target >= MIN_DIRECTION_TARGET else maximum_target
	var center := cell_rect.get_center()
	var target_offset := min_dimension * 0.31
	for index: int in range(ports.size()):
		var port: Vector2i = ports[index]
		var target_center := center + Vector2(port) * target_offset
		var cycle_count := 0
		if selected_index >= 0:
			cycle_count = (index - selected_index + ports.size()) % ports.size()
		result.append({
			"cell": cell,
			"port": port,
			"selected": port == selected,
			"locked": bool(descriptor.get("locked", false)),
			"cycle_count": cycle_count,
			"hit_rect": Rect2(
				target_center - Vector2(target_size, target_size) * 0.5,
				Vector2(target_size, target_size)
			),
		})
	return result


func _draw_semantic_target(target: Dictionary) -> void:
	var state: StringName = SemanticRuntimeStateScript.route_target_state(target)
	var record: Dictionary = _semantic_record(state)
	if record.is_empty() or _catalog == null or not _catalog.is_ready():
		return
	var hit_rect: Rect2 = target.get("hit_rect", Rect2())
	if hit_rect.size == Vector2.ZERO:
		return
	var textures: Array[Texture2D] = _catalog.textures_for(record)
	for texture: Texture2D in textures:
		if texture != null:
			draw_texture_rect(texture, hit_rect, false)


func _semantic_record(state: StringName) -> Dictionary:
	if _catalog == null or not _catalog.is_ready() or state == &"":
		return {}
	return _catalog.composition(&"switch_direction", state)


static func _input_paths(record: Dictionary) -> Array[String]:
	var result: Array[String] = []
	var inputs: Variant = record.get("inputs", [])
	if not inputs is Array:
		return result
	for path: Variant in inputs:
		result.append(str(path))
	return result


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


func _refresh_mouse_filter() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP if _is_active_phase() else Control.MOUSE_FILTER_IGNORE


func _is_active_phase() -> bool:
	var phase := StringName(_snapshot.get("phase", &""))
	return phase == &"RUNNING" or phase == &"UNLOADING"


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
