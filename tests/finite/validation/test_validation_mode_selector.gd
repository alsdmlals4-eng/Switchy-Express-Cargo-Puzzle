extends "res://tests/test_case.gd"

const SELECTOR_SCENE := "res://tools/validation/finite/finite_validation_mode_selector.tscn"


func run() -> void:
	assert_true(
		ResourceLoader.exists(SELECTOR_SCENE, "PackedScene"),
		"validation mode selector scene must exist"
	)
	if not ResourceLoader.exists(SELECTOR_SCENE, "PackedScene"):
		return

	var packed: PackedScene = load(SELECTOR_SCENE)
	var selector: Control = packed.instantiate()
	var tree := Engine.get_main_loop() as SceneTree
	assert_not_null(tree, "selector test requires SceneTree")
	if tree == null:
		selector.free()
		return
	tree.root.add_child(selector)

	var expected := {
		"Panel/Margin/Modes/ProofButton": [&"PROOF", "PROOF"],
		"Panel/Margin/Modes/Stack8Button": [&"STACK_8", "STACK 8"],
		"Panel/Margin/Modes/Stack16Button": [&"STACK_16", "STACK 16"],
		"Panel/Margin/Modes/Stack32Button": [&"STACK_32", "STACK 32"],
	}
	var emitted: Array[StringName] = []
	selector.mode_requested.connect(func(mode: StringName) -> void: emitted.append(mode))

	assert_true(selector.is_selector_visible(), "selector must start visible")
	for path: String in expected:
		var button := selector.get_node(path) as Button
		assert_not_null(button, "%s must exist" % path)
		if button == null:
			continue
		assert_equal(button.text, expected[path][1], "%s must have exact label" % path)
		assert_greater_equal(int(button.custom_minimum_size.x), 48, "%s width must meet touch contract" % path)
		assert_greater_equal(int(button.custom_minimum_size.y), 48, "%s height must meet touch contract" % path)
		button.emit_signal("pressed")
		assert_equal(emitted[-1], expected[path][0], "%s must emit exact mode" % path)

	selector.hide_selector()
	assert_false(selector.is_selector_visible(), "hide_selector must hide selector")
	selector.show_selector()
	assert_true(selector.is_selector_visible(), "show_selector must restore selector")
	selector.queue_free()
