extends "res://tests/test_case.gd"

const ProductScene := preload("res://game/demo/product_finite_slice.tscn")
const EffectsScript := preload("res://game/demo/presentation/demo_effects.gd")


func run() -> void:
	var tree := Engine.get_main_loop() as SceneTree
	assert_not_null(tree, "effects authority test requires SceneTree")
	if tree == null:
		return

	var product: Control = ProductScene.instantiate()
	tree.root.add_child(product)
	var effects: Node = EffectsScript.new()
	product.add_child(effects)

	for method_name: StringName in [
		&"play_build",
		&"play_remove",
		&"play_unload",
		&"play_success",
		&"play_failure",
		&"cancel_all",
	]:
		assert_true(effects.has_method(method_name), "effects must expose %s" % method_name)

	var controller: RefCounted = product.session_controller()
	var model_before: Dictionary = controller.model()
	var snapshot_before: Dictionary = controller.render_snapshot()
	var layout_before: String = controller.current_layout_signature()
	var summary_before: Variant = controller.current_summary()

	effects.play_build(Vector2i(2, 4))
	effects.play_remove(Vector2i(3, 4))
	effects.play_unload(4)
	effects.play_success()
	effects.play_failure()

	assert_true(
		float(effects.maximum_effect_duration_for_test()) <= 1.0,
		"all demo effects must remain bounded to one second"
	)
	assert_true(
		int(effects.active_effect_count_for_test()) > 0,
		"effect requests must create presentation activity"
	)

	assert_equal(controller.model(), model_before, "effects cannot mutate presenter/domain model")
	assert_equal(controller.render_snapshot(), snapshot_before, "effects cannot mutate render authority")
	assert_equal(controller.current_layout_signature(), layout_before, "effects cannot mutate layout identity")
	assert_equal(controller.current_summary(), summary_before, "effects cannot create a result")

	effects.cancel_all()
	assert_equal(effects.active_effect_count_for_test(), 0, "cancel_all releases all active effects")
	assert_equal(controller.model(), model_before, "effect cancellation cannot mutate domain state")

	product.free()
