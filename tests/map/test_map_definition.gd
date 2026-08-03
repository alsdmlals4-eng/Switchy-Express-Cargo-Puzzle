extends TestCase

const MapDefinitionScript := preload("res://game/map/map_definition.gd")
const Fixture := preload("res://tests/support/map_fixture.gd")


func run() -> void:
	var definition: Variant = MapDefinitionScript.create(Fixture.definition_data())
	assert_true(definition.is_runtime_eligible(), "complete validated definition must be runtime eligible")
	assert_equal(definition.identity_key(), "map.sx.0001@1", "identity key must include stable id and revision")
	assert_equal(definition.start_cell, Vector2i(0, 0), "start cell must reconstruct exactly")
	assert_equal(definition.incoming_cell, Vector2i(0, 1), "incoming cell must reconstruct exactly")

	var missing_signature: Dictionary = Fixture.definition_data()
	missing_signature["initial_pickup_signature"] = ""
	var invalid: Variant = MapDefinitionScript.create(missing_signature)
	assert_false(invalid.is_runtime_eligible(), "missing reconstruction signature must reject runtime use")
	assert_true(
		invalid.validation_errors().has("initial_pickup_signature is required"),
		"validation must identify the missing pickup signature"
	)

	var fallback_data: Dictionary = Fixture.definition_data()
	fallback_data["used_fallback"] = true
	assert_false(
		MapDefinitionScript.create(fallback_data).is_runtime_eligible(),
		"fallback definitions must never enter the official runtime catalog"
	)

	var public_data: Dictionary = definition.to_public_dictionary()
	assert_false(public_data.has("map_seed"), "public map data must not expose raw seed")
	assert_false(public_data.has("generator_version"), "public map data must not expose generator internals")
	assert_equal(public_data.get("map_id"), "map.sx.0001", "public map data keeps stable semantic id")
