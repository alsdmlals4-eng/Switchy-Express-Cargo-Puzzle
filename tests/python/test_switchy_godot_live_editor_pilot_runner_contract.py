from __future__ import annotations

import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
RUNNER = ROOT / "tools/run_switchy_godot_live_editor_pilot.py"


class SwitchyGodotLiveEditorPilotRunnerContractTests(unittest.TestCase):
    maxDiff = None

    def test_runner_exists_and_declares_stable_codes(self) -> None:
        self.assertTrue(RUNNER.is_file(), f"missing {RUNNER.relative_to(ROOT)}")
        source = RUNNER.read_text(encoding="utf-8")
        for code in (
            "GODOT_BIN_REQUIRED",
            "GODOT_BIN_NOT_FOUND",
            "GODOT_VERSION_MISMATCH",
            "MATERIALIZATION_FAILED",
            "RUNTIME_TIMEOUT",
            "RUNTIME_RESULT_MISSING",
            "RUNTIME_RESULT_INVALID",
            "PROJECT_REGRESSION_FAILED",
            "SOURCE_INTEGRITY_FAILURE",
        ):
            with self.subTest(code=code):
                self.assertIn(code, source)

    def test_runner_uses_exact_bounded_editor_and_regression_commands(self) -> None:
        self.assertTrue(RUNNER.is_file(), f"missing {RUNNER.relative_to(ROOT)}")
        source = RUNNER.read_text(encoding="utf-8")
        for marker in (
            '"--version"',
            '"4.7.1"',
            '"--editor"',
            '"--headless"',
            '"--quit-after"',
            '"900"',
            "timeout=240",
            '"--script"',
            '"res://tests/run_tests.gd"',
            "timeout=60",
            "TEST SUMMARY: cases=",
        ):
            with self.subTest(marker=marker):
                self.assertIn(marker, source)

    def test_runner_rehashes_source_and_rejects_godot_error_markers(self) -> None:
        self.assertTrue(RUNNER.is_file(), f"missing {RUNNER.relative_to(ROOT)}")
        source = RUNNER.read_text(encoding="utf-8")
        for marker in (
            "protected_inventory",
            "SCRIPT ERROR:",
            "line.startswith(\"ERROR:\")",
            "temporary_scene_byte_restore_pass",
            "project_regression_pass",
            "source_integrity_pass",
            "production_adapter_ready",
        ):
            with self.subTest(marker=marker):
                self.assertIn(marker, source)

    def test_runner_never_uses_shell_execution(self) -> None:
        self.assertTrue(RUNNER.is_file(), f"missing {RUNNER.relative_to(ROOT)}")
        source = RUNNER.read_text(encoding="utf-8")
        for forbidden in ("shell=True", "os.system(", "eval(", "exec("):
            with self.subTest(forbidden=forbidden):
                self.assertNotIn(forbidden, source)


if __name__ == "__main__":
    unittest.main()
