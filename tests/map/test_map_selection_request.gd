extends "res://tests/test_case.gd"

const MapSelectionRequestScript := preload("res://game/map/map_selection_request.gd")


func run() -> void:
	var automatic: Variant = MapSelectionRequestScript.auto_new_run("select-a")
	assert_equal(automatic.mode, &"AUTO_NEW_RUN", "automatic request must use semantic mode")
	assert_true(automatic.validation_errors().is_empty(), "valid automatic request must pass validation")
	assert_equal(automatic.requested_map_id, &"", "automatic request must not choose a raw map id")

	var manual: Variant = MapSelectionRequestScript.select_discovered("select-b", &"")
	assert_true(manual.validation_errors().has("requested_map_id is required"), "manual request requires stable map id")

	var restart: Variant = MapSelectionRequestScript.restart("select-c", null)
	assert_true(restart.validation_errors().has("previous_run_identity is required"), "restart requires previous run identity")

	var public_data: Dictionary = automatic.to_dictionary()
	assert_false(public_data.has("map_seed"), "selection request must never contain raw seed")
	assert_false(public_data.has("map_revision"), "automatic request must not choose a revision")
