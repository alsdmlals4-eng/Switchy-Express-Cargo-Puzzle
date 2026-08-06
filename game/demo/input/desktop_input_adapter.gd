class_name DesktopInputAdapter
extends Node

signal command_requested(command: StringName, payload: Variant)

const ACTIONS: Array[StringName] = [
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

var _phase: StringName = &"TITLE"
var _gameplay_enabled: bool = true


func set_phase(phase: StringName) -> void:
	_phase = phase


func set_gameplay_enabled(enabled: bool) -> void:
	_gameplay_enabled = enabled


func command_for_action(
	action: StringName,
	pressed: bool,
	phase: StringName
) -> Dictionary:
	match action:
		&"demo_tool_straight":
			return _build_tool_result(pressed, phase, &"STRAIGHT")
		&"demo_tool_curve":
			return _build_tool_result(pressed, phase, &"CURVE")
		&"demo_tool_switch":
			return _build_tool_result(pressed, phase, &"SWITCH")
		&"demo_tool_crossing":
			return _build_tool_result(pressed, phase, &"CROSSING")
		&"demo_rotate":
			return _accepted(&"ROTATE") if pressed and phase == &"BUILD" else _rejected()
		&"demo_primary":
			if not pressed:
				return _rejected()
			if phase == &"BUILD":
				return _accepted(&"START")
			if phase == &"RUNNING" or phase == &"UNLOADING":
				return _accepted(&"PAUSE")
			if phase == &"PAUSED":
				return _accepted(&"RESUME")
		&"demo_load":
			if phase == &"RUNNING" or phase == &"UNLOADING":
				return _accepted(&"LOAD_ACTIVE", pressed)
		&"demo_auto":
			if pressed and (phase == &"RUNNING" or phase == &"UNLOADING"):
				return _accepted(&"AUTO_TOGGLE")
		&"demo_cancel":
			if not pressed:
				return _rejected()
			if phase == &"BUILD":
				return _accepted(&"CANCEL_SELECTION")
			if phase == &"RUNNING" or phase == &"UNLOADING":
				return _accepted(&"PAUSE")
			if phase == &"PAUSED":
				return _accepted(&"RESUME")
		&"demo_confirm":
			return _accepted(&"FLOW_CONFIRM") if pressed else _rejected()
	return _rejected()


func _unhandled_input(event: InputEvent) -> void:
	if not _gameplay_enabled:
		return
	if event is InputEventKey and event.echo:
		return

	for action: StringName in ACTIONS:
		if not event.is_action(action):
			continue
		var pressed: bool = event.is_pressed()
		var result: Dictionary = command_for_action(action, pressed, _phase)
		if bool(result.get("accepted", false)):
			command_requested.emit(result["command"], result.get("payload"))
			get_viewport().set_input_as_handled()
		return


static func _build_tool_result(
	pressed: bool,
	phase: StringName,
	geometry: StringName
) -> Dictionary:
	if pressed and phase == &"BUILD":
		return _accepted(&"BUILD_TOOL", geometry)
	return _rejected()


static func _accepted(command: StringName, payload: Variant = null) -> Dictionary:
	return {
		"accepted": true,
		"command": command,
		"payload": payload,
	}


static func _rejected() -> Dictionary:
	return {
		"accepted": false,
		"command": &"",
		"payload": null,
	}
