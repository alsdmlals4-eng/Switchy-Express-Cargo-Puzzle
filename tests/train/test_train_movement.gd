extends "res://tests/test_case.gd"

const GENERATOR_PATH := "res://game/rail/rail_generator.gd"
const CONTROLLER_PATH := "res://game/train/train_controller.gd"
const STATE_PATH := "res://game/train/train_state.gd"


func run() -> void:
	var controller_exists := ResourceLoader.exists(CONTROLLER_PATH, "Script")
	var state_exists := ResourceLoader.exists(STATE_PATH, "Script")
	assert_true(controller_exists, "TrainController script must exist")
	assert_true(state_exists, "TrainState script must exist")
	if not controller_exists or not state_exists:
		return

	var graph: Variant = load(GENERATOR_PATH).new().generate(17)
	var start_cell: Vector2i = graph.all_cells()[20]
	var previous_cell: Vector2i = graph.neighbors(start_cell)[0]
	var controller: Variant = load(CONTROLLER_PATH).new()
	controller.configure(graph, start_cell, previous_cell, 8)
	controller.set_speed(2.5)
	assert_equal(controller.speed, 2.5, "controller must store requested cells-per-second speed")
	controller.set_wagon_count(9)
	assert_equal(controller.wagon_count(), 8, "wagon count must clamp to the confirmed capacity of eight")
	assert_equal(controller.wagon_cells().size(), 8, "controller must provide one cell for each attached wagon")
	_assert_train_cells_are_unique_and_connected(controller, graph, "initial primed trail")

	for step: int in range(200):
		var before_current: Vector2i = controller.current_cell()
		var before_previous: Vector2i = controller.previous_cell()
		var expected_next: Vector2i = graph.next_cell(before_current, before_previous)
		controller.advance_one_cell()
		assert_equal(controller.current_cell(), expected_next, "step %d locomotive must follow selected graph exit" % step)
		assert_false(controller.current_cell() == before_previous, "step %d locomotive must not reverse 180 degrees" % step)
		_assert_train_cells_are_unique_and_connected(controller, graph, "step %d" % step)
		assert_true(controller.history_size() <= 13, "step %d route history must remain bounded" % step)

	var switch_graph: Variant = load(GENERATOR_PATH).new().generate(23)
	var junction: Vector2i = switch_graph.switch_cells()[0]
	var incoming: Vector2i = switch_graph.neighbors(junction)[0]
	switch_graph.configure_switch_approach(junction, incoming)
	var default_exit: Vector2i = switch_graph.next_cell(junction, incoming)
	switch_graph.cycle_switch(junction, incoming)
	var selected_exit: Vector2i = switch_graph.next_cell(junction, incoming)
	assert_false(selected_exit == default_exit, "test setup must select a non-default switch exit")

	var switch_controller: Variant = load(CONTROLLER_PATH).new()
	switch_controller.configure(switch_graph, junction, incoming, 3)
	switch_controller.advance_one_cell()
	assert_equal(switch_controller.current_cell(), selected_exit, "locomotive must use the selected switch route")
	assert_equal(switch_graph.next_cell(junction, incoming), default_exit, "switch must reset after locomotive passage")


func _assert_train_cells_are_unique_and_connected(
	controller: Variant,
	graph: Variant,
	context: String
) -> void:
	var train_cells: Array[Vector2i] = controller.train_cells()
	var unique: Dictionary = {}
	for cell: Vector2i in train_cells:
		unique[cell] = true
	assert_equal(unique.size(), train_cells.size(), "%s train cells must not overlap" % context)
	for index: int in range(train_cells.size() - 1):
		assert_true(
			graph.neighbors(train_cells[index]).has(train_cells[index + 1]),
			"%s adjacent locomotive/wagons must occupy connected rail cells" % context
		)
