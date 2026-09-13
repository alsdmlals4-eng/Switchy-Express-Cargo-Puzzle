extends SceneTree

const Main := preload("res://game/main/main.tscn")
const Witness := preload("res://tests/fixtures/route_book/route_book_witnesses.gd")
const Copy := preload("res://game/first_session/first_session_copy.gd")
const OUT := "res://evidence/runtime/route-result-20260913/"


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var main: Control = Main.instantiate()
	root.add_child(main)
	current_scene = main
	root.size = Vector2i(960, 540)
	await process_frame
	var shell: Control = main.get_node("VerticalSliceDemo")
	var copy := Copy.new()
	var failures: Array[String] = []
	var samples: Array[Dictionary] = []
	if not copy.load_default(): failures.append("copy unavailable")
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUT))
	for locale: String in ["ko", "en", "ja", "zh-Hans"]:
		main.visible = true
		shell.first_session_locale = locale
		shell.return_to_title()
		shell.open_route_book()
		if not shell.select_route_book(&"ROUTE_BOOK_02"): failures.append("book")
		if not shell.select_route_book_stage(&"RB08_CAUTION_CUT"): failures.append("stage")
		shell.begin_build()
		var product: Control = shell.gameplay_instance()
		product.set_process(false)
		await process_frame
		await RenderingServer.frame_post_draw
		var hud: Control = product.get_node("HUD")
		_check_buttons(hud, failures)
		var problem: Label = hud.get_node("ProblemBanner/ProblemLayout/ProblemText")
		if not root.get_visible_rect().encloses(problem.get_global_rect()): failures.append("problem bounds")
		if hud.get_node("ProblemBanner").get_global_rect().intersects(hud.get_node("BuildHistory").get_global_rect()): failures.append("problem/history overlap")
		var build_path := OUT + locale + "-build.png"
		if root.get_texture().get_image().save_png(build_path) != OK: failures.append("build capture")
		if not product.install_layout_for_test(Witness.pieces(&"RB08_CAUTION_CUT")):
			failures.append("layout")
		product.request_command_for_test(&"START")
		product.advance_time(0.05)
		await process_frame
		await RenderingServer.frame_post_draw
		var top := product.get_node("HUD/TopStatus")
		_check_buttons(hud, failures)
		var phase_label: Label = top.get_node("PhaseLabel")
		var time_label: Label = top.get_node("TimeLabel")
		var cost_label: Label = top.get_node("CostLabel")
		if phase_label.text != copy.text(&"SX_HUD_RUNNING", locale): failures.append("running locale")
		if time_label.get_global_rect().intersects(cost_label.get_global_rect()): failures.append("time/cost overlap")
		for node: Control in [phase_label, time_label, cost_label, top.get_node("MenuButton")]:
			if not root.get_visible_rect().encloses(node.get_global_rect()): failures.append("status outside viewport")
		var run_path := OUT + locale + "-running.png"
		if root.get_texture().get_image().save_png(run_path) != OK: failures.append("running capture")
		for step: int in range(3000):
			if shell.state() == &"RESULT": break
			product.advance_time(0.05)
		await process_frame
		await RenderingServer.frame_post_draw
		var content := shell.get_node("ResultOverlay/Panel/Content")
		var title: String = content.get_node("Title").text
		var result_body: String = content.get_node("BodyScroll/Body").text
		if shell.state() != &"RESULT" or title != copy.text(&"SX_RESULT_ROUTE_END", locale):
			failures.append(locale + " actual no-pickup result mismatch")
		if not time_label.text.is_empty(): failures.append(locale + " result retains active guidance")
		for name: String in ["RetryButton", "EditButton", "TitleButton"]:
			var button: Button = content.get_node("Actions/" + name)
			if not button.is_visible_in_tree() or not root.get_visible_rect().encloses(button.get_global_rect()):
				failures.append(locale + " action bounds " + name)
		var path := OUT + locale + ".png"
		if root.get_texture().get_image().save_png(path) != OK: failures.append("capture")
		# UI projection stress only: does not claim a64-cargo authored gameplay run.
		shell.return_to_title()
		main.visible = false
		var stress: Control = preload("res://game/demo/presentation/product_hud.tscn").instantiate()
		stress.locale = locale
		stress.theme = shell.theme
		root.add_child(stress)
		var tokens: Array = []
		for i: int in range(64): tokens.append({"cargo_type":&"WASTE_CRATE", "top":i == 63})
		stress.apply_model({"phase":&"RUNNING", "stack_tokens":tokens, "stack_size":64})
		await process_frame
		await RenderingServer.frame_post_draw
		var manifest: RichTextLabel = stress.get_node("StackPanel/StackLayout/StackText")
		if manifest.text.split("\n").size() !=64 or manifest.get_v_scroll_bar().max_value <= manifest.get_v_scroll_bar().page:
			failures.append("manifest scroll stress")
		var panel: Control = stress.get_node("StackPanel")
		if not root.get_visible_rect().encloses(panel.get_global_rect()): failures.append("manifest bounds")
		manifest.scroll_to_line(63)
		await process_frame
		await RenderingServer.frame_post_draw
		if manifest.get_v_scroll_bar().value <= 0: failures.append("manifest last row unreachable")
		var stack_path := OUT + locale + "-manifest-stress.png"
		if root.get_texture().get_image().save_png(stack_path) != OK: failures.append("manifest capture")
		stress.free()
		samples.append({"locale":locale, "title":title,
			"build_capture_sha256":FileAccess.get_sha256(build_path),
			"manifest_stress_sha256":FileAccess.get_sha256(stack_path),
			"running_capture_sha256":FileAccess.get_sha256(run_path),
			"body":result_body,
			"capture_sha256":FileAccess.get_sha256(path)})
	var hashes: Dictionary = {}
	for path: String in ["res://game/demo/demo_flow_controller.gd", "res://game/demo/presentation/product_hud.gd", "res://game/demo/presentation/product_hud.tscn", "res://data/localization/first_session_v1.json", "res://tests/runtime/route_result_window_runner.gd"]:
		hashes[path] = FileAccess.get_file_as_string(path).replace("\r\n", "\n").sha256_text()
	var receipt := {"status":"PASS" if failures.is_empty() else "FAIL", "failures":failures,
		"scope":"actual Main, authored RB08 route, no pickup input, accelerated simulation; no injected result summary. Separate64-cargo HUD projection stress is NOT an authored gameplay run.",
		"window":str(root.size), "samples":samples, "source_sha256_lf":hashes, "human_review":"NOT_RUN"}
	var file := FileAccess.open(OUT + "receipt.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(receipt, "  "))
	file.close()
	print("ROUTE RESULT QA: " + JSON.stringify(receipt))
	quit(0 if failures.is_empty() else 1)


func _check_buttons(node: Node, failures: Array[String]) -> void:
	if node is Button and node.is_visible_in_tree():
		if not root.get_visible_rect().encloses(node.get_global_rect()): failures.append("button outside " + str(node.get_path()))
	for child: Node in node.get_children(): _check_buttons(child, failures)
