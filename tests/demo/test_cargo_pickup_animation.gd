extends "res://tests/test_case.gd"


func run() -> void:
	var path := "res://game/demo/presentation/cargo_pickup_animation.gd"
	assert_true(ResourceLoader.exists(path), "confirmed blue pickup needs a bounded presentation timeline")
	if not ResourceLoader.exists(path):
		return
	var animation: RefCounted = load(path).new()
	assert_false(animation.is_active(), "idle timeline draws no presentation")
	assert_true(not animation.start(Vector2i(2, 3), &"RED_TRIANGLE"), "unknown cargo must fail closed")
	assert_false(animation.is_active(), "unsupported cargo stays idle")
	var expected_texture_keys := {
		&"RED_STAR": "cargo_red",
		&"BLUE_DIAMOND": "cargo_blue",
		&"YELLOW_TRIANGLE": "cargo_yellow",
		&"WASTE_CRATE": "cargo_waste",
	}
	for cargo_type: StringName in expected_texture_keys:
		assert_true(animation.start(Vector2i(2, 3), cargo_type), "%s pickup starts" % cargo_type)
		assert_equal(
			animation.texture_key(),
			expected_texture_keys[cargo_type],
			"%s pickup selects its matching approved top-down lid" % cargo_type
		)
		animation.cancel()
	assert_true(animation.start(Vector2i(2, 3), &"BLUE_DIAMOND"), "confirmed blue pickup restarts")
	assert_equal(animation.cell, Vector2i(2, 3), "animation remains at the pickup cell")
	assert_true(animation.is_active(), "pickup starts a presentation")
	assert_equal(animation.offset(), Vector2.ZERO, "pickup starts on its semantic cell anchor")
	assert_equal(animation.opacity(), 1.0, "pickup starts fully visible")
	animation.advance(0.061)
	assert_true(animation.offset().y < 0.0, "normal motion lifts the flat lid without changing art")
	animation.advance(0.060)
	assert_true(animation.offset().y < 0.0, "midpoint remains above the local pickup anchor")
	animation.advance(0.060)
	assert_true(animation.opacity() < 1.0, "settling presentation fades without exposing sides")
	animation.advance(0.060)
	assert_false(animation.is_active(), "effect expires without a looping reset")
	animation.start(Vector2i(1, 1), &"BLUE_DIAMOND")
	animation.advance(0.1)
	animation.start(Vector2i(4, 2), &"WASTE_CRATE")
	assert_equal(animation.cell, Vector2i(4, 2), "rapid pickup replaces old visual instead of accumulating")
	assert_equal(animation.texture_key(), "cargo_waste", "rapid replacement switches to the new cargo lid")
	assert_equal(animation.offset(), Vector2.ZERO, "replacement restarts at the new cell anchor")
	assert_false(animation.start(Vector2i(4, 2), &"UNSUPPORTED"), "unsupported replacement fails closed")
	assert_false(animation.is_active(), "unsupported replacement clears the prior supported pickup")
	animation.start(Vector2i(4, 2), &"WASTE_CRATE")
	animation.reduced_motion = true
	animation.advance(0.13)
	assert_equal(animation.offset(), Vector2.ZERO, "reduced motion never displaces the flat lid")
	assert_true(animation.opacity() < 1.0, "reduced motion uses opacity-only feedback")
	animation.cancel()
	assert_false(animation.is_active(), "retry or exit cancellation removes the visual")
	assert_equal(animation.texture_key(), "", "cancel clears the selected pickup texture")
	var renderer: Control = load("res://game/demo/presentation/product_board_renderer.gd").new()
	assert_true(renderer.has_method("train_facing_direction"), "terminal train needs incoming direction instead of snapping right")
	if renderer.has_method("train_facing_direction"):
		assert_equal(renderer.train_facing_direction({"train_cell": Vector2i(7, 4), "train_previous_cell": Vector2i(7, 3)}), Vector2.DOWN, "terminal train retains southbound approach")
		assert_equal(renderer.train_facing_direction({"train_cell": Vector2i(4, 3), "train_previous_cell": Vector2i(5, 3)}), Vector2.LEFT, "terminal train retains westbound approach")
		assert_equal(renderer.train_facing_direction({"train_cell": Vector2i(4, 3), "train_previous_cell": Vector2i(3, 3), "train_next_cell": Vector2i(4, 4)}), Vector2.DOWN, "next segment controls facing during run")
	var snapshot := {"phase": &"RUNNING", "board_size": Vector2i(5, 5)}
	renderer.apply_snapshot(snapshot)
	renderer.play_cargo_pickup(Vector2i(2, 3), &"BLUE_DIAMOND")
	assert_equal(
		renderer.cargo_pickup_presentation_for_test().get("asset_key", ""),
		"cargo_blue",
		"renderer draws the matching approved pickup texture"
	)
	renderer._process(0.061)
	assert_true(renderer.is_processing(), "pickup must keep animating when no speed transition exists")
	assert_equal(renderer.snapshot_for_test(), snapshot, "presentation does not mutate the supplied state")
	var offset_before_pause: Vector2 = renderer._cargo_pickup.offset()
	var opacity_before_pause: float = renderer._cargo_pickup.opacity()
	renderer.apply_snapshot({"phase": &"PAUSED", "board_size": Vector2i(5, 5)})
	renderer._process(1.0)
	assert_true(renderer.is_processing(), "paused pickup remains resumable")
	assert_equal(renderer._cargo_pickup.offset(), offset_before_pause, "pause freezes pickup position")
	assert_equal(renderer._cargo_pickup.opacity(), opacity_before_pause, "pause freezes pickup opacity")
	renderer.apply_snapshot({"phase": &"RUNNING", "board_size": Vector2i(5, 5)})
	renderer._process(0.061)
	assert_true(renderer._cargo_pickup.opacity() < opacity_before_pause, "resume advances pickup presentation")
	renderer.apply_snapshot({"phase": &"BUILD", "board_size": Vector2i(5, 5)})
	renderer._process(0.0)
	assert_true(not renderer.is_processing(), "edit cancels pending pickup presentation")
	renderer.free()
