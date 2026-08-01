extends SceneTree

const TEST_SCRIPTS: Array[Script] = [
	preload("res://tests/smoke/test_project_boot.gd"),
	preload("res://tests/rail/test_rail_generator.gd"),
	preload("res://tests/rail/test_switch_routing.gd"),
]


func _initialize() -> void:
	call_deferred("_run_all")


func _run_all() -> void:
	var failed_cases: int = 0
	var assertion_total: int = 0

	for test_script: Script in TEST_SCRIPTS:
		var test_case: RefCounted = test_script.new()
		test_case.run()
		assertion_total += test_case.assertion_count
		if test_case.passed():
			print("PASS: %s (%d assertions)" % [test_script.resource_path, test_case.assertion_count])
		else:
			failed_cases += 1
			print("FAIL: %s" % test_script.resource_path)
			for failure: String in test_case.failures:
				print("  - %s" % failure)

	print("TEST SUMMARY: cases=%d failed=%d assertions=%d" % [TEST_SCRIPTS.size(), failed_cases, assertion_total])
	quit(1 if failed_cases > 0 else 0)
