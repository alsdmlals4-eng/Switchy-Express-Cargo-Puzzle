from __future__ import annotations

import importlib.util
import sys
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
RUNNER = ROOT / "tools/run_switchy_godot_live_editor_pilot.py"


def _load_runner():
    spec = importlib.util.spec_from_file_location("switchy_pilot_runner_errors", RUNNER)
    if spec is None or spec.loader is None:
        raise RuntimeError("runner unavailable")
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


class SwitchyGodotLiveEditorPilotRunnerErrorTests(unittest.TestCase):
    def test_exact_headless_dummy_thumbnail_error_is_classified_separately(self) -> None:
        runner = _load_runner()
        output = "\n".join(
            (
                'ERROR: Parameter "t" is null.',
                "   at: texture_2d_get (./servers/rendering/dummy/storage/texture_storage.h:110)",
                "   GDScript backtrace (most recent call first):",
                "       [0] execute (res://addons/base_live_editor_adapter/editor_transaction_executor.gd:103)",
            )
        )
        self.assertEqual([], runner._unexpected_godot_errors(output))
        self.assertEqual(1, runner._headless_thumbnail_error_count(output))

    def test_other_error_is_still_fatal(self) -> None:
        runner = _load_runner()
        output = "ERROR: Scene save failed.\n   at: save_scene (editor/editor_node.cpp:1)"
        self.assertEqual(["ERROR: Scene save failed."], runner._unexpected_godot_errors(output))
        self.assertEqual(0, runner._headless_thumbnail_error_count(output))

    def test_script_error_is_always_fatal_even_with_known_headless_error(self) -> None:
        runner = _load_runner()
        output = "\n".join(
            (
                'ERROR: Parameter "t" is null.',
                "   at: texture_2d_get (./servers/rendering/dummy/storage/texture_storage.h:110)",
                "SCRIPT ERROR: Invalid call.",
            )
        )
        self.assertIn("SCRIPT ERROR: Invalid call.", runner._unexpected_godot_errors(output))
        self.assertEqual(1, runner._headless_thumbnail_error_count(output))

    def test_similar_error_without_exact_dummy_renderer_location_is_fatal(self) -> None:
        runner = _load_runner()
        output = "\n".join(
            (
                'ERROR: Parameter "t" is null.',
                "   at: texture_2d_get (servers/rendering/renderer_rd/storage_rd/texture_storage.cpp:110)",
            )
        )
        self.assertEqual(
            ['ERROR: Parameter "t" is null.'],
            runner._unexpected_godot_errors(output),
        )
        self.assertEqual(0, runner._headless_thumbnail_error_count(output))

    def test_failure_report_can_preserve_bounded_runtime_diagnostics(self) -> None:
        runner = _load_runner()
        diagnostics = {
            "editor_runtime": {
                "status": "FAIL",
                "code": "RESTORE_HASH_MISMATCH",
                "original_scene_sha256": "a" * 64,
                "restored_scene_sha256": "b" * 64,
            }
        }
        payload = runner._failure(
            "RUNTIME_RESULT_INVALID",
            detail="restore mismatch",
            diagnostics=diagnostics,
        )
        self.assertEqual(diagnostics, payload["diagnostics"])
        self.assertFalse(payload["production_adapter_ready"])


if __name__ == "__main__":
    unittest.main()
