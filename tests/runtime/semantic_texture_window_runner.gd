extends SceneTree

# Actual product renderer with authored setup/clock. Not native input or human play.
const Product := preload("res://game/demo/product_finite_slice.tscn")
const Fixture := preload("res://tests/fixtures/first_session/tut_06_solution_driver.gd")
var failures: Array[String] = []


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	if DisplayServer.get_name() == "headless":
		printerr("SEMANTIC_TEXTURE: window renderer required")
		quit(2)
		return
	var output := "res://build/semantic-texture-qa/%d/" % OS.get_process_id()
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(output))
	root.size = Vector2i(1280, 720)
	var product: Control = Product.instantiate()
	product.map_path = "res://data/maps/tutorial/tut_06_switch.json"
	root.add_child(product)
	product.set_process(false)
	if not product.install_layout_for_test(Fixture.pieces()):
		quit(2)
		return
	product.request_command(&"START")
	product.request_command(&"BOARD_CELL", Vector2i(3, 3))
	var samples: Array[Dictionary] = []
	samples.append(await _capture(product, output, "unoccupied"))
	for step: int in range(100):
		product.advance_time(0.02)
		if product.session_controller().render_snapshot().get("train_cell") == Vector2i(3, 3):
			break
	var snapshot: Dictionary = product.session_controller().render_snapshot()
	if snapshot.get("train_cell") != Vector2i(3, 3) or not snapshot.route_controls[0].locked:
		failures.append("did not reach actual occupied switch")
	samples.append(await _capture(product, output, "occupied"))
	for sample: Dictionary in samples:
		if sample.get("white_ratios", []).size() != 3 or str(sample.get("sha256", "")).length() != 64:
			failures.append("incomplete capture result")
	var receipt := {"status": "PASS" if failures.is_empty() else "FAIL", "failures": failures,
		"samples": samples, "scope": "actual ProductFiniteSlice T6; authored fixture/commands/stepped clock; not native or human input",
		"engine": Engine.get_version_info().string, "human": "NOT_RUN"}
	var file := FileAccess.open(output + "receipt.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(receipt, "\t"))
	print("SEMANTIC_TEXTURE: " + JSON.stringify(receipt))
	print("SEMANTIC_TEXTURE_OUTPUT: " + ProjectSettings.globalize_path(output))
	product.free()
	# Existing product audio retires through a deferred frame callback.
	await process_frame
	await process_frame
	quit(0 if failures.is_empty() else 1)


func _capture(product: Control, output: String, state: String) -> Dictionary:
	await process_frame
	await RenderingServer.frame_post_draw
	var image := root.get_texture().get_image()
	var overlay: Control = product.get_node("RouteControlOverlay")
	var ratios: Array[float] = []
	for target: Dictionary in overlay.direction_targets_for_test():
		var rect: Rect2 = target.hit_rect
		var begin: Vector2 = root.get_final_transform() * (overlay.get_global_transform() * rect.position)
		var extent: Vector2 = rect.size * root.get_final_transform().get_scale()
		var region := Rect2i(Vector2i(begin), Vector2i(extent)).intersection(Rect2i(Vector2i.ZERO, image.get_size()))
		var white := 0
		for y: int in range(region.position.y, region.end.y):
			for x: int in range(region.position.x, region.end.x):
				var pixel := image.get_pixel(x, y)
				if pixel.r > 0.98 and pixel.g > 0.98 and pixel.b > 0.98:
					white += 1
		var area := region.size.x * region.size.y
		var ratio := float(white) / maxf(float(area), 1.0)
		ratios.append(ratio)
		if area == 0 or ratio > 0.25:
			failures.append("%s direction target is blank/white: %s" % [state, ratio])
	if ratios.size() != 3:
		failures.append("expected three visible direction targets")
	var path := output + state + ".png"
	if image.save_png(path) != OK:
		failures.append("capture write failed")
	return {"state": state, "white_ratios": ratios, "path": path, "sha256": FileAccess.get_sha256(path)}
