extends SceneTree

const RouteCatalog := preload("res://game/route_book/route_book_catalog.gd")
const RouteDefinition := preload("res://game/route_book/route_book_definition.gd")
const MapLoader := preload("res://game/finite/map/finite_map_loader.gd")
const Copy := preload("res://game/first_session/first_session_copy.gd")
const MainScene := preload("res://game/main/main.tscn")
const REQUIRED_FILES: Array[String] = [
	"res://data/maps/vs_demo_01.json",
	"res://data/maps/tutorial/tut_01_02.json",
	"res://data/maps/tutorial/tut_03_lifo.json",
	"res://data/maps/tutorial/tut_04_selective_load.json",
	"res://data/maps/tutorial/tut_05_auto_load.json",
	"res://data/maps/tutorial/tut_06_switch.json",
	"res://data/first_session/first_session_v1.json",
	"res://data/localization/first_session_v1.json",
	"res://art/product_assets/ed_hybrid_v1/manifest.json",
	"res://art/product_assets/ed_hybrid_v1/semantic_manifest_sx_dec_054.json",
	"res://art/product_assets/ed_hybrid_v1/semantic_manifest_sx_dec_054_build_2b.json",
	"res://art/product_assets/ed_hybrid_v1/semantic_manifest_sx_dec_054_vfx_2c.json",
	"res://art/product_assets/ed_hybrid_v2/manifest.json",
]
const JSON_DIRECTORIES: Array[String] = [
	"res://data/maps",
	"res://data/maps/tutorial",
	"res://data/first_session",
	"res://data/localization",
	"res://art/product_assets/ed_hybrid_v1",
	"res://art/product_assets/ed_hybrid_v2",
]


func _initialize() -> void:
	create_timer(30.0).timeout.connect(func() -> void:
		printerr("RUNTIME_JSON_PACK_PROOF: FAIL consumer watchdog expired")
		quit(2))
	call_deferred("_verify_all")


func _verify_all() -> void:
	var failures: Array[String] = []
	var parsed_count := 0

	for path: String in REQUIRED_FILES:
		if not FileAccess.file_exists(path):
			failures.append("missing required runtime JSON: %s" % path)
			continue
		if not _json_is_readable(path):
			failures.append("unreadable required runtime JSON: %s" % path)
		else:
			parsed_count += 1

	for directory: String in JSON_DIRECTORIES:
		var dir := DirAccess.open(directory)
		if dir == null:
			failures.append("missing runtime JSON directory: %s" % directory)
			continue
		dir.list_dir_begin()
		var name := dir.get_next()
		while name != "":
			if not dir.current_is_dir() and name.to_lower().ends_with(".json"):
				var path := "%s/%s" % [directory, name]
				if not _json_is_readable(path):
					failures.append("unreadable exported JSON: %s" % path)
				else:
					parsed_count += 1
			name = dir.get_next()
		dir.list_dir_end()

	if parsed_count < REQUIRED_FILES.size():
		failures.append("runtime JSON parse count below required minimum: %d" % parsed_count)

	var route_counts: Dictionary = await _verify_route_book_consumers(failures)
	if failures.is_empty():
		print("ROUTE_BOOK_PACK_PROOF: PASS books=%d stages=%d build_entries=%d" % [
			route_counts.books, route_counts.stages, route_counts.build_entries])
		print("RUNTIME_JSON_PACK_PROOF: PASS parsed_json=%d" % parsed_count)
		quit(0)
		return

	for failure: String in failures:
		printerr("RUNTIME_JSON_PACK_PROOF: FAIL %s" % failure)
	quit(1)


func _verify_route_book_consumers(failures: Array[String]) -> Dictionary:
	var counts := {"books": 0, "stages": 0, "build_entries": 0}
	var seen: Dictionary = {}
	var main: Control = MainScene.instantiate()
	root.add_child(main)
	var shell: Control = main.get_node("VerticalSliceDemo")
	for book_id: StringName in RouteCatalog.book_ids():
		var definition: Variant = RouteDefinition.load_from_path(RouteCatalog.definition_path(book_id))
		var copy: RefCounted = Copy.new()
		if definition == null or not copy.load_from_path(RouteCatalog.copy_path(book_id)):
			failures.append("unreadable exported Route Book definition/copy: %s" % book_id)
			continue
		counts.books += 1
		for stage_id: StringName in definition.stage_ids():
			if seen.has(stage_id):
				failures.append("duplicate exported stage identity: %s" % stage_id)
			seen[stage_id] = true
			counts.stages += 1
			var stage: Dictionary = definition.stage(stage_id)
			for field: String in ["title_key", "objective_key", "context_key"]:
				for locale: String in Copy.REQUIRED_LOCALES:
					if copy.text(StringName(stage.get(field, "")), locale).is_empty():
						failures.append("missing exported stage copy: %s/%s/%s" % [stage_id, field, locale])
			var map: Variant = MapLoader.load_from_path(str(stage.get("map_path", "")))
			if map == null:
				failures.append("invalid exported stage map: %s" % stage_id)
				continue
			shell.return_to_title()
			await process_frame
			shell.open_route_book()
			if not shell.select_route_book(book_id) or not shell.select_route_book_stage(stage_id):
				failures.append("exported shell cannot select stage: %s" % stage_id)
				continue
			shell.begin_build()
			await process_frame
			var product: Control = shell.gameplay_instance()
			if product == null:
				failures.append("exported shell has no product: %s" % stage_id)
				continue
			var controller: RefCounted = product.session_controller()
			if shell.state() != &"GAMEPLAY" or controller.phase() != &"BUILD" \
					or controller.render_snapshot().get("map_id") != map.map_id:
				failures.append("exported BUILD consumer identity mismatch: %s" % stage_id)
			else:
				counts.build_entries += 1
				print("ROUTE_BOOK_PACK_ENTRY: %s map=%s BUILD" % [stage_id, map.map_id])
	main.queue_free()
	await process_frame
	if counts.books == 0 or counts.stages == 0 or counts.build_entries != counts.stages:
		failures.append("incomplete exported Route Book consumer coverage: %s" % counts)
	return counts


static func _json_is_readable(path: String) -> bool:
	if not FileAccess.file_exists(path):
		return false
	var text := FileAccess.get_file_as_string(path)
	if text.strip_edges().is_empty():
		return false
	var parsed: Variant = JSON.parse_string(text)
	return parsed is Dictionary or parsed is Array
