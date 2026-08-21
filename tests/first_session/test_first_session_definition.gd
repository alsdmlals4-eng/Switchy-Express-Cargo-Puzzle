extends "res://tests/test_case.gd"

const DefinitionScript := preload("res://game/first_session/first_session_definition.gd")
const PATH := "res://data/first_session/first_session_v1.json"


func run() -> void:
	var definition: Variant = DefinitionScript.load_from_path(PATH)
	assert_not_null(definition, "first-session definition must load")
	if definition == null:
		return
	assert_equal(
		definition.lesson_ids(),
		[&"T1", &"T2", &"T3", &"T4", &"T5", &"T6", &"CAPSTONE"],
		"approved lesson order must remain canonical"
	)
	assert_equal(
		str(definition.lesson(&"T1").get("map_path", "")),
		str(definition.lesson(&"T2").get("map_path", "")),
		"T1/T2 must share one map"
	)
	assert_equal(
		str(definition.lesson(&"CAPSTONE").get("map_path", "")),
		"res://data/maps/vs_demo_01.json",
		"capstone must reuse VS_DEMO_01"
	)

	var mutated: Dictionary = definition.lesson(&"T1")
	mutated["map_path"] = "tampered"
	assert_not_equal(
		definition.lesson(&"T1").get("map_path"),
		"tampered",
		"public lesson getter must return a defensive copy"
	)
