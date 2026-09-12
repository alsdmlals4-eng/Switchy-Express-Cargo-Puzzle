extends RefCounted

const OUT := "res://evidence/runtime/build-history-20260912/"
const Witness := preload("res://tests/fixtures/route_book/route_book_witnesses.gd")


static func run(tree: SceneTree) -> Dictionary:
	var shell: Control = tree.root.get_node("Main/VerticalSliceDemo")
	shell.return_to_title()
	shell.open_route_book()
	assert(shell.select_route_book(&"ROUTE_BOOK_01"))
	assert(shell.select_route_book_stage(&"RB01_SERVICE_SIDINGS"))
	shell.begin_build()
	var product: Control = shell.gameplay_instance()
	product.set_process(false)
	var controller: Variant = product.session_controller()
	var hud: Control = product.get_node("HUD")
	assert(product.install_layout_for_test(Witness.pieces(&"RB01_SERVICE_SIDINGS")))
	var original: String = controller.current_layout_signature()
	var original_cost: int = controller.model().get("current_cost")
	await capture(tree, "layout.png")
	await click(tree, hud.get_node("BuildToolbar/ClearButton"))
	assert(controller.model().get("current_cost") == 0)
	await capture(tree, "cleared.png")
	await click(tree, hud.get_node("BuildHistory/UndoButton"))
	assert(controller.current_layout_signature() == original)
	assert(controller.model().get("current_cost") == original_cost)
	await capture(tree, "restored.png")
	await key(tree, KEY_Y, false)
	assert(controller.model().get("current_cost") == 0)
	await key(tree, KEY_Z, false)
	assert(controller.current_layout_signature() == original)
	await key(tree, KEY_Z, true)
	assert(controller.model().get("current_cost") == 0)
	await key(tree, KEY_Z, false)
	assert(controller.current_layout_signature() == original)
	var history: Control = hud.get_node("BuildHistory")
	var board: Control = product.get_node("BoardRenderer")
	assert(not history.get_global_rect().intersects(board.get_global_rect()))
	assert(tree.root.get_visible_rect().encloses(history.get_global_rect()))
	await click(tree, hud.get_node("BuildToolbar/StartButton"))
	assert(controller.phase() == &"RUNNING")
	assert(not history.visible)
	await key(tree, KEY_Z, false)
	assert(controller.current_layout_signature() == original)
	controller.request_command(&"EDIT_LAYOUT")
	assert(not controller.model().get("undo_enabled"))
	assert(not controller.model().get("redo_enabled"))
	await capture(tree, "edit-baseline.png")
	var receipt := {
		"status": "PASS", "scope": "actual running Godot main; synthetic mouse and keyboard events; no human play",
		"viewport": str(tree.root.size), "stage": "RB01_SERVICE_SIDINGS",
		"checks": ["mouse clear", "mouse undo", "Ctrl Y redo", "Ctrl Z undo", "Ctrl Shift Z redo", "cost and layout restoration", "panel outside board", "RUN keyboard lock", "Edit fresh baseline"],
		"original_layout_signature": original, "original_cost": original_cost,
		"human_review": "NOT_RUN", "device_review": "NOT_RUN"
	}
	var file := FileAccess.open(OUT + "receipt.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(receipt, "  "))
	return receipt


static func click(tree: SceneTree, button: Button) -> void:
	await tree.process_frame
	# Input.parse_input_event receives physical window coordinates; Control rects
	# remain in logical 1920x1080 coordinates under viewport stretch.
	var position := tree.root.get_final_transform() * button.get_global_rect().get_center()
	for pressed: bool in [true, false]:
		var event := InputEventMouseButton.new()
		event.position = position
		event.global_position = position
		event.button_index = MOUSE_BUTTON_LEFT
		event.pressed = pressed
		Input.parse_input_event(event)
		await tree.process_frame


static func key(tree: SceneTree, code: Key, shifted: bool) -> void:
	for pressed: bool in [true, false]:
		var event := InputEventKey.new()
		event.keycode = code
		event.ctrl_pressed = true
		event.shift_pressed = shifted
		event.pressed = pressed
		Input.parse_input_event(event)
		await tree.process_frame


static func capture(tree: SceneTree, name: String) -> void:
	await tree.process_frame
	await RenderingServer.frame_post_draw
	assert(tree.root.get_texture().get_image().save_png(OUT + name) == OK)
