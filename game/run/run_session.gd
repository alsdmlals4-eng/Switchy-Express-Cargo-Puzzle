class_name RunSession
extends RefCounted

const SELF_SCRIPT_PATH := "res://game/run/run_session.gd"

var identity: Variant
var generation: int = 0
var graph: Variant
var stations: Array = []
var cargo_spawner: Variant
var cargo_stack: Variant
var input_state: Variant
var train: Variant
var compact_token_state: Variant
var train_footprint: Variant
var delivery_loop: Variant
var run_controller: Variant


static func create(data: Dictionary) -> Variant:
	var value: Variant = load(SELF_SCRIPT_PATH).new()
	value.identity = data.get("identity")
	value.generation = int(data.get("generation", 0))
	value.graph = data.get("graph")
	value.stations = data.get("stations", []).duplicate()
	value.cargo_spawner = data.get("cargo_spawner")
	value.cargo_stack = data.get("cargo_stack")
	value.input_state = data.get("input_state")
	value.train = data.get("train")
	value.compact_token_state = data.get("compact_token_state")
	value.train_footprint = data.get("train_footprint")
	value.delivery_loop = data.get("delivery_loop")
	value.run_controller = data.get("run_controller")
	return value


func is_fully_configured() -> bool:
	return (
		identity != null
		and generation > 0
		and graph != null
		and not stations.is_empty()
		and cargo_spawner != null
		and cargo_stack != null
		and input_state != null
		and train != null
		and compact_token_state != null
		and train_footprint != null
		and delivery_loop != null
		and run_controller != null
		and run_controller.run_state() != null
		and run_controller.difficulty_director() != null
	)


func accepts_generation(candidate_generation: int) -> bool:
	return candidate_generation == generation
