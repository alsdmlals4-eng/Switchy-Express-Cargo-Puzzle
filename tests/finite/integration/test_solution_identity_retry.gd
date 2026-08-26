extends "res://tests/test_case.gd"

const FACTORY_PATH := "res://game/finite/run/finite_run_session_factory.gd"
const FIXTURE_PATH := "res://tests/fixtures/finite/finite_retry_fixture.gd"


func run() -> void:
	var factory_exists := ResourceLoader.exists(FACTORY_PATH, "Script")
	assert_true(factory_exists, "finite run session factory must exist")
	if not factory_exists:
		return

	var fixture_script: Script = load(FIXTURE_PATH)
	var inputs: Dictionary = fixture_script.sealed_inputs()
	assert_false(inputs.is_empty(), "identity retry fixture must produce sealed inputs")
	if inputs.is_empty():
		return

	var definition: Variant = inputs["definition"]
	var sealed: Dictionary = inputs["sealed"]
	var original_definition: Dictionary = definition.to_dictionary()
	var original_signature: String = sealed["layout_signature"]
	var factory_script: Script = load(FACTORY_PATH)
	var factory: Variant = factory_script.new()
	assert_true(factory.configure(definition, sealed, 2.0), "factory must configure from sealed inputs")

	definition.map_revision = 99
	sealed["layout"].clear()
	sealed["layout_signature"] = "tampered"

	var first_result: Dictionary = factory.create_attempt(1)
	assert_true(first_result["success"], "factory must own copies of configured inputs")
	var first: Variant = first_result["session"]
	assert_equal(first.map_identity(), "FP_CORE_PROOF_01@2", "caller definition mutation must not alter factory map identity")
	assert_equal(first.definition_snapshot().to_dictionary(), original_definition, "factory must preserve configured definition value")
	assert_equal(first.layout_snapshot().layout_signature(), original_signature, "caller layout mutation must not alter factory solution")

	var leaked_layout: Variant = first.layout_snapshot()
	leaked_layout.clear()
	var leaked_definition: Variant = first.definition_snapshot()
	leaked_definition.map_revision = 77
	assert_equal(first.layout_snapshot().layout_signature(), original_signature, "session layout snapshots must be independent copies")
	assert_equal(first.definition_snapshot().map_revision, 2, "session definition snapshots must be independent copies")

	var retry_result: Dictionary = factory.retry(first)
	assert_true(retry_result["success"], "valid session must retry")
	var retry: Variant = retry_result["session"]
	assert_equal(retry.map_identity(), first.map_identity(), "retry must preserve map identity")
	assert_equal(retry.solution_identity(), first.solution_identity(), "retry must preserve solution identity")
	assert_not_equal(retry.attempt_identity(), first.attempt_identity(), "retry must change attempt identity")
	assert_equal(retry.attempt_serial(), first.attempt_serial() + 1, "retry must increment attempt serial")

	var explicit_result: Dictionary = factory.create_attempt(10)
	assert_true(explicit_result["success"], "factory must accept an explicit future attempt serial")
	var explicit: Variant = explicit_result["session"]
	assert_equal(explicit.solution_identity(), first.solution_identity(), "explicit attempt must preserve solution identity")
	assert_equal(explicit.attempt_serial(), 10, "explicit attempt serial must be retained")
	assert_not_equal(explicit.attempt_identity(), retry.attempt_identity(), "different serials must produce different attempt identities")

	var duplicate_serial: Dictionary = factory.create_attempt(10)
	assert_false(duplicate_serial["success"], "attempt serial reuse must be rejected")
	assert_equal(duplicate_serial["error_code"], &"ATTEMPT_SERIAL_REUSED", "duplicate attempt rejection must be stable")
	var stale_serial: Dictionary = factory.create_attempt(2)
	assert_false(stale_serial["success"], "stale attempt serial must be rejected")
	assert_equal(stale_serial["error_code"], &"ATTEMPT_SERIAL_REUSED", "stale attempt rejection must be stable")

	var automatic_result: Dictionary = factory.create_attempt()
	assert_true(automatic_result["success"], "automatic attempt serial must remain available")
	var automatic: Variant = automatic_result["session"]
	assert_equal(automatic.attempt_serial(), 11, "automatic attempt serial must continue after the highest issued serial")
	assert_not_equal(automatic.attempt_identity(), explicit.attempt_identity(), "automatic attempt must have a unique identity")

	var late_retry_result: Dictionary = factory.retry(first)
	assert_true(late_retry_result["success"], "an older valid result must still retry with the next unused serial")
	var late_retry: Variant = late_retry_result["session"]
	assert_equal(late_retry.attempt_serial(), 12, "late retry must allocate the next unused serial")
	assert_equal(late_retry.solution_identity(), first.solution_identity(), "late retry must preserve solution identity")
	assert_not_equal(late_retry.attempt_identity(), automatic.attempt_identity(), "late retry must remain globally unique within the factory")

	var invalid_serial: Dictionary = factory.create_attempt(0)
	assert_false(invalid_serial["success"], "zero attempt serial must be rejected")
	assert_equal(invalid_serial["error_code"], &"INVALID_ATTEMPT_SERIAL", "invalid serial rejection must be stable")
	var invalid_retry: Dictionary = factory.retry(null)
	assert_false(invalid_retry["success"], "null previous session must be rejected")
	assert_equal(invalid_retry["error_code"], &"INVALID_PREVIOUS_SESSION", "invalid retry rejection must be stable")
