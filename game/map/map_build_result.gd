class_name MapBuildResult
extends RefCounted

var success: bool = false
var error_code: StringName = &"UNKNOWN"
var message: String = ""
var definition: Variant
var graph: Variant
var stations: Array = []
var cargo_spawner: Variant


static func succeeded(
	definition_value: Variant,
	graph_value: Variant,
	stations_value: Array,
	cargo_spawner_value: Variant
) -> MapBuildResult:
	var value := MapBuildResult.new()
	value.success = true
	value.error_code = &"OK"
	value.definition = definition_value
	value.graph = graph_value
	value.stations = stations_value.duplicate()
	value.cargo_spawner = cargo_spawner_value
	return value


static func failed(code: StringName, detail: String) -> MapBuildResult:
	var value := MapBuildResult.new()
	value.success = false
	value.error_code = code
	value.message = detail
	return value
