extends "res://tests/test_case.gd"


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
