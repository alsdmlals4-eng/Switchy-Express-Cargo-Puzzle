class_name TrackLayout
extends RefCounted

const SELF_SCRIPT_PATH := "res://game/finite/build/track_layout.gd"

var _pieces_by_cell: Dictionary = {}


func put_piece(piece: Variant) -> bool:
	if piece == null:
		return false
	if not piece.has_method("duplicate_piece") or not piece.has_method("build_cost"):
		return false
	var copy: Variant = piece.duplicate_piece()
	if copy == null:
		return false
	_pieces_by_cell[copy.cell] = copy
	return true


func remove_piece(cell: Vector2i) -> bool:
	if not _pieces_by_cell.has(cell):
		return false
	_pieces_by_cell.erase(cell)
	return true


func piece_at(cell: Vector2i) -> Variant:
	if not _pieces_by_cell.has(cell):
		return null
	return _pieces_by_cell[cell].duplicate_piece()


func pieces() -> Array[Variant]:
	var result: Array[Variant] = []
	for piece: Variant in _sorted_pieces():
		result.append(piece.duplicate_piece())
	return result


func build_cost() -> int:
	var result := 0
	for piece: Variant in _pieces_by_cell.values():
		result += piece.build_cost()
	return result


func canonical_string() -> String:
	var lines: PackedStringArray = []
	for piece: Variant in _sorted_pieces():
		lines.append(piece.canonical_string())
	return "\n".join(lines)


func layout_signature() -> String:
	var hashing_context := HashingContext.new()
	var start_error := hashing_context.start(HashingContext.HASH_SHA256)
	if start_error != OK:
		return ""
	var update_error := hashing_context.update(canonical_string().to_utf8_buffer())
	if update_error != OK:
		return ""
	return hashing_context.finish().hex_encode()


func duplicate_layout() -> Variant:
	var result: Variant = load(SELF_SCRIPT_PATH).new()
	for piece: Variant in _pieces_by_cell.values():
		result.put_piece(piece)
	return result


func clear() -> void:
	_pieces_by_cell.clear()


func _sorted_pieces() -> Array[Variant]:
	var result: Array[Variant] = []
	for piece: Variant in _pieces_by_cell.values():
		result.append(piece)
	result.sort_custom(_piece_precedes)
	return result


static func _piece_precedes(first: Variant, second: Variant) -> bool:
	if first.cell.y != second.cell.y:
		return first.cell.y < second.cell.y
	if first.cell.x != second.cell.x:
		return first.cell.x < second.cell.x
	return str(first.geometry) < str(second.geometry)
