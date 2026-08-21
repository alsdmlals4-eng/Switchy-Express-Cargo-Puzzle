extends "res://tests/test_case.gd"

const ProductScene := preload("res://game/demo/product_finite_slice.tscn")
const DefinitionScript := preload("res://game/first_session/first_session_definition.gd")
const PolicyScript := preload("res://game/first_session/first_session_stage_policy.gd")


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


func _buttons(node: Node) -> Array[Button]:
	var result: Array[Button] = []
	if node is Button:
		result.append(node)
	for child: Node in node.get_children():
		result.append_array(_buttons(child))
	return result
