extends "res://tests/test_case.gd"

const DemoScene := preload("res://game/demo/vertical_slice_demo.tscn")
const TUTORIAL_FOCUS := Color("9b6bdf")


func run() -> void:
	var tree := Engine.get_main_loop() as SceneTree
	assert_not_null(tree, "demo theme test requires SceneTree")
	if tree == null:
		return

	var demo: Control = DemoScene.instantiate()
	tree.root.add_child(demo)
	assert_not_null(demo.theme, "vertical slice root must own a product theme")
	if demo.theme == null:
		demo.free()
		return

	var start_button := demo.get_node_or_null(
		"TitleScreen/TitleMargin/TitleColumns/TitleDeck/Content/StartButton"
	) as Button
	assert_not_null(start_button, "title must expose its primary action inside the title deck")
	if start_button == null:
		demo.free()
		return
	for state: StringName in [&"normal", &"hover", &"pressed", &"disabled", &"focus"]:
		var style: StyleBox = start_button.get_theme_stylebox(state, &"Button")
		assert_not_null(style, "Button %s style must exist" % state)
		assert_true(style is StyleBoxFlat, "Button %s style must be flat and project-owned" % state)

	var normal := start_button.get_theme_stylebox(&"normal", &"Button") as StyleBoxFlat
	assert_true(normal.corner_radius_top_left >= 8, "buttons must use rounded product styling")
	assert_true(normal.content_margin_left >= 12.0, "buttons must include readable horizontal padding")
	assert_true(normal.content_margin_top >= 8.0, "buttons must include readable vertical padding")

	var title_backdrop := demo.get_node_or_null("TitleScreen/TitleBackdrop") as Control
	assert_not_null(title_backdrop, "title must expose the full-viewport title-art consumer")
	if title_backdrop != null:
		assert_equal(
			title_backdrop.mouse_filter,
			Control.MOUSE_FILTER_IGNORE,
			"title background must never intercept the title action deck"
		)
		assert_equal(title_backdrop.anchor_right, 1.0, "title background must fill its parent width")
		assert_equal(title_backdrop.anchor_bottom, 1.0, "title background must fill its parent height")

	var title_panel := demo.get_node("TitleScreen/TitleMargin/TitleColumns/TitleDeck") as PanelContainer
	var panel_style := title_panel.get_theme_stylebox(&"panel", &"PanelContainer") as StyleBoxFlat
	assert_not_null(panel_style, "PanelContainer product style must exist")
	if panel_style != null:
		assert_true(panel_style.corner_radius_top_left >= 12, "panels must use rounded product styling")
		assert_true(panel_style.content_margin_left >= 18.0, "panels must include content padding")

	assert_true(start_button.get_theme_font_size(&"font_size", &"Button") >= 18, "button copy remains readable")
	assert_not_equal(
		start_button.get_theme_color(&"font_color", &"Button"),
		start_button.get_theme_color(&"font_disabled_color", &"Button"),
		"disabled controls must have a distinct state"
	)
	assert_equal(
		demo.theme.get_color(&"font_color", &"Label"),
		Color("f7f2e8"),
		"control-deck text must share the board light-text role"
	)
	assert_equal(
		demo.theme.get_color(&"font_color", &"LessonFocusLabel"),
		TUTORIAL_FOCUS,
		"lesson focus must use the bounded violet role"
	)
	var preflight_style := demo.theme.get_stylebox(&"panel", &"PreflightPanel") as StyleBoxFlat
	assert_not_null(preflight_style, "preflight variation must own a panel style")
	if preflight_style != null:
		assert_equal(
			preflight_style.border_color,
			Color("d94f49"),
			"preflight variation must reserve crimson for a visible problem border"
		)
	var stack_style := demo.theme.get_stylebox(&"panel", &"StackPanel") as StyleBoxFlat
	assert_not_null(stack_style, "Stack/TOP variation must own a panel style")
	if stack_style != null:
		assert_equal(
			stack_style.border_color,
			Color("6f806f"),
			"Stack/TOP variation must retain the neutral control-deck border"
		)
	var focus_style := start_button.get_theme_stylebox(&"focus", &"Button") as StyleBoxFlat
	assert_not_null(focus_style, "focused controls must keep an explicit product focus style")
	if focus_style != null:
		assert_equal(
			focus_style.border_color,
			Color("e9ae45"),
			"focused controls must use the restrained action trim"
		)
	assert_not_null(
		demo.get_node_or_null("TitleScreen/TitleMargin/TitleColumns/ActionDeck"),
		"title must keep optional actions in a dedicated action deck"
	)
	assert_true(start_button.has_focus(), "the title's primary action must own initial keyboard focus")

	demo.free()
