class_name FiniteTrackCrossing
extends RefCounted

const MODE_TURNS: Array[int] = [0, 1, 3]
const MODE_NAMES: Array[StringName] = [&"STRAIGHT", &"RIGHT", &"LEFT"]

var _mode_index: int = 0


func outgoing_for(incoming_port: Vector2i) -> Vector2i:
	if incoming_port == Vector2i.ZERO:
		return Vector2i.ZERO
	return _rotate_clockwise(-incoming_port, MODE_TURNS[_mode_index])


func cycle() -> bool:
	_mode_index = (_mode_index + 1) % MODE_TURNS.size()
	return true


func mode() -> StringName:
	return MODE_NAMES[_mode_index]


func reset() -> void:
	_mode_index = 0


static func _rotate_clockwise(direction: Vector2i, quarter_turns: int) -> Vector2i:
	var result := direction
	for _index: int in range(posmod(quarter_turns, 4)):
		result = Vector2i(-result.y, result.x)
	return result
