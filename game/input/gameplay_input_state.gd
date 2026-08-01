class_name GameplayInputState
extends RefCounted

var _load_requested: bool = false
var _boost_requested: bool = false


func set_load_requested(requested: bool) -> void:
	_load_requested = requested


func set_boost_requested(requested: bool) -> void:
	_boost_requested = requested


func is_loading() -> bool:
	return _load_requested and not _boost_requested


func is_boosting() -> bool:
	return _boost_requested


func clear() -> void:
	_load_requested = false
	_boost_requested = false
