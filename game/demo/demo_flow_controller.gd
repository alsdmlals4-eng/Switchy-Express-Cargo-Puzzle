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
const ROUTE_BOOK: StringName = &"ROUTE_BOOK"

const ProductScene := preload("res://game/demo/product_finite_slice.tscn")
const ThemeFactory := preload("res://game/demo/presentation/demo_theme_factory.gd")
const FirstSessionDefinitionScript := preload(
	"res://game/first_session/first_session_definition.gd"
)
const FirstSessionDirectorScript := preload(
	"res://game/first_session/first_session_director.gd"
)
const FirstSessionCopyScript := preload("res://game/first_session/first_session_copy.gd")
const FirstSessionStarterLayoutsScript := preload(
	"res://game/first_session/first_session_starter_layouts.gd"
)
const FirstSessionStagePolicyScript := preload(
	"res://game/first_session/first_session_stage_policy.gd"
)
const RouteBookDefinitionScript := preload(
	"res://game/route_book/route_book_definition.gd"
)
const RouteBookDirectorScript := preload(
	"res://game/route_book/route_book_director.gd"
)

@export var first_session_enabled: bool = false
@export var first_session_locale: String = "ko"

var _state: StringName = TITLE
var _last_result: Variant
var _gameplay: Control
var _first_session_director: Variant = null
var _first_session_copy: Variant = null
var _route_book_director: Variant = null
var _route_book_copy: Variant = null
var _route_book_active: bool = false


func _ready() -> void:
	theme = ThemeFactory.create_theme()
	_connect_button("TitleScreen/Panel/Content/StartButton", start_demo)
	_connect_button("TitleScreen/Panel/Content/StageBookButton", open_route_book)
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
	_connect_button("ResultOverlay/Panel/Content/Actions/RetryButton", _retry_result)
	_connect_button("ResultOverlay/Panel/Content/Actions/EditButton", _edit_result)
	_connect_button("ResultOverlay/Panel/Content/Actions/TitleButton", return_to_title)
	_connect_button(
		"ResultOverlay/Panel/Content/RouteBookActions/StageBookButton",
		open_route_book
	)
	_connect_button(
		"ResultOverlay/Panel/Content/RouteBookActions/NextStageButton",
		open_next_route_book_stage
	)
	_connect_button("RouteBookScreen/Panel/Content/BackButton", return_to_title)
	if first_session_enabled:
		_setup_first_session()
	_setup_route_book()
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


func open_route_book() -> void:
	if _route_book_director == null:
		return
	if _state != TITLE and not (_state == RESULT and _route_book_active):
		return
	_release_gameplay_instance()
	_route_book_active = false
	_route_book_director.reset()
	_populate_route_book_list()
	_transition_to(ROUTE_BOOK)


func select_route_book_stage(stage_id: StringName) -> bool:
	if _state != ROUTE_BOOK or _route_book_director == null:
		return false
	if not _route_book_director.select_stage(stage_id):
		return false
	_route_book_active = true
	_apply_route_book_card()
	_transition_to(BRIEFING)
	return true


func open_next_route_book_stage() -> bool:
	if _state != RESULT or not _route_book_active or _route_book_director == null:
		return false
	if StringName(_summary_value(_last_result, &"outcome", &"FAILURE")) != &"SUCCESS":
		return false
	if not _route_book_director.select_next_stage():
		return false
	_release_gameplay_instance()
	_apply_route_book_card()
	_transition_to(BRIEFING)
	return true


func open_controls() -> void:
	if _state == TITLE:
		_transition_to(CONTROLS)


func close_controls() -> void:
	if _state == CONTROLS:
		_transition_to(TITLE)


func begin_build() -> void:
	if _state != BRIEFING:
		return
	var map_path := "res://data/maps/vs_demo_01.json"
	if _route_book_active and _route_book_director != null:
		map_path = str(_route_book_director.current_stage().get("map_path", map_path))
	elif first_session_enabled and _first_session_director != null:
		map_path = str(_first_session_director.current_lesson().get("map_path", map_path))
	_ensure_gameplay_instance(map_path)
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
	_route_book_active = false
	if _route_book_director != null:
		_route_book_director.reset()
	if first_session_enabled and _first_session_director != null:
		_first_session_director.reset()
		_apply_lesson_card()
	_transition_to(TITLE)


func current_lesson_id_for_test() -> StringName:
	if _first_session_director == null:
		return &""
	return _first_session_director.current_lesson_id()


func current_route_book_stage_id_for_test() -> StringName:
	if _route_book_director == null:
		return &""
	return _route_book_director.current_stage_id()


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
				ROUTE_BOOK:
					return_to_title()
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


func _ensure_gameplay_instance(map_path: String = "res://data/maps/vs_demo_01.json") -> Control:
	if is_instance_valid(_gameplay):
		return _gameplay
	var container := get_node_or_null("GameplayContainer") as Control
	if container == null:
		return null
	_gameplay = ProductScene.instantiate()
	_gameplay.name = "ProductFiniteSlice"
	_gameplay.map_path = map_path
	if _route_book_active and _route_book_director != null:
		_gameplay.set_stage_policy(
			FirstSessionStagePolicyScript.create(_route_book_director.current_stage())
		)
	elif first_session_enabled and _first_session_director != null:
		_gameplay.set_stage_policy(_first_session_director.current_policy())
	container.add_child(_gameplay)
	if first_session_enabled and _first_session_director != null:
		var layout_id := StringName(
			_first_session_director.current_lesson().get("starter_layout_id", &"")
		)
		if layout_id != &"":
			_gameplay.apply_first_session_starter_layout(
				FirstSessionStarterLayoutsScript.pieces(layout_id)
			)
	_gameplay.terminal_reached.connect(_on_product_terminal_reached)
	if first_session_enabled and not _route_book_active:
		_gameplay.product_model_changed.connect(_on_first_session_model_changed)
	_gameplay.title_requested.connect(return_to_title)
	_gameplay.pause_changed.connect(set_paused)
	_gameplay.menu_requested.connect(open_pause_menu)
	return _gameplay


func _release_gameplay_instance() -> void:
	if not is_instance_valid(_gameplay):
		_gameplay = null
		return
	var released: Control = _gameplay
	_gameplay = null
	# Terminal signals originate from the gameplay node. Queueing avoids freeing
	# the signal emitter while Godot has it locked during emission.
	released.queue_free()


func _on_product_terminal_reached(summary: Variant) -> void:
	if _route_book_active:
		show_result(summary)
		return
	if first_session_enabled and _first_session_director != null:
		var transition: Dictionary = _first_session_director.observe_terminal(summary)
		if bool(transition.get("changed", false)):
			_last_result = summary
			_release_gameplay_instance()
			_apply_lesson_card()
			_transition_to(BRIEFING)
			return
	show_result(summary)


func _on_first_session_model_changed(model: Dictionary) -> void:
	if _first_session_director == null:
		return
	var transition: Dictionary = _first_session_director.observe_model(model)
	if not bool(transition.get("changed", false)):
		return
	if is_instance_valid(_gameplay):
		_gameplay.set_stage_policy(_first_session_director.current_policy())
	_apply_lesson_card()
	_transition_to(BRIEFING)


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
	_set_visible("RouteBookScreen", _state == ROUTE_BOOK)
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
	_set_visible(
		"ResultOverlay/Panel/Content/RouteBookActions",
		_state == RESULT and _route_book_active
	)
	if is_instance_valid(_gameplay):
		_gameplay.set_shell_input_locked(_state != GAMEPLAY)


func _update_result_copy(summary: Variant) -> void:
	var title := get_node_or_null("ResultOverlay/Panel/Content/Title") as Label
	var body := get_node_or_null("ResultOverlay/Panel/Content/BodyScroll/Body") as Label
	if title == null or body == null:
		return
	var outcome := StringName(_summary_value(summary, &"outcome", &"FAILURE"))
	var result_art := get_node_or_null("ResultOverlay/Panel/Content/ResultArt")
	if result_art != null and result_art.has_method("set_result_outcome"):
		result_art.set_result_outcome(outcome)
	_update_route_book_result_actions(outcome)
	if first_session_enabled and _first_session_copy != null and not _route_book_active:
		_update_first_session_result_copy(summary, title, body)
		return

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


func _update_route_book_result_actions(outcome: StringName) -> void:
	var actions := get_node_or_null("ResultOverlay/Panel/Content/RouteBookActions") as CanvasItem
	var stage_book := get_node_or_null(
		"ResultOverlay/Panel/Content/RouteBookActions/StageBookButton"
	) as Button
	var next_stage := get_node_or_null(
		"ResultOverlay/Panel/Content/RouteBookActions/NextStageButton"
	) as Button
	var visible := _route_book_active and _route_book_director != null
	if actions != null:
		actions.visible = visible and _state == RESULT
	if stage_book != null and _route_book_copy != null:
		stage_book.text = _route_book_copy.text(&"SX_RB_STAGE_BOOK", first_session_locale)
	if next_stage != null:
		if _route_book_copy != null:
			next_stage.text = _route_book_copy.text(&"SX_RB_NEXT_STAGE", first_session_locale)
		next_stage.visible = (
			visible
			and outcome == &"SUCCESS"
			and _route_book_director.has_next_stage()
		)


func _update_first_session_result_copy(summary: Variant, title: Label, body: Label) -> void:
	var outcome := StringName(_summary_value(summary, &"outcome", &"FAILURE"))
	var reason := StringName(_summary_value(summary, &"failure_reason", &"TIME_EXPIRED"))
	var remaining := maxi(int(_summary_value(summary, &"remaining_map_cargo", 0)), 0)
	var stack_size := maxi(int(_summary_value(summary, &"stack_size", 0)), 0)
	if outcome == &"SUCCESS":
		title.text = _first_session_copy.text(&"SX_RESULT_SUCCESS", first_session_locale)
		body.text = _first_session_copy.text(&"SX_RESULT_OTHER_SOLUTION", first_session_locale)
	else:
		title.text = (
			_first_session_copy.text(&"SX_RESULT_ROUTE_END", first_session_locale)
			if reason == &"ROUTE_END"
			else _first_session_copy.text(&"SX_RESULT_TIME_EXPIRED", first_session_locale)
		)
		body.text = "\n".join([
			_first_session_copy.format(
				&"SX_RESULT_MAP_CARGO", {"count": remaining}, first_session_locale
			),
			_first_session_copy.format(
				&"SX_RESULT_STACK_CARGO", {"count": stack_size}, first_session_locale
			),
		])
	var retry := get_node_or_null(
		"ResultOverlay/Panel/Content/Actions/RetryButton"
	) as Button
	var edit := get_node_or_null("ResultOverlay/Panel/Content/Actions/EditButton") as Button
	if retry != null:
		retry.text = _first_session_copy.text(&"SX_RESULT_RETRY", first_session_locale)
	if edit != null:
		edit.text = _first_session_copy.text(&"SX_RESULT_EDIT", first_session_locale)
		var lesson: Dictionary = (
			_first_session_director.current_lesson()
			if _first_session_director != null
			else {}
		)
		edit.visible = not lesson.get("allowed_build_tools", []).is_empty()


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


func _setup_first_session() -> void:
	var definition: Variant = FirstSessionDefinitionScript.load_from_path(
		"res://data/first_session/first_session_v1.json"
	)
	_first_session_director = FirstSessionDirectorScript.new()
	if definition == null or not _first_session_director.configure(definition):
		_first_session_director = null
		return
	_first_session_copy = FirstSessionCopyScript.new()
	if not _first_session_copy.load_default():
		_first_session_copy = null
		return
	var start_button := get_node_or_null("TitleScreen/Panel/Content/StartButton") as Button
	if start_button != null:
		start_button.text = _first_session_copy.text(&"SX_FS_START", first_session_locale)
		_set_visible("TitleScreen/Panel/Content/SliceBadge", false)
	_apply_lesson_card()


func _setup_route_book() -> void:
	var definition: Variant = RouteBookDefinitionScript.load_from_path(
		"res://data/route_book/route_book_01.json"
	)
	_route_book_director = RouteBookDirectorScript.new()
	if definition == null or not _route_book_director.configure(definition):
		_route_book_director = null
		return
	_route_book_copy = FirstSessionCopyScript.new()
	if not _route_book_copy.load_from_path("res://data/localization/route_book_01_v1.json"):
		_route_book_copy = null
		return
	var button := get_node_or_null("TitleScreen/Panel/Content/StageBookButton") as Button
	if button != null:
		button.text = _route_book_copy.text(&"SX_RB_STAGE_BOOK", first_session_locale)
	var title := get_node_or_null("RouteBookScreen/Panel/Content/Title") as Label
	if title != null:
		title.text = _route_book_copy.text(&"SX_RB_SELECT_STAGE", first_session_locale)
	var back := get_node_or_null("RouteBookScreen/Panel/Content/BackButton") as Button
	if back != null:
		back.text = _route_book_copy.text(&"SX_RB_BACK", first_session_locale)


func _populate_route_book_list() -> void:
	if _route_book_director == null or _route_book_copy == null:
		return
	var list := get_node_or_null("RouteBookScreen/Panel/Content/StageScroll/StageList") as VBoxContainer
	if list == null:
		return
	for child: Node in list.get_children():
		list.remove_child(child)
		child.free()
	for stage_id: StringName in _route_book_director.stage_ids():
		var stage: Dictionary = _route_book_director.stage(stage_id)
		var selected_stage_id := stage_id
		var card := Button.new()
		card.name = "%sCard" % stage_id
		card.custom_minimum_size = Vector2(0, 64)
		card.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		card.text = "%02d  %s\n%s" % [
			_route_book_director.stage_ids().find(stage_id) + 1,
			_route_book_copy.text(StringName(stage.get("title_key", &"")), first_session_locale),
			_route_book_copy.text(StringName(stage.get("objective_key", &"")), first_session_locale),
		]
		card.pressed.connect(func() -> void: select_route_book_stage(selected_stage_id))
		list.add_child(card)


func _apply_route_book_card() -> void:
	if _route_book_director == null or _route_book_copy == null:
		return
	var stage: Dictionary = _route_book_director.current_stage()
	var progress := get_node_or_null("BriefingScreen/Panel/Content/LessonProgress") as Label
	var title := get_node_or_null("BriefingScreen/Panel/Content/Title") as Label
	var objective := get_node_or_null("BriefingScreen/Panel/Content/Objective") as Label
	var rules := get_node_or_null("BriefingScreen/Panel/Content/Rules") as Label
	var begin := get_node_or_null("BriefingScreen/Panel/Content/BeginButton") as Button
	var lesson_art := get_node_or_null("BriefingScreen/Panel/Content/LessonArt")
	if lesson_art != null and lesson_art.has_method("set_lesson_id"):
		lesson_art.set_lesson_id(_route_book_director.current_stage_id())
	if progress != null:
		progress.text = _route_book_copy.format(
			&"SX_RB_PROGRESS",
			{
				"current": _route_book_director.current_stage_number(),
				"total": _route_book_director.stage_count(),
			},
			first_session_locale
		)
	if title != null:
		title.text = _route_book_copy.text(StringName(stage.get("title_key", &"")), first_session_locale)
	if objective != null:
		objective.text = _route_book_copy.text(StringName(stage.get("objective_key", &"")), first_session_locale)
	if rules != null:
		rules.text = ""
		rules.visible = false
	if begin != null:
		begin.text = _route_book_copy.text(&"SX_RB_BEGIN", first_session_locale)


func _apply_lesson_card() -> void:
	if _first_session_director == null or _first_session_copy == null:
		return
	var lesson: Dictionary = _first_session_director.current_lesson()
	var progress := get_node_or_null("BriefingScreen/Panel/Content/LessonProgress") as Label
	var title := get_node_or_null("BriefingScreen/Panel/Content/Title") as Label
	var objective := get_node_or_null("BriefingScreen/Panel/Content/Objective") as Label
	var rules := get_node_or_null("BriefingScreen/Panel/Content/Rules") as Label
	var begin := get_node_or_null("BriefingScreen/Panel/Content/BeginButton") as Button
	var lesson_art := get_node_or_null("BriefingScreen/Panel/Content/LessonArt")
	if lesson_art != null and lesson_art.has_method("set_lesson_id"):
		lesson_art.set_lesson_id(_first_session_director.current_lesson_id())
	if progress != null:
		progress.text = "%d / %d" % [
			_first_session_director.current_lesson_number(),
			_first_session_director.lesson_count(),
		]
	if title != null:
		title.text = _first_session_copy.text(StringName(lesson.get("title_key", &"")), first_session_locale)
	if objective != null:
		objective.text = _first_session_copy.text(StringName(lesson.get("objective_key", &"")), first_session_locale)
	var context_key := StringName(lesson.get("context_key", &""))
	var context: String = _first_session_copy.text(context_key, first_session_locale)
	if rules != null:
		rules.text = context
		rules.visible = not context.is_empty()
	if begin != null:
		var action_key: StringName = &"SX_ACTION_START_RUN" if _first_session_director.current_lesson_id() == &"T2" else &"SX_ACTION_START_LESSON"
		begin.text = _first_session_copy.text(action_key, first_session_locale)
