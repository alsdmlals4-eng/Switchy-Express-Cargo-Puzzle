class_name ProductHUD
extends Control

signal build_tool_selected(tool: StringName)
signal rotate_requested()
signal remove_requested()
signal clear_requested()
signal start_requested()
signal load_active_changed(active: bool)
signal auto_toggle_requested()
signal pause_requested()
signal resume_requested()
signal retry_requested()
signal edit_requested()
signal title_requested()

@export var use_internal_overlays: bool = true

var _model: Dictionary = {}


func _ready() -> void:
	_connect_button("BuildToolbar/StraightButton", func() -> void: build_tool_selected.emit(&"STRAIGHT"))
	_connect_button("BuildToolbar/CurveButton", func() -> void: build_tool_selected.emit(&"CURVE"))
	_connect_button("BuildToolbar/SwitchButton", func() -> void: build_tool_selected.emit(&"SWITCH"))
	_connect_button("BuildToolbar/CrossingButton", func() -> void: build_tool_selected.emit(&"CROSSING"))
	_connect_button("BuildToolbar/RotateButton", func() -> void: rotate_requested.emit())
	_connect_button("BuildToolbar/RemoveButton", func() -> void: remove_requested.emit())
	_connect_button("BuildToolbar/ClearButton", func() -> void: clear_requested.emit())
	_connect_button("BuildToolbar/StartButton", func() -> void: start_requested.emit())
	_connect_button("RunToolbar/AutoButton", func() -> void: auto_toggle_requested.emit())
	_connect_button("RunToolbar/PauseButton", func() -> void: pause_requested.emit())
	_connect_button("RunToolbar/ResumeButton", func() -> void: resume_requested.emit())
	_connect_button("ResultPanel/ResultLayout/RetryButton", func() -> void: retry_requested.emit())
	_connect_button("ResultPanel/ResultLayout/EditButton", func() -> void: edit_requested.emit())
	_connect_button("ResultPanel/ResultLayout/TitleButton", func() -> void: title_requested.emit())

	var load_button := get_node("RunToolbar/LoadButton") as Button
	load_button.button_down.connect(func() -> void: load_active_changed.emit(true))
	load_button.button_up.connect(func() -> void: load_active_changed.emit(false))
	apply_model({"phase": &"BUILD"})


func apply_model(model: Dictionary) -> void:
	_model = model.duplicate(true)
	var phase: StringName = StringName(_model.get("phase", &"BUILD"))
	var is_build: bool = phase == &"BUILD"
	var is_run: bool = phase == &"RUNNING" or phase == &"UNLOADING"
	var is_paused: bool = phase == &"PAUSED"
	var is_result: bool = phase == &"SUCCESS" or phase == &"FAILURE"

	(get_node("BuildToolbar") as Control).visible = is_build
	(get_node("RunToolbar") as Control).visible = is_run or is_paused
	(get_node("StackPanel") as Control).visible = is_run or is_paused
	(get_node("ProblemBanner") as Control).visible = is_build and not bool(_model.get("start_enabled", false))
	(get_node("PausePanel") as Control).visible = is_paused and use_internal_overlays
	(get_node("ResultPanel") as Control).visible = is_result and use_internal_overlays

	(get_node("TopStatus/PhaseLabel") as Label).text = _phase_text(phase)
	(get_node("TopStatus/CostLabel") as Label).text = "현재 비용 %d  ·  권장 기준 %d" % [
		int(_model.get("current_cost", 0)),
		int(_model.get("recommended_cost", 0)),
	]
	(get_node("TopStatus/TimeLabel") as Label).text = (
		"남은 시간 %.1f초" % float(_model.get("time_remaining", 0.0))
		if is_run or is_paused
		else "노선을 설계하세요"
	)

	var start_button := get_node("BuildToolbar/StartButton") as Button
	start_button.disabled = not bool(_model.get("start_enabled", false))
	var auto_button := get_node("RunToolbar/AutoButton") as Button
	auto_button.text = (
		"자동 적재 켬  A"
		if bool(_model.get("auto_load_active", false))
		else "자동 적재 끔  A"
	)
	(get_node("RunToolbar/PauseButton") as Button).visible = not is_paused
	(get_node("RunToolbar/ResumeButton") as Button).visible = is_paused

	(get_node("StackPanel/StackLayout/StackText") as Label).text = _stack_text(
		_model.get("stack_tokens", [])
	)
	(get_node("ProblemBanner/ProblemText") as Label).text = _problem_text(
		StringName(_model.get("primary_reason", &""))
	)

	if is_result:
		var success: bool = phase == &"SUCCESS"
		(get_node("ResultPanel/ResultLayout/ResultTitle") as Label).text = "배송 완료" if success else "배송 실패"
		(get_node("ResultPanel/ResultLayout/ResultBody") as Label).text = (
			"모든 화물을 제한 시간 안에 배송했습니다.\n최종 건설비 %d" % int(_model.get("final_cost", 0))
			if success
			else "제한 시간이 종료되었습니다.\n화물 TOP과 역 방문 순서를 다시 확인하세요."
		)
		(get_node("ResultPanel/ResultLayout/RetryButton") as Button).visible = bool(_model.get("retry_visible", true))
		(get_node("ResultPanel/ResultLayout/EditButton") as Button).visible = bool(_model.get("edit_visible", true))


func model_for_test() -> Dictionary:
	return _model.duplicate(true)


static func _phase_text(phase: StringName) -> String:
	match phase:
		&"BUILD":
			return "건설 단계"
		&"READY":
			return "출발 준비"
		&"RUNNING":
			return "운행 중"
		&"UNLOADING":
			return "하역 중"
		&"PAUSED":
			return "일시정지"
		&"SUCCESS":
			return "배송 완료"
		&"FAILURE":
			return "배송 실패"
		_:
			return "배송 준비"


static func _stack_text(tokens: Array) -> String:
	if tokens.is_empty():
		return "비어 있음"
	var labels: Array[String] = []
	for value: Variant in tokens:
		var token: Dictionary = value
		var cargo_type: StringName = StringName(token.get("cargo_type", &""))
		var label := "A · 별" if cargo_type == &"RED_STAR" else "B · 다이아"
		if bool(token.get("top", false)):
			label += "  ← TOP"
		labels.append(label)
	return "\n".join(labels)


static func _problem_text(code: StringName) -> String:
	match code:
		&"DISCONNECTED", &"UNREACHABLE":
			return "연결되지 않은 지점이 있습니다"
		&"MISSING_START", &"START_DISCONNECTED":
			return "출발 선로를 연결해 주세요"
		&"INVALID_TRACK":
			return "설치할 수 없는 선로가 있습니다"
		&"NOT_READY":
			return "모든 역과 화물을 연결해 주세요"
		_:
			return "노선을 확인해 주세요"


func _connect_button(path: NodePath, callback: Callable) -> void:
	var button := get_node(path) as Button
	button.pressed.connect(callback)
