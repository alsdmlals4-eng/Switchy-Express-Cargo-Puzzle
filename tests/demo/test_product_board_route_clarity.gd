# 런타임 선로 상태 가시성 계약을 검증하는 제품 보드 테스트입니다.
extends "res://tests/test_case.gd"

const RendererScript := preload("res://game/demo/presentation/product_board_renderer.gd")


func run() -> void:
	var renderer: Control = RendererScript.new()
	renderer.apply_snapshot(_running_snapshot())
	assert_true(
		renderer.has_method("route_visual_descriptors_for_test"),
		"board renderer must expose runtime route-visibility descriptors"
	)
	if renderer.has_method("route_visual_descriptors_for_test"):
		var descriptors: Array = renderer.route_visual_descriptors_for_test()
		assert_equal(_state_at(descriptors, Vector2i(1, 1)), &"SELECTED", "start route must be selected")
		assert_equal(_state_at(descriptors, Vector2i(2, 1)), &"OCCUPIED_LOCKED", "locked control must outrank selected route")
		assert_equal(_state_at(descriptors, Vector2i(3, 1)), &"SELECTED", "selected exit must remain selected")
		assert_equal(_state_at(descriptors, Vector2i(2, 0)), &"UNSELECTED", "alternate exit must remain visibly distinct")
		var result_snapshot := _running_snapshot()
		result_snapshot["phase"] = &"SUCCESS"
		renderer.apply_snapshot(result_snapshot)
		var result_descriptors: Array = renderer.route_visual_descriptors_for_test()
		assert_equal(_state_at(result_descriptors, Vector2i(1, 1)), &"SELECTED", "result keeps the selected route trace")
		assert_equal(_state_at(result_descriptors, Vector2i(3, 1)), &"SELECTED", "result keeps selected exit trace")

	assert_true(
		renderer.has_method("route_visual_widths_for_test"),
		"renderer must expose resolution-aware route hierarchy diagnostics"
	)
	if renderer.has_method("route_visual_widths_for_test"):
		for viewport: Vector2 in [Vector2(960.0, 540.0), Vector2(1280.0, 720.0), Vector2(1920.0, 1080.0)]:
			var widths: Dictionary = renderer.route_visual_widths_for_test(viewport, Vector2i(11, 9))
			var selected := float(widths.get(&"SELECTED", 0.0))
			var locked := float(widths.get(&"OCCUPIED_LOCKED", 0.0))
			var unselected := float(widths.get(&"UNSELECTED", 0.0))
			assert_true(selected > locked, "selected route must be thicker than locked route")
			assert_true(locked > unselected, "locked route must be thicker than unselected route")
			assert_true(selected >= 5.0, "selected route must remain readable at every supported viewport")
	renderer.free()


static func _running_snapshot() -> Dictionary:
	return {
		"phase": &"RUNNING",
		"board_size": Vector2i(5, 3),
		"incoming_cell": Vector2i(0, 1),
		"start_cell": Vector2i(1, 1),
		"layout_pieces": [
			{"cell": Vector2i(2, 1), "geometry": &"SWITCH", "rotation_quarters": 0, "switch_initial_exit": Vector2i.RIGHT},
			{"cell": Vector2i(3, 1), "geometry": &"STRAIGHT", "rotation_quarters": 0, "switch_initial_exit": Vector2i.ZERO},
			{"cell": Vector2i(2, 0), "geometry": &"STRAIGHT", "rotation_quarters": 1, "switch_initial_exit": Vector2i.ZERO},
		],
		"route_controls": [{
			"cell": Vector2i(2, 1),
			"kind": &"SWITCH",
			"approach_port": Vector2i.LEFT,
			"available_exits": [Vector2i.UP, Vector2i.RIGHT, Vector2i.LEFT],
			"selected_exit": Vector2i.RIGHT,
			"locked": true,
		}],
	}


static func _state_at(descriptors: Array, cell: Vector2i) -> StringName:
	for value: Variant in descriptors:
		if value is Dictionary and value.get("cell") == cell:
			return StringName(value.get("state", &""))
	return &""
