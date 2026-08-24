from __future__ import annotations

import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
V48_ADAPTER = ROOT / "PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md"
V47_ADAPTER = ROOT / "PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.7_SWITCHY_ADAPTER.md"
PROJECT_ADAPTER = ROOT / "skills/PROJECT_BASE_ADAPTER.json"
PROJECT_SKILL = ROOT / "skills/switchy-express-design/SKILL.md"

V48_R4_SOURCE_SHA256 = "1426c2e5e25e32dc72abccf49e4a0839578e54c14b38ba0de045be426fd63ea6"
V48_R2_HISTORICAL_SHA256 = "6f0541048e084746f6777223521361d0339dbfb2e223c70947f694f1c050f508"
BASE_MAIN_AT_INITIAL_V48_MIGRATION = "2828a74f60c1ed09546171040f4178c8848ea686"
PR_BASE_AT_INITIAL_V48_MIGRATION = "ae8f4aeae111c5cce4284499b851c0c3f80f6bf3"

CURRENT_AUTHORITY_OWNERS = (
    ROOT / "PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md",
    ROOT / "AGENTS.md",
    ROOT / "README.md",
    ROOT / "기획서/00_프로젝트_허브/START_HERE.md",
    ROOT / "기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md",
    ROOT / "기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md",
    ROOT / "기획서/00_프로젝트_허브/ROADMAP.md",
    ROOT / "기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md",
)

CURRENT_CANDIDATE_ROUTING_OWNERS = (
    V48_ADAPTER,
    ROOT / "AGENTS.md",
    ROOT / "README.md",
    ROOT / "기획서/00_프로젝트_허브/START_HERE.md",
    ROOT / "기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md",
    ROOT / "기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md",
    ROOT / "기획서/00_프로젝트_허브/ROADMAP.md",
    ROOT / "기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md",
    PROJECT_SKILL,
)


class V48CurrentAuthorityMigrationTests(unittest.TestCase):
    def test_v48_thin_adapter_binds_r4_without_deleting_r2_or_v47_history(self) -> None:
        self.assertTrue(V48_ADAPTER.is_file(), "current v4.8 project thin adapter is missing")
        self.assertTrue(V47_ADAPTER.is_file(), "v4.7 rollback/history adapter must be retained")
        text = V48_ADAPTER.read_text(encoding="utf-8")
        self.assertIn("contract_version: '4.8'", text)
        self.assertIn("revision: '2026-08-24-r4'", text)
        self.assertIn(f"source_v4_8_r4_sha256: {V48_R4_SOURCE_SHA256}", text)
        self.assertIn(f"source_v4_8_r2_sha256: {V48_R2_HISTORICAL_SHA256}", text)
        self.assertIn(
            f"base_snapshot_observed_when_v4_8_adopted: {BASE_MAIN_AT_INITIAL_V48_MIGRATION}",
            text,
        )
        self.assertIn("base_snapshot_policy: ALWAYS_REFETCH_CURRENT_COMPLETED_MAIN", text)
        self.assertIn("google_sheets_policy: COMPATIBILITY_ONLY_MIGRATION_SOURCE_UNTIL_REMOVAL", text)

    def test_all_active_authority_snapshots_route_to_r4(self) -> None:
        for path in CURRENT_AUTHORITY_OWNERS:
            self.assertTrue(path.is_file(), f"missing current owner: {path}")
            text = path.read_text(encoding="utf-8")
            self.assertIn("2026-08-24-r4", text, f"{path} still lacks the current r4 locator")
            self.assertIn(V48_R4_SOURCE_SHA256, text, f"{path} lacks the exact current r4 source identity")

    def test_project_base_adapter_uses_v2_and_sheet_is_migration_compatibility_only(self) -> None:
        adapter = json.loads(PROJECT_ADAPTER.read_text(encoding="utf-8"))
        self.assertEqual(2, adapter["schema_version"])
        self.assertEqual("switchy-express-cargo-puzzle", adapter["project"]["project_id"])
        self.assertEqual(PR_BASE_AT_INITIAL_V48_MIGRATION, adapter["protected_baseline"]["commit"])
        sheet = adapter["gdd_sheet"]
        self.assertEqual("GOOGLE_SHEETS_LEGACY_MIGRATION_SOURCE", sheet["role"])
        self.assertEqual("MIGRATION_COMPATIBILITY_SURFACE", sheet["workspace_status"])
        self.assertEqual("NOT_CONFIGURED", sheet["sync_status"])
        self.assertEqual("HISTORICAL_SYNCED", sheet["declared_sync_status"])
        self.assertFalse(sheet["new_input_allowed"])
        planning = adapter["shared_overrides"]["managing-project-intake-and-work-contract"]["planning_first_governance"]
        self.assertEqual("NOTION_DEFAULT_PROJECT_WORKSPACE", planning["current_human_workspace"])
        self.assertEqual("GITHUB_REPOSITORY_AND_ACTUAL_RUNTIME", planning["runtime_structured_authority"])

    def test_active_candidate_routing_uses_candidate_003_and_fail_closed_validation_order(self) -> None:
        for path in CURRENT_CANDIDATE_ROUTING_OWNERS:
            self.assertTrue(path.is_file(), f"missing current routing owner: {path}")
            text = path.read_text(encoding="utf-8")
            self.assertIn("SX59-POC-ACCEPT-003", text, f"{path} does not identify Candidate 003 as current")

        adapter_text = V48_ADAPTER.read_text(encoding="utf-8")
        skill_text = PROJECT_SKILL.read_text(encoding="utf-8")
        for text, owner in ((adapter_text, V48_ADAPTER), (skill_text, PROJECT_SKILL)):
            for required in (
                "Candidate 003 Gate 0",
                "physical visual recheck",
                "developer self-run / screen QA",
                "audio perceptual QA",
                "Windows full physical smoke",
                "Android device smoke",
                "Five-person first-contact comprehension",
            ):
                self.assertIn(required, text, f"{owner} lacks current validation step: {required}")

        self.assertIn("Candidate 002", adapter_text)
        self.assertIn("HISTORICAL", adapter_text)
        self.assertIn("player_experience: NOT_RUN", adapter_text)

    def test_migration_does_not_authorize_deferred_product_packages(self) -> None:
        text = V48_ADAPTER.read_text(encoding="utf-8")
        for required in (
            "SX-DEC-056A: PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED",
            "SX-DEC-056B: BLOCKED_BY_AUTHORITATIVE_SCORE_COMBO_RUNTIME",
            "SX-DEC-057: PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED",
            "SX-DEC-058: PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED",
            "player_experience: NOT_RUN",
        ):
            self.assertIn(required, text)


if __name__ == "__main__":
    unittest.main()
