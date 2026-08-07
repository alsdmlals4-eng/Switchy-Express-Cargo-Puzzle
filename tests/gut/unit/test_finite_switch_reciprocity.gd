extends GutTest

const SwitchScript := preload("res://game/finite/rail/finite_track_switch.gd")

const UP := Vector2i.UP
const RIGHT := Vector2i.RIGHT
const LEFT := Vector2i.LEFT


func test_approach_traffic_follows_selected_exit() -> void:
	var finite_switch: Variant = _switch()
	assert_eq(finite_switch.exit_for(LEFT), RIGHT)
	assert_true(finite_switch.cycle(), "switch must advance selection")
	assert_eq(finite_switch.exit_for(LEFT), LEFT, "first cycle from RIGHT must expose the incoming port for U-turn")


func test_each_connected_port_is_available_in_stable_cardinal_order() -> void:
	var finite_switch: Variant = _switch()
	assert_true(finite_switch.has_method("connected_ports"), "switch must expose all three connected ports")
	if not finite_switch.has_method("connected_ports"):
		return
	assert_eq(finite_switch.connected_ports(), [UP, RIGHT, LEFT])


func test_cycle_visits_all_three_ports_and_returns_to_initial_selection() -> void:
	var finite_switch: Variant = _switch()
	assert_eq(finite_switch.selected_exit(), RIGHT)
	assert_true(finite_switch.cycle())
	assert_eq(finite_switch.selected_exit(), LEFT)
	assert_true(finite_switch.cycle())
	assert_eq(finite_switch.selected_exit(), UP)
	assert_true(finite_switch.cycle())
	assert_eq(finite_switch.selected_exit(), RIGHT)


func test_direct_selection_accepts_connected_port_and_allows_u_turn() -> void:
	var finite_switch: Variant = _switch()
	assert_true(finite_switch.has_method("select_exit"), "switch must support direct port selection")
	if not finite_switch.has_method("select_exit"):
		return
	assert_true(finite_switch.select_exit(LEFT), "incoming port must be directly selectable")
	assert_eq(finite_switch.selected_exit(), LEFT)
	assert_eq(finite_switch.exit_for(LEFT), LEFT, "selecting the incoming port must produce a U-turn")
	assert_true(finite_switch.select_exit(RIGHT))
	assert_eq(finite_switch.exit_for(RIGHT), RIGHT, "any incoming connected port may be selected for U-turn")


func test_direct_selection_rejects_non_connected_port() -> void:
	var finite_switch: Variant = _switch()
	assert_true(finite_switch.has_method("select_exit"))
	if not finite_switch.has_method("select_exit"):
		return
	var before: Vector2i = finite_switch.selected_exit()
	assert_false(finite_switch.select_exit(Vector2i.DOWN))
	assert_eq(finite_switch.selected_exit(), before)


func _switch() -> Variant:
	return SwitchScript.new(LEFT, [RIGHT, UP], RIGHT)
