extends "res://tests/test_case.gd"

const ProductScene := preload("res://game/demo/product_finite_slice.tscn")
const AudioScript := preload("res://game/demo/audio/demo_audio_director.gd")

const CUES: Array[StringName] = [
	&"button",
	&"build",
	&"remove",
	&"switch",
	&"pickup",
	&"unload",
	&"success",
	&"failure",
]


func run() -> void:
	var tree := Engine.get_main_loop() as SceneTree
	assert_not_null(tree, "audio authority test requires SceneTree")
	if tree == null:
		return

	var product: Control = ProductScene.instantiate()
	tree.root.add_child(product)
	var audio: Node = AudioScript.new()
	product.add_child(audio)

	for method_name: StringName in [
		&"play_cue",
		&"set_train_loop_active",
		&"set_paused",
		&"stop_all",
	]:
		assert_true(audio.has_method(method_name), "audio director must expose %s" % method_name)

	var controller: RefCounted = product.session_controller()
	var model_before: Dictionary = controller.model()
	var snapshot_before: Dictionary = controller.render_snapshot()
	var layout_before: String = controller.current_layout_signature()
	var summary_before: Variant = controller.current_summary()

	for cue: StringName in CUES:
		var stream: Variant = audio.stream_for_cue_for_test(cue)
		assert_true(stream is AudioStreamGenerator, "%s cue must be generated in engine" % cue)
		audio.play_cue(cue)
		assert_equal(audio.last_cue_for_test(), cue, "audio director records the requested cue")

	audio.set_train_loop_active(true)
	assert_true(audio.train_loop_active_for_test(), "train loop becomes active")
	audio.set_paused(true)
	assert_true(audio.paused_for_test(), "audio director records paused mix state")
	audio.set_paused(false)
	assert_false(audio.paused_for_test(), "audio director restores active mix state")

	assert_equal(controller.model(), model_before, "audio cannot mutate presenter/domain model")
	assert_equal(controller.render_snapshot(), snapshot_before, "audio cannot mutate render authority")
	assert_equal(controller.current_layout_signature(), layout_before, "audio cannot mutate layout identity")
	assert_equal(controller.current_summary(), summary_before, "audio cannot create a result")

	audio.stop_all()
	assert_false(audio.train_loop_active_for_test(), "stop_all stops train loop")
	assert_equal(audio.last_cue_for_test(), &"", "stop_all clears one-shot cue state")
	assert_equal(controller.model(), model_before, "stopping audio cannot mutate domain state")

	product.free()
