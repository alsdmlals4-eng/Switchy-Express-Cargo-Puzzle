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
		shell.first_session_locale = locale
		shell.return_to_title()
		shell.open_route_book()
		if not shell.select_route_book(&"ROUTE_BOOK_02"): failures.append("book")
		if not shell.select_route_book_stage(&"RB08_CAUTION_CUT"): failures.append("stage")
		shell.begin_build()
		var product: Control = shell.gameplay_instance()
		product.set_process(false)
		if not product.install_layout_for_test(Witness.pieces(&"RB08_CAUTION_CUT")):
			failures.append("layout")
		product.request_command_for_test(&"START")
		for step: int in range(3000):
			if shell.state() == &"RESULT": break
			product.advance_time(0.05)
		await process_frame
		await RenderingServer.frame_post_draw
		var content := shell.get_node("ResultOverlay/Panel/Content")
		var title: String = content.get_node("Title").text
		if shell.state() != &"RESULT" or title != copy.text(&"SX_RESULT_ROUTE_END", locale):
			failures.append(locale + " actual no-pickup result mismatch")
		for name: String in ["RetryButton", "EditButton", "TitleButton"]:
			var button: Button = content.get_node("Actions/" + name)
			if not button.is_visible_in_tree() or not root.get_visible_rect().encloses(button.get_global_rect()):
				failures.append(locale + " action bounds " + name)
		var path := OUT + locale + ".png"
		if root.get_texture().get_image().save_png(path) != OK: failures.append("capture")
		samples.append({"locale":locale, "title":title,
			"body":content.get_node("BodyScroll/Body").text,
			"capture_sha256":FileAccess.get_sha256(path)})
	var hashes: Dictionary = {}
	for path: String in ["res://game/demo/demo_flow_controller.gd", "res://data/localization/first_session_v1.json", "res://tests/runtime/route_result_window_runner.gd"]:
		hashes[path] = FileAccess.get_file_as_string(path).replace("\r\n", "\n").sha256_text()
	var receipt := {"status":"PASS" if failures.is_empty() else "FAIL", "failures":failures,
		"scope":"actual Main, authored RB08 route, no pickup input, accelerated simulation; no injected summary",
		"window":str(root.size), "samples":samples, "source_sha256_lf":hashes, "human_review":"NOT_RUN"}
	var file := FileAccess.open(OUT + "receipt.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(receipt, "  "))
	file.close()
	print("ROUTE RESULT QA: " + JSON.stringify(receipt))
	quit(0 if failures.is_empty() else 1)
