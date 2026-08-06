class_name DemoThemeFactory
extends RefCounted

const DARK_TEAL := Color("10262b")
const DARK_TEAL_RAISED := Color("18363c")
const DARK_TEAL_HOVER := Color("24505a")
const CREAM := Color("f4ead0")
const CREAM_MUTED := Color("c9bea2")
const GOLD := Color("e9ae45")
const GOLD_PRESSED := Color("c88928")
const BORDER := Color("6f806f")
const DISABLED := Color("536168")
const DANGER := Color("b8544d")


static func create_theme() -> Theme:
	var result := Theme.new()
	result.default_font = ThemeDB.fallback_font
	result.default_font_size = 18

	result.set_font_size(&"font_size", &"Button", 18)
	result.set_font_size(&"font_size", &"Label", 18)
	result.set_color(&"font_color", &"Label", CREAM)
	result.set_color(&"font_color", &"Button", CREAM)
	result.set_color(&"font_hover_color", &"Button", Color.WHITE)
	result.set_color(&"font_pressed_color", &"Button", DARK_TEAL)
	result.set_color(&"font_disabled_color", &"Button", Color(CREAM_MUTED, 0.48))
	result.set_color(&"font_focus_color", &"Button", Color.WHITE)

	result.set_stylebox(&"panel", &"PanelContainer", _panel_style())
	result.set_stylebox(&"normal", &"Button", _button_style(DARK_TEAL_RAISED, BORDER, 1))
	result.set_stylebox(&"hover", &"Button", _button_style(DARK_TEAL_HOVER, GOLD, 2))
	result.set_stylebox(&"pressed", &"Button", _button_style(GOLD_PRESSED, GOLD, 2))
	result.set_stylebox(&"disabled", &"Button", _button_style(DISABLED, BORDER, 1))
	result.set_stylebox(&"focus", &"Button", _focus_style())
	return result


static func _panel_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(DARK_TEAL_RAISED, 0.96)
	style.border_color = BORDER
	style.set_border_width_all(2)
	style.set_corner_radius_all(16)
	style.content_margin_left = 24.0
	style.content_margin_right = 24.0
	style.content_margin_top = 22.0
	style.content_margin_bottom = 22.0
	style.shadow_color = Color(0.0, 0.0, 0.0, 0.34)
	style.shadow_size = 10
	style.shadow_offset = Vector2(0.0, 5.0)
	return style


static func _button_style(
	background: Color,
	border_color: Color,
	border_width: int
) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = background
	style.border_color = border_color
	style.set_border_width_all(border_width)
	style.set_corner_radius_all(10)
	style.content_margin_left = 16.0
	style.content_margin_right = 16.0
	style.content_margin_top = 10.0
	style.content_margin_bottom = 10.0
	return style


static func _focus_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.0, 0.0, 0.0, 0.0)
	style.border_color = GOLD
	style.set_border_width_all(3)
	style.set_corner_radius_all(12)
	style.expand_margin_left = 3.0
	style.expand_margin_right = 3.0
	style.expand_margin_top = 3.0
	style.expand_margin_bottom = 3.0
	return style
