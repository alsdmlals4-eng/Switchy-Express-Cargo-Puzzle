extends RefCounted

# Invoked only in a live editor session; tests/** is excluded from release PCKs.


static func run(tree: SceneTree, output_root: String = "res://evidence/runtime/night-workshop-20260910/") -> Dictionary:
	var shell := tree.root.get_node("Main/VerticalSliceDemo")
	shell.get_node("TitleScreen/TitleMargin/TitleColumns/ActionDeck/Content/StageBookButton").pressed.emit()
	await tree.process_frame
	shell.get_node("RouteBookScreen/Panel/Content/StageScroll/StageList/ROUTE_BOOK_01Card").pressed.emit()
	await tree.process_frame
	shell.get_node("RouteBookScreen/Panel/Content/StageScroll/StageList/RB01_SERVICE_SIDINGSCard").pressed.emit()
	await tree.process_frame
	shell.get_node("BriefingScreen/Panel/Content/BeginButton").pressed.emit()
	await tree.process_frame
	var slice := shell.get_node("GameplayContainer/ProductFiniteSlice")
	slice.set_process(false)
	var pieces = load("res://tests/fixtures/route_book/route_book_witnesses.gd").pieces(&"RB01_SERVICE_SIDINGS")
	assert(slice.install_layout_for_test(pieces))
	await RenderingServer.frame_post_draw
	var root := output_root
	assert(tree.root.get_texture().get_image().save_png(root + "build.png") == OK)
	slice.request_command(&"START")
	slice.request_command(&"AUTO_TOGGLE")
	var renderer := slice.get_node("BoardRenderer")
	var steps := 0
	while renderer._cargo_pickup.frame_index() < 0 and steps < 300:
		slice.advance_time(0.01)
		steps += 1
	renderer.set_process(false)
	assert(renderer._cargo_pickup.frame_index() == 0)
	var frames: Array[int] = []
	for index in range(4):
		if index == 2:
			slice.request_command(&"PAUSE")
			renderer._process(1.0)
			assert(renderer._cargo_pickup.frame_index() == 2)
			slice.request_command(&"RESUME")
			renderer.set_process(false)
		frames.append(renderer._cargo_pickup.frame_index())
		renderer.queue_redraw()
		await RenderingServer.frame_post_draw
		assert(tree.root.get_texture().get_image().save_png(root + "pickup-%d.png" % index) == OK)
		renderer._cargo_pickup.advance(0.061)
	assert(frames == [0, 1, 2, 3])
	assert(renderer._cargo_pickup.frame_index() == -1)
	for index in range(2000):
		slice.advance_time(0.01)
		if slice.session_controller().phase() not in [&"RUNNING", &"UNLOADING"]:
			break
	await RenderingServer.frame_post_draw
	assert(tree.root.get_texture().get_image().save_png(root + "result.png") == OK)
	var result := {"mode": "live engine with programmatic UI signals and authored witness; manually stepped domain clock",
		"pickup_steps": steps, "frames": frames, "phase": str(slice.session_controller().phase()),
		"viewport": str(tree.root.size), "model": slice.session_controller().model()}
	assert(result.phase == "SUCCESS")
	assert(result.model.remaining_map_cargo == 0)
	assert(result.model.stack_size == 0)
	var layout_signature: String = slice.session_controller().current_layout_signature()
	shell.get_node("ResultOverlay/Panel/Content/Actions/RetryButton").pressed.emit()
	await tree.process_frame
	assert(slice.session_controller().current_layout_signature() == layout_signature)
	assert(renderer._cargo_pickup.frame_index() == -1)
	slice.request_command(&"PAUSE")
	slice.request_command(&"EDIT_LAYOUT")
	result["pause_preserves_frame"] = true
	result["retry_preserves_layout_cancels_visual"] = true
	var file := FileAccess.open(root + "receipt.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(result, "  "))
	return result
