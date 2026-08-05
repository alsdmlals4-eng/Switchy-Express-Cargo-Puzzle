@tool
extends "plugin_exact_restore.gd"

const STABLE_OBSERVATION_FRAMES := 3
const STABLE_OBSERVATION_ATTEMPTS := 30

var _stable_observation_pass := false
var _batch_failure_codes: Array[String] = []
var _batch_observation_revision := ""


func _restore_original_scene() -> Dictionary:
    if not _original_scene_bytes.is_empty() and _scene_bytes_are_original():
        var root := EditorInterface.get_edited_scene_root()
        if root == null or str(root.scene_file_path) != TARGET_SCENE:
            EditorInterface.open_scene_from_path(TARGET_SCENE)
            await get_tree().process_frame
            await get_tree().process_frame
            root = EditorInterface.get_edited_scene_root()
        if (
            root != null
            and str(root.scene_file_path) == TARGET_SCENE
            and root.get_node_or_null(TARGET_NODE) != null
            and str(root.get_node(TARGET_NODE).name) == ORIGINAL_NAME
        ):
            return _restore_result(
                true,
                "FINAL_REOPENED_FROM_ORIGINAL_BYTES",
                _evidence.sha256_file(TARGET_SCENE),
            )
    return await super._restore_original_scene()


func _wait_for_stable_observation() -> Dictionary:
    var previous_key := ""
    var stable_frames := 0
    var last_observation: Dictionary = {}
    for _attempt in range(STABLE_OBSERVATION_ATTEMPTS):
        var root := EditorInterface.get_edited_scene_root()
        if root == null or str(root.scene_file_path) != TARGET_SCENE:
            EditorInterface.open_scene_from_path(TARGET_SCENE)
            await get_tree().process_frame
            await get_tree().process_frame
        var observation: Dictionary = _probe.observe(
            get_editor_interface(),
            get_undo_redo(),
            NodePath("."),
        )
        if observation.has("error"):
            previous_key = ""
            stable_frames = 0
            await get_tree().process_frame
            continue
        last_observation = observation
        var key := JSON.stringify({
            "scene_path": observation.get("scene_path"),
            "dirty_state": observation.get("dirty_state"),
            "target_revision": observation.get("target_revision"),
            "target_content_sha256": observation.get("target_content_sha256"),
        })
        if key == previous_key:
            stable_frames += 1
        else:
            previous_key = key
            stable_frames = 1
        if stable_frames >= STABLE_OBSERVATION_FRAMES:
            return {
                "ok": true,
                "code": "STABLE",
                "observation": observation,
            }
        await get_tree().process_frame
    return {
        "ok": false,
        "code": "BATCH_STATE_NOT_STABLE",
        "observation": last_observation,
    }


func _run_bounded_batch(enabled: bool) -> Dictionary:
    _batch_failure_codes.clear()
    _batch_observation_revision = ""
    _stable_observation_pass = false
    if not enabled:
        return {
            "queue_capacity_pass": false,
            "batch_64_pass": false,
            "batch_64_completed": 0,
            "batch_64_elapsed_usec": 0,
        }

    var stable: Dictionary = await _wait_for_stable_observation()
    _stable_observation_pass = stable.get("ok", false)
    if not _stable_observation_pass:
        _batch_failure_codes.append(str(stable.get("code", "BATCH_STATE_NOT_STABLE")))
        return {
            "queue_capacity_pass": false,
            "batch_64_pass": false,
            "batch_64_completed": 0,
            "batch_64_elapsed_usec": 0,
        }

    var observation: Dictionary = stable.get("observation", {})
    _batch_observation_revision = str(observation.get("target_revision", ""))
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
            _batch_failure_codes.append(str(submitted.get("code", "SUBMIT_FAILED")))
        else:
            operation_ids.append(operation_id)

    var overflow := submit_validated_operation(
        _build_envelope("scene.inspect", {}, observation, "switchy-batch-overflow")
    )
    queue_capacity_pass = (
        queue_capacity_pass
        and not overflow.get("ok", false)
        and overflow.get("code") == "QUEUE_FULL"
    )
    if overflow.get("code") != "QUEUE_FULL":
        _batch_failure_codes.append(str(overflow.get("code", "OVERFLOW_ACCEPTED")))

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
            if not result.get("success", false):
                batch_pass = false
                _batch_failure_codes.append(str(result.get("code", "BATCH_RESULT_FAILED")))
            elif not _valid_result_hash(result):
                batch_pass = false
                _batch_failure_codes.append("RESULT_HASH_MISMATCH")
        if operation_ids.is_empty():
            break

    if not operation_ids.is_empty():
        _batch_failure_codes.append("BATCH_RESULT_TIMEOUT")
    return {
        "queue_capacity_pass": queue_capacity_pass,
        "batch_64_pass": (
            batch_pass
            and operation_ids.is_empty()
            and completed == BATCH_SIZE
            and _batch_failure_codes.is_empty()
        ),
        "batch_64_completed": completed,
        "batch_64_elapsed_usec": Time.get_ticks_usec() - started_usec,
    }


func _finish(payload: Dictionary) -> void:
    payload["stable_observation_pass"] = _stable_observation_pass
    payload["batch_failure_codes"] = _batch_failure_codes.duplicate()
    payload["batch_observation_revision"] = _batch_observation_revision
    super._finish(payload)
