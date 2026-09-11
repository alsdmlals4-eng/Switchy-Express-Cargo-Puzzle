extends "res://tests/test_case.gd"

const ShellArtScript := preload("res://game/demo/presentation/product_shell_art.gd")

const LARGE_SIZE := Vector2(1280.0, 720.0)
const SMALL_SIZE := Vector2(320.0, 140.0)
const LEGACY_HERO_FRAGMENT := "/shells/shell_"
const REQUIRED_DECOR_KEYS: Array[String] = [
	"decoration_forest_cluster",
	"decoration_lantern_fence",
	"decoration_moss_boulder",
	"decoration_timber_stack",
	"decoration_waterway",
]


func run() -> void:
	var tree := Engine.get_main_loop() as SceneTree
	assert_not_null(tree, "shell composition test requires SceneTree")
	if tree == null:
		return

	var title := _make_art(tree, "TITLE", LARGE_SIZE)
	_check_mode_contract(title, "TITLE")
	assert_true(
		_paths(title).has("art/product_assets/night_workshop_v1/train.png"),
		"title composition keeps the approved overhead train"
	)
	assert_true(
		_paths(title).has("art/product_assets/night_workshop_v1/board_slate.png"),
		"title composition keeps the selected slate board"
	)
	_check_layout(title, LARGE_SIZE, "title large")
	_check_layout(title, SMALL_SIZE, "title small")
	_check_responsive_resize(title)
	title.free()

	var lesson := _make_art(tree, "LESSON", LARGE_SIZE)
	_check_mode_contract(lesson, "LESSON")
	assert_true(
		_paths(lesson).has("art/product_assets/topdown_v1/cargo_blue.png"),
		"ordinary lessons use approved overhead cargo"
	)
	_check_layout(lesson, LARGE_SIZE, "lesson large")
	lesson.set_lesson_id(&"T2")
	assert_true(
		_paths(lesson).has("art/product_assets/topdown_v1/station_red.png"),
		"T2 uses an approved top-down station"
	)
	assert_true(
		_paths(lesson).has("art/product_assets/topdown_v1/cargo_red.png"),
		"T2 uses matching approved top-down cargo"
	)
	assert_false(_has_legacy_hero(_paths(lesson)), "T2 retires the oblique lesson hero")
	_check_layout(lesson, LARGE_SIZE, "T2 large")
	_check_layout(lesson, SMALL_SIZE, "T2 small")
	_check_t2_cardinal_service(lesson, LARGE_SIZE)
	lesson.free()

	var success := _make_art(tree, "RESULT", LARGE_SIZE)
	success.set_result_outcome(&"SUCCESS")
	_check_mode_contract(success, "RESULT success")
	var success_paths := _paths(success)
	assert_true(
		success_paths.has("art/product_assets/topdown_v1/station_blue.png"),
		"success result uses the blue delivered-family composition"
	)
	_check_layout(success, LARGE_SIZE, "result success large")

	var failure_paths_before := success_paths.duplicate()
	success.set_result_outcome(&"FAILURE")
	_check_mode_contract(success, "RESULT failure")
	var failure_paths := _paths(success)
	assert_not_equal(failure_paths, failure_paths_before, "success and failure compositions stay visibly distinct")
	assert_true(
		failure_paths.has("art/product_assets/topdown_v1/station_disposal.png"),
		"failure result uses a distinct approved disposal-family composition"
	)
	_check_layout(success, SMALL_SIZE, "result failure small")
	success.free()

	_check_decor_family_consumption(tree)


func _make_art(tree: SceneTree, art_mode: String, art_size: Vector2) -> Control:
	var art: Control = ShellArtScript.new()
	art.mode = art_mode
	art.size = art_size
	tree.root.add_child(art)
	return art


func _check_mode_contract(art: Control, label: String) -> void:
	assert_equal(art.mouse_filter, Control.MOUSE_FILTER_IGNORE, "%s ignores pointer input" % label)
	assert_true(art.clip_contents, "%s clips composition to its Control" % label)
	assert_true(art.has_method("asset_paths_for_test"), "%s exposes active texture paths" % label)
	assert_true(art.has_method("loaded_asset_count_for_test"), "%s exposes loaded texture count" % label)
	assert_true(art.has_method("composition_layout_for_test"), "%s exposes computed placement diagnostics" % label)
	var paths := _paths(art)
	assert_false(paths.is_empty(), "%s has a composed texture family" % label)
	assert_false(_has_legacy_hero(paths), "%s has no legacy shell hero consumer" % label)
	if art.has_method("loaded_asset_count_for_test"):
		assert_equal(
			int(art.loaded_asset_count_for_test()),
			paths.size(),
			"%s loads every active path as Texture2D" % label
		)


func _check_layout(art: Control, viewport_size: Vector2, label: String) -> void:
	if not art.has_method("composition_layout_for_test"):
		return
	var layers: Array = art.composition_layout_for_test(viewport_size)
	assert_false(layers.is_empty(), "%s produces draw layers" % label)
	var bounds := Rect2(Vector2.ZERO, viewport_size)
	var rail_layers: Array[Dictionary] = []
	for value: Variant in layers:
		var layer: Dictionary = value
		var target: Rect2 = layer.get("target_rect", Rect2())
		var draw_rect: Rect2 = layer.get("draw_rect", Rect2())
		var normalized: Rect2 = layer.get("normalized_rect", Rect2())
		assert_true(bounds.encloses(target), "%s target stays inside the Control" % label)
		assert_true(bounds.encloses(draw_rect), "%s pixels stay inside the Control" % label)
		assert_true(_normalized_rect_is_bounded(normalized), "%s placement is normalized and bounded" % label)
		var texture: Texture2D = load("res://%s" % str(layer.get("path", ""))) as Texture2D
		assert_not_null(texture, "%s layer loads as Texture2D" % label)
		if texture != null and str(layer.get("fit", "")) == "CONTAIN" and draw_rect.size.y > 0.0:
			assert_almost_equal(
				draw_rect.size.x / draw_rect.size.y,
				texture.get_size().x / texture.get_size().y,
				0.001,
				"%s contained layer preserves source aspect" % label
			)
		if str(layer.get("role", "")) == "RAIL":
			rail_layers.append(layer)
	_check_rail_join_contract(rail_layers, label)


func _check_rail_join_contract(rail_layers: Array[Dictionary], label: String) -> void:
	assert_greater_equal(rail_layers.size(), 2, "%s illustrates a connected rail run" % label)
	rail_layers.sort_custom(
		func(left: Dictionary, right: Dictionary) -> bool:
			return Vector2i(left.get("grid_cell", Vector2i.ZERO)).x < Vector2i(right.get("grid_cell", Vector2i.ZERO)).x
	)
	for index: int in range(rail_layers.size()):
		var layer: Dictionary = rail_layers[index]
		var target: Rect2 = layer.get("target_rect", Rect2())
		var unit := float(layer.get("grid_unit", 0.0))
		assert_almost_equal(target.size.x, unit, 0.001, "%s rail width uses the shared square unit" % label)
		assert_almost_equal(target.size.y, unit, 0.001, "%s rail height uses the shared square unit" % label)
		if index > 0:
			var previous: Rect2 = rail_layers[index - 1].get("target_rect", Rect2())
			assert_almost_equal(
				target.position.x,
				previous.end.x,
				0.001,
				"%s adjacent rail cells share an exact join edge" % label
			)


func _check_t2_cardinal_service(lesson: Control, viewport_size: Vector2) -> void:
	if not lesson.has_method("composition_layout_for_test"):
		return
	var layers: Array = lesson.composition_layout_for_test(viewport_size)
	var service_rail := Rect2()
	var station := Rect2()
	var cargo := Rect2()
	var unit := 0.0
	for value: Variant in layers:
		var layer: Dictionary = value
		var semantic_role := str(layer.get("semantic_role", ""))
		if semantic_role.is_empty():
			semantic_role = str(layer.get("role", ""))
		match semantic_role:
			"SERVICE_RAIL":
				service_rail = layer.get("target_rect", Rect2())
				unit = float(layer.get("grid_unit", 0.0))
			"STATION":
				station = layer.get("target_rect", Rect2())
			"CARGO_ON_RAIL":
				cargo = layer.get("target_rect", Rect2())
	assert_true(service_rail.has_area(), "T2 identifies the station service rail cell")
	assert_true(station.has_area(), "T2 identifies the off-track station cell")
	assert_true(cargo.has_area(), "T2 identifies exact-cell cargo contact")
	var delta := station.get_center() - service_rail.get_center()
	assert_almost_equal(absf(delta.x) + absf(delta.y), unit, 0.001, "T2 station is exactly one cardinal tile from service rail")
	assert_true(absf(delta.x) < 0.001 or absf(delta.y) < 0.001, "T2 station service is not diagonal")
	assert_almost_equal(cargo.get_center().y, service_rail.get_center().y, 0.001, "T2 cargo is centered on the rail row")
	assert_true(cargo.get_center() != station.get_center(), "T2 station is never drawn on the cargo/rail cell")


func _check_responsive_resize(art: Control) -> void:
	if not art.has_method("composition_layout_for_test"):
		return
	var large: Array = art.composition_layout_for_test(LARGE_SIZE)
	var small: Array = art.composition_layout_for_test(SMALL_SIZE)
	assert_equal(small.size(), large.size(), "resize preserves the composition layer family")
	if large.size() > 1 and small.size() > 1:
		assert_true(
			float((small[1] as Dictionary).get("grid_unit", 0.0)) < float((large[1] as Dictionary).get("grid_unit", 0.0)),
			"resize recomputes a smaller shared grid unit"
		)


func _check_decor_family_consumption(tree: SceneTree) -> void:
	var consumed: Dictionary = {}
	for art_mode: String in ["TITLE", "LESSON"]:
		var art := _make_art(tree, art_mode, LARGE_SIZE)
		for value: String in _paths(art):
			for key: String in REQUIRED_DECOR_KEYS:
				if value.ends_with("/%s.png" % key):
					consumed[key] = true
		art.free()
	for outcome: StringName in [&"SUCCESS", &"FAILURE"]:
		var result := _make_art(tree, "RESULT", LARGE_SIZE)
		result.set_result_outcome(outcome)
		for value: String in _paths(result):
			for key: String in REQUIRED_DECOR_KEYS:
				if value.ends_with("/%s.png" % key):
					consumed[key] = true
		result.free()
	for key: String in REQUIRED_DECOR_KEYS:
		assert_true(bool(consumed.get(key, false)), "%s has a modest shell-scene consumer" % key)


func _paths(art: Control) -> Array[String]:
	var result: Array[String] = []
	if not art.has_method("asset_paths_for_test"):
		return result
	for value: Variant in art.asset_paths_for_test():
		result.append(str(value))
	return result


func _has_legacy_hero(paths: Array[String]) -> bool:
	for path: String in paths:
		if path.contains(LEGACY_HERO_FRAGMENT):
			return true
	return false


func _normalized_rect_is_bounded(rect: Rect2) -> bool:
	return (
		rect.position.x >= 0.0
		and rect.position.y >= 0.0
		and rect.end.x <= 1.0001
		and rect.end.y <= 1.0001
		and rect.size.x > 0.0
		and rect.size.y > 0.0
	)
