from __future__ import annotations

import json
import os
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
RUNNER = ROOT / "tools/run_switchy_godot_live_editor_pilot.py"

REQUIRED_RUNTIME_FLAGS = (
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
    "source_integrity_pass",
    "temporary_scene_byte_restore_pass",
    "project_regression_pass",
)


class SwitchyGodotLiveEditorPilotRuntimeTests(unittest.TestCase):
    maxDiff = None

    def test_runner_reports_skipped_not_configured_without_godot(self) -> None:
        self.assertTrue(RUNNER.is_file(), f"missing {RUNNER.relative_to(ROOT)}")
        with tempfile.TemporaryDirectory() as temporary:
            report = Path(temporary) / "report.json"
            completed = subprocess.run(
                [sys.executable, str(RUNNER), "--report", str(report)],
                cwd=ROOT,
                capture_output=True,
                text=True,
                timeout=30,
                check=False,
            )
            self.assertEqual(0, completed.returncode, completed.stderr)
            self.assertTrue(report.is_file(), f"missing report; stdout={completed.stdout!r}")
            payload = json.loads(report.read_text(encoding="utf-8"))
            self.assertEqual(
                {
                    "status": "SKIPPED_NOT_CONFIGURED",
                    "code": "GODOT_BIN_REQUIRED",
                    "production_adapter_ready": False,
                },
                payload,
            )

    @unittest.skipUnless(
        os.environ.get("GODOT_BIN"),
        "SKIPPED_NOT_CONFIGURED: set GODOT_BIN to exact Godot 4.7.1 executable",
    )
    def test_actual_switchy_editor_pilot(self) -> None:
        self.assertTrue(RUNNER.is_file(), f"missing {RUNNER.relative_to(ROOT)}")
        with tempfile.TemporaryDirectory() as temporary:
            report = Path(temporary) / "report.json"
            completed = subprocess.run(
                [
                    sys.executable,
                    str(RUNNER),
                    "--godot",
                    os.environ["GODOT_BIN"],
                    "--report",
                    str(report),
                ],
                cwd=ROOT,
                capture_output=True,
                text=True,
                timeout=300,
                check=False,
            )
            self.assertEqual(
                0,
                completed.returncode,
                f"stdout:\n{completed.stdout}\nstderr:\n{completed.stderr}",
            )
            self.assertTrue(report.is_file(), "actual Pilot report missing")
            payload = json.loads(report.read_text(encoding="utf-8"))
            self.assertEqual("PASS", payload.get("status"), payload)
            runtime = payload.get("editor_runtime", {})
            snapshots = runtime.get("undo_diagnostics", [])
            self.assertEqual(["before", "immediate_after", "next_frame"],
                             [item.get("phase") for item in snapshots])
            before, immediate, after = snapshots
            for snapshot in snapshots:
                for key in ("root_instance_id", "history_id", "history_version",
                            "action_index", "history_count", "observed_usec"):
                    self.assertIs(type(snapshot[key]), int, key)
                for key in ("original_target_present", "dirty_target_present",
                            "filesystem_scanning", "unsaved", "history_available",
                            "has_undo", "has_redo"):
                    self.assertIs(type(snapshot[key]), bool, key)
                self.assertIsInstance(snapshot["action_name"], str)
                self.assertEqual("res://game/finite/presentation/finite_slice_view.tscn",
                                 snapshot["scene_path"])
                self.assertRegex(snapshot["scene_sha256"], r"^[0-9a-f]{64}$")
                self.assertEqual(runtime["original_scene_sha256"], snapshot["scene_sha256"])
                self.assertEqual(before["root_instance_id"], snapshot["root_instance_id"])
                self.assertEqual(before["history_id"], snapshot["history_id"])
                self.assertTrue(snapshot["history_available"])
            self.assertTrue(before["dirty_target_present"])
            self.assertFalse(before["original_target_present"])
            self.assertTrue(before["has_undo"])
            self.assertIs(type(immediate["undo_return"]), bool)
            self.assertTrue(immediate["undo_return"])
            self.assertTrue(immediate["original_target_present"])
            self.assertFalse(immediate["dirty_target_present"])
            self.assertTrue(after["original_target_present"])
            self.assertFalse(after["dirty_target_present"])
            self.assertEqual(before["scene_sha256"], after["scene_sha256"])
            self.assertEqual(before["root_instance_id"], after["root_instance_id"])
            self.assertEqual(before["history_id"], after["history_id"])
            self.assertLessEqual(before["observed_usec"], immediate["observed_usec"])
            self.assertLessEqual(immediate["observed_usec"], after["observed_usec"])
            for flag in REQUIRED_RUNTIME_FLAGS:
                with self.subTest(flag=flag):
                    self.assertTrue(runtime.get(flag), payload)
            self.assertFalse(runtime.get("network_listener_enabled"), payload)
            self.assertFalse(payload.get("production_adapter_ready"), payload)


if __name__ == "__main__":
    unittest.main()
