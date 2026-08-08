extends GutTest

const ControllerScript := preload("res://game/finite/main/finite_slice_session_controller.gd")
const AlphaSolution := preload("res://tests/fixtures/finite/fp_core_solution_alpha.gd")
const SwitchDriver := preload("res://tests/fixtures/finite/three_direction_switch_driver.gd")
const MAP_PATH := "res://data/maps/fp_core_proof_01.json"


func test_pickup_hides_marker_and_retry_restores_authored_markers() -> void:
	var controller: RefCounted = ControllerScript.new()
	assert_true(controller.initialize(MAP_PATH, 4500, 2.0), "proof map must initialize")
	assert_true(
		controller.install_layout_for_test(AlphaSolution.pieces()),
		"canonical alpha layout must install"
	)

	var initial: Dictionary = controller.render_snapshot()
	var authored_cargo: Array = initial.get("cargo_placements", [])
	var authored_stations: Array = initial.get("station_placements", [])
	assert_eq(authored_cargo.size(), 4, "BUILD must show all authored cargo markers")
	assert_eq(authored_stations.size(), 2, "station markers establish the unchanged baseline")

	controller.request_command(&"START")
	controller.request_command(&"AUTO_TOGGLE")
	var runtime: Variant = controller.active_run_session_for_test()
	assert_not_null(runtime, "START must create an active finite run")
	if runtime == null:
		return
	var branch_targets: Dictionary = SwitchDriver.capture_branch_targets(runtime.graph)

	var pickup_event: Variant = null
	for _step: int in range(4000):
		SwitchDriver.prepare_next_switch(runtime, branch_targets)
		controller.advance_time(0.05)
		for event: Variant in controller.delivery_history():
			if event.picked_up:
				pickup_event = event
				break
		if pickup_event != null:
			break

	assert_not_null(pickup_event, "canonical run must reach a successful pickup")
	if pickup_event == null:
		return

	var after_pickup: Dictionary = controller.render_snapshot()
	var visible_after_pickup: Array = after_pickup.get("cargo_placements", [])
	var visible_cells := _placement_cells(visible_after_pickup)
	assert_eq(
		visible_after_pickup.size(),
		authored_cargo.size() - 1,
		"successful pickup must remove exactly one board cargo marker"
	)
	assert_false(
		visible_cells.has(pickup_event.cell),
		"the successfully collected cargo cell must disappear from the render snapshot"
	)
	assert_eq(
		after_pickup.get("station_placements", []),
		authored_stations,
		"cargo pickup visibility must not mutate station markers"
	)

	var authored_cells := _placement_cells(authored_cargo)
	for cell: Vector2i in authored_cells:
		if cell != pickup_event.cell:
			assert_true(
				visible_cells.has(cell),
				"uncollected cargo marker %s must remain visible after the first pickup" % cell
			)

	for _step: int in range(4000):
		var active_phase: StringName = controller.phase()
		if active_phase == &"SUCCESS" or active_phase == &"FAILURE":
			break
		SwitchDriver.prepare_next_switch(runtime, branch_targets)
		controller.advance_time(0.05)

	assert_eq(controller.phase(), &"SUCCESS", "canonical alpha run must finish successfully")
	controller.request_command(&"RETRY_SAME_LAYOUT")
	var retry_snapshot: Dictionary = controller.render_snapshot()
	assert_eq(
		_placement_cells(retry_snapshot.get("cargo_placements", [])),
		authored_cells,
		"Retry Same Layout must restore all authored cargo markers"
	)
	assert_eq(
		retry_snapshot.get("station_placements", []),
		authored_stations,
		"retry must leave station markers unchanged"
	)


func _placement_cells(placements: Array) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for value: Variant in placements:
		if not value is Dictionary:
			continue
		var cell: Variant = _read_cell(value.get("cell", null))
		if cell != null:
			result.append(cell)
	result.sort_custom(_cell_precedes)
	return result


func _read_cell(raw: Variant) -> Variant:
	if raw is Vector2i:
		return raw
	if raw is Array and raw.size() == 2:
		return Vector2i(int(raw[0]), int(raw[1]))
	if raw is Dictionary and raw.has("x") and raw.has("y"):
		return Vector2i(int(raw.get("x", 0)), int(raw.get("y", 0)))
	return null


func _cell_precedes(first: Vector2i, second: Vector2i) -> bool:
	if first.y != second.y:
		return first.y < second.y
	return first.x < second.x
