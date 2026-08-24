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

	assert_true(hud.has_method("semantic_state_for_test"), "HUD must expose bounded semantic diagnostics")
	assert_not_null(hud.get_node_or_null("StackPanel/StackLayout/StackSemanticBadge"), "HUD must include Stack semantic badge")
	assert_not_null(hud.get_node_or_null("RunToolbar/ManualSemanticBadge"), "HUD must include manual-load semantic badge")
	assert_not_null(hud.get_node_or_null("RunToolbar/AutoSemanticBadge"), "HUD must include auto-load semantic badge")
	var problem_layout := hud.get_node_or_null("ProblemBanner/ProblemLayout") as HBoxContainer
	var problem_badge := hud.get_node_or_null("ProblemBanner/ProblemLayout/ProblemSemanticBadge") as Control
	var problem_text := hud.get_node_or_null("ProblemBanner/ProblemLayout/ProblemText") as Label
	assert_not_null(problem_layout, "preflight banner must use a horizontal layout")
	assert_not_null(problem_badge, "HUD must include preflight semantic badge")
	assert_not_null(problem_text, "HUD must include preflight problem text")
	if problem_badge != null:
		assert_equal(problem_badge.custom_minimum_size, Vector2(112, 48), "preflight badge keeps native semantic component footprint")
	if problem_text != null:
		assert_equal(problem_text.size_flags_horizontal, Control.SIZE_EXPAND_FILL, "preflight text owns remaining banner width")

	var build_model := _model(&"BUILD")
	hud.apply_model(build_model)
	assert_equal(hud.get_node("TopStatus/PhaseLabel").text, "건설 단계", "BUILD phase uses Korean copy")
	assert_equal(hud.get_node("BuildToolbar/StartButton").text, "운행 시작  Space", "start button shows action and shortcut")
	assert_true(hud.get_node("BuildToolbar").visible, "BUILD toolbar visible during BUILD")
	assert_false(hud.get_node("RunToolbar").visible, "RUN toolbar hidden during BUILD")
	assert_false(
		(hud.get_node("ProblemBanner/ProblemLayout/ProblemText") as Label).text.contains("Disconnected route"),
		"preflight detail must not leak diagnostic English"
	)
	if hud.has_method("semantic_state_for_test"):
		var primary_semantic: Dictionary = hud.semantic_state_for_test()
		assert_equal(primary_semantic.get("preflight_state", &""), &"primary_issue", "failed BUILD selects primary preflight semantic state")
		assert_equal(
			primary_semantic.get("preflight_paths", []),
			[
				"art/product_assets/ed_hybrid_v1/build/build_preflight_shell_v01.png",
				"art/product_assets/ed_hybrid_v1/build/build_preflight_primary_issue_marker_v01.png",
			],
			"primary preflight semantic inputs come from BUILD manifest"
		)

	var multi_build := _model(&"BUILD")
	multi_build["problem_cells"] = [Vector2i(4, 4), Vector2i(5, 4)]
	hud.apply_model(multi_build)
	if hud.has_method("semantic_state_for_test"):
		var multi_semantic: Dictionary = hud.semantic_state_for_test()
		assert_equal(multi_semantic.get("preflight_state", &""), &"multi_issue_summary", "multiple BUILD issues select multi summary")

	var clear_build := _model(&"BUILD")
	clear_build["start_enabled"] = true
	clear_build["problem_cells"] = []
	hud.apply_model(clear_build)
	if hud.has_method("semantic_state_for_test"):
		var clear_semantic: Dictionary = hud.semantic_state_for_test()
		assert_equal(clear_semantic.get("preflight_state", &""), &"clear", "passed BUILD selects clear preflight semantic state")
		assert_equal(
			clear_semantic.get("preflight_paths", []),
			["art/product_assets/ed_hybrid_v1/build/build_preflight_shell_v01.png"],
			"clear preflight keeps the approved shell"
		)

	var running_model := _model(&"RUNNING")
	running_model["manual_load_active"] = true
	hud.apply_model(running_model)
	assert_equal(hud.get_node("TopStatus/PhaseLabel").text, "운행 중", "RUNNING phase uses Korean copy")
	assert_true(hud.get_node("RunToolbar").visible, "RUN toolbar visible during RUNNING")
	assert_true(hud.get_node("StackPanel").visible, "stack panel visible during RUNNING")
	assert_true(hud.get_node("StackPanel/StackLayout/StackTitle").text.contains("화물 TOP"), "stack title explains TOP")
	if hud.has_method("semantic_state_for_test"):
		var running_semantic: Dictionary = hud.semantic_state_for_test()
		assert_equal(running_semantic.get("stack_state", &""), &"compact", "small non-empty stack selects compact semantic state")
		assert_equal(
			running_semantic.get("stack_paths", []),
			["art/product_assets/ed_hybrid_v1/run/run_stack_compact_v01.png"],
			"compact Stack resolves exact approved semantic asset"
		)
		assert_equal(running_semantic.get("manual_state", &""), &"manual_held", "manual hold selects held semantic state")
		assert_equal(
			running_semantic.get("manual_paths", []),
			[
				"art/product_assets/ed_hybrid_v1/run/run_load_mode_shell_v01.png",
				"art/product_assets/ed_hybrid_v1/run/run_load_mode_manual_marker_v01.png",
				"art/product_assets/ed_hybrid_v1/run/run_load_mode_held_marker_v01.png",
			],
			"manual held composition preserves manifest order"
		)
		assert_equal(running_semantic.get("auto_state", &""), &"auto_on", "active auto load selects auto-on semantic state")
		assert_equal(
			running_semantic.get("auto_paths", []),
			[
				"art/product_assets/ed_hybrid_v1/run/run_load_mode_shell_v01.png",
				"art/product_assets/ed_hybrid_v1/run/run_load_mode_on_marker_v01.png",
				"art/product_assets/ed_hybrid_v1/run/run_load_mode_auto_marker_v01.png",
			],
			"auto-on composition preserves approved manifest order"
		)

	hud.apply_model(_model(&"UNLOADING"))
	assert_equal(hud.get_node("TopStatus/PhaseLabel").text, "하역 중", "UNLOADING phase uses Korean copy")

	hud.apply_model(_model(&"PAUSED"))
	assert_equal(hud.get_node("TopStatus/PhaseLabel").text, "일시정지", "PAUSED phase uses Korean copy")
	assert_true(hud.get_node("PausePanel").visible, "standalone HUD pause panel remains available")
	if hud.has_method("semantic_state_for_test"):
		var paused_semantic: Dictionary = hud.semantic_state_for_test()
		assert_equal(paused_semantic.get("stack_state", &""), &"paused", "PAUSED selects paused Stack semantic state")
		assert_equal(
			paused_semantic.get("stack_paths", []),
			["art/product_assets/ed_hybrid_v1/run/run_stack_paused_v01.png"],
			"paused Stack resolves approved asset"
		)
		assert_equal(paused_semantic.get("manual_state", &""), &"paused_disabled", "PAUSED disables manual semantic state")
		assert_equal(paused_semantic.get("auto_state", &""), &"paused_disabled", "PAUSED disables auto semantic state")
		assert_equal(
			paused_semantic.get("manual_paths", []),
			[
				"art/product_assets/ed_hybrid_v1/run/run_load_mode_shell_v01.png",
				"art/product_assets/ed_hybrid_v1/run/run_load_mode_disabled_overlay_v01.png",
			],
			"paused load semantic composition uses shell plus disabled overlay"
		)

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
		"start_enabled": false,
		"editing_enabled": phase == &"BUILD",
		"primary_reason": &"DISCONNECTED",
		"status_text": "Disconnected route",
		"problem_cells": [Vector2i(4, 4)],
		"current_cost": 3200,
		"recommended_cost": 4500,
		"final_cost": 3200,
		"time_remaining": 75.4,
		"auto_load_active": true,
		"manual_load_active": false,
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
