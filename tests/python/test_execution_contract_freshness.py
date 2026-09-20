from __future__ import annotations

import json
import re
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
WORK_INSTRUCTION = (
    ROOT
    / "PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md"
)
POST_060_POINTER = ROOT / "evidence/acceptance/post_sx_dec_060_candidate.json"
SX60_ARTIFACT = ROOT / "evidence/acceptance/sx60_poc_accept_001_artifact.json"
PROJECT_CONTRACT_WORKFLOW = ROOT / ".github/workflows/project-contract.yml"
ACTIVE_CONTEXT = ROOT / "기획서" / "00_프로젝트_허브" / "ACTIVE_CONTEXT.md"
PROJECT_LEARNING_RECEIPT = ROOT / "docs" / "operations" / "2026-08-31-project-learning-absorption.md"
CURRENT_OWNER_DOCS = (
    ROOT / "기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md",
    ROOT / "기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md",
    ROOT / "기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md",
    ROOT / "기획서/00_프로젝트_허브/ROADMAP.md",
    ROOT / "docs/decisions/SX_DEC_060_CARDINAL_STATION_SERVICE_AND_REACHABLE_NETWORK.md",
)




class ExecutionContractFreshnessTests(unittest.TestCase):
    def test_current_execution_route_has_one_owner_and_no_forced_phase_repetition(self) -> None:
        instruction = WORK_INSTRUCTION.read_text(encoding="utf-8")
        self.assertIn("UNIFIED_WORK_EXECUTION_CAPABILITY_BASED", instruction)
        self.assertIn("TWO_SHARED_REVIEWS", instruction)
        for retired in ("MINIMUM_FIVE", "GPT_NON_CODING_PREPARATION",
                        "remove completed temporary worktree"):
            self.assertNotIn(retired, instruction)
        self.assertIn("현재 작업 결과/다음 행동은 Active Context", instruction)

    def test_current_execution_boundaries_are_routed_not_duplicated(self) -> None:
        instruction = WORK_INSTRUCTION.read_text(encoding="utf-8")
        agents = (ROOT / "AGENTS.md").read_text(encoding="utf-8")
        for relative in ("기획서/50_제작_검증/PLAYTEST_PLAN.md",
                         "docs/reporting/AI_WORKLOG_EVIDENCE_POLICY.md"):
            self.assertIn(relative, instruction)
            self.assertTrue((ROOT / relative).is_file())
        self.assertIn("최종 삭제는 사용자", instruction)
        self.assertIn("실행하지 않은 항목은", agents)
        self.assertIn("실제 consumer", agents)
        self.assertIn("승인된 구현", instruction)

    def test_active_context_keeps_the_user_workspace_hygiene_rule(self) -> None:
        active = ACTIVE_CONTEXT.read_text(encoding="utf-8")
        for required in (
            "## 2026-08-31 workspace artifact hygiene",
            "short direct child of the Windows temp root",
            "Never clean the user root worktree, a dirty or unmerged worktree",
            "do not relabel it as removed or work around a safety control",
            "SX60-POC-ACCEPT-009-33396533310",
            "HOST_POLICY_BLOCKED",
        ):
            self.assertIn(required, active)

    def test_project_learning_absorption_receipt_is_present(self) -> None:
        self.assertTrue(PROJECT_LEARNING_RECEIPT.is_file(), "project learning absorption receipt is missing")
        receipt = PROJECT_LEARNING_RECEIPT.read_text(encoding="utf-8")
        required_markers = (
            "SX-LRN-20260831-01",
            "a165a31ddf3ba20d2ba0411f42cc9f5899b4753b",
            "EXISTING_PROJECT_REFLECTION_AND_BASE_DUPLICATE",
            "PROJECT_ONLY",
            "BASE_REVIEW_CANDIDATE_OBSERVATION",
            "short direct child of the configured Windows temporary root",
            "cleanup_residual_path: .worktrees/codex-wayside-hazards-salvage-20260830",
            "cleanup_residual_bytes_observed: 137790617",
            "BASE_BCP_TARGET: BCP-2026-046-work-godot-process-lifecycle",
            "BASE_REPOSITORY_MUTATION: NOT_PERFORMED",
            "this receipt, its focused regression test, and the current Active Context resume link",
        )
        missing = [marker for marker in required_markers if marker not in receipt]
        self.assertFalse(missing, "project learning receipt is missing: " + ", ".join(missing))

    def test_project_learning_receipt_keeps_user_approval_preference_loop(self) -> None:
        receipt = PROJECT_LEARNING_RECEIPT.read_text(encoding="utf-8")
        required_markers = (
            "SX-APR-20260831-01",
            "USER_APPROVAL_PREFERENCE_LEARNING",
            "CURRENT_STATE → RECOMMENDED_ACTION → REASON → EXPECTED_EFFECT",
            "PROMOTION_RATIONALE",
            "WORK_STRUCTURE",
            "VISUAL_OR_ASSET_RELEVANCE",
            "FAILURE_CAUSAL_ANALYSIS",
            "EXPECTED_EFFECT",
            "TEXT_NATIVE_FLOW_NO_IMAGE_GENERATION",
            "PROJECT_LEARNING_ONLY_UNTIL_BASE_ELIGIBILITY_AND_REGISTRY_OWNERSHIP_CLEAR",
        )
        missing = [marker for marker in required_markers if marker not in receipt]
        self.assertFalse(
            missing,
            "project learning receipt is missing user approval preference markers: "
            + ", ".join(missing),
        )

    def test_active_context_routes_the_project_learning_receipt(self) -> None:
        active = ACTIVE_CONTEXT.read_text(encoding="utf-8")
        for required in (
            "SX-LRN-20260831-01",
            "docs/operations/2026-08-31-project-learning-absorption.md",
            "BASE_REVIEW_CANDIDATE_OBSERVATION",
        ):
            self.assertIn(required, active)

    def test_sx60_candidate_preserves_immutable_historical_source_identity(self) -> None:
        self.assertTrue(SX60_ARTIFACT.is_file(), "SX60 candidate artifact evidence is missing")
        artifact = json.loads(SX60_ARTIFACT.read_text(encoding="utf-8"))
        self.assertEqual(artifact["candidate_id"], "SX60-POC-ACCEPT-001")
        self.assertEqual(
            artifact["source_build"]["main_sha"],
            "7b7f350345619e870bb94e12954fbe81b1ef9403",
            "historical SX60 package provenance must remain pinned to its original main",
        )

    def test_post_merge_pointer_binds_the_new_exact_main_candidate(self) -> None:
        self.assertTrue(POST_060_POINTER.is_file(), "post-060 candidate pointer is missing")
        pointer = json.loads(POST_060_POINTER.read_text(encoding="utf-8"))
        self.assertEqual(pointer["candidate_status"], "PREPARED_PACKAGE_VERIFIED")
        self.assertEqual(pointer["current_candidate_id"], "SX60-POC-ACCEPT-010")
        self.assertEqual(pointer["minimum_product_source_main"], "79323ff0175b674c594d18dfd6d28a8e9951f5bd")
        self.assertEqual(
            pointer["historical_superseded_after_sx_dec_063_core_board_v04"]["source_main"],
            "58b99f261c3576150ab275bb041d744c69b83538",
            "Candidate 004 must remain immutable prior-byte evidence while Candidate 005 is minted",
        )
        self.assertEqual(
            pointer["historical_superseded_after_sx_dec_067"]["candidate_id"],
            "SX60-POC-ACCEPT-006",
        )

    def test_current_owner_docs_do_not_route_historical_sx60_candidate_to_physical_gate(self) -> None:
        stale_line = re.compile(
            r"SX60-POC-ACCEPT-001.*(?:current|next|physical|sole explicit|target)|"
            r"(?:current|next|physical|sole explicit|target).*SX60-POC-ACCEPT-001",
            re.IGNORECASE,
        )
        findings = []
        for path in CURRENT_OWNER_DOCS:
            self.assertTrue(path.is_file(), f"current owner doc is missing: {path}")
            for line_number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
                if stale_line.search(line):
                    findings.append(f"{path.relative_to(ROOT)}:{line_number}: {line.strip()}")
        self.assertFalse(
            findings,
            "historical SX60 candidate must not remain current/next physical target:\n"
            + "\n".join(findings),
        )

    def test_project_contract_ci_runs_execution_contract_regression(self) -> None:
        self.assertTrue(PROJECT_CONTRACT_WORKFLOW.is_file())
        workflow = PROJECT_CONTRACT_WORKFLOW.read_text(encoding="utf-8")
        self.assertIn("tests/python/test_execution_contract_freshness.py -v", workflow)


if __name__ == "__main__":
    unittest.main()
