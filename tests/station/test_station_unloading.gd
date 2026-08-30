extends "res://tests/test_case.gd"

const TYPE_PATH := "res://game/cargo/cargo_type.gd"
const STACK_PATH := "res://game/cargo/cargo_stack.gd"
const STATION_PATH := "res://game/station/station.gd"


func run() -> void:
	var cargo_type: Script = load(TYPE_PATH)
	var stack_script: Script = load(STACK_PATH)
	var station_script: Script = load(STATION_PATH)
	var red: StringName = cargo_type.RED_STAR
	var blue: StringName = cargo_type.BLUE_DIAMOND
	var yellow: StringName = cargo_type.YELLOW_TRIANGLE
	var waste: StringName = &"WASTE_CRATE"
	assert_true(cargo_type.is_valid(waste), "waste crate must be a valid authored cargo type")
	assert_equal(cargo_type.color_for(waste), &"WASTE", "waste crate must expose a distinct render color")
	assert_equal(cargo_type.shape_for(waste), &"CRATE", "waste crate must expose a distinct render shape")

	var stack: Variant = stack_script.new(8)
	stack.push(red)
	stack.push(red)
	stack.push(blue)
	stack.push(red)
	assert_equal(stack.unload_order(), [red, blue, red, red], "test setup must expose reverse unload order")

	var red_station: Variant = station_script.new(Vector2i(2, 2), red)
	var blue_station: Variant = station_script.new(Vector2i(4, 2), blue)
	var yellow_station: Variant = station_script.new(Vector2i(6, 2), yellow)

	var red_first: Dictionary = red_station.try_unload(stack)
	assert_true(red_first.matched, "matching top cargo must mark result as matched")
	assert_equal(red_first.count, 1, "first red station must unload only top red")
	assert_equal(red_first.items, [red], "first red result must contain one red item")
	assert_equal(red_first.unload_order_before, [red, blue, red, red], "result must expose pre-unload ViewModel")
	assert_equal(red_first.unload_order_after, [blue, red, red], "result must expose post-unload ViewModel")

	var blocked: Dictionary = yellow_station.try_unload(stack)
	assert_false(blocked.matched, "mismatched top cargo must report no match")
	assert_equal(blocked.count, 0, "mismatched station must unload zero")
	assert_equal(blocked.unload_order_before, [blue, red, red], "blocked result must preserve current order")
	assert_equal(blocked.unload_order_after, [blue, red, red], "blocked unload must not mutate order")

	var blue_result: Dictionary = blue_station.try_unload(stack)
	assert_equal(blue_result.count, 1, "blue station must unload the blocking blue cargo")
	assert_equal(blue_result.unload_order_after, [red, red], "blue unload must reveal older red pair")

	var red_pair: Dictionary = red_station.try_unload(stack)
	assert_equal(red_pair.count, 2, "final red station must unload consecutive red pair")
	assert_equal(red_pair.items, [red, red], "final red result must contain both red cargo")
	assert_equal(red_pair.unload_order_after, [], "stack must be empty after final unload")
	assert_true(stack.is_empty(), "actual stack and result ViewModel must agree")

	var waste_stack: Variant = stack_script.new(8)
	waste_stack.push(waste)
	var disposal_yard: Variant = station_script.new(Vector2i(8, 2), waste)
	var waste_result: Dictionary = disposal_yard.try_unload(waste_stack)
	assert_true(waste_result.matched, "a disposal yard must unload a matching waste crate")
	assert_equal(waste_result.items, [waste], "waste unloading must preserve the explicit cargo type")
	assert_true(waste_stack.is_empty(), "matching waste unload must consume the crate from the shared LIFO stack")
