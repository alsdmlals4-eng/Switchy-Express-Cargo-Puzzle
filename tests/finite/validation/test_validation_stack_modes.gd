extends "res://tests/test_case.gd"

const LAUNCHER_SCENE := "res://tools/validation/finite/finite_validation_launcher.tscn"
const VIEW_SCRIPT := "res://game/finite/presentation/finite_slice_view.gd"


func run() -> void:
	assert_true(
		ResourceLoader.exists(LAUNCHER_SCENE, "PackedScene"),
		"stack validation requires the launcher scene"
	)
	if not ResourceLoader.exists(LAUNCHER_SCENE, "PackedScene"):
		return

	var packed: PackedScene = load(LAUNCHER_SCENE)
	var launcher: Control = packed.instantiate()
	var tree := Engine.get_main_loop() as SceneTree
	assert_not_null(tree, "stack validation requires SceneTree")
	if tree == null:
		launcher.free()
		return
	tree.root.add_child(launcher)

	var expected_by_mode := {
		&"STACK_8": 8,
		&"STACK_16": 16,
		&"STACK_32": 32,
	}
	for mode: StringName in expected_by_mode:
		var expected_size: int = int(expected_by_mode[mode])
		assert_true(launcher.configure_mode(mode), "%s must configure" % mode)
		var child: Node = launcher.mounted_child()
		assert_not_null(child, "%s must mount a child" % mode)
		if child == null:
			continue
		assert_true(child.has_method("last_model"), "stack fixture must mount the real finite view")
		var child_script: Script = child.get_script()
		assert_equal(
			child_script.resource_path,
			VIEW_SCRIPT,
			"stack fixture must not mount product runtime"
		)
		var model: Dictionary = child.last_model()
		var tokens: Array = model.get("stack_tokens", [])
		assert_equal(tokens.size(), expected_size, "%s must expose exact tokens" % mode)
		var top_count := 0
		for index: int in range(tokens.size()):
			var token: Dictionary = tokens[index]
			top_count += 1 if bool(token.get("top", false)) else 0
			assert_not_equal(
				StringName(token.get("cargo_type", &"")),
				&"",
				"token must expose cargo type"
			)
			assert_not_equal(StringName(token.get("color", &"")), &"", "token must expose color")
			assert_not_equal(StringName(token.get("shape", &"")), &"", "token must expose shape")
			assert_not_equal(str(token.get("label", "")), "", "token must expose text label")
			assert_equal(int(token.get("index", -1)), index, "token index must be stable")
		assert_equal(top_count, 1, "%s must have exactly one TOP" % mode)
		if not tokens.is_empty():
			assert_true(bool(tokens[-1].get("top", false)), "%s TOP must be final/rear" % mode)

	launcher.queue_free()
