extends GutTest

const OverlayScript := preload("res://game/demo/presentation/route_control_overlay.gd")

const CELL := Vector2i(1, 1)
const UP := Vector2i.UP
const RIGHT := Vector2i.RIGHT
const LEFT := Vector2i.LEFT


func test_running_switch_exposes_three_direction_targets() -> void:
	var overlay: Control = _overlay(_snapshot(&"RUNNING", false, RIGHT))
	assert_true(overlay.has_method("direction_targets_for_test"), "overlay must expose deterministic direction targets")
	if not overlay.has_method("direction_targets_for_test"):
		return
	var targets: Array = overlay.direction_targets_for_test()
	assert_eq(targets.size(), 3)
	assert_eq(_ports(targets), [UP, RIGHT, LEFT], "targets must follow stable cardinal order")
	for target: Dictionary in targets:
		var hit_rect: Rect2 = target.get("hit_rect", Rect2())
		assert_gte(hit_rect.size.x, 44.0, "pointer target must be at least 44 px wide")
		assert_gte(hit_rect.size.y, 44.0, "pointer target must be at least 44 px tall")
	assert_true(bool(_target_for(targets, RIGHT).get("selected", false)), "selected direction must be explicit beyond color")
	assert_false(bool(_target_for(targets, UP).get("selected", true)))
	assert_eq(int(_target_for(targets, LEFT).get("cycle_count", -1)), 1)
	assert_eq(int(_target_for(targets, UP).get("cycle_count", -1)), 2)


func test_running_pointer_enqueues_cycle_intent_without_mutating_route_state() -> void:
	var overlay: Control = _overlay(_snapshot(&"RUNNING", false, RIGHT))
	assert_true(overlay.has_method("direction_targets_for_test"))
	assert_true(overlay.has_method("consume_route_selection_requests"), "overlay must expose intent consumption without signal wiring")
	if not overlay.has_method("direction_targets_for_test") or not overlay.has_method("consume_route_selection_requests"):
		return
	var target: Dictionary = _target_for(overlay.direction_targets_for_test(), LEFT)
	_send_click(overlay, (target.get("hit_rect", Rect2()) as Rect2).get_center())
	var requests: Array = overlay.consume_route_selection_requests()
	assert_eq(requests.size(), 1)
	if requests.size() == 1:
		assert_eq(requests[0].get("cell"), CELL)
		assert_eq(requests[0].get("target_port"), LEFT)
		assert_eq(int(requests[0].get("cycle_count", 0)), 1)


func test_locked_and_inactive_phases_reject_pointer_intent() -> void:
	var overlay: Control = _overlay(_snapshot(&"RUNNING", true, RIGHT))
	assert_true(overlay.has_method("direction_targets_for_test"))
	assert_true(overlay.has_method("consume_route_selection_requests"))
	if not overlay.has_method("direction_targets_for_test") or not overlay.has_method("consume_route_selection_requests"):
		return
	var target: Dictionary = _target_for(overlay.direction_targets_for_test(), LEFT)
	_send_click(overlay, (target.get("hit_rect", Rect2()) as Rect2).get_center())
	assert_eq(overlay.consume_route_selection_requests(), [], "occupied switch must reject direct selection")

	for phase: StringName in [&"BUILD", &"PAUSED", &"SUCCESS", &"FAILURE"]:
		overlay.apply_snapshot(_snapshot(phase, false, RIGHT))
		assert_eq(overlay.mouse_filter, Control.MOUSE_FILTER_IGNORE, "%s must not capture board input" % phase)
		var phase_target: Dictionary = _target_for(overlay.direction_targets_for_test(), LEFT)
		_send_click(overlay, (phase_target.get("hit_rect", Rect2()) as Rect2).get_center())
		assert_eq(overlay.consume_route_selection_requests(), [], "%s must ignore route selection" % phase)


func _overlay(snapshot: Dictionary) -> Control:
	var overlay: Control = OverlayScript.new()
	overlay.size = Vector2(600.0, 360.0)
	overlay.apply_snapshot(snapshot)
	return overlay


func _snapshot(phase: StringName, locked: bool, selected: Vector2i) -> Dictionary:
	return {
		"phase": phase,
		"board_size": Vector2i(3, 3),
		"route_controls": [{
			"cell": CELL,
			"kind": &"SWITCH",
			"available_exits": [UP, RIGHT, LEFT],
			"selected_exit": selected,
			"locked": locked,
		}],
	}


func _send_click(overlay: Control, position: Vector2) -> void:
	var event := InputEventMouseButton.new()
	event.button_index = MOUSE_BUTTON_LEFT
	event.pressed = true
	event.position = position
	overlay._gui_input(event)


static func _ports(targets: Array) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for target: Dictionary in targets:
		result.append(target.get("port", Vector2i.ZERO))
	return result


static func _target_for(targets: Array, port: Vector2i) -> Dictionary:
	for target: Dictionary in targets:
		if target.get("port") == port:
			return target
	return {}
