class_name RailGenerator
extends RefCounted

const RailGraphScript := preload("res://game/rail/rail_graph.gd")

const BOARD_WIDTH := 15
const BOARD_HEIGHT := 10
const DEFAULT_ATTEMPTS := 32


func generate(
	seed: int,
	max_attempts: int = DEFAULT_ATTEMPTS,
	force_candidate_failure: bool = false
) -> Variant:
	var attempt_limit := maxi(max_attempts, 1)
	for attempt: int in range(attempt_limit):
		if force_candidate_failure:
			continue
		var candidate: Variant = _build_candidate(seed, attempt)
		if _is_valid(candidate):
			return candidate

	var fallback: Variant = _build_network([3, 6], [3, 7, 11])
	fallback.used_fallback = true
	assert(_is_valid(fallback), "deterministic safe fallback must satisfy the rail contract")
	return fallback


func _build_candidate(seed: int, attempt: int) -> Variant:
	var positive_seed := absi(seed) + attempt * 31
	var upper_row := 2 + positive_seed % 2
	var lower_row := 6 + int(positive_seed / 2) % 2
	var left_column := 3 + int(positive_seed / 3) % 2
	var middle_column := 7
	var right_column := 10 + int(positive_seed / 5) % 2
	return _build_network(
		[upper_row, lower_row],
		[left_column, middle_column, right_column]
	)


func _build_network(horizontal_rows: Array, vertical_columns: Array) -> Variant:
	var graph: Variant = RailGraphScript.new(BOARD_WIDTH, BOARD_HEIGHT)

	_connect_horizontal(graph, 0)
	_connect_horizontal(graph, BOARD_HEIGHT - 1)
	_connect_vertical(graph, 0)
	_connect_vertical(graph, BOARD_WIDTH - 1)

	for row: Variant in horizontal_rows:
		_connect_horizontal(graph, row)
	for column: Variant in vertical_columns:
		_connect_vertical(graph, column)

	graph.finalize_switches()
	return graph


func _connect_horizontal(graph: Variant, row: int) -> void:
	for column: int in range(BOARD_WIDTH - 1):
		graph.add_edge(Vector2i(column, row), Vector2i(column + 1, row))


func _connect_vertical(graph: Variant, column: int) -> void:
	for row: int in range(BOARD_HEIGHT - 1):
		graph.add_edge(Vector2i(column, row), Vector2i(column, row + 1))


func _is_valid(graph: Variant) -> bool:
	return (
		graph.width == BOARD_WIDTH
		and graph.height == BOARD_HEIGHT
		and graph.is_fully_connected()
		and graph.dead_end_count() == 0
		and graph.cycle_rank() >= 3
		and graph.switch_cells().size() >= 6
		and graph.two_state_switch_count() >= 4
		and graph.three_state_switch_count() >= 2
		and graph.meaningful_switch_count(3) >= 6
	)
