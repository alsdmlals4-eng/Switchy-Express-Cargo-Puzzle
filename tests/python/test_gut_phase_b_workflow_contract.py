from __future__ import annotations

import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
WORKFLOW = ROOT / ".github/workflows/gut-9-7-1-tests.yml"
LEGACY_WORKFLOW = ROOT / ".github/workflows/godot-tests.yml"


class GutPhaseBWorkflowContractTests(unittest.TestCase):
    def test_workflow_is_a_separate_standard_hosted_exact_head_check(self) -> None:
        text = WORKFLOW.read_text(encoding="utf-8")
        self.assertIn("name: GUT 9.7.1 Tests", text)
        self.assertIn("pull_request:", text)
        self.assertIn("push:", text)
        self.assertIn("- main", text)
        self.assertIn("runs-on: ubuntu-latest", text)
        self.assertNotIn("self-hosted", text)
        self.assertNotIn("[skip actions]", text)

    def test_workflow_pins_godot_and_official_gut(self) -> None:
        text = WORKFLOW.read_text(encoding="utf-8")
        self.assertIn("Godot_v4.7.1-stable_linux.x86_64.zip", text)
        self.assertIn("aeb5d4f3f7f0a6c9b5e178876d6c99b791fda605", text)
        self.assertIn("tools/gut_phase_b_guard.py compare", text)
        self.assertIn("addons/gut", text)

    def test_workflow_enforces_snapshot_gut_junit_and_error_gates(self) -> None:
        text = WORKFLOW.read_text(encoding="utf-8")
        self.assertIn("tools/gut_phase_b_guard.py snapshot", text)
        self.assertIn("res://addons/gut/gut_cmdln.gd", text)
        self.assertIn("-gexit", text)
        self.assertIn("test-results/gut/junit.xml", text)
        self.assertIn("tools/gut_phase_b_guard.py junit", text)
        self.assertIn("--minimum-tests 6", text)
        self.assertIn("tools/gut_phase_b_guard.py verify", text)
        self.assertIn("SCRIPT ERROR:", text)
        self.assertIn("ERROR:", text)

    def test_workflow_always_uploads_junit_and_phase_b_evidence(self) -> None:
        text = WORKFLOW.read_text(encoding="utf-8")
        self.assertIn("name: gut-junit", text)
        self.assertIn("name: gut-phase-b-evidence", text)
        self.assertGreaterEqual(text.count("if: always()"), 2)

    def test_legacy_godot_runner_remains_unchanged_in_scope(self) -> None:
        text = LEGACY_WORKFLOW.read_text(encoding="utf-8")
        self.assertIn("--script res://tests/run_tests.gd", text)
        self.assertNotIn("gut_cmdln.gd", text)


if __name__ == "__main__":
    unittest.main()
