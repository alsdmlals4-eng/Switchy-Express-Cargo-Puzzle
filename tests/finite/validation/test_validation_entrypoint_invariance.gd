extends "res://tests/test_case.gd"

const PROJECT_PATH := "res://project.godot"
const PRESET_PATH := "res://export_presets.cfg"
const MAIN_SCENE_PATH := "res://game/main/main.tscn"
const APPROVED_MAIN_SHA256 := "05f3045700fbef7122606e099a918a6cb59cc06a22ab1b7f826dc368df7bdeb2"


func run() -> void:
	var project_text := FileAccess.get_file_as_string(PROJECT_PATH)
	assert_true(
		project_text.contains("run/main_scene=\"res://game/main/main.tscn\""),
		"base production main must remain legacy"
	)
	assert_true(
		project_text.contains(
			"run/main_scene.validation_harness=\"res://tools/validation/finite/finite_validation_launcher.tscn\""
		),
		"feature override must target validation launcher"
	)
	assert_true(
		project_text.contains(
			"textures/vram_compression/import_etc2_astc=true"
		),
		"Android export must enable ETC2/ASTC texture imports"
	)

	var hash_context := HashingContext.new()
	assert_equal(hash_context.start(HashingContext.HASH_SHA256), OK, "main scene hash must initialize")
	hash_context.update(FileAccess.get_file_as_bytes(MAIN_SCENE_PATH))
	assert_equal(
		hash_context.finish().hex_encode(),
		APPROVED_MAIN_SHA256,
		"game/main/main.tscn must remain the approved baseline"
	)

	assert_true(FileAccess.file_exists(PRESET_PATH), "Android validation export preset must exist")
	if not FileAccess.file_exists(PRESET_PATH):
		return
	var preset_text := FileAccess.get_file_as_string(PRESET_PATH)
	assert_true(preset_text.contains("name=\"Android Validation\""), "validation preset name must exist")
	assert_true(
		preset_text.contains("custom_features=\"validation_harness\""),
		"preset must activate validation feature"
	)
	assert_true(
		preset_text.contains(
			"package/unique_name=\"com.alsdmlals4.switchyexpress.validation\""
		),
		"validation package ID must be isolated"
	)
	var lowered := preset_text.to_lower()
	assert_false(lowered.contains("password"), "preset must not commit passwords")
	assert_false(preset_text.contains("C:\\"), "preset must not commit Windows user paths")
	assert_false(preset_text.contains("/Users/"), "preset must not commit macOS user paths")
	assert_false(preset_text.contains("/home/"), "preset must not commit Linux user paths")

	var config := ConfigFile.new()
	assert_equal(config.load(PRESET_PATH), OK, "export preset must parse")
	assert_equal(
		config.get_value("preset.0", "name", ""),
		"Android Validation",
		"preset name must match CLI contract"
	)
	assert_equal(
		config.get_value("preset.0", "platform", ""),
		"Android",
		"preset platform must be Android"
	)
	assert_equal(
		config.get_value("preset.0", "custom_features", ""),
		"validation_harness",
		"preset must activate validation feature"
	)
	assert_equal(
		config.get_value("preset.0.options", "package/unique_name", ""),
		"com.alsdmlals4.switchyexpress.validation",
		"package ID must be isolated"
	)
