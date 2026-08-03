extends "res://tests/test_case.gd"

const CATALOG_PATH := "res://data/maps/map_catalog_vs03.json"
const MapBuildPipelineScript := preload("res://game/map/map_build_pipeline.gd")
const MapCatalogScript := preload("res://game/map/map_catalog.gd")


func run() -> void:
	assert_true(FileAccess.file_exists(CATALOG_PATH), "VS03 target3 catalog asset must exist")
	if not FileAccess.file_exists(CATALOG_PATH):
		return
	var catalog_text := FileAccess.get_file_as_string(CATALOG_PATH)
	assert_false(catalog_text.is_empty(), "VS03 target3 catalog asset must not be empty")

	var catalog: Variant = MapCatalogScript.new()
	var loaded: Dictionary = catalog.load_json_text(
		catalog_text,
		MapBuildPipelineScript.new()
	)
	assert_true(loaded.get("success", false), "checked-in target3 catalog must pass strict reconstruction")
	assert_equal(catalog.runtime_entries().size(), 3, "checked-in VS catalog must contain exactly three runtime maps")
	assert_equal(catalog.unique_layout_count(), 3, "checked-in VS maps must have unique layout signatures")
	assert_equal(catalog.catalog_revision(), &"vs03-target3-r1", "catalog revision must be explicit")

	for definition: Variant in catalog.runtime_entries():
		assert_true(definition.is_runtime_eligible(), "every checked-in map must be runtime eligible")
		assert_false(definition.used_fallback, "checked-in official map must never use fallback")
		assert_false(definition.to_public_dictionary().has("map_seed"), "checked-in map public data must hide seed")
