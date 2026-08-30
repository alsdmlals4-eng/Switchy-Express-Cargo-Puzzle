extends "res://tests/test_case.gd"

const EXPORT_PRESETS_PATH := "res://export_presets.cfg"
const WINDOWS_WORKFLOW_PATH := "res://.github/workflows/windows-demo-export.yml"
const ANDROID_WORKFLOW_PATH := "res://.github/workflows/android-validation-apk.yml"
const PACK_VERIFIER_PATH := "res://tools/validation/verify_exported_runtime_json.gd"
const REQUIRED_INCLUDE_FILTER := (
	"include_filter=\"data/maps/*.json,data/first_session/*.json,"
	+ "data/localization/first_session*.json,art/product_assets/ed_hybrid_v1/*.json,"
	+ "art/product_assets/ed_hybrid_v2/*.json\""
)
const REQUIRED_EXCLUDE_FILTER := (
	"exclude_filter=\"tests/**,addons/gut/**,addons/godot_ai/**\""
)


func run() -> void:
	assert_true(FileAccess.file_exists(EXPORT_PRESETS_PATH), "export presets must exist")
	assert_true(FileAccess.file_exists(WINDOWS_WORKFLOW_PATH), "Windows export workflow must exist")
	assert_true(FileAccess.file_exists(ANDROID_WORKFLOW_PATH), "Android validation workflow must exist")
	assert_true(FileAccess.file_exists(PACK_VERIFIER_PATH), "exported runtime JSON verifier must exist")

	var presets := FileAccess.get_file_as_string(EXPORT_PRESETS_PATH)
	assert_equal(
		_count_occurrences(presets, REQUIRED_INCLUDE_FILTER),
		2,
		"Android Validation and Windows Demo must both narrowly include runtime map/semantic JSON"
	)
	assert_equal(
		_count_occurrences(presets, REQUIRED_EXCLUDE_FILTER),
		2,
		"release packs must exclude test runners and editor-only plugins",
	)
	assert_true(presets.contains("name=\"Android Validation\""), "Android Validation preset remains present")
	assert_true(presets.contains("name=\"Windows Demo\""), "Windows Demo preset remains present")

	var verifier := FileAccess.get_file_as_string(PACK_VERIFIER_PATH)
	for required_path: String in [
		"res://data/first_session/first_session_v1.json",
		"res://data/localization/first_session_v1.json",
		"res://data/maps/tutorial/tut_01_02.json",
		"res://data/maps/tutorial/tut_03_lifo.json",
		"res://data/maps/tutorial/tut_04_selective_load.json",
		"res://data/maps/tutorial/tut_05_auto_load.json",
		"res://data/maps/tutorial/tut_06_switch.json",
		"res://art/product_assets/ed_hybrid_v2/manifest.json",
	]:
		assert_true(
			verifier.contains(required_path),
			"proof pack verifier must parse first-session runtime data: %s" % required_path,
		)

	var windows := FileAccess.get_file_as_string(WINDOWS_WORKFLOW_PATH)
	assert_true(
		windows.contains("art/product_assets/ed_hybrid_v2/**"),
		"Windows export must run when a Core Board v02 runtime asset changes",
	)
	assert_true(windows.contains("--export-pack \"Windows Demo\""), "Windows workflow must build a preset-equivalent proof PCK")
	assert_true(windows.contains("windows-runtime-json-proof.pck"), "Windows workflow must retain named runtime JSON proof pack")
	assert_true(windows.contains("--main-pack builds/windows/windows-runtime-json-proof.pck"), "Windows workflow must mount the exported proof PCK")
	assert_true(windows.contains("--script res://tools/validation/verify_exported_runtime_json.gd"), "Windows workflow must parse runtime JSON from mounted pack")

	var android := FileAccess.get_file_as_string(ANDROID_WORKFLOW_PATH)
	assert_true(android.contains("--export-pack \"Android Validation\""), "Android workflow must build a preset-equivalent proof PCK")
	assert_true(android.contains("android-validation-runtime-json-proof.pck"), "Android workflow must retain named runtime JSON proof pack")
	assert_true(android.contains("--main-pack builds/android-validation-runtime-json-proof.pck"), "Android workflow must mount the exported proof PCK")
	assert_true(android.contains("--script res://tools/validation/verify_exported_runtime_json.gd"), "Android workflow must parse runtime JSON from mounted pack")


static func _count_occurrences(text: String, token: String) -> int:
	var count := 0
	var cursor := 0
	while true:
		var found := text.find(token, cursor)
		if found < 0:
			return count
		count += 1
		cursor = found + token.length()
	return count
