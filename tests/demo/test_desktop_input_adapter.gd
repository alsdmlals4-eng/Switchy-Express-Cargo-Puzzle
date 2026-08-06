extends "res://tests/test_case.gd"

const AdapterScript := preload("res://game/demo/input/desktop_input_adapter.gd")

const REQUIRED_ACTIONS: Array[StringName] = [
	&"demo_tool_straight",
	&"demo_tool_curve",
	&"demo_tool_switch",
	&"demo_tool_crossing",
	&"demo_rotate",
	&"demo_primary",
	&"demo_load",
	&"demo_auto",
	&"demo_cancel",
	&"demo_confirm",
]


func run() -> void:
	var adapter: Node = AdapterScript.new()

	_assert_command(adapter, &"demo_tool_straight", true, &"BUILD", &"BUILD_TOOL", &"STRAIGHT")
	_assert_command(adapter, &"demo_tool_curve", true, &"BUILD", &"BUILD_TOOL", &"CURVE")
	_assert_command(adapter, &"demo_tool_switch", true, &"BUILD", &"BUILD_TOOL", &"SWITCH")
	_assert_command(adapter, &"demo_tool_crossing", true, &"BUILD", &"BUILD_TOOL", &"CROSSING")
	_assert_command(adapter, &"demo_rotate", true, &"BUILD", &"ROTATE", null)
	_assert_command(adapter, &"demo_primary", true, &"BUILD", &"START", null)
	_assert_command(adapter, &"demo_primary", true, &"RUNNING", &"PAUSE", null)
	_assert_command(adapter, &"demo_primary", true, &"UNLOADING", &"PAUSE", null)
	_assert_command(adapter, &"demo_primary", true, &"PAUSED", &"RESUME", null)
	_assert_command(adapter, &"demo_load", true, &"RUNNING", &"LOAD_ACTIVE", true)
	_assert_command(adapter, &"demo_load", false, &"RUNNING", &"LOAD_ACTIVE", false)
	_assert_command(adapter, &"demo_load", true, &"UNLOADING", &"LOAD_ACTIVE", true)
	_assert_command(adapter, &"demo_auto", true, &"RUNNING", &"AUTO_TOGGLE", null)
	_assert_command(adapter, &"demo_cancel", true, &"BUILD", &"CANCEL_SELECTION", null)
	_assert_command(adapter, &"demo_cancel", true, &"RUNNING", &"PAUSE", null)
	_assert_command(adapter, &"demo_confirm", true, &"TITLE", &"FLOW_CONFIRM", null)

	_assert_rejected(adapter, &"demo_rotate", true, &"RUNNING")
	_assert_rejected(adapter, &"demo_load", true, &"BUILD")
	_assert_rejected(adapter, &"demo_auto", false, &"RUNNING")
	_assert_rejected(adapter, &"demo_primary", false, &"BUILD")

	for action: StringName in REQUIRED_ACTIONS:
		assert_true(InputMap.has_action(action), "%s must exist in InputMap" % action)
		assert_true(
			InputMap.action_get_events(action).size() >= 1,
			"%s must have at least one bound event" % action
		)

	adapter.free()


func _assert_command(
	adapter: Node,
	action: StringName,
	pressed: bool,
	phase: StringName,
	expected_command: StringName,
	expected_payload: Variant
) -> void:
	var result: Dictionary = adapter.command_for_action(action, pressed, phase)
	assert_true(bool(result.get("accepted", false)), "%s must be accepted in %s" % [action, phase])
	assert_equal(result.get("command", &""), expected_command, "%s command mapping" % action)
	assert_equal(result.get("payload"), expected_payload, "%s payload mapping" % action)


func _assert_rejected(
	adapter: Node,
	action: StringName,
	pressed: bool,
	phase: StringName
) -> void:
	var result: Dictionary = adapter.command_for_action(action, pressed, phase)
	assert_false(bool(result.get("accepted", false)), "%s must be rejected in %s" % [action, phase])
