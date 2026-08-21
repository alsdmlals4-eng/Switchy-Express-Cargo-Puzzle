extends "res://tests/test_case.gd"

const PRODUCT_SCENE_PATH := "res://game/demo/product_finite_slice.tscn"
const DefinitionScript := preload("res://game/first_session/first_session_definition.gd")
const PolicyScript := preload("res://game/first_session/first_session_stage_policy.gd")


func run() -> void:
	var packed: PackedScene = load(PRODUCT_SCENE_PATH)
	var definition: Variant = DefinitionScript.load_from_path(
		"res://data/first_session/first_session_v1.json"
	)
	assert_not_null(packed, "product scene must load")
	assert_not_null(definition, "first-session definition must load")
	if packed == null or definition == null:
		return

	var product: Control = packed.instantiate()
	var tree := Engine.get_main_loop() as SceneTree
	assert_not_null(tree, "policy test requires SceneTree")
	if tree == null:
		product.free()
		return
	product.set_stage_policy(PolicyScript.create(definition.lesson(&"T1")))
	tree.root.add_child(product)

	var controller: RefCounted = product.session_controller()
	product.request_command_for_test(&"BUILD_TOOL", &"STRAIGHT")
	assert_equal(controller.last_payload(), &"STRAIGHT", "T1 allows straight through shared boundary")
	product.request_command_for_test(&"BUILD_TOOL", &"SWITCH")
	assert_equal(controller.last_payload(), &"STRAIGHT", "T1 blocks hidden switch command")
	product.request_command_for_test(&"START")
	assert_not_equal(controller.last_command(), &"START", "T1 blocks direct START command")
	product.dispatch_action_for_test(&"demo_auto", true)
	assert_not_equal(controller.last_command(), &"AUTO_TOGGLE", "T1 blocks desktop auto bypass")
	assert_false(product.apply_recommended_layout(), "T1 blocks recommended-layout bypass")

	var hud := product.get_node("HUD")
	assert_false(hud.get_node("BuildToolbar/SwitchButton").visible, "T1 hides switch control")
	assert_false(hud.get_node("BuildToolbar/CrossingButton").visible, "T1 hides crossing control")
	assert_false(hud.get_node("BuildToolbar/RecommendButton").visible, "first session hides solution reveal")

	product.set_stage_policy(PolicyScript.create(definition.lesson(&"CAPSTONE")))
	product.request_command_for_test(&"BUILD_TOOL", &"CROSSING")
	assert_equal(controller.last_payload(), &"CROSSING", "capstone restores crossing command")
	assert_true(hud.get_node("BuildToolbar/CrossingButton").visible, "capstone restores crossing control")

	product.free()
