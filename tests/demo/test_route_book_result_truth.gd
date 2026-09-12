extends "res://tests/test_case.gd"

const Demo := preload("res://game/demo/vertical_slice_demo.tscn")
const Copy := preload("res://game/first_session/first_session_copy.gd")


func run() -> void:
	var copy := Copy.new()
	assert_true(copy.load_default(), "common result copy loads")
	var demo: Variant = Demo.instantiate()
	(Engine.get_main_loop() as SceneTree).root.add_child(demo)
	for locale: String in ["ko", "en", "ja", "zh-Hans"]:
		demo.first_session_locale = locale
		demo.return_to_title()
		demo.open_route_book()
		assert_true(demo.select_route_book(&"ROUTE_BOOK_02"), "book selection")
		assert_true(demo.select_route_book_stage(&"RB08_CAUTION_CUT"), "stage selection")
		demo.begin_build()
		for reason: StringName in [&"ROUTE_END", &"TIME_EXPIRED", &"UNKNOWN"]:
			demo.show_result({"outcome": &"FAILURE", "failure_reason": reason,
				"completion_time": 18.0, "time_limit_seconds": 90.0,
				"remaining_map_cargo": 2, "stack_size": 1})
			var title: String = demo.get_node("ResultOverlay/Panel/Content/Title").text
			var expected_key: StringName = &"SX_RESULT_FAILURE"
			if reason == &"ROUTE_END": expected_key = &"SX_RESULT_ROUTE_END"
			if reason == &"TIME_EXPIRED": expected_key = &"SX_RESULT_TIME_EXPIRED"
			assert_false(copy.text(expected_key, locale).is_empty(), "reason text exists")
			assert_equal(title, copy.text(expected_key, locale), "actual reason in " + locale)
			var body: String = demo.get_node("ResultOverlay/Panel/Content/BodyScroll/Body").text
			assert_true(body.contains(copy.format(&"SX_RESULT_MAP_CARGO", {"count":2}, locale)), "remaining ground cargo")
			assert_true(body.contains(copy.format(&"SX_RESULT_STACK_CARGO", {"count":1}, locale)), "actual stack count")
			assert_true(body.contains("18.0") and body.contains("72.0"), "retains elapsed and remaining time")
			assert_false(body.contains("제한 시간이 종료되었습니다"), "no hardcoded false time cause")
			var edit: Button = demo.get_node("ResultOverlay/Panel/Content/Actions/EditButton")
			assert_true(edit.visible, "Route Book does not inherit tutorial edit lock")
			assert_equal(edit.text, copy.text(&"SX_RESULT_EDIT", locale), "localized Edit")
			assert_equal(demo.get_node("ResultOverlay/Panel/Content/Actions/TitleButton").text, copy.text(&"SX_RESULT_TITLE", locale), "localized Title")
			assert_equal(demo.get_node("ResultOverlay/Panel/Content/Actions/RetryButton").text, copy.text(&"SX_RESULT_RETRY", locale), "localized Retry")
			edit.pressed.emit()
			assert_equal(demo.state(), &"GAMEPLAY", "Edit restores flow before next result")
		demo.show_result({"outcome": &"SUCCESS", "completion_time": 18.0, "time_limit_seconds":90.0})
		assert_equal(demo.get_node("ResultOverlay/Panel/Content/Title").text, copy.text(&"SX_RESULT_SUCCESS",locale), "success title remains localized")
	demo.first_session_locale = "ko"
	demo.return_to_title()
	demo.start_demo()
	demo.begin_build()
	demo.show_result({"outcome": &"FAILURE", "failure_reason": &"ROUTE_END"})
	assert_equal(demo.get_node("ResultOverlay/Panel/Content/Title").text, "노선이 끝났습니다.", "standalone fallback also uses true reason")
	demo.free()
