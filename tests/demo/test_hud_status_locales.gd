extends "res://tests/test_case.gd"

const Demo := preload("res://game/demo/vertical_slice_demo.tscn")


func run() -> void:
	var demo: Control = Demo.instantiate()
	(Engine.get_main_loop() as SceneTree).root.add_child(demo)
	var rows := [
		["ko", "건설 단계", "운행 중", "메뉴", "미배송 5"],
		["en", "Build", "Running", "Menu", "Undelivered 5"],
		["ja", "建設", "運行中", "メニュー", "未配送 5"],
		["zh-Hans", "建造", "运行中", "菜单", "未配送 5"]]
	for row: Array in rows:
		demo.first_session_locale = row[0]
		demo.return_to_title()
		demo.open_route_book()
		assert_true(demo.select_route_book(&"ROUTE_BOOK_02"), "select book")
		assert_true(demo.select_route_book_stage(&"RB08_CAUTION_CUT"), "select stage")
		demo.begin_build()
		var hud: Control = demo.gameplay_instance().get_node("HUD")
		assert_equal(hud.get_node("TopStatus/PhaseLabel").text, row[1], "shell locale reaches build status")
		assert_equal(hud.get_node("TopStatus/MenuButton").text, row[3], "menu locale")
		var design_instruction: String = hud.get_node("TopStatus/TimeLabel").text
		assert_false(design_instruction.is_empty(), "build guidance exists")
		hud.apply_model({"phase":&"RUNNING", "time_remaining":12.5,
			"remaining_map_cargo":2, "stack_size":3, "current_cost":1100, "recommended_cost":4500})
		assert_equal(hud.get_node("TopStatus/PhaseLabel").text, row[2], "running status locale")
		var time: String = hud.get_node("TopStatus/TimeLabel").text
		assert_true(time.contains("12.5") and time.contains(row[4]), "actual time and unresolved total")
		var cost: String = hud.get_node("TopStatus/CostLabel").text
		assert_true(cost.contains("1100") and cost.contains("4500"), "both cost meanings retained")
		assert_equal(hud.model_for_test().get("stack_size"), 3, "presentation does not alter model")
		var phases := {"ko":["하역 중", "일시정지", "배송 완료", "배송 실패", "배송 준비"],
			"en":["Unloading", "Paused", "Delivery Complete", "Delivery Failed", "Preparing"],
			"ja":["荷下ろし中", "一時停止", "配送完了", "配送失敗", "配送準備"],
			"zh-Hans":["卸货中", "已暂停", "配送完成", "配送失败", "准备配送"]}
		var phase_ids := [&"UNLOADING", &"PAUSED", &"SUCCESS", &"FAILURE", &"UNKNOWN"]
		for i: int in range(phase_ids.size()):
			hud.apply_model({"phase":phase_ids[i]})
			assert_equal(hud.get_node("TopStatus/PhaseLabel").text, phases[row[0]][i], "phase uses correct message")
			if i >= 2:
				assert_equal(hud.get_node("TopStatus/TimeLabel").text, "", "terminal or unknown phase cannot instruct building")
			else:
				assert_true(hud.get_node("TopStatus/TimeLabel").text.contains("0.0"), "active or paused timer remains factual")
		hud.apply_model({"phase":&"BUILD"})
		assert_equal(hud.get_node("TopStatus/TimeLabel").text, design_instruction, "edit restores design guidance")
	demo.free()
	_complete_hud()


func _complete_hud() -> void:
	var names := {"ko":["직선", "자동 적재 켬", "별", "다이아", "삼각", "폐기물", "비어 있음"],
		"en":["Straight", "Auto ON", "Star", "Diamond", "Triangle", "Waste", "Empty"],
		"ja":["直線", "自動積載 ON", "星", "ダイヤ", "三角", "廃棄物", "空"],
		"zh-Hans":["直线", "自动装载 开", "星", "菱形", "三角", "废物", "空"]}
	for language: String in names:
		var hud: Control = preload("res://game/demo/presentation/product_hud.tscn").instantiate()
		hud.locale = language
		(Engine.get_main_loop() as SceneTree).root.add_child(hud)
		assert_true(hud.get_node("BuildToolbar/StraightButton").text.contains(names[language][0]), "localized tool")
		var empty_history: String = hud.get_node("BuildHistory/Status").text
		hud.apply_model({"phase": &"BUILD", "undo_enabled":true})
		assert_false(hud.get_node("BuildHistory/Status").text == empty_history, "undo availability has distinct feedback")
		assert_false(hud.get_node("BuildHistory/UndoButton").disabled, "translation preserves undo availability")
		var undo_history: String = hud.get_node("BuildHistory/Status").text
		hud.apply_model({"phase":&"BUILD", "redo_enabled":true})
		assert_true(hud.get_node("BuildHistory/UndoButton").disabled and not hud.get_node("BuildHistory/RedoButton").disabled, "redo-only state")
		assert_true(hud.get_node("BuildHistory/Status").text != undo_history and hud.get_node("BuildHistory/Status").text != empty_history, "redo feedback distinct")
		var tokens: Array = []
		var types := [&"RED_STAR", &"BLUE_DIAMOND", &"YELLOW_TRIANGLE", &"WASTE_CRATE"]
		for i: int in range(64):
			tokens.append({"cargo_type":types[i % 4], "top": i == 63})
		var model := {"phase":&"RUNNING", "auto_load_active":true, "stack_tokens":tokens, "stack_size":64}
		hud.apply_model(model)
		assert_equal(hud.model_for_test(), model, "locale formatting cannot mutate model")
		assert_true(hud.get_node("RunToolbar/AutoButton").text.contains(names[language][1]), "auto state selected language")
		var auto_on: String = hud.get_node("RunToolbar/AutoButton").text
		var manifest: RichTextLabel = hud.get_node("StackPanel/StackLayout/StackText")
		assert_equal(manifest.text.split("\n").size(), 64, "all64 cargo rows retained")
		assert_true(manifest.scroll_active, "unbounded cargo list remains scrollable")
		for i: int in range(4):
			assert_true(manifest.text.split("\n")[i].contains(names[language][i + 2]), "cargo type retains language and load order")
		assert_true(manifest.text.split("\n")[63].contains("TOP"), "last loaded remains TOP")
		var summary: String = hud.get_node("StackPanel/StackLayout/TopSummary").text
		assert_true(summary.contains(names[language][5]) and summary.contains("× 1") and summary.contains("64"), "TOP group is contiguous not total type count")
		hud.apply_model({"phase":&"RUNNING", "stack_tokens":[], "stack_size":0})
		assert_true(manifest.text.contains(names[language][6]), "empty manifest localized")
		assert_not_equal(hud.get_node("RunToolbar/AutoButton").text, auto_on, "Auto OFF distinct from ON")
		hud.apply_model({"phase":&"UNLOADING", "stack_tokens":tokens, "stack_size":3, "unload_visual_active":true})
		assert_true(hud.get_node("StackPanel/StackLayout/TopSummary").text.contains("3"), "unload uses actual count")
		assert_false(hud.get_node("StackPanel/StackLayout/TopSummary").text.contains("64"), "unload does not count departing visual tokens")
		for reason: StringName in [&"UNREACHABLE_CARGO", &"UNREACHABLE_STATION_SERVICE", &"DANGLING_EDGE", &"PERMANENT_TRAP", &"MISSING_START", &"INVALID_CROSSING", &"INVALID_SWITCH_EXIT", &"EMPTY_LAYOUT", &"UNKNOWN"]:
			hud.apply_model({"phase":&"BUILD", "primary_reason":reason})
			var problem: String = hud.get_node("ProblemBanner/ProblemLayout/ProblemText").text
			assert_false(problem.is_empty(), "every repair reason nonempty")
			if language == "en":
				assert_false(problem.contains("선로") or problem.contains("주세요") or problem.contains("없습니다"), "English repair cannot fall back to Korean")
		hud.apply_model({"phase":&"FAILURE", "primary_reason":&"UNKNOWN"})
		var body: String = hud.get_node("ResultPanel/ResultLayout/ResultBody").text
		assert_false(body.contains("제한 시간이 종료") or body.contains("Time expired"), "unknown failure must not invent timeout")
		hud.apply_model({"phase":&"FAILURE", "primary_reason":&"TIME_EXPIRED"})
		var time_body: String = hud.get_node("ResultPanel/ResultLayout/ResultBody").text
		assert_not_equal(time_body, body, "known timeout distinct from unknown")
		hud.apply_model({"phase":&"FAILURE", "primary_reason":&"ROUTE_END"})
		assert_not_equal(hud.get_node("ResultPanel/ResultLayout/ResultBody").text, time_body, "route end is not timeout")
		hud.apply_model({"phase":&"SUCCESS", "final_cost":1234})
		assert_true(hud.get_node("ResultPanel/ResultLayout/ResultBody").text.contains("1234"), "success uses actual final cost")
		hud.free()
