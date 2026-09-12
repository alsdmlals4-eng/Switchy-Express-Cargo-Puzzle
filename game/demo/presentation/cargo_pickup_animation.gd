class_name CargoPickupAnimation
extends RefCounted

const CargoTypeScript := preload("res://game/cargo/cargo_type.gd")
const DURATION := 0.24
const LIFT_HEIGHT_RATIO := 0.16

var cell := Vector2i(-1, -1)
var reduced_motion := false
var _elapsed := DURATION
var _cargo_type: StringName = &""


func start(pickup_cell: Vector2i, cargo_type: StringName) -> bool:
	if not CargoTypeScript.is_valid(cargo_type) or pickup_cell.x < 0 or pickup_cell.y < 0:
		cancel()
		return false
	cell = pickup_cell
	_cargo_type = cargo_type
	_elapsed = 0.0
	return true


func texture_key() -> String:
	match _cargo_type:
		CargoTypeScript.RED_STAR:
			return "cargo_red"
		CargoTypeScript.BLUE_DIAMOND:
			return "cargo_blue"
		CargoTypeScript.YELLOW_TRIANGLE:
			return "cargo_yellow"
		CargoTypeScript.WASTE_CRATE:
			return "cargo_waste"
		_:
			return ""


func advance(delta: float) -> void:
	_elapsed = minf(DURATION, _elapsed + maxf(0.0, delta))


func is_active() -> bool:
	return _elapsed < DURATION


func offset() -> Vector2:
	if not is_active() or reduced_motion:
		return Vector2.ZERO
	var progress := clampf(_elapsed / DURATION, 0.0, 1.0)
	return Vector2(0.0, -sin(progress * PI) * LIFT_HEIGHT_RATIO)


func opacity() -> float:
	if not is_active():
		return 0.0
	var progress := clampf(_elapsed / DURATION, 0.0, 1.0)
	return 1.0 - progress


func cancel() -> void:
	_elapsed = DURATION
	cell = Vector2i(-1, -1)
	_cargo_type = &""
