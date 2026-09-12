extends RefCounted

static func run(tree: SceneTree) -> Dictionary:
	var shell: Variant = tree.root.get_node("Main/VerticalSliceDemo")
	shell.return_to_title()
	shell.open_route_book()
	shell.select_route_book(&"ROUTE_BOOK_01")
	shell.select_route_book_stage(&"RB01_SERVICE_SIDINGS")
	shell.begin_build()
	var product: Variant = shell.gameplay_instance()
	var witness: Array = load("res://tests/fixtures/route_book/route_book_witnesses.gd").pieces(&"RB01_SERVICE_SIDINGS")
	var selected := -1
	for i: int in range(witness.size()):
		var pieces: Array = witness.duplicate()
		pieces.remove_at(i)
		product.install_layout_for_test(pieces)
		if product.session_controller().model().primary_reason == &"UNREACHABLE_STATION_SERVICE":
			selected = i
			break
	await tree.process_frame
	await RenderingServer.frame_post_draw
	var path := "res://evidence/runtime/build-guidance-20260913/station-guidance.png"
	var saved: int = tree.root.get_texture().get_image().save_png(path)
	var label: Label = product.get_node("HUD/ProblemBanner/ProblemLayout/ProblemText")
	return {"selected": selected, "code": str(product.session_controller().model().primary_reason), "text": label.text, "label_size": str(label.size), "minimum": str(label.get_minimum_size()), "save_error": saved}
