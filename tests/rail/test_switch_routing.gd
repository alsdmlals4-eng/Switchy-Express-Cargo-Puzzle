extends "res://tests/test_case.gd"

const SWITCH_PATH := "res://game/rail/rail_switch.gd"
const GENERATOR_PATH := "res://game/rail/rail_generator.gd"


func run() -> void:
	var switch_script: Script = load(SWITCH_PATH)
	assert_not_null(switch_script, "RailSwitch script must exist")
	if switch_script == null:
		return

	var center := Vector2i(5, 5)
	var left := Vector2i(4, 5)
	var up := Vector2i(5, 4)
	var right := Vector2i(6, 5)
	var down := Vector2i(5, 6)

	var two_state: RefCounted = switch_script.new()
	two_state.configure(center, [left, up, right], left)
	assert_equal(two_state.state_count(), 2, "degree-3 junction must expose two exits for one approach")
	assert_equal(two_state.current_exit(), up, "two-state switch must start at route A")
	two_state.cycle_state()
	assert_equal(two_state.current_exit(), right, "two-state switch must cycle A to B")
	two_state.cycle_state()
	assert_equal(two_state.current_exit(), up, "two-state switch must cycle B to A")

	var three_state: RefCounted = switch_script.new()
	three_state.configure(center, [left, up, right, down], left)
	assert_equal(three_state.state_count(), 3, "degree-4 junction must expose three exits for one approach")
	assert_equal(three_state.current_exit(), up, "three-state switch must start at route A")
	three_state.cycle_state()
	assert_equal(three_state.current_exit(), right, "three-state switch must cycle A to B")
	three_state.cycle_state()
	assert_equal(three_state.current_exit(), down, "three-state switch must cycle B to C")
	three_state.cycle_state()
	assert_equal(three_state.current_exit(), up, "three-state switch must cycle C to A")
	assert_false(three_state.current_exit() == left, "switch must never route an immediate 180-degree reversal")
	three_state.cycle_state()
	three_state.reset_after_passage()
	assert_equal(three_state.current_exit(), up, "switch must reset to its default route after passage")

	var generator_script: Script = load(GENERATOR_PATH)
	assert_not_null(generator_script, "RailGenerator script must exist for routing integration")
	if generator_script == null:
		return

	var graph: RefCounted = generator_script.new().generate(17)
	var junction: Vector2i = graph.switch_cells()[0]
	var incoming: Vector2i = graph.neighbors(junction)[0]
	graph.configure_switch_approach(junction, incoming)
	var expected_next: Vector2i = graph.next_cell(junction, incoming)
	var preview: Array[Vector2i] = graph.preview_route(junction, incoming, 5)
	assert_equal(preview.size(), 5, "route preview must contain five future cells")
	assert_equal(preview[0], expected_next, "preview first cell must match actual next-cell routing")
	assert_false(expected_next == incoming, "graph routing must reject immediate reversal")

	graph.cycle_switch(junction, incoming)
	var changed_next: Vector2i = graph.next_cell(junction, incoming)
	assert_false(changed_next == expected_next, "cycling a switch must select another valid route")
	graph.commit_switch_passage(junction)
	assert_equal(graph.next_cell(junction, incoming), expected_next, "passage commit must restore the default route")
