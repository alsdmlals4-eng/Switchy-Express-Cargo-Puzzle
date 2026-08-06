extends "res://tests/test_case.gd"

const MainScene := preload("res://game/main/main.tscn")


func run() -> void:
	assert_equal(
		ProjectSettings.get_setting("application/config/name", ""),
		"Switchy Express: Cargo Puzzle",
		"application name must match the confirmed title"
	)
	assert_equal(
		ProjectSettings.get_setting("application/run/main_scene", ""),
		"res://game/main/main.tscn",
		"main scene must be registered"
	)
	assert_equal(
		ProjectSettings.get_setting("display/window/size/viewport_width", 0),
		1920,
		"viewport width must be 1920"
	)
	assert_equal(
		ProjectSettings.get_setting("display/window/size/viewport_height", 0),
		1080,
		"viewport height must be 1080"
	)
	assert_equal(
		ProjectSettings.get_setting("display/window/handheld/orientation", -1),
		0,
		"mobile orientation must be landscape"
	)
	assert_equal(
		ProjectSettings.get_setting("display/window/stretch/mode", ""),
		"canvas_items",
		"stretch mode must use canvas_items"
	)
	assert_true(
		ResourceLoader.exists("res://game/main/main.tscn", "PackedScene"),
		"main scene resource must exist"
	)

	var tree := Engine.get_main_loop() as SceneTree
	assert_not_null(tree, "project boot test requires SceneTree")
	if tree == null:
		return
	var main := MainScene.instantiate()
	tree.root.add_child(main)
	var demo := main.get_node_or_null("VerticalSliceDemo")
	assert_not_null(demo, "default project Play must boot the vertical slice without scene setup")
	if demo != null:
		assert_true(demo.has_method("state"), "default product boot must expose demo flow state")
		assert_equal(demo.state(), &"TITLE", "default project Play must open the demo title")
		demo.start_demo()
		assert_equal(demo.state(), &"BRIEFING", "default project Play flow must enter briefing")
		demo.begin_build()
		assert_equal(demo.state(), &"GAMEPLAY", "default project Play flow must enter gameplay")
		var product := demo.gameplay_instance() as Control
		assert_not_null(product, "default project Play must create the playable product slice")
		if product != null:
			var hud := product.get_node_or_null("HUD") as Control
			var toolbar := product.get_node_or_null("HUD/BuildToolbar") as Control
			assert_not_null(hud, "default project Play must include the product HUD")
			assert_not_null(toolbar, "default project Play must include the BUILD toolbar")
			if hud != null:
				assert_true(hud.is_visible_in_tree(), "default product HUD must be visible")
			if toolbar != null:
				assert_true(toolbar.is_visible_in_tree(), "default BUILD toolbar must be visible")
	main.free()
