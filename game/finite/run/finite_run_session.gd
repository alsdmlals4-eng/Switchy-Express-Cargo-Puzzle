class_name FiniteRunSession
extends RefCounted

const SELF_SCRIPT_PATH := "res://game/finite/run/finite_run_session.gd"
const FiniteMapDefinitionScript := preload("res://game/finite/map/finite_map_definition.gd")

var _identity: Variant
var _definition: Variant
var _layout: Variant

var graph: Variant
var stations: Array = []
var cargo_field: Variant
var cargo_stack: Variant
var input_state: Variant
var train: Variant
var delivery_loop: Variant
var run_controller: Variant


static func create(data: Dictionary) -> Variant:
	var value: Variant = load(SELF_SCRIPT_PATH).new()
	value._identity = data.get("identity")
	var definition: Variant = data.get("definition")
	if definition != null:
		value._definition = FiniteMapDefinitionScript.create(definition.to_dictionary())
	var layout: Variant = data.get("layout")
	if layout != null:
		value._layout = layout.duplicate_layout()
	value.graph = data.get("graph")
	value.stations = data.get("stations", []).duplicate()
	value.cargo_field = data.get("cargo_field")
	value.cargo_stack = data.get("cargo_stack")
	value.input_state = data.get("input_state")
	value.train = data.get("train")
	value.delivery_loop = data.get("delivery_loop")
	value.run_controller = data.get("run_controller")
	return value


func is_fully_configured() -> bool:
	return (
		_identity != null
		and _definition != null
		and _layout != null
		and graph != null
		and not stations.is_empty()
		and cargo_field != null
		and cargo_stack != null
		and input_state != null
		and train != null
		and delivery_loop != null
		and run_controller != null
		and run_controller.run_state() != null
	)


func map_identity() -> String:
	return "" if _identity == null else str(_identity.map_identity)


func solution_identity() -> String:
	return "" if _identity == null else str(_identity.solution_identity)


func attempt_identity() -> String:
	return "" if _identity == null else str(_identity.attempt_identity)


func attempt_serial() -> int:
	return 0 if _identity == null else int(_identity.attempt_serial)


func definition_snapshot() -> Variant:
	if _definition == null:
		return null
	return FiniteMapDefinitionScript.create(_definition.to_dictionary())


func layout_snapshot() -> Variant:
	if _layout == null:
		return null
	return _layout.duplicate_layout()
