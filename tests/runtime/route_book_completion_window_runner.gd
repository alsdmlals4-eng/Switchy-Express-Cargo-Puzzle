extends SceneTree

# Actual Main/Product integration proof, not human-paced play or native repair.
const Main := preload("res://game/main/main.tscn")
const Witness := preload("res://tests/fixtures/route_book/route_book_witnesses.gd")
const Stages := preload("res://tests/route_book/test_route_book_machine_witnesses.gd")
var failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var negative := OS.get_cmdline_user_args().has("no-pickup")
	var output_dir := "user://route-book-completion-negative/" if negative else "user://route-book-completion/"
	if DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(output_dir)) != OK:
		printerr("ROUTE_COMPLETION: FAIL output directory")
		quit(2)
		return
	var main: Control = Main.instantiate()
	root.add_child(main)
	current_scene = main
	root.size = Vector2i(960, 540)
	await process_frame
	var shell: Control = main.get_node("VerticalSliceDemo")
	var samples: Array[Dictionary] = []
	var stage_ids: Array = Stages.PATHS.keys()
	for index: int in range(1 if negative else 12):
		var stage_id := StringName(stage_ids[index])
		shell.return_to_title()
		await process_frame
		shell.open_route_book()
		_check(shell.select_route_book(&"ROUTE_BOOK_01" if index < 6 else &"ROUTE_BOOK_02"), "book selection")
		_check(shell.select_route_book_stage(stage_id), "stage selection " + str(stage_id))
		shell.begin_build()
		var product: Control = shell.gameplay_instance()
		if product == null:
			failures.append("missing product " + str(stage_id))
			break
		product.set_process(false)
		_check(StringName(product.session_controller().render_snapshot().get("map_id")) == stage_id, "actual map identity")
		_check(product.install_layout_for_test(Witness.pieces(stage_id)), "authored layout " + str(stage_id))
		product.request_command_for_test(&"START")
		var controller: RefCounted = product.session_controller()
		var runtime: Variant = controller.active_run_session_for_test()
		if runtime == null:
			failures.append("missing started runtime " + str(stage_id))
			break
		_check(is_equal_approx(runtime.train.speed, 2.0), "actual started product speed")
		if index in [4, 10]: _select_exit(product, runtime, Vector2i(6, 4), Vector2i.RIGHT)
		if index in [5, 11]: _select_exit(product, runtime, Vector2i(6, 5), Vector2i.UP)
		for step: int in range(5000):
			if shell.state() == &"RESULT": break
			if not negative: _drive(index, product, controller, runtime)
			product.advance_time(0.05)
			if step % 10 == 0: await process_frame
		await process_frame
		await RenderingServer.frame_post_draw
		var summary: Variant = shell.last_result()
		var outcome := str(summary.outcome) if summary != null else "MISSING"
		_check(shell.state() == &"RESULT", str(stage_id) + " actual RESULT reached")
		_check(outcome == "SUCCESS", str(stage_id) + " expected SUCCESS got " + outcome)
		if summary != null:
			_check(summary.remaining_map_cargo == 0 and summary.stack_size == 0, str(stage_id) + " all cargo resolved")
		var next: Button = shell.get_node("ResultOverlay/Panel/Content/RouteBookActions/NextStageButton")
		_check(next.is_visible_in_tree() == (index % 6 < 5 and outcome == "SUCCESS"), "next action boundary")
		var capture := output_dir + "RB%02d-result.png" % (index + 1)
		_check(root.get_texture().get_image().save_png(capture) == OK, "result capture")
		var sample := {"stage": str(stage_id), "outcome": outcome, "shell_state": str(shell.state()),
			"capture_sha256": FileAccess.get_sha256(capture), "next_visible": next.is_visible_in_tree()}
		samples.append(sample)
		print("ROUTE_COMPLETION_STAGE: " + JSON.stringify(sample))
	_check(samples.size() == (1 if negative else 12), "complete expected stage count")
	var hashes: Dictionary = {}
	var paths: Array = ["res://tests/runtime/route_book_completion_window_runner.gd",
		"res://tests/fixtures/route_book/route_book_witnesses.gd", "res://game/main/main.tscn",
		"res://game/demo/demo_flow_controller.gd", "res://game/demo/product_finite_slice.gd",
		"res://game/demo/product_finite_slice.tscn", "res://game/finite/main/finite_slice_session_controller.gd"]
	paths.append_array(Stages.PATHS.values())
	for path: String in paths:
		hashes[path] = FileAccess.get_file_as_string(path).replace("\r\n", "\n").sha256_text()
	var receipt := {"status": "PASS" if failures.is_empty() else "FAIL", "failures": failures,
		"samples": samples, "negative_no_pickup": negative, "engine": Engine.get_version_info().string,
		"source_sha256_lf": hashes, "human_review": "NOT_RUN", "native_reliability": "NOT_FIXED",
		"scope": "Actual Main/Product, authored fixtures, commands, accelerated0.05 steps, 960x540 ko; no injected terminal outcome."}
	var output := FileAccess.open(output_dir + "receipt.json", FileAccess.WRITE)
	if output == null:
		printerr("ROUTE_COMPLETION: FAIL receipt unavailable")
		quit(2)
		return
	output.store_string(JSON.stringify(receipt, "\t"))
	output.close()
	for failure: String in failures: printerr("ROUTE_COMPLETION_FAILURE: " + failure)
	print("ROUTE_COMPLETION: %s stages=%d" % ["PASS" if failures.is_empty() else "FAIL", samples.size()])
	quit(0 if failures.is_empty() else 1)


func _check(condition: bool, message: String) -> void:
	if not condition: failures.append(message)


func _select_exit(product: Control, runtime: Variant, cell: Vector2i, desired: Vector2i) -> void:
	for attempt: int in range(4):
		for state: Dictionary in runtime.graph.route_control_states():
			if state.get("cell") == cell and state.get("selected_exit") == desired: return
		product.request_command_for_test(&"BOARD_CELL", cell)
	failures.append("switch command did not select " + str(desired))


func _drive(index: int, product: Control, controller: RefCounted, runtime: Variant) -> void:
	var target: Vector2i = runtime.train.target_cell()
	var load := true
	if index in [2, 9]:
		var visits: int = controller.delivery_history().filter(func(event: Variant) -> bool:
			return event.cell == Vector2i(5, 4)).size()
		load = target == Vector2i(4, 4) or (target == Vector2i(5, 4) and visits > 0)
	elif index == 3:
		var visits: int = controller.delivery_history().filter(func(event: Variant) -> bool:
			return event.cell == Vector2i(6, 4)).size()
		if target in [Vector2i(3, 4), Vector2i(4, 4)]:
			if not runtime.input_state.is_auto_load_enabled(): product.request_command_for_test(&"AUTO_TOGGLE")
		elif target == Vector2i(6, 4) and visits == 0:
			if runtime.input_state.is_auto_load_enabled(): product.request_command_for_test(&"AUTO_TOGGLE")
		load = target == Vector2i(6, 4) and visits > 0
	elif index in [5, 11]:
		if target == Vector2i(4, 5) and not runtime.input_state.is_auto_load_enabled():
			product.request_command_for_test(&"AUTO_TOGGLE")
		elif target == Vector2i(7, 4) and runtime.input_state.is_auto_load_enabled():
			product.request_command_for_test(&"AUTO_TOGGLE")
		load = target in [Vector2i(7, 4), Vector2i(9, 7)]
	product.request_command_for_test(&"LOAD_ACTIVE", load)
