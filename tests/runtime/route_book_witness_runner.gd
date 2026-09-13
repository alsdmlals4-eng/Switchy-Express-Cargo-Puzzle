extends SceneTree

const WitnessCase := preload("res://tests/route_book/test_route_book_machine_witnesses.gd")


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var test: RefCounted = WitnessCase.new()
	test.run()
	# A script error can return without populating TestCase.failures. Require output.
	test.assert_equal(test.witness_results.size(), 12, "all12 authored results completed")
	for index: int in range(test.witness_results.size()):
		var sample: Dictionary = test.witness_results[index]
		test.assert_equal(sample.get("stage"), "RB%02d" % (index + 1), "exact ordered stage identity")
		test.assert_equal(sample.get("phase"), "SUCCESS", "authored positive result completed")
		test.assert_equal(sample.get("base_speed"), 2.0, "receipt reports verified product speed")
	var source_hashes: Dictionary = {}
	var paths: Array = ["res://tests/route_book/test_route_book_machine_witnesses.gd",
		"res://tests/fixtures/route_book/route_book_witnesses.gd",
		"res://tests/runtime/route_book_witness_runner.gd",
		"res://game/demo/product_finite_slice.tscn", "res://game/demo/product_finite_slice.gd",
		"res://game/finite/run/finite_run_session_factory.gd"]
	paths.append_array(WitnessCase.PATHS.values())
	for path: String in paths:
		source_hashes[path] = FileAccess.get_file_as_string(path).replace("\r\n", "\n").sha256_text()
	var receipt := {"status": "PASS" if test.passed() else "FAIL", "failures": test.failures,
		"assertions": test.assertion_count, "stages": test.witness_results,
		"engine": Engine.get_version_info().string, "source_sha256_lf": source_hashes,
		"human_review": "NOT_RUN", "native_reliability": "SEPARATE_DIAGNOSTIC_REQUIRED"}
	var output := FileAccess.open("user://product-speed-witnesses.json", FileAccess.WRITE)
	if output == null:
		printerr("PRODUCT_SPEED_WITNESS: FAIL receipt unavailable")
		quit(2)
		return
	output.store_string(JSON.stringify(receipt, "\t"))
	output.close()
	for sample: Dictionary in test.witness_results:
		print("PRODUCT_SPEED_STAGE: %s" % JSON.stringify(sample))
	for failure: String in test.failures:
		printerr("PRODUCT_SPEED_WITNESS: FAIL %s" % failure)
	print("PRODUCT_SPEED_WITNESS: %s assertions=%d" % ["PASS" if test.passed() else "FAIL", test.assertion_count])
	quit(0 if test.passed() else 1)
