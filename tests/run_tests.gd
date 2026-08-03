extends SceneTree

const DIAGNOSTIC_PATHS: Array[String] = [
	"res://game/map/map_definition.gd",
	"res://game/map/map_build_result.gd",
	"res://game/map/map_build_pipeline.gd",
	"res://game/map/map_catalog.gd",
	"res://tests/map/test_map_definition.gd",
	"res://tests/map/test_map_build_pipeline.gd",
	"res://tests/map/test_map_catalog.gd",
]


func _initialize() -> void:
	call_deferred("_run_diagnostic")


func _run_diagnostic() -> void:
	var failed := false
	for path: String in DIAGNOSTIC_PATHS:
		print("DIAGNOSTIC LOAD: %s" % path)
		var script: Variant = load(path)
		if script == null:
			failed = true
			printerr("DIAGNOSTIC FAILED: %s" % path)
		else:
			print("DIAGNOSTIC PASS: %s" % path)
	quit(1 if failed else 0)
