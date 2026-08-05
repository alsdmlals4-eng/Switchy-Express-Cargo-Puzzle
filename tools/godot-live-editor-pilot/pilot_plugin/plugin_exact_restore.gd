@tool
extends "plugin.gd"

var _original_scene_bytes := PackedByteArray()
var _restore_codes: Array[String] = []


func _enter_tree() -> void:
    _original_scene_bytes = FileAccess.get_file_as_bytes(
        ProjectSettings.globalize_path(TARGET_SCENE)
    )
    super._enter_tree()


func _restore_original_scene() -> Dictionary:
    var root := EditorInterface.get_edited_scene_root()
    if root == null or str(root.scene_file_path) != TARGET_SCENE:
        return _restore_result(false, "RESTORE_SCENE_MISSING", null)
    if _original_scene_bytes.is_empty():
        return _restore_result(false, "RESTORE_SOURCE_BYTES_MISSING", null)

    if _target_is_original() and _scene_bytes_are_original():
        return _restore_result(
            true,
            "ALREADY_RESTORED",
            _evidence.sha256_file(TARGET_SCENE),
        )

    if not _target_is_original():
        var history_id := get_undo_redo().get_object_history_id(root)
        var history := get_undo_redo().get_history_undo_redo(history_id)
        if history == null or not history.has_undo():
            return _restore_result(false, "RESTORE_UNDO_UNAVAILABLE", null)
        history.undo()
        await get_tree().process_frame

    if not _target_is_original():
        return _restore_result(false, "RESTORE_TARGET_MISMATCH", null)

    EditorInterface.mark_scene_as_unsaved()
    var save_error := EditorInterface.save_scene()
    if save_error != OK:
        return _restore_result(false, "RESTORE_SAVE_FAILED", null)
    EditorInterface.get_resource_filesystem().update_file(TARGET_SCENE)
    await get_tree().process_frame

    var saved_hash = _evidence.sha256_file(TARGET_SCENE)
    if saved_hash == _original_scene_sha256:
        return _restore_result(true, "RESTORED_BY_EDITOR_SAVE", saved_hash)

    var absolute_path := ProjectSettings.globalize_path(TARGET_SCENE)
    var file := FileAccess.open(absolute_path, FileAccess.WRITE)
    if file == null:
        return _restore_result(false, "RESTORE_BYTE_WRITE_OPEN_FAILED", saved_hash)
    file.store_buffer(_original_scene_bytes)
    file.flush()
    file.close()

    EditorInterface.get_resource_filesystem().update_file(TARGET_SCENE)
    EditorInterface.open_scene_from_path(TARGET_SCENE)
    await get_tree().process_frame
    await get_tree().process_frame

    var restored_hash = _evidence.sha256_file(TARGET_SCENE)
    var restored_root := EditorInterface.get_edited_scene_root()
    var restored_target_ok := (
        restored_root != null
        and str(restored_root.scene_file_path) == TARGET_SCENE
        and restored_root.get_node_or_null(TARGET_NODE) != null
        and str(restored_root.get_node(TARGET_NODE).name) == ORIGINAL_NAME
    )
    return _restore_result(
        restored_target_ok and restored_hash == _original_scene_sha256,
        "TEMPORARY_RESTORE_BYTE_WRITE"
        if restored_target_ok and restored_hash == _original_scene_sha256
        else "RESTORE_HASH_MISMATCH",
        restored_hash,
    )


func _restore_result(ok: bool, code: String, restored_hash: Variant) -> Dictionary:
    _restore_codes.append(code)
    return {
        "ok": ok,
        "code": code,
        "restored_scene_sha256": restored_hash,
    }


func _finish(payload: Dictionary) -> void:
    payload["restore_code"] = (
        _restore_codes[0] if not _restore_codes.is_empty() else "NOT_RUN"
    )
    payload["final_restore_code"] = (
        _restore_codes[-1] if not _restore_codes.is_empty() else "NOT_RUN"
    )
    payload["original_scene_byte_count"] = _original_scene_bytes.size()
    super._finish(payload)
