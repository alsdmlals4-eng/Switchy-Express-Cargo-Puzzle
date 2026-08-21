extends GutTest

const MainScene := preload("res://game/main/main.tscn")
const DefinitionScript := preload(
	"res://game/first_session/first_session_definition.gd"
)


func test_product_entry_enables_the_first_session_sequence() -> void:
	var main: Control = MainScene.instantiate()
	add_child_autofree(main)
	var flow := main.get_node("VerticalSliceDemo")

	assert_true(flow.first_session_enabled, "product main must opt into the first session")
	assert_eq(flow.current_lesson_id_for_test(), &"T1", "product entry must begin at T1")
	flow.start_demo()
	assert_eq(flow.state(), &"BRIEFING", "start CTA must open the T1 lesson card")


func test_first_session_definition_preserves_shared_t1_t2_and_capstone_map() -> void:
	var definition: Variant = DefinitionScript.load_from_path(
		"res://data/first_session/first_session_v1.json"
	)
	assert_not_null(definition, "first-session definition must load in the formal consumer")
	if definition == null:
		return

	assert_eq(
		definition.lesson(&"T1").get("map_path"),
		definition.lesson(&"T2").get("map_path"),
		"T1 preflight and T2 execution must share one authored map",
	)
	assert_eq(
		definition.lesson(&"CAPSTONE").get("map_path"),
		"res://data/maps/vs_demo_01.json",
		"capstone must reuse the sealed vertical-slice map",
	)
