extends "res://tests/test_case.gd"

const MapBuildPipelineScript := preload("res://game/map/map_build_pipeline.gd")
const MapCatalogScript := preload("res://game/map/map_catalog.gd")
const MapDiscoveryStateScript := preload("res://game/map/map_discovery_state.gd")
const MapSelectionRequestScript := preload("res://game/map/map_selection_request.gd")
const MapSelectionServiceScript := preload("res://game/map/map_selection_service.gd")
const RunIdentityScript := preload("res://game/run/run_identity.gd")
const Fixture := preload("res://tests/support/map_fixture.gd")


func run() -> void:
	var catalog: Variant = MapCatalogScript.new()
	var catalog_result: Dictionary = catalog.load_manifest(
		Fixture.manifest_data(),
		MapBuildPipelineScript.new()
	)
	assert_true(catalog_result.get("success", false), "selection test catalog must load")
	if not catalog_result.get("success", false):
		return

	var discovery: Variant = MapDiscoveryStateScript.new()
	discovery.configure(catalog.stable_map_ids(), 42)
	var service: Variant = MapSelectionServiceScript.new()
	service.configure(catalog, discovery)

	var automatic: Variant = service.select(
		MapSelectionRequestScript.auto_new_run("auto-1")
	)
	assert_true(automatic.success, "automatic selection must return receipt")
	assert_equal(discovery.discovered_ids().size(), 0, "selection alone must not commit discovery")
	assert_equal(discovery.undiscovered_remaining_count(), 3, "selection alone must not consume undiscovered bag")
	assert_false(automatic.receipt.to_public_dictionary().has("map_seed"), "selection receipt must hide raw seed")

	assert_true(service.commit_started(automatic.receipt), "run start commit must apply receipt exactly once")
	assert_equal(discovery.discovered_ids().size(), 1, "committed run start must discover selected map")
	assert_equal(discovery.play_count(automatic.receipt.map_id), 1, "committed run start must increment play count")
	assert_equal(discovery.undiscovered_remaining_count(), 2, "committed automatic selection must consume one bag entry")
	assert_false(service.commit_started(automatic.receipt), "duplicate receipt commit must be idempotently ignored")
	assert_equal(discovery.play_count(automatic.receipt.map_id), 1, "duplicate receipt must not double count play")

	var undiscovered_id: StringName = &""
	for map_id: StringName in catalog.stable_map_ids():
		if not discovery.is_discovered(map_id):
			undiscovered_id = map_id
			break
	var rejected_manual: Variant = service.select(
		MapSelectionRequestScript.select_discovered("manual-reject", undiscovered_id)
	)
	assert_false(rejected_manual.success, "manual selection must reject undiscovered maps")
	assert_equal(rejected_manual.error_code, &"MAP_NOT_DISCOVERED", "manual rejection must be explicit")

	var remaining_before_manual: int = discovery.undiscovered_remaining_count()
	var manual: Variant = service.select(
		MapSelectionRequestScript.select_discovered("manual-ok", automatic.receipt.map_id)
	)
	assert_true(manual.success, "manual selection must allow discovered semantic id")
	assert_true(service.commit_started(manual.receipt), "manual run start may update play history")
	assert_equal(discovery.undiscovered_remaining_count(), remaining_before_manual, "manual selection must not consume automatic bag")

	var definition: Variant = catalog.resolve_latest(automatic.receipt.map_id)
	var previous_identity: Variant = RunIdentityScript.create(definition, "run-a", 0, "")
	var remaining_before_restart: int = discovery.undiscovered_remaining_count()
	var restart: Variant = service.select(
		MapSelectionRequestScript.restart("restart-1", previous_identity)
	)
	assert_true(restart.success, "restart selection must resolve exact previous map")
	assert_equal(restart.receipt.map_id, previous_identity.map_definition.map_id, "restart must preserve stable map id")
	assert_equal(restart.receipt.map_revision, previous_identity.map_definition.map_revision, "restart must preserve exact map revision")
	assert_equal(restart.receipt.content_signature, previous_identity.map_definition.content_signature, "restart must preserve exact content signature")
	assert_true(service.commit_started(restart.receipt), "restart run start may update play history")
	assert_equal(discovery.undiscovered_remaining_count(), remaining_before_restart, "restart must not consume automatic bag")
