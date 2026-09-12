class_name FiniteBuildSession
extends RefCounted

const TrackLayoutScript := preload("res://game/finite/build/track_layout.gd")
const TrackLayoutEditorScript := preload("res://game/finite/build/track_layout_editor.gd")
const TrackEditResultScript := preload("res://game/finite/build/track_edit_result.gd")
const PreflightValidatorScript := preload("res://game/finite/build/preflight_validator.gd")

const BUILD: StringName = &"BUILD"
const RUN: StringName = &"RUN"
const PHASE_LOCKED: StringName = &"PHASE_LOCKED"
const HISTORY_LIMIT := 128

var _definition: Variant
var _layout: Variant
var _editor: Variant
var _validator: Variant
var _phase: StringName = BUILD
var _sealed: Dictionary = {}
var _undo: Array = []
var _redo: Array = []


func _init(definition: Variant = null) -> void:
	_definition = definition
	_layout = TrackLayoutScript.new()
	_editor = TrackLayoutEditorScript.new(_definition, _layout)
	_validator = PreflightValidatorScript.new()


func phase() -> StringName:
	return _phase


func current_cost() -> int:
	return _layout.build_cost()


func layout_signature() -> String:
	return _layout.layout_signature()


func layout_snapshot() -> Variant:
	return _layout.duplicate_layout()


func place_piece(piece: Variant) -> Variant:
	if _phase != BUILD:
		return _phase_locked([])
	var before: Variant = _layout.duplicate_layout()
	return _record_edit(before, _editor.place_piece(piece))


func rotate_piece(cell: Vector2i, delta_quarters: int) -> Variant:
	if _phase != BUILD:
		return _phase_locked([cell])
	var before: Variant = _layout.duplicate_layout()
	return _record_edit(before, _editor.rotate_piece(cell, delta_quarters))


func replace_piece(piece: Variant) -> Variant:
	if _phase != BUILD:
		return _phase_locked(_piece_cells(piece))
	var before: Variant = _layout.duplicate_layout()
	return _record_edit(before, _editor.replace_piece(piece))


func remove_piece(cell: Vector2i) -> Variant:
	if _phase != BUILD:
		return _phase_locked([cell])
	var before: Variant = _layout.duplicate_layout()
	return _record_edit(before, _editor.remove_piece(cell))


func clear_layout() -> Variant:
	if _phase != BUILD:
		return _phase_locked(_layout_cells())
	var before: Variant = _layout.duplicate_layout()
	return _record_edit(before, _editor.clear_layout())


func can_undo() -> bool:
	return _phase == BUILD and not _undo.is_empty()


func can_redo() -> bool:
	return _phase == BUILD and not _redo.is_empty()


func undo_edit() -> Variant:
	return _restore_history(_undo, _redo)


func redo_edit() -> Variant:
	return _restore_history(_redo, _undo)


func reset_edit_history() -> void:
	_undo.clear()
	_redo.clear()


func replace_layout(pieces: Array) -> Variant:
	if _phase != BUILD:
		return _phase_locked([])
	var candidate: Variant = TrackLayoutScript.new()
	var candidate_editor: Variant = TrackLayoutEditorScript.new(_definition, candidate)
	for piece: Variant in pieces:
		var result: Variant = candidate_editor.place_piece(piece)
		if not result.success:
			return TrackEditResultScript.new(false, result.code, result.message, result.affected_cells, current_cost(), current_cost())
	var before: Variant = _layout.duplicate_layout()
	var cells: Array[Vector2i] = _layout_cells()
	_layout = candidate
	_editor = candidate_editor
	for cell: Vector2i in _layout_cells():
		if not cells.has(cell):
			cells.append(cell)
	return _record_edit(before, TrackEditResultScript.new(true, &"PASS", "layout replaced", cells, before.build_cost(), current_cost()))


func _record_edit(before: Variant, result: Variant) -> Variant:
	if result.success and before.layout_signature() != _layout.layout_signature():
		_undo.append(before)
		if _undo.size() > HISTORY_LIMIT:
			_undo.pop_front()
		_redo.clear()
	return result


func _restore_history(source: Array, destination: Array) -> Variant:
	if _phase != BUILD:
		return _phase_locked([])
	var cost := current_cost()
	if source.is_empty():
		return TrackEditResultScript.new(false, &"HISTORY_EMPTY", "no edit history", [], cost, cost)
	var cells: Array[Vector2i] = _layout_cells()
	destination.append(_layout.duplicate_layout())
	_layout = source.pop_back().duplicate_layout()
	_editor = TrackLayoutEditorScript.new(_definition, _layout)
	for cell: Vector2i in _layout_cells():
		if not cells.has(cell):
			cells.append(cell)
	return TrackEditResultScript.new(true, &"PASS", "layout restored", cells, cost, current_cost())


func begin_run() -> Variant:
	if _phase != BUILD:
		return _phase_locked([])
	var result: Variant = _validator.validate(_definition, _layout)
	if result == null or not result.passed:
		return result

	var sealed_layout: Variant = _layout.duplicate_layout()
	_sealed = {
		"definition_identity": _definition.identity_key(),
		"definition_schema_version": _definition.definition_schema_version,
		"ruleset_version": str(_definition.ruleset_version),
		"layout_signature": sealed_layout.layout_signature(),
		"construction_cost": sealed_layout.build_cost(),
		"layout": sealed_layout,
		"graph": result.graph,
	}
	_phase = RUN
	return result


func sealed_snapshot() -> Dictionary:
	var result: Dictionary = _sealed.duplicate(false)
	if result.has("layout") and result["layout"] != null:
		result["layout"] = result["layout"].duplicate_layout()
	return result


func _phase_locked(affected_cells: Array[Vector2i]) -> Variant:
	var cost := current_cost()
	return TrackEditResultScript.new(
		false,
		PHASE_LOCKED,
		"track layout is sealed for runtime",
		affected_cells,
		cost,
		cost
	)


func _layout_cells() -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for piece: Variant in _layout.pieces():
		result.append(piece.cell)
	return result


static func _piece_cells(piece: Variant) -> Array[Vector2i]:
	if piece == null or not piece is RefCounted:
		return []
	if not "cell" in piece:
		return []
	return [piece.cell]
