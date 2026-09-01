from __future__ import annotations

import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
ADAPTER = ROOT / "PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md"
START_HERE = ROOT / "기획서/00_프로젝트_허브/START_HERE.md"
ACTIVE_CONTEXT = ROOT / "기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md"
DECISIONS = ROOT / "기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md"
DOCUMENTATION_MAP = ROOT / "기획서/00_프로젝트_허브/DOCUMENTATION_MAP.md"
REGISTRY = ROOT / "기획서/00_프로젝트_허브/DESIGN_DOCUMENT_REGISTRY.json"
HEALTH = ROOT / "docs/PROJECT_OPERATING_HEALTH.json"
AUDIT_RECEIPT = ROOT / "docs/operations/2026-09-01-switchy-base-operating-adaptation-audit.md"
README = ROOT / "README.md"
DEVELOPMENT_GATES = ROOT / "기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md"
ROADMAP = ROOT / "기획서/00_프로젝트_허브/ROADMAP.md"


def read(path: Path) -> str:
    return path.read_text(encoding="utf-8")


class BaseOperatingAdaptationTests(unittest.TestCase):
    def test_adapter_adopts_current_base_execution_without_repining(self) -> None:
        adapter = read(ADAPTER)
        self.assertIn("base_current_execution_model: FRESH_READ_ONLY_NO_REPIN", adapter)
        self.assertIn(
            "FRESH_READ → CLASSIFY → PLAN → BUILD_OR_HANDOFF → VERIFY → FIVE_ADVERSARIAL_LOOPS",
            adapter,
        )
        self.assertIn("project_base_compatibility_pin: v9.4.3", adapter)
        self.assertIn("current_base_provider_change: DEFERRED_UNVERIFIED", adapter)

    def test_current_locators_select_sx_dec_069_and_candidate_010(self) -> None:
        start_here = read(START_HERE)
        active_context = read(ACTIVE_CONTEXT)
        decisions = read(DECISIONS)

        self.assertIn("| 결정 범위 | `SX-DEC-027~069` |", start_here)
        self.assertIn("SX-DEC-069 merged main@79323ff", active_context)
        self.assertIn("SX60-POC-ACCEPT-010 is the exact current machine package candidate", active_context)
        self.assertIn("| **SX-DEC-069** |", decisions)

    def test_operating_health_stays_schema_compatible_and_audit_bounds_its_scope(self) -> None:
        health = json.loads(read(HEALTH))
        self.assertEqual(health["artifact_role"], "PROJECT_OPERATING_HEALTH")
        self.assertNotIn("snapshot_role", health)
        self.assertNotIn("current_runtime_authority", health)
        self.assertIn(
            "remains schema-compatible",
            read(AUDIT_RECEIPT),
        )

    def test_audit_receipt_is_not_an_active_base_pin(self) -> None:
        receipt = read(AUDIT_RECEIPT)
        self.assertIn("base_completed_main_observed: 19355b7ef065a21d0f2b685c7d9be64a4a3970f8", receipt)
        self.assertIn("observation_status: HISTORICAL_TASK_RECEIPT", receipt)
        self.assertIn("next_task_requirement: REFRESH_BASE_COMPLETED_MAIN_AGAIN", receipt)
        self.assertIn("base_repository_mutation: NOT_PERFORMED", receipt)

    def test_navigation_preserves_one_active_adapter_and_a_historical_audit_receipt(self) -> None:
        documentation_map = read(DOCUMENTATION_MAP)
        registry = json.loads(read(REGISTRY))

        self.assertIn("Current Base execution model", documentation_map)
        self.assertIn("SX-BASE-CURRENT-OPERATING-ADAPTATION-20260901", documentation_map)
        entry = next(
            document
            for document in registry["documents"]
            if document["id"] == "SX-BASE-CURRENT-OPERATING-ADAPTATION-20260901"
        )
        self.assertEqual(entry["status"], "HISTORICAL_AUDIT_RECEIPT")
        self.assertEqual(
            entry["source"],
            "docs/operations/2026-09-01-switchy-base-operating-adaptation-audit.md",
        )

    def test_entry_surfaces_do_not_leave_pre_sx_dec_069_state_as_current(self) -> None:
        readme = read(README)
        gates = read(DEVELOPMENT_GATES)
        roadmap = read(ROADMAP)

        self.assertIn(
            "FINAL_USER_REVIEW_ON_UNCHANGED_SX60_POC_ACCEPT_010",
            readme,
        )
        self.assertIn("HISTORICAL_PRE_RUNTIME", gates)
        self.assertIn("current_decisions: SX-DEC-027~069", roadmap)


if __name__ == "__main__":
    unittest.main()
