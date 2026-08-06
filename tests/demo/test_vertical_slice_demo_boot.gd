extends "res://tests/test_case.gd"

const DEMO_SCENE_PATH := "res://game/demo/vertical_slice_demo.tscn"


func run() -> void:
	var packed: PackedScene = load(DEMO_SCENE_PATH)
	assert_not_null(packed, "vertical slice demo scene must load")
	if packed == null:
		return

	var demo: Control = packed.instantiate()
	var tree := Engine.get_main_loop() as SceneTree
	assert_not_null(tree, "demo boot test requires SceneTree")
	if tree == null:
		demo.free()
		return
	tree.root.add_child(demo)

	assert_true(demo.has_method("state"), "demo root must expose flow state")
	assert_equal(demo.state(), &"TITLE", "F6 demo scene must boot TITLE")
	assert_not_null(demo.get_node_or_null("TitleScreen"), "demo requires TitleScreen")
	assert_not_null(demo.get_node_or_null("ControlsOverlay"), "demo requires ControlsOverlay")
	assert_not_null(demo.get_node_or_null("BriefingScreen"), "demo requires BriefingScreen")
	assert_not_null(demo.get_node_or_null("GameplayContainer"), "demo requires GameplayContainer")
	assert_not_null(demo.get_node_or_null("PauseOverlay"), "demo requires PauseOverlay")
	assert_not_null(demo.get_node_or_null("ResultOverlay"), "demo requires ResultOverlay")

	var project_file := FileAccess.open("res://project.godot", FileAccess.READ)
	assert_not_null(project_file, "project.godot must remain readable")
	if project_file != null:
		var project_text := project_file.get_as_text()
		assert_true(
			project_text.contains('run/main_scene="res://game/main/main.tscn"'),
			"demo work must not change the default main scene"
		)

	demo.free()
