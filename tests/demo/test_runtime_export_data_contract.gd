extends "res://tests/test_case.gd"

const EXPORT_PRESETS_PATH := "res://export_presets.cfg"
const WINDOWS_WORKFLOW_PATH := "res://.github/workflows/windows-demo-export.yml"
const ANDROID_WORKFLOW_PATH := "res://.github/workflows/android-validation-apk.yml"
const PACK_VERIFIER_PATH := "res://tools/validation/verify_exported_runtime_json.gd"
const REQUIRED_INCLUDE_FILTER := "include_filter=\"data/maps/*.json,art/product_assets/ed_hybrid_v1/*.json\""


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
	assert_true(presets.contains("name=\"Android Validation\""), "Android Validation preset remains present")
	assert_true(presets.contains("name=\"Windows Demo\""), "Windows Demo preset remains present")

	var windows := FileAccess.get_file_as_string(WINDOWS_WORKFLOW_PATH)
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
