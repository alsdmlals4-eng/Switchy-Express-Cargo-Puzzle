extends RefCounted

const Catalog := preload("res://game/route_book/route_book_catalog.gd")
const Definition := preload("res://game/route_book/route_book_definition.gd")
const Copy := preload("res://game/first_session/first_session_copy.gd")
const InputQA := preload("res://tests/runtime/build_history_live_qa.gd")
const OUT := "res://evidence/runtime/stage-preview-window-20260913/"
const SIZES: Array[Vector2i] = [Vector2i(960, 540), Vector2i(1280, 720), Vector2i(1600, 900)]
const LOCALES: Array[String] = ["ko", "en", "ja", "zh-Hans"]


static func run(tree: SceneTree, source_revision: String = "") -> Dictionary:
	var shell := tree.root.get_node_or_null("Main/VerticalSliceDemo") as Control
	if shell == null:
		return {"status": "BLOCKED", "reason": "Expected actual Switchy Main scene"}
	if source_revision.length() != 40 or not source_revision.is_valid_hex_number(false):
		return {"status": "BLOCKED", "reason": "Pass the verified 40-character product source revision"}
	var original_size := tree.root.size
	var original_locale: String = shell.first_session_locale
	var failures: Array[String] = []
	var observed: Array[Dictionary] = []
	var checked := 0
	var begin_checks := 0
	var sources: Dictionary = {}
	var captures: Dictionary = {}
	for path: String in [
		"res://game/main/main.tscn", "res://game/demo/vertical_slice_demo.tscn",
		"res://game/demo/demo_flow_controller.gd", "res://game/demo/presentation/stage_board_preview.gd",
		"res://game/demo/presentation/product_board_renderer.gd",
		"res://game/route_book/route_book_catalog.gd", "res://game/route_book/route_book_definition.gd",
		"res://game/first_session/first_session_copy.gd",
		"res://tests/runtime/stage_preview_live_qa.gd", "res://tests/runtime/stage_preview_window_runner.gd",
		"res://tests/runtime/build_history_live_qa.gd"]:
		sources[path] = _text_hash(path)
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(OUT))
	for requested: Vector2i in SIZES:
		tree.root.size = requested
		await tree.process_frame
		await tree.process_frame
		observed.append({"requested": str(requested), "actual": str(tree.root.size), "logical": str(tree.root.get_visible_rect().size)})
		if tree.root.size != requested:
			failures.append("Window size not accepted: %s -> %s" % [requested, tree.root.size])
		for locale: String in LOCALES:
			shell.first_session_locale = locale
			for book: StringName in Catalog.book_ids():
				sources[Catalog.definition_path(book)] = _text_hash(Catalog.definition_path(book))
				sources[Catalog.copy_path(book)] = _text_hash(Catalog.copy_path(book))
				var definition: Variant = Definition.load_from_path(Catalog.definition_path(book))
				var copy := Copy.new()
				if definition == null or not copy.load_from_path(Catalog.copy_path(book)):
					failures.append("Missing book/copy %s" % book)
					continue
				var number := 0
				for stage_id: StringName in definition.stage_ids():
					number += 1
					checked += 1
					var key := "%s/%s/%s" % [requested, locale, stage_id]
					shell.return_to_title()
					shell.open_route_book()
					if not shell.select_route_book(book) or not shell.select_route_book_stage(stage_id):
						failures.append(key + " selection failed")
						continue
					await tree.process_frame
					await RenderingServer.frame_post_draw
					var content := shell.get_node("BriefingScreen/Panel/Content")
					var preview := content.get_node("MapPreview") as Control
					var board: Control = preview.get_node("Board")
					var snapshot: Dictionary = board.snapshot_for_test()
					var stage: Dictionary = definition.stage(stage_id)
					sources[str(stage.get("map_path"))] = _text_hash(str(stage.get("map_path")))
					var expected_progress: String = copy.format(&"SX_RB_PROGRESS", {"current": number, "total": definition.stage_count()}, locale)
					if content.get_node("LessonProgress").text != expected_progress:
						failures.append(key + " progress mismatch")
					if content.get_node("Rules").text != copy.text(StringName(stage.get("context_key")), locale):
						failures.append(key + " planning prompt mismatch")
					if snapshot.get("map_id") != stage_id or not preview.is_visible_in_tree():
						failures.append(key + " selected map mismatch/hidden")
					if not snapshot.get("layout_pieces", []).is_empty() or shell.gameplay_instance() != null:
						failures.append(key + " preview started gameplay or disclosed player rails")
					var horizontal: Vector2 = board.cell_center_global(Vector2i(1, 0)) - board.cell_center_global(Vector2i.ZERO)
					var vertical: Vector2 = board.cell_center_global(Vector2i(0, 1)) - board.cell_center_global(Vector2i.ZERO)
					if not is_equal_approx(horizontal.length(), vertical.length()):
						failures.append(key + " non-square cells")
					for control: Control in [content.get_parent(), content.get_node("BeginButton")]:
						if not tree.root.get_visible_rect().encloses(control.get_global_rect()):
							failures.append(key + " panel/Begin outside viewport")
					if tree.root.size == requested and requested == SIZES[0] and book == &"ROUTE_BOOK_02" and number == 6:
						var error := tree.root.get_texture().get_image().save_png(OUT + "rb12-" + locale + "-960.png")
						if error != OK:
							failures.append(key + " capture failed")
						else:
							var capture_path := OUT + "rb12-" + locale + "-960.png"
							captures[capture_path] = FileAccess.get_sha256(capture_path)
					if locale == "ko" and book == &"ROUTE_BOOK_02" and number == 6:
						await InputQA.click(tree, content.get_node("BeginButton"))
						var product: Variant = shell.gameplay_instance()
						if product == null:
							failures.append(key + " pointer Begin did not open gameplay")
						else:
							var started: Dictionary = product.session_controller().render_snapshot()
							if started.get("map_id") != stage_id or not started.get("layout_pieces", []).is_empty():
								failures.append(key + " pointer Begin map/layout mismatch")
							begin_checks += 1
	shell.first_session_locale = original_locale
	shell.return_to_title()
	tree.root.size = original_size
	await tree.process_frame
	await tree.process_frame
	if tree.root.size != original_size or shell.first_session_locale != original_locale:
		failures.append("Original window/locale restoration did not read back")
	var receipt := {"status": "PASS" if failures.is_empty() and checked == 144 and begin_checks == 3 else "FAIL",
		"source_revision": source_revision, "engine": Engine.get_version_info().get("string"),
		"source_hash_policy": "SHA256_UTF8_TEXT_CRLF_TO_LF", "source_hashes": sources,
		"capture_sha256": captures,
		"scope": "actual Windows game window, programmatic selection/post-draw capture, not human/device approval",
		"checked": checked, "pointer_begin_checks": begin_checks, "window_sizes": observed, "failures": failures,
		"restored_size": str(tree.root.size), "restored_locale": shell.first_session_locale,
		"human_review": "NOT_RUN", "release_review": "NOT_RUN"}
	var file := FileAccess.open(OUT + "receipt.json", FileAccess.WRITE)
	if file == null:
		return {"status": "BLOCKED", "reason": "Cannot write QA receipt", "checks": receipt}
	file.store_string(JSON.stringify(receipt, "  "))
	return receipt


static func _text_hash(path: String) -> String:
	return FileAccess.get_file_as_string(path).replace("\r\n", "\n").sha256_text()
