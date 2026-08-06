class_name FiniteSliceSessionController
extends RefCounted

signal model_changed(model: Dictionary)
signal render_snapshot_changed(snapshot: Dictionary)
signal delivery_event_created(event: Variant)
signal terminal_reached(summary: Variant)

const DEFAULT_RECOMMENDED_COST := 4500
const DEFAULT_BASE_SPEED := 2.0
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
var _selected_rotation_quarters: int = 0
var _selected_cell: Vector2i = NO_CELL
var _delivery_history: Array = []
var _last_command: StringName = &""
var _last_payload: Variant
var _recommended_cost: int = DEFAULT_RECOMMENDED_COST
var _base_speed: float = DEFAULT_BASE_SPEED
var _render_snapshot: Dictionary = {}
var _terminal_emitted: bool = false


func _init() -> void:
	_presenter = PresenterScript.new()
	_render_snapshot = _empty_render_snapshot()


func initialize(
	map_path: String,
	recommended_cost: int = DEFAULT_RECOMMENDED_COST,
	base_speed: float = DEFAULT_BASE_SPEED
) -> bool:
	_recommended_cost = maxi(recommended_cost, 0)
	_base_speed = maxf(base_speed, 0.0)
	_definition = MapLoaderScript.load_from_path(map_path)
	if _definition == null or not _definition.validation_errors().is_empty():
		_build_session = null
		_run_factory = null
		_run_session = null
		_selected_geometry = &""
		_selected_rotation_quarters = 0
		_selected_cell = NO_CELL
		_delivery_history.clear()
		_terminal_emitted = false
		_publish_state()
		return false

	_build_session = BuildSessionScript.new(_definition)
	_run_factory = null
	_run_session = null
	_selected_geometry = &""
	_selected_rotation_quarters = 0
	_selected_cell = NO_CELL
	_delivery_history.clear()
	_terminal_emitted = false
	_refresh_build_state()
	return true


func request_command(command: StringName, payload: Variant = null) -> void:
	_last_command = command
	_last_payload = payload
	_dispatch_command(command, payload)


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
		_presenter.apply_unload_emissions(emitted)
	_refresh_run_or_result()


func phase() -> StringName:
	return StringName(_presenter.model().get("phase", &"BUILD"))


func model() -> Dictionary:
	return _presenter.model()


func render_snapshot() -> Dictionary:
	return _render_snapshot.duplicate(true)


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


func last_command() -> StringName:
	return _last_command


func last_payload() -> Variant:
	return _last_payload


func active_run_session_for_test() -> Variant:
	return _run_session


func active_attempt_identity_for_test() -> String:
	if _run_session == null:
		return ""
	return _run_session.attempt_identity()


func install_layout_for_test(pieces: Array) -> bool:
	if phase() != &"BUILD" or _build_session == null:
		return false
	_build_session.clear_layout()
	for piece: Variant in pieces:
		var result: Variant = _build_session.place_piece(piece)
		if result == null or not bool(result.success):
			_refresh_build_state()
			return false
	_refresh_build_state()
	return true


func _dispatch_command(command: StringName, payload: Variant) -> void:
	match command:
		&"BUILD_TOOL":
			_selected_geometry = StringName(payload)
			_selected_rotation_quarters = 0
			_selected_cell = NO_CELL
			_publish_state()
		&"BOARD_CELL":
			_handle_board_cell(payload)
		&"CANCEL_SELECTION":
			_selected_geometry = &""
			_selected_rotation_quarters = 0
			_selected_cell = NO_CELL
			_publish_state()
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
	var active_phase: StringName = phase()
	if active_phase == &"BUILD":
		_selected_cell = cell
		if _build_session == null or _selected_geometry == &"":
			_publish_state()
			return
		var switch_exit := Vector2i.ZERO
		if _selected_geometry == &"SWITCH":
			switch_exit = _rotate_clockwise(Vector2i.RIGHT, _selected_rotation_quarters)
		var piece: Variant = TrackPieceScript.create(
			cell,
			_selected_geometry,
			_selected_rotation_quarters,
			switch_exit
		)
		if piece == null:
			_publish_state()
			return
		var layout: Variant = _build_session.layout_snapshot()
		if layout.piece_at(cell) != null:
			_build_session.replace_piece(piece)
		else:
			_build_session.place_piece(piece)
		_refresh_build_state()
		return

	if (
		(active_phase == &"RUNNING" or active_phase == &"UNLOADING")
		and _run_session != null
		and _run_session.graph.switch_cells().has(cell)
	):
		_selected_cell = cell
		_run_session.graph.cycle_switch(cell)
		_refresh_run_or_result()


func _handle_rotate() -> void:
	if phase() != &"BUILD" or _build_session == null:
		return
	if _selected_cell != NO_CELL:
		var layout: Variant = _build_session.layout_snapshot()
		if layout.piece_at(_selected_cell) != null:
			_build_session.rotate_piece(_selected_cell, 1)
			_refresh_build_state()
			return
	if _selected_geometry != &"":
		_selected_rotation_quarters = _next_tool_rotation(
			_selected_geometry,
			_selected_rotation_quarters
		)
		_publish_state()


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
	if not _run_factory.configure(_definition, _build_session.sealed_snapshot(), _base_speed):
		return
	var result: Dictionary = _run_factory.create_attempt(1)
	if not bool(result.get("success", false)):
		return
	_activate_run_session(result["session"])


func _activate_run_session(session: Variant) -> void:
	_run_session = session
	_delivery_history.clear()
	_terminal_emitted = false
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
	_selected_geometry = &""
	_selected_rotation_quarters = 0
	_selected_cell = NO_CELL
	_delivery_history.clear()
	_terminal_emitted = false
	_refresh_build_state()


func _refresh_build_state() -> void:
	if _definition == null or _build_session == null:
		_publish_state()
		return
	var preflight: Variant = PreflightValidatorScript.new().validate(
		_definition,
		_build_session.layout_snapshot()
	)
	_presenter.show_build(preflight, _build_session.current_cost(), _recommended_cost)
	_publish_state()


func _refresh_run_or_result() -> void:
	if _run_session == null:
		return
	var summary: Variant = _run_session.run_controller.summary()
	var final_cost: int = _run_session.layout_snapshot().build_cost()
	if summary != null:
		_presenter.show_result(summary, final_cost)
		_publish_state()
		if not _terminal_emitted:
			_terminal_emitted = true
			terminal_reached.emit(summary)
		return
	_presenter.show_run(
		_run_session.run_controller.run_state(),
		_run_session.cargo_stack.load_order(),
		_run_session.input_state.is_auto_load_enabled(),
		final_cost
	)
	_publish_state()


func _on_delivery_event_created(event: Variant) -> void:
	_delivery_history.append(event)
	delivery_event_created.emit(event)
	if event == null or int(event.unload_count) <= 0 or _run_session == null:
		_publish_state()
		return
	var stack_before: Array[StringName] = _run_session.cargo_stack.load_order()
	var unloaded_items: Array[StringName] = event.unloaded_items
	var restored_top: Array[StringName] = unloaded_items.duplicate()
	restored_top.reverse()
	stack_before.append_array(restored_top)
	_presenter.begin_unload_visual(stack_before, unloaded_items)
	_publish_state()


func _publish_state() -> void:
	var current_model: Dictionary = _presenter.model()
	_render_snapshot = _build_render_snapshot(current_model)
	model_changed.emit(current_model.duplicate(true))
	render_snapshot_changed.emit(_render_snapshot.duplicate(true))


func _build_render_snapshot(current_model: Dictionary) -> Dictionary:
	var snapshot: Dictionary = _empty_render_snapshot()
	if _definition != null:
		snapshot["map_id"] = _definition.map_id
		snapshot["map_revision"] = _definition.map_revision
		snapshot["board_size"] = _definition.board_size
		snapshot["start_cell"] = _definition.start_cell
		snapshot["incoming_cell"] = _definition.incoming_cell
		snapshot["buildable_cells"] = _definition.buildable_cells.duplicate()
		snapshot["blocked_cells"] = _definition.blocked_cells.duplicate()
		snapshot["station_placements"] = _definition.station_placements.duplicate(true)
		snapshot["cargo_placements"] = _definition.cargo_placements.duplicate(true)

	snapshot["layout_pieces"] = _layout_piece_descriptors()
	snapshot["selected_cell"] = _selected_cell
	snapshot["selected_geometry"] = _selected_geometry
	snapshot["selected_rotation_quarters"] = _selected_rotation_quarters
	snapshot["problem_cells"] = current_model.get("problem_cells", []).duplicate()
	snapshot["phase"] = StringName(current_model.get("phase", &"BUILD"))
	snapshot["stack_tokens"] = current_model.get("stack_tokens", []).duplicate(true)
	snapshot["delivery_count"] = _delivery_history.size()

	if _run_session != null:
		snapshot["switch_cells"] = _run_session.graph.switch_cells().duplicate()
		var train: Variant = _run_session.train
		if train != null and train.has_method("current_cell"):
			snapshot["train_cell"] = train.current_cell()
		if train != null and train.has_method("next_cell"):
			snapshot["train_next_cell"] = train.next_cell()
	return snapshot


func _layout_piece_descriptors() -> Array[Dictionary]:
	var layout: Variant = null
	if _build_session != null:
		layout = _build_session.layout_snapshot()
	elif _run_session != null:
		layout = _run_session.layout_snapshot()
	if layout == null:
		return []

	var result: Array[Dictionary] = []
	for piece: Variant in layout.pieces():
		result.append({
			"cell": piece.cell,
			"geometry": piece.geometry,
			"rotation_quarters": piece.rotation_quarters,
			"switch_initial_exit": piece.switch_initial_exit,
		})
	return result


static func _next_tool_rotation(geometry: StringName, current: int) -> int:
	match geometry:
		&"STRAIGHT":
			return posmod(current + 1, 2)
		&"CROSSING":
			return 0
		&"CURVE", &"SWITCH":
			return posmod(current + 1, 4)
		_:
			return 0


static func _rotate_clockwise(direction: Vector2i, quarter_turns: int) -> Vector2i:
	var result := direction
	for _index: int in range(posmod(quarter_turns, 4)):
		result = Vector2i(-result.y, result.x)
	return result


static func _empty_render_snapshot() -> Dictionary:
	return {
		"map_id": &"",
		"map_revision": 0,
		"board_size": Vector2i.ZERO,
		"start_cell": NO_CELL,
		"incoming_cell": NO_CELL,
		"buildable_cells": [],
		"blocked_cells": [],
		"station_placements": [],
		"cargo_placements": [],
		"layout_pieces": [],
		"selected_cell": NO_CELL,
		"selected_geometry": &"",
		"selected_rotation_quarters": 0,
		"problem_cells": [],
		"phase": &"BUILD",
		"train_cell": NO_CELL,
		"train_next_cell": NO_CELL,
		"switch_cells": [],
		"stack_tokens": [],
		"delivery_count": 0,
	}
