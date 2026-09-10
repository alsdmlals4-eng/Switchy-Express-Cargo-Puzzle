class_name CargoPickupAnimation
extends RefCounted

const DURATION := 0.24
const FRAME_DURATION := 0.06

var cell := Vector2i(-1, -1)
var reduced_motion := false
var _elapsed := DURATION


func start(pickup_cell: Vector2i, cargo_type: StringName) -> bool:
	if cargo_type != &"BLUE_DIAMOND" or pickup_cell.x < 0 or pickup_cell.y < 0:
		return false
	cell = pickup_cell
	_elapsed = 0.0
	return true


func advance(delta: float) -> void:
	_elapsed = minf(DURATION, _elapsed + maxf(0.0, delta))


func frame_index() -> int:
	if _elapsed >= DURATION:
		return -1
	return 0 if reduced_motion else mini(3, int(_elapsed / FRAME_DURATION))


func opacity() -> float:
	return clampf((DURATION - _elapsed) / (DURATION if reduced_motion else FRAME_DURATION), 0.0, 1.0)


func cancel() -> void:
	_elapsed = DURATION
	cell = Vector2i(-1, -1)
