class_name FiniteTrackGraphBuilder
extends RefCounted

const TrackPieceScript := preload("res://game/finite/build/track_piece.gd")
const FiniteTrackGraphScript := preload("res://game/finite/rail/finite_track_graph.gd")


static func build(definition: Variant, layout: Variant) -> Variant:
	if definition == null or layout == null:
		return null
	if not definition.validation_errors().is_empty():
		return null

	var pieces_by_cell: Dictionary = {}
	if not _put_fixed_piece(
		pieces_by_cell,
		TrackPieceScript.create(definition.incoming_cell, &"STRAIGHT", 0, Vector2i.ZERO)
	):
		return null
	if not _put_fixed_piece(
		pieces_by_cell,
		TrackPieceScript.create(definition.start_cell, &"STRAIGHT", 0, Vector2i.ZERO)
	):
		return null

	for placement: Dictionary in definition.station_placements:
		if not _put_authored_anchor(pieces_by_cell, placement):
			return null
	for placement: Dictionary in definition.cargo_placements:
		if not _put_authored_anchor(pieces_by_cell, placement):
			return null
	for piece: Variant in layout.pieces():
		if not _put_fixed_piece(pieces_by_cell, piece):
			return null

	var pieces: Array[Variant] = []
	for piece: Variant in pieces_by_cell.values():
		pieces.append(piece)
	return FiniteTrackGraphScript.new(pieces)


static func _put_authored_anchor(pieces_by_cell: Dictionary, placement: Dictionary) -> bool:
	var anchor: Variant = placement.get("rail_anchor", null)
	if not anchor is Dictionary:
		return false
	var cell := _read_cell(placement.get("cell", []))
	var geometry := StringName(anchor.get("geometry", &""))
	var rotation := int(anchor.get("rotation_quarters", -1))
	var initial_exit := Vector2i.ZERO
	if geometry == &"SWITCH":
		initial_exit = _rotate_clockwise(Vector2i.RIGHT, rotation)
	return _put_fixed_piece(
		pieces_by_cell,
		TrackPieceScript.create(cell, geometry, rotation, initial_exit)
	)


static func _put_fixed_piece(pieces_by_cell: Dictionary, piece: Variant) -> bool:
	if piece == null or pieces_by_cell.has(piece.cell):
		return false
	pieces_by_cell[piece.cell] = piece.duplicate_piece()
	return true


static func _read_cell(raw: Variant) -> Vector2i:
	if raw is Vector2i:
		return raw
	if raw is Array and raw.size() == 2:
		return Vector2i(int(raw[0]), int(raw[1]))
	if raw is Dictionary and raw.has("x") and raw.has("y"):
		return Vector2i(int(raw.get("x", 0)), int(raw.get("y", 0)))
	return Vector2i.ZERO


static func _rotate_clockwise(direction: Vector2i, quarter_turns: int) -> Vector2i:
	var result := direction
	for _index: int in range(quarter_turns):
		result = Vector2i(-result.y, result.x)
	return result
