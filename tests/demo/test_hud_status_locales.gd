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
	demo.free()
