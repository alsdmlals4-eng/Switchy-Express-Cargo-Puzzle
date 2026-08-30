extends "res://tests/test_case.gd"

const DemoScene := preload("res://game/demo/vertical_slice_demo.tscn")


func run() -> void:
	var tree := Engine.get_main_loop() as SceneTree
	assert_not_null(tree, "Route Book flow test requires SceneTree")
	if tree == null:
		return
	var demo: Control = DemoScene.instantiate()
	tree.root.add_child(demo)
	assert_true(demo.has_method("open_route_book"), "demo exposes the Route Book entry")
	assert_true(demo.has_method("select_route_book"), "demo exposes Route Book selection")
	assert_true(demo.has_method("select_route_book_stage"), "demo exposes fixed-stage selection")
	assert_true(demo.has_method("current_route_book_id_for_test"), "demo exposes selected Route Book identity")
	assert_true(demo.has_method("current_route_book_stage_id_for_test"), "demo exposes selected stage for regression tests")
	if not demo.has_method("open_route_book"):
		demo.free()
		return

	demo.open_route_book()
	assert_equal(demo.state(), &"ROUTE_BOOK", "title opens Route Book selection")
	var stage_list := demo.get_node_or_null("RouteBookScreen/Panel/Content/StageScroll/StageList") as VBoxContainer
	assert_not_null(stage_list, "Route Book has a dedicated selection list")
	if stage_list != null:
		assert_equal(stage_list.get_child_count(), 2, "both authored Route Books are directly selectable")
	assert_false(demo.select_route_book(&"UNKNOWN"), "unknown Route Book is rejected")
	var route_book_02_card := stage_list.get_node_or_null("ROUTE_BOOK_02Card") as Button if stage_list != null else null
	assert_not_null(route_book_02_card, "Wayside Route Book has a concrete selection card")
	if route_book_02_card != null:
		route_book_02_card.pressed.emit()
	else:
		assert_true(demo.select_route_book(&"ROUTE_BOOK_02"), "Wayside Route Book is selectable")
	assert_equal(demo.current_route_book_id_for_test(), &"ROUTE_BOOK_02", "selected Route Book identity remains exact")
	if stage_list != null:
		assert_equal(stage_list.get_child_count(), 6, "all six Route Book 02 stages are directly selectable")
	assert_false(demo.select_route_book_stage(&"UNKNOWN"), "unknown Route Book stage is rejected")
	var salvage_card := stage_list.get_node_or_null("RB09_SALVAGE_SIDINGCard") as Button if stage_list != null else null
	assert_not_null(salvage_card, "Salvage Siding has a concrete stage card")
	if salvage_card != null:
		salvage_card.pressed.emit()
	else:
		assert_true(demo.select_route_book_stage(&"RB09_SALVAGE_SIDING"), "known card selects Route Book stage")
	assert_equal(demo.state(), &"BRIEFING", "selected Route Book stage reuses briefing")
	assert_equal(demo.current_route_book_stage_id_for_test(), &"RB09_SALVAGE_SIDING", "selected stage identity remains exact")
	demo.begin_build()
	assert_equal(demo.state(), &"GAMEPLAY", "Route Book briefing begins gameplay")
	var product: Control = demo.gameplay_instance()
	assert_equal(
		StringName(product.session_controller().render_snapshot().get("map_id", &"")),
		&"RB09_SALVAGE_SIDING",
		"selected Route Book map reaches the real product slice",
	)
	assert_false(
		(product.get_node("HUD/BuildToolbar/RecommendButton") as Button).visible,
		"Route Book never shows a recommended layout",
	)
	demo.show_result({"outcome": &"SUCCESS"})
	var next := demo.get_node_or_null("ResultOverlay/Panel/Content/RouteBookActions/NextStageButton") as Button
	var stage_book := demo.get_node_or_null("ResultOverlay/Panel/Content/RouteBookActions/StageBookButton") as Button
	assert_not_null(next, "Route Book result has a Next Stage action")
	assert_not_null(stage_book, "Route Book result has a Stage Book action")
	if next != null:
		assert_true(next.visible, "success before stage six exposes Next Stage")
	if stage_book != null:
		assert_true(stage_book.visible, "Route Book result exposes Stage Book")
	if next != null:
		next.pressed.emit()
	else:
		assert_true(demo.open_next_route_book_stage(), "success selects the next fixed stage")
	assert_equal(demo.state(), &"BRIEFING", "Next Stage returns to the reused briefing")
	assert_equal(demo.current_route_book_stage_id_for_test(), &"RB10_CLEAN_BREAK", "Next Stage follows declared order")
	demo.begin_build()
	demo.show_result({"outcome": &"SUCCESS"})
	if stage_book != null:
		stage_book.pressed.emit()
	assert_equal(demo.state(), &"ROUTE_BOOK", "Stage Book returns to direct selection")
	demo.free()
