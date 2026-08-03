extends "res://tests/test_case.gd"

const MapBuildPipelineScript := preload("res://game/map/map_build_pipeline.gd")
const RunIdFactoryScript := preload("res://game/run/run_id_factory.gd")
const RunSessionFactoryScript := preload("res://game/run/run_session_factory.gd")
const Fixture := preload("res://tests/support/map_fixture.gd")


func run() -> void:
	var pipeline: Variant = MapBuildPipelineScript.new()
	var build: Variant = pipeline.build_from_manifest_entry(
		Fixture.manifest_entry(&"map.sx.0001", 1)
	)
	assert_true(build.success, "session fixture must build")
	if not build.success:
		return

	var id_factory: Variant = RunIdFactoryScript.new()
	id_factory.configure_sequence(["run-a", "run-b", "run-c"])
	var factory: Variant = RunSessionFactoryScript.new()
	factory.configure(pipeline, id_factory)

	var first_result: Dictionary = factory.create_for_definition(build.definition)
	assert_true(first_result.get("success", false), "factory must return a fully configured first session")
	var first: Variant = first_result.get("session")
	assert_not_null(first, "successful factory result must include session")
	if first == null:
		return
	assert_true(first.is_fully_configured(), "session must not report success with missing dependency")
	assert_equal(first.identity.run_id, "run-a", "factory must consume injected run identity")
	assert_true(first.run_controller.run_state().is_ready(), "fresh session run state must be ready")
	assert_equal(first.cargo_stack.size(), 0, "fresh session stack must be empty")
	assert_equal(first.compact_token_state.token_count(), 0, "fresh token state must match empty stack")
	assert_true(first.cargo_spawner.pickup_cells().size() >= 12, "fresh session must contain configured initial pickups")

	first.cargo_stack.push(&"RED")
	first.compact_token_state.sync_from_stack()
	first.input_state.set_boost_requested(true)
	first.run_controller.start()
	first.run_controller.advance_time(0.5)

	var retry_result: Dictionary = factory.restart(first)
	assert_true(retry_result.get("success", false), "same-map restart must rebuild a fresh session")
	var retry: Variant = retry_result.get("session")
	assert_not_null(retry, "successful restart must include session")
	if retry == null:
		return

	assert_equal(retry.identity.map_definition.identity_key(), first.identity.map_definition.identity_key(), "restart must preserve exact map id and revision")
	assert_equal(retry.identity.map_definition.content_signature, first.identity.map_definition.content_signature, "restart must preserve exact reconstruction signature")
	assert_equal(retry.identity.run_id, "run-b", "restart must create next run identity")
	assert_equal(retry.identity.retry_index, 1, "restart must increment retry index")
	assert_equal(retry.identity.restarted_from_run_id, "run-a", "restart lineage must reference previous run")
	assert_not_equal(retry.graph, first.graph, "restart must rebuild graph object")
	assert_not_equal(retry.train, first.train, "restart must rebuild train object")
	assert_not_equal(retry.cargo_stack, first.cargo_stack, "restart must rebuild stack object")
	assert_not_equal(retry.cargo_spawner, first.cargo_spawner, "restart must rebuild spawner object")
	assert_not_equal(retry.delivery_loop, first.delivery_loop, "restart must rebuild delivery loop object")
	assert_not_equal(retry.run_controller, first.run_controller, "restart must rebuild run controller object")
	assert_not_equal(retry.run_controller.difficulty_director(), first.run_controller.difficulty_director(), "restart must rebuild difficulty authority")
	assert_equal(retry.cargo_stack.size(), 0, "restart must not leak previous cargo")
	assert_false(retry.input_state.is_boosting(), "restart must not leak input state")
	assert_true(retry.run_controller.run_state().is_ready(), "restart run state must reset to ready")
	assert_equal(retry.generation, first.generation + 1, "restart must advance session generation")
	assert_false(retry.accepts_generation(first.generation), "new session must reject stale generation callbacks")
	assert_true(retry.accepts_generation(retry.generation), "new session must accept current generation callbacks")

	var tampered_data: Dictionary = build.definition.to_dictionary()
	tampered_data["content_signature"] = "tampered"
	var tampered: Variant = preload("res://game/map/map_definition.gd").create(tampered_data)
	var rejected: Dictionary = factory.create_for_definition(tampered)
	assert_false(rejected.get("success", true), "signature mismatch must fail without silent map substitution")
	assert_equal(rejected.get("session"), null, "failed reconstruction must not return partial session")
