class_name FiniteSlice
extends Control

signal command_requested(command: StringName, payload: Variant)

const MAP_PATH := "res://data/maps/fp_core_proof_01.json"
const RECOMMENDED_COST := 4500
const BASE_SPEED := 2.0
const NO_CELL := Vector2i(-1, -1)

const PresenterScript := preload("res://game/finite/presentation/finite_slice_presenter.gd")
const MapLoaderScript := preload("res://game/finite/map/finite_map_loader.gd")
const BuildSessionScript := preload("res://game/finite/build/finite_build_session.gd")
const PreflightValidatorScript := preload("res://game/finite/build/preflight_validator.gd")
const TrackPieceScript := preload("res://game/finite/build/track_piece.gd")
const RunSessionFactoryScript := preload("res://game/finite/run/finite_run_session_factory.gd")

var _presenter: Variant
var _definition: Variant
var _build_session: Variant
var _run_factory: Variant
var _run_session: Variant
var _selected_geometry: StringName = &""
var _selected_cell: Vector2i = NO_CELL
var _delivery_history: Array = []
var _last_command: StringName = &""
var _last_payload: Variant


func _init() -> void:
	_presenter = PresenterScript.new()


func _ready() -> void:
	_connect_view_commands()
	_initialize_domain()
	_refresh_view()


func _process(delta: float) -> void:
	advance_time(delta)


func phase() -> StringName:
	return StringName(_presenter.model().get("phase", &"BUILD"))


func presenter_model() -> Dictionary:
	return _presenter.model()


func domain_ready() -> bool:
	return (
		_definition != null
		and _definition.validation_errors().is_empty()
		and _build_session != null
	)


func current_layout_signature() -> String:
	if _build_session != null:
		return _build_session.layout_signature()
	if _run_session != null:
		return _run_session.layout_snapshot().layout_signature()
	return ""


func current_summary() -> Variant:
	if _run_session == null:
		return null
	return _run_session.run_controller.summary()


func delivery_history() -> Array:
	return _delivery_history.duplicate()


func advance_time(delta_seconds: float) -> void:
	if _run_session == null or delta_seconds <= 0.0:
		return
	var state: Variant = _run_session.run_controller.run_state()
	if state == null:
		return
	var active_phase: StringName = state.phase()
	if active_phase == &"READY" or active_phase == &"SUCCESS" or active_phase == &"FAILURE":
		return

	var emitted: Array[StringName] = _run_session.run_controller.advance_time(delta_seconds)
	if not emitted.is_empty():
		apply_unload_emissions(emitted)
	_refresh_run_or_result()


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


func _initialize_domain() -> void:
	_definition = MapLoaderScript.load_from_path(MAP_PATH)
	if _definition == null or not _definition.validation_errors().is_empty():
		_build_session = null
		return
	_build_session = BuildSessionScript.new(_definition)
	_run_factory = null
	_run_session = null
	_selected_geometry = &""
	_selected_cell = NO_CELL
	_delivery_history.clear()
	_refresh_build_state()


func _refresh_build_state() -> void:
	if _definition == null or _build_session == null:
		return
	var preflight: Variant = PreflightValidatorScript.new().validate(
		_definition,
		_build_session.layout_snapshot()
	)
	show_build(preflight, _build_session.current_cost(), RECOMMENDED_COST)


func _refresh_run_or_result() -> void:
	if _run_session == null:
		return
	var summary: Variant = _run_session.run_controller.summary()
	var final_cost: int = _run_session.layout_snapshot().build_cost()
	if summary != null:
		show_result(summary, final_cost)
		return
	show_run(
		_run_session.run_controller.run_state(),
		_run_session.cargo_stack.load_order(),
		_run_session.input_state.is_auto_load_enabled(),
		final_cost
	)


func _refresh_view() -> void:
	var view: Node = get_node_or_null("View")
	if view != null and view.has_method("apply_model"):
		view.apply_model(_presenter.model())


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
	_last_command = command
	_last_payload = payload
	command_requested.emit(command, payload)
	_dispatch_command(command, payload)


func _dispatch_command(command: StringName, payload: Variant) -> void:
	match command:
		&"BUILD_TOOL":
			_selected_geometry = StringName(payload)
		&"BOARD_CELL":
			_handle_board_cell(payload)
		&"ROTATE":
			_handle_rotate()
		&"REMOVE":
			_handle_remove()
		&"CLEAR":
			_handle_clear()
		&"START":
			_handle_start()
		&"LOAD_ACTIVE":
			_handle_load_active(bool(payload))
		&"AUTO_TOGGLE":
			_handle_auto_toggle()
		&"SWITCH":
			_handle_switch()
		&"PAUSE":
			_handle_pause()
		&"RESUME":
			_handle_resume()
		&"RETRY_SAME_LAYOUT":
			_handle_retry()
		&"EDIT_LAYOUT":
			_handle_edit_layout()


func _handle_board_cell(cell: Vector2i) -> void:
	_selected_cell = cell
	if phase() != &"BUILD" or _build_session == null or _selected_geometry == &"":
		return
	var piece: Variant = TrackPieceScript.create(
		cell,
		_selected_geometry,
		0,
		Vector2i.RIGHT if _selected_geometry == &"SWITCH" else Vector2i.ZERO
	)
	var layout: Variant = _build_session.layout_snapshot()
	if layout.piece_at(cell) != null:
		_build_session.replace_piece(piece)
	else:
		_build_session.place_piece(piece)
	_refresh_build_state()


func _handle_rotate() -> void:
	if phase() != &"BUILD" or _build_session == null or _selected_cell == NO_CELL:
		return
	_build_session.rotate_piece(_selected_cell, 1)
	_refresh_build_state()


func _handle_remove() -> void:
	if phase() != &"BUILD" or _build_session == null or _selected_cell == NO_CELL:
		return
	_build_session.remove_piece(_selected_cell)
	_refresh_build_state()


func _handle_clear() -> void:
	if phase() != &"BUILD" or _build_session == null:
		return
	_build_session.clear_layout()
	_selected_cell = NO_CELL
	_refresh_build_state()


func _handle_start() -> void:
	if phase() != &"BUILD" or _build_session == null:
		return
	var preflight: Variant = _build_session.begin_run()
	if preflight == null or not preflight.passed:
		_refresh_build_state()
		return
	_run_factory = RunSessionFactoryScript.new()
	if not _run_factory.configure(_definition, _build_session.sealed_snapshot(), BASE_SPEED):
		return
	var result: Dictionary = _run_factory.create_attempt(1)
	if not bool(result.get("success", false)):
		return
	_activate_run_session(result["session"])


func _activate_run_session(session: Variant) -> void:
	_run_session = session
	_delivery_history.clear()
	_run_session.delivery_loop.delivery_event_created.connect(_on_delivery_event_created)
	_run_session.run_controller.start()
	_refresh_run_or_result()


func _handle_load_active(active: bool) -> void:
	if _run_session == null:
		return
	_run_session.input_state.set_manual_load_active(active)
	_refresh_run_or_result()


func _handle_auto_toggle() -> void:
	if _run_session == null:
		return
	_run_session.input_state.toggle_auto_load()
	_refresh_run_or_result()


func _handle_switch() -> void:
	if _run_session == null or _selected_cell == NO_CELL:
		return
	if _run_session.graph.switch_cells().has(_selected_cell):
		_run_session.graph.cycle_switch(_selected_cell)
	_refresh_run_or_result()


func _handle_pause() -> void:
	if _run_session == null:
		return
	_run_session.run_controller.pause()
	_refresh_run_or_result()


func _handle_resume() -> void:
	if _run_session == null:
		return
	_run_session.run_controller.resume()
	_refresh_run_or_result()


func _handle_retry() -> void:
	if _run_factory == null or _run_session == null:
		return
	var result: Dictionary = _run_factory.retry(_run_session)
	if bool(result.get("success", false)):
		_activate_run_session(result["session"])


func _handle_edit_layout() -> void:
	if _run_session == null or _definition == null:
		return
	var preserved_layout: Variant = _run_session.layout_snapshot()
	_build_session = BuildSessionScript.new(_definition)
	for piece: Variant in preserved_layout.pieces():
		_build_session.place_piece(piece)
	_run_session = null
	_run_factory = null
	_delivery_history.clear()
	_refresh_build_state()


func _on_delivery_event_created(event: Variant) -> void:
	_delivery_history.append(event)
	if event == null or int(event.unload_count) <= 0 or _run_session == null:
		return
	var stack_before: Array[StringName] = _run_session.cargo_stack.load_order()
	var unloaded_items: Array[StringName] = event.unloaded_items
	var restored_top: Array[StringName] = unloaded_items.duplicate()
	restored_top.reverse()
	stack_before.append_array(restored_top)
	begin_unload_visual(stack_before, unloaded_items)
