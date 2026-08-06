extends "res://tests/test_case.gd"

const DEMO_SCENE_PATH := "res://game/demo/vertical_slice_demo.tscn"
const ALPHA_FIXTURE := preload("res://tests/fixtures/finite/vs_demo_solution_alpha.gd")


func run() -> void:
	var packed: PackedScene = load(DEMO_SCENE_PATH)
	assert_not_null(packed, "vertical slice demo must load for end-to-end test")
	if packed == null:
		return

	var demo: Control = packed.instantiate()
	var tree := Engine.get_main_loop() as SceneTree
	assert_not_null(tree, "end-to-end demo test requires SceneTree")
	if tree == null:
		demo.free()
		return
	tree.root.add_child(demo)

	demo.start_demo()
	assert_equal(demo.state(), &"BRIEFING", "title starts briefing")
	demo.begin_build()
	assert_equal(demo.state(), &"GAMEPLAY", "briefing creates gameplay")
	assert_true(demo.has_method("gameplay_instance"), "demo exposes current gameplay instance")
	if not demo.has_method("gameplay_instance"):
		demo.free()
		return

	var product: Control = demo.gameplay_instance()
	assert_not_null(product, "gameplay instance exists after briefing")
	if product == null:
		demo.free()
		return
	var first_product_id: int = product.get_instance_id()
	var controller: RefCounted = product.session_controller()

	assert_true(product.install_layout_for_test(ALPHA_FIXTURE.pieces()), "alpha layout installs in product slice")
	var layout_signature: String = controller.current_layout_signature()
	assert_false(layout_signature.is_empty(), "installed layout has stable identity")
	assert_true(bool(controller.model()["start_enabled"]), "authored demo route passes preflight")

	product.request_command_for_test(&"START")
	assert_equal(controller.phase(), &"RUNNING", "product starts finite run")
	product.request_command_for_test(&"AUTO_TOGGLE")
	assert_true(_advance_until_terminal(product), "product run reaches a terminal state")
	assert_equal(controller.phase(), &"SUCCESS", "authored demo route succeeds")
	assert_equal(demo.state(), &"RESULT", "terminal signal opens result flow")

	var first_attempt: String = product.active_attempt_identity_for_test()
	product.request_command_for_test(&"RETRY_SAME_LAYOUT")
	assert_equal(controller.phase(), &"RUNNING", "retry starts a fresh attempt")
	assert_equal(controller.current_layout_signature(), layout_signature, "retry preserves sealed layout")
	assert_not_equal(product.active_attempt_identity_for_test(), first_attempt, "retry creates a fresh attempt identity")

	product.request_command_for_test(&"EDIT_LAYOUT")
	assert_equal(controller.phase(), &"BUILD", "edit returns to BUILD")
	assert_equal(controller.current_layout_signature(), layout_signature, "edit restores preserved route")

	demo.return_to_title()
	assert_equal(demo.state(), &"TITLE", "demo returns to title")
	assert_equal(demo.gameplay_instance(), null, "title return releases the old gameplay instance")

	demo.start_demo()
	demo.begin_build()
	var replacement: Control = demo.gameplay_instance()
	assert_not_null(replacement, "new gameplay instance is created for a new demo session")
	if replacement != null:
		assert_not_equal(replacement.get_instance_id(), first_product_id, "new demo session owns a new controller surface")

	demo.free()


func _advance_until_terminal(product: Control) -> bool:
	for _step: int in range(4800):
		var phase: StringName = product.session_controller().phase()
		if phase == &"SUCCESS" or phase == &"FAILURE":
			return true
		product.advance_time(0.05)
	return false
