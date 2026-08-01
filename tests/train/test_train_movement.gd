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

	var generator: Variant = load(GENERATOR_PATH).new()
	var controller_script: Script = load(CONTROLLER_PATH)
	var graph: Variant = generator.generate(17)
	var start_cell: Vector2i = graph.all_cells()[20]
	var previous_cell: Vector2i = graph.neighbors(start_cell)[0]
	var controller: Variant = controller_script.new()
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

	_test_continuous_movement(controller_script, generator)
	_test_primed_trails_across_seeds(controller_script, generator)
	_test_switch_passage(controller_script, generator)


func _test_continuous_movement(controller_script: Script, generator: Variant) -> void:
	var graph: Variant = generator.generate(41)
	var start_cell: Vector2i = graph.all_cells()[24]
	var previous_cell: Vector2i = graph.neighbors(start_cell)[0]
	var first_target: Vector2i = graph.next_cell(start_cell, previous_cell)
	var controller: Variant = controller_script.new()
	controller.configure(graph, start_cell, previous_cell, 2)
	controller.set_wagon_count(2)
	controller.set_speed(2.0)

	assert_equal(controller.movement_progress(), 0.0, "movement progress must start at zero")
	assert_equal(controller.target_cell(), first_target, "target cell must follow current graph routing")
	assert_equal(controller.advance_time(0.25), 0, "quarter second at speed two must not cross a full cell")
	assert_equal(controller.movement_progress(), 0.5, "quarter second at speed two must advance half a cell")
	assert_equal(
		controller.locomotive_position(),
		Vector2(start_cell).lerp(Vector2(first_target), 0.5),
		"locomotive must interpolate between current and target cells"
	)
	var wagon_positions: Array[Vector2] = controller.wagon_positions()
	assert_equal(wagon_positions.size(), 2, "continuous view must include both wagons")
	assert_equal(
		wagon_positions[0],
		Vector2(previous_cell).lerp(Vector2(start_cell), 0.5),
		"first wagon must interpolate over the locomotive's previous segment"
	)
	assert_equal(controller.train_positions().size(), 3, "continuous train positions must include locomotive and wagons")

	assert_equal(controller.advance_time(0.25), 1, "second quarter second must cross exactly one cell")
	assert_equal(controller.current_cell(), first_target, "cell crossing must commit locomotive to target")
	assert_equal(controller.movement_progress(), 0.0, "exact cell crossing must leave zero remainder")
	assert_equal(controller.wagon_positions()[0], Vector2(start_cell), "wagon must reach prior locomotive cell at boundary")

	var expected_current: Vector2i = controller.current_cell()
	var expected_previous: Vector2i = controller.previous_cell()
	for _index: int in range(2):
		var next: Vector2i = graph.next_cell(expected_current, expected_previous)
		expected_previous = expected_current
		expected_current = next
	assert_equal(controller.advance_time(1.25), 2, "large delta must process every full crossed cell")
	assert_equal(controller.current_cell(), expected_current, "large delta must end on the correct graph cell")
	assert_equal(controller.movement_progress(), 0.5, "large delta must preserve fractional remainder")
	assert_true(controller.history_size() <= 7, "continuous movement must preserve bounded history")


func _test_primed_trails_across_seeds(controller_script: Script, generator: Variant) -> void:
	for seed: int in range(1, 26):
		var graph: Variant = generator.generate(seed)
		var cells: Array[Vector2i] = graph.all_cells()
		var sample_indices: Array[int] = [5, cells.size() / 2, cells.size() - 6]
		for sample_index: int in sample_indices:
			var start_cell: Vector2i = cells[sample_index]
			var previous_cell: Vector2i = graph.neighbors(start_cell)[0]
			var controller: Variant = controller_script.new()
			controller.configure(graph, start_cell, previous_cell, 8)
			controller.set_wagon_count(8)
			_assert_train_cells_are_unique_and_connected(
				controller,
				graph,
				"seed %d sample %d primed trail" % [seed, sample_index]
			)


func _test_switch_passage(controller_script: Script, generator: Variant) -> void:
	var switch_graph: Variant = generator.generate(23)
	var junction: Vector2i = switch_graph.switch_cells()[0]
	var incoming: Vector2i = switch_graph.neighbors(junction)[0]
	switch_graph.configure_switch_approach(junction, incoming)
	var default_exit: Vector2i = switch_graph.next_cell(junction, incoming)
	switch_graph.cycle_switch(junction, incoming)
	var selected_exit: Vector2i = switch_graph.next_cell(junction, incoming)
	assert_false(selected_exit == default_exit, "test setup must select a non-default switch exit")

	var switch_controller: Variant = controller_script.new()
	switch_controller.configure(switch_graph, junction, incoming, 3)
	switch_controller.set_speed(1.0)
	assert_equal(switch_controller.target_cell(), selected_exit, "selected switch exit must become the current segment target")
	assert_equal(switch_controller.advance_time(0.25), 0, "partial switch traversal must stay within the segment")
	switch_graph.cycle_switch(junction, incoming)
	assert_equal(
		switch_controller.target_cell(),
		selected_exit,
		"switch changes after departure must not redirect the in-flight segment"
	)
	assert_equal(switch_controller.advance_time(0.75), 1, "remaining switch traversal must cross the selected segment")
	assert_equal(switch_controller.current_cell(), selected_exit, "locomotive must finish on the locked selected route")
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
