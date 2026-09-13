extends SceneTree

const AudioDirector := preload("res://game/demo/audio/demo_audio_director.gd")


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var failures: Array[String] = []
	var retained: Array[AudioStreamPlayback] = []
	var weak_sources: Array[WeakRef] = []
	for kind: String in ["cue", "train"]:
		var record := _retire_director(kind)
		retained.append(record.playback)
		weak_sources.append(record.source)
		record.clear()
		if not _source_alive(weak_sources.back()):
			failures.append(kind + " generator destroyed while playback still owns a pending mix")
	# A resource must not be held forever once the mixer and test release playback.
	retained.clear()
	for frame: int in range(120):
		await process_frame
		if weak_sources.all(func(source: WeakRef) -> bool: return not _source_alive(source)): break
	for source: WeakRef in weak_sources:
		if _source_alive(source): failures.append("generator retained after playback release")
	var hashes: Dictionary = {}
	for path: String in ["res://game/demo/audio/demo_audio_director.gd", "res://tests/runtime/audio_generator_lifetime_runner.gd"]:
		hashes[path] = FileAccess.get_file_as_string(path).replace("\r\n", "\n").sha256_text()
	var output := FileAccess.open("user://generator-lifetime-proof.json", FileAccess.WRITE)
	if output == null:
		printerr("GENERATOR_LIFETIME: FAIL receipt unavailable")
		quit(2)
		return
	output.store_string(JSON.stringify({"status": "PASS" if failures.is_empty() else "FAIL",
		"sources": 2, "failures": failures, "source_sha256_lf": hashes,
		"engine": Engine.get_version_info().string,
		"scope": "generator survives director destruction while playback is held, then is released",
		"human_audio_review": "NOT_RUN"}, "\t"))
	output.close()
	for failure: String in failures: printerr("GENERATOR_LIFETIME_FAILURE: " + failure)
	print("GENERATOR_LIFETIME: %s sources=2" % ["PASS" if failures.is_empty() else "FAIL"])
	quit(0 if failures.is_empty() else 1)


func _retire_director(kind: String) -> Dictionary:
	# Returning clears GDScript expression temporaries which could retain player.stream.
	var audio: Node = AudioDirector.new()
	root.add_child(audio)
	if kind == "cue": audio.play_cue(&"pickup")
	else: audio.set_train_loop_active(true)
	var player: AudioStreamPlayer = audio.get_node("OneShotPlayer" if kind == "cue" else "TrainLoopPlayer")
	var record := {"playback": player.get_stream_playback(), "source": weakref(player.stream)}
	audio.stop_all()
	audio.free()
	return record


func _source_alive(source: WeakRef) -> bool:
	return source.get_ref() != null
