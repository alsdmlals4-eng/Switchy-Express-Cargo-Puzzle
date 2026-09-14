extends SceneTree

# Actual Main/Product integration proof, not human-paced play or native repair.
const Main := preload("res://game/main/main.tscn")
const Catalog := preload("res://game/route_book/route_book_catalog.gd")
const Definition := preload("res://game/route_book/route_book_definition.gd")
const STAGE_BOOKS := {
	&"RB01_SERVICE_SIDINGS": &"ROUTE_BOOK_01", &"RB02_REVERSE_ORDER": &"ROUTE_BOOK_01",
	&"RB03_RETURN_MANIFEST": &"ROUTE_BOOK_01", &"RB04_LOAD_WINDOW": &"ROUTE_BOOK_01",
	&"RB05_FORK_LOCK": &"ROUTE_BOOK_01", &"RB06_PORT_CIRCUIT": &"ROUTE_BOOK_01",
	&"RB07_FOREST_RELAY": &"ROUTE_BOOK_02", &"RB08_CAUTION_CUT": &"ROUTE_BOOK_02",
	&"RB09_SALVAGE_SIDING": &"ROUTE_BOOK_02", &"RB10_CLEAN_BREAK": &"ROUTE_BOOK_02",
	&"RB11_TURNOUT_UNDER_LOAD": &"ROUTE_BOOK_02", &"RB12_LANTERN_LOOP": &"ROUTE_BOOK_02",
	&"RB13_FOUR_SIDES": &"ROUTE_BOOK_03", &"RB14_MANIFEST_MIRROR": &"ROUTE_BOOK_03",
	&"RB15_MANUAL_GAP": &"ROUTE_BOOK_03", &"RB16_CAUTION_LEDGER": &"ROUTE_BOOK_03",
	&"RB17_CLEARANCE_YARD": &"ROUTE_BOOK_03", &"RB18_SWITCHBOARD_NIGHT": &"ROUTE_BOOK_03",
}
var failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	if DisplayServer.get_name() == "headless":
		printerr("ROUTE_COMPLETION: FAIL window renderer required")
		quit(2)
		return
	var negative := OS.get_cmdline_user_args().has("no-pickup")
	var book03_negative := OS.get_cmdline_user_args().has("book03-negative")
	var rb08_detour := OS.get_cmdline_user_args().has("rb08-detour")
	var pack_path := ""
	var expected_hash := ""
	for argument: String in OS.get_cmdline_user_args():
		if argument.begins_with("pack-sha256="):
			expected_hash = argument.trim_prefix("pack-sha256=")
		elif argument.begins_with("pack-path="):
			pack_path = argument.trim_prefix("pack-path=")
	# Godot consumes --main-pack before exposing script arguments; the caller binds
	# this absolute identity to its launch command. No resource overlays are used.
	var pack_hash := FileAccess.get_sha256(pack_path) if not pack_path.is_empty() else ""
	var checkout_fixture := FileAccess.file_exists("res://tests/fixtures/route_book/route_book_witnesses.gd")
	if checkout_fixture != pack_path.is_empty():
		printerr("ROUTE_COMPLETION: FAIL checkout/pack consumer mismatch")
		quit(2)
		return
	if (not pack_path.is_empty() and (pack_hash.length() != 64 or pack_hash != expected_hash)) \
			or (pack_path.is_empty() and not expected_hash.is_empty()):
		printerr("ROUTE_COMPLETION: FAIL package identity path=%s actual=%s expected=%s" % [pack_path, pack_hash, expected_hash])
		quit(2)
		return
	# Only the authored input fixture comes from beside this external test script.
	# All product scenes/scripts/maps resolve through res:// in the mounted pack.
	var runner_path: String = get_script().resource_path
	var witness_path := runner_path.get_base_dir().get_base_dir().path_join("fixtures/route_book/route_book_witnesses.gd")
	var witness: Script = load(witness_path)
	var new_witness_path := witness_path.get_base_dir().path_join("route_book_03_witnesses.gd")
	var new_witness: Script = load(new_witness_path)
	if witness == null:
		printerr("ROUTE_COMPLETION: FAIL authored fixture unavailable")
		quit(2)
		return
	var stage_paths: Dictionary = {}
	for book_id: StringName in Catalog.book_ids():
		var book: Variant = Definition.load_from_path(Catalog.definition_path(book_id))
		if book == null:
			printerr("ROUTE_COMPLETION: FAIL book definition")
			quit(2)
			return
		for stage_id: StringName in book.stage_ids():
			_check(STAGE_BOOKS.get(stage_id) == book_id, "independent stage-to-book ownership " + str(stage_id))
			stage_paths[stage_id] = book.stage(stage_id).get("map_path", "")
	if stage_paths.size() != 18 or stage_paths.keys() != STAGE_BOOKS.keys() or new_witness == null:
		printerr("ROUTE_COMPLETION: FAIL expected eighteen exact stages and both fixtures")
		quit(2)
		return
	var output_dir := "user://route-book-completion" + ("-pack" if not pack_path.is_empty() else "") + ("-negative/" if negative else "/")
	if rb08_detour:
		output_dir = output_dir.trim_suffix("/") + "-rb08-detour/"
	if book03_negative:
		output_dir = output_dir.trim_suffix("/") + "-book03-negative/"
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
	var stage_ids: Array = stage_paths.keys()
	for index: int in range(12 if book03_negative else 0, 18 if book03_negative else (1 if negative else 18)):
		var stage_id := StringName(stage_ids[index])
		shell.return_to_title()
		await process_frame
		shell.open_route_book()
		_check(shell.select_route_book(STAGE_BOOKS[stage_id]), "book selection")
		_check(shell.select_route_book_stage(stage_id), "stage selection " + str(stage_id))
		shell.begin_build()
		var product: Control = shell.gameplay_instance()
		if product == null:
			failures.append("missing product " + str(stage_id))
			break
		product.set_process(false)
		_check(StringName(product.session_controller().render_snapshot().get("map_id")) == stage_id, "actual map identity")
		var layout: Array = witness.rb08_caution_detour() if rb08_detour and stage_id == &"RB08_CAUTION_CUT" else witness.pieces(stage_id)
		if index >= 12:
			layout = new_witness.pieces(stage_id, book03_negative)
		_check(product.install_layout_for_test(layout), "authored layout " + str(stage_id))
		product.request_command_for_test(&"START")
		var controller: RefCounted = product.session_controller()
		var runtime: Variant = controller.active_run_session_for_test()
		if book03_negative and stage_id == &"RB13_FOUR_SIDES":
			_check(runtime == null and controller.phase() == &"BUILD", "RB13 actual START rejects diagonal layout")
			_check(controller.render_snapshot().get("problem_cells") == [Vector2i(6, 2)], "RB13 only red service reported")
			samples.append({"stage": str(stage_id), "outcome": "PREFLIGHT_REJECTED", "shell_state": str(shell.state())})
			continue
		if runtime == null:
			failures.append("missing started runtime " + str(stage_id))
			break
		_check(is_equal_approx(runtime.train.speed, 2.0), "actual started product speed")
		if index in [4, 10]: _select_exit(product, runtime, Vector2i(6, 4), Vector2i.RIGHT)
		if index in [5, 11]: _select_exit(product, runtime, Vector2i(6, 5), Vector2i.UP)
		if index >= 12:
			var command: Dictionary = new_witness.drive(stage_id, controller.delivery_history(), runtime, book03_negative)
			if command.desired_exit != Vector2i.ZERO:
				_select_exit(product, runtime, command.switch_cell, command.desired_exit)
		for step: int in range(5000):
			if shell.state() == &"RESULT": break
			if index >= 12:
				var command: Dictionary = new_witness.drive(stage_id, controller.delivery_history(), runtime, book03_negative)
				product.request_command_for_test(&"LOAD_ACTIVE", command.manual)
				if runtime.input_state.is_auto_load_enabled() != command.auto:
					product.request_command_for_test(&"AUTO_TOGGLE")
			elif not negative:
				_drive(index, product, controller, runtime)
			product.advance_time(0.05)
			if step % 10 == 0: await process_frame
		await process_frame
		await RenderingServer.frame_post_draw
		var summary: Variant = shell.last_result()
		var outcome := str(summary.outcome) if summary != null else "MISSING"
		_check(shell.state() == &"RESULT", str(stage_id) + " actual RESULT reached")
		_check(outcome == ("FAILURE" if book03_negative else "SUCCESS"), str(stage_id) + " expected terminal outcome got " + outcome)
		_check(product.get_node("HUD/TopStatus/TimeLabel").text.is_empty(), "terminal guidance blank")
		if summary != null:
			if book03_negative:
				_check(summary.failure_reason == &"ROUTE_END" and summary.remaining_map_cargo == 0 and summary.stack_size > 0, "authored negative route-end cargo facts")
			else:
				_check(summary.remaining_map_cargo == 0 and summary.stack_size == 0, str(stage_id) + " all cargo resolved")
		var next: Button = shell.get_node("ResultOverlay/Panel/Content/RouteBookActions/NextStageButton")
		_check(next.is_visible_in_tree() == (index % 6 < 5 and outcome == "SUCCESS"), "next action boundary")
		var capture := output_dir + "RB%02d-result.png" % (index + 1)
		_check(root.get_texture().get_image().save_png(capture) == OK, "result capture")
		var sample := {"stage": str(stage_id), "outcome": outcome, "shell_state": str(shell.state()),
			"capture_sha256": FileAccess.get_sha256(capture), "next_visible": next.is_visible_in_tree()}
		samples.append(sample)
		print("ROUTE_COMPLETION_STAGE: " + JSON.stringify(sample))
		if index >= 12 and not book03_negative:
			var old_identity: String = runtime.attempt_identity()
			var old_layout: Array = controller.render_snapshot().get("layout_pieces", []).duplicate(true)
			shell.get_node("ResultOverlay/Panel/Content/Actions/RetryButton").pressed.emit()
			var retry: Variant = controller.active_run_session_for_test()
			_check(retry != null and retry.attempt_identity() != old_identity, "book03 Retry creates fresh attempt")
			_check(controller.render_snapshot().get("layout_pieces") == old_layout, "book03 Retry preserves layout")
			if retry != null:
				_check(not retry.input_state.is_auto_load_enabled() and retry.cargo_stack.is_empty(), "Retry resets input and stack")
			# No pickup: reach a second factual result, then exercise the actual Edit button.
			product.request_command_for_test(&"LOAD_ACTIVE", false)
			for step: int in range(5000):
				if shell.state() == &"RESULT": break
				product.advance_time(0.05)
				if step % 10 == 0: await process_frame
			_check(shell.state() == &"RESULT" and shell.last_result() != null and shell.last_result().outcome == &"FAILURE", "Retry no-pickup has actual failure")
			shell.get_node("ResultOverlay/Panel/Content/Actions/EditButton").pressed.emit()
			_check(controller.phase() == &"BUILD" and controller.render_snapshot().get("layout_pieces") == old_layout, "book03 Edit preserves layout in BUILD")
			sample["retry_fresh_same_layout"] = retry != null and retry.attempt_identity() != old_identity
			sample["edit_same_layout"] = controller.phase() == &"BUILD" and controller.render_snapshot().get("layout_pieces") == old_layout
	_check(samples.size() == (6 if book03_negative else (1 if negative else 18)), "complete expected stage count")
	var hashes: Dictionary = {}
	var paths: Array = [runner_path, witness_path, new_witness_path]
	if pack_path.is_empty():
		paths.append_array(["res://game/main/main.tscn",
		"res://game/demo/demo_flow_controller.gd", "res://game/demo/product_finite_slice.gd",
		"res://game/demo/audio/demo_audio_director.gd",
		"res://game/demo/presentation/product_hud.gd",
		"res://game/demo/product_finite_slice.tscn", "res://game/finite/main/finite_slice_session_controller.gd"])
	paths.append_array(stage_paths.values())
	for path: String in paths:
		_check(FileAccess.file_exists(path), "readable evidence source " + path)
		hashes[path] = FileAccess.get_file_as_string(path).replace("\r\n", "\n").sha256_text()
	if not pack_path.is_empty():
		_check(FileAccess.get_sha256(pack_path) == pack_hash, "package unchanged after run")
	var receipt := {"status": "PASS" if failures.is_empty() else "FAIL", "failures": failures,
		"consumer": "EDITOR_MOUNTED_EXPORTED_PCK" if not pack_path.is_empty() else "CHECKOUT_MAIN",
		"package_sha256": pack_hash, "package_path": pack_path,
		"samples": samples, "negative_no_pickup": negative, "book03_negative": book03_negative, "rb08_detour": rb08_detour, "engine": Engine.get_version_info().string,
		"source_sha256_lf": hashes, "human_review": "NOT_RUN", "native_reliability": "SEPARATE_DIAGNOSTIC_REQUIRED",
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
