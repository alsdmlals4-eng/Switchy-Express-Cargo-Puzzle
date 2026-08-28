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

	renderer.free()
