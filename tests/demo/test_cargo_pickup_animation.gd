extends "res://tests/test_case.gd"


func run() -> void:
	var path := "res://game/demo/presentation/cargo_pickup_animation.gd"
	assert_true(ResourceLoader.exists(path), "confirmed blue pickup needs a bounded presentation timeline")
	if not ResourceLoader.exists(path):
		return
	var animation: RefCounted = load(path).new()
	assert_equal(animation.frame_index(), -1, "idle timeline draws no frame")
	assert_true(not animation.start(Vector2i(2, 3), &"RED_TRIANGLE"), "red pickup must not display blue cargo")
	assert_equal(animation.frame_index(), -1, "unsupported cargo stays idle")
	assert_true(animation.start(Vector2i(2, 3), &"BLUE_DIAMOND"), "confirmed blue pickup starts")
	assert_equal(animation.cell, Vector2i(2, 3), "animation remains at the pickup cell")
	assert_equal(animation.frame_index(), 0, "pickup starts at preparation")
	animation.advance(0.061)
	assert_equal(animation.frame_index(), 1, "60ms boundary enters lift")
	animation.advance(0.060)
	assert_equal(animation.frame_index(), 2, "120ms boundary enters peak")
	animation.advance(0.060)
	assert_equal(animation.frame_index(), 3, "180ms boundary enters settling")
	animation.advance(0.060)
	assert_equal(animation.frame_index(), -1, "effect expires without a looping reset")
	animation.start(Vector2i(1, 1), &"BLUE_DIAMOND")
	animation.advance(0.1)
	animation.start(Vector2i(4, 2), &"BLUE_DIAMOND")
	assert_equal(animation.cell, Vector2i(4, 2), "rapid pickup replaces old visual instead of accumulating")
	assert_equal(animation.frame_index(), 0, "replacement starts at preparation")
	animation.reduced_motion = true
	animation.advance(0.13)
	assert_equal(animation.frame_index(), 0, "reduced motion never advances displaced poses")
	animation.cancel()
	assert_equal(animation.frame_index(), -1, "retry or exit cancellation removes the visual")
	var renderer: Control = load("res://game/demo/presentation/product_board_renderer.gd").new()
	var snapshot := {"phase": &"RUNNING", "board_size": Vector2i(5, 5)}
	renderer.apply_snapshot(snapshot)
	renderer.play_cargo_pickup(Vector2i(2, 3), &"BLUE_DIAMOND")
	renderer._process(0.061)
	assert_true(renderer.is_processing(), "pickup must keep animating when no speed transition exists")
	assert_equal(renderer.snapshot_for_test(), snapshot, "presentation does not mutate the supplied state")
	renderer.apply_snapshot({"phase": &"PAUSED", "board_size": Vector2i(5, 5)})
	renderer._process(1.0)
	assert_true(renderer.is_processing(), "paused pickup remains resumable")
	renderer.apply_snapshot({"phase": &"BUILD", "board_size": Vector2i(5, 5)})
	renderer._process(0.0)
	assert_true(not renderer.is_processing(), "edit cancels pending pickup presentation")
	renderer.free()
