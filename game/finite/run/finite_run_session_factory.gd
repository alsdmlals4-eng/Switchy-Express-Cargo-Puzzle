class_name FiniteRunSessionFactory
extends RefCounted

const FiniteMapDefinitionScript := preload("res://game/finite/map/finite_map_definition.gd")
const PreflightValidatorScript := preload("res://game/finite/build/preflight_validator.gd")
const FiniteSolutionIdentityScript := preload("res://game/finite/run/finite_solution_identity.gd")
const FiniteRunSessionScript := preload("res://game/finite/run/finite_run_session.gd")
const FixedCargoFieldScript := preload("res://game/finite/cargo/fixed_cargo_field.gd")
const UnlimitedCargoStackScript := preload("res://game/finite/cargo/unlimited_cargo_stack.gd")
const FiniteGameplayInputStateScript := preload("res://game/finite/input/finite_gameplay_input_state.gd")
const TrainControllerScript := preload("res://game/train/train_controller.gd")
const StationScript := preload("res://game/station/station.gd")
const FiniteDeliveryLoopScript := preload("res://game/finite/delivery/finite_delivery_loop.gd")
const FiniteRunControllerScript := preload("res://game/finite/run/finite_run_controller.gd")

var _definition: Variant
var _layout: Variant
var _base_speed: float = 0.0
var _next_attempt_serial: int = 1
var _configured: bool = false


func configure(
	definition: Variant,
	sealed_snapshot: Dictionary,
	base_speed: float = 2.0
) -> bool:
	_clear_configuration()
	if definition == null or not definition.has_method("validation_errors"):
		return false
	if not definition.validation_errors().is_empty():
		return false
	var layout: Variant = sealed_snapshot.get("layout")
	if layout == null or not layout.has_method("duplicate_layout"):
		return false

	var definition_copy: Variant = FiniteMapDefinitionScript.create(definition.to_dictionary())
	var layout_copy: Variant = layout.duplicate_layout()
	if str(sealed_snapshot.get("definition_identity", "")) != definition_copy.identity_key():
		return false
	if str(sealed_snapshot.get("ruleset_version", "")) != str(definition_copy.ruleset_version):
		return false
	if str(sealed_snapshot.get("layout_signature", "")) != layout_copy.layout_signature():
		return false

	var preflight: Variant = PreflightValidatorScript.new().validate(definition_copy, layout_copy)
	if preflight == null or not preflight.passed:
		return false

	_definition = definition_copy
	_layout = layout_copy
	_base_speed = maxf(base_speed, 0.0)
	_next_attempt_serial = 1
	_configured = true
	return true


func create_attempt(attempt_serial: int = -1) -> Dictionary:
	if not _configured:
		return _failed(&"NOT_CONFIGURED", "finite run session factory must be configured")
	var serial: int = _next_attempt_serial if attempt_serial == -1 else attempt_serial
	if serial <= 0:
		return _failed(&"INVALID_ATTEMPT_SERIAL", "attempt serial must be positive")
	if attempt_serial != -1 and serial < _next_attempt_serial:
		return _failed(&"ATTEMPT_SERIAL_REUSED", "attempt serial must increase monotonically")

	var definition: Variant = FiniteMapDefinitionScript.create(_definition.to_dictionary())
	var layout: Variant = _layout.duplicate_layout()
	var preflight: Variant = PreflightValidatorScript.new().validate(definition, layout)
	if preflight == null or not preflight.passed or preflight.graph == null:
		return _failed(&"PREFLIGHT_FAILED", "sealed finite solution must remain structurally valid")

	var identity: Variant = FiniteSolutionIdentityScript.create(definition, layout, serial)
	var stations: Array = _create_stations(definition.station_placements)
	if stations.is_empty():
		return _failed(&"STATIONS_UNAVAILABLE", "finite definition requires stations")

	var cargo_field: Variant = FixedCargoFieldScript.new(definition.cargo_placements)
	if not cargo_field.validation_errors().is_empty():
		return _failed(&"CARGO_FIELD_INVALID", "finite cargo placements must remain valid")
	var cargo_stack: Variant = UnlimitedCargoStackScript.new()
	var input_state: Variant = FiniteGameplayInputStateScript.new()
	var train: Variant = TrainControllerScript.new()
	train.configure(preflight.graph, definition.start_cell, definition.incoming_cell, 0)
	var delivery_loop: Variant = FiniteDeliveryLoopScript.new(
		cargo_field,
		input_state,
		cargo_stack,
		stations
	)
	if not delivery_loop.is_valid():
		return _failed(&"STATION_SERVICE_INVALID", "station service ownership must be unambiguous")
	var run_controller: Variant = FiniteRunControllerScript.new()
	run_controller.configure(
		train,
		delivery_loop,
		input_state,
		definition.time_limit_seconds,
		_base_speed,
		cargo_field.remaining_count()
	)

	var session: Variant = FiniteRunSessionScript.create({
		"identity": identity,
		"definition": definition,
		"layout": layout,
		"graph": preflight.graph,
		"stations": stations,
		"cargo_field": cargo_field,
		"cargo_stack": cargo_stack,
		"input_state": input_state,
		"train": train,
		"delivery_loop": delivery_loop,
		"run_controller": run_controller,
	})
	if not session.is_fully_configured():
		return _failed(&"INCOMPLETE_SESSION", "factory produced an incomplete finite session")

	_next_attempt_serial = maxi(_next_attempt_serial, serial + 1)
	return {
		"success": true,
		"error_code": &"OK",
		"message": "",
		"session": session,
	}


func retry(previous_session: Variant) -> Dictionary:
	if not _configured:
		return _failed(&"NOT_CONFIGURED", "finite run session factory must be configured")
	if (
		previous_session == null
		or not previous_session.has_method("is_fully_configured")
		or not previous_session.is_fully_configured()
	):
		return _failed(&"INVALID_PREVIOUS_SESSION", "fully configured previous finite session required")
	var expected: Variant = FiniteSolutionIdentityScript.create(_definition, _layout, 1)
	if previous_session.solution_identity() != expected.solution_identity:
		return _failed(&"RETRY_SOLUTION_MISMATCH", "retry must preserve exact finite solution identity")
	return create_attempt()


func _clear_configuration() -> void:
	_definition = null
	_layout = null
	_base_speed = 0.0
	_next_attempt_serial = 1
	_configured = false


static func _create_stations(placements: Array[Dictionary]) -> Array:
	var result: Array = []
	for placement: Dictionary in placements:
		result.append(
			StationScript.new(
				_read_cell(placement.get("cell", [])),
				StringName(placement.get("cargo_type", &""))
			)
		)
	return result


static func _read_cell(raw: Variant) -> Vector2i:
	if raw is Vector2i:
		return raw
	if raw is Array and raw.size() == 2:
		return Vector2i(int(raw[0]), int(raw[1]))
	if raw is Dictionary and raw.has("x") and raw.has("y"):
		return Vector2i(int(raw.get("x", 0)), int(raw.get("y", 0)))
	return Vector2i.ZERO


static func _failed(code: StringName, detail: String) -> Dictionary:
	return {
		"success": false,
		"error_code": code,
		"message": detail,
		"session": null,
	}
