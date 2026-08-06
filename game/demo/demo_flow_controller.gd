class_name DemoFlowController
extends Control

signal state_changed(state: StringName)

const TITLE: StringName = &"TITLE"
const CONTROLS: StringName = &"CONTROLS"
const BRIEFING: StringName = &"BRIEFING"
const GAMEPLAY: StringName = &"GAMEPLAY"
const PAUSED: StringName = &"PAUSED"
const EXIT_CONFIRM: StringName = &"EXIT_CONFIRM"
const RESULT: StringName = &"RESULT"

const ProductScene := preload("res://game/demo/product_finite_slice.tscn")
const ThemeFactory := preload("res://game/demo/presentation/demo_theme_factory.gd")

var _state: StringName = TITLE
var _last_result: Variant
var _gameplay: Control


func _ready() -> void:
	theme = ThemeFactory.create_theme()
	_connect_button("TitleScreen/Panel/Content/StartButton", start_demo)
	_connect_button("TitleScreen/Panel/Content/ControlsButton", open_controls)
	_connect_button("TitleScreen/Panel/Content/QuitButton", _quit_demo)
	_connect_button("ControlsOverlay/Panel/Content/CloseButton", close_controls)
	_connect_button("BriefingScreen/Panel/Content/BeginButton", begin_build)
	_connect_button("PauseOverlay/Panel/Content/ResumeButton", _resume_demo)
	_connect_button("PauseOverlay/Panel/Content/ExitButton", request_exit_confirmation)
	_connect_button(
		"ExitConfirmOverlay/Panel/Content/ContinueButton",
		cancel_exit_confirmation
	)
	_connect_button(
		"ExitConfirmOverlay/Panel/Content/ConfirmButton",
		confirm_exit_to_title
	)
	_connect_button("ResultOverlay/Panel/Content/RetryButton", _retry_result)
	_connect_button("ResultOverlay/Panel/Content/EditButton", _edit_result)
	_connect_button("ResultOverlay/Panel/Content/TitleButton", return_to_title)
	_sync_visibility()


func state() -> StringName:
	return _state


func last_result() -> Variant:
	return _last_result


func gameplay_instance() -> Control:
	return _gameplay if is_instance_valid(_gameplay) else null


func start_demo() -> void:
	if _state == TITLE:
		_transition_to(BRIEFING)


func open_controls() -> void:
	if _state == TITLE:
		_transition_to(CONTROLS)


func close_controls() -> void:
	if _state == CONTROLS:
		_transition_to(TITLE)


func begin_build() -> void:
	if _state != BRIEFING:
		return
	_ensure_gameplay_instance()
	_transition_to(GAMEPLAY)


func open_pause_menu() -> void:
	if _state != GAMEPLAY or not is_instance_valid(_gameplay):
		return
	var phase: StringName = _gameplay.session_controller().phase()
	if phase == &"BUILD":
		_transition_to(PAUSED)
	elif phase == &"RUNNING" or phase == &"UNLOADING":
		_gameplay.request_command(&"PAUSE")
	elif phase == &"PAUSED":
		_transition_to(PAUSED)


func set_paused(paused: bool) -> void:
	if paused and _state == GAMEPLAY:
		_transition_to(PAUSED)
	elif not paused and _state == PAUSED:
		_transition_to(GAMEPLAY)


func request_exit_confirmation() -> void:
	if _state != PAUSED:
		return
	_transition_to(EXIT_CONFIRM)
	var continue_button := get_node_or_null(
		"ExitConfirmOverlay/Panel/Content/ContinueButton"
	) as Button
	if continue_button != null:
		continue_button.grab_focus()


func cancel_exit_confirmation() -> void:
	if _state == EXIT_CONFIRM:
		_transition_to(PAUSED)


func confirm_exit_to_title() -> void:
	if _state == EXIT_CONFIRM:
		return_to_title()


func show_result(summary: Variant) -> void:
	if _state != GAMEPLAY and _state != PAUSED:
		return
	_last_result = summary
	_update_result_copy(summary)
	_transition_to(RESULT)


func return_to_title() -> void:
	_last_result = null
	_release_gameplay_instance()
	_transition_to(TITLE)


func dispatch_flow_action_for_test(action: StringName, pressed: bool) -> bool:
	if not pressed:
		return false
	match action:
		&"demo_confirm":
			match _state:
				TITLE:
					start_demo()
					return true
				CONTROLS:
					close_controls()
					return true
				BRIEFING:
					begin_build()
					return true
				RESULT:
					_retry_result()
					return true
		&"demo_cancel":
			match _state:
				CONTROLS:
					close_controls()
					return true
				BRIEFING, RESULT:
					return_to_title()
					return true
				PAUSED:
					_resume_demo()
					return true
				EXIT_CONFIRM:
					cancel_exit_confirmation()
					return true
	return false


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.echo:
		return
	for action: StringName in [&"demo_confirm", &"demo_cancel"]:
		if not event.is_action(action):
			continue
		if dispatch_flow_action_for_test(action, event.is_pressed()):
			get_viewport().set_input_as_handled()
		return


func _ensure_gameplay_instance() -> Control:
	if is_instance_valid(_gameplay):
		return _gameplay
	var container := get_node_or_null("GameplayContainer") as Control
	if container == null:
		return null
	_gameplay = ProductScene.instantiate()
	_gameplay.name = "ProductFiniteSlice"
	container.add_child(_gameplay)
	_gameplay.terminal_reached.connect(_on_product_terminal_reached)
	_gameplay.title_requested.connect(return_to_title)
	_gameplay.pause_changed.connect(set_paused)
	_gameplay.menu_requested.connect(open_pause_menu)
	return _gameplay


func _release_gameplay_instance() -> void:
	if not is_instance_valid(_gameplay):
		_gameplay = null
		return
	var parent := _gameplay.get_parent()
	if parent != null:
		parent.remove_child(_gameplay)
	_gameplay.free()
	_gameplay = null


func _on_product_terminal_reached(summary: Variant) -> void:
	show_result(summary)


func _resume_demo() -> void:
	if not is_instance_valid(_gameplay):
		set_paused(false)
		return
	var phase: StringName = _gameplay.session_controller().phase()
	if phase == &"PAUSED":
		_gameplay.request_command(&"RESUME")
	elif phase == &"BUILD" and _state == PAUSED:
		_transition_to(GAMEPLAY)


func _retry_result() -> void:
	if _state != RESULT or not is_instance_valid(_gameplay):
		return
	_gameplay.request_command(&"RETRY_SAME_LAYOUT")
	_transition_to(GAMEPLAY)


func _edit_result() -> void:
	if _state != RESULT or not is_instance_valid(_gameplay):
		return
	_gameplay.request_command(&"EDIT_LAYOUT")
	_transition_to(GAMEPLAY)


func _quit_demo() -> void:
	if OS.has_feature("pc") and get_tree() != null:
		get_tree().quit()


func _transition_to(next_state: StringName) -> void:
	if _state == next_state:
		return
	_state = next_state
	_sync_visibility()
	state_changed.emit(_state)


func _sync_visibility() -> void:
	_set_visible("TitleScreen", _state == TITLE)
	_set_visible("ControlsOverlay", _state == CONTROLS)
	_set_visible("BriefingScreen", _state == BRIEFING)
	_set_visible(
		"GameplayContainer",
		_state == GAMEPLAY
		or _state == PAUSED
		or _state == EXIT_CONFIRM
		or _state == RESULT
	)
	_set_visible("PauseOverlay", _state == PAUSED)
	_set_visible("ExitConfirmOverlay", _state == EXIT_CONFIRM)
	_set_visible("ResultOverlay", _state == RESULT)
	if is_instance_valid(_gameplay):
		_gameplay.set_shell_input_locked(_state != GAMEPLAY)


func _update_result_copy(summary: Variant) -> void:
	var title := get_node_or_null("ResultOverlay/Panel/Content/Title") as Label
	var body := get_node_or_null("ResultOverlay/Panel/Content/Body") as Label
	if title == null or body == null:
		return

	var outcome := StringName(_summary_value(summary, &"outcome", &"FAILURE"))
	var success: bool = outcome == &"SUCCESS"
	var completion_time := maxf(float(_summary_value(summary, &"completion_time", 0.0)), 0.0)
	var time_limit := maxf(float(_summary_value(summary, &"time_limit_seconds", 0.0)), 0.0)
	var remaining_time := maxf(time_limit - completion_time, 0.0)
	var final_cost := 0
	var unload_groups: Array[String] = []
	if is_instance_valid(_gameplay):
		var controller: RefCounted = _gameplay.session_controller()
		final_cost = int(controller.model().get("final_cost", 0))
		for event: Variant in controller.delivery_history():
			if event != null and int(event.unload_count) > 0:
				unload_groups.append(str(int(event.unload_count)))

	title.text = "배송 완료" if success else "배송 실패"
	body.text = "%s\n완료 시간 %.1f초\n남은 시간 %.1f초\n건설비 %d\n하역 %s" % [
		"모든 화물을 제한 시간 안에 배송했습니다."
		if success
		else "제한 시간이 종료되었습니다. 노선과 화물 TOP을 다시 확인하세요.",
		completion_time,
		remaining_time,
		final_cost,
		" → ".join(unload_groups) if not unload_groups.is_empty() else "없음",
	]


static func _summary_value(summary: Variant, key: StringName, fallback: Variant) -> Variant:
	if summary == null:
		return fallback
	if summary is Dictionary:
		return summary.get(key, fallback)
	var value: Variant = summary.get(key)
	return fallback if value == null else value


func _set_visible(path: NodePath, value: bool) -> void:
	var control := get_node_or_null(path) as CanvasItem
	if control != null:
		control.visible = value


func _connect_button(path: NodePath, callable: Callable) -> void:
	var button := get_node_or_null(path) as Button
	if button != null and not button.pressed.is_connected(callable):
		button.pressed.connect(callable)
