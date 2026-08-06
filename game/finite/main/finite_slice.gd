class_name FiniteSlice
extends Control

signal command_requested(command: StringName, payload: Variant)

const MAP_PATH := "res://data/maps/fp_core_proof_01.json"
const RECOMMENDED_COST := 4500
const BASE_SPEED := 2.0

const SessionControllerScript := preload(
	"res://game/finite/main/finite_slice_session_controller.gd"
)

var _controller: RefCounted

# Legacy test-only compatibility. This getter does not own or copy runtime state.
var _run_session: Variant:
	get:
		return null if _controller == null else _controller.get("_run_session")


func _init() -> void:
	_controller = SessionControllerScript.new()


func _ready() -> void:
	_controller.model_changed.connect(_on_model_changed)
	_connect_view_commands()
	_controller.initialize(MAP_PATH, RECOMMENDED_COST, BASE_SPEED)
	_apply_model(_controller.model())


func _process(delta: float) -> void:
	advance_time(delta)


func session_controller() -> RefCounted:
	return _controller


func phase() -> StringName:
	return _controller.phase()


func presenter_model() -> Dictionary:
	return _controller.model()


func domain_ready() -> bool:
	return _controller.domain_ready()


func current_layout_signature() -> String:
	return _controller.current_layout_signature()


func current_summary() -> Variant:
	return _controller.current_summary()


func delivery_history() -> Array:
	return _controller.delivery_history()


func advance_time(delta_seconds: float) -> void:
	_controller.advance_time(delta_seconds)


func last_command() -> StringName:
	return _controller.last_command()


func last_payload() -> Variant:
	return _controller.last_payload()


func _on_model_changed(model: Dictionary) -> void:
	_apply_model(model)


func _apply_model(model: Dictionary) -> void:
	var view: Node = get_node_or_null("View")
	if view != null and view.has_method("apply_model"):
		view.apply_model(model)


func _connect_view_commands() -> void:
	var view: Node = get_node_or_null("View")
	if view == null:
		return
	view.board_cell_requested.connect(
		func(cell: Vector2i) -> void: _record_command(&"BOARD_CELL", cell)
	)
	view.build_tool_selected.connect(
		func(tool: StringName) -> void: _record_command(&"BUILD_TOOL", tool)
	)
	view.rotate_requested.connect(
		func() -> void: _record_command(&"ROTATE", null)
	)
	view.remove_requested.connect(
		func() -> void: _record_command(&"REMOVE", null)
	)
	view.clear_requested.connect(
		func() -> void: _record_command(&"CLEAR", null)
	)
	view.start_requested.connect(
		func() -> void: _record_command(&"START", null)
	)
	view.load_active_changed.connect(
		func(active: bool) -> void: _record_command(&"LOAD_ACTIVE", active)
	)
	view.auto_toggle_requested.connect(
		func() -> void: _record_command(&"AUTO_TOGGLE", null)
	)
	view.switch_requested.connect(
		func() -> void: _record_command(&"SWITCH", null)
	)
	view.pause_requested.connect(
		func() -> void: _record_command(&"PAUSE", null)
	)
	view.resume_requested.connect(
		func() -> void: _record_command(&"RESUME", null)
	)
	view.retry_requested.connect(
		func() -> void: _record_command(&"RETRY_SAME_LAYOUT", null)
	)
	view.edit_requested.connect(
		func() -> void: _record_command(&"EDIT_LAYOUT", null)
	)


func _record_command(command: StringName, payload: Variant) -> void:
	command_requested.emit(command, payload)
	_controller.request_command(command, payload)
