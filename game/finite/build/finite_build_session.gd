class_name FiniteBuildSession
extends RefCounted

const TrackLayoutScript := preload("res://game/finite/build/track_layout.gd")
const TrackLayoutEditorScript := preload("res://game/finite/build/track_layout_editor.gd")
const TrackEditResultScript := preload("res://game/finite/build/track_edit_result.gd")
const PreflightValidatorScript := preload("res://game/finite/build/preflight_validator.gd")

const BUILD: StringName = &"BUILD"
const RUN: StringName = &"RUN"
const PHASE_LOCKED: StringName = &"PHASE_LOCKED"

var _definition: Variant
var _layout: Variant
var _editor: Variant
var _validator: Variant
var _phase: StringName = BUILD
var _sealed: Dictionary = {}


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
	return _editor.place_piece(piece)


func rotate_piece(cell: Vector2i, delta_quarters: int) -> Variant:
	if _phase != BUILD:
		return _phase_locked([cell])
	return _editor.rotate_piece(cell, delta_quarters)


func replace_piece(piece: Variant) -> Variant:
	if _phase != BUILD:
		return _phase_locked(_piece_cells(piece))
	return _editor.replace_piece(piece)


func remove_piece(cell: Vector2i) -> Variant:
	if _phase != BUILD:
		return _phase_locked([cell])
	return _editor.remove_piece(cell)


func clear_layout() -> Variant:
	if _phase != BUILD:
		return _phase_locked(_layout_cells())
	return _editor.clear_layout()


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
	return _sealed.duplicate(false)


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
