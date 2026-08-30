extends "res://tests/test_case.gd"

const CopyScript := preload("res://game/first_session/first_session_copy.gd")
const COPY_PATH := "res://data/localization/route_book_01_v1.json"
const LOCALES: Array[String] = ["ko", "en", "ja", "zh-Hans"]
const KEYS: Array[StringName] = [
	&"SX_RB_STAGE_BOOK",
	&"SX_RB_SELECT_STAGE",
	&"SX_RB_BACK",
	&"SX_RB_BEGIN",
	&"SX_RB_NEXT_STAGE",
	&"SX_RB_PROGRESS",
	&"SX_RB01_TITLE",
	&"SX_RB01_OBJECTIVE",
	&"SX_RB06_TITLE",
	&"SX_RB06_OBJECTIVE",
]


func run() -> void:
	var copy: Variant = CopyScript.new()
	assert_true(copy.load_from_path(COPY_PATH), "Route Book copy must load through the reusable JSON-path loader")
	for key: StringName in KEYS:
		for locale: String in LOCALES:
			assert_false(
				copy.text(key, locale).is_empty(),
				"%s resolves in %s" % [key, locale],
			)
