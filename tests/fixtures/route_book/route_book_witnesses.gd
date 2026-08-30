extends RefCounted

const PieceScript := preload("res://game/finite/build/track_piece.gd")


static func pieces(stage_id: StringName) -> Array[Variant]:
	match stage_id:
		&"RB01_SERVICE_SIDINGS":
			return _rb01()
		&"RB02_REVERSE_ORDER":
			return _rb02()
		&"RB03_RETURN_MANIFEST":
			return _rb03()
		&"RB04_LOAD_WINDOW":
			return _rb04()
		&"RB05_FORK_LOCK":
			return _rb05()
		&"RB06_PORT_CIRCUIT":
			return _rb06()
		&"RB07_FOREST_RELAY", &"RB09_SALVAGE_SIDING":
			return _rb01()
		&"RB08_CAUTION_CUT":
			return _rb02()
		&"RB10_CLEAN_BREAK":
			return _rb03()
		&"RB11_TURNOUT_UNDER_LOAD":
			return _rb05()
		&"RB12_LANTERN_LOOP":
			return _rb06()
	return []


static func _rb01() -> Array[Variant]:
	return [
		_piece(2, 3, &"STRAIGHT", 0),
		_piece(3, 3, &"STRAIGHT", 0),
		_piece(4, 3, &"CURVE", 2),
		_piece(4, 4, &"CURVE", 0),
		_piece(5, 4, &"CURVE", 3),
		_piece(5, 3, &"CURVE", 1),
		_piece(6, 3, &"STRAIGHT", 0),
		_piece(7, 3, &"CURVE", 2),
		_piece(7, 4, &"STRAIGHT", 1),
	]


static func _rb02() -> Array[Variant]:
	return [
		_piece(2, 3, &"STRAIGHT", 0),
		_piece(3, 3, &"STRAIGHT", 0),
		_piece(4, 3, &"STRAIGHT", 0),
		_piece(5, 3, &"STRAIGHT", 0),
		_piece(6, 3, &"CURVE", 3),
		_piece(6, 2, &"CURVE", 1),
		_piece(7, 2, &"STRAIGHT", 0),
		_piece(8, 2, &"CURVE", 2),
		_piece(8, 3, &"STRAIGHT", 1),
		_piece(8, 4, &"CURVE", 0),
		_piece(9, 4, &"STRAIGHT", 0),
	]


static func _rb03() -> Array[Variant]:
	return [
		_piece(2, 4, &"STRAIGHT", 0),
		_piece(3, 4, &"STRAIGHT", 0),
		_piece(4, 4, &"STRAIGHT", 0),
		_piece(5, 4, &"CROSSING", 0),
		_piece(6, 4, &"STRAIGHT", 0),
		_piece(7, 4, &"CURVE", 3),
		_piece(7, 3, &"STRAIGHT", 1),
		_piece(7, 2, &"CURVE", 2),
		_piece(6, 2, &"STRAIGHT", 0),
		_piece(5, 2, &"CURVE", 1),
		_piece(5, 3, &"STRAIGHT", 1),
		_piece(5, 5, &"STRAIGHT", 1),
		_piece(5, 6, &"CURVE", 0),
		_piece(6, 6, &"CURVE", 2),
		_piece(6, 7, &"STRAIGHT", 1),
	]


static func _rb04() -> Array[Variant]:
	return [
		_piece(2, 4, &"STRAIGHT", 0),
		_piece(3, 4, &"STRAIGHT", 0),
		_piece(4, 4, &"STRAIGHT", 0),
		_piece(5, 4, &"STRAIGHT", 0),
		_piece(6, 4, &"CROSSING", 0),
		_piece(7, 4, &"STRAIGHT", 0),
		_piece(8, 4, &"CURVE", 3),
		_piece(8, 3, &"STRAIGHT", 1),
		_piece(8, 2, &"CURVE", 2),
		_piece(7, 2, &"STRAIGHT", 0),
		_piece(6, 2, &"CURVE", 1),
		_piece(6, 3, &"STRAIGHT", 1),
		_piece(6, 5, &"STRAIGHT", 1),
		_piece(6, 6, &"CURVE", 0),
		_piece(7, 6, &"STRAIGHT", 0),
		_piece(8, 6, &"CURVE", 2),
		_piece(8, 7, &"STRAIGHT", 1),
	]


static func _rb05() -> Array[Variant]:
	return [
		_piece(2, 4, &"STRAIGHT", 0),
		_piece(3, 4, &"STRAIGHT", 0),
		_piece(4, 4, &"STRAIGHT", 0),
		_piece(5, 4, &"STRAIGHT", 0),
		_piece(6, 4, &"SWITCH", 0, Vector2i.UP),
		_piece(7, 4, &"CURVE", 3),
		_piece(7, 3, &"STRAIGHT", 1),
		_piece(7, 2, &"CURVE", 1),
		_piece(8, 2, &"STRAIGHT", 0),
		_piece(9, 2, &"STRAIGHT", 0),
		_piece(10, 2, &"CURVE", 2),
		_piece(10, 3, &"STRAIGHT", 1),
		_piece(10, 4, &"STRAIGHT", 1),
		_piece(10, 5, &"STRAIGHT", 1),
		_piece(10, 6, &"STRAIGHT", 1),
		_piece(6, 3, &"STRAIGHT", 1),
		_piece(6, 2, &"CURVE", 2),
		_piece(5, 2, &"STRAIGHT", 0),
	]


static func _rb06() -> Array[Variant]:
	return [
		_piece(2, 5, &"STRAIGHT", 0),
		_piece(3, 5, &"STRAIGHT", 0),
		_piece(4, 5, &"STRAIGHT", 0),
		_piece(5, 5, &"STRAIGHT", 0),
		_piece(6, 5, &"SWITCH", 0, Vector2i.RIGHT),
		_piece(6, 4, &"CURVE", 1),
		_piece(7, 4, &"STRAIGHT", 0),
		_piece(8, 4, &"STRAIGHT", 0),
		_piece(9, 4, &"CURVE", 2),
		_piece(9, 5, &"STRAIGHT", 1),
		_piece(9, 6, &"STRAIGHT", 1),
		_piece(9, 7, &"CURVE", 0),
		_piece(10, 7, &"CURVE", 3),
		_piece(10, 6, &"STRAIGHT", 1),
		_piece(10, 5, &"STRAIGHT", 1),
		_piece(10, 4, &"CURVE", 1),
		_piece(11, 4, &"CROSSING", 0),
		_piece(12, 4, &"CURVE", 3),
		_piece(12, 3, &"CURVE", 2),
		_piece(11, 3, &"CURVE", 1),
		_piece(11, 5, &"STRAIGHT", 1),
		_piece(11, 6, &"STRAIGHT", 1),
		_piece(11, 7, &"STRAIGHT", 1),
		_piece(11, 8, &"STRAIGHT", 1),
		_piece(7, 5, &"STRAIGHT", 0),
		_piece(8, 5, &"STRAIGHT", 0),
	]


static func _piece(
	x: int,
	y: int,
	geometry: StringName,
	rotation: int,
	switch_exit: Vector2i = Vector2i.ZERO
) -> Variant:
	return PieceScript.create(Vector2i(x, y), geometry, rotation, switch_exit)
