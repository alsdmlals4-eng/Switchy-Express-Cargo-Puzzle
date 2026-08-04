class_name FiniteSolutionIdentity
extends RefCounted

const SELF_SCRIPT_PATH := "res://game/finite/run/finite_solution_identity.gd"

var _map_identity: String = ""
var _solution_identity: String = ""
var _attempt_identity: String = ""
var _attempt_serial: int = 0

var map_identity: String:
	get:
		return _map_identity
	set(_value):
		pass

var solution_identity: String:
	get:
		return _solution_identity
	set(_value):
		pass

var attempt_identity: String:
	get:
		return _attempt_identity
	set(_value):
		pass

var attempt_serial: int:
	get:
		return _attempt_serial
	set(_value):
		pass


static func create(definition: Variant, layout: Variant, serial: int) -> Variant:
	assert(definition != null, "finite solution identity requires a definition")
	assert(layout != null, "finite solution identity requires a layout")
	assert(serial > 0, "finite attempt serial must be positive")
	assert(definition.validation_errors().is_empty(), "finite solution identity requires a valid definition")
	var layout_signature: String = str(layout.layout_signature())
	assert(not layout_signature.is_empty(), "finite solution identity requires a layout signature")

	var value: Variant = load(SELF_SCRIPT_PATH).new()
	value._map_identity = str(definition.identity_key())
	var solution_material := "%s|schema=%d|ruleset=%s|layout=%s" % [
		value._map_identity,
		int(definition.definition_schema_version),
		str(definition.ruleset_version),
		layout_signature,
	]
	value._solution_identity = _sha256(solution_material)
	value._attempt_serial = serial
	value._attempt_identity = _sha256(
		"%s|attempt=%d" % [value._solution_identity, serial]
	)
	return value


static func _sha256(material: String) -> String:
	var context := HashingContext.new()
	var start_error: Error = context.start(HashingContext.HASH_SHA256)
	if start_error != OK:
		return ""
	var bytes: PackedByteArray = material.to_utf8_buffer()
	if not bytes.is_empty():
		var update_error: Error = context.update(bytes)
		if update_error != OK:
			return ""
	return context.finish().hex_encode()
