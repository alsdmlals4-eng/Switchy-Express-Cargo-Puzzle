extends "res://tests/test_case.gd"

const SLICE_SCENE_PATH := "res://game/finite/main/finite_slice.tscn"
const DRIVER_PATH := "res://tests/fixtures/finite/finite_slice_driver.gd"


func run() -> void:
	var packed: PackedScene = load(SLICE_SCENE_PATH)
	assert_not_null(packed, "finite validation wrapper scene must load")
	if packed == null:
		return

	var slice: Control = packed.instantiate()
	var tree := Engine.get_main_loop() as SceneTree
	assert_not_null(tree, "wrapper parity test requires SceneTree")
	if tree == null:
		slice.free()
		return
	tree.root.add_child(slice)

	assert_true(
		slice.has_method("session_controller"),
		"finite validation scene must expose its shared session controller"
	)
	if not slice.has_method("session_controller"):
		slice.queue_free()
		return

	var controller: RefCounted = slice.session_controller()
	assert_not_null(controller, "finite validation wrapper must own one controller")
	if controller == null:
		slice.queue_free()
		return

	assert_equal(slice.phase(), controller.phase(), "wrapper phase must match controller")
	assert_equal(
		slice.presenter_model(),
		controller.model(),
		"wrapper model must match controller"
	)
	assert_equal(
		slice.current_layout_signature(),
		controller.current_layout_signature(),
		"wrapper layout identity must match controller"
	)

	var driver_script: Script = load(DRIVER_PATH)
	assert_true(
		driver_script.install_alpha_through_view(slice),
		"existing validation View commands must install the alpha route"
	)
	assert_equal(slice.phase(), controller.phase(), "BUILD command phase parity must hold")
	assert_equal(
		slice.current_layout_signature(),
		controller.current_layout_signature(),
		"BUILD command layout parity must hold"
	)
	assert_equal(
		slice.presenter_model(),
		controller.model(),
		"BUILD command model parity must hold"
	)

	slice.queue_free()
