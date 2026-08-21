extends "res://tests/test_case.gd"

const DefinitionScript := preload("res://game/first_session/first_session_definition.gd")
const DirectorScript := preload("res://game/first_session/first_session_director.gd")


func run() -> void:
	var definition: Variant = DefinitionScript.load_from_path(
		"res://data/first_session/first_session_v1.json"
	)
	var director: Variant = DirectorScript.new()
	assert_true(director.configure(definition), "director configures from canonical definition")
	assert_equal(director.current_lesson_id(), &"T1", "director boots at T1")

	var stayed: Dictionary = director.observe_model({"phase": &"BUILD", "start_enabled": false})
	assert_false(stayed["changed"], "invalid T1 route stays on T1")
	var t2: Dictionary = director.observe_model({"phase": &"BUILD", "start_enabled": true})
	assert_true(t2["changed"], "preflight pass advances T1")
	assert_true(t2["preserve_gameplay_instance"], "T1/T2 preserve one gameplay instance")
	assert_equal(director.current_lesson_id(), &"T2", "T1 advances to T2")

	var failure: Dictionary = director.observe_terminal({"outcome": &"FAILURE"})
	assert_false(failure["changed"], "failure never advances a lesson")
	assert_equal(director.current_lesson_id(), &"T2", "failure stays at T2")

	for expected: StringName in [&"T3", &"T4", &"T5", &"T6", &"CAPSTONE"]:
		var transition: Dictionary = director.observe_terminal({"outcome": &"SUCCESS"})
		assert_true(transition["changed"], "success advances to %s" % expected)
		assert_false(transition["preserve_gameplay_instance"], "terminal transition replaces gameplay")
		assert_equal(director.current_lesson_id(), expected, "lesson order remains exact")

	var complete: Dictionary = director.observe_terminal({"outcome": &"SUCCESS"})
	assert_false(complete["changed"], "capstone completion does not leave capstone")
	assert_true(complete["sequence_complete"], "capstone success completes sequence")

	director.reset()
	assert_equal(director.current_lesson_id(), &"T1", "reset returns to T1")
