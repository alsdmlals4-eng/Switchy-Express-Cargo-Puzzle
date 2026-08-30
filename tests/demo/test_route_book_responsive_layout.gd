extends "res://tests/test_case.gd"

const DemoScene := preload("res://game/demo/vertical_slice_demo.tscn")
const VIEWPORT_SIZES: Array[Vector2] = [Vector2(960.0, 540.0), Vector2(2560.0, 1080.0)]


func run() -> void:
	var tree := Engine.get_main_loop() as SceneTree
	assert_not_null(tree, "Route Book responsive test requires SceneTree")
	if tree == null:
		return
	for viewport_size: Vector2 in VIEWPORT_SIZES:
		var demo: Control = DemoScene.instantiate()
		tree.root.add_child(demo)
		demo.set_anchors_preset(Control.PRESET_TOP_LEFT)
		demo.position = Vector2.ZERO
		demo.size = viewport_size
		demo.open_route_book()
		_force_layout(demo)
		var root_rect := Rect2(Vector2.ZERO, viewport_size)
		var panel := demo.get_node("RouteBookScreen/Panel") as Control
		var back := demo.get_node("RouteBookScreen/Panel/Content/BackButton") as Button
		var list := demo.get_node("RouteBookScreen/Panel/Content/StageScroll/StageList") as VBoxContainer
		assert_true(_rect_inside(root_rect, panel.get_global_rect()), "Route Book panel fits %s" % viewport_size)
		assert_true(_rect_inside(root_rect, back.get_global_rect()), "Route Book back button fits %s" % viewport_size)
		assert_true(back.size.x >= 48.0 and back.size.y >= 48.0, "Route Book back button remains reachable at %s" % viewport_size)
		assert_equal(list.get_child_count(), 6, "Route Book keeps all six direct cards at %s" % viewport_size)
		for card: Node in list.get_children():
			var button := card as Button
			assert_not_null(button, "Route Book card is a button at %s" % viewport_size)
			if button != null:
				assert_true(button.custom_minimum_size.y >= 48.0, "%s keeps a 48px target" % [button.name])

		assert_true(demo.select_route_book_stage(&"RB02_REVERSE_ORDER"), "Route Book selection works at %s" % viewport_size)
		demo.begin_build()
		demo.show_result({"outcome": &"SUCCESS"})
		_force_layout(demo)
		var result_panel := demo.get_node("ResultOverlay/Panel") as Control
		var actions := demo.get_node("ResultOverlay/Panel/Content/RouteBookActions") as Control
		assert_true(_rect_inside(root_rect, result_panel.get_global_rect()), "Route Book result fits %s" % viewport_size)
		assert_true(actions.visible, "Route Book result actions only appear for Route Book at %s" % viewport_size)
		for child: Node in actions.get_children():
			var action := child as Button
			assert_true(action.size.x >= 48.0 and action.size.y >= 48.0, "%s stays reachable at %s" % [action.name, viewport_size])
			assert_true(_rect_inside(root_rect, action.get_global_rect()), "%s fits %s" % [action.name, viewport_size])
		demo.free()


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
