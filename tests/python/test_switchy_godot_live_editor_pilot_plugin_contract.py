from __future__ import annotations

import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
PLUGIN_ROOT = ROOT / "tools/godot-live-editor-pilot/pilot_plugin"
PLUGIN_CFG = PLUGIN_ROOT / "plugin.cfg"
PLUGIN_GD = PLUGIN_ROOT / "plugin.gd"
EXACT_RESTORE_GD = PLUGIN_ROOT / "plugin_exact_restore.gd"


class SwitchyGodotLiveEditorPilotPluginContractTests(unittest.TestCase):
    maxDiff = None

    def test_plugin_files_exist(self) -> None:
        for path in (PLUGIN_CFG, PLUGIN_GD, EXACT_RESTORE_GD):
            with self.subTest(path=path):
                self.assertTrue(path.is_file(), f"missing {path.relative_to(ROOT)}")
        config = PLUGIN_CFG.read_text(encoding="utf-8")
        self.assertIn('script="plugin_exact_restore.gd"', config)

    def test_plugin_targets_only_the_approved_switchy_scene_and_node(self) -> None:
        self.assertTrue(PLUGIN_GD.is_file(), f"missing {PLUGIN_GD.relative_to(ROOT)}")
        source = PLUGIN_GD.read_text(encoding="utf-8")
        for marker in (
            'const TARGET_SCENE := "res://game/finite/presentation/finite_slice_view.tscn"',
            'const TARGET_NODE := NodePath("Board/BoardTitle")',
            'const ORIGINAL_NAME := "BoardTitle"',
            'const DIRTY_NAME := "BoardTitlePilotDirty"',
            'const SAVED_NAME := "BoardTitlePilotSaved"',
            "const BATCH_SIZE := 64",
        ):
            with self.subTest(marker=marker):
                self.assertIn(marker, source)

    def test_plugin_declares_success_restore_and_adversarial_evidence(self) -> None:
        self.assertTrue(PLUGIN_GD.is_file(), f"missing {PLUGIN_GD.relative_to(ROOT)}")
        source = PLUGIN_GD.read_text(encoding="utf-8")
        for marker in (
            "scene_inspect_pass",
            "dirty_rename_pass",
            "dirty_undo_pass",
            "saved_rename_pass",
            "saved_undo_restore_pass",
            "stale_state_block_pass",
            "request_hash_block_pass",
            "expired_approval_block_pass",
            "approval_binding_block_pass",
            "result_hash_pass",
            "queue_capacity_pass",
            "batch_64_pass",
            "temporary_scene_byte_restore_pass",
            "network_listener_enabled",
            "TARGET_STATE_CONFLICT",
            "REQUEST_HASH_MISMATCH",
            "APPROVAL_EXPIRED",
            "APPROVAL_BINDING_MISMATCH",
            "QUEUE_FULL",
        ):
            with self.subTest(marker=marker):
                self.assertIn(marker, source)

    def test_plugin_has_bounded_restore_and_result_paths(self) -> None:
        self.assertTrue(PLUGIN_GD.is_file(), f"missing {PLUGIN_GD.relative_to(ROOT)}")
        combined = "\n".join(
            path.read_text(encoding="utf-8")
            for path in (PLUGIN_GD, EXACT_RESTORE_GD)
            if path.is_file()
        )
        for marker in (
            "switchy_real_project_pilot_result.json",
            "_restore_original_scene",
            "EditorInterface.save_scene()",
            "get_resource_filesystem().update_file",
            "_evidence.sha256_file(TARGET_SCENE)",
            "production_adapter_ready",
        ):
            with self.subTest(marker=marker):
                self.assertIn(marker, combined)
        for forbidden in (
            "TCPServer",
            "WebSocketPeer",
            "HTTPServer",
            "PacketPeerUDP",
            "Thread.new",
            "OS.execute",
            "GDScript.new",
            "Expression.new",
        ):
            with self.subTest(forbidden=forbidden):
                self.assertNotIn(forbidden, combined)

    def test_plugin_restores_exact_original_bytes_only_for_the_pinned_scene(self) -> None:
        self.assertTrue(
            EXACT_RESTORE_GD.is_file(),
            f"missing {EXACT_RESTORE_GD.relative_to(ROOT)}",
        )
        source = EXACT_RESTORE_GD.read_text(encoding="utf-8")
        for marker in (
            "var _original_scene_bytes := PackedByteArray()",
            "FileAccess.get_file_as_bytes",
            "ProjectSettings.globalize_path(TARGET_SCENE)",
            "file.store_buffer(_original_scene_bytes)",
            "TEMPORARY_RESTORE_BYTE_WRITE",
            "restore_code",
            "final_restore_code",
        ):
            with self.subTest(marker=marker):
                self.assertIn(marker, source)
        self.assertNotIn("FileAccess.open(arguments", source)
        self.assertNotIn("FileAccess.open(envelope", source)


if __name__ == "__main__":
    unittest.main()
