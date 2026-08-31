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

	var non_square_target := Rect2(40.0, 80.0, 100.0, 60.0)
	var base_curve_ports: Array[Vector2i] = [Vector2i.UP, Vector2i.RIGHT]
	for rotation: int in range(4):
		var local_draw_rect: Rect2 = RendererScript.product_texture_draw_rect_for_test(
			non_square_target,
			rotation
		)
		var expected_local_size := non_square_target.size
		if rotation % 2 == 1:
			expected_local_size = Vector2(non_square_target.size.y, non_square_target.size.x)
		assert_equal(
			local_draw_rect.size,
			expected_local_size,
			"quarter-turn texture draw must pre-swap a non-square target at rotation %d" % rotation
		)
		for base_port: Vector2i in base_curve_ports:
			var expected_direction := base_port
			for _quarter: int in range(rotation):
				expected_direction = Vector2i(-expected_direction.y, expected_direction.x)
			var expected_port_position := non_square_target.get_center() + Vector2(
				float(expected_direction.x) * non_square_target.size.x * 0.5,
				float(expected_direction.y) * non_square_target.size.y * 0.5
			)
			assert_equal(
				RendererScript.product_texture_port_position_for_test(
					base_port,
					non_square_target,
					rotation
				),
				expected_port_position,
				"rotated curve port must meet the correct edge centre in a non-square cell at rotation %d" % rotation
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
			layer_order.find(&"DECORATION") >= 0,
			"board renderer must expose a dedicated decoration layer"
		)
		assert_true(
			layer_order.find(&"CAUTION") >= 0,
			"board renderer must expose a dedicated caution-track layer"
		)
		assert_true(
			layer_order.find(&"TERRAIN") < layer_order.find(&"DECORATION"),
			"board decorations must rest on terrain before the readable grid"
		)
		assert_true(
			layer_order.find(&"DECORATION") < layer_order.find(&"GRID"),
			"the grid must remain readable above board decorations"
		)
		assert_true(
			layer_order.find(&"BLOCKED") < layer_order.find(&"CAUTION"),
			"caution cues must remain visible above blocked-cell treatment"
		)
		assert_true(
			layer_order.find(&"CAUTION") < layer_order.find(&"FIXED_TRACK"),
			"rails must remain readable above authored caution cues"
		)
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

	renderer.apply_snapshot({
		"caution_track_cells": [[2, 3]],
		"board_decorations": [{"kind": "FOREST_CLUSTER", "cell": [4, 5]}],
	})
	assert_true(
		renderer.has_method("wayside_presentation_descriptors_for_test"),
		"board renderer must expose normalized wayside presentation data"
	)
	if renderer.has_method("wayside_presentation_descriptors_for_test"):
		assert_equal(
			renderer.wayside_presentation_descriptors_for_test(),
			{
				"caution_track_cells": [Vector2i(2, 3)],
				"board_decorations": [{"kind": &"FOREST_CLUSTER", "cell": Vector2i(4, 5)}],
			},
			"renderer must normalize wayside data before it reaches board drawing"
		)

	assert_true(
		renderer.has_method("speed_transition_descriptor_for_test"),
		"renderer must expose visual-only speed transition diagnostics"
	)
	if renderer.has_method("speed_transition_descriptor_for_test"):
		var deceleration: Dictionary = renderer.speed_transition_descriptor_for_test(
			{
				"train_cell": Vector2i(2, 3),
				"caution_track_cells": [Vector2i(3, 3)],
			},
			{
				"train_cell": Vector2i(3, 3),
				"caution_track_cells": [Vector2i(3, 3)],
			}
		)
		assert_equal(
			deceleration.get("kind", &""),
			&"DECELERATE",
			"normal-to-caution entry must show braking"
		)
		assert_equal(
			deceleration.get("cell", Vector2i(-1, -1)),
			Vector2i(3, 3),
			"braking cue belongs at the entered caution cell"
		)
		var acceleration: Dictionary = renderer.speed_transition_descriptor_for_test(
			{
				"train_cell": Vector2i(3, 3),
				"caution_track_cells": [Vector2i(3, 3)],
			},
			{
				"train_cell": Vector2i(4, 3),
				"caution_track_cells": [Vector2i(3, 3)],
			}
		)
		assert_equal(
			acceleration.get("kind", &""),
			&"ACCELERATE",
			"caution exit must show normal-speed recovery"
		)
		assert_equal(
			acceleration.get("direction", Vector2i.ZERO),
			Vector2i.RIGHT,
			"recovery cue must follow train travel direction"
		)
		assert_equal(
			renderer.speed_transition_descriptor_for_test(
				{
					"train_cell": Vector2i(3, 3),
					"caution_track_cells": [Vector2i(3, 3), Vector2i(4, 3)],
				},
				{
					"train_cell": Vector2i(4, 3),
					"caution_track_cells": [Vector2i(3, 3), Vector2i(4, 3)],
				}
			),
			{},
			"consecutive caution cells must not replay a speed transition"
		)
		assert_true(
			renderer.visual_layer_order_for_test().find(&"SPEED_TRANSITION")
			< renderer.visual_layer_order_for_test().find(&"TRAIN"),
			"speed feedback must remain below the train"
		)
		renderer.apply_snapshot({
			"train_cell": Vector2i(2, 3),
			"caution_track_cells": [Vector2i(3, 3)],
		})
		renderer.apply_snapshot({
			"train_cell": Vector2i(3, 3),
			"caution_track_cells": [Vector2i(3, 3)],
		})
		assert_equal(
			renderer.speed_transition_playback_for_test().get("kind", &""),
			&"DECELERATE",
			"snapshot playback must retain renderer-local braking feedback"
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

	var expected_product_paths := {
		"board_terrain": "art/product_assets/ed_hybrid_v2/board/board_terrain_playfield_v02.png",
		"decoration_forest_cluster": "art/product_assets/ed_hybrid_v2/board/board_decor_forest_cluster_v02.png",
		"decoration_moss_boulder": "art/product_assets/ed_hybrid_v2/board/board_decor_moss_boulder_v02.png",
		"decoration_timber_stack": "art/product_assets/ed_hybrid_v2/board/board_decor_timber_stack_v02.png",
		"decoration_waterway": "art/product_assets/ed_hybrid_v2/board/board_decor_waterway_v02.png",
		"decoration_lantern_fence": "art/product_assets/ed_hybrid_v2/board/board_decor_lantern_fence_v02.png",
		"caution_track": "art/product_assets/ed_hybrid_v2/board/board_caution_track_overlay_v02.png",
		"train": "art/product_assets/ed_hybrid_v2/core/core_train_locomotive_blue_normal_v02.png",
		"rail_straight": "art/product_assets/ed_hybrid_v2/core/core_rail_straight_normal_v04.png",
		"rail_curve": "art/product_assets/ed_hybrid_v2/core/core_rail_curve_normal_v04.png",
		"rail_crossing": "art/product_assets/ed_hybrid_v2/core/core_rail_crossing_normal_v04.png",
		"rail_switch": "art/product_assets/ed_hybrid_v2/core/core_rail_switch_three_way_normal_v04.png",
		"start_marker": "art/product_assets/ed_hybrid_v2/core/core_marker_start_normal_v02.png",
		"route_end_marker": "art/product_assets/ed_hybrid_v2/core/core_marker_route_end_normal_v02.png",
		"station_red": "art/product_assets/ed_hybrid_v2/core/core_station_red_normal_v02.png",
		"station_blue": "art/product_assets/ed_hybrid_v2/core/core_station_blue_normal_v02.png",
		"station_yellow": "art/product_assets/ed_hybrid_v2/core/core_station_yellow_normal_v02.png",
		"station_disposal": "art/product_assets/ed_hybrid_v2/core/core_disposal_yard_normal_v02.png",
		"cargo_red": "art/product_assets/ed_hybrid_v2/core/core_cargo_star_red_normal_v02.png",
		"cargo_blue": "art/product_assets/ed_hybrid_v2/core/core_cargo_star_blue_normal_v02.png",
		"cargo_yellow": "art/product_assets/ed_hybrid_v2/core/core_cargo_star_yellow_normal_v02.png",
		"cargo_waste": "art/product_assets/ed_hybrid_v2/core/core_cargo_waste_crate_normal_v02.png",
	}
	assert_equal(
		renderer.product_visual_asset_paths_for_test(),
		expected_product_paths,
		"core board must retain existing visual slots while adding approved wayside consumers"
	)
	for asset_key: String in expected_product_paths:
		assert_true(
			renderer.loaded_product_visuals_for_test().get(asset_key, false),
			"core board asset must import as Texture2D: %s" % asset_key
		)

	assert_true(
		renderer.has_method("product_rail_seam_descriptor_for_test"),
		"master-derived rails must expose their disabled legacy-seam contract"
	)
	if renderer.has_method("product_rail_seam_descriptor_for_test"):
		for geometry: StringName in [&"STRAIGHT", &"CURVE", &"CROSSING", &"SWITCH"]:
			assert_equal(
				renderer.product_rail_seam_descriptor_for_test(geometry, 0),
				{"enabled": false, "ports": []},
				"%s master-derived rail must not receive a procedural seam layer" % geometry
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

	renderer.free()
