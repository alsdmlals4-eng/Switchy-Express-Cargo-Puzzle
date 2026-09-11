class_name ProductShellArt
extends Control

@export_enum("TITLE", "LESSON", "RESULT") var mode: String = "TITLE"

const PADDING := 8.0
const CARGO_TARGET_SCALE := 0.62

const ASSET_PATHS := {
	"board_terrain": "art/product_assets/night_workshop_v1/board_slate.png",
	"train": "art/product_assets/night_workshop_v1/train.png",
	"rail_straight": "art/product_assets/ed_hybrid_v2/core/core_rail_straight_normal_v04.png",
	"station_blue": "art/product_assets/topdown_v1/station_blue.png",
	"station_red": "art/product_assets/topdown_v1/station_red.png",
	"station_disposal": "art/product_assets/topdown_v1/station_disposal.png",
	"cargo_blue": "art/product_assets/topdown_v1/cargo_blue.png",
	"cargo_red": "art/product_assets/topdown_v1/cargo_red.png",
	"cargo_waste": "art/product_assets/topdown_v1/cargo_waste.png",
	"decoration_forest_cluster": "art/product_assets/topdown_v1/decoration_forest_cluster.png",
	"decoration_lantern_fence": "art/product_assets/topdown_v1/decoration_lantern_fence.png",
	"decoration_moss_boulder": "art/product_assets/topdown_v1/decoration_moss_boulder.png",
	"decoration_timber_stack": "art/product_assets/topdown_v1/decoration_timber_stack.png",
	"decoration_waterway": "art/product_assets/topdown_v1/decoration_waterway.png",
}

# Every scene uses one virtual square-cell grid. Rail cells therefore keep equal scale and exact
# edge joins at every Control size; all other layers are presentation-only occupants of that grid.
const SCENE_SPECS := {
	"TITLE": {
		"grid_size": Vector2i(10, 4),
		"layers": [
			{"key": "rail_straight", "cell": Vector2i(1, 2), "role": "RAIL"},
			{"key": "rail_straight", "cell": Vector2i(2, 2), "role": "RAIL"},
			{"key": "rail_straight", "cell": Vector2i(3, 2), "role": "RAIL"},
			{"key": "rail_straight", "cell": Vector2i(4, 2), "role": "RAIL"},
			{"key": "rail_straight", "cell": Vector2i(5, 2), "role": "RAIL"},
			{"key": "rail_straight", "cell": Vector2i(6, 2), "role": "RAIL"},
			{"key": "cargo_blue", "cell": Vector2i(2, 2), "role": "CARGO_ON_RAIL", "scale": CARGO_TARGET_SCALE},
			{"key": "train", "cell": Vector2i(5, 2), "role": "TRAIN", "scale": 0.92},
			{"key": "station_blue", "cell": Vector2i(6, 1), "role": "STATION", "scale": 0.88},
			{"key": "decoration_forest_cluster", "cell": Vector2i(8, 2), "role": "DECOR", "scale": 0.58},
			{"key": "decoration_lantern_fence", "cell": Vector2i(8, 3), "role": "DECOR", "scale": 0.72},
		],
	},
	"LESSON": {
		"grid_size": Vector2i(10, 4),
		"layers": [
			{"key": "rail_straight", "cell": Vector2i(2, 2), "role": "RAIL"},
			{"key": "rail_straight", "cell": Vector2i(3, 2), "role": "RAIL"},
			{"key": "rail_straight", "cell": Vector2i(4, 2), "role": "RAIL"},
			{"key": "rail_straight", "cell": Vector2i(5, 2), "role": "RAIL"},
			{"key": "rail_straight", "cell": Vector2i(6, 2), "role": "RAIL"},
			{"key": "cargo_blue", "cell": Vector2i(3, 2), "role": "CARGO_ON_RAIL", "scale": CARGO_TARGET_SCALE},
			{"key": "station_blue", "cell": Vector2i(5, 1), "role": "STATION", "scale": 0.88},
			{"key": "decoration_waterway", "cell": Vector2i(7, 3), "role": "DECOR", "scale": 0.62},
		],
	},
	"LESSON_T2": {
		"grid_size": Vector2i(10, 4),
		"layers": [
			{"key": "rail_straight", "cell": Vector2i(2, 2), "role": "RAIL"},
			{"key": "rail_straight", "cell": Vector2i(3, 2), "role": "RAIL"},
			{
				"key": "rail_straight",
				"cell": Vector2i(4, 2),
				"role": "RAIL",
				"semantic_role": "SERVICE_RAIL",
			},
			{"key": "rail_straight", "cell": Vector2i(5, 2), "role": "RAIL"},
			{"key": "rail_straight", "cell": Vector2i(6, 2), "role": "RAIL"},
			{"key": "cargo_red", "cell": Vector2i(3, 2), "role": "CARGO_ON_RAIL", "scale": CARGO_TARGET_SCALE},
			{"key": "station_red", "cell": Vector2i(4, 1), "role": "STATION", "scale": 0.88},
			{"key": "decoration_waterway", "cell": Vector2i(7, 3), "role": "DECOR", "scale": 0.62},
		],
	},
	"RESULT_SUCCESS": {
		"grid_size": Vector2i(10, 4),
		"layers": [
			{"key": "rail_straight", "cell": Vector2i(2, 2), "role": "RAIL"},
			{"key": "rail_straight", "cell": Vector2i(3, 2), "role": "RAIL"},
			{"key": "rail_straight", "cell": Vector2i(4, 2), "role": "RAIL"},
			{"key": "rail_straight", "cell": Vector2i(5, 2), "role": "RAIL"},
			{"key": "rail_straight", "cell": Vector2i(6, 2), "role": "RAIL"},
			{"key": "cargo_blue", "cell": Vector2i(3, 2), "role": "CARGO_ON_RAIL", "scale": CARGO_TARGET_SCALE},
			{"key": "train", "cell": Vector2i(5, 2), "role": "TRAIN", "scale": 0.92},
			{"key": "station_blue", "cell": Vector2i(6, 1), "role": "STATION", "scale": 0.88},
			{"key": "decoration_timber_stack", "cell": Vector2i(7, 3), "role": "DECOR", "scale": 0.56},
		],
	},
	"RESULT_FAILURE": {
		"grid_size": Vector2i(10, 4),
		"layers": [
			{"key": "rail_straight", "cell": Vector2i(2, 2), "role": "RAIL"},
			{"key": "rail_straight", "cell": Vector2i(3, 2), "role": "RAIL"},
			{"key": "rail_straight", "cell": Vector2i(4, 2), "role": "RAIL"},
			{"key": "rail_straight", "cell": Vector2i(5, 2), "role": "RAIL"},
			{"key": "rail_straight", "cell": Vector2i(6, 2), "role": "RAIL"},
			{"key": "cargo_waste", "cell": Vector2i(3, 2), "role": "CARGO_ON_RAIL", "scale": CARGO_TARGET_SCALE},
			{"key": "train", "cell": Vector2i(5, 2), "role": "TRAIN", "scale": 0.92},
			{"key": "station_disposal", "cell": Vector2i(6, 1), "role": "STATION", "scale": 0.88},
			{"key": "decoration_moss_boulder", "cell": Vector2i(7, 3), "role": "DECOR", "scale": 0.54},
		],
	},
}

var _textures: Dictionary = {}
var _result_outcome: StringName = &""
var _lesson_id: StringName = &""


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	clip_contents = true
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_load_textures()
	queue_redraw()


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED:
		queue_redraw()


func set_result_outcome(outcome: StringName) -> void:
	if mode != "RESULT":
		return
	_result_outcome = &"SUCCESS" if outcome == &"SUCCESS" else &"FAILURE"
	_load_textures()
	queue_redraw()


func set_lesson_id(lesson_id: StringName) -> void:
	if mode != "LESSON" or _lesson_id == lesson_id:
		return
	_lesson_id = lesson_id
	_load_textures()
	queue_redraw()


func asset_paths_for_test() -> Array[String]:
	var result: Array[String] = [str(ASSET_PATHS["board_terrain"])]
	var spec: Dictionary = _active_spec()
	for value: Variant in spec.get("layers", []):
		var layer: Dictionary = value
		var path := str(ASSET_PATHS.get(str(layer.get("key", "")), ""))
		if not path.is_empty() and not result.has(path):
			result.append(path)
	return result


func loaded_asset_count_for_test() -> int:
	return _textures.size()


func composition_layout_for_test(control_size: Vector2) -> Array[Dictionary]:
	return _composition_layout(control_size)


func _active_spec() -> Dictionary:
	var scene_key := mode
	if mode == "LESSON" and _lesson_id == &"T2":
		scene_key = "LESSON_T2"
	elif mode == "RESULT":
		scene_key = "RESULT_SUCCESS" if _result_outcome == &"SUCCESS" else "RESULT_FAILURE"
	return SCENE_SPECS.get(scene_key, SCENE_SPECS["LESSON"])


func _load_textures() -> void:
	_textures.clear()
	for path: String in asset_paths_for_test():
		var resource: Resource = load("res://%s" % path)
		if resource is Texture2D:
			_textures[path] = resource as Texture2D


func _draw() -> void:
	for layer: Dictionary in _composition_layout(size):
		var texture := _textures.get(str(layer.get("path", ""))) as Texture2D
		if texture == null:
			continue
		if str(layer.get("fit", "")) == "COVER":
			draw_texture_rect_region(
				texture,
				layer.get("target_rect", Rect2()),
				layer.get("source_rect", Rect2(Vector2.ZERO, texture.get_size()))
			)
		else:
			draw_texture_rect(texture, layer.get("draw_rect", Rect2()), false)


func _composition_layout(control_size: Vector2) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	if control_size.x <= 0.0 or control_size.y <= 0.0:
		return result
	var padding := minf(PADDING, minf(control_size.x, control_size.y) * 0.2)
	var available := Rect2(
		Vector2(padding, padding),
		control_size - Vector2(padding * 2.0, padding * 2.0)
	)
	if available.size.x <= 0.0 or available.size.y <= 0.0:
		return result

	var background_path := str(ASSET_PATHS["board_terrain"])
	var background := _textures.get(background_path) as Texture2D
	if background != null:
		result.append({
			"key": "board_terrain",
			"path": background_path,
			"role": "BACKGROUND",
			"fit": "COVER",
			"target_rect": available,
			"draw_rect": available,
			"source_rect": _cover_source_rect(background.get_size(), available.size),
			"normalized_rect": _normalized_rect(available, control_size),
			"grid_unit": 0.0,
			"grid_cell": Vector2i(-1, -1),
		})

	var spec: Dictionary = _active_spec()
	var grid_size: Vector2i = spec.get("grid_size", Vector2i(10, 4))
	var unit := minf(
		available.size.x / float(grid_size.x),
		available.size.y / float(grid_size.y)
	)
	if unit <= 0.0:
		return result
	var grid_rect := Rect2(
		available.get_center() - Vector2(grid_size) * unit * 0.5,
		Vector2(grid_size) * unit
	)
	for value: Variant in spec.get("layers", []):
		var layer_spec: Dictionary = value
		var key := str(layer_spec.get("key", ""))
		var path := str(ASSET_PATHS.get(key, ""))
		var texture := _textures.get(path) as Texture2D
		if texture == null:
			continue
		var cell: Vector2i = layer_spec.get("cell", Vector2i.ZERO)
		var cell_rect := Rect2(grid_rect.position + Vector2(cell) * unit, Vector2.ONE * unit)
		var target_scale := clampf(float(layer_spec.get("scale", 1.0)), 0.0, 1.0)
		var target := Rect2(
			cell_rect.get_center() - cell_rect.size * target_scale * 0.5,
			cell_rect.size * target_scale
		)
		result.append({
			"key": key,
			"path": path,
			"role": str(layer_spec.get("role", "")),
			"semantic_role": str(layer_spec.get("semantic_role", "")),
			"fit": "CONTAIN",
			"target_rect": target,
			"draw_rect": _contained_draw_rect(texture.get_size(), target),
			"source_rect": Rect2(Vector2.ZERO, texture.get_size()),
			"normalized_rect": _normalized_rect(target, control_size),
			"grid_unit": unit,
			"grid_cell": cell,
		})
	return result


static func _contained_draw_rect(texture_size: Vector2, target: Rect2) -> Rect2:
	if texture_size.x <= 0.0 or texture_size.y <= 0.0:
		return Rect2(target.get_center(), Vector2.ZERO)
	var scale := minf(target.size.x / texture_size.x, target.size.y / texture_size.y)
	var draw_size := texture_size * scale
	return Rect2(target.get_center() - draw_size * 0.5, draw_size)


static func _cover_source_rect(texture_size: Vector2, target_size: Vector2) -> Rect2:
	var source := Rect2(Vector2.ZERO, texture_size)
	if texture_size.x <= 0.0 or texture_size.y <= 0.0 or target_size.y <= 0.0:
		return source
	var source_ratio := texture_size.x / texture_size.y
	var target_ratio := target_size.x / target_size.y
	if source_ratio > target_ratio:
		var crop_width := texture_size.y * target_ratio
		source.position.x = (texture_size.x - crop_width) * 0.5
		source.size.x = crop_width
	else:
		var crop_height := texture_size.x / target_ratio
		source.position.y = (texture_size.y - crop_height) * 0.5
		source.size.y = crop_height
	return source


static func _normalized_rect(rect: Rect2, control_size: Vector2) -> Rect2:
	return Rect2(rect.position / control_size, rect.size / control_size)
