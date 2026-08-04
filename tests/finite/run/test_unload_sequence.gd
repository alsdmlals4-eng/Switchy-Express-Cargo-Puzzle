extends "res://tests/test_case.gd"

const SEQUENCE_PATH := "res://game/finite/run/unload_sequence.gd"
const A: StringName = &"RED_STAR"
const B: StringName = &"BLUE_DIAMOND"


func run() -> void:
	var sequence_exists := ResourceLoader.exists(SEQUENCE_PATH, "Script")
	assert_true(sequence_exists, "finite unload sequence must exist")
	if not sequence_exists:
		return

	var sequence_script: Script = load(SEQUENCE_PATH)
	var three_items: Array[StringName] = [A, A, A]
	var sequence: Variant = sequence_script.new(three_items)
	assert_almost_equal(sequence.total_duration(), 0.24, 0.000001, "three cargo must use 0.08 seconds each")
	assert_almost_equal(sequence.remaining_seconds(), 0.24, 0.000001, "new sequence must retain full duration")
	assert_equal(sequence.pending_count(), 3, "new sequence must retain every visual item")
	assert_false(sequence.is_complete(), "new sequence must not be complete")
	assert_equal(sequence.advance_time(-1.0), [], "negative time must not emit items")
	assert_almost_equal(sequence.remaining_seconds(), 0.24, 0.000001, "negative time must not mutate duration")

	assert_equal(sequence.advance_time(0.08), [A], "first visual interval must emit one cargo")
	assert_equal(sequence.pending_count(), 2, "one visual cargo must be consumed")
	assert_almost_equal(sequence.remaining_seconds(), 0.16, 0.000001, "first interval must reduce remaining time")
	assert_equal(sequence.advance_time(0.16), [A, A], "remaining interval must emit remaining cargo")
	assert_true(sequence.is_complete(), "all visual cargo must complete")
	assert_equal(sequence.pending_count(), 0, "complete sequence must have no pending cargo")
	assert_almost_equal(sequence.remaining_seconds(), 0.0, 0.000001, "complete sequence must have no remaining time")
	assert_equal(sequence.advance_time(1.0), [], "complete sequence must not emit twice")

	var single_items: Array[StringName] = [B]
	var single: Variant = sequence_script.new(single_items)
	assert_almost_equal(single.total_duration(), 0.12, 0.000001, "single cargo must use minimum unload duration")

	var thirty_two_items: Array[StringName] = []
	for index: int in range(32):
		thirty_two_items.append(A if index % 2 == 0 else B)
	var large: Variant = sequence_script.new(thirty_two_items)
	assert_true(large.total_duration() > 0.0, "32-cargo unload must take positive time")
	assert_less_equal(large.total_duration(), 1.0, "32-cargo unload must be capped at one second")
	assert_almost_equal(large.total_duration(), 1.0, 0.000001, "32-cargo unload must reach the one-second cap")
	assert_equal(large.advance_time(1.0), thirty_two_items, "one-second advancement must emit all 32 visual cargo")
	assert_true(large.is_complete(), "32-cargo sequence must complete within one second")

	var source_copy: Array[StringName] = large.items()
	source_copy.clear()
	assert_equal(large.items(), thirty_two_items, "sequence item snapshots must be copy-safe")
