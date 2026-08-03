extends "res://tests/test_case.gd"

const MapBuildPipelineScript := preload("res://game/map/map_build_pipeline.gd")
const MapCatalogScript := preload("res://game/map/map_catalog.gd")
const MapDiscoveryStateScript := preload("res://game/map/map_discovery_state.gd")
const MapSelectionRequestScript := preload("res://game/map/map_selection_request.gd")
const MapSelectionServiceScript := preload("res://game/map/map_selection_service.gd")
const RunIdFactoryScript := preload("res://game/run/run_id_factory.gd")
const RunSessionFactoryScript := preload("res://game/run/run_session_factory.gd")
const RunSessionStartServiceScript := preload("res://game/run/run_session_start_service.gd")
const FailingRunSessionFactoryScript := preload("res://tests/support/failing_run_session_factory.gd")
const Fixture := preload("res://tests/support/map_fixture.gd")


func run() -> void:
	var pipeline: Variant = MapBuildPipelineScript.new()
	var catalog: Variant = MapCatalogScript.new()
	var loaded: Dictionary = catalog.load_manifest(Fixture.manifest_data(), pipeline)
	assert_true(loaded.get("success", false), "flow catalog must load")
	if not loaded.get("success", false):
		return

	var discovery: Variant = MapDiscoveryStateScript.new()
	discovery.configure(catalog.stable_map_ids(), 91)
	var selection: Variant = MapSelectionServiceScript.new()
	selection.configure(catalog, discovery)
	var id_factory: Variant = RunIdFactoryScript.new()
	id_factory.configure_sequence(["run-a", "run-b", "run-c", "run-d"])
	var session_factory: Variant = RunSessionFactoryScript.new()
	session_factory.configure(pipeline, id_factory)
	var start_service: Variant = RunSessionStartServiceScript.new()
	start_service.configure(selection, session_factory)

	var first_cycle: Array[StringName] = []
	var latest_session: Variant
	for index: int in range(3):
		var started: Dictionary = start_service.start(
			MapSelectionRequestScript.auto_new_run("flow-%d" % index)
		)
		assert_true(started.get("success", false), "automatic flow must create and commit session")
		if not started.get("success", false):
			return
		latest_session = started.get("session")
		assert_true(latest_session.is_fully_configured(), "started flow session must be fully configured")
		assert_false(first_cycle.has(latest_session.identity.map_definition.map_id), "first target3 sessions must use unique maps")
		first_cycle.append(latest_session.identity.map_definition.map_id)
		assert_true(discovery.is_receipt_committed(started.get("receipt").receipt_id), "successful session start must commit selection receipt")

	assert_equal(discovery.discovered_ids().size(), 3, "three successful sessions must discover target3")
	assert_equal(discovery.total_play_count(), 3, "three successful sessions must record three plays")

	var restarted: Dictionary = start_service.start(
		MapSelectionRequestScript.restart("flow-restart", latest_session.identity)
	)
	assert_true(restarted.get("success", false), "end-to-end exact restart must succeed")
	var retry: Variant = restarted.get("session")
	assert_equal(retry.identity.map_definition.identity_key(), latest_session.identity.map_definition.identity_key(), "end-to-end restart must preserve exact map")
	assert_equal(retry.identity.map_definition.content_signature, latest_session.identity.map_definition.content_signature, "end-to-end restart must preserve content signature")
	assert_equal(retry.identity.run_id, "run-d", "restart must allocate fresh run id")
	assert_equal(retry.identity.retry_index, 1, "restart must increment attempt lineage")
	assert_not_equal(retry.run_controller, latest_session.run_controller, "restart must create fresh run authority")
	assert_equal(discovery.total_play_count(), 4, "committed restart must record one additional play")

	var failure_discovery: Variant = MapDiscoveryStateScript.new()
	failure_discovery.configure(catalog.stable_map_ids(), 91)
	var failure_selection: Variant = MapSelectionServiceScript.new()
	failure_selection.configure(catalog, failure_discovery)
	var failing_service: Variant = RunSessionStartServiceScript.new()
	failing_service.configure(failure_selection, FailingRunSessionFactoryScript.new())
	var failed: Dictionary = failing_service.start(
		MapSelectionRequestScript.auto_new_run("flow-fail")
	)
	assert_false(failed.get("success", true), "session construction failure must remain failure")
	assert_equal(failed.get("error_code"), &"INJECTED_FAILURE", "construction failure code must be preserved")
	assert_equal(failure_discovery.discovered_ids().size(), 0, "failed session construction must not commit discovery")
	assert_equal(failure_discovery.undiscovered_remaining_count(), 3, "failed session construction must not consume automatic bag")
