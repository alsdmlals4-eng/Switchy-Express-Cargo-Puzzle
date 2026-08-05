class_name FiniteValidationLauncher
extends Control

const MODE_PROOF: StringName = &"PROOF"
const MODE_STACK_8: StringName = &"STACK_8"
const MODE_STACK_16: StringName = &"STACK_16"
const MODE_STACK_32: StringName = &"STACK_32"
const ERROR_INVALID_MODE: StringName = &"INVALID_MODE"
const ERROR_MISSING_SCENE: StringName = &"MISSING_SCENE"
const PROOF_SCENE_PATH := "res://game/finite/main/finite_slice.tscn"
const VIEW_SCENE_PATH := "res://game/finite/presentation/finite_slice_view.tscn"

const PresenterScript := preload("res://game/finite/presentation/finite_slice_presenter.gd")
const RunStateFixtureScript := preload("res://tools/validation/finite/validation_run_state_fixture.gd")

var _active_mode: StringName = &""
var _active_scene_path := ""
var _stack_fixture_size := 0
var _last_error: StringName = &""
var _mounted_child: Node


func _ready() -> void:
	configure_mode(mode_from_user_args(OS.get_cmdline_user_args()))


static func mode_from_user_args(args: PackedStringArray) -> StringName:
	for argument: String in args:
		if not argument.begins_with("--validation-mode="):
			continue
		var value := argument.trim_prefix("--validation-mode=").to_lower()
		match value:
			"proof":
				return MODE_PROOF
			"stack8":
				return MODE_STACK_8
			"stack16":
				return MODE_STACK_16
			"stack32":
				return MODE_STACK_32
	return MODE_PROOF


func configure_mode(mode: StringName) -> bool:
	_clear_mounted_child()
	_active_mode = &""
	_active_scene_path = ""
	_stack_fixture_size = 0
	_last_error = &""

	match mode:
		MODE_PROOF:
			if not _mount_proof():
				return false
		MODE_STACK_8:
			if not _mount_stack(8):
				return false
		MODE_STACK_16:
			if not _mount_stack(16):
				return false
		MODE_STACK_32:
			if not _mount_stack(32):
				return false
		_:
			_last_error = ERROR_INVALID_MODE
			return false

	_active_mode = mode
	return true


func active_mode() -> StringName:
	return _active_mode


func active_scene_path() -> String:
	return _active_scene_path


func stack_fixture_size() -> int:
	return _stack_fixture_size


func last_error() -> StringName:
	return _last_error


func mounted_child() -> Node:
	return _mounted_child


func _mount_proof() -> bool:
	var child := _instantiate_scene(PROOF_SCENE_PATH)
	if child == null:
		return false
	_get_mount().add_child(child)
	_mounted_child = child
	_active_scene_path = PROOF_SCENE_PATH
	return true


func _mount_stack(size: int) -> bool:
	if not [8, 16, 32].has(size):
		_last_error = ERROR_INVALID_MODE
		return false
	var child := _instantiate_scene(VIEW_SCENE_PATH)
	if child == null:
		return false
	_get_mount().add_child(child)
	var presenter: Variant = PresenterScript.new()
	presenter.show_run(RunStateFixtureScript.new(), _fixture_load_order(size), false, 0)
	child.apply_model(presenter.model())
	_mounted_child = child
	_active_scene_path = VIEW_SCENE_PATH
	_stack_fixture_size = size
	return true


func _instantiate_scene(path: String) -> Node:
	if not ResourceLoader.exists(path, "PackedScene"):
		_last_error = ERROR_MISSING_SCENE
		return null
	var packed := load(path) as PackedScene
	if packed == null:
		_last_error = ERROR_MISSING_SCENE
		return null
	var child := packed.instantiate()
	if child == null:
		_last_error = ERROR_MISSING_SCENE
		return null
	return child


func _fixture_load_order(size: int) -> Array[StringName]:
	var cargo_types: Array[StringName] = [
		&"RED_STAR",
		&"BLUE_DIAMOND",
		&"YELLOW_TRIANGLE",
	]
	var result: Array[StringName] = []
	for index: int in range(size):
		result.append(cargo_types[index % cargo_types.size()])
	return result


func _clear_mounted_child() -> void:
	if _mounted_child == null or not is_instance_valid(_mounted_child):
		_mounted_child = null
		return
	var parent := _mounted_child.get_parent()
	if parent != null:
		parent.remove_child(_mounted_child)
	_mounted_child.free()
	_mounted_child = null


func _get_mount() -> Control:
	return get_node("Mount") as Control
