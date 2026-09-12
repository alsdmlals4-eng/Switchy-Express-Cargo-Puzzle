extends "res://tests/test_case.gd"

const RendererScript := preload("res://game/demo/presentation/product_board_renderer.gd")
const HUD_SCENE_PATH := "res://game/demo/presentation/product_hud.tscn"
const SHELL_SCENE_PATH := "res://game/demo/vertical_slice_demo.tscn"
const SHELL_BOARD_PATH := "art/product_assets/night_workshop_v1/board_slate.png"


func run() -> void:
	var renderer: Control = RendererScript.new()
	assert_true(
		renderer.has_method("product_visual_asset_paths_for_test"),
		"POC board renderer must expose the approved product-art mapping it renders"
	)
	var required_board_art: Array[String] = [
		"train",
		"rail_straight",
		"rail_curve",
		"rail_crossing",
		"rail_switch",
		"start_marker",
		"route_end_marker",
		"station_red",
		"station_blue",
		"station_yellow",
		"cargo_red",
		"cargo_blue",
		"cargo_yellow",
		"board_terrain",
	]
	if renderer.has_method("product_visual_asset_paths_for_test"):
		var paths: Dictionary = renderer.product_visual_asset_paths_for_test()
		for required: String in required_board_art:
			assert_true(paths.has(required), "POC board art mapping must contain %s" % required)
			if paths.has(required):
				if required == "board_terrain":
					assert_equal(str(paths[required]), "art/product_assets/night_workshop_v1/board_slate.png", "selected board pixels own the terrain slot")
					continue
				assert_true(
					(
						str(paths[required]) == "art/product_assets/night_workshop_v1/train.png"
						if required == "train"
						else str(paths[required]) == "art/product_assets/topdown_v1/%s.png" % required
						if required.begins_with("station_") or required.begins_with("cargo_")
						else str(paths[required]).begins_with("art/product_assets/ed_hybrid_v2/")
					),
					"%s must use its approved product asset family" % required
				)
	assert_true(
		renderer.has_method("loaded_product_visuals_for_test"),
		"POC board renderer must report whether approved textures actually loaded"
	)
	if renderer.has_method("loaded_product_visuals_for_test"):
		var loaded: Dictionary = renderer.loaded_product_visuals_for_test()
		for required: String in required_board_art:
			assert_true(bool(loaded.get(required, false)), "%s product texture must load" % required)
	renderer.free()

	var tree := Engine.get_main_loop() as SceneTree
	assert_not_null(tree, "POC visual integration test requires SceneTree")
	if tree == null:
		return

	var hud_packed: PackedScene = load(HUD_SCENE_PATH)
	assert_not_null(hud_packed, "POC HUD scene must load")
	if hud_packed != null:
		var hud: Control = hud_packed.instantiate()
		tree.root.add_child(hud)
		for path: NodePath in [
			"BuildToolbar/StraightButton",
			"BuildToolbar/CurveButton",
			"BuildToolbar/SwitchButton",
			"BuildToolbar/CrossingButton",
		]:
			var button := hud.get_node_or_null(path) as Button
			assert_not_null(button, "POC HUD tool button must exist: %s" % path)
			if button != null:
				assert_not_null(button.icon, "POC HUD tool button must display approved rail art: %s" % path)
				assert_true(button.custom_minimum_size.y >= 48.0, "POC HUD controls keep touch minimum")
		hud.free()

	var shell_packed: PackedScene = load(SHELL_SCENE_PATH)
	assert_not_null(shell_packed, "POC shell scene must load")
	if shell_packed == null:
		return
	var shell: Control = shell_packed.instantiate()
	shell.first_session_enabled = true
	tree.root.add_child(shell)
	for panel_path: NodePath in [
		NodePath("TitleScreen/TitleMargin/TitleColumns/TitleDeck"),
		NodePath("TitleScreen/TitleMargin/TitleColumns/ActionDeck"),
		NodePath("BriefingScreen/Panel"),
		NodePath("PauseOverlay/Panel"),
		NodePath("ExitConfirmOverlay/Panel"),
		NodePath("ResultOverlay/Panel"),
	]:
		var panel := shell.get_node_or_null(panel_path) as PanelContainer
		assert_not_null(panel, "shell control-deck panel must exist at %s" % panel_path)
		if panel != null:
			assert_equal(
				panel.theme_type_variation,
				&"ShellPanel",
				"shell panel must use the shared board-first control-deck variation at %s" % panel_path
			)
	for path: NodePath in [
		"TitleScreen/TitleBackdrop",
		"BriefingScreen/Panel/Content/LessonArt",
		"ResultOverlay/Panel/Content/ResultArt",
	]:
		var art := shell.get_node_or_null(path)
		assert_not_null(art, "playable POC shell must include product art at %s" % path)
		if art != null:
			assert_true(art.has_method("asset_paths_for_test"), "shell art must expose bounded asset diagnostics")
			if art.has_method("asset_paths_for_test"):
				var shell_paths: Array = art.asset_paths_for_test()
				assert_true(not shell_paths.is_empty(), "shell art must render at least one approved product asset")
				for value: Variant in shell_paths:
					assert_true(
						not str(value).contains("/shells/shell_"),
						"shell visual must not consume a legacy oblique hero"
					)
			if art.has_method("loaded_asset_count_for_test") and art.has_method("asset_paths_for_test"):
				assert_equal(
					int(art.loaded_asset_count_for_test()),
					(art.asset_paths_for_test() as Array).size(),
					"all shell product-art textures must load"
				)

	var title_art := shell.get_node_or_null("TitleScreen/TitleBackdrop")
	assert_not_null(title_art, "title screen must expose its runtime hero-art consumer")
	if title_art != null and title_art.has_method("asset_paths_for_test"):
		var title_paths: Array = title_art.asset_paths_for_test()
		assert_true(
			title_paths.has(SHELL_BOARD_PATH),
			"title backdrop composes the selected slate instead of a legacy scenic banner"
		)
		assert_true(
			title_paths.has("art/product_assets/night_workshop_v1/train.png"),
			"title backdrop keeps the approved overhead train"
		)

	var result_art := shell.get_node_or_null("ResultOverlay/Panel/Content/ResultArt")
	assert_true(
		result_art != null and result_art.has_method("set_result_outcome"),
		"result art must support outcome-specific approved feedback"
	)
	if result_art != null and result_art.has_method("set_result_outcome"):
		var lesson_art := shell.get_node_or_null("BriefingScreen/Panel/Content/LessonArt")
		assert_not_null(lesson_art, "lesson must retain its concrete runtime art consumer")
		if lesson_art != null and lesson_art.has_method("asset_paths_for_test"):
			var neutral_paths: Array = lesson_art.asset_paths_for_test()
			assert_true(
				neutral_paths.has("art/product_assets/topdown_v1/cargo_blue.png"),
				"non-T2 lessons use the neutral top-down cargo family"
			)
			if lesson_art.has_method("set_lesson_id"):
				lesson_art.set_lesson_id(&"T2")
				var t2_paths: Array = lesson_art.asset_paths_for_test()
				assert_true(
					t2_paths.has("art/product_assets/topdown_v1/station_red.png"),
					"T2 uses the top-down cardinal-service station composition"
				)
				assert_equal(
					int(lesson_art.loaded_asset_count_for_test()),
					t2_paths.size(),
					"every T2 composition layer must load as Texture2D"
				)
		result_art.set_result_outcome(&"SUCCESS")
		var success_paths: Array = result_art.asset_paths_for_test()
		assert_true(
			success_paths.has("art/product_assets/topdown_v1/station_blue.png"),
			"successful POC result uses its distinct top-down delivered-family composition"
		)
		assert_false(
			success_paths.has("art/product_assets/topdown_v1/station_disposal.png"),
			"success result must not show the failure composition's station"
		)
		result_art.set_result_outcome(&"FAILURE")
		var failure_paths: Array = result_art.asset_paths_for_test()
		assert_true(
			failure_paths.has("art/product_assets/topdown_v1/station_disposal.png"),
			"failed POC result uses its distinct top-down disposal-family composition"
		)
		assert_false(
			failure_paths.has("art/product_assets/topdown_v1/station_blue.png"),
			"failure result must not show the success composition's station"
		)

	var progress := shell.get_node_or_null("BriefingScreen/Panel/Content/LessonProgress") as Label
	assert_not_null(progress, "first-session briefing must expose visible lesson progress")
	if progress != null:
		assert_true(progress.text.contains("1 / 7"), "first-session briefing starts at lesson 1 of 7")
		assert_equal(
			progress.theme_type_variation,
			&"LessonFocusLabel",
			"lesson progress must use the bounded lesson-focus variation"
		)
	shell.free()
