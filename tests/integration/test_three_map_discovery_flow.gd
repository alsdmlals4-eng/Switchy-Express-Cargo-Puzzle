extends "res://tests/test_case.gd"

const MapBuildPipelineScript := preload("res://game/map/map_build_pipeline.gd")
const MapCatalogScript := preload("res://game/map/map_catalog.gd")
const MapDiscoveryStateScript := preload("res://game/map/map_discovery_state.gd")
const MapSelectionRequestScript := preload("res://game/map/map_selection_request.gd")
const MapSelectionServiceScript := preload("res://game/map/map_selection_service.gd")
const Fixture := preload("res://tests/support/map_fixture.gd")


func run() -> void:
	var catalog: Variant = MapCatalogScript.new()
	var loaded: Dictionary = catalog.load_manifest(
		Fixture.manifest_data(),
		MapBuildPipelineScript.new()
	)
	assert_true(loaded.get("success", false), "three-map flow catalog must load")
	if not loaded.get("success", false):
		return

	var discovery: Variant = MapDiscoveryStateScript.new()
	discovery.configure(catalog.stable_map_ids(), 77)
	var service: Variant = MapSelectionServiceScript.new()
	service.configure(catalog, discovery)

	var first_cycle: Array[StringName] = []
	for index: int in range(3):
		var selected: Variant = service.select(
			MapSelectionRequestScript.auto_new_run("auto-%d" % index)
		)
		assert_true(selected.success, "each target3 automatic selection must succeed")
		if not selected.success:
			return
		assert_false(first_cycle.has(selected.receipt.map_id), "first three automatic starts must be unique")
		first_cycle.append(selected.receipt.map_id)
		assert_true(service.commit_started(selected.receipt), "each selected run must commit once")

	assert_equal(discovery.discovered_ids().size(), 3, "first target3 cycle must discover all official VS maps")
	assert_equal(discovery.undiscovered_remaining_count(), 0, "undiscovered bag must empty after target3 cycle")

	var most_recent: StringName = discovery.recent_ids()[0]
	var replay: Variant = service.select(
		MapSelectionRequestScript.auto_new_run("auto-replay")
	)
	assert_true(replay.success, "automatic selection must continue after all maps are discovered")
	assert_not_equal(replay.receipt.map_id, most_recent, "replay cycle must avoid immediate repeat when alternatives exist")
	assert_equal(replay.receipt.selection_phase, &"REPLAY", "post-discovery automatic selection must use replay phase")
	assert_true(service.commit_started(replay.receipt), "replay receipt must commit")
	assert_equal(discovery.total_play_count(), 4, "four committed starts must create four play records")
