extends "res://tests/test_case.gd"

const RESOLVER_PATH := "res://game/demo/presentation/semantic_runtime_state.gd"


func run() -> void:
	var exists := ResourceLoader.exists(RESOLVER_PATH, "Script")
	assert_true(exists, "SemanticRuntimeState production script must exist")
	if not exists:
		return

	var resolver: Script = load(RESOLVER_PATH)
	assert_not_null(resolver, "SemanticRuntimeState script must load")
	if resolver == null:
		return

	for pair: Array in [
		[0, &"empty"],
		[1, &"compact"],
		[7, &"compact"],
		[8, &"8plus"],
		[15, &"8plus"],
		[16, &"16plus"],
		[31, &"16plus"],
		[32, &"32plus"],
	]:
		assert_equal(
			resolver.stack_primary_state(_stack_model(int(pair[0]), &"RUNNING")),
			pair[1],
			"stack count boundary %d must select %s" % [int(pair[0]), str(pair[1])]
		)

	assert_equal(
		resolver.stack_primary_state(_stack_model(40, &"PAUSED")),
		&"paused",
		"paused state must override stack count"
	)
	assert_equal(
		resolver.stack_primary_state(_stack_model(40, &"UNLOADING")),
		&"unloading",
		"unloading state must override stack count"
	)

	var tokens := [
		{"cargo_type": &"RED_STAR"},
		{"cargo_type": &"BLUE_DIAMOND"},
		{"cargo_type": &"RED_STAR"},
		{"cargo_type": &"RED_STAR"},
	]
	assert_equal(resolver.contiguous_top_group_size(tokens), 2, "TOP grouping must count only contiguous identical cargo")
	assert_equal(resolver.contiguous_top_group_size([]), 0, "empty stack has zero TOP group")

	assert_equal(resolver.manual_load_state({"phase": &"RUNNING", "manual_load_active": false}), &"manual_idle", "manual idle state")
	assert_equal(resolver.manual_load_state({"phase": &"RUNNING", "manual_load_active": true}), &"manual_held", "manual held state")
	assert_equal(resolver.manual_load_state({"phase": &"PAUSED", "manual_load_active": true}), &"paused_disabled", "pause overrides manual held")
	assert_equal(resolver.auto_load_state({"phase": &"RUNNING", "auto_load_active": false}), &"auto_off", "auto off state")
	assert_equal(resolver.auto_load_state({"phase": &"RUNNING", "auto_load_active": true}), &"auto_on", "auto on state")
	assert_equal(resolver.auto_load_state({"phase": &"PAUSED", "auto_load_active": true}), &"paused_disabled", "pause overrides auto state")

	assert_equal(resolver.preflight_summary_state({"start_enabled": true, "problem_cells": []}), &"clear", "start-enabled preflight is clear")
	assert_equal(resolver.preflight_summary_state({"start_enabled": false, "problem_cells": [Vector2i(1, 1)]}), &"primary_issue", "single preflight issue is primary")
	assert_equal(resolver.preflight_summary_state({"start_enabled": false, "problem_cells": [Vector2i(1, 1), Vector2i(2, 2)]}), &"multi_issue_summary", "multiple preflight issues use summary")
	assert_equal(resolver.preflight_focus_state({"problem_cells": []}), &"", "no problem cell has no focused semantic state")
	assert_equal(resolver.preflight_focus_state({"problem_cells": [Vector2i(1, 1)]}), &"focused_location", "problem cells enable focused location semantic state")

	assert_equal(resolver.placement_state({}, {}), &"", "missing ghost has no placement semantic state")
	assert_equal(resolver.placement_state({"phase": &"RUNNING", "cell": Vector2i(2, 2), "valid": true}, {}), &"", "non-BUILD ghost has no placement semantic state")
	assert_equal(resolver.placement_state({"phase": &"BUILD", "cell": Vector2i(2, 2), "valid": false}, {}), &"invalid", "invalid placement has highest placement priority")
	assert_equal(
		resolver.placement_state(
			{"phase": &"BUILD", "cell": Vector2i(2, 2), "valid": true, "rotation_quarters": 1},
			{"layout_pieces": [{"cell": Vector2i(2, 2)}]}
		),
		&"replacement_preview",
		"replacement preview outranks rotation"
	)
	assert_equal(resolver.placement_state({"phase": &"BUILD", "cell": Vector2i(2, 2), "valid": true, "rotation_quarters": 1}, {"layout_pieces": []}), &"rotate_preview", "non-zero rotation selects rotate preview")
	assert_equal(resolver.placement_state({"phase": &"BUILD", "cell": Vector2i(2, 2), "valid": true, "rotation_quarters": 0}, {"layout_pieces": []}), &"valid", "ordinary valid ghost selects valid")

	assert_equal(resolver.route_target_state({"locked": true, "selected": true}), &"occupied_locked", "occupied lock outranks selected")
	assert_equal(resolver.route_target_state({"locked": false, "selected": true}), &"selected", "selected route target")
	assert_equal(resolver.route_target_state({"locked": false, "selected": false}), &"unselected", "unselected route target")

	assert_equal(resolver.terminal_event(&"SUCCESS", &""), &"success", "success terminal event")
	assert_equal(resolver.terminal_event(&"FAILURE", &"ROUTE_END"), &"route_end", "route-end terminal event")
	assert_equal(resolver.terminal_event(&"FAILURE", &"TIME_EXPIRED"), &"time_expired", "timeout terminal event")
	assert_equal(resolver.terminal_event(&"FAILURE", &"OTHER"), &"failure", "generic failure terminal event")


func _stack_model(count: int, phase: StringName) -> Dictionary:
	var tokens: Array = []
	for index: int in range(count):
		tokens.append({"cargo_type": &"RED_STAR", "top": index == count - 1})
	return {"phase": phase, "stack_tokens": tokens}
