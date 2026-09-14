extends SceneTree

const Case := preload("res://tests/route_book/test_route_book_03_witnesses.gd")


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var test := Case.new()
	var selected := ""
	var receipt_path := ""
	for argument: String in OS.get_cmdline_user_args():
		if argument.begins_with("stage="):
			selected = argument.trim_prefix("stage=")
		elif argument.begins_with("receipt="):
			receipt_path = argument.trim_prefix("receipt=")
	if selected.is_empty():
		test.run()
	else:
		test.assert_true(Case.IDS.has(StringName(selected)), "known single-stage selector")
		if test.passed():
			test.run_stage(StringName(selected))
	test.assert_equal(test.results.size(), 6 if selected.is_empty() else 1, "complete witness result count")
	if not receipt_path.is_empty():
		var sources: Array[String] = ["res://tests/fixtures/route_book/route_book_03_witnesses.gd",
			"res://tests/route_book/test_route_book_03_witnesses.gd", "res://tests/runtime/route_book_03_witness_runner.gd"]
		for id: StringName in Case.IDS:
			sources.append("res://data/maps/route_book/" + str(id).to_lower() + ".json")
		var hashes: Dictionary = {}
		for path: String in sources:
			test.assert_true(FileAccess.file_exists(path), "source exists " + path)
			hashes[path] = FileAccess.get_file_as_string(path).replace("\r\n", "\n").sha256_text()
		var output := FileAccess.open(receipt_path, FileAccess.WRITE)
		test.assert_not_null(output, "receipt can be written")
		if output != null:
			output.store_string(JSON.stringify({"status": "PASS" if test.passed() else "FAIL",
				"engine": Engine.get_version_info().string, "recorded_at_utc": Time.get_datetime_string_from_system(true),
				"selected_stage": selected, "source_sha256_lf": hashes, "results": test.results,
				"assertions": test.assertion_count, "failures": test.failures,
				"ceiling": "DOMAIN_AUTOMATION_ONLY_NOT_WINDOW_NOT_PACKAGE_NOT_HUMAN"}, "\t"))
			output.close()
	for failure: String in test.failures:
		printerr("BOOK03: " + failure)
	print("BOOK03: %s assertions=%d" % ["PASS" if test.passed() else "FAIL", test.assertion_count])
	quit(0 if test.passed() else 1)
