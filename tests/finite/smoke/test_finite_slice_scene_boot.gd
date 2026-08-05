extends "res://tests/test_case.gd"

const VIEW_SCENE_PATH := "res://game/finite/presentation/finite_slice_view.tscn"
const VIEW_SCRIPT_PATH := "res://game/finite/presentation/finite_slice_view.gd"
const PRESENTER_PATH := "res://game/finite/presentation/finite_slice_presenter.gd"
const MAIN_SCENE_PATH := "res://game/finite/main/finite_slice.tscn"
const MAIN_SCRIPT_PATH := "res://game/finite/main/finite_slice.gd"
const MIN_TOUCH_TARGET := 48.0


func run() -> void:
	var required_paths: Array[String] = [
		VIEW_SCENE_PATH,
		VIEW_SCRIPT_PATH,
		PRESENTER_PATH,
		MAIN_SCENE_PATH,
		MAIN_SCRIPT_PATH,
	]
	for path: String in required_paths:
		assert_true(ResourceLoader.exists(path), "%s must exist" % path)
	if not _all_exist(required_paths):
		return

	var packed: PackedScene = load(MAIN_SCENE_PATH)
	assert_not_null(packed, "finite slice main scene must load")
	if packed == null:
		return
	var instance: Control = packed.instantiate()
	assert_equal(instance.name, "FiniteSlice", "finite slice root name must be stable")
	assert_true(instance.has_method("phase"), "finite slice root must expose current phase")
	assert_equal(instance.phase(), &"BUILD", "finite slice must boot in BUILD")

	var view: Control = instance.get_node_or_null("View")
	assert_not_null(view, "finite slice must contain the presentation view")
	if view == null:
		instance.free()
		return
	assert_true(view.has_method("apply_model"), "finite slice view must accept presenter models")
	assert_equal(view.anchor_right, 1.0, "view must stretch to viewport width")
	assert_equal(view.anchor_bottom, 1.0, "view must stretch to viewport height")

	var required_nodes: Array[String] = [
		"Board",
		"TopBar/PhaseLabel",
		"TopBar/CostLabel",
		"TopBar/TimeLabel",
		"TopBar/StatusLabel",
		"StackPanel/StackLabel",
		"BuildTools/StraightButton",
		"BuildTools/CurveButton",
		"BuildTools/SwitchPieceButton",
		"BuildTools/CrossingButton",
		"BuildTools/RotateButton",
		"BuildTools/RemoveButton",
		"BuildTools/ClearButton",
		"BuildTools/StartButton",
		"RunTools/LoadButton",
		"RunTools/AutoButton",
		"RunTools/SwitchButton",
		"RunTools/PauseButton",
		"RunTools/ResumeButton",
		"ResultPanel/RetryButton",
		"ResultPanel/EditButton",
		"ResultPanel/ResultLabel",
	]
	for node_path: String in required_nodes:
		assert_not_null(view.get_node_or_null(node_path), "view must expose %s" % node_path)

	var buttons: Array[Button] = []
	_collect_buttons(view, buttons)
	assert_true(buttons.size() >= 15, "finite slice must expose the approved command surface")
	for button: Button in buttons:
		assert_greater_equal(
			button.custom_minimum_size.x,
			MIN_TOUCH_TARGET,
			"%s must meet 48dp-equivalent width" % button.name
		)
		assert_greater_equal(
			button.custom_minimum_size.y,
			MIN_TOUCH_TARGET,
			"%s must meet 48dp-equivalent height" % button.name
		)
		assert_false(button.text.strip_edges().is_empty(), "%s must have a visible text label" % button.name)

	var board: Control = view.get_node("Board")
	assert_true(board.mouse_filter != Control.MOUSE_FILTER_IGNORE, "board must remain touch-interactive")
	var load_button: Button = view.get_node("RunTools/LoadButton")
	assert_equal(load_button.action_mode, BaseButton.ACTION_MODE_BUTTON_PRESS, "load hold must react on press")
	instance.free()


func _all_exist(paths: Array[String]) -> bool:
	for path: String in paths:
		if not ResourceLoader.exists(path):
			return false
	return true


func _collect_buttons(node: Node, result: Array[Button]) -> void:
	if node is Button:
		result.append(node)
	for child: Node in node.get_children():
		_collect_buttons(child, result)
