class_name FiniteSlice
extends Control

signal command_requested(command: StringName, payload: Variant)

const PresenterScript := preload("res://game/finite/presentation/finite_slice_presenter.gd")

var _presenter: Variant
var _last_command: StringName = &""
var _last_payload: Variant


func _init() -> void:
	_presenter = PresenterScript.new()


func _ready() -> void:
	_connect_view_commands()
	_refresh_view()


func phase() -> StringName:
	return StringName(_presenter.model().get("phase", &"BUILD"))


func presenter_model() -> Dictionary:
	return _presenter.model()


func last_command() -> StringName:
	return _last_command


func last_payload() -> Variant:
	return _last_payload


func show_build(preflight: Variant, current_cost: int, recommended_cost: int) -> void:
	_presenter.show_build(preflight, current_cost, recommended_cost)
	_refresh_view()


func show_run(
	run_state: Variant,
	load_order: Array[StringName],
	auto_load_active: bool,
	final_cost: int
) -> void:
	_presenter.show_run(run_state, load_order, auto_load_active, final_cost)
	_refresh_view()


func begin_unload_visual(
	stack_before: Array[StringName],
	unloaded_items: Array[StringName]
) -> void:
	_presenter.begin_unload_visual(stack_before, unloaded_items)
	_refresh_view()


func apply_unload_emissions(emitted_items: Array[StringName]) -> void:
	_presenter.apply_unload_emissions(emitted_items)
	_refresh_view()


func show_result(summary: Variant, final_cost: int) -> void:
	_presenter.show_result(summary, final_cost)
	_refresh_view()


func _refresh_view() -> void:
	var view: Node = get_node_or_null("View")
	if view != null and view.has_method("apply_model"):
		view.apply_model(_presenter.model())


func _connect_view_commands() -> void:
	var view: Node = get_node_or_null("View")
	if view == null:
		return
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
	_last_command = command
	_last_payload = payload
	command_requested.emit(command, payload)
