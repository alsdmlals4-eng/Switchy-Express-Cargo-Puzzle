extends "res://tests/test_case.gd"

const MAP_PATH := "res://data/maps/vs_demo_01.json"
const MapLoaderScript := preload("res://game/finite/map/finite_map_loader.gd")
const ControllerScript := preload("res://game/finite/main/finite_slice_session_controller.gd")
const PROVIDER_PATH := "res://game/demo/recommended_layout_provider.gd"


func run() -> void:
	var definition: Variant = MapLoaderScript.load_from_path(MAP_PATH)
	assert_not_null(definition, "demo map must load")
	if definition == null:
		return

	assert_equal(definition.board_size, Vector2i(15, 11), "demo board must use a wider playfield")
	var marker_cells: Array[Vector2i] = _marker_cells(definition)
	assert_equal(marker_cells.size(), 6, "demo keeps two stations and four cargo markers")
	assert_true(_spread_width(marker_cells) >= 4, "markers must use a broad horizontal span")
	assert_true(_spread_height(marker_cells) >= 4, "markers must use a broad vertical span")
	assert_true(_minimum_pair_distance(marker_cells) >= 2, "stations and cargo must not be adjacent")

	assert_true(ResourceLoader.exists(PROVIDER_PATH), "recommended layout provider must exist")
	if not ResourceLoader.exists(PROVIDER_PATH):
		return
	var provider: Script = load(PROVIDER_PATH)
	assert_true(provider.has_method("pieces_for_map"), "provider must expose map-scoped pieces")
	if not provider.has_method("pieces_for_map"):
		return
	var pieces: Array = provider.pieces_for_map(definition.map_id, &"ALPHA")
	assert_true(pieces.size() >= 30, "recommended layout must provide a complete editable route")

	var controller: RefCounted = ControllerScript.new()
	assert_true(controller.initialize(MAP_PATH), "controller must initialize redesigned map")
	assert_true(controller.has_method("replace_layout"), "controller must expose production layout replacement")
	if not controller.has_method("replace_layout"):
		return
	assert_true(controller.replace_layout(pieces), "recommended layout must install")
	var model: Dictionary = controller.model()
	assert_true(bool(model.get("start_enabled", false)), "recommended layout must pass preflight")
	assert_true(model.get("problem_cells", []).is_empty(), "recommended layout must show no red warnings")

	controller.request_command(&"START")
	assert_equal(controller.phase(), &"RUNNING", "recommended layout must start")
	if controller.phase() != &"RUNNING":
		return
	controller.request_command(&"AUTO_TOGGLE")
	for _step: int in range(6000):
		if controller.phase() == &"SUCCESS" or controller.phase() == &"FAILURE":
			break
		controller.advance_time(0.05)
	assert_equal(controller.phase(), &"SUCCESS", "recommended route must complete the full delivery loop")


static func _marker_cells(definition: Variant) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for placement: Dictionary in definition.station_placements:
		result.append(_read_cell(placement.get("cell", [])))
	for placement: Dictionary in definition.cargo_placements:
		result.append(_read_cell(placement.get("cell", [])))
	return result


static func _spread_width(cells: Array[Vector2i]) -> int:
	var minimum := 999
	var maximum := -999
	for cell: Vector2i in cells:
		minimum = mini(minimum, cell.x)
		maximum = maxi(maximum, cell.x)
	return maximum - minimum


static func _spread_height(cells: Array[Vector2i]) -> int:
	var minimum := 999
	var maximum := -999
	for cell: Vector2i in cells:
		minimum = mini(minimum, cell.y)
		maximum = maxi(maximum, cell.y)
	return maximum - minimum


static func _minimum_pair_distance(cells: Array[Vector2i]) -> int:
	var result := 999
	for first_index: int in range(cells.size()):
		for second_index: int in range(first_index + 1, cells.size()):
			var delta := cells[first_index] - cells[second_index]
			result = mini(result, absi(delta.x) + absi(delta.y))
	return result


static func _read_cell(raw: Variant) -> Vector2i:
	if raw is Vector2i:
		return raw
	if raw is Array and raw.size() == 2:
		return Vector2i(int(raw[0]), int(raw[1]))
	return Vector2i(-1, -1)
