extends "res://tests/test_case.gd"

const FACTORY_PATH := "res://game/finite/run/finite_run_session_factory.gd"
const FIXTURE_PATH := "res://tests/fixtures/finite/finite_retry_fixture.gd"


func run() -> void:
	var fixture_script: Script = load(FIXTURE_PATH)
	var inputs: Dictionary = fixture_script.sealed_inputs()
	assert_false(inputs.is_empty(), "adversarial fixture must produce sealed inputs")
	if inputs.is_empty():
		return

	var factory_script: Script = load(FACTORY_PATH)
	var factory: Variant = factory_script.new()
	assert_true(factory.configure(inputs["definition"], inputs["sealed"], 2.0), "adversarial factory must configure")
	var result: Dictionary = factory.create_attempt(1)
	assert_true(result["success"], "adversarial attempt must be created")
	if not result["success"]:
		return
	var session: Variant = result["session"]

	var crossing := Vector2i(7, 4)
	assert_equal(session.graph.next_cell(crossing, Vector2i(6, 4)), Vector2i(8, 4), "crossing west entry must stay horizontal")
	assert_equal(session.graph.next_cell(crossing, Vector2i(7, 3)), Vector2i(7, 5), "crossing north entry must stay vertical")
	assert_not_equal(session.graph.next_cell(crossing, Vector2i(6, 4)), Vector2i(7, 3), "crossing must not leak between lanes")

	var switch_cell := Vector2i(3, 4)
	var switch_approach := Vector2i(2, 4)
	var authored_exit: Vector2i = session.graph.next_cell(switch_cell, switch_approach)
	assert_true(session.graph.cycle_switch(switch_cell), "unoccupied switch must permit preconfiguration")
	assert_equal(session.graph.next_cell(switch_cell, switch_approach), switch_approach, "first cycle must expose incoming-port U-turn")
	assert_true(session.graph.cycle_switch(switch_cell), "second cycle must expose alternate branch")
	assert_not_equal(session.graph.next_cell(switch_cell, switch_approach), authored_exit, "second cycle must differ from authored branch")
	assert_true(session.graph.cycle_switch(switch_cell), "third cycle must complete the three-state loop")
	assert_equal(session.graph.next_cell(switch_cell, switch_approach), authored_exit, "third cycle must restore authored exit")

	assert_equal(session.train.current_cell(), Vector2i(1, 4), "train must begin at start")
	assert_equal(session.train.advance_one_cell(), Vector2i(2, 4), "train must enter the cell before the switch")
	assert_equal(session.train.advance_one_cell(), switch_cell, "train must enter the switch cell")
	assert_false(session.graph.cycle_switch(switch_cell), "switch must lock while the train occupies it")
	assert_false(session.graph.select_switch_exit(switch_cell, Vector2i.UP), "occupied switch must reject direct selection")
	var occupied_target: Vector2i = session.train.target_cell()
	assert_equal(session.train.advance_one_cell(), occupied_target, "train must leave using the locked switch target")
	assert_true(session.graph.cycle_switch(switch_cell), "switch must unlock after the train leaves")

	var retry_result: Dictionary = factory.retry(session)
	assert_true(retry_result["success"], "adversarial runtime mutation must still allow same-layout retry")
	var retry: Variant = retry_result["session"]
	assert_equal(retry.graph.next_cell(switch_cell, switch_approach), authored_exit, "retry must restore authored switch state")
	assert_equal(retry.train.current_cell(), inputs["definition"].start_cell, "retry must restore train start")
	assert_equal(retry.cargo_stack.size(), 0, "retry must restore empty stack")
	assert_equal(retry.run_controller.run_state().phase(), &"READY", "retry must restore READY lifecycle")
