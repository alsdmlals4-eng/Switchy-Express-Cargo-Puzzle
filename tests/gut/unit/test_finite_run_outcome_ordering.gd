extends GutTest

const ControllerScript := preload("res://game/finite/run/finite_run_controller.gd")
const EventScript := preload("res://game/finite/delivery/finite_delivery_event.gd")
const InputScript := preload("res://game/finite/input/finite_gameplay_input_state.gd")
const CARGO: StringName = &"RED_STAR"
const ROUTE_END: StringName = &"ROUTE_END"
const TIME_EXPIRED: StringName = &"TIME_EXPIRED"


class FakeTrain:
	extends RefCounted

	signal cell_entered(cell: Vector2i)

	var speed: float = 0.0
	var can_advance_value: bool = true

	func set_speed(value: float) -> void:
		speed = value

	func advance_time(_delta_seconds: float) -> int:
		return 0

	func seconds_to_next_cell() -> float:
		return INF

	func can_advance() -> bool:
		return can_advance_value

	func enter_cell(cell: Vector2i) -> void:
		cell_entered.emit(cell)


class FakeDeliveryLoop:
	extends RefCounted

	var next_event: Variant = null

	func handle_cell_entered(_cell: Vector2i, _event_time: float) -> Variant:
		var event: Variant = next_event
		next_event = null
		return event


func test_final_delivery_at_exact_limit_has_success_priority() -> void:
	var controller: Variant = _configured_controller()
	assert_true(controller.start(), "controller must start")
	var items: Array[StringName] = [CARGO]
	var event: Variant = EventScript.new(Vector2i(8, 1), 90.0, false, &"", items, true, 0, 0)
	assert_true(controller.accept_delivery_event(event), "final delivery must be accepted")
	assert_eq(controller.run_state().phase(), &"UNLOADING", "delivery presentation must finish first")
	assert_true(is_equal_approx(controller.final_delivery_commit_time(), 90.0))
	controller.advance_time(0.12)
	assert_eq(controller.run_state().phase(), &"SUCCESS", "exact-limit final delivery must win")
	assert_eq(controller.summary().outcome, &"SUCCESS")


func test_final_delivery_after_limit_resolves_failure() -> void:
	var controller: Variant = _configured_controller()
	assert_true(controller.start(), "controller must start")
	var items: Array[StringName] = [CARGO]
	var event: Variant = EventScript.new(Vector2i(8, 1), 90.001, false, &"", items, true, 0, 0)
	assert_true(controller.accept_delivery_event(event), "late final delivery event must be recorded")
	controller.advance_time(0.12)
	assert_eq(controller.run_state().phase(), &"FAILURE", "post-limit delivery must fail")
	assert_eq(controller.summary().outcome, &"FAILURE")


func test_dead_end_without_delivery_fails_route_end_after_cell_contact() -> void:
	var case: Dictionary = _configured_case()
	var controller: Variant = case["controller"]
	var train: FakeTrain = case["train"]
	assert_true(controller.start())
	train.can_advance_value = false
	train.enter_cell(Vector2i(9, 1))
	assert_eq(controller.run_state().phase(), &"FAILURE", "dead end must fail after contact handling")
	_assert_failure_reason(controller.summary(), ROUTE_END)


func test_non_final_unload_completes_before_route_end_failure() -> void:
	var case: Dictionary = _configured_case()
	var controller: Variant = case["controller"]
	var train: FakeTrain = case["train"]
	var delivery: FakeDeliveryLoop = case["delivery"]
	assert_true(controller.start())
	train.can_advance_value = false
	var items: Array[StringName] = [CARGO]
	delivery.next_event = EventScript.new(Vector2i(9, 1), 5.0, false, &"", items, true, 1, 0)
	train.enter_cell(Vector2i(9, 1))
	assert_eq(controller.run_state().phase(), &"UNLOADING", "non-final contact must enter unload first")
	assert_null(controller.summary(), "route-end summary must wait for unload completion")
	controller.advance_time(0.12)
	assert_eq(controller.run_state().phase(), &"FAILURE", "non-final unload at dead end must then fail")
	_assert_failure_reason(controller.summary(), ROUTE_END)


func test_final_delivery_at_dead_end_still_finishes_success() -> void:
	var case: Dictionary = _configured_case()
	var controller: Variant = case["controller"]
	var train: FakeTrain = case["train"]
	var delivery: FakeDeliveryLoop = case["delivery"]
	assert_true(controller.start())
	train.can_advance_value = false
	var items: Array[StringName] = [CARGO]
	delivery.next_event = EventScript.new(Vector2i(9, 1), 5.0, false, &"", items, true, 0, 0)
	train.enter_cell(Vector2i(9, 1))
	assert_eq(controller.run_state().phase(), &"UNLOADING")
	controller.advance_time(0.12)
	assert_eq(controller.run_state().phase(), &"SUCCESS", "final delivery must beat same-cell route end")
	var summary: Variant = controller.summary()
	assert_not_null(summary)
	if summary != null:
		assert_true(_has_property(summary, &"failure_reason"), "summary must expose failure reason")
		if _has_property(summary, &"failure_reason"):
			assert_eq(summary.failure_reason, &"", "success must not carry a failure reason")


func test_timeout_uses_time_expired_reason() -> void:
	var controller: Variant = _configured_controller()
	assert_true(controller.start())
	controller.advance_time(90.0)
	assert_eq(controller.run_state().phase(), &"FAILURE")
	_assert_failure_reason(controller.summary(), TIME_EXPIRED)


func _configured_controller() -> Variant:
	return _configured_case()["controller"]


func _configured_case() -> Dictionary:
	var train := FakeTrain.new()
	var delivery := FakeDeliveryLoop.new()
	var controller: Variant = ControllerScript.new()
	controller.configure(train, delivery, InputScript.new(), 90.0, 2.0)
	return {"controller": controller, "train": train, "delivery": delivery}


func _assert_failure_reason(summary: Variant, expected: StringName) -> void:
	assert_not_null(summary, "terminal outcome must freeze a summary")
	if summary == null:
		return
	assert_true(_has_property(summary, &"failure_reason"), "summary must expose failure_reason")
	if _has_property(summary, &"failure_reason"):
		assert_eq(summary.failure_reason, expected)


static func _has_property(value: Object, property_name: StringName) -> bool:
	for entry: Dictionary in value.get_property_list():
		if StringName(entry.get("name", &"")) == property_name:
			return true
	return false
