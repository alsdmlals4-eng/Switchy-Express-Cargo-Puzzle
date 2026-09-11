extends RefCounted


static func run(tree: SceneTree, output_root: String) -> Dictionary:
	var slice: Node = tree.root.get_node("Main/VerticalSliceDemo/GameplayContainer/ProductFiniteSlice")
	var hud: Control = slice.get_node("HUD")
	slice.request_command(&"RESUME")
	var model: Dictionary = slice.session_controller().model().duplicate(true)
	model.phase = &"RUNNING"
	model.stack_size = 64
	model.stack_tokens = []
	for index in range(64):
		model.stack_tokens.append({"cargo_type": &"BLUE_DIAMOND" if index >= 61 else &"RED_STAR", "top": index == 63})
	hud.apply_model(model)
	await tree.process_frame
	await RenderingServer.frame_post_draw
	assert(tree.root.get_texture().get_image().save_png(output_root + "manifest-64.png") == OK)
	var detail: RichTextLabel = hud.get_node("StackPanel/StackLayout/StackText")
	var result := {"mode": "presentation fixture only; not domain inventory",
		"viewport": str(tree.root.size), "logical_hud_size": str(hud.size),
		"panel_rect": str(hud.get_node("StackPanel").get_global_rect()),
		"detail_rect": str(detail.get_global_rect()),
		"scroll_max": detail.get_v_scroll_bar().max_value,
		"summary": hud.get_node("StackPanel/StackLayout/TopSummary").text}
	var file := FileAccess.open(output_root + "manifest-receipt.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(result, "  "))
	return result
