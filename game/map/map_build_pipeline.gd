class_name MapBuildPipeline
extends RefCounted

const RailGeneratorScript := preload("res://game/rail/rail_generator.gd")
const StationPlacerScript := preload("res://game/station/station_placer.gd")
const CargoSpawnerScript := preload("res://game/cargo/cargo_spawner.gd")
const MapDefinitionScript := preload("res://game/map/map_definition.gd")
const MapBuildResultScript := preload("res://game/map/map_build_result.gd")

const STATION_SEED_OFFSET := 100003
const PICKUP_SEED_OFFSET := 200003


func build_from_manifest_entry(entry: Dictionary) -> Variant:
	var map_id := StringName(entry.get("map_id", &""))
	var map_revision := int(entry.get("map_revision", 0))
	var generator_version := StringName(entry.get("generator_version", &""))
	var ruleset_version := StringName(entry.get("ruleset_version", &""))
	if map_id == &"" or map_revision <= 0:
		return MapBuildResultScript.failed(&"INVALID_IDENTITY", "map id and positive revision are required")
	if generator_version == &"" or ruleset_version == &"":
		return MapBuildResultScript.failed(&"INVALID_VERSION", "generator and ruleset versions are required")

	var start_cell := _read_cell(entry.get("start_cell", []))
	var incoming_cell := _read_cell(entry.get("incoming_cell", []))
	if start_cell == incoming_cell:
		return MapBuildResultScript.failed(&"INVALID_START", "incoming cell must differ from start cell")

	var seed := int(entry.get("map_seed", 0))
	var generator: Variant = RailGeneratorScript.new()
	var graph: Variant = generator.generate(
		seed,
		RailGeneratorScript.DEFAULT_ATTEMPTS,
		bool(entry.get("force_candidate_failure", false))
	)
	if bool(graph.used_fallback):
		return MapBuildResultScript.failed(&"FALLBACK_REJECTED", "official map build used fallback")
	if not graph.has_cell(start_cell) or not graph.neighbors(start_cell).has(incoming_cell):
		return MapBuildResultScript.failed(&"INVALID_START", "start and incoming cells must be connected rail cells")

	var placement: Dictionary = StationPlacerScript.new().place(
		graph,
		start_cell,
		seed + STATION_SEED_OFFSET
	)
	if not bool(placement.get("success", false)):
		return MapBuildResultScript.failed(&"STATION_PLACEMENT_FAILED", "station placement failed")
	var stations: Array = placement.get("stations", [])

	var cargo_spawner: Variant = CargoSpawnerScript.new()
	cargo_spawner.configure(graph, stations, seed + PICKUP_SEED_OFFSET)
	var spawn_status: StringName = cargo_spawner.ensure_all_minimum(
		CargoSpawnerScript.DEFAULT_MINIMUM_PER_TYPE,
		[start_cell],
		graph.preview_route(start_cell, incoming_cell, 2)
	)
	if spawn_status == CargoSpawnerScript.STATUS_DEFERRED:
		return MapBuildResultScript.failed(&"PICKUP_PLACEMENT_FAILED", "initial pickup placement was deferred")

	var graph_signature: String = graph.signature()
	var station_signature: String = str(placement.get("signature", ""))
	var pickup_signature: String = cargo_spawner.signature()
	var layout_signature := _digest("%s\n%s" % [graph_signature, station_signature])
	var content_signature := _digest("%s\n%s" % [layout_signature, pickup_signature])

	var definition_data := entry.duplicate(true)
	definition_data.erase("force_candidate_failure")
	definition_data["graph_signature"] = graph_signature
	definition_data["station_signature"] = station_signature
	definition_data["initial_pickup_signature"] = pickup_signature
	definition_data["layout_signature"] = layout_signature
	definition_data["content_signature"] = content_signature
	definition_data["used_fallback"] = false
	var definition: Variant = MapDefinitionScript.create(definition_data)
	if not definition.is_runtime_eligible():
		return MapBuildResultScript.failed(
			&"INVALID_DEFINITION",
			"; ".join(definition.validation_errors())
		)
	return MapBuildResultScript.succeeded(definition, graph, stations, cargo_spawner)


func rebuild(definition: Variant) -> Variant:
	if definition == null or not definition.is_runtime_eligible():
		return MapBuildResultScript.failed(&"INVALID_DEFINITION", "eligible map definition required")
	var rebuilt: Variant = build_from_manifest_entry(definition.to_manifest_entry())
	if not rebuilt.success:
		return rebuilt
	var actual: Variant = rebuilt.definition
	var expected_signatures := {
		"graph_signature": definition.graph_signature,
		"station_signature": definition.station_signature,
		"initial_pickup_signature": definition.initial_pickup_signature,
		"layout_signature": definition.layout_signature,
		"content_signature": definition.content_signature,
	}
	for field_name: String in expected_signatures.keys():
		if actual.get(field_name) != expected_signatures[field_name]:
			return MapBuildResultScript.failed(
				&"SIGNATURE_MISMATCH",
				"%s mismatch" % field_name
			)
	return rebuilt


func _digest(value: String) -> String:
	var context := HashingContext.new()
	context.start(HashingContext.HASH_SHA256)
	context.update(value.to_utf8_buffer())
	return context.finish().hex_encode()


func _read_cell(raw: Variant) -> Vector2i:
	if raw is Vector2i:
		return raw
	if raw is Array and raw.size() == 2:
		return Vector2i(int(raw[0]), int(raw[1]))
	if raw is Dictionary and raw.has("x") and raw.has("y"):
		return Vector2i(int(raw.x), int(raw.y))
	return Vector2i.ZERO
