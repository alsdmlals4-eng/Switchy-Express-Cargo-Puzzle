extends SceneTree

const TEST_SCRIPTS: Array[Script] = [
	preload("res://tests/smoke/test_project_boot.gd"),
	preload("res://tests/rail/test_rail_generator.gd"),
	preload("res://tests/rail/test_switch_routing.gd"),
	preload("res://tests/map/test_map_definition.gd"),
	preload("res://tests/map/test_map_build_pipeline.gd"),
	preload("res://tests/map/test_map_catalog.gd"),
	preload("res://tests/map/test_vs03_catalog_asset.gd"),
	preload("res://tests/map/test_map_selection_request.gd"),
	preload("res://tests/map/test_map_shuffle_bag.gd"),
	preload("res://tests/map/test_map_selection_service.gd"),
	preload("res://tests/train/test_train_movement.gd"),
	preload("res://tests/train/test_compact_wagon_tokens.gd"),
	preload("res://tests/train/test_train_footprint.gd"),
	preload("res://tests/cargo/test_cargo_stack.gd"),
	preload("res://tests/station/test_station_placement.gd"),
	preload("res://tests/cargo/test_cargo_spawner.gd"),
	preload("res://tests/station/test_station_unloading.gd"),
	preload("res://tests/integration/test_delivery_loop.gd"),
	preload("res://tests/integration/test_compact_footprint_respawn.gd"),
	preload("res://tests/integration/test_run_controller_delivery_loop.gd"),
	preload("res://tests/integration/test_three_map_discovery_flow.gd"),
	preload("res://tests/integration/test_map_run_session_flow.gd"),
	preload("res://tests/run/test_run_balance.gd"),
	preload("res://tests/run/test_run_state.gd"),
	preload("res://tests/difficulty/test_difficulty_director.gd"),
	preload("res://tests/run/test_run_controller.gd"),
	preload("res://tests/run/test_run_controller_difficulty_events.gd"),
	preload("res://tests/run/test_run_controller_guards.gd"),
	preload("res://tests/run/test_run_identity.gd"),
	preload("res://tests/run/test_run_session_factory.gd"),
]

const WATCHDOG_SECONDS := 10.0


func _initialize() -> void:
	var watchdog: SceneTreeTimer = create_timer(WATCHDOG_SECONDS)
	watchdog.timeout.connect(_on_watchdog_timeout)
	call_deferred("_run_all")


func _run_all() -> void:
	var failed_cases: int = 0
	var assertion_total: int = 0

	for test_script: Script in TEST_SCRIPTS:
		var test_case: RefCounted = test_script.new()
		test_case.run()
		assertion_total += test_case.assertion_count
		if test_case.passed():
			print("PASS: %s (%d assertions)" % [test_script.resource_path, test_case.assertion_count])
		else:
			failed_cases += 1
			print("FAIL: %s" % test_script.resource_path)
			for failure: String in test_case.failures:
				print("  - %s" % failure)

	print("TEST SUMMARY: cases=%d failed=%d assertions=%d" % [TEST_SCRIPTS.size(), failed_cases, assertion_total])
	quit(1 if failed_cases > 0 else 0)


func _on_watchdog_timeout() -> void:
	printerr("TEST WATCHDOG TIMEOUT after %.1f seconds" % WATCHDOG_SECONDS)
	quit(2)
