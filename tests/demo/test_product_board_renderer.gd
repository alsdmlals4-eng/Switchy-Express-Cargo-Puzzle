extends "res://tests/test_case.gd"

const RendererScript := preload("res://game/demo/presentation/product_board_renderer.gd")
const TrackPieceScript := preload("res://game/finite/build/track_piece.gd")


func run() -> void:
	var renderer: Control = RendererScript.new()
	renderer.size = Vector2(1100.0, 900.0)

	assert_equal(
		renderer.board_cell_from_local(Vector2(550.0, 450.0), Vector2i(11, 9)),
		Vector2i(5, 4),
		"board center must map to the center grid cell"
	)
	assert_equal(
		renderer.board_cell_from_local(Vector2(-1.0, 100.0), Vector2i(11, 9)),
		Vector2i(-1, -1),
		"positions outside the board must be rejected"
	)
	assert_equal(
		renderer.board_cell_from_local(Vector2(1099.0, 899.0), Vector2i(11, 9)),
		Vector2i(-1, -1),
		"outer padding must not dispatch a board cell"
	)

	assert_equal(
		RendererScript.snapshot_cell([4, 3]),
		Vector2i(4, 3),
		"JSON marker coordinates must normalize from Array to Vector2i"
	)
	assert_equal(
		RendererScript.snapshot_cell(Vector2i(6, 2)),
		Vector2i(6, 2),
		"typed marker coordinates must remain unchanged"
	)
	assert_equal(
		RendererScript.snapshot_cell([4]),
		Vector2i(-1, -1),
		"malformed marker coordinates must be rejected"
	)

	for rotation: int in range(4):
		var curve: Variant = TrackPieceScript.create(
			Vector2i(2, 2),
			&"CURVE",
			rotation,
			Vector2i.ZERO
		)
		assert_not_null(curve, "curve fixture must be valid")
		if curve != null:
			assert_equal(
				RendererScript.track_ports_for_test(&"CURVE", rotation),
				curve.ports(),
				"rendered curve ports must match domain ports at rotation %d" % rotation
			)

	var fixed_snapshot := {
		"start_cell": Vector2i(1, 4),
		"incoming_cell": Vector2i(0, 4),
		"station_placements": [
			{"cell": [8, 5], "cargo_type": "RED_STAR"},
		],
		"cargo_placements": [
			{"cell": [9, 4], "cargo_type": "RED_STAR"},
		],
	}
	var fixed_tracks: Array = RendererScript.fixed_track_descriptors(fixed_snapshot)
	assert_equal(fixed_tracks.size(), 2, "only incoming and start rails may be prelaid")
	assert_equal(fixed_tracks[0]["cell"], Vector2i(0, 4), "incoming rail must be visible")
	assert_equal(fixed_tracks[1]["cell"], Vector2i(1, 4), "start rail must be visible")
	assert_equal(
		RendererScript.start_marker_descriptor(fixed_snapshot)["cell"],
		Vector2i(1, 4),
		"start marker must point at the authored start cell"
	)
	renderer.apply_snapshot({
		"board_size": Vector2i(7, 7),
		"station_placements": [{"cell": [3, 3], "cargo_type": "RED_STAR"}],
	})
	assert_equal(
		renderer.station_service_descriptors_for_test(),
		[{
			"station_cell": Vector2i(3, 3),
			"cargo_type": &"RED_STAR",
			"service_cells": [Vector2i(3, 2), Vector2i(4, 3), Vector2i(3, 4), Vector2i(2, 3)],
		}],
		"station service descriptor must expose only cardinal service cells"
	)
	assert_false(
		renderer.product_visual_asset_paths_for_test().has("station_service_range"),
		"cardinal service visualization must not require a new bitmap asset"
	)
	assert_true(
		renderer.has_method("visual_layer_order_for_test"),
		"board renderer must expose visual-only layer diagnostics"
	)
	if renderer.has_method("visual_layer_order_for_test"):
		var layer_order: Array = renderer.visual_layer_order_for_test()
		assert_true(
			layer_order.find(&"STATION_SERVICE") < layer_order.find(&"ROUTE"),
			"station service orientation must remain below decisive route feedback"
		)
		assert_true(
			layer_order.find(&"ROUTE") < layer_order.find(&"MARKERS"),
			"route feedback must remain below cargo and station markers"
		)
		assert_true(
			layer_order.find(&"MARKERS") < layer_order.find(&"STATE"),
			"markers must remain below state overlays"
		)

	var source: Dictionary = {
		"map_id": &"VS_DEMO_01",
		"board_size": Vector2i(11, 9),
		"blocked_cells": [Vector2i(4, 3)],
		"layout_pieces": [],
		"station_placements": [],
		"cargo_placements": [],
		"problem_cells": [],
		"selected_cell": Vector2i(3, 4),
		"selected_geometry": &"STRAIGHT",
		"selected_rotation_quarters": 0,
		"phase": &"BUILD",
		"train_cell": Vector2i(-1, -1),
		"train_next_cell": Vector2i(-1, -1),
		"switch_cells": [],
		"stack_tokens": [],
	}
	renderer.apply_snapshot(source)
	source["map_id"] = &"BROKEN"
	source["blocked_cells"].append(Vector2i(9, 9))
	var stored: Dictionary = renderer.snapshot_for_test()
	assert_equal(stored["map_id"], &"VS_DEMO_01", "renderer stores a deep snapshot copy")
	assert_equal(stored["blocked_cells"], [Vector2i(4, 3)], "source arrays cannot mutate renderer")

	var primary_cells: Array[Vector2i] = []
	var secondary_cells: Array[Vector2i] = []
	renderer.cell_primary_requested.connect(
		func(cell: Vector2i) -> void: primary_cells.append(cell)
	)
	renderer.cell_secondary_requested.connect(
		func(cell: Vector2i) -> void: secondary_cells.append(cell)
	)
	renderer.request_primary_at(Vector2(550.0, 450.0))
	renderer.request_secondary_at(Vector2(550.0, 450.0))
	assert_equal(primary_cells, [Vector2i(5, 4)], "primary requests preserve exact cell")
	assert_equal(secondary_cells, [Vector2i(5, 4)], "secondary requests preserve exact cell")

	var expected_v02_paths := {
		"board_terrain": "art/product_assets/ed_hybrid_v2/board/board_terrain_playfield_v02.png",
		"train": "art/product_assets/ed_hybrid_v2/core/core_train_locomotive_blue_normal_v02.png",
		"rail_straight": "art/product_assets/ed_hybrid_v2/core/core_rail_straight_normal_v02.png",
		"rail_curve": "art/product_assets/ed_hybrid_v2/core/core_rail_curve_normal_v02.png",
		"rail_crossing": "art/product_assets/ed_hybrid_v2/core/core_rail_crossing_normal_v02.png",
		"rail_switch": "art/product_assets/ed_hybrid_v2/core/core_rail_switch_three_way_normal_v02.png",
		"start_marker": "art/product_assets/ed_hybrid_v2/core/core_marker_start_normal_v02.png",
		"route_end_marker": "art/product_assets/ed_hybrid_v2/core/core_marker_route_end_normal_v02.png",
		"station_red": "art/product_assets/ed_hybrid_v2/core/core_station_red_normal_v02.png",
		"station_blue": "art/product_assets/ed_hybrid_v2/core/core_station_blue_normal_v02.png",
		"station_yellow": "art/product_assets/ed_hybrid_v2/core/core_station_yellow_normal_v02.png",
		"cargo_red": "art/product_assets/ed_hybrid_v2/core/core_cargo_star_red_normal_v02.png",
		"cargo_blue": "art/product_assets/ed_hybrid_v2/core/core_cargo_star_blue_normal_v02.png",
		"cargo_yellow": "art/product_assets/ed_hybrid_v2/core/core_cargo_star_yellow_normal_v02.png",
	}
	assert_equal(
		renderer.product_visual_asset_paths_for_test(),
		expected_v02_paths,
		"core board v02 must replace only the existing visual slot paths"
	)
	for asset_key: String in expected_v02_paths:
		assert_true(
			renderer.loaded_product_visuals_for_test().get(asset_key, false),
			"core board v02 asset must import as Texture2D: %s" % asset_key
		)

	assert_true(
		renderer.has_method("product_rail_seam_descriptor_for_test"),
		"curve and switch seam diagnostics must expose their visual-only scope"
	)
	if renderer.has_method("product_rail_seam_descriptor_for_test"):
		assert_equal(
			renderer.product_rail_seam_descriptor_for_test(&"STRAIGHT", 0),
			{"enabled": false, "ports": []},
			"straight rail art must not gain a procedural seam layer"
		)
		assert_equal(
			renderer.product_rail_seam_descriptor_for_test(&"CURVE", 0),
			{
				"enabled": true,
				"mode": &"CURVE_ARC",
				"ports": [Vector2i.UP, Vector2i.RIGHT],
			},
			"curve seam must follow the authored quarter-turn instead of center spokes"
		)
		assert_equal(
			renderer.product_rail_seam_descriptor_for_test(&"SWITCH", 0),
			{
				"enabled": true,
				"mode": &"PORT_SPOKES",
				"ports": [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP],
			},
			"switch seam must preserve its authored three radial ports"
		)
	assert_true(
		renderer.has_method("product_rail_seam_target_for_test"),
		"curve and switch seams must expose the expanded visual target used to bridge tile gaps"
	)
	if renderer.has_method("product_rail_seam_target_for_test"):
		var seam_source := Rect2(0.0, 0.0, 120.0, 60.0)
		for geometry: StringName in [&"CURVE", &"SWITCH"]:
			assert_equal(
				renderer.product_rail_seam_target_for_test(geometry, seam_source),
				Rect2(-3.0, -3.0, 126.0, 66.0),
				"%s seam must extend three pixels across both tile edges" % geometry
			)

	assert_true(
		renderer.has_method("marker_target_for_test"),
		"marker sizing must expose the same station and cargo targets used by the renderer"
	)
	if renderer.has_method("marker_target_for_test"):
		var marker_cell := Rect2(0.0, 0.0, 100.0, 60.0)
		var station_target: Rect2 = renderer.marker_target_for_test(true, marker_cell)
		var cargo_target: Rect2 = renderer.marker_target_for_test(false, marker_cell)
		assert_equal(station_target, Rect2(5.0, 5.0, 90.0, 50.0), "station keeps its existing prominent footprint")
		assert_equal(cargo_target.get_center(), station_target.get_center(), "cargo remains centered in its authored map cell")
		assert_almost_equal(cargo_target.size.x, cargo_target.size.y, 0.00001, "cargo art must retain its square source aspect")
		assert_less_equal(cargo_target.size.x, 38.0, "cargo width must be materially smaller than its 100x60 tile")
		assert_true(cargo_target.size.y < station_target.size.y, "cargo height must be smaller than the station footprint")

	assert_true(
		renderer.has_method("curve_seam_arc_for_test"),
		"curve seam must expose the actual quarter-turn geometry used by the renderer"
	)
	if renderer.has_method("curve_seam_arc_for_test"):
		var expected_curve_arcs: Array[Dictionary] = [
			{
				"center": Vector2(120.0, 0.0),
				"major_radius": 60.0,
				"minor_radius": 30.0,
				"start_angle": PI,
				"end_angle": PI * 0.5,
			},
			{
				"center": Vector2(120.0, 60.0),
				"major_radius": 60.0,
				"minor_radius": 30.0,
				"start_angle": -PI * 0.5,
				"end_angle": -PI,
			},
			{
				"center": Vector2(0.0, 60.0),
				"major_radius": 60.0,
				"minor_radius": 30.0,
				"start_angle": 0.0,
				"end_angle": -PI * 0.5,
			},
			{
				"center": Vector2(0.0, 0.0),
				"major_radius": 60.0,
				"minor_radius": 30.0,
				"start_angle": PI * 0.5,
				"end_angle": 0.0,
			},
		]
		for rotation: int in range(4):
			var actual_arc: Dictionary = renderer.curve_seam_arc_for_test(
				rotation,
				Rect2(0.0, 0.0, 120.0, 60.0)
			)
			assert_equal(
				{
					"center": actual_arc["center"],
					"major_radius": actual_arc["major_radius"],
					"minor_radius": actual_arc["minor_radius"],
				},
				{
					"center": expected_curve_arcs[rotation]["center"],
					"major_radius": expected_curve_arcs[rotation]["major_radius"],
					"minor_radius": expected_curve_arcs[rotation]["minor_radius"],
				},
				"curve rotation %d must preserve its rectangular tile geometry" % rotation
			)
			assert_almost_equal(
				float(actual_arc["start_angle"]),
				float(expected_curve_arcs[rotation]["start_angle"]),
				0.00001,
				"curve rotation %d must start at the first authored port" % rotation
			)
			assert_almost_equal(
				float(actual_arc["end_angle"]),
				float(expected_curve_arcs[rotation]["end_angle"]),
				0.00001,
				"curve rotation %d must take the short 90-degree path to its second port" % rotation
			)

	renderer.free()
