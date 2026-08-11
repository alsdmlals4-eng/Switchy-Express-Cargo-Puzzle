extends "res://tests/test_case.gd"

const OVERLAY_PATH := "res://game/demo/presentation/semantic_event_overlay.gd"
const CatalogScript := preload("res://game/demo/presentation/semantic_asset_catalog.gd")
const EVENTS: Array[StringName] = [
	&"cargo_pickup",
	&"cargo_unload",
	&"combo",
	&"route_selection",
	&"success",
	&"failure",
	&"route_end",
	&"time_expired",
]


func run() -> void:
	var catalog: RefCounted = CatalogScript.new()
	assert_true(catalog.load_default(), "diagnostic catalog load must succeed")
	var route_record: Dictionary = catalog.vfx_composition(&"route_selection", false)
	assert_false(route_record.is_empty(), "diagnostic VFX manifest lookup must succeed before overlay playback")
	assert_equal(
		route_record.get("inputs", []),
		["art/product_assets/ed_hybrid_v1/run/run_switch_state_selected_overlay_v01.png"],
		"diagnostic route-selection manifest record must keep approved input"
	)
	assert_true(
		FileAccess.file_exists("res://art/product_assets/ed_hybrid_v1/run/run_switch_state_selected_overlay_v01.png"),
		"diagnostic approved RUN PNG source bytes must exist on clean runner"
	)
	assert_true(
		not catalog.textures_for(route_record).is_empty(),
		"diagnostic catalog texture resolution must load approved RUN PNG"
	)
	var pickup_record: Dictionary = catalog.vfx_composition(&"cargo_pickup", false)
	assert_false(pickup_record.is_empty(), "diagnostic pickup VFX manifest lookup must succeed")
	assert_true(
		FileAccess.file_exists("res://art/product_assets/ed_hybrid_v1/vfx/vfx_cargo_pickup_feedback_v01.png"),
		"diagnostic approved VFX PNG source bytes must exist on clean runner"
	)
	assert_true(
		not catalog.textures_for(pickup_record).is_empty(),
		"diagnostic catalog texture resolution must load approved VFX PNG"
	)

	var exists := ResourceLoader.exists(OVERLAY_PATH, "Script")
	assert_true(exists, "SemanticEventOverlay production script must exist")
	if not exists:
		return

	var overlay_script: Script = load(OVERLAY_PATH)
	assert_not_null(overlay_script, "SemanticEventOverlay script must load")
	if overlay_script == null:
		return
	var overlay: Control = overlay_script.new()
	var tree := Engine.get_main_loop() as SceneTree
	assert_not_null(tree, "semantic event overlay test requires SceneTree")
	if tree == null:
		overlay.free()
		return
	tree.root.add_child(overlay)

	assert_true(float(overlay.maximum_event_duration_for_test()) <= 1.0, "semantic event duration must remain at or below one second")
	assert_equal(
		overlay.combo_trigger_status_for_test(),
		&"RUNTIME_TRIGGER_DEFERRED_NO_EXISTING_SEAM",
		"combo must not gain a fabricated gameplay trigger"
	)

	for event: StringName in EVENTS:
		overlay.set_reduced_motion(false)
		assert_true(overlay.play_event(event), "%s standard event must resolve" % str(event))
		var standard_key: StringName = overlay.information_key_for_test()
		var standard_paths: Array[String] = overlay.input_paths_for_test()
		assert_equal(standard_key, event, "%s standard information identity" % str(event))
		assert_true(not standard_paths.is_empty(), "%s standard event must expose an approved input" % str(event))
		assert_true(overlay.motion_active_for_test(), "%s standard presentation may use bounded motion" % str(event))

		overlay.set_reduced_motion(true)
		assert_true(overlay.play_event(event), "%s reduced-motion event must resolve" % str(event))
		assert_equal(overlay.information_key_for_test(), standard_key, "%s reduced mode preserves information identity" % str(event))
		assert_equal(overlay.input_paths_for_test(), standard_paths, "%s reduced mode preserves exact semantic input" % str(event))
		assert_false(overlay.motion_active_for_test(), "%s reduced mode must disable spatial/scale motion" % str(event))

	overlay.set_reduced_motion(false)
	assert_true(overlay.play_event(&"route_selection"), "route selection event resolves")
	assert_equal(
		overlay.input_paths_for_test(),
		["art/product_assets/ed_hybrid_v1/run/run_switch_state_selected_overlay_v01.png"],
		"route selection reuses the approved selected-route semantic input"
	)
	assert_true(overlay.play_event(&"combo"), "combo catalog entry resolves without creating a runtime trigger")
	assert_equal(
		overlay.input_paths_for_test(),
		["art/product_assets/ed_hybrid_v1/run/run_combo_feedback_static_v01.png"],
		"combo reuses the approved static feedback input"
	)

	assert_false(overlay.play_event(&"does_not_exist"), "unknown semantic event must fail soft")
	assert_equal(overlay.current_event_for_test(), &"", "unknown event must not substitute another semantic event")
	assert_equal(overlay.input_paths_for_test(), [], "unknown event must show no substituted semantic input")

	overlay.play_event(&"success")
	overlay.cancel_all()
	assert_equal(overlay.current_event_for_test(), &"", "cancel_all clears current event")
	assert_false(overlay.motion_active_for_test(), "cancel_all clears presentation motion")
	overlay.free()
