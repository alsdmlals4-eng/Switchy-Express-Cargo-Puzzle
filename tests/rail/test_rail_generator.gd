extends "res://tests/test_case.gd"

const GENERATOR_PATH := "res://game/rail/rail_generator.gd"


func run() -> void:
	var script_exists := ResourceLoader.exists(GENERATOR_PATH, "Script")
	assert_true(script_exists, "RailGenerator script must exist")
	if not script_exists:
		return

	var generator_script: Script = load(GENERATOR_PATH)
	var generator: Variant = generator_script.new()
	for seed: int in range(1, 101):
		var graph: Variant = generator.generate(seed)
		assert_equal(graph.width, 15, "seed %d must use 15 columns" % seed)
		assert_equal(graph.height, 10, "seed %d must use 10 rows" % seed)
		assert_true(graph.is_connected(), "seed %d rail graph must be connected" % seed)
		assert_equal(graph.dead_end_count(), 0, "seed %d must have no degree-1 endpoint" % seed)
		assert_greater_equal(graph.cycle_rank(), 3, "seed %d must contain at least three independent cycles" % seed)
		assert_greater_equal(graph.switch_cells().size(), 6, "seed %d must contain at least six switches" % seed)
		assert_greater_equal(graph.meaningful_switch_count(3), 6, "seed %d switches must create paths that differ for at least three cells" % seed)

	var first_signature: String = generator.generate(42).signature()
	var repeated_signature: String = generator.generate(42).signature()
	assert_equal(repeated_signature, first_signature, "same seed must generate the same graph")

	var fallback_graph: Variant = generator.generate(7, 32, true)
	assert_true(fallback_graph.used_fallback, "forced candidate failure must use deterministic safe fallback")
	assert_true(fallback_graph.is_connected(), "safe fallback must be connected")
	assert_equal(fallback_graph.dead_end_count(), 0, "safe fallback must have no dead ends")
	assert_greater_equal(fallback_graph.switch_cells().size(), 6, "safe fallback must keep required switches")
