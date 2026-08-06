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
	preload("res://tests/map/test_map_selection_security.gd"),
	preload("res://tests/finite/map/test_finite_map_definition.gd"),
	preload("res://tests/finite/map/test_finite_start_direction.gd"),
	preload("res://tests/finite/map/test_vs_demo_map.gd"),
	preload("res://tests/finite/build/test_track_layout.gd"),
	preload("res://tests/finite/build/test_track_layout_editor.gd"),
	preload("res://tests/finite/rail/test_finite_track_graph.gd"),
	preload("res://tests/finite/rail/test_interactive_route_controls.gd"),
	preload("res://tests/finite/build/test_preflight_validator.gd"),
	preload("res://tests/finite/integration/test_finite_build_session.gd"),
	preload("res://tests/finite/integration/test_finite_sealed_snapshot.gd"),
	preload("res://tests/finite/input/test_finite_gameplay_input_state.gd"),
	preload("res://tests/finite/cargo/test_unlimited_cargo_stack.gd"),
	preload("res://tests/finite/cargo/test_fixed_cargo_field.gd"),
	preload("res://tests/finite/delivery/test_finite_delivery_loop.gd"),
	preload("res://tests/finite/delivery/test_finite_delivery_event.gd"),
	preload("res://tests/finite/run/test_finite_run_state.gd"),
	preload("res://tests/finite/run/test_unload_sequence.gd"),
	preload("res://tests/finite/run/test_finite_run_controller.gd"),
	preload("res://tests/finite/run/test_finite_run_encapsulation.gd"),
	preload("res://tests/finite/run/test_finite_solution_identity.gd"),
	preload("res://tests/finite/integration/test_failed_run_preserves_layout.gd"),
	preload("res://tests/finite/integration/test_solution_identity_retry.gd"),
	preload("res://tests/finite/presentation/test_finite_slice_presenter.gd"),
	preload("res://tests/finite/presentation/test_finite_slice_session_controller.gd"),
	preload("res://tests/finite/presentation/test_finite_slice_commands.gd"),
	preload("res://tests/finite/smoke/test_finite_slice_scene_boot.gd"),
	preload("res://tests/finite/integration/test_build_to_delivery_slice.gd"),
	preload("res://tests/finite/integration/test_lifo_revisit_proof.gd"),
	preload("res://tests/finite/integration/test_vs_demo_authored_solutions.gd"),
	preload("res://tests/finite/integration/test_demo_marker_track_editability.gd"),
	preload("res://tests/finite/integration/test_demo_recommended_route.gd"),
	preload("res://tests/finite/integration/test_pause_integrity.gd"),
	preload("res://tests/finite/integration/test_finite_adversarial_cases.gd"),
	preload("res://tests/finite/validation/test_finite_wrapper_controller_parity.gd"),
	preload("res://tests/finite/validation/test_finite_validation_launcher.gd"),
	preload("res://tests/finite/validation/test_validation_mode_selector.gd"),
	preload("res://tests/finite/validation/test_validation_stack_modes.gd"),
	preload("res://tests/finite/validation/test_validation_entrypoint_invariance.gd"),
	preload("res://tests/finite/validation/test_android_validation_workflow_contract.gd"),
	preload("res://tests/demo/test_demo_flow_controller.gd"),
	preload("res://tests/demo/test_vertical_slice_demo_boot.gd"),
	preload("res://tests/demo/test_desktop_input_adapter.gd"),
	preload("res://tests/demo/test_product_board_renderer.gd"),
	preload("res://tests/demo/test_product_board_ghost.gd"),
	preload("res://tests/demo/test_product_hud.gd"),
	preload("res://tests/demo/test_product_finite_slice_commands.gd"),
	preload("res://tests/demo/test_recommended_layout_ui.gd"),
	preload("res://tests/demo/test_route_control_runtime_ui.gd"),
	preload("res://tests/demo/test_vertical_slice_end_to_end.gd"),
	preload("res://tests/demo/test_demo_effects_authority.gd"),
	preload("res://tests/demo/test_demo_audio_director.gd"),
	preload("res://tests/demo/test_demo_responsive_layout.gd"),
	preload("res://tests/demo/test_demo_touch_parity.gd"),
	preload("res://tests/demo/test_demo_overlay_ownership.gd"),
	preload("res://tests/demo/test_demo_mid_run_exit.gd"),
	preload("res://tests/demo/test_product_secondary_remove.gd"),
	preload("res://tests/demo/test_demo_flow_keyboard.gd"),
	preload("res://tests/demo/test_demo_theme.gd"),
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
	preload("res://tests/difficulty/test_difficulty_pressure_schedule.gd"),
	preload("res://tests/run/test_run_controller.gd"),
	preload("res://tests/run/test_run_controller_difficulty_events.gd"),
	preload("res://tests/run/test_run_controller_pressure_authority.gd"),
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
