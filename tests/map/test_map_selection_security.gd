extends "res://tests/test_case.gd"

const MapBuildPipelineScript := preload("res://game/map/map_build_pipeline.gd")
const MapCatalogScript := preload("res://game/map/map_catalog.gd")
const MapDiscoveryStateScript := preload("res://game/map/map_discovery_state.gd")
const MapSelectionReceiptScript := preload("res://game/map/map_selection_receipt.gd")
const MapSelectionRequestScript := preload("res://game/map/map_selection_request.gd")
const MapSelectionServiceScript := preload("res://game/map/map_selection_service.gd")
const Fixture := preload("res://tests/support/map_fixture.gd")


func run() -> void:
	var catalog: Variant = MapCatalogScript.new()
	var loaded: Dictionary = catalog.load_manifest(
		Fixture.manifest_data(),
		MapBuildPipelineScript.new()
	)
	assert_true(loaded.get("success", false), "security fixture catalog must load")
	if not loaded.get("success", false):
		return

	var discovery: Variant = MapDiscoveryStateScript.new()
	discovery.configure(catalog.stable_map_ids(), 19)
	var service: Variant = MapSelectionServiceScript.new()
	service.configure(catalog, discovery)

	var undiscovered_id: StringName = catalog.stable_map_ids()[0]
	var forged_request: Variant = MapSelectionRequestScript.select_discovered(
		"forged-request",
		undiscovered_id
	)
	var forged_receipt: Variant = MapSelectionReceiptScript.create(
		forged_request,
		&"MANUAL",
		catalog.resolve_latest(undiscovered_id)
	)
	assert_false(service.commit_started(forged_receipt), "service must reject receipts it did not issue")
	assert_equal(discovery.discovered_ids().size(), 0, "forged receipt must not discover map")

	var issued: Variant = service.select(
		MapSelectionRequestScript.auto_new_run("duplicate-id")
	)
	assert_true(issued.success, "first request id must issue receipt")
	var duplicate: Variant = service.select(
		MapSelectionRequestScript.auto_new_run("duplicate-id")
	)
	assert_false(duplicate.success, "same request id must not issue a second receipt")
	assert_equal(duplicate.error_code, &"DUPLICATE_REQUEST", "duplicate request rejection must be explicit")

	issued.receipt.content_signature = "tampered"
	assert_false(service.commit_started(issued.receipt), "mutated receipt must fail issued snapshot validation")
	assert_equal(discovery.discovered_ids().size(), 0, "mutated issued receipt must not commit discovery")
	assert_equal(discovery.undiscovered_remaining_count(), 3, "mutated receipt must not consume bag")
