extends "res://tests/test_case.gd"

const FACTORY_PATH := "res://game/finite/run/finite_run_session_factory.gd"
const SESSION_PATH := "res://game/finite/run/finite_run_session.gd"
const FIXTURE_PATH := "res://tests/fixtures/finite/finite_retry_fixture.gd"
const A: StringName = &"RED_STAR"


func run() -> void:
	var factory_exists := ResourceLoader.exists(FACTORY_PATH, "Script")
	var session_exists := ResourceLoader.exists(SESSION_PATH, "Script")
	assert_true(factory_exists, "finite run session factory must exist")
	assert_true(session_exists, "finite run session must exist")
	if not factory_exists or not session_exists:
		return

	var fixture_script: Script = load(FIXTURE_PATH)
	var inputs: Dictionary = fixture_script.sealed_inputs()
	assert_false(inputs.is_empty(), "retry fixture must produce sealed inputs")
	if inputs.is_empty():
		return

	var definition: Variant = inputs["definition"]
	var sealed: Dictionary = inputs["sealed"]
	var canonical_definition: Dictionary = definition.to_dictionary()
	var canonical_signature: String = sealed["layout_signature"]
	var factory_script: Script = load(FACTORY_PATH)
	var factory: Variant = factory_script.new()
	assert_true(factory.configure(definition, sealed, 0.0), "factory must accept valid sealed finite inputs")

	var first_result: Dictionary = factory.create_attempt(1)
	assert_true(first_result["success"], "first finite attempt must be created")
	var first: Variant = first_result["session"]
	assert_true(first.is_fully_configured(), "first finite session must be fully configured")
	assert_equal(first.layout_snapshot().layout_signature(), canonical_signature, "first attempt must use sealed layout")

	var switch_cell := Vector2i(3, 4)
	var switch_approach := Vector2i(2, 4)
	assert_equal(first.graph.next_cell(switch_cell, switch_approach), Vector2i(4, 4), "first attempt must begin with authored switch exit")
	assert_true(first.graph.cycle_switch(switch_cell), "first attempt switch must be mutable at runtime")
	assert_equal(first.graph.next_cell(switch_cell, switch_approach), Vector2i(3, 3), "first attempt switch mutation must take effect")

	var collected: StringName = first.cargo_field.collect(Vector2i(9, 4))
	assert_equal(collected, A, "first attempt must expose authored cargo")
	assert_true(first.cargo_stack.push(collected), "first attempt stack must accept collected cargo")
	assert_true(first.input_state.toggle_auto_load(), "first attempt input must be mutable")
	assert_equal(first.train.advance_one_cell(), Vector2i(2, 4), "first attempt train must be mutable")
	assert_true(first.run_controller.start(), "first attempt controller must start")
	first.run_controller.advance_time(90.0)
	assert_equal(first.run_controller.summary().outcome, &"FAILURE", "unfinished first attempt must fail at the limit")

	var retry_result: Dictionary = factory.retry(first)
	assert_true(retry_result["success"], "failed finite attempt must retry")
	var retry: Variant = retry_result["session"]
	assert_true(retry.is_fully_configured(), "retry finite session must be fully configured")

	assert_equal(retry.definition_snapshot().to_dictionary(), canonical_definition, "retry must preserve exact map definition value")
	assert_equal(retry.layout_snapshot().layout_signature(), canonical_signature, "retry must preserve exact final layout")
	assert_equal(retry.solution_identity(), first.solution_identity(), "retry must preserve solution identity")
	assert_not_equal(retry.attempt_identity(), first.attempt_identity(), "retry must create a new attempt identity")
	assert_equal(retry.attempt_serial(), 2, "retry must increment attempt serial")

	assert_true(retry.graph != first.graph, "retry must build a fresh graph")
	assert_true(retry.train != first.train, "retry must build a fresh train")
	assert_true(retry.cargo_field != first.cargo_field, "retry must build a fresh cargo field")
	assert_true(retry.cargo_stack != first.cargo_stack, "retry must build a fresh cargo stack")
	assert_true(retry.input_state != first.input_state, "retry must build a fresh input state")
	assert_true(retry.delivery_loop != first.delivery_loop, "retry must build a fresh delivery loop")
	assert_true(retry.run_controller != first.run_controller, "retry must build a fresh run controller")

	assert_equal(retry.train.current_cell(), definition.start_cell, "retry train must reset to start")
	assert_equal(retry.train.previous_cell(), definition.incoming_cell, "retry train must restore incoming cell")
	assert_almost_equal(retry.train.movement_progress(), 0.0, 0.000001, "retry train progress must reset")
	assert_equal(retry.cargo_field.remaining_count(), definition.cargo_placements.size(), "retry must restore every fixed cargo")
	assert_equal(retry.cargo_stack.size(), 0, "retry stack must be empty")
	assert_false(retry.input_state.is_manual_load_active(), "retry manual load must default inactive")
	assert_false(retry.input_state.is_auto_load_enabled(), "retry auto load must default off")
	assert_false(retry.input_state.is_paused(), "retry input must begin unpaused")
	assert_equal(retry.graph.next_cell(switch_cell, switch_approach), Vector2i(4, 4), "retry switch must restore authored initial exit")
	assert_equal(retry.run_controller.run_state().phase(), &"READY", "retry finite run must begin READY")
	assert_almost_equal(retry.run_controller.run_state().elapsed_seconds(), 0.0, 0.000001, "retry finite clock must reset")
