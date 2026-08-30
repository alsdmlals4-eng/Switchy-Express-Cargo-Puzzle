extends "res://tests/test_case.gd"

const BOOK_PATH := "res://data/route_book/route_book_01.json"
const DEFINITION_PATH := "res://game/route_book/route_book_definition.gd"
const DIRECTOR_PATH := "res://game/route_book/route_book_director.gd"
const REQUIRED_IDS: Array[StringName] = [
	&"RB01_SERVICE_SIDINGS",
	&"RB02_REVERSE_ORDER",
	&"RB03_RETURN_MANIFEST",
	&"RB04_LOAD_WINDOW",
	&"RB05_FORK_LOCK",
	&"RB06_PORT_CIRCUIT",
]


func run() -> void:
	var definition_script: Variant = load(DEFINITION_PATH)
	assert_not_null(definition_script, "Route Book definition script must exist")
	if definition_script == null:
		return
	var definition: Variant = definition_script.load_from_path(BOOK_PATH)
	assert_not_null(definition, "Route Book definition must load")
	if definition == null:
		return
	assert_equal(definition.stage_ids(), REQUIRED_IDS, "Route Book stage order is exact")
	assert_equal(definition.stage_count(), 6, "Route Book has exactly six fixed stages")
	var first_stage: Dictionary = definition.stage(&"RB01_SERVICE_SIDINGS")
	assert_false(
		first_stage.get("visible_features", []).has("RECOMMENDED_LAYOUT"),
		"Route Book never exposes a recommended solution",
	)
	assert_equal(
		StringName(first_stage.get("map_path", &"")),
		&"res://data/maps/route_book/rb01_service_sidings.json",
		"RB01 map path is canonical",
	)
	var director_script: Variant = load(DIRECTOR_PATH)
	assert_not_null(director_script, "Route Book director script must exist")
	if director_script == null:
		return
	var director: Variant = director_script.new()
	assert_true(director.configure(definition), "director configures valid Route Book")
	assert_false(director.select_stage(&"UNKNOWN"), "unknown Route Book stage is rejected")
	assert_true(director.select_stage(&"RB05_FORK_LOCK"), "known Route Book stage is selectable")
	assert_equal(director.current_stage_number(), 5, "selection preserves declared fixed order")
