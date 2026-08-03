extends "res://tests/test_case.gd"

const MapBuildPipelineScript := preload("res://game/map/map_build_pipeline.gd")
const RunIdentityScript := preload("res://game/run/run_identity.gd")
const Fixture := preload("res://tests/support/map_fixture.gd")


func run() -> void:
	var build: Variant = MapBuildPipelineScript.new().build_from_manifest_entry(
		Fixture.manifest_entry(&"map.sx.0001", 1)
	)
	assert_true(build.success, "identity test fixture must build")
	if not build.success:
		return

	var first: Variant = RunIdentityScript.create(build.definition, "run-a", 0, "")
	var retry: Variant = RunIdentityScript.create(build.definition, "run-b", 1, "run-a")
	assert_equal(retry.map_definition.identity_key(), first.map_definition.identity_key(), "retry must preserve exact map identity")
	assert_equal(retry.map_definition.content_signature, first.map_definition.content_signature, "retry must preserve exact content signature")
	assert_not_equal(retry.run_id, first.run_id, "retry must create a fresh run id")
	assert_equal(retry.retry_index, 1, "retry index must increment")
	assert_equal(retry.restarted_from_run_id, "run-a", "retry lineage must point to previous attempt")
	assert_not_equal(retry.transaction_namespace, first.transaction_namespace, "transaction namespace must be fresh per attempt")

	var public_data: Dictionary = retry.to_public_dictionary()
	assert_false(public_data.has("map_seed"), "public run identity must not expose raw map seed")
	assert_equal(public_data.get("map_id"), "map.sx.0001", "public run identity must expose semantic map id")
	assert_equal(public_data.get("retry_index"), 1, "public run identity may expose retry count")
