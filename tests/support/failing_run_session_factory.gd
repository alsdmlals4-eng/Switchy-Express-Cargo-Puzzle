extends RefCounted


func create_for_definition(
	_definition: Variant,
	_previous_identity: Variant = null,
	_assisted: bool = false
) -> Dictionary:
	return {
		"success": false,
		"error_code": &"INJECTED_FAILURE",
		"message": "injected session construction failure",
		"session": null,
	}
