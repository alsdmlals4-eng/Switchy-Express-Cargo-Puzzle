extends "res://tests/test_case.gd"

const PRODUCT_SCENE := preload("res://game/demo/product_finite_slice.tscn")
const ALPHA_FIXTURE := preload("res://tests/fixtures/finite/vs_demo_solution_alpha.gd")


class FakeSummary:
	extends RefCounted

	var outcome: StringName
	var failure_reason: StringName

	func _init(result: StringName, reason: StringName = &"") -> void:
		outcome = result
		failure_reason = reason


func run() -> void:
	var tree := Engine.get_main_loop() as SceneTree
	assert_not_null(tree, "runtime semantic POC test requires SceneTree")
	if tree == null:
		return
	var product: Control = PRODUCT_SCENE.instantiate()
	tree.root.add_child(product)

	var semantic: Control = product.get_node_or_null("SemanticEventOverlay")
	assert_not_null(semantic, "product slice must own exactly one SemanticEventOverlay")
	var semantic_count := 0
	for child: Node in product.get_children():
		if child.name == &"SemanticEventOverlay":
			semantic_count += 1
	assert_equal(semantic_count, 1, "product slice must not duplicate semantic event overlay authority")
	assert_not_null(product.get_node_or_null("DemoEffects"), "existing DemoEffects must remain present")
	assert_not_null(product.get_node_or_null("DemoAudioDirector"), "existing audio director must remain present")
	if semantic == null:
		product.free()
		return

	assert_true(semantic.has_method("event_history_for_test"), "semantic overlay must expose bounded event history diagnostics")
	assert_true(product.has_method("set_reduced_motion"), "product slice must expose reduced-motion presentation control")
	if not semantic.has_method("event_history_for_test") or not product.has_method("set_reduced_motion"):
		product.free()
		return

	var controller: RefCounted = product.session_controller()
	var model_before: Dictionary = controller.model()
	var snapshot_before: Dictionary = controller.render_snapshot()
	var layout_before: String = controller.current_layout_signature()
	product.set_reduced_motion(true)
	assert_true(semantic.play_event(&"route_selection"), "direct semantic overlay playback must resolve in integration")
	assert_false(semantic.motion_active_for_test(), "reduced-motion integration path disables spatial/scale motion")
	assert_equal(controller.model(), model_before, "direct semantic playback cannot mutate presenter/domain model")
	assert_equal(controller.render_snapshot(), snapshot_before, "direct semantic playback cannot mutate render authority")
	assert_equal(controller.current_layout_signature(), layout_before, "direct semantic playback cannot mutate layout identity")
	semantic.cancel_all()
	product.set_reduced_motion(false)
	semantic.clear_event_history_for_test()

	assert_true(product.install_layout_for_test(ALPHA_FIXTURE.pieces()), "alpha route installs for runtime semantic proof")
	assert_true(bool(controller.model().get("start_enabled", false)), "alpha route passes preflight")
	product.request_command_for_test(&"START")
	assert_equal(controller.phase(), &"RUNNING", "runtime semantic proof enters RUNNING")

	var route_controls_before: Array = controller.render_snapshot().get("route_controls", []).duplicate(true)
	var switch_state := _first_switch_state(route_controls_before)
	assert_false(switch_state.is_empty(), "runtime semantic proof requires an authored switch control")
	if not switch_state.is_empty():
		var switch_cell: Vector2i = switch_state.get("cell", Vector2i(-1, -1))
		var cycle_count := (switch_state.get("available_exits", []) as Array).size()
		assert_true(cycle_count > 1, "switch proof must expose more than one exit")
		for _cycle: int in range(cycle_count):
			product.request_command_for_test(&"BOARD_CELL", switch_cell)
		assert_equal(
			controller.render_snapshot().get("route_controls", []),
			route_controls_before,
			"full switch cycle restores exact route-control state after accepted selections"
		)

	product.request_command_for_test(&"AUTO_TOGGLE")
	assert_true(_advance_until_terminal(product), "alpha semantic run reaches terminal")
	assert_equal(controller.phase(), &"SUCCESS", "semantic wiring must not change canonical alpha success")

	var history: Array[StringName] = semantic.event_history_for_test()
	assert_true(history.has(&"route_selection"), "accepted route selection emits semantic feedback")
	assert_true(history.has(&"cargo_pickup"), "authoritative pickup event emits semantic feedback")
	assert_true(history.has(&"cargo_unload"), "authoritative unload event emits semantic feedback")
	assert_true(history.has(&"success"), "success terminal emits semantic feedback")
	assert_false(history.has(&"combo"), "runtime must not fabricate a combo trigger")

	var terminal_model: Dictionary = controller.model()
	var terminal_snapshot: Dictionary = controller.render_snapshot()
	var terminal_layout: String = controller.current_layout_signature()
	product._on_terminal_reached(FakeSummary.new(&"FAILURE", &"ROUTE_END"))
	assert_equal(semantic.current_event_for_test(), &"route_end", "route-end failure maps to route_end semantic event")
	product._on_terminal_reached(FakeSummary.new(&"FAILURE", &"TIME_EXPIRED"))
	assert_equal(semantic.current_event_for_test(), &"time_expired", "timeout failure maps to time_expired semantic event")
	product._on_terminal_reached(FakeSummary.new(&"FAILURE", &"OTHER"))
	assert_equal(semantic.current_event_for_test(), &"failure", "other failure maps to generic failure semantic event")
	assert_equal(controller.model(), terminal_model, "terminal presentation callbacks cannot mutate domain model")
	assert_equal(controller.render_snapshot(), terminal_snapshot, "terminal presentation callbacks cannot mutate render snapshot")
	assert_equal(controller.current_layout_signature(), terminal_layout, "terminal presentation callbacks cannot mutate layout identity")

	product.free()


func _advance_until_terminal(product: Control) -> bool:
	for _step: int in range(4800):
		var phase: StringName = product.session_controller().phase()
		if phase == &"SUCCESS" or phase == &"FAILURE":
			return true
		product.advance_time(0.05)
	return false


static func _first_switch_state(states: Array) -> Dictionary:
	for value: Variant in states:
		if value is Dictionary and StringName(value.get("kind", &"")) == &"SWITCH":
			return value.duplicate(true)
	return {}
