extends SceneTree

const AudioCase := preload("res://tests/demo/test_demo_audio_director.gd")
const AudioDirector := preload("res://game/demo/audio/demo_audio_director.gd")
const FlowCase := preload("res://tests/demo/test_first_session_flow_controller.gd")
const MainScene := preload("res://game/main/main.tscn")
const T12 := preload("res://tests/fixtures/first_session/tut_01_02_solution.gd")
const BUS := &"SwitchyCueProof"


func _initialize() -> void:
	call_deferred("_run_proof")


func _run_proof() -> void:
	var flow_test: RefCounted = FlowCase.new()
	flow_test.run()
	if not flow_test.passed():
		for failure: String in flow_test.failures:
			printerr("TUTORIAL_AUDIO_PROOF: FAIL %s" % failure)
		quit(1)
		return
	await process_frame
	var test: RefCounted = AudioCase.new()
	test.run()
	if not test.passed():
		for failure: String in test.failures:
			printerr("AUDIO_CUE_PROOF: FAIL %s" % failure)
		quit(1)
		return
	await process_frame
	if AudioServer.get_bus_index(BUS) != -1:
		printerr("AUDIO_CUE_PROOF: FAIL owned test bus already exists")
		quit(2)
		return
	AudioServer.add_bus()
	var bus_index := AudioServer.bus_count - 1
	AudioServer.set_bus_name(bus_index, BUS)
	var capture := AudioEffectCapture.new()
	capture.buffer_length = 1.0
	AudioServer.add_bus_effect(bus_index, capture)
	# Capture generated output only; no microphone or user sound is recorded.
	AudioServer.set_bus_mute(bus_index, true)
	var audio: Node = AudioDirector.new()
	root.add_child(audio)
	audio.get_node("OneShotPlayer").bus = BUS
	var samples: Array[Dictionary] = []
	for cue: StringName in AudioCase.CUES:
		capture.clear_buffer()
		audio.play_cue(cue)
		await create_timer(0.55).timeout
		await process_frame
		var frames := capture.get_buffer(capture.get_frames_available())
		var peak := 0.0
		for frame: Vector2 in frames:
			peak = maxf(peak, maxf(absf(frame.x), absf(frame.y)))
		var playing: bool = audio.get_node("OneShotPlayer").playing
		test.assert_true(peak > 0.0001, "%s has nonzero generated output" % cue)
		test.assert_false(playing, "%s stops after source buffer drains" % cue)
		samples.append({"cue": str(cue), "frames": frames.size(), "peak": peak, "still_playing": playing})
		print("AUDIO_CUE_SAMPLE: %s frames=%d peak=%f playing=%s" % [cue, frames.size(), peak, playing])
	audio.queue_free()
	await process_frame
	var tutorial_sample: Dictionary = await _capture_tutorial_transition(test, capture)
	AudioServer.remove_bus(AudioServer.get_bus_index(BUS))
	var output := FileAccess.open("user://audio-cue-capture-proof.json", FileAccess.WRITE)
	if output == null:
		printerr("AUDIO_CUE_PROOF: FAIL could not save numerical receipt")
		quit(2)
		return
	var hashes: Dictionary = {}
	for path: String in ["res://game/demo/audio/demo_audio_director.gd",
		"res://tests/demo/test_demo_audio_director.gd", "res://tests/runtime/audio_cue_capture_runner.gd",
		"res://game/demo/demo_flow_controller.gd", "res://game/demo/product_finite_slice.gd",
		"res://tests/demo/test_first_session_flow_controller.gd"]:
		hashes[path] = FileAccess.get_file_as_string(path).replace("\r\n", "\n").sha256_text()
	output.store_string(JSON.stringify({"samples": samples, "failures": test.failures,
		"human_audio_review": "NOT_RUN", "assertions": test.assertion_count,
		"engine": Engine.get_version_info().string, "source_sha256_lf": hashes,
		"tutorial_transition": tutorial_sample, "flow_assertions": flow_test.assertion_count}, "\t"))
	output.close()
	for failure: String in test.failures:
		printerr("AUDIO_CUE_PROOF: FAIL %s" % failure)
	print("AUDIO_CUE_PROOF: %s cues=%d assertions=%d" % ["PASS" if test.passed() else "FAIL", samples.size(), test.assertion_count])
	print("TUTORIAL_AUDIO_PROOF: %s" % ("PASS" if test.passed() else "FAIL"))
	quit(0 if test.passed() else 1)


func _capture_tutorial_transition(test: RefCounted, capture: AudioEffectCapture) -> Dictionary:
	var main: Control = MainScene.instantiate()
	root.add_child(main)
	var flow := main.get_node("VerticalSliceDemo")
	flow.start_demo()
	flow.begin_build()
	var product: Control = flow.gameplay_instance()
	test.assert_true(product.install_layout_for_test(T12.pieces()), "capture installs real T2 witness")
	flow.begin_build()
	product.request_command_for_test(&"START")
	product.request_command_for_test(&"LOAD_ACTIVE", true)
	for _step: int in range(1000):
		if flow.gameplay_instance() != product:
			break
		product.advance_time(1.0 / 30.0)
	test.assert_equal(flow.current_lesson_id_for_test(), &"T3", "capture enters actual T3 briefing")
	var audio := flow.get_node_or_null("TransitionAudio")
	test.assert_not_null(audio, "capture finds persistent transition audio")
	if audio == null:
		main.queue_free()
		await process_frame
		return {"error": "transition_audio_missing"}
	audio.get_node("OneShotPlayer").bus = BUS
	capture.clear_buffer()
	await process_frame
	await process_frame
	var old_product_freed := not is_instance_valid(product)
	test.assert_true(old_product_freed, "old product is freed before transition output readback")
	test.assert_true(audio.get_node("OneShotPlayer").playing, "shell cue is active after old product is freed")
	# Discard all pre-destruction samples: only the surviving owner's tail is proof.
	capture.clear_buffer()
	await create_timer(0.55).timeout
	var frames := capture.get_buffer(capture.get_frames_available())
	var peak := 0.0
	for frame: Vector2 in frames:
		peak = maxf(peak, maxf(absf(frame.x), absf(frame.y)))
	var playing: bool = audio.get_node("OneShotPlayer").playing
	test.assert_true(peak > 0.0001, "tutorial success emits nonzero shell output")
	test.assert_false(playing, "tutorial success stops after source drain")
	var result := {"peak": peak, "frames": frames.size(), "playing": playing,
		"old_product_freed": old_product_freed, "lesson": str(flow.current_lesson_id_for_test())}
	print("TUTORIAL_AUDIO_SAMPLE: %s" % JSON.stringify(result))
	main.queue_free()
	await process_frame
	return result
