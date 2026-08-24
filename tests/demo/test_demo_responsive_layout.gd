extends "res://tests/test_case.gd"

const DemoScene := preload("res://game/demo/vertical_slice_demo.tscn")
const VIEWPORT_SIZES: Array[Vector2] = [
	Vector2(1280.0, 720.0),
	Vector2(1600.0, 900.0),
	Vector2(1920.0, 1080.0),
]


func run() -> void:
	var tree := Engine.get_main_loop() as SceneTree
	assert_not_null(tree, "responsive layout test requires SceneTree")
	if tree == null:
		return

	for viewport_size: Vector2 in VIEWPORT_SIZES:
		var demo: Control = DemoScene.instantiate()
		tree.root.add_child(demo)
		demo.set_anchors_preset(Control.PRESET_TOP_LEFT)
		demo.position = Vector2.ZERO
		demo.size = viewport_size
		demo.start_demo()
		demo.begin_build()
		_force_layout(demo)

		var root_rect := Rect2(Vector2.ZERO, viewport_size)
		for path: NodePath in [
			NodePath("TitleScreen/Panel/Content/StartButton"),
			NodePath("BriefingScreen/Panel/Content/BeginButton"),
			NodePath("GameplayContainer/ProductFiniteSlice/HUD/BuildToolbar"),
			NodePath("GameplayContainer/ProductFiniteSlice/HUD/RunToolbar"),
			NodePath("GameplayContainer/ProductFiniteSlice/HUD/StackPanel"),
			NodePath("PauseOverlay/Panel"),
			NodePath("ResultOverlay/Panel"),
		]:
			var control := demo.get_node_or_null(path) as Control
			assert_not_null(control, "%s must exist at %s" % [path, viewport_size])
			if control != null:
				assert_true(
					_rect_inside(root_rect, control.get_global_rect()),
					_layout_failure_message(demo, path, control, viewport_size)
				)

		var product := demo.get_node("GameplayContainer/ProductFiniteSlice") as Control
		var board := product.get_node("BoardRenderer") as Control
		var hud := product.get_node("HUD") as Control
		assert_true(hud.is_visible_in_tree(), "HUD must be visible after entering BUILD")
		assert_true(hud.size.x >= product.size.x - 1.0, "HUD must fill product width")
		assert_true(hud.size.y >= product.size.y - 1.0, "HUD must fill product height")
		assert_true(hud.z_index > board.z_index, "HUD must render above the board explicitly")
		assert_true(
			(hud.get_node("BuildToolbar") as Control).is_visible_in_tree(),
			"BUILD toolbar must be visible after entering BUILD"
		)

		_assert_single_layout_child(hud.get_node("StackPanel") as Control, "StackPanel")
		_assert_single_layout_child(hud.get_node("PausePanel") as Control, "PausePanel")
		_assert_single_layout_child(hud.get_node("ResultPanel") as Control, "ResultPanel")

		for button: Button in _buttons(demo):
			assert_true(button.size.x >= 48.0, "%s rendered width must be at least 48" % button.name)
			assert_true(button.size.y >= 48.0, "%s rendered height must be at least 48" % button.name)

		demo.free()


func _layout_failure_message(
	demo: Control,
	path: NodePath,
	control: Control,
	viewport_size: Vector2
) -> String:
	var message := "%s must remain inside %s · rect=%s · min=%s" % [
		path,
		viewport_size,
		control.get_global_rect(),
		control.get_combined_minimum_size(),
	]
	if str(path) == "BriefingScreen/Panel/Content/BeginButton":
		var panel := demo.get_node_or_null("BriefingScreen/Panel") as Control
		var content := demo.get_node_or_null("BriefingScreen/Panel/Content") as Control
		if panel != null:
			message += " · panel_rect=%s · panel_min=%s" % [
				panel.get_global_rect(), panel.get_combined_minimum_size()
			]
		if content != null:
			message += " · content_rect=%s · content_min=%s" % [
				content.get_global_rect(), content.get_combined_minimum_size()
			]
			for child: Node in content.get_children():
				if child is Control:
					var child_control := child as Control
					message += " · child=%s visible=%s rect=%s min=%s hflags=%d vflags=%d" % [
						child_control.name,
						child_control.visible,
						child_control.get_global_rect(),
						child_control.get_combined_minimum_size(),
						child_control.size_flags_horizontal,
						child_control.size_flags_vertical,
					]
					if child_control is Label:
						var label := child_control as Label
						message += " text_len=%d autowrap=%d" % [label.text.length(), label.autowrap_mode]
	return message


func _assert_single_layout_child(panel: Control, panel_name: String) -> void:
	assert_equal(panel.get_child_count(), 1, "%s must have one layout container child" % panel_name)
	if panel.get_child_count() == 1:
		assert_true(panel.get_child(0) is Container, "%s child must own its layout" % panel_name)


func _force_layout(node: Node) -> void:
	if node is Container:
		node.notification(Container.NOTIFICATION_SORT_CHILDREN)
	for child: Node in node.get_children():
		_force_layout(child)


static func _rect_inside(outer: Rect2, inner: Rect2) -> bool:
	const EPSILON := 1.0
	return (
		inner.position.x >= outer.position.x - EPSILON
		and inner.position.y >= outer.position.y - EPSILON
		and inner.end.x <= outer.end.x + EPSILON
		and inner.end.y <= outer.end.y + EPSILON
	)


func _buttons(node: Node) -> Array[Button]:
	var result: Array[Button] = []
	if node is Button and node.is_visible_in_tree():
		result.append(node)
	for child: Node in node.get_children():
		result.append_array(_buttons(child))
	return result
