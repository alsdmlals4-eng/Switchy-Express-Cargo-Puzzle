extends "res://tests/test_case.gd"

const DEMO_PATH := "res://game/demo/vertical_slice_demo.tscn"
const MAIN_PATH := "res://game/main/main.tscn"


func run() -> void:
	var tree := Engine.get_main_loop() as SceneTree
	assert_not_null(tree, "flow test requires SceneTree")
	if tree == null:
		return

	var demo_scene: PackedScene = load(DEMO_PATH)
	var demo: Control = demo_scene.instantiate()
	tree.root.add_child(demo)
	assert_false(demo.first_session_enabled, "standalone demo remains opt-out")
	demo.start_demo()
	demo.begin_build()
	assert_equal(demo.state(), &"GAMEPLAY", "standalone title/briefing/gameplay path remains")
	assert_equal(
		demo.gameplay_instance().session_controller().render_snapshot().get("map_id"),
		&"VS_DEMO_01",
		"standalone demo still loads VS_DEMO_01"
	)
	demo.free()

	var main_scene: PackedScene = load(MAIN_PATH)
	var main: Control = main_scene.instantiate()
	tree.root.add_child(main)
	var first_session := main.get_node("VerticalSliceDemo")
	assert_true(first_session.first_session_enabled, "product main opts into first session")
	assert_equal(
		(first_session.get_node("TitleScreen/Panel/Content/StartButton") as Button).text,
		"첫 배송 시작",
		"first-session title uses localized CTA"
	)
	assert_false(
		(first_session.get_node("TitleScreen/Panel/Content/SliceBadge") as Label).visible,
		"internal vertical-slice badge is hidden in product entry"
	)
	first_session.start_demo()
	assert_equal(first_session.state(), &"BRIEFING", "first-session title opens lesson card")
	var lesson_art := first_session.get_node("BriefingScreen/Panel/Content/LessonArt")
	assert_true(lesson_art.has_method("asset_paths_for_test"), "lesson art exposes its active asset path")
	if lesson_art.has_method("asset_paths_for_test"):
		assert_equal(
			lesson_art.asset_paths_for_test(),
			["art/product_assets/ed_hybrid_v1/shells/shell_lesson_hero_v01.png"],
			"T1 keeps the neutral lesson hero instead of showing the T2 station-service illustration"
		)
	assert_equal(
		(first_session.get_node("BriefingScreen/Panel/Content/Title") as Label).text,
		"선로 연결",
		"first lesson card renders T1 title"
	)
	main.free()
