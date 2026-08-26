from __future__ import annotations

import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
START = ROOT / "기획서/00_프로젝트_허브/START_HERE.md"
ACTIVE = ROOT / "기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md"
DECISIONS = ROOT / "기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md"
ADAPTER = ROOT / "PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md"
POST_060_POINTER = ROOT / "evidence/acceptance/post_sx_dec_060_candidate.json"
POST_060_LAUNCHER = ROOT / "RUN_SX60_POC_SELF_RUN.ps1"


class Candidate003PostmergeCanonTests(unittest.TestCase):
    def _text(self, path: Path) -> str:
        self.assertTrue(path.is_file(), f"missing canonical owner: {path}")
        return path.read_text(encoding="utf-8")

    def test_start_here_bounds_candidate_003_as_pre_change_history(self) -> None:
        text = self._text(START)
        for required in (
            "SX-DEC-060",
            "SX59-POC-ACCEPT-003",
            "HISTORICAL_EXACT_BYTES_ONLY",
            "post-060 candidate",
            "NOT_CREATED",
        ):
            self.assertIn(required, text)
        self.assertNotIn("current_candidate: SX59-POC-ACCEPT-003", text)

    def test_active_context_preserves_003_evidence_without_current_promotion(self) -> None:
        text = self._text(ACTIVE)
        for required in (
            "pre_sx_dec_060_candidate: SX59-POC-ACCEPT-003",
            "candidate_003_role_after_sx_dec_060: HISTORICAL_EXACT_BYTES_ONLY",
            "candidate_003_physical_visual_recheck: NOT_RUN",
            "post_sx_dec_060_candidate: NOT_CREATED",
            "SX_DEC_060_CODEX_HANDOFF_PACKAGE.md",
        ):
            self.assertIn(required, text)
        self.assertNotIn("current_candidate: SX59-POC-ACCEPT-003", text)

    def test_decision_owner_retains_historical_evidence_and_current_span(self) -> None:
        text = self._text(DECISIONS)
        for required in (
            "pre_sx_dec_060_candidate: SX59-POC-ACCEPT-003",
            "role_after_sx_dec_060: HISTORICAL_PRE_CHANGE_EVIDENCE_ONLY",
            "candidate_003_physical_visual_recheck: NOT_RUN",
            "sx_dec_060_post_change_candidate: NOT_CREATED",
            "current_decision_span: SX-DEC-027~060",
            "SX-DEC-060",
        ):
            self.assertIn(required, text)
        self.assertNotIn("current_candidate: SX59-POC-ACCEPT-003", text)
        self.assertNotIn("current_decision_span: SX-DEC-027~059", text)

    def test_live_base_authority_is_dynamic_not_a_stale_current_sha_pin(self) -> None:
        active = self._text(ACTIVE)
        decisions = self._text(DECISIONS)
        for text in (active, decisions):
            self.assertIn("ALWAYS_REFETCH_CURRENT_COMPLETED_MAIN", text)
            self.assertNotIn("base_latest_observed:", text)
        self.assertIn("base_canon_sync_observation:", decisions)
        self.assertIn("AUDIT_EVIDENCE_ONLY", decisions)
        self.assertIn("project_live_main_policy: REFRESH_FROM_GITHUB_BEFORE_EXECUTION", active)
        self.assertNotIn("current_main:", active)

    def test_candidate_003_has_no_post_060_current_pointer_or_launcher_route(self) -> None:
        self.assertTrue(POST_060_POINTER.is_file())
        self.assertTrue(POST_060_LAUNCHER.is_file())
        pointer = POST_060_POINTER.read_text(encoding="utf-8")
        launcher = POST_060_LAUNCHER.read_text(encoding="ascii")
        self.assertIn('\"candidate_status\": \"NOT_CREATED\"', pointer)
        self.assertIn('\"current_candidate_id\": null', pointer)
        self.assertIn("HISTORICAL_EXACT_BYTES_ONLY", pointer)
        self.assertNotIn("SX59-POC-ACCEPT-003", launcher)
        self.assertIn("POST_SX_DEC_060_CANDIDATE_NOT_CREATED", launcher)
        adapter = ADAPTER.read_text(encoding="utf-8")
        self.assertIn("evidence/acceptance/post_sx_dec_060_candidate.json", adapter)
        self.assertIn("only when Candidate 003 pre-060 provenance is needed", adapter)
        self.assertNotIn(
            "current_poc_candidate.json` when acceptance identity matters",
            adapter,
        )


if __name__ == "__main__":
    unittest.main()
