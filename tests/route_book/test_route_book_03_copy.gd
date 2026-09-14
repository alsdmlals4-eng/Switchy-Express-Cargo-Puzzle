extends "res://tests/test_case.gd"

const Definition := preload("res://game/route_book/route_book_definition.gd")
const Copy := preload("res://game/first_session/first_session_copy.gd")
const IDS: Array[StringName] = [&"RB13_FOUR_SIDES", &"RB14_MANIFEST_MIRROR", &"RB15_MANUAL_GAP", &"RB16_CAUTION_LEDGER", &"RB17_CLEARANCE_YARD", &"RB18_SWITCHBOARD_NIGHT"]
const BOOK_PATH := "res://data/route_book/route_book_03.json"
const COPY_PATH := "res://data/localization/route_book_03_v1.json"
const SELECTOR_PATH := "res://data/localization/route_book_selector_v1.json"
const LOCALES := ["ko", "en", "ja", "zh-Hans"]
const SELECTOR_KEYS := ["SX_RB_STAGE_BOOK", "SX_RB_SELECT_BOOK", "SX_RB_SELECT_STAGE", "SX_RB_BACK", "SX_RB01_STAGE_BOOK", "SX_RB02_STAGE_BOOK", "SX_RB03_STAGE_BOOK"]


func run() -> void:
	var book: Variant = Definition.load_from_path(BOOK_PATH)
	assert_not_null(book, "book03 exact definition exists")
	var copy: Variant = Copy.new()
	var selector: Variant = Copy.new()
	assert_true(copy.load_from_path(COPY_PATH), "book03 four-locale copy loads")
	assert_true(selector.load_from_path(SELECTOR_PATH), "shared selector four-locale copy loads")
	if book == null or not FileAccess.file_exists(COPY_PATH) or not FileAccess.file_exists(SELECTOR_PATH):
		return
	assert_equal(book.stage_ids(), IDS, "six ordered authored IDs")
	var data: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(BOOK_PATH))
	var copy_data: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(COPY_PATH))
	for key: String in SELECTOR_KEYS:
		assert_false(copy_data.strings.has(key), "book03 does not duplicate selector owner " + key)
		for locale: String in LOCALES:
			assert_false(selector.text(StringName(key), locale).is_empty(), "selector %s %s" % [key, locale])
	for index: int in range(6):
		var stage: Dictionary = book.stage(IDS[index])
		assert_equal(stage.map_path, "res://data/maps/route_book/" + str(IDS[index]).to_lower() + ".json", "stage exact map binding")
		assert_false(stage.visible_features.has("RECOMMENDED_LAYOUT"), "no solution disclosure")
		for suffix: String in ["TITLE", "OBJECTIVE", "CONTEXT"]:
			var key := "SX_RB%02d_%s" % [index + 13, suffix]
			for locale: String in LOCALES:
				assert_false(copy.text(StringName(key), locale).is_empty(), "%s %s" % [key, locale])
	for key: String in ["SX_RB_PROGRESS", "SX_RB_BEGIN", "SX_RB_NEXT_STAGE"]:
		for locale: String in LOCALES:
			assert_false(copy.text(StringName(key), locale).is_empty(), "selected book action " + key + locale)
	for corruption: String in ["map", "context", "missing", "duplicate", "order"]:
		var invalid: Dictionary = data.duplicate(true)
		match corruption:
			"map": invalid.stages[0].map_path = invalid.stages[1].map_path
			"context": invalid.stages[0].context_key = ""
			"missing": invalid.stages.pop_back()
			"duplicate": invalid.stages[1] = invalid.stages[0].duplicate(true)
			"order": invalid.stages.reverse()
		assert_equal(Definition.create(invalid), null, "book03 rejects " + corruption)
	# Test-only user:// file. Never alter the production translation owner.
	var malformed: Dictionary = copy_data.duplicate(true)
	malformed.strings.SX_RB13_CONTEXT.erase("ja")
	var temp_path := "user://route_book_03_missing_translation_test.json"
	var file := FileAccess.open(temp_path, FileAccess.WRITE)
	assert_not_null(file, "negative translation fixture writable")
	if file != null:
		file.store_string(JSON.stringify(malformed))
		file.close()
		assert_false(Copy.new().load_from_path(temp_path), "missing locale fails closed")
