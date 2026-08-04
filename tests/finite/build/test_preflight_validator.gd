extends "res://tests/test_case.gd"

const VALIDATOR_PATH := "res://game/finite/build/preflight_validator.gd"
const RESULT_PATH := "res://game/finite/build/preflight_result.gd"
const Fixtures := preload("res://tests/fixtures/finite/preflight_fixtures.gd")


func run() -> void:
	var validator_exists := ResourceLoader.exists(VALIDATOR_PATH, "Script")
	var result_exists := ResourceLoader.exists(RESULT_PATH, "Script")
	assert_true(validator_exists, "finite preflight validator must exist")
	assert_true(result_exists, "finite preflight result must exist")
	if not validator_exists or not result_exists:
		return

	var validator_script: Script = load(VALIDATOR_PATH)
	var validator: Variant = validator_script.new()
	for case: Dictionary in Fixtures.cases():
		var fixture: Dictionary = Fixtures.make(case["name"])
		assert_false(fixture.is_empty(), "%s fixture must exist" % case["name"])
		if fixture.is_empty():
			continue
		assert_equal(
			fixture["definition"].validation_errors(),
			[],
			"%s definition must be valid before structural validation" % case["name"]
		)

		var first: Variant = validator.validate(fixture["definition"], fixture["layout"])
		assert_equal(first.primary_code, case["code"], "%s must return expected primary code" % case["name"])
		assert_equal(first.passed, case["code"] == &"PASS", "%s pass flag must match code" % case["name"])
		assert_equal(first.problem_cells, fixture["expected_cells"], "%s problem cells must match" % case["name"])
		assert_equal(first.problem_cells, _sorted_unique(first.problem_cells), "%s cells must be sorted and unique" % case["name"])
		if first.passed:
			assert_not_null(first.graph, "PASS must expose the validated graph")
		else:
			assert_equal(first.graph, null, "failed preflight must not expose a graph")

		for _iteration: int in range(100):
			var repeated_fixture: Dictionary = Fixtures.make(case["name"])
			var repeated: Variant = validator.validate(
				repeated_fixture["definition"],
				repeated_fixture["layout"]
			)
			assert_equal(repeated.primary_code, first.primary_code, "%s code must be deterministic" % case["name"])
			assert_equal(repeated.problem_cells, first.problem_cells, "%s cell order must be deterministic" % case["name"])


func _sorted_unique(cells: Array[Vector2i]) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for cell: Vector2i in cells:
		if not result.has(cell):
			result.append(cell)
	result.sort_custom(func(first: Vector2i, second: Vector2i) -> bool:
		if first.y != second.y:
			return first.y < second.y
		return first.x < second.x
	)
	return result
