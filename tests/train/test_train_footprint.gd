extends "res://tests/test_case.gd"

const GENERATOR_PATH := "res://game/rail/rail_generator.gd"
const TRAIN_PATH := "res://game/train/train_controller.gd"
const STACK_PATH := "res://game/cargo/cargo_stack.gd"
const TOKEN_STATE_PATH := "res://game/train/compact_wagon_token_state.gd"
const FOOTPRINT_PATH := "res://game/train/train_footprint.gd"

const RED: StringName = &"RED_STAR"
const BLUE: StringName = &"BLUE_DIAMOND"
const YELLOW: StringName = &"YELLOW_TRIANGLE"
const POSITION_TOLERANCE := 0.0001


func run() -> void:
	var footprint_exists := ResourceLoader.exists(FOOTPRINT_PATH, "Script")
	assert_true(footprint_exists, "TrainFootprint script must exist")
	if not footprint_exists:
		return

	var graph: Variant = load(GENERATOR_PATH).new().generate(23)
	var start_cell: Vector2i = graph.all_cells()[24]
	var incoming_cell: Vector2i = graph.neighbors(start_cell)[0]
	var train: Variant = load(TRAIN_PATH).new()
	train.configure(graph, start_cell, incoming_cell, 8)
	train.set_speed(2.0)
	train.advance_time(0.25)

	var stack: Variant = load(STACK_PATH).new(8)
	var token_state: Variant = load(TOKEN_STATE_PATH).new()
	token_state.configure(stack)
	var footprint: Variant = load(FOOTPRINT_PATH).new()
	footprint.configure(train, token_state)

	assert_equal(footprint.token_positions(), [], "empty stack must produce no compact token positions")
	assert_equal(
		footprint.occupied_cells(),
		[train.current_cell()],
		"empty compact footprint must reserve only the locomotive cell"
	)

	var cargo_types: Array[StringName] = [RED, BLUE, YELLOW, RED, BLUE, YELLOW, RED, BLUE]
	for cargo_type: StringName in cargo_types:
		assert_true(stack.push(cargo_type), "test setup must load eight cargo tokens")
	assert_true(token_state.sync_from_stack(), "loaded stack must synchronize token state")

	var positions: Array[Vector2] = footprint.token_positions()
	assert_equal(positions.size(), 8, "capacity-eight stack must produce eight compact token positions")
	for index: int in range(positions.size()):
		var expected_distance := 0.22 + float(index) * 0.28
		assert_almost_equal(
			footprint.token_distance_cells(index),
			expected_distance,
			POSITION_TOLERANCE,
			"compact token distance must use the approved body/spacing geometry"
		)
		var expected_position: Vector2 = train.sample_trailing_position(expected_distance)
		assert_almost_equal(
			positions[index].distance_to(expected_position),
			0.0,
			POSITION_TOLERANCE,
			"token %d must sample the train route instead of cutting corners" % index
		)

	assert_almost_equal(
		footprint.maximum_trailing_distance_cells(),
		2.18,
		POSITION_TOLERANCE,
		"eight tokens must end at the approved 2.18-cell trailing distance"
	)
	_assert_occupied_cells(footprint, train, "partial straight/curve segment")

	for step: int in range(12):
		train.advance_time(0.5)
		var moved_positions: Array[Vector2] = footprint.token_positions()
		for index: int in range(moved_positions.size()):
			var expected: Vector2 = train.sample_trailing_position(footprint.token_distance_cells(index))
			assert_almost_equal(
				moved_positions[index].distance_to(expected),
				0.0,
				POSITION_TOLERANCE,
				"step %d token %d must remain on route-history geometry" % [step, index]
			)
		_assert_occupied_cells(footprint, train, "step %d" % step)


func _assert_occupied_cells(footprint: Variant, train: Variant, context: String) -> void:
	var occupied: Array[Vector2i] = footprint.occupied_cells()
	var trailing: Array[Vector2i] = footprint.trailing_occupied_cells()
	var history: Array[Vector2i] = train.route_history_cells()
	var unique: Dictionary = {}
	for cell: Vector2i in occupied:
		unique[cell] = true
		assert_true(history.has(cell), "%s occupied cell must come from route history" % context)
	assert_equal(unique.size(), occupied.size(), "%s occupied cells must be unique" % context)
	assert_equal(occupied[0], train.current_cell(), "%s footprint must start at locomotive cell" % context)
	assert_less_equal(trailing.size(), 3.0, "%s eight-token trailing footprint must reserve at most three cells" % context)
	for index: int in range(occupied.size() - 1):
		var first_index: int = history.find(occupied[index])
		var second_index: int = history.find(occupied[index + 1])
		assert_true(second_index > first_index, "%s occupied order must remain front-to-rear" % context)
