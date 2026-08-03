class_name RunSessionFactory
extends RefCounted

const RunIdentityScript := preload("res://game/run/run_identity.gd")
const RunSessionScript := preload("res://game/run/run_session.gd")
const RunBalanceScript := preload("res://game/run/run_balance.gd")
const CargoStackScript := preload("res://game/cargo/cargo_stack.gd")
const GameplayInputStateScript := preload("res://game/input/gameplay_input_state.gd")
const TrainControllerScript := preload("res://game/train/train_controller.gd")
const CompactWagonTokenStateScript := preload("res://game/train/compact_wagon_token_state.gd")
const TrainFootprintScript := preload("res://game/train/train_footprint.gd")
const DeliveryLoopScript := preload("res://game/delivery/delivery_loop.gd")
const RunControllerScript := preload("res://game/run/run_controller.gd")

var _pipeline: Variant
var _id_factory: Variant
var _next_generation: int = 0


func configure(pipeline: Variant, id_factory: Variant) -> void:
	assert(pipeline != null and pipeline.has_method("rebuild"), "RunSessionFactory requires map build pipeline")
	assert(id_factory != null and id_factory.has_method("next_id"), "RunSessionFactory requires run id factory")
	_pipeline = pipeline
	_id_factory = id_factory
	_next_generation = 0


func create_for_definition(
	definition: Variant,
	previous_identity: Variant = null,
	assisted: bool = false
) -> Dictionary:
	if _pipeline == null or _id_factory == null:
		return _failed(&"NOT_CONFIGURED", "factory must be configured")
	if definition == null or not definition.is_runtime_eligible():
		return _failed(&"INVALID_DEFINITION", "eligible map definition required")

	var build: Variant = _pipeline.rebuild(definition)
	if not build.success:
		return _failed(build.error_code, build.message)

	var retry_index := 0
	var previous_run_id := ""
	if previous_identity != null:
		if previous_identity.map_definition.identity_key() != definition.identity_key():
			return _failed(&"RESTART_MAP_MISMATCH", "restart must preserve exact map identity")
		if previous_identity.map_definition.content_signature != definition.content_signature:
			return _failed(&"RESTART_SIGNATURE_MISMATCH", "restart must preserve exact map content")
		retry_index = int(previous_identity.retry_index) + 1
		previous_run_id = str(previous_identity.run_id)

	var run_id: String = _id_factory.next_id()
	if run_id.is_empty():
		return _failed(&"RUN_ID_UNAVAILABLE", "run id factory returned empty identity")
	var identity: Variant = RunIdentityScript.create(
		definition,
		run_id,
		retry_index,
		previous_run_id
	)

	var cargo_stack: Variant = CargoStackScript.new()
	var input_state: Variant = GameplayInputStateScript.new()
	var train: Variant = TrainControllerScript.new()
	train.configure(build.graph, definition.start_cell, definition.incoming_cell)

	var compact_token_state: Variant = CompactWagonTokenStateScript.new()
	compact_token_state.configure(cargo_stack)
	var train_footprint: Variant = TrainFootprintScript.new()
	train_footprint.configure(train, compact_token_state)

	var delivery_loop: Variant = DeliveryLoopScript.new()
	delivery_loop.configure(
		train,
		cargo_stack,
		build.cargo_spawner,
		input_state,
		build.stations,
		train_footprint
	)

	var run_controller: Variant = RunControllerScript.new()
	run_controller.configure(
		train,
		delivery_loop,
		cargo_stack,
		input_state,
		RunBalanceScript.FUEL_MAX,
		RunBalanceScript.FUEL_START,
		assisted
	)

	_next_generation += 1
	var session: Variant = RunSessionScript.create({
		"identity": identity,
		"generation": _next_generation,
		"graph": build.graph,
		"stations": build.stations,
		"cargo_spawner": build.cargo_spawner,
		"cargo_stack": cargo_stack,
		"input_state": input_state,
		"train": train,
		"compact_token_state": compact_token_state,
		"train_footprint": train_footprint,
		"delivery_loop": delivery_loop,
		"run_controller": run_controller,
	})
	if not session.is_fully_configured():
		return _failed(&"INCOMPLETE_SESSION", "factory produced incomplete session")
	return {
		"success": true,
		"error_code": &"OK",
		"message": "",
		"session": session,
	}


func restart(previous_session: Variant, assisted: bool = false) -> Dictionary:
	if previous_session == null or not previous_session.is_fully_configured():
		return _failed(&"INVALID_PREVIOUS_SESSION", "fully configured previous session required")
	return create_for_definition(
		previous_session.identity.map_definition,
		previous_session.identity,
		assisted
	)


func _failed(code: StringName, detail: String) -> Dictionary:
	return {
		"success": false,
		"error_code": code,
		"message": detail,
		"session": null,
	}
