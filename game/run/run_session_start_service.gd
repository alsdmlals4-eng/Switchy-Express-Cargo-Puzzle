class_name RunSessionStartService
extends RefCounted

var _selection_service: Variant
var _session_factory: Variant


func configure(selection_service: Variant, session_factory: Variant) -> void:
	assert(selection_service != null and selection_service.has_method("select"), "RunSessionStartService requires selection service")
	assert(session_factory != null and session_factory.has_method("create_for_definition"), "RunSessionStartService requires session factory")
	_selection_service = selection_service
	_session_factory = session_factory


func start(request: Variant, assisted: bool = false) -> Dictionary:
	if _selection_service == null or _session_factory == null:
		return _failed(&"NOT_CONFIGURED", "start service must be configured")

	var selection_result: Variant = _selection_service.select(request)
	if not selection_result.success:
		return _failed(selection_result.error_code, selection_result.message)
	var receipt: Variant = selection_result.receipt

	var previous_identity: Variant = null
	if request != null and request.mode == &"RESTART":
		previous_identity = request.previous_run_identity
	var session_result: Dictionary = _session_factory.create_for_definition(
		receipt.map_definition,
		previous_identity,
		assisted
	)
	if not session_result.get("success", false):
		return _failed(
			StringName(session_result.get("error_code", &"SESSION_BUILD_FAILED")),
			str(session_result.get("message", "session construction failed"))
		)

	if not _selection_service.commit_started(receipt):
		return _failed(&"SELECTION_COMMIT_FAILED", "selection receipt could not be committed")
	return {
		"success": true,
		"error_code": &"OK",
		"message": "",
		"receipt": receipt,
		"session": session_result.get("session"),
	}


func _failed(code: StringName, detail: String) -> Dictionary:
	return {
		"success": false,
		"error_code": code,
		"message": detail,
		"receipt": null,
		"session": null,
	}
