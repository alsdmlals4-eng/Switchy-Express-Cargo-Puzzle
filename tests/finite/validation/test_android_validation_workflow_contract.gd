extends "res://tests/test_case.gd"

const WORKFLOW_PATH := "res://.github/workflows/android-validation-apk.yml"


func run() -> void:
	assert_true(FileAccess.file_exists(WORKFLOW_PATH), "Android validation workflow must exist")
	if not FileAccess.file_exists(WORKFLOW_PATH):
		return
	var text := FileAccess.get_file_as_string(WORKFLOW_PATH)
	var lowered := text.to_lower()

	assert_true(text.contains("workflow_dispatch:"), "workflow must be manually dispatched")
	assert_false(text.contains("pull_request:"), "workflow must not run on pull requests")
	assert_false(text.contains("schedule:"), "workflow must not be scheduled")
	assert_false(text.contains("release:"), "workflow must not use release trigger")
	assert_true(text.contains("GODOT_VERSION: 4.7.1-stable"), "Godot version must be pinned")
	assert_true(text.contains("ANDROID_PLATFORM: 35"), "Android platform must be pinned")
	assert_true(text.contains("ANDROID_BUILD_TOOLS: 35.0.1"), "build tools must be pinned")
	assert_true(text.contains("ANDROID_NDK_VERSION: 28.1.13356709"), "NDK package version must be pinned")
	assert_true(text.contains("distribution: temurin"), "Temurin must be selected")
	assert_true(text.contains("java-version: '17'"), "Java 17 must be pinned")
	assert_true(text.contains("--script res://tests/run_tests.gd"), "tests must run before export")
	assert_true(text.contains("--export-debug \"Android Validation\""), "exact validation preset must export")
	assert_true(text.contains("test -s builds/switchy-express-validation.apk"), "workflow must reject missing or empty APK")
	assert_true(text.contains("sha256sum builds/switchy-express-validation.apk"), "workflow must hash APK")
	assert_true(text.contains("validation-build-manifest.json"), "workflow must generate manifest")
	assert_true(text.contains("validation-build-summary.txt"), "workflow must generate summary")
	assert_true(text.contains("retention-days: 14"), "artifact retention must be 14 days")
	assert_true(text.contains("actions/upload-artifact@v4"), "workflow must upload artifact")
	assert_true(text.contains("actions/attest@v4"), "workflow must attest artifact")
	assert_true(text.contains("id-token: write"), "attestation must have id-token permission")
	assert_true(text.contains("attestations: write"), "attestation permission must be explicit")
	assert_false(lowered.contains("keystore_password"), "workflow must not contain keystore password")
	assert_false(text.contains("C:\\"), "workflow must not contain Windows local paths")
	assert_false(text.contains("/Users/"), "workflow must not contain macOS local paths")
