class_name TrackLayoutEditor
extends RefCounted

const TrackPieceScript := preload("res://game/finite/build/track_piece.gd")
const TrackEditResultScript := preload("res://game/finite/build/track_edit_result.gd")

const PASS: StringName = &"PASS"
const OUTSIDE_BOARD: StringName = &"OUTSIDE_BOARD"
const NOT_BUILDABLE: StringName = &"NOT_BUILDABLE"
const BLOCKED_CELL: StringName = &"BLOCKED_CELL"
const AUTHORED_ANCHOR: StringName = &"AUTHORED_ANCHOR"
const OCCUPIED_CELL: StringName = &"OCCUPIED_CELL"
const EMPTY_CELL: StringName = &"EMPTY_CELL"
const INVALID_PIECE: StringName = &"INVALID_PIECE"

var _definition: Variant
var _layout: Variant


func _init(definition: Variant = null, layout: Variant = null) -> void:
	_definition = definition
	_layout = layout


func place_piece(piece: Variant) -> Variant:
	var cost_before := _current_cost()
	var validated_piece: Variant = _validated_piece_copy(piece)
	if validated_piece == null:
		return _failure(INVALID_PIECE, "piece is invalid", [], cost_before)

	var cell: Vector2i = validated_piece.cell
	var surface_code := _surface_validation_code(cell)
	if surface_code != PASS:
		return _failure(surface_code, _message_for(surface_code), [cell], cost_before)
	if _layout.piece_at(cell) != null:
		return _failure(OCCUPIED_CELL, _message_for(OCCUPIED_CELL), [cell], cost_before)

	if not _layout.put_piece(validated_piece):
		return _failure(INVALID_PIECE, "piece could not be placed", [cell], cost_before)
	return _success([cell], cost_before)


func rotate_piece(cell: Vector2i, delta_quarters: int) -> Variant:
	var cost_before := _current_cost()
	var surface_code := _surface_validation_code(cell)
	if surface_code != PASS:
		return _failure(surface_code, _message_for(surface_code), [cell], cost_before)

	var current: Variant = _layout.piece_at(cell)
	if current == null:
		return _failure(EMPTY_CELL, _message_for(EMPTY_CELL), [cell], cost_before)

	var quarter_turns: int = posmod(delta_quarters, 4)
	var next_rotation: int = posmod(current.rotation_quarters + quarter_turns, 4)
	var next_switch_exit := Vector2i.ZERO
	if current.geometry == &"SWITCH":
		next_switch_exit = _rotate_clockwise(current.switch_initial_exit, quarter_turns)
	var replacement: Variant = TrackPieceScript.create(
		cell,
		current.geometry,
		next_rotation,
		next_switch_exit
	)
	if replacement == null:
		return _failure(INVALID_PIECE, "rotated piece is invalid", [cell], cost_before)

	_layout.put_piece(replacement)
	return _success([cell], cost_before)


func replace_piece(piece: Variant) -> Variant:
	var cost_before := _current_cost()
	var validated_piece: Variant = _validated_piece_copy(piece)
	if validated_piece == null:
		return _failure(INVALID_PIECE, "piece is invalid", [], cost_before)

	var cell: Vector2i = validated_piece.cell
	var surface_code := _surface_validation_code(cell)
	if surface_code != PASS:
		return _failure(surface_code, _message_for(surface_code), [cell], cost_before)
	if _layout.piece_at(cell) == null:
		return _failure(EMPTY_CELL, _message_for(EMPTY_CELL), [cell], cost_before)

	if not _layout.put_piece(validated_piece):
		return _failure(INVALID_PIECE, "replacement piece is invalid", [cell], cost_before)
	return _success([cell], cost_before)


func remove_piece(cell: Vector2i) -> Variant:
	var cost_before := _current_cost()
	var surface_code := _surface_validation_code(cell)
	if surface_code != PASS:
		return _failure(surface_code, _message_for(surface_code), [cell], cost_before)
	if _layout.piece_at(cell) == null:
		return _failure(EMPTY_CELL, _message_for(EMPTY_CELL), [cell], cost_before)

	_layout.remove_piece(cell)
	return _success([cell], cost_before)


func clear_layout() -> Variant:
	var cost_before := _current_cost()
	var affected_cells: Array[Vector2i] = []
	for piece: Variant in _layout.pieces():
		affected_cells.append(piece.cell)
	_layout.clear()
	return _success(affected_cells, cost_before)


func _validated_piece_copy(piece: Variant) -> Variant:
	if piece == null or not piece is RefCounted:
		return null
	var piece_script: Script = piece.get_script()
	if piece_script == null or piece_script.resource_path != TrackPieceScript.resource_path:
		return null
	return piece.duplicate_piece()


func _surface_validation_code(cell: Vector2i) -> StringName:
	if _definition == null or _layout == null:
		return INVALID_PIECE
	if (
		cell.x < 0
		or cell.y < 0
		or cell.x >= _definition.board_size.x
		or cell.y >= _definition.board_size.y
	):
		return OUTSIDE_BOARD
	if _definition.required_anchor_cells().has(cell):
		return AUTHORED_ANCHOR
	if _definition.blocked_cells.has(cell):
		return BLOCKED_CELL
	if not _definition.buildable_cells.has(cell):
		return NOT_BUILDABLE
	return PASS


func _success(affected_cells: Array[Vector2i], cost_before: int) -> Variant:
	return TrackEditResultScript.new(
		true,
		PASS,
		_message_for(PASS),
		affected_cells,
		cost_before,
		_current_cost()
	)


func _failure(
	code: StringName,
	message: String,
	affected_cells: Array[Vector2i],
	cost_before: int
) -> Variant:
	return TrackEditResultScript.new(
		false,
		code,
		message,
		affected_cells,
		cost_before,
		cost_before
	)


func _current_cost() -> int:
	if _layout == null:
		return 0
	return _layout.build_cost()


static func _message_for(code: StringName) -> String:
	match code:
		PASS:
			return "edit applied"
		OUTSIDE_BOARD:
			return "cell is outside the board"
		NOT_BUILDABLE:
			return "cell is not buildable"
		BLOCKED_CELL:
			return "cell is blocked"
		AUTHORED_ANCHOR:
			return "authored anchor cannot be edited"
		OCCUPIED_CELL:
			return "cell already contains a player piece"
		EMPTY_CELL:
			return "cell does not contain a player piece"
		INVALID_PIECE:
			return "piece is invalid"
		_:
			return "edit rejected"


static func _rotate_clockwise(direction: Vector2i, quarter_turns: int) -> Vector2i:
	var result := direction
	for _index: int in range(quarter_turns):
		result = Vector2i(-result.y, result.x)
	return result
