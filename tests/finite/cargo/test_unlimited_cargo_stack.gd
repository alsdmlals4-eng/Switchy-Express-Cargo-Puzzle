extends "res://tests/test_case.gd"

const STACK_PATH := "res://game/finite/cargo/unlimited_cargo_stack.gd"
const CargoTypeScript := preload("res://game/cargo/cargo_type.gd")


func run() -> void:
	var stack_exists := ResourceLoader.exists(STACK_PATH, "Script")
	assert_true(stack_exists, "unlimited finite cargo stack must exist")
	if not stack_exists:
		return

	var stack_script: Script = load(STACK_PATH)
	var stack: Variant = stack_script.new()
	assert_false("capacity" in stack, "finite stack must not expose capacity")
	assert_equal(stack.size(), 0, "new stack must be empty")
	assert_true(stack.is_empty(), "new stack must report empty")
	assert_equal(stack.peek(), &"", "empty TOP must be blank")
	assert_false(stack.push(&"INVALID"), "invalid cargo types must be rejected")

	var expected_load_order: Array[StringName] = []
	var valid_types: Array[StringName] = CargoTypeScript.all_types()
	for index: int in range(32):
		var cargo_type: StringName = valid_types[index % valid_types.size()]
		assert_true(stack.push(cargo_type), "valid cargo %d must load without a capacity ceiling" % index)
		expected_load_order.append(cargo_type)
	assert_equal(stack.size(), 32, "finite stack must hold at least 32 cargo")
	assert_equal(stack.load_order(), expected_load_order, "load order must preserve bottom-to-TOP order")
	assert_equal(stack.peek(), expected_load_order[31], "latest cargo must be TOP")

	var expected_unload_order: Array[StringName] = expected_load_order.duplicate()
	expected_unload_order.reverse()
	assert_equal(stack.unload_order(), expected_unload_order, "unload order must expose TOP first")

	var top_type: StringName = stack.peek()
	var popped: Array[StringName] = stack.pop_matching_group(top_type)
	assert_equal(popped, [top_type], "alternating stack must pop one matching TOP cargo")
	assert_equal(stack.size(), 31, "matching pop must reduce size")
	assert_equal(stack.pop_matching_group(top_type), [], "mismatched TOP must not mutate stack")

	stack.clear()
	assert_true(stack.push(&"BLUE_DIAMOND"), "mismatch base cargo must load")
	assert_true(stack.push(&"RED_STAR"), "first repeated A must load")
	assert_true(stack.push(&"RED_STAR"), "second repeated A must load")
	assert_true(stack.push(&"RED_STAR"), "third repeated A must load")
	assert_equal(
		stack.pop_matching_group(&"RED_STAR"),
		[&"RED_STAR", &"RED_STAR", &"RED_STAR"],
		"matching group must pop every consecutive TOP cargo"
	)
	assert_equal(stack.size(), 1, "group pop must stop at first mismatch")
	assert_equal(stack.peek(), &"BLUE_DIAMOND", "mismatched base cargo must remain")

	stack.clear()
	assert_equal(stack.size(), 0, "clear must remove every cargo")
	assert_equal(stack.load_order(), [], "clear must reset load order")
	assert_equal(stack.unload_order(), [], "clear must reset unload order")
