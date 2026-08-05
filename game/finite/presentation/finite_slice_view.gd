class_name FiniteSliceView
extends Control

signal build_tool_selected(tool: StringName)
signal rotate_requested
signal remove_requested
signal clear_requested
signal start_requested
signal load_active_changed(active: bool)
signal auto_toggle_requested
signal switch_requested
signal pause_requested
signal resume_requested
signal retry_requested
signal edit_requested

var _last_model: Dictionary = {}


func _ready() -> void:
	_connect_commands()
	if not _last_model.is_empty():
		_apply_to_nodes(_last_model)


func apply_model(model: Dictionary) -> void:
	_last_model = model.duplicate(true)
	if is_node_ready():
		_apply_to_nodes(_last_model)


func last_model() -> Dictionary:
	return _last_model.duplicate(true)


func _apply_to_nodes(model: Dictionary) -> void:
	var phase := StringName(model.get("phase", &"BUILD"))
	var is_build := phase == &"BUILD"
	var is_result := phase == &"SUCCESS" or phase == &"FAILURE"
	var is_run := not is_build and not is_result

	_get_label("TopBar/PhaseLabel").text = "PHASE · %s" % str(phase)
	_get_label("TopBar/CostLabel").text = _cost_text(model, is_result)
	_get_label("TopBar/TimeLabel").text = _time_text(model)
	_get_label("TopBar/StatusLabel").text = str(model.get("status_text", ""))
	_get_label("StackPanel/StackLabel").text = _stack_text(model.get("stack_tokens", []))

	var build_tools: Control = get_node("BuildTools")
	var run_tools: Control = get_node("RunTools")
	var result_panel: Control = get_node("ResultPanel")
	build_tools.visible = is_build
	run_tools.visible = is_run
	result_panel.visible = is_result

	_set_build_controls(bool(model.get("editing_enabled", false)))
	_get_button("BuildTools/StartButton").disabled = not bool(model.get("start_enabled", false))
	_get_button("RunTools/LoadButton").disabled = not bool(model.get("load_enabled", false))
	_get_button("RunTools/AutoButton").disabled = not bool(model.get("auto_enabled", false))
	_get_button("RunTools/SwitchButton").disabled = not bool(model.get("switch_enabled", false))
	_get_button("RunTools/PauseButton").visible = bool(model.get("pause_visible", false))
	_get_button("RunTools/ResumeButton").visible = bool(model.get("resume_visible", false))
	_get_button("RunTools/AutoButton").text = (
		"AUTO · ON" if bool(model.get("auto_load_active", false)) else "AUTO · OFF"
	)

	_get_button("ResultPanel/RetryButton").visible = bool(model.get("retry_visible", false))
	_get_button("ResultPanel/EditButton").visible = bool(model.get("edit_visible", false))
	_get_label("ResultPanel/ResultLabel").text = _result_text(model)

	var board: Control = get_node("Board")
	board.tooltip_text = _problem_cells_text(model.get("problem_cells", []))


func _connect_commands() -> void:
	_get_button("BuildTools/StraightButton").pressed.connect(
		func() -> void: build_tool_selected.emit(&"STRAIGHT")
	)
	_get_button("BuildTools/CurveButton").pressed.connect(
		func() -> void: build_tool_selected.emit(&"CURVE")
	)
	_get_button("BuildTools/SwitchPieceButton").pressed.connect(
		func() -> void: build_tool_selected.emit(&"SWITCH")
	)
	_get_button("BuildTools/CrossingButton").pressed.connect(
		func() -> void: build_tool_selected.emit(&"CROSSING")
	)
	_get_button("BuildTools/RotateButton").pressed.connect(
		func() -> void: rotate_requested.emit()
	)
	_get_button("BuildTools/RemoveButton").pressed.connect(
		func() -> void: remove_requested.emit()
	)
	_get_button("BuildTools/ClearButton").pressed.connect(
		func() -> void: clear_requested.emit()
	)
	_get_button("BuildTools/StartButton").pressed.connect(
		func() -> void: start_requested.emit()
	)
	_get_button("RunTools/LoadButton").button_down.connect(
		func() -> void: load_active_changed.emit(true)
	)
	_get_button("RunTools/LoadButton").button_up.connect(
		func() -> void: load_active_changed.emit(false)
	)
	_get_button("RunTools/AutoButton").pressed.connect(
		func() -> void: auto_toggle_requested.emit()
	)
	_get_button("RunTools/SwitchButton").pressed.connect(
		func() -> void: switch_requested.emit()
	)
	_get_button("RunTools/PauseButton").pressed.connect(
		func() -> void: pause_requested.emit()
	)
	_get_button("RunTools/ResumeButton").pressed.connect(
		func() -> void: resume_requested.emit()
	)
	_get_button("ResultPanel/RetryButton").pressed.connect(
		func() -> void: retry_requested.emit()
	)
	_get_button("ResultPanel/EditButton").pressed.connect(
		func() -> void: edit_requested.emit()
	)


func _set_build_controls(enabled: bool) -> void:
	for child: Node in get_node("BuildTools").get_children():
		if child is Button and child.name != "StartButton":
			child.disabled = not enabled


func _get_label(path: String) -> Label:
	return get_node(path) as Label


func _get_button(path: String) -> Button:
	return get_node(path) as Button


static func _cost_text(model: Dictionary, is_result: bool) -> String:
	if is_result:
		return "FINAL COST · %d" % int(model.get("final_cost", 0))
	var current := int(model.get("current_cost", 0))
	var recommended := int(model.get("recommended_cost", 0))
	if recommended > 0:
		return "COST · %d / GUIDE %d" % [current, recommended]
	return "COST · %d" % current


static func _time_text(model: Dictionary) -> String:
	var phase := StringName(model.get("phase", &"BUILD"))
	if phase == &"BUILD":
		return "CLOCK · PAUSED"
	var remaining := float(model.get("time_remaining", 0.0))
	if phase == &"SUCCESS" or phase == &"FAILURE":
		remaining = maxf(
			float(model.get("time_limit", 0.0)) - float(model.get("completion_time", 0.0)),
			0.0
		)
	return "TIME · %.2f" % remaining


static func _stack_text(tokens: Array) -> String:
	if tokens.is_empty():
		return "STACK · EMPTY"
	var parts: Array[String] = []
	for token: Dictionary in tokens:
		var shape := _shape_symbol(StringName(token.get("shape", &"")))
		var top_suffix := " · TOP" if bool(token.get("top", false)) else ""
		parts.append("%s %s%s" % [shape, str(token.get("label", "")), top_suffix])
	return "STACK · " + "  |  ".join(parts)


static func _result_text(model: Dictionary) -> String:
	var phase := StringName(model.get("phase", &"BUILD"))
	if phase == &"SUCCESS":
		return "SUCCESS\nCompletion %.2fs · Commit %.2fs\nFinal cost %d" % [
			float(model.get("completion_time", 0.0)),
			float(model.get("commit_time", -1.0)),
			int(model.get("final_cost", 0)),
		]
	if phase == &"FAILURE":
		return "FAILURE\nTime expired\nKeep route and retry, or edit the layout"
	return ""


static func _problem_cells_text(cells: Array) -> String:
	if cells.is_empty():
		return "Track construction board"
	var parts: Array[String] = []
	for cell: Variant in cells:
		parts.append("(%d,%d)" % [cell.x, cell.y])
	return "Problem cells: " + ", ".join(parts)


static func _shape_symbol(shape: StringName) -> String:
	match shape:
		&"STAR":
			return "★"
		&"DIAMOND":
			return "◆"
		&"TRIANGLE":
			return "▲"
		_:
			return "●"
