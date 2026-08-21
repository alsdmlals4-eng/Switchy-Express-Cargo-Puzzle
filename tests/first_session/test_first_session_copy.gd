extends "res://tests/test_case.gd"

const CopyScript := preload("res://game/first_session/first_session_copy.gd")
const LOCALES: Array[String] = ["ko", "en", "ja", "zh-Hans"]
const KEYS: Array[StringName] = [
	&"SX_FS_START", &"SX_T1_TITLE", &"SX_T1_OBJECTIVE", &"SX_T1_READY",
	&"SX_T2_TITLE", &"SX_T2_OBJECTIVE", &"SX_T2_LOAD_CUE", &"SX_T2_UNLOAD_NOTE",
	&"SX_T3_TITLE", &"SX_T3_OBJECTIVE", &"SX_T3_TOP_RULE",
	&"SX_T4_TITLE", &"SX_T4_OBJECTIVE", &"SX_T4_SKIP_CUE", &"SX_T4_REVISIT_CUE",
	&"SX_T5_TITLE", &"SX_T5_OBJECTIVE", &"SX_T5_AUTO_ON", &"SX_T5_AUTO_OFF_HINT",
	&"SX_T6_TITLE", &"SX_T6_OBJECTIVE", &"SX_T6_PRESET_CUE", &"SX_T6_LOCK_CUE",
	&"SX_CAPSTONE_TITLE", &"SX_CAPSTONE_OBJECTIVE",
	&"SX_RESULT_SUCCESS", &"SX_RESULT_ROUTE_END", &"SX_RESULT_TIME_EXPIRED",
	&"SX_RESULT_MAP_CARGO", &"SX_RESULT_STACK_CARGO", &"SX_RESULT_RETRY", &"SX_RESULT_EDIT",
	&"SX_RESULT_OTHER_SOLUTION", &"SX_ACTION_START_LESSON", &"SX_ACTION_START_RUN",
	&"SX_ACTION_CONTINUE",
]


func run() -> void:
	var copy: Variant = CopyScript.new()
	assert_true(copy.load_default(), "default first-session copy must load")
	for key: StringName in KEYS:
		for locale: String in LOCALES:
			assert_false(copy.text(key, locale).is_empty(), "%s resolves in %s" % [key, locale])
	assert_equal(copy.text(&"SX_FS_START", "fr"), copy.text(&"SX_FS_START", "en"), "unknown locale falls back to English")
	assert_equal(copy.text(&"SX_FS_START", "zh_CN"), copy.text(&"SX_FS_START", "zh-Hans"), "zh_CN normalizes to zh-Hans")
	assert_equal(copy.text(&"UNKNOWN", "ko"), "", "unknown key never leaks raw key")
	assert_true(copy.format(&"SX_RESULT_MAP_CARGO", {"count": 3}, "en").contains("3"), "format replaces count")
	for locale: String in LOCALES:
		assert_true(copy.text(&"SX_T3_TOP_RULE", locale).contains("TOP"), "TOP remains literal in %s" % locale)
	var t6_objectives := {
		"ko": "열차가 오기 전에 분기를 바꿔 배송 경로를 선택하세요.",
		"en": "Set the switch before the train arrives to choose the delivery route.",
		"ja": "列車が来る前に分岐を切り替え、配送経路を選んでください。",
		"zh-Hans": "列车到达前切换道岔，选择配送路线。",
	}
	for locale: String in LOCALES:
		assert_equal(
			copy.text(&"SX_T6_OBJECTIVE", locale),
			t6_objectives[locale],
			"T6 copy must describe the shipped one-switch causal lesson in %s" % locale,
		)
