extends "res://tests/test_case.gd"

const RendererScript := preload("res://game/demo/presentation/product_board_renderer.gd")
const HUD_SCENE_PATH := "res://game/demo/presentation/product_hud.tscn"
const SHELL_SCENE_PATH := "res://game/demo/vertical_slice_demo.tscn"
const TITLE_HERO_PATH := "art/product_assets/ed_hybrid_v1/shells/shell_title_hero_v01.png"


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
				assert_true(
					str(paths[required]).begins_with("art/product_assets/ed_hybrid_v2/"),
					"%s must use the approved Core Board v02 product assets" % required
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
		NodePath("TitleScreen/Panel"),
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
		"TitleScreen/Panel/Content/HeroArt",
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
						str(value).begins_with("art/product_assets/ed_hybrid_v1/"),
						"shell visual must use approved E+D product assets"
					)
			if art.has_method("loaded_asset_count_for_test") and art.has_method("asset_paths_for_test"):
				assert_equal(
					int(art.loaded_asset_count_for_test()),
					(art.asset_paths_for_test() as Array).size(),
					"all shell product-art textures must load"
				)

	var title_art := shell.get_node_or_null("TitleScreen/Panel/Content/HeroArt")
	assert_not_null(title_art, "title screen must expose its runtime hero-art consumer")
	if title_art != null and title_art.has_method("asset_paths_for_test"):
		assert_equal(
			title_art.asset_paths_for_test(),
			[TITLE_HERO_PATH],
			"title hero must load exactly one generated, text-free runtime banner"
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
			assert_equal(
				lesson_art.asset_paths_for_test(),
				["art/product_assets/ed_hybrid_v1/shells/shell_lesson_hero_v01.png"],
				"non-T2 lessons keep the neutral shared HeroArt"
			)
			if lesson_art.has_method("set_lesson_id"):
				lesson_art.set_lesson_id(&"T2")
				assert_equal(
					lesson_art.asset_paths_for_test(),
					["art/product_assets/ed_hybrid_v1/shells/shell_lesson_hero_v02.png"],
					"T2 uses the cardinal-station-service HeroArt rather than the shared HeroArt"
				)
				assert_equal(
					int(lesson_art.loaded_asset_count_for_test()),
					1,
					"T2 cardinal-station-service HeroArt must load as a Texture2D, not only resolve a path"
				)
		result_art.set_result_outcome(&"SUCCESS")
		var success_paths: Array = result_art.asset_paths_for_test()
		assert_true(
			success_paths.has("art/product_assets/ed_hybrid_v1/shells/shell_result_success_v02.png"),
			"successful POC result must use its scene-scale success art"
		)
		assert_false(
			success_paths.has("art/product_assets/ed_hybrid_v1/shells/shell_result_failure_v02.png"),
			"success result must not show failure result art"
		)
		result_art.set_result_outcome(&"FAILURE")
		var failure_paths: Array = result_art.asset_paths_for_test()
		assert_true(
			failure_paths.has("art/product_assets/ed_hybrid_v1/shells/shell_result_failure_v02.png"),
			"failed POC result must use its scene-scale failure art"
		)
		assert_false(
			failure_paths.has("art/product_assets/ed_hybrid_v1/shells/shell_result_success_v02.png"),
			"failure result must not show success result art"
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
