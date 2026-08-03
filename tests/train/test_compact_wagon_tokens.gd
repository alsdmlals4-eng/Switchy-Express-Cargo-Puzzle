extends "res://tests/test_case.gd"

const STACK_PATH := "res://game/cargo/cargo_stack.gd"
const TOKEN_STATE_PATH := "res://game/train/compact_wagon_token_state.gd"

const RED: StringName = &"RED_STAR"
const BLUE: StringName = &"BLUE_DIAMOND"
const YELLOW: StringName = &"YELLOW_TRIANGLE"


func run() -> void:
	var token_state_exists := ResourceLoader.exists(TOKEN_STATE_PATH, "Script")
	assert_true(token_state_exists, "CompactWagonTokenState script must exist")
	if not token_state_exists:
		return

	_assert_every_supported_count()

	var stack: Variant = load(STACK_PATH).new(8)
	var token_state: Variant = load(TOKEN_STATE_PATH).new()
	token_state.configure(stack)

	assert_equal(token_state.token_count(), 0, "empty CargoStack must produce zero compact tokens")
	assert_equal(token_state.front_to_rear_types(), [], "empty token state must preserve an empty order")
	assert_equal(token_state.rear_type(), &"", "empty token state must expose no rear cargo")
	assert_equal(token_state.revision(), 0, "initial empty synchronization must not create a revision")

	var expected: Array[StringName] = [RED, BLUE, RED, YELLOW, BLUE, RED, BLUE, YELLOW]
	for cargo_type: StringName in expected:
		assert_true(stack.push(cargo_type), "test setup must fill CargoStack to capacity")

	assert_true(token_state.sync_from_stack(), "stack mutation must refresh compact token state")
	assert_equal(token_state.token_count(), 8, "token count must equal CargoStack size")
	assert_equal(
		token_state.front_to_rear_types(),
		expected,
		"front-to-rear compact token order must equal stack bottom-to-top order"
	)
	assert_equal(token_state.rear_type(), YELLOW, "rear compact token must equal CargoStack top")
	assert_equal(token_state.revision(), 1, "one changed stack snapshot must advance one revision")
	assert_false(token_state.sync_from_stack(), "unchanged stack snapshot must not advance twice")
	assert_equal(token_state.revision(), 1, "unchanged synchronization must preserve revision")

	var unloaded: Array[StringName] = stack.pop_matching_group(YELLOW)
	assert_equal(unloaded, [YELLOW], "test setup must remove the current LIFO top group")
	assert_true(token_state.sync_from_stack(), "unload mutation must refresh compact token state")
	assert_equal(token_state.token_count(), 7, "unload must reduce compact token count")
	assert_equal(token_state.rear_type(), BLUE, "rear compact token must follow the new CargoStack top")
	assert_equal(token_state.revision(), 2, "second changed snapshot must advance exactly once")


func _assert_every_supported_count() -> void:
	var sequence: Array[StringName] = [RED, BLUE, YELLOW, RED, BLUE, YELLOW, RED, BLUE]
	for count: int in range(9):
		var stack: Variant = load(STACK_PATH).new(8)
		for index: int in range(count):
			assert_true(stack.push(sequence[index]), "count %d setup cargo must load" % count)
		var token_state: Variant = load(TOKEN_STATE_PATH).new()
		token_state.configure(stack)
		var expected: Array[StringName] = []
		for index: int in range(count):
			expected.append(sequence[index])
		assert_equal(token_state.token_count(), count, "count %d must map one cargo to one compact token" % count)
		assert_equal(token_state.front_to_rear_types(), expected, "count %d must preserve bottom-to-top order" % count)
		var expected_rear: StringName = &"" if count == 0 else sequence[count - 1]
		assert_equal(token_state.rear_type(), expected_rear, "count %d rear must equal the LIFO top" % count)
