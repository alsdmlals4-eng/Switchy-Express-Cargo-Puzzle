class_name SemanticEventOverlay
extends Control

const SemanticAssetCatalogScript := preload("res://game/demo/presentation/semantic_asset_catalog.gd")
const EVENT_DURATION := 0.45
const BASE_SIZE := Vector2(96.0, 96.0)
const COMBO_TRIGGER_STATUS: StringName = &"RUNTIME_TRIGGER_DEFERRED_NO_EXISTING_SEAM"

var _catalog: Variant
var _reduced_motion: bool = false
var _current_event: StringName = &""
var _information_key: StringName = &""
var _input_paths: Array[String] = []
var _textures: Array[Texture2D] = []
var _remaining: float = 0.0
var _motion_active: bool = false
var _event_history: Array[StringName] = []


func _init() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	_catalog = SemanticAssetCatalogScript.new()
	_catalog.load_default()


func _ready() -> void:
	set_process(false)


func set_reduced_motion(enabled: bool) -> void:
	_reduced_motion = enabled


func play_event(event: StringName) -> bool:
	if _catalog == null or not _catalog.is_ready():
		cancel_all()
		return false
	var record: Dictionary = _catalog.vfx_composition(event, _reduced_motion)
	if record.is_empty():
		cancel_all()
		return false
	var textures: Array[Texture2D] = _catalog.textures_for(record)
	if textures.is_empty():
		cancel_all()
		return false

	_current_event = event
	_information_key = StringName(record.get("information_key", &""))
	_input_paths = _paths(record)
	_textures.clear()
	_textures.assign(textures)
	_remaining = EVENT_DURATION
	_motion_active = not _reduced_motion
	_event_history.append(event)
	visible = true
	set_process(true)
	queue_redraw()
	return true


func cancel_all() -> void:
	_current_event = &""
	_information_key = &""
	_input_paths.clear()
	_textures.clear()
	_remaining = 0.0
	_motion_active = false
	visible = false
	set_process(false)
	queue_redraw()


func maximum_event_duration_for_test() -> float:
	return EVENT_DURATION


func combo_trigger_status_for_test() -> StringName:
	return COMBO_TRIGGER_STATUS


func current_event_for_test() -> StringName:
	return _current_event


func information_key_for_test() -> StringName:
	return _information_key


func input_paths_for_test() -> Array[String]:
	var result: Array[String] = []
	result.assign(_input_paths)
	return result


func event_history_for_test() -> Array[StringName]:
	var result: Array[StringName] = []
	result.assign(_event_history)
	return result


func clear_event_history_for_test() -> void:
	_event_history.clear()


func motion_active_for_test() -> bool:
	return _motion_active and _remaining > 0.0


func reduced_motion_for_test() -> bool:
	return _reduced_motion


func _process(delta: float) -> void:
	if _remaining <= 0.0:
		cancel_all()
		return
	_remaining = maxf(_remaining - maxf(delta, 0.0), 0.0)
	if _remaining <= 0.0:
		cancel_all()
		return
	queue_redraw()


func _draw() -> void:
	if _textures.is_empty() or _remaining <= 0.0:
		return
	var center := size * 0.5
	if center == Vector2.ZERO:
		center = BASE_SIZE * 0.5
	var draw_size := BASE_SIZE
	if not _reduced_motion:
		var progress := 1.0 - clampf(_remaining / EVENT_DURATION, 0.0, 1.0)
		var pulse := 1.0 + sin(progress * PI) * 0.12
		draw_size *= pulse
	var target := Rect2(center - draw_size * 0.5, draw_size)
	for texture: Texture2D in _textures:
		if texture != null:
			draw_texture_rect(texture, target, false)


static func _paths(record: Dictionary) -> Array[String]:
	var result: Array[String] = []
	var inputs: Variant = record.get("inputs", [])
	if not inputs is Array:
		return result
	for path: Variant in inputs:
		result.append(str(path))
	return result
