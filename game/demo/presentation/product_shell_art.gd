class_name ProductShellArt
extends Control

@export_enum("TITLE", "LESSON", "RESULT") var mode: String = "TITLE"

const TITLE_HERO_PATH := "art/product_assets/ed_hybrid_v1/shells/shell_title_hero_v01.png"
const LESSON_HERO_PATH := "art/product_assets/ed_hybrid_v1/shells/shell_lesson_hero_v01.png"
const RESULT_SUCCESS_PATH := "art/product_assets/ed_hybrid_v1/shells/shell_result_success_v02.png"
const RESULT_FAILURE_PATH := "art/product_assets/ed_hybrid_v1/shells/shell_result_failure_v02.png"

const ART_BY_MODE := {
	"LESSON": [
		"art/product_assets/ed_hybrid_v1/core/core_marker_start_normal_v01.png",
		"art/product_assets/ed_hybrid_v1/core/core_rail_curve_normal_v01.png",
		"art/product_assets/ed_hybrid_v1/core/core_station_red_normal_v01.png",
		"art/product_assets/ed_hybrid_v1/core/core_cargo_star_red_normal_v01.png",
	],
	"RESULT": [
		"art/product_assets/ed_hybrid_v1/core/core_train_locomotive_blue_normal_v01.png",
		"art/product_assets/ed_hybrid_v1/core/core_marker_route_end_normal_v01.png",
		"art/product_assets/ed_hybrid_v1/core/core_cargo_star_blue_normal_v01.png",
		"art/product_assets/ed_hybrid_v1/core/core_station_blue_normal_v01.png",
	],
}

var _textures: Array[Texture2D] = []
var _result_outcome: StringName = &""


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
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


func asset_paths_for_test() -> Array[String]:
	var result: Array[String] = []
	if mode == "TITLE":
		result.append(TITLE_HERO_PATH)
		return result
	if mode == "LESSON":
		result.append(LESSON_HERO_PATH)
		return result
	if mode == "RESULT" and _result_outcome != &"":
		result.append(RESULT_SUCCESS_PATH if _result_outcome == &"SUCCESS" else RESULT_FAILURE_PATH)
		return result
	for value: Variant in ART_BY_MODE.get(mode, ART_BY_MODE["LESSON"]):
		result.append(str(value))
	return result


func loaded_asset_count_for_test() -> int:
	return _textures.size()


func _load_textures() -> void:
	_textures.clear()
	for path: String in asset_paths_for_test():
		var resource: Resource = load("res://%s" % path)
		if resource is Texture2D:
			_textures.append(resource as Texture2D)


func _draw() -> void:
	if _textures.is_empty() or size.x <= 0.0 or size.y <= 0.0:
		return
	var padding := 8.0
	var available := Rect2(Vector2(padding, padding), size - Vector2(padding * 2.0, padding * 2.0))
	if available.size.x <= 0.0 or available.size.y <= 0.0:
		return

	# Presentation images support orientation only; live game state remains authoritative.
	# Gameplay state and outcome authority stay in the finite session model.
	if _textures.size() == 1:
		_draw_texture_cover(_textures[0], available)
		return
	var slot_width := available.size.x / float(_textures.size())
	for index: int in range(_textures.size()):
		var texture: Texture2D = _textures[index]
		var target := Rect2(
			available.position + Vector2(slot_width * float(index), 0.0),
			Vector2(slot_width, available.size.y)
		).grow(-5.0)
		_draw_texture_contained(texture, target)


func _draw_texture_contained(texture: Texture2D, target: Rect2) -> void:
	if texture == null:
		return
	var texture_size := texture.get_size()
	if texture_size.x <= 0.0 or texture_size.y <= 0.0:
		return
	var scale := minf(target.size.x / texture_size.x, target.size.y / texture_size.y)
	var draw_size := texture_size * scale
	var draw_rect := Rect2(target.get_center() - draw_size * 0.5, draw_size)
	draw_texture_rect(texture, draw_rect, false)


func _draw_texture_cover(texture: Texture2D, target: Rect2) -> void:
	if texture == null:
		return
	var texture_size := texture.get_size()
	if texture_size.x <= 0.0 or texture_size.y <= 0.0:
		return
	var source := Rect2(Vector2.ZERO, texture_size)
	var source_ratio := texture_size.x / texture_size.y
	var target_ratio := target.size.x / target.size.y
	if source_ratio > target_ratio:
		var crop_width := texture_size.y * target_ratio
		source.position.x = (texture_size.x - crop_width) * 0.5
		source.size.x = crop_width
	else:
		var crop_height := texture_size.x / target_ratio
		source.position.y = (texture_size.y - crop_height) * 0.5
		source.size.y = crop_height
	draw_texture_rect_region(texture, target, source)
