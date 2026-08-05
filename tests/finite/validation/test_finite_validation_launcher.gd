extends "res://tests/test_case.gd"

const LAUNCHER_SCENE := "res://tools/validation/finite/finite_validation_launcher.tscn"
const LAUNCHER_SCRIPT := "res://tools/validation/finite/finite_validation_launcher.gd"
const PROOF_SCENE := "res://game/finite/main/finite_slice.tscn"


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
		&"PROOF",
		"missing validation argument must default to proof"
	)
	assert_equal(
		launcher_script.mode_from_user_args(
			PackedStringArray(["--validation-mode=bogus"])
		),
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

	assert_equal(launcher.active_mode(), &"PROOF", "launcher must default to proof mode")
	assert_equal(
		launcher.active_scene_path(),
		PROOF_SCENE,
		"proof mode must mount the real finite slice"
	)
	assert_not_null(launcher.mounted_child(), "proof mode must mount a child")
	assert_true(launcher.configure_mode(&"STACK_8"), "stack mode must configure")
	assert_equal(launcher.stack_fixture_size(), 8, "stack8 must report exact fixture size")
	assert_false(launcher.configure_mode(&"UNKNOWN"), "unknown mode must fail closed")
	assert_equal(launcher.last_error(), &"INVALID_MODE", "unknown mode must expose stable error")
	assert_equal(launcher.mounted_child(), null, "invalid mode must leave no child mounted")

	launcher.queue_free()
