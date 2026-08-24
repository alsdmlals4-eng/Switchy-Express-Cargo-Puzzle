extends "res://tests/test_case.gd"

const RendererScript := preload("res://game/demo/presentation/product_board_renderer.gd")
const HUD_SCENE_PATH := "res://game/demo/presentation/product_hud.tscn"
const SHELL_SCENE_PATH := "res://game/demo/vertical_slice_demo.tscn"


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
	]
	if renderer.has_method("product_visual_asset_paths_for_test"):
		var paths: Dictionary = renderer.product_visual_asset_paths_for_test()
		for required: String in required_board_art:
			assert_true(paths.has(required), "POC board art mapping must contain %s" % required)
			if paths.has(required):
				assert_true(
					str(paths[required]).begins_with("art/product_assets/ed_hybrid_v1/"),
					"%s must use approved E+D product assets" % required
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

	var result_art := shell.get_node_or_null("ResultOverlay/Panel/Content/ResultArt")
	assert_true(
		result_art != null and result_art.has_method("set_result_outcome"),
		"result art must support outcome-specific approved feedback"
	)
	if result_art != null and result_art.has_method("set_result_outcome"):
		result_art.set_result_outcome(&"SUCCESS")
		var success_paths: Array = result_art.asset_paths_for_test()
		assert_true(
			success_paths.has("art/product_assets/ed_hybrid_v1/shells/shell_result_success_candidate_v01.png"),
			"successful POC result must use approved success result art"
		)
		assert_false(
			success_paths.has("art/product_assets/ed_hybrid_v1/shells/shell_result_failure_candidate_v01.png"),
			"success result must not show failure result art"
		)
		result_art.set_result_outcome(&"FAILURE")
		var failure_paths: Array = result_art.asset_paths_for_test()
		assert_true(
			failure_paths.has("art/product_assets/ed_hybrid_v1/shells/shell_result_failure_candidate_v01.png"),
			"failed POC result must use approved failure result art"
		)
		assert_false(
			failure_paths.has("art/product_assets/ed_hybrid_v1/shells/shell_result_success_candidate_v01.png"),
			"failure result must not show success result art"
		)

	var progress := shell.get_node_or_null("BriefingScreen/Panel/Content/LessonProgress") as Label
	assert_not_null(progress, "first-session briefing must expose visible lesson progress")
	if progress != null:
		assert_true(progress.text.contains("1 / 7"), "first-session briefing starts at lesson 1 of 7")
	shell.free()
