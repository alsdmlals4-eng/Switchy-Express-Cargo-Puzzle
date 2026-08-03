class_name RunIdentity
extends RefCounted

const SELF_SCRIPT_PATH := "res://game/run/run_identity.gd"

var map_definition: Variant
var run_id: String = ""
var retry_index: int = 0
var restarted_from_run_id: String = ""
var transaction_namespace: String = ""


static func create(
	definition: Variant,
	run_id_value: String,
	retry_value: int,
	previous_run_id: String
) -> Variant:
	assert(definition != null and definition.is_runtime_eligible(), "eligible map definition required")
	assert(not run_id_value.is_empty(), "run_id required")
	assert(retry_value >= 0, "retry_index cannot be negative")
	if retry_value == 0:
		assert(previous_run_id.is_empty(), "first attempt cannot reference previous run")
	else:
		assert(not previous_run_id.is_empty(), "retry must reference previous run")

	var value: Variant = load(SELF_SCRIPT_PATH).new()
	value.map_definition = definition
	value.run_id = run_id_value
	value.retry_index = retry_value
	value.restarted_from_run_id = previous_run_id
	value.transaction_namespace = "run-tx:%s" % run_id_value
	return value


func to_public_dictionary() -> Dictionary:
	return {
		"run_id": run_id,
		"map_id": str(map_definition.map_id),
		"map_revision": map_definition.map_revision,
		"retry_index": retry_index,
		"restarted_from_run_id": restarted_from_run_id,
	}
