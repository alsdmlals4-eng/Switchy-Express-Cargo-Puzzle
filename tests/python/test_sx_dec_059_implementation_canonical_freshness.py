from __future__ import annotations

import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
IMPLEMENTATION_MERGE_MAIN = "162e8a0a5e8ddc8472e74a6152e87dc12008e34c"

CURRENT_OWNER_FILES = {
    "agents": ROOT / "AGENTS.md",
    "adapter": ROOT / "PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.7_SWITCHY_ADAPTER.md",
    "readme": ROOT / "README.md",
    "start_here": ROOT / "기획서/00_프로젝트_허브/START_HERE.md",
    "active_context": ROOT / "기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md",
    "current_decisions": ROOT / "기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md",
    "development_gates": ROOT / "기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md",
    "roadmap": ROOT / "기획서/00_프로젝트_허브/ROADMAP.md",
    "playtest_wrapper": ROOT / "기획서/50_제작_검증/PLAYTEST_PLAN_V4_7_CURRENT.md",
}

STALE_CURRENT_TOKENS = (
    "implementation_execution_state: NOT_STARTED",
    "sx_dec_059_build_started: false",
    "sx_dec_059_technical_implementation: NOT_RUN",
    "sx_dec_059_implementation: NOT_STARTED",
    "sx_dec_059_notion_sync: POST_MERGE_READBACK_REQUIRED",
    "notion_sync: POST_MERGE_READBACK_REQUIRED",
    "implementation PR exact-head CI + merge",
    "close superseded PR #154 unmerged",
)

STAGE_SPEC = ROOT / "기획서/20_시스템_콘텐츠/FIRST_SESSION_STAGE_CONTENT_SPEC_V1.md"
COPY_MATRIX = ROOT / "기획서/30_UI_UX/FIRST_SESSION_LOCALIZATION_COPY_MATRIX_V1.md"
EVIDENCE = ROOT / "기획서/50_제작_검증/SX_AUD_066_SX_DEC_059_IMPLEMENTATION_AND_FIVE_PASS_REVIEW.md"


class SxDec059ImplementationCanonicalFreshnessTests(unittest.TestCase):
    def _read(self, key: str) -> str:
        path = CURRENT_OWNER_FILES[key]
        self.assertTrue(path.is_file(), f"missing current owner: {path}")
        return path.read_text(encoding="utf-8")

    def test_each_current_owner_rejects_known_premerge_state(self) -> None:
        for key, path in CURRENT_OWNER_FILES.items():
            text = path.read_text(encoding="utf-8")
            for stale in STALE_CURRENT_TOKENS:
                self.assertNotIn(stale, text, f"{key} still contains stale token: {stale}")

    def test_authority_chain_records_pr158_merge_without_inflating_human_evidence(self) -> None:
        adapter = self._read("adapter")
        self.assertIn("implementation_execution_state: MERGED_MAIN_VERIFIED", adapter)
        self.assertIn("implementation_merge_pr: 158", adapter)
        self.assertIn(f"implementation_merge_main: {IMPLEMENTATION_MERGE_MAIN}", adapter)
        self.assertIn("implementation_notion_readback: PASS", adapter)
        self.assertIn("sx_dec_059_developer_self_run: NOT_RUN", adapter)
        self.assertIn("five_person_comprehension: NOT_RUN", adapter)

        for key in (
            "agents",
            "readme",
            "start_here",
            "active_context",
            "current_decisions",
            "roadmap",
            "playtest_wrapper",
        ):
            text = self._read(key)
            self.assertIn(IMPLEMENTATION_MERGE_MAIN, text, f"{key} lost PR #158 merge identity")
            self.assertIn("NOT_RUN", text, f"{key} must preserve manual evidence ceiling")

    def test_current_next_action_is_validation_not_implementation_restart(self) -> None:
        for key in ("readme", "active_context", "development_gates", "playtest_wrapper"):
            text = self._read(key)
            self.assertIn("developer self-run", text, f"{key} must route to developer validation")
            self.assertIn("acceptance build", text, f"{key} must retain exact-build gate")
            self.assertIn("Five-person", text, f"{key} must retain human evidence gate")

    def test_superseded_pr154_is_closed_not_future_work(self) -> None:
        for key in ("agents", "adapter", "start_here", "active_context", "development_gates", "roadmap"):
            text = self._read(key)
            self.assertIn("CLOSED_UNMERGED", text, f"{key} must record PR #154 closure")

    def test_shipped_t4_t5_t6_contract_is_explicit(self) -> None:
        stage = STAGE_SPEC.read_text(encoding="utf-8")
        self.assertGreaterEqual(stage.count("FIXED_FIGURE_EIGHT_STARTER_LAYOUT"), 2)
        self.assertIn("ONE_SWITCH_PRESET_SELECTION", stage)

        matrix = COPY_MATRIX.read_text(encoding="utf-8")
        self.assertIn(
            "Set the switch before the train arrives to choose the delivery route.",
            matrix,
        )
        self.assertNotIn("Change the switch so the train uses both routes.", matrix)

    def test_five_pass_implementation_evidence_is_registered(self) -> None:
        self.assertTrue(EVIDENCE.is_file())
        text = EVIDENCE.read_text(encoding="utf-8")
        for pass_number in range(1, 6):
            self.assertIn(f"ADVERSARIAL_PASS_{pass_number}: CLOSED", text)
        self.assertIn("PHYSICAL_WINDOWS: NOT_RUN", text)
        self.assertIn("FIVE_PERSON_COMPREHENSION: NOT_RUN", text)


if __name__ == "__main__":
    unittest.main()
