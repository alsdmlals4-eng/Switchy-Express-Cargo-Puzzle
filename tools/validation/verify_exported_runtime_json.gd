extends SceneTree

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

	if failures.is_empty():
		print("RUNTIME_JSON_PACK_PROOF: PASS parsed_json=%d" % parsed_count)
		quit(0)
		return

	for failure: String in failures:
		printerr("RUNTIME_JSON_PACK_PROOF: FAIL %s" % failure)
	quit(1)


static func _json_is_readable(path: String) -> bool:
	if not FileAccess.file_exists(path):
		return false
	var text := FileAccess.get_file_as_string(path)
	if text.strip_edges().is_empty():
		return false
	var parsed: Variant = JSON.parse_string(text)
	return parsed is Dictionary or parsed is Array
