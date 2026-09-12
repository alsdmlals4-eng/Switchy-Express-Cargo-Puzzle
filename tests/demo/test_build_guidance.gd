extends "res://tests/test_case.gd"

const Hud := preload("res://game/demo/presentation/product_hud.tscn")
const Presenter := preload("res://game/finite/presentation/finite_slice_presenter.gd")
const Validator := preload("res://game/finite/build/preflight_validator.gd")
const Fixtures := preload("res://tests/fixtures/finite/preflight_fixtures.gd")


func run() -> void:
	var hud: Variant = Hud.instantiate()
	(Engine.get_main_loop() as SceneTree).root.add_child(hud)
	var presenter: Variant = Presenter.new()
	var validator: Variant = Validator.new()
	var label: Label = hud.get_node("ProblemBanner/ProblemLayout/ProblemText")
	var messages: Dictionary = {}
	for case: Dictionary in Fixtures.cases():
		var fixture: Dictionary = Fixtures.make(case["name"])
		var result: Variant = validator.validate(fixture["definition"], fixture["layout"])
		presenter.show_build(result, 0, 0)
		hud.apply_model(presenter.model())
		assert_equal(hud.get_node("ProblemBanner").visible, not result.passed, "banner follows real validator")
		assert_equal(presenter.model()["problem_cells"], result.problem_cells, "guidance preserves actual board markers")
		if not result.passed:
			messages[result.primary_code] = label.text
			assert_false(label.text == "노선을 확인해 주세요", "actual failure %s needs specific repair guidance" % result.primary_code)
	assert_true(str(messages.get(&"UNREACHABLE_CARGO", "")).contains("화물 칸"), "cargo instruction uses exact cargo tile")
	assert_true(str(messages.get(&"UNREACHABLE_STATION_SERVICE", "")).contains("상하좌우"), "station instruction uses cardinal service")
	assert_true(str(messages.get(&"UNREACHABLE_STATION_SERVICE", "")).contains("대각선"), "station instruction excludes diagonal service")
	hud.apply_model({"phase": &"BUILD", "primary_reason": &"UNKNOWN", "start_enabled": false})
	assert_false(label.text.is_empty(), "unknown failure retains safe guidance")
	for phase: StringName in [&"RUNNING", &"UNLOADING", &"PAUSED", &"SUCCESS", &"FAILURE"]:
		hud.apply_model({"phase": phase, "primary_reason": &"UNREACHABLE_CARGO", "start_enabled": false})
		assert_false(hud.get_node("ProblemBanner").visible, "stale preflight never appears outside BUILD")
	hud.free()
	var product: Variant = preload("res://game/demo/product_finite_slice.tscn").instantiate()
	(Engine.get_main_loop() as SceneTree).root.add_child(product)
	var problem: Label = product.get_node("HUD/ProblemBanner/ProblemLayout/ProblemText")
	var empty_text: String = problem.text
	product.request_command(&"BUILD_TOOL", &"STRAIGHT")
	product.request_command(&"BOARD_CELL", Vector2i(2, 4))
	var edited_text: String = problem.text
	assert_false(edited_text == empty_text, "real edit replaces empty-layout guidance")
	product.request_command(&"UNDO")
	assert_equal(problem.text, empty_text, "undo refreshes empty-layout guidance")
	product.request_command(&"REDO")
	assert_equal(problem.text, edited_text, "redo restores current preflight guidance")
	product.free()
