extends GutTest

const ControllerScript := preload("res://game/finite/run/finite_run_controller.gd")
const EventScript := preload("res://game/finite/delivery/finite_delivery_event.gd")
const InputScript := preload("res://game/finite/input/finite_gameplay_input_state.gd")
const CARGO: StringName = &"RED_STAR"


class FakeTrain:
	extends RefCounted

	signal cell_entered(cell: Vector2i)

	var speed: float = 0.0

	func set_speed(value: float) -> void:
		speed = value

	func advance_time(_delta_seconds: float) -> int:
		return 0

	func seconds_to_next_cell() -> float:
		return INF


class FakeDeliveryLoop:
	extends RefCounted

	func handle_cell_entered(_cell: Vector2i, _event_time: float) -> Variant:
		return null


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


func _configured_controller() -> Variant:
	var controller: Variant = ControllerScript.new()
	controller.configure(FakeTrain.new(), FakeDeliveryLoop.new(), InputScript.new(), 90.0, 2.0)
	return controller
