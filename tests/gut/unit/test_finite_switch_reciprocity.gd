extends GutTest

const SwitchScript := preload("res://game/finite/rail/finite_track_switch.gd")


func test_approach_traffic_follows_selected_exit() -> void:
	var finite_switch: Variant = SwitchScript.new(
		Vector2i.LEFT,
		[Vector2i.RIGHT, Vector2i.UP],
		Vector2i.RIGHT
	)
	assert_eq(finite_switch.exit_for(Vector2i.LEFT), Vector2i.RIGHT)
	assert_true(finite_switch.cycle(), "switch must select the alternate branch")
	assert_eq(finite_switch.exit_for(Vector2i.LEFT), Vector2i.UP)


func test_each_branch_is_reciprocal_to_the_approach() -> void:
	var finite_switch: Variant = SwitchScript.new(
		Vector2i.LEFT,
		[Vector2i.RIGHT, Vector2i.UP],
		Vector2i.RIGHT
	)
	assert_eq(
		finite_switch.exit_for(Vector2i.RIGHT),
		Vector2i.LEFT,
		"incoming traffic from the selected branch must return through approach"
	)
	assert_eq(
		finite_switch.exit_for(Vector2i.UP),
		Vector2i.LEFT,
		"incoming traffic from the alternate branch must return through approach"
	)
