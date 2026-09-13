extends SceneTree

# Diagnostic only: never substitutes for tests/run_tests.gd acceptance evidence.
const CASES := {
	"end_to_end": preload("res://tests/demo/test_first_session_end_to_end.gd"),
	"responsive": preload("res://tests/demo/test_first_session_responsive_accessibility.gd"),
}


func _initialize() -> void:
	call_deferred("_run_probe")


func _run_probe() -> void:
	var arguments := OS.get_cmdline_user_args()
	if arguments.size() != 2 or not arguments[1].is_valid_int():
		printerr("Usage: -- end_to_end|responsive|pair repeats(1..30)")
		quit(2)
		return
	var repeats := int(arguments[1])
	var selected := arguments[0]
	if repeats < 1 or repeats > 30 or (selected != "pair" and not CASES.has(selected)):
		printerr("Invalid bounded diagnostic selection")
		quit(2)
		return
	var keys: Array = ["end_to_end", "responsive"] if selected == "pair" else [selected]
	var failures := 0
	var assertions := 0
	for iteration: int in range(repeats):
		for key: String in keys:
			print("ISOLATION BEGIN iteration=%d case=%s" % [iteration + 1, key])
			var test: RefCounted = CASES[key].new()
			test.run()
			assertions += test.assertion_count
			if not test.passed():
				failures += 1
				for failure: String in test.failures:
					printerr(failure)
			print("ISOLATION END iteration=%d case=%s failed=%s assertions=%d" % [
				iteration + 1, key, not test.passed(), test.assertion_count])
	print("ISOLATION SUMMARY iterations=%d cases=%d failed=%d assertions=%d NOT_A_FIX" % [
		repeats, repeats * keys.size(), failures, assertions])
	quit(1 if failures else 0)
