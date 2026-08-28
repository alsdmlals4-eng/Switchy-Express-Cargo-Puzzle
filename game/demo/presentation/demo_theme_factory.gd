class_name DemoThemeFactory
extends RefCounted

const Palette := preload("res://game/demo/presentation/demo_palette.gd")


static func create_theme() -> Theme:
	var result := Theme.new()
	result.default_font = ThemeDB.fallback_font
	result.default_font_size = 18

	result.set_font_size(&"font_size", &"Button", 18)
	result.set_font_size(&"font_size", &"Label", 18)
	result.set_color(&"font_color", &"Label", Palette.TEXT_LIGHT)
	result.set_color(&"font_color", &"Button", Palette.TEXT_LIGHT)
	result.set_color(&"font_hover_color", &"Button", Color.WHITE)
	result.set_color(&"font_pressed_color", &"Button", Palette.BACKGROUND)
	result.set_color(&"font_disabled_color", &"Button", Color(Palette.TEXT_LIGHT, 0.48))
	result.set_color(&"font_focus_color", &"Button", Color.WHITE)

	result.set_stylebox(&"panel", &"PanelContainer", _panel_style())
	result.set_stylebox(
		&"normal", &"Button", _button_style(Palette.CONTROL_DECK_RAISED, Palette.CONTROL_DECK_BORDER, 1)
	)
	result.set_stylebox(
		&"hover", &"Button", _button_style(Palette.CONTROL_DECK_HOVER, Palette.CONTROL_DECK_ACTION, 2)
	)
	result.set_stylebox(
		&"pressed", &"Button", _button_style(Palette.CONTROL_DECK_ACTION.darkened(0.15), Palette.CONTROL_DECK_ACTION, 2)
	)
	result.set_stylebox(
		&"disabled", &"Button", _button_style(Palette.CONTROL_DECK_DISABLED, Palette.CONTROL_DECK_BORDER, 1)
	)
	result.set_stylebox(&"focus", &"Button", _focus_style())
	result.set_type_variation(&"ShellPanel", &"PanelContainer")
	result.set_stylebox(&"panel", &"ShellPanel", _panel_style())
	result.set_type_variation(&"StackPanel", &"PanelContainer")
	result.set_stylebox(&"panel", &"StackPanel", _panel_style())
	result.set_type_variation(&"PreflightPanel", &"PanelContainer")
	result.set_stylebox(&"panel", &"PreflightPanel", _panel_style(Palette.PROBLEM))
	result.set_type_variation(&"LessonFocusLabel", &"Label")
	result.set_color(&"font_color", &"LessonFocusLabel", Palette.TUTORIAL_FOCUS)
	return result


static func _panel_style(border_color: Color = Palette.CONTROL_DECK_BORDER) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(Palette.CONTROL_DECK_RAISED, 0.96)
	style.border_color = border_color
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
	style.border_color = Palette.CONTROL_DECK_ACTION
	style.set_border_width_all(3)
	style.set_corner_radius_all(12)
	style.expand_margin_left = 3.0
	style.expand_margin_right = 3.0
	style.expand_margin_top = 3.0
	style.expand_margin_bottom = 3.0
	return style
