class_name ProductHUD
extends Control

signal build_tool_selected(tool: StringName)
signal recommended_layout_requested()
signal rotate_requested()
signal remove_requested()
signal clear_requested()
signal undo_requested()
signal redo_requested()
signal start_requested()
signal load_active_changed(active: bool)
signal auto_toggle_requested()
signal pause_requested()
signal resume_requested()
signal retry_requested()
signal edit_requested()
signal title_requested()
signal menu_requested()

const SemanticAssetCatalogScript := preload("res://game/demo/presentation/semantic_asset_catalog.gd")
const SemanticRuntimeStateScript := preload("res://game/demo/presentation/semantic_runtime_state.gd")

@export var use_internal_overlays: bool = true

var _model: Dictionary = {}
var _catalog: Variant
var _semantic_state: Dictionary = {}
var _stage_visibility_active: bool = false
var _stage_features: Dictionary = {}


func _ready() -> void:
	_catalog = SemanticAssetCatalogScript.new()
	_catalog.load_default()

	_connect_button("TopStatus/MenuButton", func() -> void: menu_requested.emit())
	_connect_button("BuildToolbar/StraightButton", func() -> void: build_tool_selected.emit(&"STRAIGHT"))
	_connect_button("BuildToolbar/CurveButton", func() -> void: build_tool_selected.emit(&"CURVE"))
	_connect_button("BuildToolbar/SwitchButton", func() -> void: build_tool_selected.emit(&"SWITCH"))
	_connect_button("BuildToolbar/CrossingButton", func() -> void: build_tool_selected.emit(&"CROSSING"))
	_connect_button("BuildToolbar/RecommendButton", func() -> void: recommended_layout_requested.emit())
	_connect_button("BuildToolbar/RotateButton", func() -> void: rotate_requested.emit())
	_connect_button("BuildToolbar/RemoveButton", func() -> void: remove_requested.emit())
	_connect_button("BuildToolbar/ClearButton", func() -> void: clear_requested.emit())
	_connect_button("BuildHistory/UndoButton", func() -> void: undo_requested.emit())
	_connect_button("BuildHistory/RedoButton", func() -> void: redo_requested.emit())
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
	(get_node("BuildHistory") as Control).visible = is_build
	(get_node("BuildHistory/UndoButton") as Button).disabled = not is_build or not bool(_model.get("undo_enabled", false))
	(get_node("BuildHistory/RedoButton") as Button).disabled = not is_build or not bool(_model.get("redo_enabled", false))
	(get_node("BuildHistory/Status") as Label).text = (
		"최근 편집 복구 가능" if bool(_model.get("undo_enabled", false))
		else "취소한 편집 재적용 가능" if bool(_model.get("redo_enabled", false))
		else "되돌릴 편집이 없습니다"
	)
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
		"남은 시간 %.1f초 · 미배송 %d" % [
			float(_model.get("time_remaining", 0.0)),
			maxi(int(_model.get("remaining_map_cargo", 0)), 0) + maxi(int(_model.get("stack_size", 0)), 0),
		]
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

	var tokens: Array = _model.get("stack_tokens", [])
	var manifest := get_node("StackPanel/StackLayout/StackText") as RichTextLabel
	var stack_text := _stack_text(tokens)
	if manifest.text != stack_text:
		manifest.text = stack_text
	(get_node("StackPanel/StackLayout/TopSummary") as Label).text = (
		"하역 중 · 실제 적재 %d" % int(_model.get("stack_size", 0))
		if bool(_model.get("unload_visual_active", false))
		else _top_summary(tokens, int(_model.get("stack_size", tokens.size())))
	)
	(get_node("ProblemBanner/ProblemLayout/ProblemText") as Label).text = _problem_text(
		StringName(_model.get("primary_reason", &""))
	)

	if is_result:
		var success: bool = phase == &"SUCCESS"
		var failure_reason: StringName = StringName(_model.get("primary_reason", &"TIME_EXPIRED"))
		(get_node("ResultPanel/ResultLayout/ResultTitle") as Label).text = "배송 완료" if success else "배송 실패"
		(get_node("ResultPanel/ResultLayout/ResultBody") as Label).text = (
			"모든 화물을 제한 시간 안에 배송했습니다.\n최종 건설비 %d" % int(_model.get("final_cost", 0))
			if success
			else _failure_body(failure_reason)
		)
		(get_node("ResultPanel/ResultLayout/RetryButton") as Button).visible = bool(_model.get("retry_visible", true))
		(get_node("ResultPanel/ResultLayout/EditButton") as Button).visible = bool(_model.get("edit_visible", true))

	_apply_semantic_model()
	_apply_stage_visibility_gate()


func apply_stage_visibility(visible_features: Array) -> void:
	_stage_visibility_active = true
	_stage_features.clear()
	for value: Variant in visible_features:
		_stage_features[StringName(value)] = true
	_apply_stage_visibility_gate()


func reset_stage_visibility() -> void:
	_stage_visibility_active = false
	_stage_features.clear()
	for path: NodePath in [
		"BuildToolbar/StraightButton",
		"BuildToolbar/CurveButton",
		"BuildToolbar/SwitchButton",
		"BuildToolbar/CrossingButton",
		"BuildToolbar/RecommendButton",
		"BuildToolbar/RotateButton",
		"BuildToolbar/RemoveButton",
		"BuildToolbar/ClearButton",
		"RunToolbar/LoadButton",
		"RunToolbar/ManualSemanticBadge",
		"RunToolbar/AutoButton",
		"RunToolbar/AutoSemanticBadge",
		"TopStatus/TimeLabel",
	]:
		var item := get_node_or_null(path) as CanvasItem
		if item != null:
			item.visible = true
	apply_model(_model)


func _apply_stage_visibility_gate() -> void:
	if not _stage_visibility_active:
		return
	(get_node("BuildHistory") as Control).visible = StringName(_model.get("phase", &"BUILD")) == &"BUILD" and _stage_features.has(&"BUILD_HISTORY")
	_set_stage_visible("BuildToolbar/StraightButton", &"STRAIGHT")
	_set_stage_visible("BuildToolbar/CurveButton", &"CURVE")
	_set_stage_visible("BuildToolbar/SwitchButton", &"SWITCH")
	_set_stage_visible("BuildToolbar/CrossingButton", &"CROSSING")
	_set_stage_visible("BuildToolbar/RecommendButton", &"RECOMMENDED_LAYOUT")
	_set_stage_visible("BuildToolbar/RotateButton", &"ROTATE")
	_set_stage_visible("BuildToolbar/RemoveButton", &"REMOVE")
	_set_stage_visible("BuildToolbar/ClearButton", &"CLEAR")
	_set_stage_visible("RunToolbar/LoadButton", &"LOAD")
	_set_stage_visible("RunToolbar/ManualSemanticBadge", &"LOAD")
	_set_stage_visible("RunToolbar/AutoButton", &"AUTO_LOAD")
	_set_stage_visible("RunToolbar/AutoSemanticBadge", &"AUTO_LOAD")
	var phase := StringName(_model.get("phase", &"BUILD"))
	var run_visible: bool = phase == &"RUNNING" or phase == &"UNLOADING" or phase == &"PAUSED"
	(get_node("StackPanel") as Control).visible = run_visible and _stage_features.has(&"STACK_TOP")
	(get_node("TopStatus/TimeLabel") as Control).visible = _stage_features.has(&"TIME")


func _set_stage_visible(path: NodePath, feature: StringName) -> void:
	var item := get_node_or_null(path) as CanvasItem
	if item != null:
		item.visible = _stage_features.has(feature)


func model_for_test() -> Dictionary:
	return _model.duplicate(true)


func semantic_state_for_test() -> Dictionary:
	return _semantic_state.duplicate(true)


func _apply_semantic_model() -> void:
	var stack_state: StringName = SemanticRuntimeStateScript.stack_primary_state(_model)
	var manual_state: StringName = SemanticRuntimeStateScript.manual_load_state(_model)
	var auto_state: StringName = SemanticRuntimeStateScript.auto_load_state(_model)
	var preflight_state: StringName = SemanticRuntimeStateScript.preflight_summary_state(_model)

	var stack_record := _stack_record(stack_state)
	var manual_record: Dictionary = _composition(&"load_mode", manual_state)
	var auto_record: Dictionary = _composition(&"load_mode", auto_state)
	var preflight_record: Dictionary = _composition(&"preflight_notice", preflight_state)

	_set_semantic_badge("StackPanel/StackLayout/StackSemanticBadge", stack_record)
	_set_semantic_badge("RunToolbar/ManualSemanticBadge", manual_record)
	_set_semantic_badge("RunToolbar/AutoSemanticBadge", auto_record)
	_set_semantic_badge("ProblemBanner/ProblemLayout/ProblemSemanticBadge", preflight_record)

	_semantic_state = {
		"stack_state": stack_state,
		"stack_paths": _input_paths(stack_record),
		"manual_state": manual_state,
		"manual_paths": _input_paths(manual_record),
		"auto_state": auto_state,
		"auto_paths": _input_paths(auto_record),
		"preflight_state": preflight_state,
		"preflight_paths": _input_paths(preflight_record),
	}


func _stack_record(state: StringName) -> Dictionary:
	match state:
		&"empty":
			return _base_slice_record(&"run_stack_empty_v01")
		&"32plus":
			return _base_slice_record(&"run_stack_32plus_v01")
		&"unloading":
			return _base_slice_record(&"run_stack_unloading_v01")
		_:
			return _composition(&"stack_hud", state)


func _base_slice_record(slice_name: StringName) -> Dictionary:
	if _catalog == null or not _catalog.is_ready():
		return {}
	var asset: Dictionary = _catalog.base_asset_by_authoritative_slice(slice_name)
	var path := str(asset.get("path", ""))
	if path == "":
		return {}
	return {"inputs": [path]}


func _composition(component: StringName, state: StringName) -> Dictionary:
	if _catalog == null or not _catalog.is_ready() or state == &"":
		return {}
	return _catalog.composition(component, state)


func _set_semantic_badge(path: NodePath, record: Dictionary) -> void:
	var badge: Variant = get_node_or_null(path)
	if badge == null or not badge.has_method("set_textures"):
		return
	var textures: Array[Texture2D] = []
	if _catalog != null and _catalog.is_ready():
		textures = _catalog.textures_for(record)
	badge.set_textures(textures)


static func _input_paths(record: Dictionary) -> Array[String]:
	var result: Array[String] = []
	var inputs: Variant = record.get("inputs", [])
	if not inputs is Array:
		return result
	for path: Variant in inputs:
		result.append(str(path))
	return result


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


static func _failure_body(failure_reason: StringName) -> String:
	if failure_reason == &"ROUTE_END":
		return "더 진행할 수 있는 연결 선로가 없습니다.\n분기 방향과 종착 노선을 다시 확인하세요."
	return "제한 시간이 종료되었습니다.\n화물 TOP과 역 방문 순서를 다시 확인하세요."


static func _stack_text(tokens: Array) -> String:
	if tokens.is_empty():
		return "비어 있음"
	var labels: Array[String] = []
	for value: Variant in tokens:
		var token: Dictionary = value
		var cargo_type: StringName = StringName(token.get("cargo_type", &""))
		var label := _cargo_name(cargo_type)
		if bool(token.get("top", false)):
			label += "  ← TOP"
		labels.append(label)
	return "\n".join(labels)


static func _top_summary(tokens: Array, total: int) -> String:
	if tokens.is_empty():
		return "비어 있음 · 전체 %d" % total
	var top_type := StringName(tokens.back().get("cargo_type", &""))
	var count := 0
	for index in range(tokens.size() - 1, -1, -1):
		if StringName(tokens[index].get("cargo_type", &"")) != top_type:
			break
		count += 1
	return "TOP %s × %d\n전체 %d" % [_cargo_name(top_type), count, total]


static func _cargo_name(cargo_type: StringName) -> String:
	match cargo_type:
		&"RED_STAR": return "A · 별"
		&"BLUE_DIAMOND": return "B · 다이아"
		&"YELLOW_TRIANGLE": return "C · 삼각"
		&"WASTE_CRATE": return "폐기물 · 처리장"
	return "알 수 없는 화물"


static func _problem_text(code: StringName) -> String:
	match code:
		&"UNREACHABLE_CARGO":
			return "화물까지 갈 수 없습니다\n표시된 화물 칸을 지나는 선로를 출발점과 연결하세요"
		&"UNREACHABLE_STATION_SERVICE":
			return "역 옆까지 갈 수 없습니다\n역의 상하좌우 한 칸에 연결하세요 · 역 위·대각선은 제외"
		&"DANGLING_EDGE":
			return "선로 끝이 맞물리지 않습니다\n표시된 선로를 회전하거나 이어 붙이세요"
		&"PERMANENT_TRAP":
			return "진행 방향이 막혀 있습니다\n표시된 칸에서 앞으로 나갈 선로를 연결하세요"
		&"DISCONNECTED", &"UNREACHABLE", &"DISCONNECTED_REQUIRED_POINT":
			return "연결되지 않은 역 또는 화물이 있습니다"
		&"MISSING_START", &"START_DISCONNECTED", &"INVALID_START":
			return "출발 선로가 연결되지 않았습니다\n출발점의 진입 방향에 맞춰 선로를 연결하세요"
		&"INVALID_CROSSING":
			return "교차 선로의 연결이 부족합니다\n표시된 교차 칸의 네 방향을 모두 연결하세요"
		&"INVALID_SWITCH_EXIT":
			return "분기 선로의 출구가 막혀 있습니다\n표시된 분기의 세 방향과 각 출구 다음 선로를 확인하세요"
		&"INVALID_TRACK":
			return "분기·교차 선로의 연결 방향을 확인해 주세요"
		&"NOT_READY", &"EMPTY_LAYOUT":
			return "아직 배치한 선로가 없습니다\n선로 도구를 선택하고 출발점부터 연결하세요"
		_:
			return "노선을 확인해 주세요"


func _connect_button(path: NodePath, callback: Callable) -> void:
	var button := get_node(path) as Button
	button.pressed.connect(callback)
