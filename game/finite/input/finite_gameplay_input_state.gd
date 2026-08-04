class_name FiniteGameplayInputState
extends RefCounted

var _manual_load_active: bool = false
var _auto_load_enabled: bool = false
var _paused: bool = false


func is_manual_load_active() -> bool:
	return _manual_load_active


func is_auto_load_enabled() -> bool:
	return _auto_load_enabled


func is_paused() -> bool:
	return _paused


func should_load_on_contact() -> bool:
	return not _paused and (_auto_load_enabled or _manual_load_active)


func set_manual_load_active(active: bool) -> bool:
	if _paused:
		return false
	_manual_load_active = active
	return true


func toggle_auto_load() -> bool:
	if _paused:
		return false
	_auto_load_enabled = not _auto_load_enabled
	return true


func set_paused(paused: bool) -> void:
	_paused = paused
	if _paused:
		_manual_load_active = false


func reset() -> void:
	_manual_load_active = false
	_auto_load_enabled = false
	_paused = false
