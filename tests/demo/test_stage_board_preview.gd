extends "res://tests/test_case.gd"

const Demo := preload("res://game/demo/vertical_slice_demo.tscn")

func run() -> void:
	var demo: Variant = Demo.instantiate()
	demo.first_session_enabled = true
	(Engine.get_main_loop() as SceneTree).root.add_child(demo)
	demo.open_route_book()
	demo.select_route_book(&"ROUTE_BOOK_02")
	demo.select_route_book_stage(&"RB08_CAUTION_CUT")
	var preview: Variant = demo.get_node_or_null("BriefingScreen/Panel/Content/MapPreview")
	assert_not_null(preview, "selected stage has an actual map preview")
	if preview == null:
		demo.free()
		return
	var board: Variant = preview.get_node("Board")
	var snapshot: Dictionary = board.snapshot_for_test()
	assert_true(preview.visible, "stage preview is visible")
	assert_equal(snapshot.get("map_id"), &"RB08_CAUTION_CUT", "preview loads selected map")
	assert_equal(snapshot.get("board_size"), Vector2i(11, 7), "preview preserves board dimensions")
	assert_equal(snapshot.get("cargo_placements", []).size(), 2, "preview shows actual cargo")
	assert_equal(snapshot.get("station_placements", []).size(), 2, "preview shows actual stations")
	assert_equal(snapshot.get("caution_track_cells", []).size(), 2, "preview shows caution choice")
	assert_equal(snapshot.get("layout_pieces", []).size(), 0, "no solution rails are disclosed")
	assert_true(demo.gameplay_instance() == null, "preview does not start gameplay")
	assert_equal(board.mouse_filter, Control.MOUSE_FILTER_IGNORE, "preview ignores pointer input")
	assert_equal(board.focus_mode, Control.FOCUS_NONE, "preview does not steal focus")
	demo.begin_build()
	assert_equal(demo.gameplay_instance().session_controller().render_snapshot().get("map_id"), &"RB08_CAUTION_CUT", "Begin uses same map")
	demo.show_result({"outcome": &"SUCCESS"})
	assert_true(demo.open_next_route_book_stage(), "Next opens following briefing")
	assert_equal(board.snapshot_for_test().get("map_id"), &"RB09_SALVAGE_SIDING", "Next refreshes preview")
	assert_false(preview.show_map(""), "empty map fails closed")
	assert_true(board.snapshot_for_test().is_empty(), "invalid map clears stale preview")
	assert_false(preview.visible, "invalid preview hides")
	assert_true(preview.show_map("res://data/maps/route_book/rb12_lantern_loop.json"), "valid map recovers after invalid input")
	assert_equal(board.snapshot_for_test().get("map_id"), &"RB12_LANTERN_LOOP", "recovery uses new map")
	preview.custom_minimum_size = Vector2.ZERO
	for bounds: Vector2 in [Vector2(632, 360), Vector2(632, 250), Vector2(300, 200)]:
		preview.size = bounds
		var horizontal: Vector2 = board.cell_center_global(Vector2i(1, 0)) - board.cell_center_global(Vector2i.ZERO)
		var vertical: Vector2 = board.cell_center_global(Vector2i(0, 1)) - board.cell_center_global(Vector2i.ZERO)
		assert_true(is_equal_approx(horizontal.length(), vertical.length()), "preview preserves square cells on resize")
		assert_true(Rect2(Vector2.ZERO, bounds).encloses(Rect2(board.position, board.size)), "fitted board stays inside preview")
	demo.return_to_title()
	demo.start_demo()
	assert_false(preview.visible, "tutorial hides Route Book preview")
	assert_true(demo.get_node("BriefingScreen/Panel/Content/LessonArt").visible, "tutorial restores approved lesson illustration")
	demo.free()
