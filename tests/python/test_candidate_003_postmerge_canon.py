from __future__ import annotations

import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
START = ROOT / "기획서/00_프로젝트_허브/START_HERE.md"
ACTIVE = ROOT / "기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md"
DECISIONS = ROOT / "기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md"


class Candidate003PostmergeCanonTests(unittest.TestCase):
    def _text(self, path: Path) -> str:
        self.assertTrue(path.is_file(), f"missing canonical owner: {path}")
        return path.read_text(encoding="utf-8")

    def test_start_here_routes_current_manual_gate_to_candidate_003(self) -> None:
        text = self._text(START)
        for required in (
            "SX59-POC-ACCEPT-003",
            "evidence/acceptance/current_poc_candidate.json",
            "SX_DEC_059_POC_ACCEPTANCE_CANDIDATE_03.md",
            "SX_DEC_059_POC_DEVELOPER_SELF_RUN_RECORD_03.md",
            "Candidate 002",
            "BLOCKED_BY_CONFIRMED_P1_PREFLIGHT_VISUAL_DEFECTS",
            "PR #171",
            "PR #172",
            "2521f3be600ea950f9893ce45940604c2d0ac88a",
            "physical visual recheck",
        ):
            self.assertIn(required, text)
        self.assertNotIn(
            "Current POC candidate | `SX59-POC-ACCEPT-002 · PREPARED · PENDING_DEVELOPER_SELF_RUN`",
            text,
        )

    def test_active_context_preserves_002_startup_and_routes_003_gate_zero(self) -> None:
        text = self._text(ACTIVE)
        for required in (
            "current_candidate: SX59-POC-ACCEPT-003",
            "candidate_002_windows_physical_startup_smoke: PASS",
            "candidate_002_result: BLOCKED_BY_CONFIRMED_P1_PREFLIGHT_VISUAL_DEFECTS",
            "current_candidate_pointer: evidence/acceptance/current_poc_candidate.json",
            "candidate_003_physical_visual_recheck: NOT_RUN",
            "SX_DEC_059_POC_ACCEPTANCE_CANDIDATE_03.md",
            "SX_DEC_059_POC_DEVELOPER_SELF_RUN_RECORD_03.md",
            "2521f3be600ea950f9893ce45940604c2d0ac88a",
        ):
            self.assertIn(required, text)
        self.assertNotIn("current_candidate: SX59-POC-ACCEPT-002 · PREPARED", text)

    def test_decision_owner_distinguishes_startup_smoke_from_full_physical_gate(self) -> None:
        text = self._text(DECISIONS)
        for required in (
            "current_candidate: SX59-POC-ACCEPT-003",
            "candidate_002_windows_physical_startup_smoke: PASS",
            "candidate_002_acceptance_promotion: PROHIBITED",
            "candidate_003_physical_visual_recheck: NOT_RUN",
            "windows_full_physical_runtime: NOT_RUN",
            "audio_perceptual_qa: NOT_RUN",
            "evidence/acceptance/current_poc_candidate.json",
            "PR #171",
            "PR #172",
        ):
            self.assertIn(required, text)
        self.assertIn("current_decision_span: SX-DEC-027~059", text)
        self.assertNotIn("SX-DEC-060", text)

    def test_latest_base_observation_is_fresh_without_repinning_product(self) -> None:
        for path in (START, ACTIVE, DECISIONS):
            text = self._text(path)
            self.assertIn("7a8b1c596f9cf1e8da8d2652be076a0624e0b4a2", text)
            self.assertIn("ALWAYS_REFETCH_CURRENT_COMPLETED_MAIN", text)


if __name__ == "__main__":
    unittest.main()
