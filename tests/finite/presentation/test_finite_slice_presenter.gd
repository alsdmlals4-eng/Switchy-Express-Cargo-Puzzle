extends "res://tests/test_case.gd"

const PRESENTER_PATH := "res://game/finite/presentation/finite_slice_presenter.gd"
const A: StringName = &"RED_STAR"
const B: StringName = &"BLUE_DIAMOND"


class FakePreflight:
	extends RefCounted

	var passed: bool
	var primary_code: StringName
	var message: String
	var problem_cells: Array[Vector2i]

	func _init(
		did_pass: bool,
		code: StringName,
		detail: String,
		cells: Array[Vector2i] = []
	) -> void:
		passed = did_pass
		primary_code = code
		message = detail
		problem_cells = cells.duplicate()


class FakeRunState:
	extends RefCounted

	var _phase: StringName
	var _elapsed: float
	var _limit: float

	func _init(phase_value: StringName, elapsed_value: float, limit_value: float) -> void:
		_phase = phase_value
		_elapsed = elapsed_value
		_limit = limit_value

	func phase() -> StringName:
		return _phase

	func elapsed_seconds() -> float:
		return _elapsed

	func time_limit_seconds() -> float:
		return _limit


class FakeSummary:
	extends RefCounted

	var outcome: StringName
	var failure_reason: StringName
	var completion_time: float
	var final_delivery_commit_time: float
	var time_limit_seconds: float

	func _init(
		result: StringName,
		completed_at: float,
		committed_at: float,
		limit: float,
		reason: StringName = &""
	) -> void:
		outcome = result
		failure_reason = reason if result == &"FAILURE" else &""
		completion_time = completed_at
		final_delivery_commit_time = committed_at
		time_limit_seconds = limit


func run() -> void:
	var presenter_exists := ResourceLoader.exists(PRESENTER_PATH, "Script")
	assert_true(presenter_exists, "finite slice presenter must exist")
	if not presenter_exists:
		return

	var presenter_script: Script = load(PRESENTER_PATH)
	var presenter: Variant = presenter_script.new()
	var initial: Dictionary = presenter.model()
	assert_equal(initial["phase"], &"BUILD", "presenter must begin in BUILD")
	assert_false(initial["start_enabled"], "initial empty build must not start")
	assert_true(initial["editing_enabled"], "initial build must permit editing")
	assert_equal(initial["stack_tokens"], [], "initial stack view must be empty")

	var fail_cells: Array[Vector2i] = [Vector2i(2, 3)]
	var failed_preflight := FakePreflight.new(
		false,
		&"DISCONNECTED_REQUIRED",
		"required point is disconnected",
		fail_cells
	)
	presenter.show_build(failed_preflight, 1200, 4500)
	var failed_build: Dictionary = presenter.model()
	assert_equal(failed_build["phase"], &"BUILD", "preflight failure must remain BUILD")
	assert_false(failed_build["start_enabled"], "failed preflight must disable Start")
	assert_equal(failed_build["primary_reason"], &"DISCONNECTED_REQUIRED", "failed preflight must show one primary code")
	assert_equal(failed_build["status_text"], "required point is disconnected", "failed preflight must show one primary reason")
	assert_equal(failed_build["problem_cells"], fail_cells, "failed preflight must highlight problem cells")
	assert_equal(failed_build["current_cost"], 1200, "build HUD must show current construction cost")
	assert_equal(failed_build["recommended_cost"], 4500, "build HUD must show recommended estimate")

	var pass_cells: Array[Vector2i] = []
	var passed_preflight := FakePreflight.new(true, &"PASS", "route ready", pass_cells)
	presenter.show_build(passed_preflight, 4300, 4500)
	var passed_build: Dictionary = presenter.model()
	assert_true(passed_build["start_enabled"], "passed preflight must enable Start")
	assert_equal(passed_build["primary_reason"], &"PASS", "passed preflight must show PASS")

	var load_order: Array[StringName] = [A, B, A, A]
	presenter.show_run(FakeRunState.new(&"RUNNING", 12.5, 90.0), load_order, true, 4300)
	var running: Dictionary = presenter.model()
	assert_equal(running["phase"], &"RUNNING", "running snapshot must enter RUNNING")
	assert_false(running["editing_enabled"], "RUNNING must disable build editing")
	assert_true(running["switch_enabled"], "RUNNING must enable switch input")
	assert_true(running["load_enabled"], "RUNNING must enable load hold")
	assert_true(running["auto_enabled"], "RUNNING must enable auto toggle")
	assert_true(running["auto_load_active"], "RUNNING must show auto-load state")
	assert_equal(running["stack_tokens"].size(), 4, "RUNNING must show every stack token")
	assert_equal(running["stack_tokens"][3]["top"], true, "latest cargo must be labeled TOP")
	assert_equal(running["stack_tokens"][0]["top"], false, "bottom cargo must not be labeled TOP")

	presenter.show_run(FakeRunState.new(&"PAUSED", 12.5, 90.0), load_order, true, 4300)
	var paused: Dictionary = presenter.model()
	assert_false(paused["switch_enabled"], "PAUSED must disable switch input")
	assert_false(paused["load_enabled"], "PAUSED must disable load hold")
	assert_false(paused["auto_enabled"], "PAUSED must disable auto toggle")
	assert_true(paused["resume_visible"], "PAUSED must expose Resume")

	var unload_items: Array[StringName] = [A, A]
	var one_emission: Array[StringName] = [A]
	presenter.begin_unload_visual(load_order, unload_items)
	presenter.show_run(FakeRunState.new(&"UNLOADING", 13.0, 90.0), load_order, true, 4300)
	var unloading: Dictionary = presenter.model()
	assert_equal(unloading["phase"], &"UNLOADING", "matching station must show UNLOADING")
	assert_equal(unloading["stack_tokens"].size(), 4, "unload visual must begin from pre-commit stack")
	assert_true(unloading["switch_enabled"], "UNLOADING must permit branch preconfiguration")
	assert_true(unloading["load_enabled"], "UNLOADING must preserve held-load preparation")
	assert_true(unloading["auto_enabled"], "UNLOADING must permit auto-load changes")
	presenter.apply_unload_emissions(one_emission)
	assert_equal(presenter.model()["stack_tokens"].size(), 3, "first emission must remove one visible TOP token")
	assert_equal(presenter.model()["stack_tokens"][2]["top"], true, "new visual TOP must update after one emission")
	presenter.apply_unload_emissions(one_emission)
	assert_equal(presenter.model()["stack_tokens"].size(), 2, "second emission must remove the second token")
	assert_false(presenter.model()["unload_visual_active"], "all unload emissions must close the visual sequence")

	presenter.show_result(FakeSummary.new(&"FAILURE", 90.0, -1.0, 90.0, &"TIME_EXPIRED"), 4300)
	var failure: Dictionary = presenter.model()
	assert_equal(failure["phase"], &"FAILURE", "failure summary must show FAILURE")
	assert_equal(failure["primary_reason"], &"TIME_EXPIRED", "timeout result must expose TIME_EXPIRED")
	assert_equal(failure["status_text"], "Time expired", "timeout result must retain timeout copy")
	assert_true(failure["retry_visible"], "FAILURE must show Retry Same Layout")
	assert_true(failure["edit_visible"], "FAILURE must show Edit Layout")
	assert_false(failure["completion_visible"], "FAILURE must not show completion success")

	presenter.show_result(FakeSummary.new(&"FAILURE", 18.0, -1.0, 90.0, &"ROUTE_END"), 4300)
	var route_end: Dictionary = presenter.model()
	assert_equal(route_end["primary_reason"], &"ROUTE_END", "route-end result must expose ROUTE_END")
	assert_equal(route_end["status_text"], "Route ended", "route-end result must not masquerade as timeout")

	presenter.show_result(FakeSummary.new(&"SUCCESS", 42.25, 42.13, 90.0), 4300)
	var success: Dictionary = presenter.model()
	assert_equal(success["phase"], &"SUCCESS", "success summary must show SUCCESS")
	assert_equal(success["primary_reason"], &"SUCCESS", "success must not carry a failure reason")
	assert_true(success["completion_visible"], "SUCCESS must show completion data")
	assert_almost_equal(success["completion_time"], 42.25, 0.000001, "SUCCESS must show presentation completion time")
	assert_almost_equal(success["commit_time"], 42.13, 0.000001, "SUCCESS must show final domain commit time")
	assert_equal(success["final_cost"], 4300, "SUCCESS must show final build cost")

	var red_descriptor: Dictionary = presenter.cargo_descriptor(A)
	var blue_descriptor: Dictionary = presenter.cargo_descriptor(B)
	assert_equal(red_descriptor["shape"], &"STAR", "red cargo must include STAR silhouette")
	assert_equal(blue_descriptor["shape"], &"DIAMOND", "blue cargo must include DIAMOND silhouette")
	assert_not_equal(red_descriptor["label"], blue_descriptor["label"], "cargo must remain distinguishable without color")
