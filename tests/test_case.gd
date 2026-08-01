class_name TestCase
extends RefCounted

var failures: Array[String] = []
var assertion_count: int = 0


func run() -> void:
	pass


func assert_true(condition: bool, message: String) -> void:
	assertion_count += 1
	if not condition:
		failures.append(message)


func assert_false(condition: bool, message: String) -> void:
	assert_true(not condition, message)


func assert_equal(actual: Variant, expected: Variant, message: String) -> void:
	assertion_count += 1
	if actual != expected:
		failures.append("%s | expected=%s actual=%s" % [message, str(expected), str(actual)])


func assert_not_null(value: Variant, message: String) -> void:
	assertion_count += 1
	if value == null:
		failures.append(message)


func assert_greater_equal(actual: int, expected_minimum: int, message: String) -> void:
	assertion_count += 1
	if actual < expected_minimum:
		failures.append("%s | expected>=%d actual=%d" % [message, expected_minimum, actual])


func passed() -> bool:
	return failures.is_empty()
