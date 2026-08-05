extends "res://tests/test_case.gd"

const SELECTOR_SCENE := "res://tools/validation/finite/finite_validation_mode_selector.tscn"


func run() -> void:
	assert_true(ResourceLoader.exists(SELECTOR_SCENE, "PackedScene"), "validation selector scene must exist")
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
		"ProofButton": ["PROOF", &"PROOF"],
		"Stack8Button": ["STACK 8", &"STACK_8"],
		"Stack16Button": ["STACK 16", &"STACK_16"],
		"Stack32Button": ["STACK 32", &"STACK_32"],
	}
	var emitted: Array[StringName] = []
	selector.mode_selected.connect(func(mode: StringName) -> void: emitted.append(mode))
	for node_name: String in expected:
		var button := selector.get_node("Panel/Margin/Buttons/%s" % node_name) as Button
		assert_not_null(button, "%s must exist" % node_name)
		if button == null:
			continue
		assert_equal(button.text, expected[node_name][0], "%s label must be explicit" % node_name)
		assert_greater_equal(int(button.custom_minimum_size.x), 48, "%s width must meet touch minimum" % node_name)
		assert_greater_equal(int(button.custom_minimum_size.y), 48, "%s height must meet touch minimum" % node_name)
		button.pressed.emit()
		assert_equal(emitted[-1], expected[node_name][1], "%s must emit exact mode" % node_name)

	selector.queue_free()
