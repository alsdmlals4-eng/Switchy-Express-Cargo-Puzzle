extends SceneTree

const AudioCase := preload("res://tests/demo/test_demo_audio_director.gd")
const AudioDirector := preload("res://game/demo/audio/demo_audio_director.gd")
const BUS := &"SwitchyCueProof"


func _initialize() -> void:
	call_deferred("_run_proof")


func _run_proof() -> void:
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
	AudioServer.remove_bus(AudioServer.get_bus_index(BUS))
	var output := FileAccess.open("user://audio-cue-capture-proof.json", FileAccess.WRITE)
	if output == null:
		printerr("AUDIO_CUE_PROOF: FAIL could not save numerical receipt")
		quit(2)
		return
	var hashes: Dictionary = {}
	for path: String in ["res://game/demo/audio/demo_audio_director.gd",
		"res://tests/demo/test_demo_audio_director.gd", "res://tests/runtime/audio_cue_capture_runner.gd"]:
		hashes[path] = FileAccess.get_file_as_string(path).replace("\r\n", "\n").sha256_text()
	output.store_string(JSON.stringify({"samples": samples, "failures": test.failures,
		"human_audio_review": "NOT_RUN", "assertions": test.assertion_count,
		"engine": Engine.get_version_info().string, "source_sha256_lf": hashes}, "\t"))
	output.close()
	for failure: String in test.failures:
		printerr("AUDIO_CUE_PROOF: FAIL %s" % failure)
	print("AUDIO_CUE_PROOF: %s cues=%d assertions=%d" % ["PASS" if test.passed() else "FAIL", samples.size(), test.assertion_count])
	quit(0 if test.passed() else 1)
