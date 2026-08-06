extends "res://tests/test_case.gd"

const DemoScene := preload("res://game/demo/vertical_slice_demo.tscn")


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

	var start_button := demo.get_node("TitleScreen/Panel/Content/StartButton") as Button
	for state: StringName in [&"normal", &"hover", &"pressed", &"disabled", &"focus"]:
		var style: StyleBox = start_button.get_theme_stylebox(state, &"Button")
		assert_not_null(style, "Button %s style must exist" % state)
		assert_true(style is StyleBoxFlat, "Button %s style must be flat and project-owned" % state)

	var normal := start_button.get_theme_stylebox(&"normal", &"Button") as StyleBoxFlat
	assert_true(normal.corner_radius_top_left >= 8, "buttons must use rounded product styling")
	assert_true(normal.content_margin_left >= 12.0, "buttons must include readable horizontal padding")
	assert_true(normal.content_margin_top >= 8.0, "buttons must include readable vertical padding")

	var title_panel := demo.get_node("TitleScreen/Panel") as PanelContainer
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

	demo.free()
