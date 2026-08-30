class_name ProductBoardRenderer
extends Control

signal cell_primary_requested(cell: Vector2i)
signal cell_secondary_requested(cell: Vector2i)
signal hover_changed(cell: Vector2i)

const Palette := preload("res://game/demo/presentation/demo_palette.gd")
const SemanticAssetCatalogScript := preload("res://game/demo/presentation/semantic_asset_catalog.gd")
const SemanticRuntimeStateScript := preload("res://game/demo/presentation/semantic_runtime_state.gd")
const FiniteTrackGraphScript := preload("res://game/finite/rail/finite_track_graph.gd")
const TrackPieceScript := preload("res://game/finite/build/track_piece.gd")
const NO_CELL := Vector2i(-1, -1)
const GHOST_FILL_ALPHA := 0.08
const GHOST_TRACK_ALPHA := 0.46
const GHOST_SEMANTIC_BADGE_SCALE := 0.28
const CARGO_MARKER_SCALE := 0.62

const PRODUCT_VISUAL_ASSET_PATHS := {
	"board_terrain": "art/product_assets/ed_hybrid_v2/board/board_terrain_playfield_v02.png",
	"decoration_forest_cluster": "art/product_assets/ed_hybrid_v2/board/board_decor_forest_cluster_v01.png",
	"decoration_moss_boulder": "art/product_assets/ed_hybrid_v2/board/board_decor_moss_boulder_v01.png",
	"decoration_timber_stack": "art/product_assets/ed_hybrid_v2/board/board_decor_timber_stack_v01.png",
	"decoration_waterway": "art/product_assets/ed_hybrid_v2/board/board_decor_waterway_v01.png",
	"decoration_lantern_fence": "art/product_assets/ed_hybrid_v2/board/board_decor_lantern_fence_v01.png",
	"caution_track": "art/product_assets/ed_hybrid_v2/board/board_caution_track_overlay_v01.png",
	"train": "art/product_assets/ed_hybrid_v2/core/core_train_locomotive_blue_normal_v02.png",
	"rail_straight": "art/product_assets/ed_hybrid_v2/core/core_rail_straight_normal_v04.png",
	"rail_curve": "art/product_assets/ed_hybrid_v2/core/core_rail_curve_normal_v04.png",
	"rail_crossing": "art/product_assets/ed_hybrid_v2/core/core_rail_crossing_normal_v04.png",
	"rail_switch": "art/product_assets/ed_hybrid_v2/core/core_rail_switch_three_way_normal_v04.png",
	"start_marker": "art/product_assets/ed_hybrid_v2/core/core_marker_start_normal_v02.png",
	"route_end_marker": "art/product_assets/ed_hybrid_v2/core/core_marker_route_end_normal_v02.png",
	"station_red": "art/product_assets/ed_hybrid_v2/core/core_station_red_normal_v02.png",
	"station_blue": "art/product_assets/ed_hybrid_v2/core/core_station_blue_normal_v02.png",
	"station_yellow": "art/product_assets/ed_hybrid_v2/core/core_station_yellow_normal_v02.png",
	"station_disposal": "art/product_assets/ed_hybrid_v2/core/core_disposal_yard_normal_v01.png",
	"cargo_red": "art/product_assets/ed_hybrid_v2/core/core_cargo_star_red_normal_v02.png",
	"cargo_blue": "art/product_assets/ed_hybrid_v2/core/core_cargo_star_blue_normal_v02.png",
	"cargo_yellow": "art/product_assets/ed_hybrid_v2/core/core_cargo_star_yellow_normal_v02.png",
	"cargo_waste": "art/product_assets/ed_hybrid_v2/core/core_cargo_waste_crate_normal_v01.png",
}

var _snapshot: Dictionary = {}
var _hover_cell: Vector2i = NO_CELL
var _catalog: Variant
var _product_textures: Dictionary = {}


func _init() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	focus_mode = Control.FOCUS_NONE
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_catalog = SemanticAssetCatalogScript.new()
	_catalog.load_default()
	_load_product_visuals()


func apply_snapshot(snapshot: Dictionary) -> void:
	_snapshot = snapshot.duplicate(true)
	queue_redraw()


func snapshot_for_test() -> Dictionary:
	return _snapshot.duplicate(true)


func ghost_descriptor_for_test() -> Dictionary:
	return _ghost_descriptor()


func semantic_build_descriptor_for_test() -> Dictionary:
	return _semantic_build_descriptor()


func product_visual_asset_paths_for_test() -> Dictionary:
	return PRODUCT_VISUAL_ASSET_PATHS.duplicate(true)


func loaded_product_visuals_for_test() -> Dictionary:
	var result: Dictionary = {}
	for key: Variant in PRODUCT_VISUAL_ASSET_PATHS.keys():
		result[str(key)] = _product_textures.get(str(key)) is Texture2D
	return result


func product_rail_seam_descriptor_for_test(geometry: StringName, rotation: int) -> Dictionary:
	return _product_rail_seam_descriptor(geometry, rotation)


func marker_target_for_test(is_station: bool, cell_rect: Rect2) -> Rect2:
	return _marker_target_rect(is_station, cell_rect)


func ghost_presentation_for_test() -> Dictionary:
	return _ghost_presentation()


func ghost_status_badge_rect_for_test(cell_rect: Rect2) -> Rect2:
	return _ghost_status_badge_rect(cell_rect)


func station_service_descriptors_for_test() -> Array[Dictionary]:
	return _station_service_descriptors(_snapshot)


func route_visual_descriptors_for_test() -> Array[Dictionary]:
	return _route_visual_descriptors(_snapshot)


func route_visual_widths_for_test(viewport: Vector2, board_size: Vector2i) -> Dictionary:
	if viewport.x <= 0.0 or viewport.y <= 0.0 or board_size.x <= 0 or board_size.y <= 0:
		return {}
	var board_extent := Vector2(
		maxf(viewport.x - Palette.BOARD_PADDING * 2.0, 0.0),
		maxf(viewport.y - Palette.BOARD_PADDING * 2.0, 0.0)
	)
	var cell_size := Vector2(
		board_extent.x / float(board_size.x),
		board_extent.y / float(board_size.y)
	)
	return {
		&"SELECTED": _route_visual_width(&"SELECTED", cell_size),
	}


func wayside_presentation_descriptors_for_test() -> Dictionary:
	return _wayside_presentation_descriptors(_snapshot)


func visual_layer_order_for_test() -> Array[StringName]:
	return [
		&"TERRAIN",
		&"DECORATION",
		&"GRID",
		&"BLOCKED",
		&"CAUTION",
		&"FIXED_TRACK",
		&"LAYOUT",
		&"STATION_SERVICE",
		&"ROUTE",
		&"MARKERS",
		&"START",
		&"STATE",
		&"TRAIN",
	]


static func track_ports_for_test(geometry: StringName, rotation: int) -> Array[Vector2i]:
	return _track_ports(geometry, rotation)


static func product_texture_draw_rect_for_test(target: Rect2, rotation_quarters: int) -> Rect2:
	return _product_texture_local_draw_rect(target, rotation_quarters)


static func product_texture_port_position_for_test(
	base_port: Vector2i,
	target: Rect2,
	rotation_quarters: int
) -> Vector2:
	var local_rect := _product_texture_local_draw_rect(target, rotation_quarters)
	var local_port := Vector2(
		float(base_port.x) * local_rect.size.x * 0.5,
		float(base_port.y) * local_rect.size.y * 0.5
	)
	return target.get_center() + _rotate_vector_by_quarters(local_port, rotation_quarters)


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
	_draw_board_terrain(rect)
	_draw_board_decorations(rect, board_size)
	_draw_grid(rect, board_size)
	_draw_blocked(rect, board_size)
	_draw_caution_tracks(rect, board_size)
	_draw_fixed_tracks(rect, board_size)
	_draw_layout(rect, board_size)
	_draw_station_service_ranges(rect, board_size)
	_draw_route_visual_overlays(rect, board_size)
	_draw_fixed_markers(rect, board_size)
	_draw_start_marker(rect, board_size)
	_draw_state_overlays(rect, board_size)
	_draw_train(rect, board_size)


func _draw_board_terrain(rect: Rect2) -> void:
	var terrain := _product_textures.get("board_terrain") as Texture2D
	if terrain == null:
		return
	draw_texture_rect(terrain, rect, false, Palette.BOARD_TERRAIN_TINT)
	draw_rect(rect, Palette.BOARD_TERRAIN_VEIL, true)


func _draw_board_decorations(rect: Rect2, board_size: Vector2i) -> void:
	for decoration: Dictionary in _wayside_presentation_descriptors(_snapshot)["board_decorations"]:
		var asset_key := _decoration_asset_key(StringName(decoration["kind"]))
		if asset_key == "":
			continue
		_draw_product_texture(
			asset_key,
			_cell_rect(decoration["cell"], rect, board_size).grow(-1.0)
		)


func _draw_caution_tracks(rect: Rect2, board_size: Vector2i) -> void:
	for cell: Vector2i in _wayside_presentation_descriptors(_snapshot)["caution_track_cells"]:
		_draw_product_texture("caution_track", _cell_rect(cell, rect, board_size).grow(-2.0))


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


func _draw_route_visual_overlays(rect: Rect2, board_size: Vector2i) -> void:
	for descriptor: Dictionary in _route_visual_descriptors(_snapshot):
		var state := StringName(descriptor.get("state", &"INACTIVE"))
		if state == &"INACTIVE":
			continue
		var cell := snapshot_cell(descriptor.get("cell", NO_CELL))
		if cell == NO_CELL:
			continue
		var color := _route_visual_color(state)
		var cell_size := _cell_size(rect, board_size)
		var width := _route_visual_width(state, cell_size)
		var center := _cell_rect(cell, rect, board_size).get_center()
		var half := cell_size * 0.42
		for port_value: Variant in descriptor.get("ports", []):
			var port := snapshot_cell(port_value)
			if port == NO_CELL or port == Vector2i.ZERO:
				continue
			var endpoint := center + Vector2(port) * half
			draw_line(center, endpoint, _alpha(Palette.BOARD_EDGE, 0.72), width + 4.0, true)
			draw_line(center, endpoint, color, width, true)
		if state == &"SELECTED":
			_draw_route_direction_cue(center, descriptor.get("outgoing_port", Vector2i.ZERO), half, color)
			if bool(descriptor.get("locked", false)):
				_draw_route_lock_cue(center, width)


func _draw_route_lock_cue(center: Vector2, route_width: float) -> void:
	var body_size := maxf(route_width * 0.72, 5.0)
	var body := Rect2(
		center + Vector2(-body_size * 0.50, -body_size * 0.08),
		Vector2(body_size, body_size * 0.74)
	)
	draw_circle(center + Vector2(0.0, -body_size * 0.14), body_size * 0.55, Palette.BOARD_EDGE)
	draw_circle(center + Vector2(0.0, -body_size * 0.14), body_size * 0.36, Palette.ROUTE_LOCKED)
	draw_rect(body.grow(1.5), Palette.BOARD_EDGE, true)
	draw_rect(body, Palette.ROUTE_LOCKED, true)


func _draw_route_direction_cue(
	center: Vector2,
	outgoing_value: Variant,
	half: Vector2,
	color: Color
) -> void:
	var outgoing := snapshot_cell(outgoing_value)
	if outgoing == NO_CELL or outgoing == Vector2i.ZERO:
		return
	var direction := Vector2(outgoing).normalized()
	var cue_center := center + direction * minf(half.x, half.y) * 0.48
	var perpendicular := Vector2(-direction.y, direction.x)
	var tip := cue_center + direction * 7.0
	var base := cue_center - direction * 5.0
	draw_colored_polygon(
		PackedVector2Array([
			tip,
			base + perpendicular * 4.5,
			base - perpendicular * 4.5,
		]),
		color
	)


static func _route_visual_color(state: StringName) -> Color:
	match state:
		&"SELECTED":
			return Palette.ROUTE_SELECTED
		_:
			return Palette.ROUTE_INACTIVE


static func _route_visual_width(state: StringName, cell_size: Vector2) -> float:
	var base := clampf(minf(cell_size.x, cell_size.y) * 0.15, 5.0, 12.0)
	match state:
		&"SELECTED":
			return base
		_:
			return maxf(base * 0.45, 3.0)


static func _route_visual_descriptors(snapshot: Dictionary) -> Array[Dictionary]:
	var phase := StringName(snapshot.get("phase", &"BUILD"))
	if not _route_visual_phase(phase):
		return []
	var graph: Variant = _route_visual_graph(snapshot)
	if graph == null:
		return []
	var route: Array[Dictionary] = _selected_route_segments(graph, snapshot)
	if route.is_empty():
		return []
	var locked_cells := _locked_route_control_cells(snapshot)
	var result: Array[Dictionary] = []
	for segment: Dictionary in route:
		var cell := snapshot_cell(segment.get("cell", NO_CELL))
		if cell == NO_CELL:
			continue
		result.append({
			"cell": cell,
			"state": &"SELECTED",
			"ports": segment.get("ports", []),
			"outgoing_port": segment.get("outgoing_port", Vector2i.ZERO),
			"locked": locked_cells.has(cell),
		})
	return result


static func _route_visual_phase(phase: StringName) -> bool:
	return phase == &"RUNNING" or phase == &"UNLOADING" or phase == &"PAUSED"


static func _route_visual_graph(snapshot: Dictionary) -> Variant:
	var pieces: Array[Variant] = []
	for descriptor: Dictionary in fixed_track_descriptors(snapshot):
		_append_route_visual_piece(pieces, descriptor)
	for value: Variant in snapshot.get("layout_pieces", []):
		if value is Dictionary:
			_append_route_visual_piece(pieces, value)
	if pieces.is_empty():
		return null
	var graph: Variant = FiniteTrackGraphScript.new(pieces)
	_apply_route_control_selection(graph, snapshot.get("route_controls", []))
	return graph


static func _append_route_visual_piece(pieces: Array[Variant], descriptor: Dictionary) -> void:
	var cell := snapshot_cell(descriptor.get("cell", NO_CELL))
	var geometry := StringName(descriptor.get("geometry", &""))
	if cell == NO_CELL or geometry == &"":
		return
	for existing: Variant in pieces:
		if existing != null and existing.cell == cell:
			return
	var piece: Variant = TrackPieceScript.create(
		cell,
		geometry,
		int(descriptor.get("rotation_quarters", 0)),
		snapshot_cell(descriptor.get("switch_initial_exit", Vector2i.ZERO))
	)
	if piece != null:
		pieces.append(piece)


static func _apply_route_control_selection(graph: Variant, states: Variant) -> void:
	if graph == null or not states is Array:
		return
	for value: Variant in states:
		if not value is Dictionary:
			continue
		var state: Dictionary = value
		var cell := snapshot_cell(state.get("cell", NO_CELL))
		if cell == NO_CELL:
			continue
		if StringName(state.get("kind", &"")) == &"SWITCH":
			graph.select_switch_exit(cell, snapshot_cell(state.get("selected_exit", Vector2i.ZERO)))
		elif StringName(state.get("kind", &"")) == &"CROSSING":
			var desired_mode := StringName(state.get("mode", &"STRAIGHT"))
			for _index: int in range(3):
				var current := _route_control_state_at(graph.route_control_states(), cell)
				if StringName(current.get("mode", &"STRAIGHT")) == desired_mode:
					break
				graph.cycle_route_control(cell)


static func _route_control_state_at(states: Array, cell: Vector2i) -> Dictionary:
	for value: Variant in states:
		if value is Dictionary and snapshot_cell(value.get("cell", NO_CELL)) == cell:
			return value
	return {}


static func _selected_route_segments(graph: Variant, snapshot: Dictionary) -> Array[Dictionary]:
	var start := snapshot_cell(snapshot.get("train_cell", NO_CELL))
	var incoming := snapshot_cell(snapshot.get("train_previous_cell", NO_CELL))
	if graph == null:
		return []
	if start == NO_CELL or incoming == NO_CELL or not graph.has_cell(start):
		start = snapshot_cell(snapshot.get("start_cell", NO_CELL))
		incoming = snapshot_cell(snapshot.get("incoming_cell", NO_CELL))
	if start == NO_CELL or incoming == NO_CELL or not graph.has_cell(start):
		return []
	var result: Array[Dictionary] = []
	var seen: Dictionary = {}
	var current := start
	var previous := incoming
	for _step: int in range(maxi(graph.all_cells().size() * 2, 1)):
		var state_key := "%d,%d:%d,%d" % [current.x, current.y, previous.x, previous.y]
		if seen.has(state_key):
			break
		seen[state_key] = true
		var incoming_port := previous - current
		var next: Vector2i = graph.next_cell(current, previous)
		var outgoing_port := next - current if next != current else Vector2i.ZERO
		var ports: Array[Vector2i] = []
		if incoming_port != Vector2i.ZERO:
			ports.append(incoming_port)
		if outgoing_port != Vector2i.ZERO and not ports.has(outgoing_port):
			ports.append(outgoing_port)
		result.append({
			"cell": current,
			"ports": ports,
			"outgoing_port": outgoing_port,
		})
		if next == current:
			break
		previous = current
		current = next
	return result


static func _locked_route_control_cells(snapshot: Dictionary) -> Dictionary:
	var result: Dictionary = {}
	for value: Variant in snapshot.get("route_controls", []):
		if value is Dictionary and bool(value.get("locked", false)):
			var cell := snapshot_cell(value.get("cell", NO_CELL))
			if cell != NO_CELL:
				result[cell] = true
	return result


func _draw_station_service_ranges(rect: Rect2, board_size: Vector2i) -> void:
	for descriptor: Dictionary in _station_service_descriptors(_snapshot):
		var color: Color = Palette.cargo_color(StringName(descriptor["cargo_type"]))
		for service_cell: Vector2i in descriptor["service_cells"]:
			var target := _cell_rect(service_cell, rect, board_size).grow(-7.0)
			draw_rect(target, _alpha(Palette.TEXT_LIGHT, 0.18), false, 1.5)
			draw_rect(target.grow(-2.0), _alpha(color, 0.28), false, 2.0)


func _draw_track_piece(
	cell: Vector2i,
	geometry: StringName,
	rotation: int,
	rect: Rect2,
	board_size: Vector2i,
	bed_color: Color,
	rail_color: Color
) -> void:
	var target := _cell_rect(cell, rect, board_size)
	var asset_key := _track_asset_key(geometry)
	var has_product_art := asset_key != "" and _product_textures.get(asset_key) is Texture2D
	if has_product_art and _draw_product_texture(asset_key, target, rotation, bed_color.a):
		return

	var center := target.get_center()
	var half := _cell_size(rect, board_size) * 0.44
	var directions: Array[Vector2i] = _track_ports(geometry, rotation)
	if directions.is_empty():
		return
	for direction: Vector2i in directions:
		var endpoint := center + Vector2(direction.x * half.x, direction.y * half.y)
		draw_line(center, endpoint, bed_color, Palette.RAIL_WIDTH, true)
		draw_line(center, endpoint, rail_color, Palette.RAIL_HIGHLIGHT_WIDTH, true)
	if geometry == &"SWITCH":
		draw_circle(center, minf(half.x, half.y) * 0.18, rail_color)

static func _product_rail_seam_descriptor(geometry: StringName, rotation: int) -> Dictionary:
	return {"enabled": false, "ports": []}


func _draw_fixed_markers(rect: Rect2, board_size: Vector2i) -> void:
	for value: Variant in _snapshot.get("station_placements", []):
		var placement: Dictionary = value
		_draw_marker(
			placement.get("cell", NO_CELL),
			StringName(placement.get("cargo_type", &"")),
			true,
			rect,
			board_size,
			StringName(placement.get("destination_kind", &"STATION"))
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
	board_size: Vector2i,
	destination_kind: StringName = &"STATION"
) -> void:
	var cell := snapshot_cell(cell_value)
	if cell == NO_CELL:
		return
	var cell_rect := _cell_rect(cell, rect, board_size)
	var marker_rect := _marker_target_rect(is_station, cell_rect)
	var color: Color = Palette.cargo_color(cargo_type)
	var asset_key := _marker_asset_key(cargo_type, is_station, destination_kind)
	var drew_product_art := _draw_product_texture(asset_key, marker_rect)
	if not drew_product_art:
		if is_station:
			draw_rect(marker_rect, _alpha(color, 0.22), true)
			draw_rect(marker_rect, color, false, 4.0)
		else:
			draw_circle(marker_rect.get_center(), minf(marker_rect.size.x, marker_rect.size.y) * 0.27, Palette.BOARD_EDGE)
	else:
		# Keep a non-color outline even when the approved sprite is available.
		if is_station:
			draw_rect(marker_rect, color, false, 2.0)
		else:
			draw_circle(marker_rect.get_center(), minf(marker_rect.size.x, marker_rect.size.y) * 0.24, Palette.BOARD_EDGE, false, 2.0)
	_draw_cargo_shape(
		marker_rect.get_center(),
		cargo_type,
		minf(marker_rect.size.x, marker_rect.size.y) * (0.11 if drew_product_art else 0.20),
		color
	)
	_draw_marker_label(marker_rect.get_center(), cargo_type)


static func _marker_target_rect(is_station: bool, cell_rect: Rect2) -> Rect2:
	if is_station:
		return cell_rect.grow(-5.0)
	var cargo_side := minf(cell_rect.size.x, cell_rect.size.y) * CARGO_MARKER_SCALE
	var cargo_size := Vector2(cargo_side, cargo_side)
	return Rect2(cell_rect.get_center() - cargo_size * 0.5, cargo_size)


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
	var quarters := _rotation_quarters_for_direction(Vector2i(roundi(direction.x), roundi(direction.y)))
	var drew_product_art := _draw_product_texture("start_marker", cell_rect, quarters)
	if not drew_product_art:
		draw_circle(center, radius, Palette.BOARD_EDGE)
		draw_circle(center, radius * 0.78, Palette.SELECTED)
	var tip := center + direction * radius * 0.66
	var base := center - direction * radius * 0.34
	draw_colored_polygon(PackedVector2Array([
		tip,
		base + perpendicular * radius * 0.34,
		base - perpendicular * radius * 0.34,
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
	elif cargo_type == &"WASTE_CRATE":
		var square := Rect2(center - Vector2(radius, radius), Vector2(radius * 2.0, radius * 2.0))
		draw_rect(square, color, true)
		draw_rect(square, Palette.BOARD_EDGE, false, maxf(radius * 0.22, 1.0))
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
			var problem_rect := _cell_rect(problem, rect, board_size).grow(-2.0)
			draw_rect(problem_rect, Palette.PROBLEM, false, 5.0)


func _draw_ghost(rect: Rect2, board_size: Vector2i) -> void:
	var descriptor := _ghost_descriptor()
	if descriptor.is_empty():
		return
	var valid := bool(descriptor.get("valid", false))
	var color: Color = Palette.GHOST_VALID if valid else Palette.GHOST_INVALID
	var cell: Vector2i = descriptor["cell"]
	var cell_rect := _cell_rect(cell, rect, board_size).grow(-5.0)
	var presentation := _ghost_presentation()
	draw_rect(cell_rect, _alpha(color, float(presentation["fill_alpha"])), true)
	_draw_track_piece(
		cell,
		StringName(descriptor["geometry"]),
		int(descriptor.get("rotation_quarters", 0)),
		rect,
		board_size,
		_alpha(color, float(presentation["track_alpha"])),
		color
	)
	_draw_semantic_record(_placement_record(), _ghost_status_badge_rect(cell_rect))


static func _ghost_presentation() -> Dictionary:
	return {
		"fill_alpha": GHOST_FILL_ALPHA,
		"track_alpha": GHOST_TRACK_ALPHA,
		"semantic_badge_scale": GHOST_SEMANTIC_BADGE_SCALE,
	}


static func _ghost_status_badge_rect(cell_rect: Rect2) -> Rect2:
	var side := clampf(
		minf(cell_rect.size.x, cell_rect.size.y) * GHOST_SEMANTIC_BADGE_SCALE,
		12.0,
		20.0
	)
	var margin := 2.0
	var badge_size := Vector2(side, side)
	return Rect2(cell_rect.end - badge_size - Vector2(margin, margin), badge_size)


func _draw_train(rect: Rect2, board_size: Vector2i) -> void:
	var cell: Vector2i = snapshot_cell(_snapshot.get("train_cell", NO_CELL))
	if cell == NO_CELL:
		return
	var cell_rect := _cell_rect(cell, rect, board_size).grow(-6.0)
	var next_cell: Vector2i = snapshot_cell(_snapshot.get("train_next_cell", NO_CELL))
	var direction := Vector2.RIGHT
	if next_cell != NO_CELL:
		direction = Vector2(next_cell - cell).normalized()
	var quarters := _rotation_quarters_for_direction(
		Vector2i(roundi(direction.x), roundi(direction.y))
	)
	var drew_product_art := _draw_product_texture("train", cell_rect, quarters)
	if not drew_product_art:
		draw_rect(cell_rect, Palette.TRAIN, true)
		draw_rect(cell_rect, Palette.TRAIN_ACCENT, false, 3.0)
	else:
		draw_rect(cell_rect, Palette.TRAIN_ACCENT, false, 2.0)
	if next_cell != NO_CELL:
		var nose := cell_rect.get_center() + direction * minf(cell_rect.size.x, cell_rect.size.y) * 0.38
		draw_circle(nose, 4.0, Palette.TRAIN_ACCENT)


func _load_product_visuals() -> void:
	_product_textures.clear()
	for key: Variant in PRODUCT_VISUAL_ASSET_PATHS.keys():
		var path := str(PRODUCT_VISUAL_ASSET_PATHS[key])
		var resource: Resource = load("res://%s" % path)
		if resource is Texture2D:
			_product_textures[str(key)] = resource as Texture2D


func _draw_product_texture(
	asset_key: String,
	target: Rect2,
	rotation_quarters: int = 0,
	alpha: float = 1.0
) -> bool:
	var texture := _product_textures.get(asset_key) as Texture2D
	if texture == null:
		return false
	var modulate := Color(1.0, 1.0, 1.0, clampf(alpha, 0.0, 1.0))
	var quarters := posmod(rotation_quarters, 4)
	if quarters == 0:
		draw_texture_rect(texture, target, false, modulate)
		return true
	var center := target.get_center()
	var local_target := _product_texture_local_draw_rect(target, quarters)
	draw_set_transform(center, float(quarters) * PI * 0.5, Vector2.ONE)
	draw_texture_rect(
		texture,
		local_target,
		false,
		modulate
	)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	return true


static func _track_asset_key(geometry: StringName) -> String:
	match geometry:
		&"STRAIGHT":
			return "rail_straight"
		&"CURVE":
			return "rail_curve"
		&"SWITCH":
			return "rail_switch"
		&"CROSSING":
			return "rail_crossing"
		_:
			return ""



static func _marker_asset_key(
	cargo_type: StringName,
	is_station: bool,
	destination_kind: StringName = &"STATION"
) -> String:
	if is_station and destination_kind == &"DISPOSAL_YARD":
		return "station_disposal"
	if not is_station and cargo_type == &"WASTE_CRATE":
		return "cargo_waste"
	var family := _cargo_family(cargo_type)
	return ("station_" if is_station else "cargo_") + family


static func _cargo_family(cargo_type: StringName) -> String:
	var normalized := str(cargo_type).to_upper()
	if normalized.contains("RED"):
		return "red"
	if normalized.contains("YELLOW"):
		return "yellow"
	return "blue"


static func _decoration_asset_key(kind: StringName) -> String:
	match kind:
		&"FOREST_CLUSTER":
			return "decoration_forest_cluster"
		&"MOSS_BOULDER":
			return "decoration_moss_boulder"
		&"TIMBER_STACK":
			return "decoration_timber_stack"
		&"WATERWAY":
			return "decoration_waterway"
		&"LANTERN_FENCE":
			return "decoration_lantern_fence"
		_:
			return ""


static func _wayside_presentation_descriptors(snapshot: Dictionary) -> Dictionary:
	var caution_track_cells: Array[Vector2i] = []
	for value: Variant in snapshot.get("caution_track_cells", []):
		var cell := snapshot_cell(value)
		if cell != NO_CELL and not caution_track_cells.has(cell):
			caution_track_cells.append(cell)

	var board_decorations: Array[Dictionary] = []
	for value: Variant in snapshot.get("board_decorations", []):
		if not value is Dictionary:
			continue
		var placement: Dictionary = value
		var cell := snapshot_cell(placement.get("cell", NO_CELL))
		var kind := StringName(placement.get("kind", &""))
		if cell == NO_CELL or _decoration_asset_key(kind) == "":
			continue
		board_decorations.append({"kind": kind, "cell": cell})
	return {
		"caution_track_cells": caution_track_cells,
		"board_decorations": board_decorations,
	}


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


func _semantic_build_descriptor() -> Dictionary:
	var placement_state: StringName = SemanticRuntimeStateScript.placement_state(
		_ghost_descriptor(),
		_snapshot
	)
	var placement_record: Dictionary = {}
	if placement_state != &"" and _catalog != null and _catalog.is_ready():
		placement_record = _catalog.composition(&"placement_preview", placement_state)
	var focus_state: StringName = SemanticRuntimeStateScript.preflight_focus_state(_snapshot)
	var focus_record := _preflight_focus_record()
	return {
		"placement_state": placement_state,
		"placement_paths": _input_paths(placement_record),
		"preflight_focus_state": focus_state,
		"preflight_focus_paths": _input_paths(focus_record),
	}


func _placement_record() -> Dictionary:
	if _catalog == null or not _catalog.is_ready():
		return {}
	var state: StringName = SemanticRuntimeStateScript.placement_state(_ghost_descriptor(), _snapshot)
	if state == &"":
		return {}
	return _catalog.composition(&"placement_preview", state)


func _preflight_focus_record() -> Dictionary:
	if _catalog == null or not _catalog.is_ready():
		return {}
	var state: StringName = SemanticRuntimeStateScript.preflight_focus_state(_snapshot)
	if state == &"":
		return {}
	return _catalog.composition(&"preflight_notice", state)


func _draw_semantic_record(record: Dictionary, target: Rect2) -> void:
	if record.is_empty() or _catalog == null or not _catalog.is_ready():
		return
	var textures: Array[Texture2D] = _catalog.textures_for(record)
	for texture: Texture2D in textures:
		if texture != null:
			draw_texture_rect(texture, target, false)


static func _input_paths(record: Dictionary) -> Array[String]:
	var result: Array[String] = []
	var inputs: Variant = record.get("inputs", [])
	if not inputs is Array:
		return result
	for path: Variant in inputs:
		result.append(str(path))
	return result


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


static func _station_service_descriptors(snapshot: Dictionary) -> Array[Dictionary]:
	var board_size := snapshot_cell(snapshot.get("board_size", NO_CELL))
	var result: Array[Dictionary] = []
	var directions: Array[Vector2i] = [
		Vector2i.UP,
		Vector2i.RIGHT,
		Vector2i.DOWN,
		Vector2i.LEFT,
	]
	for value: Variant in snapshot.get("station_placements", []):
		if not value is Dictionary:
			continue
		var placement: Dictionary = value
		var station_cell := snapshot_cell(placement.get("cell", NO_CELL))
		if station_cell == NO_CELL:
			continue
		var service_cells: Array[Vector2i] = []
		for direction: Vector2i in directions:
			var candidate := station_cell + direction
			if _is_board_cell(candidate, board_size):
				service_cells.append(candidate)
		result.append({
			"station_cell": station_cell,
			"cargo_type": StringName(placement.get("cargo_type", &"")),
			"service_cells": service_cells,
		})
	return result


static func _is_board_cell(cell: Vector2i, board_size: Vector2i) -> bool:
	return cell.x >= 0 and cell.y >= 0 and cell.x < board_size.x and cell.y < board_size.y


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


static func _track_ports(geometry: StringName, rotation: int) -> Array[Vector2i]:
	var base_ports: Array[Vector2i] = []
	match geometry:
		&"STRAIGHT":
			base_ports = [Vector2i.LEFT, Vector2i.RIGHT]
		&"CURVE":
			base_ports = [Vector2i.UP, Vector2i.RIGHT]
		&"SWITCH":
			base_ports = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP]
		&"CROSSING":
			base_ports = [Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT]
		_:
			return []
	var result: Array[Vector2i] = []
	for port: Vector2i in base_ports:
		result.append(_rotate_direction(port, rotation))
	return result


static func _product_texture_local_draw_rect(target: Rect2, rotation_quarters: int) -> Rect2:
	var local_size := target.size
	if posmod(rotation_quarters, 4) % 2 == 1:
		local_size = Vector2(target.size.y, target.size.x)
	return Rect2(-local_size * 0.5, local_size)


static func _rotation_quarters_for_direction(direction: Vector2i) -> int:
	if direction == Vector2i.DOWN:
		return 1
	if direction == Vector2i.LEFT:
		return 2
	if direction == Vector2i.UP:
		return 3
	return 0


static func _rotate_direction(direction: Vector2i, quarters: int) -> Vector2i:
	var result := direction
	for _index: int in range(posmod(quarters, 4)):
		result = Vector2i(-result.y, result.x)
	return result


static func _rotate_vector_by_quarters(vector: Vector2, quarters: int) -> Vector2:
	var result := vector
	for _index: int in range(posmod(quarters, 4)):
		result = Vector2(-result.y, result.x)
	return result


static func _alpha(color: Color, alpha: float) -> Color:
	return Color(color.r, color.g, color.b, alpha)
