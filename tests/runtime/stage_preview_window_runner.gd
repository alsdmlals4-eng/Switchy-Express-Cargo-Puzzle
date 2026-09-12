extends SceneTree

const Main := preload("res://game/main/main.tscn")
const QA := preload("res://tests/runtime/stage_preview_live_qa.gd")


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var source_revision := ""
	for argument: String in OS.get_cmdline_user_args():
		if argument.begins_with("--source-revision="):
			source_revision = argument.trim_prefix("--source-revision=")
	var main: Control = Main.instantiate()
	root.add_child(main)
	current_scene = main
	await process_frame
	var receipt: Dictionary = await QA.run(self, source_revision)
	print("STAGE PREVIEW WINDOW QA: " + JSON.stringify(receipt))
	quit(0 if receipt.get("status") == "PASS" else 1)
