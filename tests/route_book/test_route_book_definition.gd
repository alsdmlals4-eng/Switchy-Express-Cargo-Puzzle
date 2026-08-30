extends "res://tests/test_case.gd"

const BOOK_PATH := "res://data/route_book/route_book_01.json"
const BOOK_02_PATH := "res://data/route_book/route_book_02.json"
const DefinitionScript := preload("res://game/route_book/route_book_definition.gd")
const DirectorScript := preload("res://game/route_book/route_book_director.gd")
const REQUIRED_IDS: Array[StringName] = [
	&"RB01_SERVICE_SIDINGS",
	&"RB02_REVERSE_ORDER",
	&"RB03_RETURN_MANIFEST",
	&"RB04_LOAD_WINDOW",
	&"RB05_FORK_LOCK",
	&"RB06_PORT_CIRCUIT",
]
const ROUTE_BOOK_02_IDS: Array[StringName] = [
	&"RB07_FOREST_RELAY",
	&"RB08_CAUTION_CUT",
	&"RB09_SALVAGE_SIDING",
	&"RB10_CLEAN_BREAK",
	&"RB11_TURNOUT_UNDER_LOAD",
	&"RB12_LANTERN_LOOP",
]


func run() -> void:
	var definition: Variant = DefinitionScript.load_from_path(BOOK_PATH)
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
	var director: Variant = DirectorScript.new()
	assert_true(director.configure(definition), "director configures valid Route Book")
	assert_false(director.select_stage(&"UNKNOWN"), "unknown Route Book stage is rejected")
	assert_true(director.select_stage(&"RB05_FORK_LOCK"), "known Route Book stage is selectable")
	assert_equal(director.current_stage_number(), 5, "selection preserves declared fixed order")

	var route_book_02: Variant = DefinitionScript.load_from_path(BOOK_02_PATH)
	assert_not_null(route_book_02, "Route Book 02 definition must load")
	if route_book_02 == null:
		return
	assert_equal(route_book_02.book_id(), &"ROUTE_BOOK_02", "Route Book 02 keeps its declared identity")
	assert_equal(route_book_02.stage_ids(), ROUTE_BOOK_02_IDS, "Route Book 02 stage order is exact")
	assert_equal(route_book_02.stage_count(), 6, "Route Book 02 has six direct stages")
	assert_true(director.configure(route_book_02), "director configures Route Book 02")
	assert_true(director.select_stage(&"RB12_LANTERN_LOOP"), "Route Book 02 capstone is selectable")
	assert_equal(director.current_stage_number(), 6, "Route Book 02 preserves fixed stage order")
