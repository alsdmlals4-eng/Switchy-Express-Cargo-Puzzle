from __future__ import annotations

import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]

CURRENT_OWNERS = {
    "agents": ROOT / "AGENTS.md",
    "readme": ROOT / "README.md",
    "start_here": ROOT / "기획서/00_프로젝트_허브/START_HERE.md",
    "current_decisions": ROOT / "기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md",
    "baseline": ROOT / "기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md",
    "active_context": ROOT / "기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md",
    "roadmap": ROOT / "기획서/00_프로젝트_허브/ROADMAP.md",
    "development_gates": ROOT / "기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md",
    "core_gameplay": ROOT / "기획서/10_경험/CORE_GAMEPLAY.md",
    "core_systems": ROOT / "기획서/20_시스템_콘텐츠/CORE_SYSTEMS.md",
    "first_session": ROOT / "기획서/20_시스템_콘텐츠/FIRST_SESSION_STAGE_CONTENT_SPEC_V1.md",
    "project_skill": ROOT / "skills/switchy-express-design/SKILL.md",
}

PACKAGE_OWNERS = {
    "decision": ROOT / "docs/decisions/SX_DEC_060_CARDINAL_STATION_SERVICE_AND_REACHABLE_NETWORK.md",
    "design": ROOT / "docs/superpowers/specs/2026-08-26-cardinal-station-service-and-reachable-network-design.md",
    "plan": ROOT / "docs/superpowers/plans/2026-08-26-cardinal-station-service-and-reachable-network.md",
    "handoff": ROOT / "기획서/50_제작_검증/SX_DEC_060_CODEX_HANDOFF_PACKAGE.md",
}


class SXDec060CanonicalFreshnessTests(unittest.TestCase):
    def _read_path(self, path: Path) -> str:
        self.assertTrue(path.is_file(), f"missing SX-DEC-060 owner: {path}")
        return path.read_text(encoding="utf-8")

    def _read_current(self, key: str) -> str:
        return self._read_path(CURRENT_OWNERS[key])

    def test_current_entry_owners_promote_decision_060(self) -> None:
        for key in (
            "agents",
            "readme",
            "start_here",
            "current_decisions",
            "baseline",
            "active_context",
            "roadmap",
            "development_gates",
            "project_skill",
        ):
            text = self._read_current(key)
            self.assertIn("SX-DEC-060", text, f"{key} does not route to SX-DEC-060")
            self.assertNotIn(
                "current_decision_span: SX-DEC-027~059",
                text,
                f"{key} still advertises the pre-060 decision span as current",
            )
            self.assertNotIn(
                "current_decisions: SX-DEC-027~059",
                text,
                f"{key} still advertises the pre-060 decision span as current",
            )

    def test_current_gameplay_owners_express_exact_cardinal_service(self) -> None:
        combined = "\n".join(
            self._read_current(key)
            for key in ("baseline", "core_gameplay", "core_systems", "first_session")
        )
        for required in (
            "상·하·좌·우",
            "대각선",
            "SX-DEC-060",
        ):
            self.assertIn(required, combined)

        for key in ("baseline", "core_gameplay", "core_systems"):
            text = self._read_current(key)
            self.assertTrue(
                "abs(" in text or "Manhattan" in text or "상·하·좌·우" in text,
                f"{key} does not express the exact cardinal station-service rule",
            )

    def test_preflight_owners_route_to_start_reachable_required_coverage(self) -> None:
        for key in ("baseline", "core_gameplay", "core_systems", "development_gates"):
            text = self._read_current(key)
            self.assertTrue(
                "start-reachable" in text or "START_REACHABLE" in text,
                f"{key} does not identify start-reachable RUN preflight",
            )
            self.assertTrue(
                "disconnected" in text or "분리 선로" in text,
                f"{key} does not record that irrelevant disconnected rail is allowed",
            )

    def test_first_session_no_longer_teaches_direct_station_track_contact(self) -> None:
        text = self._read_current("first_session")
        self.assertIn("T2", text)
        self.assertIn("SX-DEC-060", text)
        self.assertIn("대각선", text)
        self.assertNotIn(
            "player는 start→cargo→station을 모두 연결해야 preflight PASS",
            text,
            "first-session content still teaches station footprint rail contact",
        )

    def test_candidate_003_is_preserved_as_pre_change_history(self) -> None:
        for key in ("readme", "start_here", "current_decisions", "active_context", "roadmap", "development_gates"):
            text = self._read_current(key)
            self.assertIn("Candidate 003", text)
            self.assertTrue(
                "HISTORICAL" in text or "historical" in text or "역사" in text,
                f"{key} does not bound Candidate 003 as pre-change history",
            )

    def test_runtime_and_human_evidence_remain_fail_closed(self) -> None:
        combined = "\n".join(self._read_current(key) for key in CURRENT_OWNERS)
        for required in (
            "POST_060_PACKAGE_VERIFIED_SX60_POC_ACCEPT_001",
            "PREPARED_PACKAGE_VERIFIED",
            "NOT_RUN",
            "IMPLEMENTATION_NOT_AUTHORIZED",
            "READ_ONLY",
        ):
            self.assertIn(required, combined)

    def test_current_gate_starts_with_post_merge_package_candidate_work(self) -> None:
        for key in ("readme", "roadmap", "development_gates"):
            text = self._read_current(key)
            self.assertIn("SX60-POC-ACCEPT-001 physical self-run", text)
            self.assertNotIn("SX_DEC_060_EXACT_HEAD_REVIEW_CI_MERGE", text)
            self.assertNotIn("PR_REVIEW_CI_MERGE_READBACK", text)

    def test_roadmap_does_not_reopen_merged_sx060_implementation(self) -> None:
        roadmap = self._read_current("roadmap")
        for required in (
            "runtime implementation merged/main verified · PR #188",
            "schema-v3/map-witness migration is implemented and regression-verified",
            "PASS_POST_SX_DEC_060 · CARDINAL_SERVICE_IMPLEMENTED",
        ):
            self.assertIn(required, roadmap)

        for stale in (
            "→ runtime implementation NOT_RUN",
            "MIGRATION_REQUIRED_FOR_POST_060",
            "CARDINAL_SERVICE_DELTA_NOT_RUN",
        ):
            self.assertNotIn(stale, roadmap)

    def test_active_owners_record_automated_runtime_delivery_without_promoting_human_evidence(self) -> None:
        for key in ("current_decisions", "active_context"):
            text = self._read_current(key)
            self.assertIn("sx_dec_060_runtime_implementation: MERGED_MAIN_VERIFIED · PR_188", text)
            self.assertIn("sx_dec_060_automated_regression: PASS", text)
            self.assertTrue(
                "windows_physical" in text or "windows_full_physical" in text,
                f"{key} must retain the physical evidence boundary",
            )
            self.assertIn("NOT_RUN", text)

    def test_consumer_first_visual_contract_requires_zero_new_bitmap(self) -> None:
        combined = "\n".join(
            self._read_current(key)
            for key in ("agents", "readme", "active_context", "development_gates", "project_skill")
        )
        self.assertIn("ProductBoardRenderer", combined)
        self.assertIn("station PNG", combined)
        self.assertTrue(
            "new_bitmap_assets: 0" in combined
            or "new_bitmap_assets_required: 0" in combined
            or "0 new bitmap" in combined
            or "zero new bitmap" in combined.lower()
            or "ZERO new bitmap" in combined,
            "current owners do not make the no-new-bitmap contract explicit",
        )

    def test_decision_design_plan_and_handoff_exist_and_share_id(self) -> None:
        for key, path in PACKAGE_OWNERS.items():
            text = self._read_path(path)
            self.assertIn("SX-DEC-060", text, f"{key} does not share Decision ID")

    def test_implementation_package_records_merged_state_without_promoting_physical_evidence(self) -> None:
        decision = self._read_path(PACKAGE_OWNERS["decision"])
        design = self._read_path(PACKAGE_OWNERS["design"])
        plan = self._read_path(PACKAGE_OWNERS["plan"])
        handoff = self._read_path(PACKAGE_OWNERS["handoff"])

        self.assertIn("MERGED_MAIN_VERIFIED · PR #188", decision)
        self.assertIn("IMPLEMENTATION_MERGED_MAIN_VERIFIED · PR #188", design)
        self.assertIn("HISTORICAL_EXECUTION_PROVENANCE · IMPLEMENTATION_MERGED_MAIN_VERIFIED · PR #188", plan)
        self.assertIn("EXECUTED_MERGED_MAIN_VERIFIED", handoff)
        self.assertIn("godot_product_implementation: MERGED_MAIN_VERIFIED · PR_188", handoff)
        self.assertIn("automated_regression: PASS · 111_CASES_13461_ASSERTIONS", handoff)
        self.assertIn("implementation_five_pass_review: CLOSED · SX-AUD-071", handoff)
        self.assertNotIn("IMPLEMENTATION_NOT_YET_EXECUTED", decision)
        self.assertNotIn("IMPLEMENTATION_NOT_YET_EXECUTED", design)
        self.assertNotIn("PREPARED_NOT_EXECUTED", handoff)
        self.assertNotIn("Implementation is ready for a Codex agent to execute", plan)

        for text in (design, plan, handoff):
            self.assertIn("PHYSICAL_NOT_RUN", text)
            self.assertIn("HUMAN_NOT_RUN", text)

    def test_protected_future_packages_and_pr_174_stay_closed(self) -> None:
        combined = "\n".join(self._read_current(key) for key in CURRENT_OWNERS)
        for required in (
            "SX-DEC-056",
            "SX-DEC-057",
            "SX-DEC-058",
            "IMPLEMENTATION_NOT_AUTHORIZED",
            "PR #174",
            "READ_ONLY",
        ):
            self.assertIn(required, combined)


if __name__ == "__main__":
    unittest.main()
