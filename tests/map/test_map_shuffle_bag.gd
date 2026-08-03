extends "res://tests/test_case.gd"

const MapShuffleBagScript := preload("res://game/map/map_shuffle_bag.gd")


func run() -> void:
	var bag: Variant = MapShuffleBagScript.new()
	bag.configure([&"map.sx.0001", &"map.sx.0002", &"map.sx.0003"], 42)
	assert_equal(bag.remaining_count(), 3, "new bag must contain all unique map ids")

	var first: StringName = bag.peek([])
	assert_not_equal(first, &"", "bag must peek an eligible map")
	assert_equal(bag.remaining_count(), 3, "peek must not consume bag")
	assert_true(bag.consume(first), "selected map must be consumed only at commit")
	assert_equal(bag.remaining_count(), 2, "commit consumption must remove one map")
	assert_false(bag.consume(first), "same bag entry cannot be consumed twice")

	var second: StringName = bag.peek([first])
	assert_not_equal(second, first, "exclusion must avoid immediate repeat when alternatives exist")
	assert_true(bag.consume(second), "second map must consume")
	var third: StringName = bag.peek([first, second])
	assert_not_equal(third, &"", "bag must relax exclusions when only one item remains")
	assert_true(bag.consume(third), "third map must consume")
	assert_equal(bag.remaining_count(), 0, "bag must empty after all unique maps")

	bag.refill()
	assert_equal(bag.remaining_count(), 3, "refill must restore each unique map exactly once")
