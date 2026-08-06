extends "res://tests/test_case.gd"

const DemoScene := preload("res://game/demo/vertical_slice_demo.tscn")


func run() -> void:
	var tree := Engine.get_main_loop() as SceneTree
	assert_not_null(tree, "mid-run exit test requires SceneTree")
	if tree == null:
		return

	var demo: Control = DemoScene.instantiate()
	tree.root.add_child(demo)
	demo.start_demo()
	demo.begin_build()

	var product = demo.gameplay_instance()
	assert_not_null(product, "gameplay instance exists")
	if product == null:
		demo.free()
		return

	var menu_button := product.get_node_or_null("HUD/TopStatus/MenuButton") as Button
	assert_not_null(menu_button, "persistent menu button exists")
	if menu_button == null:
		demo.free()
		return

	menu_button.pressed.emit()
	assert_equal(demo.state(), &"PAUSED", "menu opens shell pause during BUILD")
	assert_equal(
		product.session_controller().phase(),
		&"BUILD",
		"BUILD menu does not mutate finite phase"
	)
	assert_true(
		product.has_method("shell_input_locked_for_test"),
		"product exposes shell input-lock evidence"
	)
	if product.has_method("shell_input_locked_for_test"):
		assert_true(
			bool(product.call("shell_input_locked_for_test")),
			"pause shell locks product input"
		)

	var resume_button := demo.get_node_or_null(
		"PauseOverlay/Panel/Content/ResumeButton"
	) as Button
	var exit_button := demo.get_node_or_null(
		"PauseOverlay/Panel/Content/ExitButton"
	) as Button
	assert_not_null(resume_button, "pause overlay exposes resume")
	assert_not_null(exit_button, "pause overlay exposes current-play exit")
	if resume_button == null or exit_button == null:
		demo.free()
		return

	exit_button.pressed.emit()
	assert_equal(demo.state(), &"EXIT_CONFIRM", "exit button opens confirmation")
	var confirm_overlay := demo.get_node_or_null("ExitConfirmOverlay") as Control
	assert_not_null(confirm_overlay, "confirmation overlay exists")
	if confirm_overlay == null:
		demo.free()
		return
	assert_true(confirm_overlay.visible, "confirmation overlay is visible")

	var continue_button := demo.get_node_or_null(
		"ExitConfirmOverlay/Panel/Content/ContinueButton"
	) as Button
	var confirm_button := demo.get_node_or_null(
		"ExitConfirmOverlay/Panel/Content/ConfirmButton"
	) as Button
	assert_not_null(continue_button, "confirmation exposes safe continue action")
	assert_not_null(confirm_button, "confirmation exposes destructive exit action")
	if continue_button == null or confirm_button == null:
		demo.free()
		return
	assert_true(
		continue_button.has_focus(),
		"safe continue action receives initial focus"
	)

	continue_button.pressed.emit()
	assert_equal(demo.state(), &"PAUSED", "continue returns to pause")
	assert_true(
		demo.gameplay_instance() == product,
		"cancel preserves the same gameplay instance"
	)

	resume_button.pressed.emit()
	assert_equal(demo.state(), &"GAMEPLAY", "BUILD resume returns to gameplay")
	assert_equal(
		product.session_controller().phase(),
		&"BUILD",
		"BUILD resume remains in finite BUILD"
	)

	assert_true(product.apply_recommended_layout(), "recommended route installs")
	product.request_command(&"START")
	assert_equal(
		product.session_controller().phase(),
		&"RUNNING",
		"recommended route starts active run"
	)

	menu_button.pressed.emit()
	assert_equal(demo.state(), &"PAUSED", "menu opens pause during RUNNING")
	assert_equal(
		product.session_controller().phase(),
		&"PAUSED",
		"RUNNING menu pauses finite controller"
	)

	exit_button.pressed.emit()
	continue_button.pressed.emit()
	assert_equal(demo.state(), &"PAUSED", "run exit cancellation returns to pause")
	assert_equal(
		product.session_controller().phase(),
		&"PAUSED",
		"exit cancellation leaves finite controller paused"
	)

	exit_button.pressed.emit()
	confirm_button.pressed.emit()
	assert_equal(demo.state(), &"TITLE", "confirmed exit returns to title")
	assert_true(demo.gameplay_instance() == null, "confirmed exit disposes gameplay")
	assert_true(demo.last_result() == null, "confirmed exit clears stale result")

	demo.free()
