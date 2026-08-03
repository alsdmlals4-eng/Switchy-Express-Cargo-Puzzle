extends "res://tests/test_case.gd"

const MapCatalogScript := preload("res://game/map/map_catalog.gd")
const MapBuildPipelineScript := preload("res://game/map/map_build_pipeline.gd")
const Fixture := preload("res://tests/support/map_fixture.gd")


func run() -> void:
	var catalog: Variant = MapCatalogScript.new()
	var load_result: Dictionary = catalog.load_manifest(
		Fixture.manifest_data(),
		MapBuildPipelineScript.new()
	)
	assert_true(load_result.get("success", false), "target3 manifest must load successfully")
	assert_equal(catalog.runtime_entries().size(), 3, "Vertical Slice catalog must contain exactly three maps")
	assert_equal(catalog.unique_layout_count(), 3, "target3 maps must have distinct layout signatures")
	assert_not_null(catalog.resolve(&"map.sx.0001", 1), "exact map revision must resolve")
	assert_equal(catalog.resolve(&"map.sx.0001", 2), null, "unavailable revision must not silently substitute")

	var duplicate_manifest: Dictionary = Fixture.manifest_data()
	duplicate_manifest["entries"] = [
		Fixture.manifest_entry(&"map.sx.0001", 1),
		Fixture.manifest_entry(&"map.sx.0002", 1),
		Fixture.manifest_entry(&"map.sx.0003", 5),
	]
	var duplicate_catalog: Variant = MapCatalogScript.new()
	var duplicate_result: Dictionary = duplicate_catalog.load_manifest(
		duplicate_manifest,
		MapBuildPipelineScript.new()
	)
	assert_false(duplicate_result.get("success", true), "duplicate reconstructed layout must reject the whole strict catalog")
	assert_equal(duplicate_catalog.runtime_entries().size(), 0, "failed strict load must leave no partial runtime entries")

	var fallback_manifest: Dictionary = Fixture.manifest_data()
	fallback_manifest["entries"][0]["force_candidate_failure"] = true
	var fallback_result: Dictionary = MapCatalogScript.new().load_manifest(
		fallback_manifest,
		MapBuildPipelineScript.new()
	)
	assert_false(fallback_result.get("success", true), "fallback-generated entry must be rejected")
