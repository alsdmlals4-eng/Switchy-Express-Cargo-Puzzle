class_name ProductFiniteSlice
extends Control

signal terminal_reached(summary: Variant)
signal title_requested()
signal pause_changed(paused: bool)
signal menu_requested()
signal product_model_changed(model: Dictionary)

const SessionControllerScript := preload(
	"res://game/finite/main/finite_slice_session_controller.gd"
)
const RecommendedLayoutProviderScript := preload(
	"res://game/demo/recommended_layout_provider.gd"
)
const SemanticRuntimeStateScript := preload(
	"res://game/demo/presentation/semantic_runtime_state.gd"
)

@export_file("*.json") var map_path := "res://data/maps/vs_demo_01.json"
@export var recommended_cost := 4500
@export var base_speed := 2.0

var _controller: RefCounted
var _last_pause_state: bool = false
var _shell_input_locked: bool = false
var _stage_policy: Variant = null

@onready var _renderer: Control = $BoardRenderer
@onready var _route_overlay: Control = $RouteControlOverlay
@onready var _semantic_events: Control = $SemanticEventOverlay
@onready var _hud: Control = $HUD
@onready var _desktop_input: Node = $DesktopInputAdapter
@onready var _effects: Node = $DemoEffects
@onready var _audio: Node = $DemoAudioDirector


func _init() -> void:
	_controller = SessionControllerScript.new()


func _ready() -> void:
	_connect_controller()
	_connect_renderer()
	_connect_hud()
	_desktop_input.command_requested.connect(_on_desktop_command_requested)
	_controller.initialize(map_path, recommended_cost, base_speed)
	_apply_model(_controller.model())
	_apply_stage_policy_to_hud()
	_on_render_snapshot_changed(_controller.render_snapshot())


func _process(delta: float) -> void:
	_consume_route_selection_requests()
	advance_time(delta)


func _exit_tree() -> void:
	if is_instance_valid(_semantic_events):
		_semantic_events.cancel_all()
	if is_instance_valid(_effects):
		_effects.cancel_all()
	if is_instance_valid(_audio):
		_audio.stop_all()


func session_controller() -> RefCounted:
	return _controller


func set_shell_input_locked(locked: bool) -> void:
	_shell_input_locked = locked
	_refresh_desktop_input_enabled()


func shell_input_locked_for_test() -> bool:
	return _shell_input_locked


func set_reduced_motion(enabled: bool) -> void:
	if is_instance_valid(_renderer) and _renderer.has_method("set_reduced_motion"):
		_renderer.set_reduced_motion(enabled)
	if is_instance_valid(_semantic_events):
		_semantic_events.set_reduced_motion(enabled)


func set_stage_policy(policy: Variant) -> void:
	_stage_policy = policy
	_apply_stage_policy_to_hud()


func advance_time(delta_seconds: float) -> void:
	_controller.advance_time(delta_seconds)


func request_command(command: StringName, payload: Variant = null) -> void:
	_dispatch_command(command, payload)


func dispatch_action(action: StringName, pressed: bool) -> Dictionary:
	var result: Dictionary = _desktop_input.command_for_action(
		action,
		pressed,
		_controller.phase()
	)
	if bool(result.get("accepted", false)):
		_on_desktop_command_requested(
			StringName(result.get("command", &"")),
			result.get("payload")
		)
	return result


func apply_recommended_layout() -> bool:
	if _controller.phase() != &"BUILD":
		return false
	if _stage_policy != null and not _stage_policy.feature_visible(&"RECOMMENDED_LAYOUT"):
		return false
	var map_id := StringName(_controller.render_snapshot().get("map_id", &""))
	var pieces: Array[Variant] = RecommendedLayoutProviderScript.pieces_for_map(map_id, &"ALPHA")
	if pieces.is_empty():
		return false
	var applied: bool = _controller.replace_layout(pieces)
	if applied:
		_audio.play_cue(&"button")
		_audio.play_cue(&"build")
	return applied


func install_layout_for_test(pieces: Array) -> bool:
	return _controller.install_layout_for_test(pieces)


func apply_first_session_starter_layout(pieces: Array) -> bool:
	if _stage_policy == null or pieces.is_empty():
		return false
	return _controller.replace_layout(pieces)


func active_attempt_identity_for_test() -> String:
	return _controller.active_attempt_identity_for_test()


func request_command_for_test(command: StringName, payload: Variant = null) -> void:
	request_command(command, payload)


func dispatch_action_for_test(action: StringName, pressed: bool) -> Dictionary:
	return dispatch_action(action, pressed)


func _connect_controller() -> void:
	_controller.model_changed.connect(_on_controller_model_changed)
	_controller.render_snapshot_changed.connect(_on_render_snapshot_changed)
	_controller.delivery_event_created.connect(_on_delivery_event_created)
	_controller.terminal_reached.connect(_on_terminal_reached)


func _connect_renderer() -> void:
	_renderer.cell_primary_requested.connect(
		func(cell: Vector2i) -> void: _dispatch_command(&"BOARD_CELL", cell)
	)
	_renderer.cell_secondary_requested.connect(_on_secondary_cell_requested)


func _connect_hud() -> void:
	_hud.build_tool_selected.connect(
		func(tool: StringName) -> void: _dispatch_command(&"BUILD_TOOL", tool)
	)
	_hud.recommended_layout_requested.connect(func() -> void: apply_recommended_layout())
	_hud.rotate_requested.connect(func() -> void: _dispatch_command(&"ROTATE"))
	_hud.remove_requested.connect(func() -> void: _dispatch_command(&"REMOVE"))
	_hud.clear_requested.connect(func() -> void: _dispatch_command(&"CLEAR"))
	_hud.start_requested.connect(func() -> void: _dispatch_command(&"START"))
	_hud.load_active_changed.connect(
		func(active: bool) -> void: _dispatch_command(&"LOAD_ACTIVE", active)
	)
	_hud.auto_toggle_requested.connect(func() -> void: _dispatch_command(&"AUTO_TOGGLE"))
	_hud.pause_requested.connect(func() -> void: _dispatch_command(&"PAUSE"))
	_hud.resume_requested.connect(func() -> void: _dispatch_command(&"RESUME"))
	_hud.retry_requested.connect(func() -> void: _dispatch_command(&"RETRY_SAME_LAYOUT"))
	_hud.edit_requested.connect(func() -> void: _dispatch_command(&"EDIT_LAYOUT"))
	_hud.title_requested.connect(func() -> void: title_requested.emit())
	_hud.menu_requested.connect(func() -> void: menu_requested.emit())


func _on_secondary_cell_requested(cell: Vector2i) -> void:
	if _controller.phase() != &"BUILD":
		return
	var has_piece := false
	for value: Variant in _controller.render_snapshot().get("layout_pieces", []):
		var piece: Dictionary = value
		if piece.get("cell", Vector2i(-1, -1)) == cell:
			has_piece = true
			break
	if not has_piece:
		_dispatch_command(&"CANCEL_SELECTION")
		return

	_dispatch_command(&"CANCEL_SELECTION")
	_dispatch_command(&"BOARD_CELL", cell)
	_dispatch_command(&"REMOVE")


func _on_desktop_command_requested(command: StringName, payload: Variant) -> void:
	if command == &"FLOW_CONFIRM":
		return
	_dispatch_command(command, payload)


func _consume_route_selection_requests() -> void:
	if not is_instance_valid(_route_overlay):
		return
	if not _route_overlay.has_method("consume_route_selection_requests"):
		return
	for value: Variant in _route_overlay.consume_route_selection_requests():
		if not value is Dictionary:
			continue
		var request: Dictionary = value
		var cell: Variant = request.get("cell")
		if not cell is Vector2i:
			continue
		var cycle_count := clampi(int(request.get("cycle_count", 0)), 0, 4)
		for _cycle: int in range(cycle_count):
			_dispatch_command(&"BOARD_CELL", cell)


func _dispatch_command(command: StringName, payload: Variant = null) -> void:
	if not _command_allowed(command, payload):
		return
	var phase_before: StringName = _controller.phase()
	var layout_before: String = _controller.current_layout_signature()
	var selected_before: Vector2i = _controller.render_snapshot().get(
		"selected_cell",
		Vector2i(-1, -1)
	)
	var route_controls_before: Array = []
	if command == &"BOARD_CELL" and (phase_before == &"RUNNING" or phase_before == &"UNLOADING"):
		route_controls_before = _controller.render_snapshot().get("route_controls", []).duplicate(true)

	_controller.request_command(command, payload)
	var layout_changed: bool = _controller.current_layout_signature() != layout_before

	match command:
		&"BUILD_TOOL", &"ROTATE", &"CLEAR", &"START", &"AUTO_TOGGLE", &"PAUSE", &"RESUME", &"RETRY_SAME_LAYOUT", &"EDIT_LAYOUT":
			_audio.play_cue(&"button")
		&"BOARD_CELL":
			if phase_before == &"BUILD" and layout_changed:
				_effects.play_build(Vector2i(payload))
				_audio.play_cue(&"build")
			elif phase_before == &"RUNNING" or phase_before == &"UNLOADING":
				_audio.play_cue(&"switch")
				var route_controls_after: Array = _controller.render_snapshot().get("route_controls", [])
				if route_controls_after != route_controls_before and is_instance_valid(_semantic_events):
					_semantic_events.play_event(&"route_selection")
		&"REMOVE":
			if layout_changed:
				_effects.play_remove(selected_before)
				_audio.play_cue(&"remove")


func _apply_model(model: Dictionary) -> void:
	_hud.apply_model(model)
	_apply_stage_policy_to_hud()
	var phase: StringName = StringName(model.get("phase", &"BUILD"))
	_desktop_input.set_phase(phase)
	_refresh_desktop_input_enabled()
	var active_run: bool = phase == &"RUNNING" or phase == &"UNLOADING"
	_audio.set_train_loop_active(active_run)
	var paused: bool = phase == &"PAUSED"
	_audio.set_paused(paused)
	if paused != _last_pause_state:
		_last_pause_state = paused
		pause_changed.emit(paused)


func _on_controller_model_changed(model: Dictionary) -> void:
	_apply_model(model)
	product_model_changed.emit(model.duplicate(true))


func _command_allowed(command: StringName, payload: Variant = null) -> bool:
	if _stage_policy == null:
		return true
	return bool(_stage_policy.allows_command(command, _controller.phase(), payload))


func _apply_stage_policy_to_hud() -> void:
	if not is_instance_valid(_hud):
		return
	if _stage_policy == null:
		_hud.reset_stage_visibility()
		if is_instance_valid(_route_overlay):
			_route_overlay.visible = true
		return
	_hud.apply_stage_visibility(_stage_policy.visible_features())
	if is_instance_valid(_route_overlay):
		_route_overlay.visible = _stage_policy.feature_visible(&"SWITCH_STATE")


func _refresh_desktop_input_enabled() -> void:
	if not is_instance_valid(_desktop_input):
		return
	var phase: StringName = _controller.phase()
	var terminal: bool = phase == &"SUCCESS" or phase == &"FAILURE"
	_desktop_input.set_gameplay_enabled(not _shell_input_locked and not terminal)


func _on_render_snapshot_changed(snapshot: Dictionary) -> void:
	_renderer.apply_snapshot(snapshot)
	_route_overlay.apply_snapshot(snapshot)


func _on_delivery_event_created(event: Variant) -> void:
	if event == null:
		return
	if bool(event.picked_up):
		if is_instance_valid(_semantic_events):
			_semantic_events.play_event(&"cargo_pickup")
		_audio.play_cue(&"pickup")
	if int(event.unload_count) > 0:
		if is_instance_valid(_semantic_events):
			_semantic_events.play_event(&"cargo_unload")
		_effects.play_unload(int(event.unload_count))
		_audio.play_cue(&"unload")


func _on_terminal_reached(summary: Variant) -> void:
	var outcome: StringName = StringName(summary.outcome) if summary != null else &"FAILURE"
	var failure_reason: StringName = StringName(summary.failure_reason) if summary != null else &"TIME_EXPIRED"
	var success: bool = outcome == &"SUCCESS"
	_audio.set_train_loop_active(false)
	if success:
		_effects.play_success()
		_audio.play_cue(&"success")
	else:
		_effects.play_failure()
		_audio.play_cue(&"failure")
	var semantic_event: StringName = SemanticRuntimeStateScript.terminal_event(outcome, failure_reason)
	if semantic_event != &"" and is_instance_valid(_semantic_events):
		_semantic_events.play_event(semantic_event)
	terminal_reached.emit(summary)
