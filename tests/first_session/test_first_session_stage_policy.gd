extends "res://tests/test_case.gd"

const DefinitionScript := preload("res://game/first_session/first_session_definition.gd")
const PolicyScript := preload("res://game/first_session/first_session_stage_policy.gd")
const PATH := "res://data/first_session/first_session_v1.json"


func run() -> void:
	var definition: Variant = DefinitionScript.load_from_path(PATH)
	assert_not_null(definition, "definition is required by policy tests")
	if definition == null:
		return

	var t1: Variant = PolicyScript.create(definition.lesson(&"T1"))
	assert_not_null(t1, "T1 policy must load")
	assert_true(t1.allows_command(&"BUILD_TOOL", &"BUILD", &"STRAIGHT"), "T1 allows straight")
	assert_true(t1.allows_command(&"BUILD_TOOL", &"BUILD", &"CURVE"), "T1 allows curve")
	assert_false(t1.allows_command(&"BUILD_TOOL", &"BUILD", &"SWITCH"), "T1 blocks switch")
	assert_false(t1.allows_command(&"START", &"BUILD"), "T1 blocks premature start")
	assert_false(t1.allows_command(&"AUTO_TOGGLE", &"RUNNING"), "T1 blocks auto")
	assert_true(t1.feature_visible(&"BOARD"), "T1 board is visible")
	assert_false(t1.feature_visible(&"AUTO_LOAD"), "T1 auto is hidden")

	var t5: Variant = PolicyScript.create(definition.lesson(&"T5"))
	assert_true(t5.allows_command(&"AUTO_TOGGLE", &"RUNNING"), "T5 allows auto toggle")
	assert_false(t5.allows_command(&"SWITCH", &"RUNNING"), "T5 blocks switch")
	assert_true(
		t5.allows_command(&"RETRY_SAME_LAYOUT", &"FAILURE"),
		"terminal retry is a first-session lifecycle command, not a lesson bypass",
	)
	assert_true(
		t5.allows_command(&"EDIT_LAYOUT", &"FAILURE"),
		"policy must recognize terminal edit; the shell separately controls its visibility",
	)

	var capstone: Variant = PolicyScript.create(definition.lesson(&"CAPSTONE"))
	assert_true(capstone.allows_command(&"BUILD_TOOL", &"BUILD", &"CROSSING"), "capstone allows crossing")
	assert_true(capstone.allows_command(&"BOARD_CELL", &"RUNNING"), "capstone allows route controls")
