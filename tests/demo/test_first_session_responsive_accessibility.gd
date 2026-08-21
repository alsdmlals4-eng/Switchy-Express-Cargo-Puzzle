extends "res://tests/test_case.gd"

const ProductScene := preload("res://game/demo/product_finite_slice.tscn")
const MainScene := preload("res://game/main/main.tscn")
const DefinitionScript := preload("res://game/first_session/first_session_definition.gd")
const PolicyScript := preload("res://game/first_session/first_session_stage_policy.gd")
const SummaryScript := preload("res://game/finite/run/finite_run_summary.gd")

const VIEWPORT_SIZES: Array[Vector2] = [
	Vector2(1280.0, 720.0),
	Vector2(1600.0, 900.0),
	Vector2(1920.0, 1080.0),
	Vector2(2560.0, 1080.0),
	Vector2(960.0, 540.0),
]


func run() -> void:
	var definition: Variant = DefinitionScript.load_from_path(
		"res://data/first_session/first_session_v1.json"
	)
	var product: Control = ProductScene.instantiate()
	product.set_stage_policy(PolicyScript.create(definition.lesson(&"T4")))
	var tree := Engine.get_main_loop() as SceneTree
	tree.root.add_child(product)
	var hud := product.get_node("HUD")
	var running: Dictionary = hud.model_for_test()
	running["phase"] = &"RUNNING"
	running["stack_tokens"] = [{"cargo_type": &"RED_STAR", "top": true}]
	hud.apply_model(running)
	assert_true(product.get_node("BoardRenderer").visible, "first-session board remains visible")
	assert_true(hud.get_node("StackPanel").visible, "T4 exposes Stack/TOP")
	assert_true(hud.get_node("RunToolbar/LoadButton").visible, "T4 exposes manual Load")
	assert_false(hud.get_node("RunToolbar/AutoButton").visible, "Auto stays hidden before T5")
	assert_false(
		product.get_node("RouteControlOverlay").visible,
		"T4 fixed scaffold must not expose crossing route controls before T6",
	)

	product.set_stage_policy(PolicyScript.create(definition.lesson(&"T5")))
	hud.apply_model(running)
	assert_true(hud.get_node("RunToolbar/AutoButton").visible, "Auto appears at T5")
	assert_false(hud.get_node("TopStatus/TimeLabel").visible, "timer stays hidden before capstone")

	product.set_stage_policy(PolicyScript.create(definition.lesson(&"T6")))
	assert_true(hud.get_node("BuildToolbar/SwitchButton").visible, "switch control appears at T6")
	assert_true(
		product.get_node("RouteControlOverlay").visible,
		"route state and occupied lock become visible at T6",
	)
	product.set_stage_policy(PolicyScript.create(definition.lesson(&"CAPSTONE")))
	assert_true(hud.get_node("TopStatus/TimeLabel").visible, "capstone exposes timer")
	product.set_stage_policy(null)
	assert_true(
		hud.get_node("BuildToolbar/RecommendButton").visible,
		"removing the tutorial policy must restore the standalone product HUD",
	)
	assert_true(
		product.get_node("RouteControlOverlay").visible,
		"removing the tutorial policy restores route controls",
	)

	var before: Dictionary = hud.model_for_test()
	product.set_reduced_motion(true)
	assert_equal(hud.model_for_test(), before, "Reduced Motion preserves all information state")

	for button: Button in _buttons(hud):
		if button.visible:
			assert_true(button.custom_minimum_size.x >= 48.0, "%s keeps 48px width" % button.name)
			assert_true(button.custom_minimum_size.y >= 48.0, "%s keeps 48px height" % button.name)

	var presenter: Variant = preload(
		"res://game/finite/presentation/finite_slice_presenter.gd"
	).new()
	var descriptor: Dictionary = presenter.cargo_descriptor(&"RED_STAR")
	assert_equal(descriptor.get("shape"), &"STAR", "cargo identity includes non-color shape")
	assert_false(str(descriptor.get("label", "")).is_empty(), "cargo identity includes text label")
	product.free()

	_run_layout_and_result_action_matrix(definition, tree)


func _run_layout_and_result_action_matrix(definition: Variant, tree: SceneTree) -> void:
	for viewport_size: Vector2 in VIEWPORT_SIZES:
		var main: Control = MainScene.instantiate()
		tree.root.add_child(main)
		main.set_anchors_preset(Control.PRESET_TOP_LEFT)
		main.position = Vector2.ZERO
		main.size = viewport_size
		var flow: Control = main.get_node("VerticalSliceDemo")
		flow.set_anchors_preset(Control.PRESET_TOP_LEFT)
		flow.position = Vector2.ZERO
		flow.size = viewport_size
		assert_equal(flow.size, viewport_size, "shell accepts logical size %s" % viewport_size)
		flow.start_demo()
		flow.begin_build()
		var matrix_product: Control = flow.gameplay_instance()
		matrix_product.set_stage_policy(PolicyScript.create(definition.lesson(&"T4")))
		var matrix_hud: Control = matrix_product.get_node("HUD")
		var running: Dictionary = matrix_hud.model_for_test()
		running["phase"] = &"RUNNING"
		running["stack_tokens"] = [{"cargo_type": &"RED_STAR", "top": true}]
		matrix_hud.apply_model(running)
		_force_layout(main)

		var root_rect := Rect2(Vector2.ZERO, viewport_size)
		for path: NodePath in [
			NodePath("GameplayContainer/ProductFiniteSlice/BoardRenderer"),
			NodePath("GameplayContainer/ProductFiniteSlice/HUD/RunToolbar"),
			NodePath("GameplayContainer/ProductFiniteSlice/HUD/StackPanel"),
			NodePath("GameplayContainer/ProductFiniteSlice/HUD/RunToolbar/LoadButton"),
		]:
			var control := flow.get_node_or_null(path) as Control
			assert_not_null(control, "%s exists at %s" % [path, viewport_size])
			if control != null:
				assert_true(control.is_visible_in_tree(), "%s visible at %s" % [path, viewport_size])
				assert_true(
					_rect_inside(root_rect, control.get_global_rect()),
					"%s remains inside %s" % [path, viewport_size],
				)

		for button: Button in _buttons(flow):
			if button.is_visible_in_tree():
				assert_true(button.size.x >= 48.0, "%s rendered width at %s" % [button.name, viewport_size])
				assert_true(button.size.y >= 48.0, "%s rendered height at %s" % [button.name, viewport_size])
				assert_true(
					_rect_inside(root_rect, button.get_global_rect()),
					"%s remains reachable at %s" % [button.name, viewport_size],
				)

		var summary: Variant = SummaryScript.new(
			&"FAILURE", 18.0, -1.0, 90.0, 2, 1, &"ROUTE_END"
		)
		flow.show_result(summary)
		_force_layout(main)
		var result_panel := flow.get_node("ResultOverlay/Panel") as Control
		assert_true(
			_rect_inside(root_rect, result_panel.get_global_rect()),
			"result panel rect %s min %s inside %s"
			% [
				result_panel.get_global_rect(),
				result_panel.get_combined_minimum_size(),
				viewport_size,
			],
		)
		var retry := flow.get_node(
			"ResultOverlay/Panel/Content/Actions/RetryButton"
		) as Button
		var edit := flow.get_node("ResultOverlay/Panel/Content/Actions/EditButton") as Button
		var title_button := flow.get_node(
			"ResultOverlay/Panel/Content/Actions/TitleButton"
		) as Button
		for recovery: Button in [retry, edit, title_button]:
			assert_true(recovery.is_visible_in_tree(), "%s visible at %s" % [recovery.name, viewport_size])
			assert_true(recovery.size.x >= 48.0, "%s width at %s" % [recovery.name, viewport_size])
			assert_true(recovery.size.y >= 48.0, "%s height at %s" % [recovery.name, viewport_size])
			assert_true(
				_rect_inside(root_rect, recovery.get_global_rect()),
				"%s rect %s remains reachable at %s"
				% [recovery.name, recovery.get_global_rect(), viewport_size],
			)

		retry.pressed.emit()
		assert_equal(flow.state(), &"GAMEPLAY", "Retry works at %s" % viewport_size)
		flow.show_result(summary)
		edit.pressed.emit()
		assert_equal(flow.state(), &"GAMEPLAY", "Edit works at %s" % viewport_size)
		main.free()


func _buttons(node: Node) -> Array[Button]:
	var result: Array[Button] = []
	if node is Button:
		result.append(node)
	for child: Node in node.get_children():
		result.append_array(_buttons(child))
	return result


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
