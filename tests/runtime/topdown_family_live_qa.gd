extends RefCounted

# Live-engine evidence only. Authored witness input is not human play or a new game rule.
const OUTPUT := "res://evidence/runtime/topdown-family-20260912/"
const T12 := preload("res://tests/fixtures/first_session/tut_01_02_solution.gd")
const Witnesses := preload("res://tests/fixtures/route_book/route_book_witnesses.gd")


static func run(tree: SceneTree, output_root: String = OUTPUT) -> Dictionary:
	assert(DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(output_root)) == OK)
	var shell: Control = tree.root.get_node("Main/VerticalSliceDemo")
	shell.return_to_title()
	await _capture(tree, output_root + "title.png")
	var result: Dictionary = await load("res://tests/runtime/night_workshop_live_qa.gd").run(tree, output_root)
	# Both normal cargo families and all five decoration slots come from unchanged maps.
	var boards: Array[Dictionary] = []
	for stage: StringName in [&"RB06_PORT_CIRCUIT", &"RB12_LANTERN_LOOP"]:
		shell.return_to_title()
		shell.open_route_book()
		assert(shell.select_route_book(&"ROUTE_BOOK_01" if stage == &"RB06_PORT_CIRCUIT" else &"ROUTE_BOOK_02"))
		assert(shell.select_route_book_stage(stage))
		shell.begin_build()
		var product: Control = shell.gameplay_instance()
		product.set_process(false)
		assert(product.install_layout_for_test(Witnesses.pieces(stage)))
		var renderer: Control = product.get_node("BoardRenderer")
		var loaded: Dictionary = renderer.loaded_product_visuals_for_test()
		for value: Variant in loaded.values():
			assert(value == true)
		await _capture(tree, output_root + ("board-rb06.png" if stage == &"RB06_PORT_CIRCUIT" else "board-rb12.png"))
		boards.append({"stage": str(stage), "loaded_textures": loaded, "model": product.session_controller().model(), "mode": "BUILD with authored witness; not a completed attempt"})
	# Reach T2 through actual T1 preflight, then fail by never requesting pickup.
	shell.return_to_title()
	shell.start_demo()
	shell.begin_build()
	var tutorial: Control = shell.gameplay_instance()
	tutorial.set_process(false)
	assert(tutorial.install_layout_for_test(T12.pieces()))
	assert(shell.current_lesson_id_for_test() == &"T2")
	assert(shell.state() == &"BRIEFING")
	await _capture(tree, output_root + "lesson-t2.png")
	shell.begin_build()
	tutorial.request_command_for_test(&"START")
	for step: int in range(3000):
		if shell.state() == &"RESULT":
			break
		tutorial.advance_time(0.05)
	assert(shell.state() == &"RESULT")
	assert(tutorial.session_controller().phase() != &"SUCCESS")
	await _capture(tree, output_root + "failure.png")
	result["boards"] = boards
	result["t2_reached_through_preflight"] = true
	result["failure_model"] = tutorial.session_controller().model()
	result["final_user_review"] = "NOT_RUN"
	result["scope"] = "exact live renderer; programmatic navigation and manually stepped domain clock"
	var file := FileAccess.open(output_root + "receipt.json", FileAccess.WRITE)
	assert(file != null)
	file.store_string(JSON.stringify(result, "  "))
	shell.return_to_title()
	return result


static func _capture(tree: SceneTree, filename: String) -> void:
	await tree.process_frame
	await RenderingServer.frame_post_draw
	assert(tree.root.get_texture().get_image().save_png(filename) == OK)
