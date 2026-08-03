extends "res://tests/test_case.gd"

const MapBuildPipelineScript := preload("res://game/map/map_build_pipeline.gd")
const Fixture := preload("res://tests/support/map_fixture.gd")


func run() -> void:
	var pipeline: Variant = MapBuildPipelineScript.new()
	var first: Variant = pipeline.build_from_manifest_entry(Fixture.manifest_entry(&"map.sx.0001", 1))
	assert_true(first.success, "eligible manifest entry must build without fallback")
	assert_not_null(first.definition, "successful build must return immutable definition")
	assert_true(first.definition.is_runtime_eligible(), "built definition must be runtime eligible")
	assert_true(not first.definition.graph_signature.is_empty(), "graph signature must be recorded")
	assert_true(not first.definition.station_signature.is_empty(), "station signature must be recorded")
	assert_true(not first.definition.initial_pickup_signature.is_empty(), "pickup signature must be recorded")

	var rebuilt: Variant = pipeline.rebuild(first.definition)
	assert_true(rebuilt.success, "same definition must rebuild successfully")
	assert_equal(rebuilt.definition.graph_signature, first.definition.graph_signature, "graph reconstruction signature must match")
	assert_equal(rebuilt.definition.station_signature, first.definition.station_signature, "station reconstruction signature must match")
	assert_equal(rebuilt.definition.initial_pickup_signature, first.definition.initial_pickup_signature, "pickup reconstruction signature must match")
	assert_equal(rebuilt.definition.layout_signature, first.definition.layout_signature, "layout reconstruction signature must match")
	assert_equal(rebuilt.definition.content_signature, first.definition.content_signature, "content reconstruction signature must match")

	var tampered_data: Dictionary = first.definition.to_dictionary()
	tampered_data["graph_signature"] = "tampered"
	var tampered: Variant = preload("res://game/map/map_definition.gd").create(tampered_data)
	var rejected: Variant = pipeline.rebuild(tampered)
	assert_false(rejected.success, "signature mismatch must fail reconstruction explicitly")
