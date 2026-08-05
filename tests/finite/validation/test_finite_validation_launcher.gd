extends "res://tests/test_case.gd"

const LAUNCHER_SCENE := "res://tools/validation/finite/finite_validation_launcher.tscn"
const LAUNCHER_SCRIPT := "res://tools/validation/finite/finite_validation_launcher.gd"


func run() -> void:
	assert_true(
		ResourceLoader.exists(LAUNCHER_SCENE, "PackedScene"),
		"validation launcher scene must exist"
	)
	if not ResourceLoader.exists(LAUNCHER_SCENE, "PackedScene"):
		return

	var launcher_script: Script = load(LAUNCHER_SCRIPT)
	assert_equal(
		launcher_script.mode_from_user_args(PackedStringArray()),
		&"SELECTOR",
		"missing validation argument must open selector"
	)
	assert_equal(
		launcher_script.mode_from_user_args(PackedStringArray(["--validation-mode=proof"])),
		&"PROOF",
		"explicit proof argument must remain supported"
	)
	assert_equal(
		launcher_script.mode_from_user_args(PackedStringArray(["--validation-mode=bogus"])),
		&"INVALID",
		"an explicit unknown validation argument must fail closed"
	)

	var packed: PackedScene = load(LAUNCHER_SCENE)
	var launcher: Control = packed.instantiate()
	var tree := Engine.get_main_loop() as SceneTree
	assert_not_null(tree, "launcher test requires SceneTree")
	if tree == null:
		launcher.free()
		return
	tree.root.add_child(launcher)

	assert_equal(launcher.active_mode(), &"SELECTOR", "launcher must boot in selector state")
	assert_true(launcher.selector_visible(), "selector must be visible at boot")
	assert_false(launcher.back_control_visible(), "back control must be hidden at selector")
	assert_equal(launcher.mounted_child(), null, "selector state must mount no product or fixture child")

	assert_true(launcher.configure_mode(&"STACK_8"), "stack8 must configure")
	var first_child: Node = launcher.mounted_child()
	assert_equal(launcher.stack_fixture_size(), 8, "stack8 must report exact fixture size")
	assert_false(launcher.selector_visible(), "selector must hide after mode selection")
	assert_true(launcher.back_control_visible(), "back control must appear in a mode")
	launcher.show_selector()
	assert_equal(launcher.mounted_child(), null, "returning must clear mounted child")
	assert_false(is_instance_valid(first_child), "returning must free prior child")
	assert_true(launcher.selector_visible(), "selector must return")
	assert_false(launcher.back_control_visible(), "back control must hide at selector")

	assert_false(launcher.configure_mode(&"UNKNOWN"), "unknown mode must fail closed")
	assert_equal(launcher.last_error(), &"INVALID_MODE", "unknown mode must expose stable error")
	assert_equal(launcher.mounted_child(), null, "invalid mode must leave no child mounted")
	assert_true(launcher.selector_visible(), "invalid mode must return to safe selector")

	launcher.queue_free()
