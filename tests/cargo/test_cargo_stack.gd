extends "res://tests/test_case.gd"

const TYPE_PATH := "res://game/cargo/cargo_type.gd"
const STACK_PATH := "res://game/cargo/cargo_stack.gd"
const INPUT_PATH := "res://game/input/gameplay_input_state.gd"


func run() -> void:
	var type_exists := ResourceLoader.exists(TYPE_PATH, "Script")
	var stack_exists := ResourceLoader.exists(STACK_PATH, "Script")
	var input_exists := ResourceLoader.exists(INPUT_PATH, "Script")
	assert_true(type_exists, "CargoType script must exist")
	assert_true(stack_exists, "CargoStack script must exist")
	assert_true(input_exists, "GameplayInputState script must exist")
	if not type_exists or not stack_exists or not input_exists:
		return

	var cargo_type: Script = load(TYPE_PATH)
	var stack_script: Script = load(STACK_PATH)
	var input_script: Script = load(INPUT_PATH)
	var red: StringName = cargo_type.RED_STAR
	var blue: StringName = cargo_type.BLUE_DIAMOND
	var yellow: StringName = cargo_type.YELLOW_TRIANGLE

	assert_equal(cargo_type.all_types().size(), 3, "exactly three cargo types must exist in Vertical Slice")
	assert_false(red == blue or blue == yellow or red == yellow, "cargo type identifiers must be distinct")
	assert_equal(cargo_type.shape_for(red), &"STAR", "red cargo must carry star shape encoding")
	assert_equal(cargo_type.shape_for(blue), &"DIAMOND", "blue cargo must carry diamond shape encoding")
	assert_equal(cargo_type.shape_for(yellow), &"TRIANGLE", "yellow cargo must carry triangle shape encoding")

	var input_state: Variant = input_script.new()
	assert_false(input_state.is_loading(), "LOAD must default to inactive")
	assert_false(input_state.is_boosting(), "BOOST must default to inactive")
	input_state.set_load_requested(true)
	assert_true(input_state.is_loading(), "LOAD request must enable loading without BOOST")
	input_state.set_boost_requested(true)
	assert_true(input_state.is_boosting(), "BOOST request must enable boosting")
	assert_false(input_state.is_loading(), "BOOST must take priority and disable LOAD")
	input_state.set_boost_requested(false)
	assert_true(input_state.is_loading(), "LOAD must resume when BOOST releases")
	input_state.clear()
	assert_false(input_state.is_loading(), "clear must release LOAD")

	var stack: Variant = stack_script.new(8)
	assert_equal(stack.capacity, 8, "cargo capacity must be eight")
	assert_false(stack.try_load(red, input_state), "cargo contact must not load while LOAD is inactive")
	assert_equal(stack.size(), 0, "inactive LOAD must not mutate stack")

	input_state.set_load_requested(true)
	assert_true(stack.try_load(red, input_state), "LOAD must accept first red cargo")
	assert_true(stack.try_load(red, input_state), "LOAD must accept second red cargo")
	assert_true(stack.try_load(blue, input_state), "LOAD must accept blue cargo")
	assert_true(stack.try_load(red, input_state), "LOAD must accept final red cargo")
	assert_equal(stack.load_order(), [red, red, blue, red], "stack must preserve physical load order")
	assert_equal(stack.unload_order(), [red, blue, red, red], "unload ViewModel must reverse load order")
	assert_equal(stack.peek(), red, "last loaded cargo must be stack top")

	var first_red_group: Array = stack.pop_matching_group(red)
	assert_equal(first_red_group, [red], "red station must unload only the consecutive top red group")
	assert_equal(stack.peek(), blue, "blue must block older red cargo")
	assert_equal(stack.pop_matching_group(red).size(), 0, "mismatched station must unload zero cargo")
	assert_equal(stack.pop_matching_group(blue), [blue], "blue station must unload top blue cargo")
	assert_equal(stack.pop_matching_group(red), [red, red], "red station must then unload the remaining red pair")
	assert_true(stack.is_empty(), "stack must be empty after all matching groups unload")

	for index: int in range(8):
		assert_true(stack.push(cargo_type.all_types()[index % 3]), "capacity slot %d must accept cargo" % index)
	assert_false(stack.push(red), "ninth cargo must be rejected")
	assert_equal(stack.size(), 8, "rejected cargo must not exceed capacity")
