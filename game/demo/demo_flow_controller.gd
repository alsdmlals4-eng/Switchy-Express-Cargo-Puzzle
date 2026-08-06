class_name DemoFlowController
extends Control

signal state_changed(state: StringName)

const TITLE: StringName = &"TITLE"
const CONTROLS: StringName = &"CONTROLS"
const BRIEFING: StringName = &"BRIEFING"
const GAMEPLAY: StringName = &"GAMEPLAY"
const PAUSED: StringName = &"PAUSED"
const RESULT: StringName = &"RESULT"

const ProductScene := preload("res://game/demo/product_finite_slice.tscn")

var _state: StringName = TITLE
var _last_result: Variant
var _gameplay: Control


func _ready() -> void:
	_connect_button("TitleScreen/Panel/Content/StartButton", start_demo)
	_connect_button("TitleScreen/Panel/Content/ControlsButton", open_controls)
	_connect_button("TitleScreen/Panel/Content/QuitButton", _quit_demo)
	_connect_button("ControlsOverlay/Panel/Content/CloseButton", close_controls)
	_connect_button("BriefingScreen/Panel/Content/BeginButton", begin_build)
	_connect_button("PauseOverlay/Panel/Content/ResumeButton", _resume_demo)
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


func set_paused(paused: bool) -> void:
	if paused and _state == GAMEPLAY:
		_transition_to(PAUSED)
	elif not paused and _state == PAUSED:
		_transition_to(GAMEPLAY)


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
	if is_instance_valid(_gameplay):
		_gameplay.request_command_for_test(&"RESUME")
	else:
		set_paused(false)


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
		_state == GAMEPLAY or _state == PAUSED or _state == RESULT
	)
	_set_visible("PauseOverlay", _state == PAUSED)
	_set_visible("ResultOverlay", _state == RESULT)


func _update_result_copy(summary: Variant) -> void:
	var title := get_node_or_null("ResultOverlay/Panel/Content/Title") as Label
	var body := get_node_or_null("ResultOverlay/Panel/Content/Body") as Label
	if title == null or body == null:
		return
	var success := summary != null and StringName(summary.outcome) == &"SUCCESS"
	title.text = "배송 완료" if success else "배송 실패"
	body.text = (
		"모든 화물을 제한 시간 안에 배송했습니다."
		if success
		else "제한 시간이 종료되었습니다. 노선과 화물 TOP을 다시 확인하세요."
	)


func _set_visible(path: NodePath, value: bool) -> void:
	var control := get_node_or_null(path) as CanvasItem
	if control != null:
		control.visible = value


func _connect_button(path: NodePath, callable: Callable) -> void:
	var button := get_node_or_null(path) as Button
	if button != null and not button.pressed.is_connected(callable):
		button.pressed.connect(callable)
