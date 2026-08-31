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


REQUIRED_DURABLE_MARKERS = {
    "startup reconciliation checklist":
        "startup_checklist: CORE_FUN_SYSTEM_SWOT_REMAINING_WORK_ORDER_CHECK",
    "bounded fallback route":
        "bounded_fallback_route: REQUIRED_ON_DELAY_OR_BLOCKER",
    "delegated routine approval":
        "delegated_routine_approval: APPROVED_BY_DEFAULT_UNLESS_DANGEROUS_CHANGE",
    "GPT then Codex then deferred human QA":
        "workflow_order: GPT_NON_CODING_PREPARATION → CODEX_SINGLE_IMPLEMENTATION_WINDOW → HUMAN_QA_DEFERRED",
    "machine runtime validation":
        "machine_runtime_validation: GODOT_HERA_GUT_REQUIRED; HUMAN_QA_DEFERRED",
    "candidate freshness invalidation":
        "candidate_freshness_invalidation: PLAYER_FACING_BYTES_CHANGE → INVALIDATE_EXACT_CANDIDATE",
    "zero remaining work completion gate": "completion_gate: REQUIRED_WORK_REMAINING: 0",
    "workspace artifact hygiene": "## 8A. Workspace artifact hygiene · 2026-08-31 user directive",
}


class ExecutionContractFreshnessTests(unittest.TestCase):
    def test_current_work_instruction_contains_durable_execution_contract_markers(self) -> None:
        self.assertTrue(WORK_INSTRUCTION.is_file(), "current v4.8 work instruction is missing")
        instruction = WORK_INSTRUCTION.read_text(encoding="utf-8")
        missing = {
            name: marker
            for name, marker in REQUIRED_DURABLE_MARKERS.items()
            if marker not in instruction
        }
        self.assertFalse(
            missing,
            "work instruction is missing required durable markers: "
            + ", ".join(f"{name}={marker!r}" for name, marker in missing.items()),
        )

    def test_current_work_instruction_preserves_execution_boundaries(self) -> None:
        instruction = WORK_INSTRUCTION.read_text(encoding="utf-8")
        required_clauses = {
            "human QA remains deferred": "Human QA는 현재 보류한다.",
            "machine evidence cannot become human evidence": "machine observation은 human/player PASS가 아니다.",
            "fallback cannot reduce verification": "Fallback은 security, rights, exactness, or validation strength를 낮추는 우회가 될 수 없다.",
            "tooling-only changes do not invalidate": "tooling-only, test-only, documentation-only 변경은 candidate를 무효화하지 않는다.",
            "current candidate conflict must be reconciled": "CONTEXT_DRIFT_RECHECK_REQUIRED",
            "generated images require a runtime consumer": "verified runtime consumer",
            "generated images have GitHub-only preservation": "tracked project-local GitHub path",
            "historical candidate state is explicit": "HISTORICAL_SUPERSEDED_BY_PLAYER_FACING_BYTE_CHANGE",
        }
        missing = {
            name: clause
            for name, clause in required_clauses.items()
            if clause not in instruction
        }
        self.assertFalse(
            missing,
            "work instruction is missing required execution boundaries: "
            + ", ".join(f"{name}={clause!r}" for name, clause in missing.items()),
        )

    def test_active_context_keeps_the_user_workspace_hygiene_rule(self) -> None:
        active = ACTIVE_CONTEXT.read_text(encoding="utf-8")
        for required in (
            "## 2026-08-31 workspace artifact hygiene",
            "short direct child of the Windows temp root",
            "Never clean the user root worktree, a dirty or unmerged worktree",
            "do not relabel it as removed or work around a safety control",
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

    def test_post_merge_pointer_fails_closed_until_the_new_exact_main_candidate_is_minted(self) -> None:
        self.assertTrue(POST_060_POINTER.is_file(), "post-060 candidate pointer is missing")
        pointer = json.loads(POST_060_POINTER.read_text(encoding="utf-8"))
        self.assertEqual(pointer["candidate_status"], "NOT_MINTED")
        self.assertIsNone(pointer["current_candidate_id"])
        self.assertEqual(pointer["minimum_product_source_main"], "c0bb86efa5bad6050217ca67dd6aa9eba155dc75")
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
