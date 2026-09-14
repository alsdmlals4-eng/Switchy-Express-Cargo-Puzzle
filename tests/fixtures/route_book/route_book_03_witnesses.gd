extends RefCounted

# Authored test input only. Converts explicit paths to pieces; never searches.
const Piece := preload("res://game/finite/build/track_piece.gd")
const POSITIVE := {
	&"RB13_FOUR_SIDES": [[1,3],[2,3],[3,3],[4,3],[4,4],[5,4],[6,4],[6,3],[7,3],[8,3],[8,4],[8,5]],
	&"RB14_MANIFEST_MIRROR": [[1,2],[2,2],[3,2],[4,2],[4,3],[4,4],[4,5],[3,5],[3,4],[4,4],[5,4],[6,4],[7,4],[8,4],[9,4],[10,4],[10,5],[10,6],[9,6]],
	&"RB15_MANUAL_GAP": [[1,4],[2,4],[3,4],[4,4],[5,4],[6,4],[7,4],[7,3],[6,3],[5,3],[5,4],[5,5],[6,5],[7,5],[8,5],[9,5],[9,4],[9,3],[10,3],[10,4],[10,5],[10,6],[9,6],[8,6]],
	&"RB16_CAUTION_LEDGER": [[1,5],[2,5],[3,5],[4,5],[5,5],[6,5],[7,5],[7,4],[8,4],[8,3],[9,3],[10,3],[10,4],[10,5],[10,6]],
	&"RB17_CLEARANCE_YARD": [[1,3],[2,3],[3,3],[4,3],[5,3],[6,3],[7,3],[7,2],[8,2],[9,2],[9,3],[9,4],[9,5],[9,6]],
	&"RB18_SWITCHBOARD_NIGHT": [[1,5],[2,5],[3,5],[4,5],[5,5],[6,5],[6,4],[7,4],[8,4],[9,4],[9,3],[8,3],[7,3],[7,4],[7,5],[7,6],[8,6],[9,6],[9,5],[10,5],[10,4],[10,3],[11,3],[12,3],[12,4],[12,5],[12,6],[12,7],[11,7],[10,7]],
}
const NEGATIVE := {
	&"RB13_FOUR_SIDES": [[1,3],[2,3],[3,3],[4,3],[4,4],[5,4],[6,4],[7,4],[7,3],[8,3],[8,4],[8,5]],
	&"RB14_MANIFEST_MIRROR": [[1,2],[2,2],[2,3],[2,4],[3,4],[4,4],[5,4],[6,4],[7,4],[8,4],[9,4],[10,4],[10,5],[10,6],[9,6]],
	&"RB17_CLEARANCE_YARD": [[1,3],[2,3],[2,2],[2,1],[3,1],[4,1],[5,1],[6,1],[6,2],[6,3],[6,4],[5,4],[4,4],[4,3],[3,3],[3,4],[3,5],[4,5],[5,5],[6,5],[7,5],[7,4],[7,3],[7,2],[8,2],[9,2],[9,3],[9,4],[9,5],[9,6]],
}


static func pieces(stage_id: StringName, negative: bool = false) -> Array[Variant]:
	if not POSITIVE.has(stage_id):
		return []
	var path: Array = NEGATIVE[stage_id] if negative and NEGATIVE.has(stage_id) else POSITIVE[stage_id]
	var by_cell: Dictionary = {}
	for index: int in range(1, path.size()):
		var cell := _cell(path[index])
		var incoming := _cell(path[index - 1]) - cell
		var outgoing := _cell(path[index + 1]) - cell if index + 1 < path.size() else -incoming
		assert(absi(incoming.x) + absi(incoming.y) == 1 and absi(outgoing.x) + absi(outgoing.y) == 1, "authored cardinal path")
		var geometry: StringName = &"CURVE"
		var rotation := 0
		if incoming == -outgoing:
			geometry = &"STRAIGHT"
			rotation = 0 if incoming.y == 0 else 1
		else:
			var directions := [Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT]
			for quarter: int in range(4):
				if directions[quarter] in [incoming, outgoing] and directions[(quarter + 1) % 4] in [incoming, outgoing]:
					rotation = quarter
					break
		if by_cell.has(cell):
			assert(by_cell[cell].geometry == &"STRAIGHT" and geometry == &"STRAIGHT" and by_cell[cell].rotation_quarters != rotation, "only authored orthogonal repeat becomes crossing")
			geometry = &"CROSSING"
			rotation = 0
		by_cell[cell] = Piece.create(cell, geometry, rotation, Vector2i.ZERO)
	if stage_id == &"RB16_CAUTION_LEDGER":
		by_cell[Vector2i(7, 5)] = Piece.create(Vector2i(7, 5), &"SWITCH", 0, Vector2i.RIGHT)
		for cell: Vector2i in [Vector2i(8, 5), Vector2i(9, 5)]:
			by_cell[cell] = Piece.create(cell, &"STRAIGHT", 0, Vector2i.ZERO)
	elif stage_id == &"RB18_SWITCHBOARD_NIGHT":
		by_cell[Vector2i(6, 5)] = Piece.create(Vector2i(6, 5), &"SWITCH", 0, Vector2i.RIGHT)
		by_cell[Vector2i(7, 5)] = Piece.create(Vector2i(7, 5), &"CROSSING", 0, Vector2i.ZERO)
		by_cell[Vector2i(8, 5)] = Piece.create(Vector2i(8, 5), &"STRAIGHT", 0, Vector2i.ZERO)
	var result: Array[Variant] = []
	result.assign(by_cell.values())
	return result


static func drive(stage_id: StringName, history: Array, runtime: Variant, negative: bool = false) -> Dictionary:
	var result := {"manual": true, "auto": false, "switch_cell": Vector2i(-1, -1), "desired_exit": Vector2i.ZERO}
	var target: Vector2i = runtime.train.target_cell()
	if stage_id == &"RB15_MANUAL_GAP":
		result.auto = negative
		result.manual = not negative and (target != Vector2i(5, 4) or _visits(history, Vector2i(5, 4)) > 0)
	elif stage_id == &"RB16_CAUTION_LEDGER":
		result.switch_cell = Vector2i(7, 5)
		result.desired_exit = Vector2i.RIGHT if negative else Vector2i.UP
	elif stage_id == &"RB18_SWITCHBOARD_NIGHT":
		result.switch_cell = Vector2i(6, 5)
		result.desired_exit = Vector2i.UP
		var red_visits := _visits(history, Vector2i(7, 4))
		var waste_pair_done := _visits(history, Vector2i(4, 5)) > 0
		result.auto = negative or not waste_pair_done
		result.manual = not negative and (target == Vector2i(8, 4) or (target == Vector2i(7, 4) and red_visits > 0))
	return result


static func _visits(history: Array, cell: Vector2i) -> int:
	var count := 0
	for event: Variant in history:
		if event.cell == cell:
			count += 1
	return count


static func _cell(coordinate: Array) -> Vector2i:
	return Vector2i(int(coordinate[0]), int(coordinate[1]))
