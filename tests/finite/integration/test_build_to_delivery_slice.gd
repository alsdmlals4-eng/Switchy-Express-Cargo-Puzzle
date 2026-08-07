extends "res://tests/test_case.gd"

const SLICE_SCENE_PATH := "res://game/finite/main/finite_slice.tscn"
const DRIVER_PATH := "res://tests/fixtures/finite/finite_slice_driver.gd"
const ALPHA_PATH := "res://tests/fixtures/finite/fp_core_solution_alpha.gd"
const LAYOUT_PATH := "res://game/finite/build/track_layout.gd"
const A: StringName = &"RED_STAR"
const B: StringName = &"BLUE_DIAMOND"


func run() -> void:
	var packed: PackedScene = load(SLICE_SCENE_PATH)
	assert_not_null(packed, "integrated finite slice scene must load")
	if packed == null:
		return
	var slice: Control = packed.instantiate()
	var tree := Engine.get_main_loop() as SceneTree
	assert_not_null(tree, "integrated slice test requires SceneTree")
	if tree == null:
		slice.free()
		return
	tree.root.add_child(slice)

	assert_true(slice.has_method("domain_ready"), "finite slice must expose domain readiness")
	assert_true(slice.has_method("advance_time"), "finite slice must expose deterministic time advancement")
	assert_true(slice.has_method("delivery_history"), "finite slice must expose immutable delivery history")
	assert_true(slice.has_method("current_summary"), "finite slice must expose terminal summary")
	assert_true(slice.has_method("current_layout_signature"), "finite slice must expose final layout identity")
	if not slice.has_method("domain_ready"):
		slice.queue_free()
		return

	assert_true(slice.domain_ready(), "finite slice must load the proof map in BUILD")
	assert_equal(slice.phase(), &"BUILD", "integrated slice must boot BUILD")
	var driver_script: Script = load(DRIVER_PATH)
	assert_true(driver_script.install_alpha_through_view(slice), "alpha solution must be installable through UI commands")

	var alpha_script: Script = load(ALPHA_PATH)
	var layout_script: Script = load(LAYOUT_PATH)
	var expected_layout: Variant = layout_script.new()
	for piece: Variant in alpha_script.pieces():
		expected_layout.put_piece(piece)
	assert_equal(slice.current_layout_signature(), expected_layout.layout_signature(), "UI build commands must produce the canonical alpha solution")
	assert_true(slice.presenter_model()["start_enabled"], "passing UI-built route must enable Start")

	var view: Control = slice.get_node("View")
	view.start_requested.emit()
	assert_equal(slice.phase(), &"RUNNING", "Start command must create and start a finite attempt")
	assert_false(slice.presenter_model()["editing_enabled"], "run start must seal editing")

	var runtime: Variant = slice.get("_run_session")
	assert_not_null(runtime, "started finite slice must own one active run session")
	var switch_cell := Vector2i(3, 4)
	var switch_approach := Vector2i(2, 4)
	var authored_exit: Vector2i = runtime.graph.next_cell(switch_cell, switch_approach)
	view.request_board_cell(switch_cell)
	assert_equal(runtime.graph.next_cell(switch_cell, switch_approach), switch_approach, "first tap must expose the incoming direction for U-turn")
	view.request_board_cell(switch_cell)
	assert_not_equal(runtime.graph.next_cell(switch_cell, switch_approach), authored_exit, "second tap must expose the alternate branch")
	view.request_board_cell(switch_cell)
	assert_equal(runtime.graph.next_cell(switch_cell, switch_approach), authored_exit, "third tap must restore the authored route")

	view.pause_requested.emit()
	assert_equal(slice.phase(), &"PAUSED", "Pause command must enter inspection-only mode")
	var paused_exit: Vector2i = runtime.graph.next_cell(switch_cell, switch_approach)
	view.request_board_cell(switch_cell)
	assert_equal(runtime.graph.next_cell(switch_cell, switch_approach), paused_exit, "board taps during PAUSED must not preconfigure a branch")
	view.resume_requested.emit()
	assert_equal(slice.phase(), &"RUNNING", "Resume command must restore RUNNING")

	view.auto_toggle_requested.emit()
	assert_true(slice.presenter_model()["auto_load_active"], "auto toggle must update the product surface")

	assert_true(driver_script.advance_until_terminal(slice), "integrated alpha run must reach a terminal state")
	assert_equal(slice.phase(), &"SUCCESS", "canonical alpha route with explicit three-direction control must complete")
	var summary: Variant = slice.current_summary()
	assert_not_null(summary, "successful integrated run must expose summary")
	assert_equal(summary.outcome, &"SUCCESS", "integrated summary must record success")
	assert_true(summary.final_delivery_commit_time <= summary.time_limit_seconds, "final delivery must commit within the limit")
	assert_equal(slice.presenter_model()["phase"], &"SUCCESS", "product surface must show success")
	assert_true(slice.presenter_model()["completion_visible"], "success UI must show completion details")

	var history: Array = slice.delivery_history()
	var pickups: Array[StringName] = []
	var unload_counts: Array[int] = []
	for event: Variant in history:
		if event.picked_up:
			pickups.append(event.pickup_type)
		if event.unload_count > 0:
			unload_counts.append(event.unload_count)
	assert_equal(pickups, [A, B, A, A], "integrated contact order must be A/B/A/A")
	assert_equal(unload_counts, [2, 1, 1], "integrated unload groups must be 2→1→1")
	assert_false("fuel" in summary, "finite integrated summary must not expose fuel")
	assert_false("boost_seconds" in summary, "finite integrated summary must not expose BOOST")
	assert_false("score" in summary, "finite integrated summary must not expose endless score")

	slice.queue_free()
