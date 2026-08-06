extends "res://tests/test_case.gd"

const ProductScene := preload("res://game/demo/product_finite_slice.tscn")
const AlphaFixture := preload("res://tests/fixtures/finite/vs_demo_solution_alpha.gd")


func run() -> void:
	var tree := Engine.get_main_loop() as SceneTree
	assert_not_null(tree, "touch parity test requires SceneTree")
	if tree == null:
		return

	var product: Control = ProductScene.instantiate()
	tree.root.add_child(product)
	var renderer := product.get_node("BoardRenderer") as Control
	var controller: RefCounted = product.session_controller()
	var local_point := renderer.size * 0.5

	var mouse := InputEventMouseButton.new()
	mouse.button_index = MOUSE_BUTTON_LEFT
	mouse.pressed = true
	mouse.position = local_point
	renderer._gui_input(mouse)
	var mouse_command: StringName = controller.last_command()
	var mouse_payload: Variant = controller.last_payload()

	product.request_command_for_test(&"CANCEL_SELECTION")
	var touch := InputEventScreenTouch.new()
	touch.pressed = true
	touch.position = local_point
	renderer._gui_input(touch)
	assert_equal(controller.last_command(), mouse_command, "touch and mouse use the same board command")
	assert_equal(controller.last_payload(), mouse_payload, "touch and mouse preserve the same board cell")

	assert_true(product.install_layout_for_test(AlphaFixture.pieces()), "touch parity test installs authored route")
	product.request_command_for_test(&"START")
	assert_equal(controller.phase(), &"RUNNING", "load parity requires active run")

	var load_button := product.get_node("HUD/RunToolbar/LoadButton") as Button
	load_button.button_down.emit()
	var button_down_command: StringName = controller.last_command()
	var button_down_payload: Variant = controller.last_payload()
	load_button.button_up.emit()
	var button_up_command: StringName = controller.last_command()
	var button_up_payload: Variant = controller.last_payload()

	var shift_down: Dictionary = product.dispatch_action_for_test(&"demo_load", true)
	assert_true(bool(shift_down.get("accepted", false)), "Shift down is accepted during RUNNING")
	assert_equal(controller.last_command(), button_down_command, "Shift down and button down share command")
	assert_equal(controller.last_payload(), button_down_payload, "Shift down and button down share payload")

	var shift_up: Dictionary = product.dispatch_action_for_test(&"demo_load", false)
	assert_true(bool(shift_up.get("accepted", false)), "Shift up is accepted during RUNNING")
	assert_equal(controller.last_command(), button_up_command, "Shift up and button up share command")
	assert_equal(controller.last_payload(), button_up_payload, "Shift up and button up share payload")

	product.free()
