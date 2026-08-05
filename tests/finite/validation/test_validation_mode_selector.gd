extends "res://tests/test_case.gd"

const SELECTOR_SCENE := "res://tools/validation/finite/finite_validation_mode_selector.tscn"
const LAUNCHER_SCENE := "res://tools/validation/finite/finite_validation_launcher.tscn"


func run() -> void:
	assert_true(
		ResourceLoader.exists(SELECTOR_SCENE, "PackedScene"),
		"validation mode selector scene must exist"
	)
	if not ResourceLoader.exists(SELECTOR_SCENE, "PackedScene"):
		return

	var selector_packed: PackedScene = load(SELECTOR_SCENE)
	var selector: Control = selector_packed.instantiate()
	var tree := Engine.get_main_loop() as SceneTree
	assert_not_null(tree, "selector test requires SceneTree")
	if tree == null:
		selector.free()
		return
	tree.root.add_child(selector)

	var expected := {
		"ProofButton": ["PROOF", &"PROOF"],
		"Stack8Button": ["STACK 8", &"STACK_8"],
		"Stack16Button": ["STACK 16", &"STACK_16"],
		"Stack32Button": ["STACK 32", &"STACK_32"],
	}
	for node_name: String in expected:
		var button := selector.get_node_or_null("Panel/VBox/%s" % node_name) as Button
		assert_not_null(button, "%s must exist" % node_name)
		if button == null:
			continue
		assert_equal(button.text, expected[node_name][0], "%s label must be explicit" % node_name)
		assert_greater_equal(int(button.custom_minimum_size.x), 48, "%s width must meet touch minimum" % node_name)
		assert_greater_equal(int(button.custom_minimum_size.y), 48, "%s height must meet touch minimum" % node_name)

	assert_true(selector.has_signal("mode_selected"), "selector must expose mode_selected signal")
	var emitted: Array[StringName] = []
	selector.mode_selected.connect(func(mode: StringName) -> void: emitted.append(mode))
	(selector.get_node("Panel/VBox/Stack16Button") as Button).pressed.emit()
	assert_equal(emitted, [&"STACK_16"], "button must emit exact mode identifier")
	selector.queue_free()

	assert_true(ResourceLoader.exists(LAUNCHER_SCENE, "PackedScene"), "launcher scene must exist")
	if not ResourceLoader.exists(LAUNCHER_SCENE, "PackedScene"):
		return
	var launcher: Control = (load(LAUNCHER_SCENE) as PackedScene).instantiate()
	tree.root.add_child(launcher)
	assert_true(launcher.has_method("show_selector"), "launcher must expose selector navigation")
	assert_true(launcher.has_method("selector_visible"), "launcher must expose selector state")
	assert_true(launcher.has_method("back_to_modes"), "launcher must expose Back to Modes")
	assert_true(launcher.selector_visible(), "launcher must boot into selector state")
	assert_equal(launcher.mounted_child(), null, "selector state must mount no proof or fixture child")
	launcher.queue_free()
