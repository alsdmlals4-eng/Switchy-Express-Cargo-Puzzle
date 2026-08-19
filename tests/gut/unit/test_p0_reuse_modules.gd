extends GutTest

const GRID_PATH := "res://game/reuse/grid_placement_rule_engine.gd"
const SKIN_PATH := "res://game/reuse/semantic_ui_skin_kit.gd"
const SYMBOL_PATH := "res://game/reuse/gameplay_symbol_atlas.gd"
const ADAPTER_PATH := "res://game/reuse/switchy_reuse_adapter.gd"


func test_shared_grid_contract_handles_switchy_build_bounds_and_overlap() -> void:
	assert_true(ResourceLoader.exists(GRID_PATH, "Script"), "shared grid engine must be vendored")
	if not ResourceLoader.exists(GRID_PATH, "Script"):
		return
	var engine: Variant = load(GRID_PATH).new()
	var valid: Dictionary = engine.evaluate(
		Vector2i(4, 4),
		{},
		[Vector2i.ZERO, Vector2i.RIGHT],
		Vector2i(1, 1)
	)
	assert_true(valid.valid)
	assert_eq(valid.target_cells, [Vector2i(1, 1), Vector2i(2, 1)])

	var occupied: Dictionary = {Vector2i(2, 1): true}
	var blocked: Dictionary = engine.evaluate(
		Vector2i(4, 4), occupied, [Vector2i.ZERO, Vector2i.RIGHT], Vector2i(1, 1)
	)
	assert_false(blocked.valid)
	assert_has(blocked.reason_codes, "OCCUPIED")

	var out_of_bounds: Dictionary = engine.evaluate(
		Vector2i(4, 4), {}, [Vector2i.ZERO, Vector2i.RIGHT], Vector2i(3, 3)
	)
	assert_false(out_of_bounds.valid)
	assert_has(out_of_bounds.reason_codes, "OUT_OF_BOUNDS")


func test_switchy_adapter_preserves_shape_text_redundancy_and_semantic_states() -> void:
	for path: String in [SKIN_PATH, SYMBOL_PATH, ADAPTER_PATH]:
		assert_true(ResourceLoader.exists(path, "Script"), "%s must exist" % path)
	if not ResourceLoader.exists(ADAPTER_PATH, "Script"):
		return
	var adapter: Variant = load(ADAPTER_PATH).new()
	var build_invalid: Dictionary = adapter.resolve_ui("build_action", "invalid")
	assert_true(build_invalid.ok)
	assert_eq(build_invalid.token, "build_invalid")

	var cargo: Dictionary = adapter.resolve_symbol("cargo")
	assert_true(cargo.ok)
	assert_false(cargo.shape_cue.is_empty())
	assert_false(cargo.text_cue.is_empty())
	assert_true(cargo.color_is_not_sufficient)


func test_rotation_keeps_grid_engine_project_neutral() -> void:
	if not ResourceLoader.exists(GRID_PATH, "Script"):
		return
	var engine: Variant = load(GRID_PATH).new()
	var rotated: Dictionary = engine.evaluate(
		Vector2i(5, 5),
		{},
		[Vector2i.ZERO, Vector2i.RIGHT],
		Vector2i(2, 2),
		1
	)
	assert_true(rotated.valid)
	assert_eq(rotated.target_cells, [Vector2i(2, 2), Vector2i(2, 3)])
