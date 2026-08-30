extends "res://tests/test_case.gd"

const CopyScript := preload("res://game/first_session/first_session_copy.gd")
const COPY_PATH := "res://data/localization/route_book_02_v1.json"
const LOCALES: Array[String] = ["ko", "en", "ja", "zh-Hans"]
const KEYS: Array[StringName] = [
	&"SX_RB_STAGE_BOOK",
	&"SX_RB_SELECT_BOOK",
	&"SX_RB01_STAGE_BOOK",
	&"SX_RB02_STAGE_BOOK",
	&"SX_RB07_TITLE",
	&"SX_RB07_OBJECTIVE",
	&"SX_RB08_TITLE",
	&"SX_RB08_OBJECTIVE",
	&"SX_RB09_TITLE",
	&"SX_RB09_OBJECTIVE",
	&"SX_RB10_TITLE",
	&"SX_RB10_OBJECTIVE",
	&"SX_RB11_TITLE",
	&"SX_RB11_OBJECTIVE",
	&"SX_RB12_TITLE",
	&"SX_RB12_OBJECTIVE",
]


func run() -> void:
	var copy: Variant = CopyScript.new()
	assert_true(copy.load_from_path(COPY_PATH), "Route Book 02 copy must load")
	for key: StringName in KEYS:
		for locale: String in LOCALES:
			assert_false(
				copy.text(key, locale).is_empty(),
				"%s resolves in %s" % [key, locale],
			)
