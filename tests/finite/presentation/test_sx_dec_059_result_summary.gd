extends "res://tests/test_case.gd"

const PresenterScript := preload("res://game/finite/presentation/finite_slice_presenter.gd")
const SummaryScript := preload("res://game/finite/run/finite_run_summary.gd")


func run() -> void:
	var presenter: Variant = PresenterScript.new()
	var summary: Variant = SummaryScript.new(
		&"FAILURE", 18.0, -1.0, 90.0, 2, 1, &"ROUTE_END"
	)
	presenter.show_result(summary, 900)
	var model: Dictionary = presenter.model()
	assert_equal(model.get("primary_reason"), &"ROUTE_END", "result projects route-end reason")
	assert_equal(model.get("remaining_map_cargo"), 2, "result projects remaining map cargo")
	assert_equal(model.get("stack_size"), 1, "result projects train stack size")
