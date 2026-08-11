class_name SemanticTextureStack
extends Control

var _textures: Array[Texture2D] = []


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST


func set_textures(textures: Array[Texture2D]) -> void:
	_textures.clear()
	_textures.assign(textures)
	queue_redraw()


func texture_paths_for_test() -> Array[String]:
	var result: Array[String] = []
	for texture: Texture2D in _textures:
		var path := texture.resource_path
		if path.begins_with("res://"):
			path = path.trim_prefix("res://")
		result.append(path)
	return result


func _draw() -> void:
	if size.x <= 0.0 or size.y <= 0.0:
		return
	var target := Rect2(Vector2.ZERO, size)
	for texture: Texture2D in _textures:
		if texture != null:
			draw_texture_rect(texture, target, false)
