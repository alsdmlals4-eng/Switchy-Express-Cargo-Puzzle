extends RefCounted

const ALPHA_PATH := "res://tests/fixtures/finite/fp_core_solution_alpha.gd"
const SwitchDriver := preload("res://tests/fixtures/finite/three_direction_switch_driver.gd")


static func install_alpha_through_view(slice: Variant) -> bool:
	if slice == null:
		return false
	var view: Variant = slice.get_node_or_null("View")
	if view == null:
		return false
	var alpha_script: Script = load(ALPHA_PATH)
	for piece: Variant in alpha_script.pieces():
		view.build_tool_selected.emit(piece.geometry)
		view.request_board_cell(piece.cell)
		for _quarter: int in range(piece.rotation_quarters):
			view.rotate_requested.emit()
	return true


static func advance_until_terminal(
	slice: Variant,
	step_seconds: float = 0.05,
	max_steps: int = 4000
) -> bool:
	var runtime: Variant = slice.get("_run_session")
	var branch_targets: Dictionary = (
		SwitchDriver.capture_branch_targets(runtime.graph)
		if runtime != null
		else {}
	)
	for _step: int in range(max_steps):
		var phase: StringName = slice.phase()
		if phase == &"SUCCESS" or phase == &"FAILURE":
			return true
		if runtime != null:
			SwitchDriver.prepare_next_switch(runtime, branch_targets)
		slice.advance_time(step_seconds)
	return false
