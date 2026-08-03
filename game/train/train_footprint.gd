class_name TrainFootprint
extends RefCounted

const TOKEN_FRONT_OFFSET_CELLS := 0.22
const TOKEN_SPACING_CELLS := 0.28

var _train: Variant
var _token_state: Variant


func configure(train: Variant, token_state: Variant) -> void:
	assert(train != null, "TrainFootprint requires a TrainController")
	assert(token_state != null, "TrainFootprint requires CompactWagonTokenState")
	_train = train
	_token_state = token_state


func sync_from_sources() -> bool:
	_assert_configured()
	return _token_state.sync_from_stack()


func token_distance_cells(index: int) -> float:
	_assert_configured()
	assert(index >= 0 and index < _token_state.token_count(), "token index must exist")
	return TOKEN_FRONT_OFFSET_CELLS + float(index) * TOKEN_SPACING_CELLS


func maximum_trailing_distance_cells() -> float:
	_assert_configured()
	if _token_state.token_count() == 0:
		return 0.0
	return token_distance_cells(_token_state.token_count() - 1)


func token_positions(cell_size: Vector2 = Vector2.ONE) -> Array[Vector2]:
	_assert_configured()
	var positions: Array[Vector2] = []
	for index: int in range(_token_state.token_count()):
		positions.append(_train.sample_trailing_position(token_distance_cells(index), cell_size))
	return positions


func occupied_cells() -> Array[Vector2i]:
	_assert_configured()
	var history: Array[Vector2i] = _train.route_history_cells()
	assert(not history.is_empty(), "TrainFootprint requires route history")

	var occupied: Array[Vector2i] = [_train.current_cell()]
	for index: int in range(_token_state.token_count()):
		var distance_from_current := maxf(
			token_distance_cells(index) - float(_train.movement_progress()),
			0.0
		)
		var history_index := clampi(roundi(distance_from_current), 0, history.size() - 1)
		var cell: Vector2i = history[history_index]
		if not occupied.has(cell):
			occupied.append(cell)
	return occupied


func trailing_occupied_cells() -> Array[Vector2i]:
	var occupied: Array[Vector2i] = occupied_cells()
	var trailing: Array[Vector2i] = []
	for index: int in range(1, occupied.size()):
		trailing.append(occupied[index])
	return trailing


func _assert_configured() -> void:
	assert(_train != null and _token_state != null, "TrainFootprint must be configured before use")
