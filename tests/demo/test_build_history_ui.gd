extends "res://tests/test_case.gd"

const Product := preload("res://game/demo/product_finite_slice.tscn")
const Definition := preload("res://game/first_session/first_session_definition.gd")
const Policy := preload("res://game/first_session/first_session_stage_policy.gd")
const Adapter := preload("res://game/demo/input/desktop_input_adapter.gd")


func run() -> void:
	var product: Variant = Product.instantiate()
	(Engine.get_main_loop() as SceneTree).root.add_child(product)
	var hud: Variant = product.get_node("HUD")
	var undo: Variant = hud.get_node_or_null("BuildHistory/UndoButton")
	assert_not_null(undo, "BUILD recovery needs a visible pointer action")
	if undo == null:
		product.free()
		return
	var redo: Variant = hud.get_node("BuildHistory/RedoButton")
	assert_true(undo.disabled and redo.disabled, "empty history disables both actions")
	product.request_command(&"BUILD_TOOL", &"STRAIGHT")
	product.request_command(&"BOARD_CELL", Vector2i(2, 4))
	var controller: Variant = product.session_controller()
	var cost: int = controller.model().get("current_cost")
	assert_true(cost > 0 and not undo.disabled, "placement enables undo")
	undo.pressed.emit()
	assert_equal(controller.model().get("current_cost"), 0, "pointer undo shares domain")
	assert_false(redo.disabled, "pointer redo available")
	redo.pressed.emit()
	assert_equal(controller.model().get("current_cost"), cost, "pointer redo restores cost")
	var definition: Variant = Definition.load_from_path("res://data/first_session/first_session_v1.json")
	product.set_stage_policy(Policy.create(definition.lesson(&"T2")))
	assert_false(hud.get_node("BuildHistory").visible, "fixed lesson hides editing history")
	var signature: String = controller.current_layout_signature()
	product.request_command(&"UNDO")
	assert_equal(controller.current_layout_signature(), signature, "fixed lesson rejects direct history")
	product.set_stage_policy(Policy.create(definition.lesson(&"T1")))
	assert_true(hud.get_node("BuildHistory").visible, "editable lesson exposes recovery")
	product.request_command(&"UNDO")
	assert_equal(controller.model().get("current_cost"), 0, "editable lesson permits undo")
	product.free()
	var adapter: Variant = Adapter.new()
	assert_true(adapter.has_method("command_for_key_event"), "keyboard shares explicit history boundary")
	if adapter.has_method("command_for_key_event"):
		var key := InputEventKey.new()
		key.keycode = KEY_Z
		key.pressed = true
		key.ctrl_pressed = true
		assert_equal(adapter.command_for_key_event(key, &"BUILD").get("command"), &"UNDO", "Ctrl Z")
		key.shift_pressed = true
		assert_equal(adapter.command_for_key_event(key, &"BUILD").get("command"), &"REDO", "Ctrl Shift Z")
		key.shift_pressed = false
		key.keycode = KEY_Y
		assert_equal(adapter.command_for_key_event(key, &"BUILD").get("command"), &"REDO", "Ctrl Y")
		for phase: StringName in [&"TITLE", &"RUNNING", &"UNLOADING", &"PAUSED", &"SUCCESS", &"FAILURE"]:
			assert_false(adapter.command_for_key_event(key, phase).get("accepted", false), "no history outside BUILD")
		key.echo = true
		assert_false(adapter.command_for_key_event(key, &"BUILD").get("accepted", false), "no held key repeat")
		key.echo = false
		key.ctrl_pressed = false
		assert_false(adapter.command_for_key_event(key, &"BUILD").get("accepted", false), "bare Y does nothing")
	adapter.free()
