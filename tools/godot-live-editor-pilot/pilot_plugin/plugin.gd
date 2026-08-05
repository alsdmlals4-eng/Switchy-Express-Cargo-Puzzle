@tool
extends "res://addons/base_live_editor_adapter/plugin.gd"

const RESULT_PATH := "res://artifacts/godot-live-editor/switchy_real_project_pilot_result.json"
const BASELINE_PATH := "res://tools/godot-live-editor-pilot/SOURCE_BASELINE.json"
const TARGET_SCENE := "res://game/finite/presentation/finite_slice_view.tscn"
const TARGET_NODE := NodePath("Board/BoardTitle")
const ORIGINAL_NAME := "BoardTitle"
const DIRTY_NAME := "BoardTitlePilotDirty"
const SAVED_NAME := "BoardTitlePilotSaved"
const SERVICE_INSTANCE_ID := "switchy-pilot-service-001"
const BATCH_SIZE := 64

var _manifest: Dictionary = {}
var _original_scene_sha256 := ""
var _pilot_started_usec := 0


func _enter_tree() -> void:
    super._enter_tree()
    call_deferred("_run_pilot")


func _run_pilot() -> void:
    _pilot_started_usec = Time.get_ticks_usec()
    await get_tree().process_frame
    var adapter_state: Dictionary = availability()
    if not adapter_state.get("available", false):
        _finish(_failure_payload(str(adapter_state.get("code", "ADAPTER_NOT_CONFIGURED"))))
        return
    if network_listener_enabled:
        _finish(_failure_payload("NETWORK_LISTENER_ENABLED"))
        return

    _manifest = _load_json("res://GODOT_LIVE_EDITOR_CAPABILITY_MANIFEST.json")
    var baseline := _load_json(BASELINE_PATH)
    _original_scene_sha256 = str(
        baseline.get("target_scene", {}).get("raw_sha256", "")
    )
    if _original_scene_sha256.length() != 64:
        _finish(_failure_payload("SOURCE_BASELINE_MISMATCH"))
        return

    EditorInterface.open_scene_from_path(TARGET_SCENE)
    await get_tree().process_frame
    await get_tree().process_frame

    var root := EditorInterface.get_edited_scene_root()
    if (
        root == null
        or str(root.scene_file_path) != TARGET_SCENE
        or root.get_node_or_null(TARGET_NODE) == null
        or str(root.get_node(TARGET_NODE).name) != ORIGINAL_NAME
        or _evidence.sha256_file(TARGET_SCENE) != _original_scene_sha256
    ):
        _finish(_failure_payload("TARGET_SCENE_CONTRACT_MISMATCH"))
        return

    var inspect_observation: Dictionary = _probe.observe(
        get_editor_interface(),
        get_undo_redo(),
        NodePath("."),
    )
    var inspect_result: Dictionary = await _submit_and_wait(
        _build_envelope(
            "scene.inspect",
            {},
            inspect_observation,
            "switchy-inspect-001",
        )
    )
    var scene_inspect_pass: bool = (
        inspect_result.get("success", false)
        and inspect_result.get("data", {}).get("scene_path") == TARGET_SCENE
    )

    var dirty_observation: Dictionary = _probe.observe(
        get_editor_interface(),
        get_undo_redo(),
        TARGET_NODE,
    )
    var dirty_result: Dictionary = await _submit_and_wait(
        _build_envelope(
            "node.rename",
            {
                "node_path": str(TARGET_NODE),
                "new_name": DIRTY_NAME,
                "save_mode": "KEEP_DIRTY",
            },
            dirty_observation,
            "switchy-rename-dirty-001",
        )
    )
    root = EditorInterface.get_edited_scene_root()
    var dirty_rename_pass: bool = (
        dirty_result.get("success", false)
        and root != null
        and root.get_node_or_null(NodePath("Board/%s" % DIRTY_NAME)) != null
        and EditorInterface.get_unsaved_scenes().has(TARGET_SCENE)
        and _evidence.sha256_file(TARGET_SCENE) == _original_scene_sha256
    )
    var dirty_undo_pass: bool = await _undo_to_original()

    var saved_result: Dictionary = _failure_result("SAVE_SEQUENCE_NOT_RUN")
    var saved_rename_pass := false
    var saved_scene_sha256: Variant = null
    if dirty_undo_pass:
        var saved_observation: Dictionary = _probe.observe(
            get_editor_interface(),
            get_undo_redo(),
            TARGET_NODE,
        )
        saved_result = await _submit_and_wait(
            _build_envelope(
                "node.rename",
                {
                    "node_path": str(TARGET_NODE),
                    "new_name": SAVED_NAME,
                    "save_mode": "SAVE_CURRENT_SCENE",
                },
                saved_observation,
                "switchy-rename-save-001",
            )
        )
        root = EditorInterface.get_edited_scene_root()
        saved_scene_sha256 = saved_result.get("data", {}).get("saved_scene_sha256")
        saved_rename_pass = (
            saved_result.get("success", false)
            and root != null
            and root.get_node_or_null(NodePath("Board/%s" % SAVED_NAME)) != null
            and saved_scene_sha256 != null
            and saved_scene_sha256 == _evidence.sha256_file(TARGET_SCENE)
            and saved_scene_sha256 != _original_scene_sha256
        )

    var restore_result: Dictionary = await _restore_original_scene()
    var saved_undo_restore_pass: bool = restore_result.get("ok", false)
    var restored_scene_sha256 = restore_result.get("restored_scene_sha256")
    var temporary_scene_byte_restore_pass: bool = (
        saved_undo_restore_pass
        and restored_scene_sha256 == _original_scene_sha256
    )

    root = EditorInterface.get_edited_scene_root()
    var adversarial_ready: bool = (
        root != null
        and root.get_node_or_null(TARGET_NODE) != null
        and temporary_scene_byte_restore_pass
    )

    var stale_result: Dictionary = _failure_result("ADVERSARIAL_NOT_RUN")
    var stale_state_block_pass := false
    var hash_submit: Dictionary = {"ok": false, "code": "ADVERSARIAL_NOT_RUN"}
    var request_hash_block_pass := false
    var expired_submit: Dictionary = {"ok": false, "code": "ADVERSARIAL_NOT_RUN"}
    var expired_approval_block_pass := false
    var binding_submit: Dictionary = {"ok": false, "code": "ADVERSARIAL_NOT_RUN"}
    var approval_binding_block_pass := false

    if adversarial_ready:
        var adversarial_observation: Dictionary = _probe.observe(
            get_editor_interface(),
            get_undo_redo(),
            TARGET_NODE,
        )
        var stale_envelope := _build_envelope(
            "node.rename",
            {
                "node_path": str(TARGET_NODE),
                "new_name": "BoardTitlePilotStale",
                "save_mode": "KEEP_DIRTY",
            },
            adversarial_observation,
            "switchy-rename-stale-001",
        )
        stale_envelope["preconditions"]["expected_target_revision"] = "stale-revision"
        _refresh_request_security(stale_envelope, _capability("node.rename"))
        stale_result = await _submit_and_wait(stale_envelope)
        stale_state_block_pass = (
            not stale_result.get("success", false)
            and stale_result.get("code") == "TARGET_STATE_CONFLICT"
            and _target_is_original()
            and _scene_bytes_are_original()
            and _ledger_state("switchy-rename-stale-001") == null
            and not _evidence_exists("switchy-rename-stale-001")
        )

        var inspect_adversarial_observation: Dictionary = _probe.observe(
            get_editor_interface(),
            get_undo_redo(),
            NodePath("."),
        )
        var hash_envelope := _build_envelope(
            "scene.inspect",
            {},
            inspect_adversarial_observation,
            "switchy-hash-tamper-001",
        )
        hash_envelope["request"]["arguments"] = {"tampered": true}
        hash_submit = submit_validated_operation(hash_envelope)
        request_hash_block_pass = (
            not hash_submit.get("ok", false)
            and hash_submit.get("code") == "REQUEST_HASH_MISMATCH"
            and _target_is_original()
            and _scene_bytes_are_original()
            and _ledger_state("switchy-hash-tamper-001") == null
            and not _evidence_exists("switchy-hash-tamper-001")
        )

        var expired_envelope := _build_envelope(
            "node.rename",
            {
                "node_path": str(TARGET_NODE),
                "new_name": "BoardTitlePilotExpired",
                "save_mode": "KEEP_DIRTY",
            },
            adversarial_observation,
            "switchy-rename-expired-001",
        )
        expired_envelope["approval"]["expires_at"] = "2000-01-01T00:00:00Z"
        expired_submit = submit_validated_operation(expired_envelope)
        expired_approval_block_pass = (
            not expired_submit.get("ok", false)
            and expired_submit.get("code") == "APPROVAL_EXPIRED"
            and _target_is_original()
            and _scene_bytes_are_original()
            and _ledger_state("switchy-rename-expired-001") == null
            and not _evidence_exists("switchy-rename-expired-001")
        )

        var binding_envelope := _build_envelope(
            "node.rename",
            {
                "node_path": str(TARGET_NODE),
                "new_name": "BoardTitlePilotBinding",
                "save_mode": "KEEP_DIRTY",
            },
            adversarial_observation,
            "switchy-rename-binding-001",
        )
        binding_envelope["approval"]["token_binding"]["policy"]["rollback_policy"] = "MANUAL"
        binding_submit = submit_validated_operation(binding_envelope)
        approval_binding_block_pass = (
            not binding_submit.get("ok", false)
            and binding_submit.get("code") == "APPROVAL_BINDING_MISMATCH"
            and _target_is_original()
            and _scene_bytes_are_original()
            and _ledger_state("switchy-rename-binding-001") == null
            and not _evidence_exists("switchy-rename-binding-001")
        )

    var batch_result: Dictionary = await _run_bounded_batch(adversarial_ready)
    var queue_capacity_pass: bool = batch_result.get("queue_capacity_pass", false)
    var batch_64_pass: bool = batch_result.get("batch_64_pass", false)
    var batch_64_completed: int = int(batch_result.get("batch_64_completed", 0))
    var batch_64_elapsed_usec: int = int(batch_result.get("batch_64_elapsed_usec", 0))

    var result_hash_pass: bool = (
        _valid_result_hash(inspect_result)
        and _valid_result_hash(dirty_result)
        and _valid_result_hash(saved_result)
        and _valid_result_hash(stale_result)
    )
    var ledger_states := [
        _ledger_state("switchy-rename-dirty-001"),
        _ledger_state("switchy-rename-save-001"),
    ]
    var final_restore: Dictionary = await _restore_original_scene()
    temporary_scene_byte_restore_pass = (
        temporary_scene_byte_restore_pass
        and final_restore.get("ok", false)
        and _target_is_original()
        and _scene_bytes_are_original()
    )

    var passed: bool = (
        scene_inspect_pass
        and dirty_rename_pass
        and dirty_undo_pass
        and saved_rename_pass
        and saved_undo_restore_pass
        and stale_state_block_pass
        and request_hash_block_pass
        and expired_approval_block_pass
        and approval_binding_block_pass
        and result_hash_pass
        and queue_capacity_pass
        and batch_64_pass
        and temporary_scene_byte_restore_pass
        and ledger_states == ["COMPLETED", "COMPLETED"]
        and network_listener_enabled == false
    )

    _finish({
        "status": "PASS" if passed else "FAIL",
        "code": "OK" if passed else "PILOT_ASSERTION_FAILED",
        "engine_version": Engine.get_version_info().get("string", ""),
        "editor_instance_id": editor_instance_id(),
        "scene_inspect_pass": scene_inspect_pass,
        "dirty_rename_pass": dirty_rename_pass,
        "dirty_undo_pass": dirty_undo_pass,
        "saved_rename_pass": saved_rename_pass,
        "saved_undo_restore_pass": saved_undo_restore_pass,
        "stale_state_block_pass": stale_state_block_pass,
        "request_hash_block_pass": request_hash_block_pass,
        "expired_approval_block_pass": expired_approval_block_pass,
        "approval_binding_block_pass": approval_binding_block_pass,
        "result_hash_pass": result_hash_pass,
        "queue_capacity_pass": queue_capacity_pass,
        "batch_64_pass": batch_64_pass,
        "temporary_scene_byte_restore_pass": temporary_scene_byte_restore_pass,
        "saved_scene_sha256": saved_scene_sha256,
        "original_scene_sha256": _original_scene_sha256,
        "restored_scene_sha256": _evidence.sha256_file(TARGET_SCENE),
        "ledger_states": ledger_states,
        "batch_64_completed": batch_64_completed,
        "batch_64_elapsed_usec": batch_64_elapsed_usec,
        "network_listener_enabled": network_listener_enabled,
        "elapsed_usec": Time.get_ticks_usec() - _pilot_started_usec,
        "inspect_code": inspect_result.get("code"),
        "dirty_rename_code": dirty_result.get("code"),
        "saved_rename_code": saved_result.get("code"),
        "stale_code": stale_result.get("code"),
        "request_hash_code": hash_submit.get("code"),
        "expired_approval_code": expired_submit.get("code"),
        "approval_binding_code": binding_submit.get("code"),
        "production_adapter_ready": false,
    })


func _undo_to_original() -> bool:
    var root := EditorInterface.get_edited_scene_root()
    if root == null:
        return false
    var history_id := get_undo_redo().get_object_history_id(root)
    var history := get_undo_redo().get_history_undo_redo(history_id)
    if history == null or not history.has_undo():
        return false
    history.undo()
    await get_tree().process_frame
    return _target_is_original() and _scene_bytes_are_original()


func _restore_original_scene() -> Dictionary:
    var root := EditorInterface.get_edited_scene_root()
    if root == null or str(root.scene_file_path) != TARGET_SCENE:
        return {"ok": false, "code": "RESTORE_SCENE_MISSING"}

    if not _target_is_original():
        var history_id := get_undo_redo().get_object_history_id(root)
        var history := get_undo_redo().get_history_undo_redo(history_id)
        if history == null or not history.has_undo():
            return {"ok": false, "code": "RESTORE_UNDO_UNAVAILABLE"}
        history.undo()
        await get_tree().process_frame

    if not _target_is_original():
        return {"ok": false, "code": "RESTORE_TARGET_MISMATCH"}

    EditorInterface.mark_scene_as_unsaved()
    var save_error := EditorInterface.save_scene()
    if save_error != OK:
        return {"ok": false, "code": "RESTORE_SAVE_FAILED"}
    EditorInterface.get_resource_filesystem().update_file(TARGET_SCENE)
    await get_tree().process_frame
    var restored_hash = _evidence.sha256_file(TARGET_SCENE)
    return {
        "ok": restored_hash == _original_scene_sha256,
        "code": "RESTORED" if restored_hash == _original_scene_sha256 else "RESTORE_HASH_MISMATCH",
        "restored_scene_sha256": restored_hash,
    }


func _run_bounded_batch(enabled: bool) -> Dictionary:
    if not enabled:
        return {
            "queue_capacity_pass": false,
            "batch_64_pass": false,
            "batch_64_completed": 0,
            "batch_64_elapsed_usec": 0,
        }
    var observation: Dictionary = _probe.observe(
        get_editor_interface(),
        get_undo_redo(),
        NodePath("."),
    )
    var operation_ids: Array[String] = []
    var queue_capacity_pass := true
    var started_usec := Time.get_ticks_usec()
    for index in range(BATCH_SIZE):
        var operation_id := "switchy-batch-%03d" % index
        var submitted := submit_validated_operation(
            _build_envelope("scene.inspect", {}, observation, operation_id)
        )
        if not submitted.get("ok", false):
            queue_capacity_pass = false
        operation_ids.append(operation_id)
    var overflow := submit_validated_operation(
        _build_envelope("scene.inspect", {}, observation, "switchy-batch-overflow")
    )
    queue_capacity_pass = (
        queue_capacity_pass
        and not overflow.get("ok", false)
        and overflow.get("code") == "QUEUE_FULL"
    )

    var completed := 0
    var batch_pass := true
    for _frame_index in range(BATCH_SIZE + 60):
        await get_tree().process_frame
        var pending := operation_ids.duplicate()
        for operation_id in pending:
            var result := take_completed_result(operation_id)
            if result.is_empty():
                continue
            operation_ids.erase(operation_id)
            completed += 1
            if not result.get("success", false) or not _valid_result_hash(result):
                batch_pass = false
        if operation_ids.is_empty():
            break
    return {
        "queue_capacity_pass": queue_capacity_pass,
        "batch_64_pass": batch_pass and operation_ids.is_empty() and completed == BATCH_SIZE,
        "batch_64_completed": completed,
        "batch_64_elapsed_usec": Time.get_ticks_usec() - started_usec,
    }


func _submit_and_wait(envelope: Dictionary) -> Dictionary:
    var submitted := submit_validated_operation(envelope)
    if not submitted.get("ok", false):
        return _failure_result(str(submitted.get("code", "SUBMIT_FAILED")))
    var operation_id := str(envelope["operation_id"])
    for _index in range(120):
        await get_tree().process_frame
        var result := take_completed_result(operation_id)
        if not result.is_empty():
            return result
    return _failure_result("PILOT_RESULT_TIMEOUT")


func _build_envelope(
    capability_id: String,
    arguments: Dictionary,
    observation: Dictionary,
    operation_id: String,
) -> Dictionary:
    var capability := _capability(capability_id)
    var preconditions := {
        "expected_target_revision": observation.get("target_revision"),
        "observed_target_revision": observation.get("target_revision"),
        "expected_target_content_sha256": observation.get("target_content_sha256"),
        "observed_target_content_sha256": observation.get("target_content_sha256"),
        "expected_dirty_state": observation.get("dirty_state"),
        "observed_dirty_state": observation.get("dirty_state"),
        "expected_scene_path": observation.get("scene_path"),
        "observed_scene_path": observation.get("scene_path"),
        "conflict_policy": "FAIL_CLOSED",
    }
    var policy := {
        "effect_kind": capability.get("effect_kind"),
        "idempotency": capability.get("idempotency"),
        "approval_policy": capability.get("approval_policy"),
        "execution_mode": capability.get("execution_mode"),
        "rollback_policy": capability.get("rollback_policy"),
    }
    var snapshot := {
        "contract_version": _manifest.get("contract_version"),
        "adapter_version": _manifest.get("adapter_version"),
        "catalog_sha256": _manifest.get("catalog", {}).get("sha256"),
        "capability_input_schema_sha256": capability.get("input_schema_sha256"),
        "capability_output_schema_sha256": capability.get("output_schema_sha256"),
        "protocol_profile": _manifest.get("transport", {}).get("protocol_profile"),
        "protocol_version": _manifest.get("transport", {}).get("protocol_version"),
    }
    var instance_identity := {
        "automation_service_instance_id": SERVICE_INSTANCE_ID,
        "editor_instance_id": editor_instance_id(),
        "runtime_session_id": null,
        "runtime_session_state": "NOT_APPLICABLE",
    }
    var envelope := {
        "schema_version": 2,
        "artifact_role": "GODOT_LIVE_EDITOR_OPERATION_ENVELOPE",
        "operation_id": operation_id,
        "capability_id": capability_id,
        "project_identity": _manifest.get("project_identity", {}).duplicate(true),
        "instance_identity": instance_identity,
        "contract_snapshot": snapshot,
        "policy": policy,
        "request": {"arguments": arguments.duplicate(true)},
        "request_hash": "",
        "idempotency_key": operation_id if capability_id == "node.rename" else null,
        "preconditions": preconditions,
        "approval": {
            "state": "NOT_REQUIRED",
            "token_id": null,
            "token_binding": null,
            "expires_at": null,
            "consumed_by_operation_id": null,
        },
        "task": {
            "task_id": null,
            "state": "NOT_APPLICABLE",
            "created_at": null,
            "last_updated_at": null,
            "ttl_ms": null,
            "poll_interval_ms": null,
            "cancellation_policy": "NOT_SUPPORTED",
            "result_binding": null,
        },
        "result": {
            "success": false,
            "code": "NOT_RUN",
            "message": "Not executed.",
            "data": {},
            "result_hash": _guard.canonical_json_sha256({}),
            "evidence": [],
        },
    }
    _refresh_request_security(envelope, capability)
    return envelope


func _refresh_request_security(envelope: Dictionary, capability: Dictionary) -> void:
    var request_hash: String = _guard.canonical_json_sha256(
        _guard.operation_request_material(envelope)
    )
    envelope["request_hash"] = request_hash
    if capability.get("approval_policy") == "REQUIRED":
        envelope["approval"] = {
            "state": "APPROVED",
            "token_id": "token-%s" % envelope["operation_id"],
            "token_binding": {
                "operation_id": envelope["operation_id"],
                "capability_id": envelope["capability_id"],
                "project_identity": envelope["project_identity"].duplicate(true),
                "instance_identity": envelope["instance_identity"].duplicate(true),
                "contract_snapshot": envelope["contract_snapshot"].duplicate(true),
                "policy": envelope["policy"].duplicate(true),
                "request_hash": request_hash,
                "preconditions": envelope["preconditions"].duplicate(true),
            },
            "expires_at": "2099-01-01T00:00:00Z",
            "consumed_by_operation_id": envelope["operation_id"],
        }


func _valid_result_hash(result: Dictionary) -> bool:
    var expected: String = _guard.canonical_json_sha256(result.get("data", {}))
    return str(result.get("result_hash", "")) == expected and expected.length() == 64


func _capability(capability_id: String) -> Dictionary:
    for value in _manifest.get("capabilities", []):
        if value is Dictionary and value.get("capability_id") == capability_id:
            return value
    return {}


func _target_is_original() -> bool:
    var root := EditorInterface.get_edited_scene_root()
    return (
        root != null
        and root.get_node_or_null(TARGET_NODE) != null
        and str(root.get_node(TARGET_NODE).name) == ORIGINAL_NAME
    )


func _scene_bytes_are_original() -> bool:
    return _evidence.sha256_file(TARGET_SCENE) == _original_scene_sha256


func _ledger_state(operation_id: String) -> Variant:
    return _ledger.read_record(operation_id).get("state")


func _evidence_exists(operation_id: String) -> bool:
    return FileAccess.file_exists(
        "res://artifacts/godot-live-editor/evidence/%s.json" % operation_id
    )


func _load_json(path: String) -> Dictionary:
    var file := FileAccess.open(path, FileAccess.READ)
    if file == null:
        return {}
    var parsed = JSON.parse_string(file.get_as_text())
    return parsed if parsed is Dictionary else {}


func _failure_result(code: String) -> Dictionary:
    var data := {}
    return {
        "success": false,
        "code": code,
        "message": code,
        "data": data,
        "result_hash": _guard.canonical_json_sha256(data),
        "evidence": [],
    }


func _failure_payload(code: String) -> Dictionary:
    return {
        "status": "FAIL",
        "code": code,
        "scene_inspect_pass": false,
        "dirty_rename_pass": false,
        "dirty_undo_pass": false,
        "saved_rename_pass": false,
        "saved_undo_restore_pass": false,
        "stale_state_block_pass": false,
        "request_hash_block_pass": false,
        "expired_approval_block_pass": false,
        "approval_binding_block_pass": false,
        "result_hash_pass": false,
        "queue_capacity_pass": false,
        "batch_64_pass": false,
        "temporary_scene_byte_restore_pass": false,
        "network_listener_enabled": network_listener_enabled,
        "production_adapter_ready": false,
        "elapsed_usec": Time.get_ticks_usec() - _pilot_started_usec,
    }


func _finish(payload: Dictionary) -> void:
    var absolute := ProjectSettings.globalize_path(RESULT_PATH)
    DirAccess.make_dir_recursive_absolute(absolute.get_base_dir())
    var file := FileAccess.open(absolute, FileAccess.WRITE)
    if file != null:
        file.store_string(JSON.stringify(payload, "  ") + "\n")
        file.flush()
        file.close()
    get_tree().quit()
