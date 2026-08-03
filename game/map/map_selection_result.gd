class_name MapSelectionResult
extends RefCounted

const SELF_SCRIPT_PATH := "res://game/map/map_selection_result.gd"

var success: bool = false
var error_code: StringName = &"UNKNOWN"
var message: String = ""
var receipt: Variant


static func succeeded(receipt_value: Variant) -> Variant:
	var value: Variant = load(SELF_SCRIPT_PATH).new()
	value.success = true
	value.error_code = &"OK"
	value.receipt = receipt_value
	return value


static func failed(code: StringName, detail: String) -> Variant:
	var value: Variant = load(SELF_SCRIPT_PATH).new()
	value.success = false
	value.error_code = code
	value.message = detail
	value.receipt = null
	return value
