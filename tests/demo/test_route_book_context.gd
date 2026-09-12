extends "res://tests/test_case.gd"

const Demo := preload("res://game/demo/vertical_slice_demo.tscn")
const Definition := preload("res://game/route_book/route_book_definition.gd")

func run() -> void:
	var demo: Variant = Demo.instantiate()
	(Engine.get_main_loop() as SceneTree).root.add_child(demo)
	var rules: Label = demo.get_node("BriefingScreen/Panel/Content/Rules")
	for locale: String in ["ko", "en", "ja", "zh-Hans"]:
		demo.first_session_locale = locale
		var seen: Dictionary = {}
		for book: StringName in [&"ROUTE_BOOK_01", &"ROUTE_BOOK_02"]:
			demo.return_to_title()
			demo.open_route_book()
			assert_true(demo.select_route_book(book), "book selectable")
			var definition: Variant = Definition.load_from_path("res://data/route_book/route_book_%02d.json" % (1 if book == &"ROUTE_BOOK_01" else 2))
			for stage: StringName in definition.stage_ids():
				demo.return_to_title()
				demo.open_route_book()
				demo.select_route_book(book)
				assert_true(demo.select_route_book_stage(stage), "stage selectable")
				assert_true(rules.visible, "%s %s exposes planning context" % [stage, locale])
				assert_false(rules.text.is_empty(), "%s %s has planning context" % [stage, locale])
				assert_false(rules.text.begins_with("SX_"), "no raw translation key")
				assert_false(seen.has(rules.text), "context changes with stage, not stale")
				seen[rules.text] = true
	# Empty optional context must clear the previous stage's text.
	var data: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/route_book/route_book_01.json"))
	data["stages"][0]["context_key"] = ""
	var without_context: Variant = Definition.create(data)
	assert_not_null(without_context, "empty optional context remains valid")
	demo._route_book_director.configure(without_context)
	demo._route_book_director.select_stage(&"RB01_SERVICE_SIDINGS")
	rules.text = "stale previous stage"
	rules.visible = true
	demo._apply_route_book_card()
	assert_equal(rules.text, "", "empty context clears stale text")
	assert_false(rules.visible, "empty context hides optional label")
	demo.free()
