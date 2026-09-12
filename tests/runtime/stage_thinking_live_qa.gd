extends RefCounted

static func run(tree: SceneTree) -> Dictionary:
	var shell: Variant = tree.root.get_node("Main/VerticalSliceDemo")
	shell.return_to_title()
	shell.open_route_book()
	shell.select_route_book(&"ROUTE_BOOK_02")
	shell.select_route_book_stage(&"RB09_SALVAGE_SIDING")
	await tree.process_frame
	await RenderingServer.frame_post_draw
	var rules: Label = shell.get_node("BriefingScreen/Panel/Content/Rules")
	var first: String = rules.text
	var error: int = tree.root.get_texture().get_image().save_png("res://evidence/runtime/stage-thinking-20260913/salvage-briefing.png")
	var bounds := {"size": str(rules.size), "minimum": str(rules.get_minimum_size())}
	await load("res://tests/runtime/build_history_live_qa.gd").click(tree, shell.get_node("BriefingScreen/Panel/Content/BeginButton"))
	var map_id: String = str(shell.gameplay_instance().session_controller().render_snapshot().get("map_id"))
	shell.return_to_title()
	shell.open_route_book()
	shell.select_route_book(&"ROUTE_BOOK_01")
	shell.select_route_book_stage(&"RB02_REVERSE_ORDER")
	await tree.process_frame
	return {"capture_error":error,"first":first,"next":rules.text,"changed":rules.text != first,"map_id":map_id,"bounds":bounds,"viewport":str(tree.root.size)}
