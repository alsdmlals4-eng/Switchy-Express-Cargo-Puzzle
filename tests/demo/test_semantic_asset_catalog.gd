extends "res://tests/test_case.gd"

const CATALOG_PATH := "res://game/demo/presentation/semantic_asset_catalog.gd"


func run() -> void:
	var exists := ResourceLoader.exists(CATALOG_PATH, "Script")
	assert_true(exists, "SemanticAssetCatalog production script must exist")
	if not exists:
		return

	var catalog_script: Script = load(CATALOG_PATH)
	assert_not_null(catalog_script, "SemanticAssetCatalog script must load")
	if catalog_script == null:
		return

	var catalog: RefCounted = catalog_script.new()
	assert_true(catalog.load_default(), "default semantic manifests must load")
	assert_true(catalog.is_ready(), "catalog must report ready after successful load")
	assert_equal(catalog.errors(), [], "successful catalog load must have no errors")

	var compact: Dictionary = catalog.composition(&"stack_hud", &"compact")
	assert_equal(
		compact.get("inputs", []),
		["art/product_assets/ed_hybrid_v1/run/run_stack_compact_v01.png"],
		"stack_hud/compact must resolve the exact RUN semantic asset"
	)

	var manual_held: Dictionary = catalog.composition(&"load_mode", &"manual_held")
	assert_equal(
		manual_held.get("inputs", []),
		[
			"art/product_assets/ed_hybrid_v1/run/run_load_mode_shell_v01.png",
			"art/product_assets/ed_hybrid_v1/run/run_load_mode_manual_marker_v01.png",
			"art/product_assets/ed_hybrid_v1/run/run_load_mode_held_marker_v01.png",
		],
		"manual_held must preserve shell/manual/held manifest order"
	)

	var placement_valid: Dictionary = catalog.composition(&"placement_preview", &"valid")
	assert_equal(
		placement_valid.get("inputs", []),
		["art/product_assets/ed_hybrid_v1/build/build_placement_valid_overlay_v01.png"],
		"placement_preview/valid must resolve from BUILD_2B"
	)

	var focused_location: Dictionary = catalog.composition(&"preflight_notice", &"focused_location")
	assert_equal(
		focused_location.get("inputs", []),
		[
			"art/product_assets/ed_hybrid_v1/build/build_preflight_shell_v01.png",
			"art/product_assets/ed_hybrid_v1/build/build_preflight_focused_location_marker_v01.png",
		],
		"preflight focused location must resolve from BUILD_2B"
	)

	var route_end_standard: Dictionary = catalog.vfx_composition(&"route_end", false)
	var route_end_reduced: Dictionary = catalog.vfx_composition(&"route_end", true)
	assert_equal(
		route_end_standard.get("information_key", ""),
		route_end_reduced.get("information_key", ""),
		"route_end standard/reduced modes must share information identity"
	)
	assert_equal(
		route_end_standard.get("inputs", []),
		route_end_reduced.get("inputs", []),
		"route_end standard/reduced modes must use the exact same semantic input"
	)
	assert_equal(
		route_end_standard.get("inputs", []),
		["art/product_assets/ed_hybrid_v1/vfx/vfx_route_end_feedback_v01.png"],
		"route_end must resolve the approved VFX input"
	)

	var combo: Dictionary = catalog.vfx_composition(&"combo", false)
	assert_equal(
		combo.get("inputs", []),
		["art/product_assets/ed_hybrid_v1/run/run_combo_feedback_static_v01.png"],
		"combo must resolve the approved static feedback asset without inventing a trigger"
	)

	var stack_empty: Dictionary = catalog.base_asset_by_authoritative_slice(&"run_stack_empty_v01")
	assert_equal(
		stack_empty.get("path", ""),
		"art/product_assets/ed_hybrid_v1/run/run_stack_empty_v01.png",
		"authoritative stack-empty slice must resolve to the exact SX-DEC-053 product path"
	)

	assert_equal(
		catalog.composition(&"does_not_exist", &"missing"),
		{},
		"unknown semantic component/state must fail closed without substitution"
	)
	assert_equal(
		catalog.vfx_composition(&"does_not_exist", false),
		{},
		"unknown VFX event must fail closed without substitution"
	)
