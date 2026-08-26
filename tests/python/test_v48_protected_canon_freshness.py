from __future__ import annotations

import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
V48_ADAPTER = "PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md"
CURRENT_R54_REVISION = "2026-08-26-r5.4-superset-final"
CURRENT_R54_ROLE = "USER_PROVIDED_V4_8_R5_4_SUPERSET_FINAL_CONTRACT"
CURRENT_R54_SHA256 = "fdf238c202cfac6d3a824aae49b8ac525fba023e31bba7df6ece64a2790365a0"
HISTORICAL_R4_REVISION = "2026-08-24-r4"
HISTORICAL_R2_SHA256 = "6f0541048e084746f6777223521361d0339dbfb2e223c70947f694f1c050f508"

OWNERS = {
    "start_here": ROOT / "기획서/00_프로젝트_허브/START_HERE.md",
    "active_context": ROOT / "기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md",
    "current_decisions": ROOT / "기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md",
    "development_gates": ROOT / "기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md",
    "roadmap": ROOT / "기획서/00_프로젝트_허브/ROADMAP.md",
}


class V48ProtectedCanonFreshnessTests(unittest.TestCase):
    def _read(self, key: str) -> str:
        path = OWNERS[key]
        self.assertTrue(path.is_file(), f"missing protected current owner: {path}")
        return path.read_text(encoding="utf-8")

    def test_current_protected_entry_owners_name_r54_as_current(self) -> None:
        for key in OWNERS:
            text = self._read(key)
            self.assertIn("v4.8", text, f"{key} does not identify v4.8 current authority")
            self.assertIn(CURRENT_R54_REVISION, text, f"{key} does not identify r5.4 current authority")
            self.assertIn(CURRENT_R54_ROLE, text, f"{key} does not identify the r5.4 user-contract role")
            self.assertNotIn(
                "work_instruction: v4.8 · 2026-08-24-r4 · SWITCHY_THIN_ADAPTER",
                text,
                f"{key} still advertises r4 as current work instruction",
            )
            self.assertNotIn(
                "current_work_instruction: v4.8 · 2026-08-24-r4 · SWITCHY_THIN_ADAPTER",
                text,
                f"{key} still advertises r4 as current work instruction",
            )

    def test_start_here_routes_to_v48_adapter_and_preserves_history(self) -> None:
        text = self._read("start_here")
        self.assertIn(V48_ADAPTER, text)
        self.assertIn("v4.7", text, "historical v4.7 provenance should remain discoverable")
        self.assertIn(HISTORICAL_R4_REVISION, text, "historical r4 predecessor should remain discoverable")

    def test_decision_and_active_context_keep_history_and_current_base_dynamic(self) -> None:
        for key in ("active_context", "current_decisions"):
            text = self._read(key)
            self.assertIn(CURRENT_R54_SHA256, text)
            self.assertIn(HISTORICAL_R4_REVISION, text)
            self.assertIn(HISTORICAL_R2_SHA256, text)
            self.assertIn("ALWAYS_REFETCH_CURRENT_COMPLETED_MAIN", text)

    def test_gate_and_roadmap_expose_candidate_003_without_changing_product_gate(self) -> None:
        for key in ("development_gates", "roadmap"):
            text = self._read(key)
            self.assertIn("Candidate 003", text)
            self.assertIn("physical visual recheck", text)
            self.assertIn("NOT_RUN", text)

    def test_deferred_packages_and_human_evidence_remain_closed(self) -> None:
        combined = "\n".join(self._read(key) for key in OWNERS)
        for required in (
            "IMPLEMENTATION_NOT_AUTHORIZED",
            "BLOCKED_BY_AUTHORITATIVE_SCORE_COMBO_RUNTIME",
            "player_experience: NOT_RUN",
        ):
            self.assertIn(required, combined)


if __name__ == "__main__":
    unittest.main()
