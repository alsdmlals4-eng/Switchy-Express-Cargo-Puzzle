extends "res://tests/test_case.gd"

const HUD_SCENE_PATH := "res://game/demo/presentation/product_hud.tscn"
const BANNED_TEXT: Array[String] = [
	"PHASE",
	"CLOCK",
	"STACK",
	"SUCCESS",
	"FAILURE",
	"Train running",
	"Time expired",
	"Disconnected route",
]


func run() -> void:
	var packed: PackedScene = load(HUD_SCENE_PATH)
	assert_not_null(packed, "product HUD scene must load")
	if packed == null:
		return
	var hud: Control = packed.instantiate()
	var tree := Engine.get_main_loop() as SceneTree
	assert_not_null(tree, "HUD test requires SceneTree")
	if tree == null:
		hud.free()
		return
	tree.root.add_child(hud)

	assert_true(hud.has_method("apply_model"), "HUD must consume presenter model")
	if not hud.has_method("apply_model"):
		hud.free()
		return

	hud.apply_model(_model(&"BUILD"))
	assert_equal(hud.get_node("TopStatus/PhaseLabel").text, "건설 단계", "BUILD phase uses Korean copy")
	assert_equal(hud.get_node("BuildToolbar/StartButton").text, "운행 시작  Space", "start button shows action and shortcut")
	assert_true(hud.get_node("BuildToolbar").visible, "BUILD toolbar visible during BUILD")
	assert_false(hud.get_node("RunToolbar").visible, "RUN toolbar hidden during BUILD")
	assert_false(
		(hud.get_node("ProblemBanner/ProblemText") as Label).text.contains("Disconnected route"),
		"preflight detail must not leak diagnostic English"
	)

	hud.apply_model(_model(&"RUNNING"))
	assert_equal(hud.get_node("TopStatus/PhaseLabel").text, "운행 중", "RUNNING phase uses Korean copy")
	assert_true(hud.get_node("RunToolbar").visible, "RUN toolbar visible during RUNNING")
	assert_true(hud.get_node("StackPanel").visible, "stack panel visible during RUNNING")
	assert_true(hud.get_node("StackPanel/StackLayout/StackTitle").text.contains("화물 TOP"), "stack title explains TOP")

	hud.apply_model(_model(&"UNLOADING"))
	assert_equal(hud.get_node("TopStatus/PhaseLabel").text, "하역 중", "UNLOADING phase uses Korean copy")

	hud.apply_model(_model(&"PAUSED"))
	assert_equal(hud.get_node("TopStatus/PhaseLabel").text, "일시정지", "PAUSED phase uses Korean copy")
	assert_true(hud.get_node("PausePanel").visible, "standalone HUD pause panel remains available")

	hud.apply_model(_model(&"SUCCESS"))
	assert_equal(hud.get_node("ResultPanel/ResultLayout/ResultTitle").text, "배송 완료", "success uses Korean copy")
	assert_true(hud.get_node("ResultPanel").visible, "standalone HUD success panel remains available")

	hud.apply_model(_model(&"FAILURE"))
	assert_equal(hud.get_node("ResultPanel/ResultLayout/ResultTitle").text, "배송 실패", "failure uses Korean copy")
	assert_true(hud.get_node("ResultPanel/ResultLayout/ResultBody").text.contains("제한 시간"), "failure explains time expiry")

	var all_text: String = _collect_label_and_button_text(hud)
	for banned: String in BANNED_TEXT:
		assert_false(all_text.contains(banned), "HUD must not expose diagnostic English: %s" % banned)

	var start_events: Array[StringName] = []
	hud.start_requested.connect(func() -> void: start_events.append(&"START"))
	hud.get_node("BuildToolbar/StartButton").pressed.emit()
	assert_equal(start_events, [&"START"], "HUD start button emits finite command signal")

	for button: Button in _buttons(hud):
		assert_true(button.custom_minimum_size.x >= 48.0, "%s width meets touch minimum" % button.name)
		assert_true(button.custom_minimum_size.y >= 48.0, "%s height meets touch minimum" % button.name)

	hud.free()


func _model(phase: StringName) -> Dictionary:
	return {
		"phase": phase,
		"start_enabled": true,
		"editing_enabled": phase == &"BUILD",
		"primary_reason": &"DISCONNECTED",
		"status_text": "Disconnected route",
		"problem_cells": [Vector2i(4, 4)],
		"current_cost": 3200,
		"recommended_cost": 4500,
		"final_cost": 3200,
		"time_remaining": 75.4,
		"auto_load_active": true,
		"stack_tokens": [
			{"cargo_type": &"RED_STAR", "top": false},
			{"cargo_type": &"BLUE_DIAMOND", "top": true},
		],
		"retry_visible": phase == &"SUCCESS" or phase == &"FAILURE",
		"edit_visible": phase == &"SUCCESS" or phase == &"FAILURE",
	}


func _collect_label_and_button_text(node: Node) -> String:
	var result := ""
	if node is Label:
		result += node.text + "\n"
	elif node is Button:
		result += node.text + "\n"
	for child: Node in node.get_children():
		result += _collect_label_and_button_text(child)
	return result


func _buttons(node: Node) -> Array[Button]:
	var result: Array[Button] = []
	if node is Button:
		result.append(node)
	for child: Node in node.get_children():
		result.append_array(_buttons(child))
	return result
