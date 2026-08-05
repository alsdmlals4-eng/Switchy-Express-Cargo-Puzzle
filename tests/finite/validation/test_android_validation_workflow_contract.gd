extends "res://tests/test_case.gd"

const WORKFLOW_PATH := "res://.github/workflows/android-validation-apk.yml"


func run() -> void:
	assert_true(FileAccess.file_exists(WORKFLOW_PATH), "Android validation APK workflow must exist")
	if not FileAccess.file_exists(WORKFLOW_PATH):
		return
	var text := FileAccess.get_file_as_string(WORKFLOW_PATH)

	assert_true(text.contains("workflow_dispatch:"), "workflow must be manually dispatched")
	assert_false(text.contains("pull_request:"), "workflow must not run on pull requests")
	assert_false(text.contains("schedule:"), "workflow must not be scheduled")
	assert_false(text.contains("release:"), "workflow must not be release-triggered")
	assert_false(text.contains("branches:"), "workflow must not add push branch triggers")

	var required := [
		"GODOT_VERSION: 4.7.1-stable",
		"JAVA_VERSION: '17'",
		"ANDROID_PLATFORM: android-35",
		"ANDROID_BUILD_TOOLS: 35.0.1",
		"ANDROID_NDK_VERSION: 28.1.13356709",
		"uses: actions/checkout@v4",
		"uses: actions/setup-java@v4",
		"distribution: temurin",
		"uses: android-actions/setup-android@v3",
		"sdkmanager --licenses >/dev/null || true",
		"platforms;android-35",
		"build-tools;35.0.1",
		"ndk;28.1.13356709",
		"openssl rand -hex 16",
		"GODOT_ANDROID_KEYSTORE_DEBUG_PATH",
		"GODOT_ANDROID_KEYSTORE_DEBUG_USER",
		"GODOT_ANDROID_KEYSTORE_DEBUG_PASSWORD",
		"export/android/java_sdk_path",
		"export/android/android_sdk_path",
		"--script res://tests/run_tests.gd",
		"05f3045700fbef7122606e099a918a6cb59cc06a22ab1b7f826dc368df7bdeb2",
		"--export-debug \"Android Validation\"",
		"test -s builds/switchy-express-validation.apk",
		"sha256sum builds/switchy-express-validation.apk",
		"validation-build-manifest.json",
		"validation-build-summary.txt",
		"uses: actions/attest@v4",
		"subject-path: builds/switchy-express-validation.apk",
		"uses: actions/upload-artifact@v4",
		"retention-days: 14",
	]
	for token: String in required:
		assert_true(text.contains(token), "workflow must contain %s" % token)

	var test_index := text.find("name: Run complete headless test suite")
	var invariant_index := text.find("name: Verify product entrypoint invariants")
	var export_index := text.find("name: Export Android validation APK")
	var hash_index := text.find("name: Generate build evidence")
	var attest_index := text.find("name: Attest APK provenance")
	var upload_index := text.find("name: Upload validation evidence bundle")
	assert_true(
		test_index >= 0 and test_index < invariant_index and invariant_index < export_index
		and export_index < hash_index and hash_index < attest_index and attest_index < upload_index,
		"workflow steps must execute tests, invariants, export, evidence, attestation, upload in order"
	)

	var lowered := text.to_lower()
	assert_false(
		lowered.contains("godot_android_keystore_release"),
		"validation workflow must not configure release signing"
	)
	assert_false(lowered.contains("storepass android"), "workflow must not commit a fixed store password")
	assert_false(lowered.contains("keypass android"), "workflow must not commit a fixed key password")
	assert_false(text.contains("secrets."), "workflow must not depend on repository signing secrets")
	assert_false(text.contains("C:\\"), "workflow must not contain Windows user paths")
	assert_false(text.contains("/Users/"), "workflow must not contain macOS user paths")
