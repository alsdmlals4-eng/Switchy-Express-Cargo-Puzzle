from __future__ import annotations

import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
V48_ADAPTER = ROOT / "PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md"
V47_ADAPTER = ROOT / "PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.7_SWITCHY_ADAPTER.md"
PROJECT_ADAPTER = ROOT / "skills/PROJECT_BASE_ADAPTER.json"
PROJECT_SKILL = ROOT / "skills/switchy-express-design/SKILL.md"

V48_SOURCE_SHA256 = "6f0541048e084746f6777223521361d0339dbfb2e223c70947f694f1c050f508"
BASE_MAIN_AT_MIGRATION = "2828a74f60c1ed09546171040f4178c8848ea686"
PR_BASE_AT_MIGRATION = "ae8f4aeae111c5cce4284499b851c0c3f80f6bf3"

UNPROTECTED_CURRENT_OWNER_EXPECTATIONS = {
    ROOT / "AGENTS.md": "PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md",
    ROOT / "README.md": "work_instruction: v4.8 · revision 2026-08-24-r2 · SWITCHY_THIN_ADAPTER",
}


class V48CurrentAuthorityMigrationTests(unittest.TestCase):
    def test_v48_thin_adapter_binds_the_user_contract_without_deleting_v47_history(self) -> None:
        self.assertTrue(V48_ADAPTER.is_file(), "current v4.8 project thin adapter is missing")
        self.assertTrue(V47_ADAPTER.is_file(), "v4.7 rollback/history adapter must be retained")
        text = V48_ADAPTER.read_text(encoding="utf-8")
        self.assertIn("contract_version: '4.8'", text)
        self.assertIn("revision: '2026-08-24-r2'", text)
        self.assertIn(f"source_v4_8_sha256: {V48_SOURCE_SHA256}", text)
        self.assertIn(f"base_snapshot_observed_when_v4_8_adopted: {BASE_MAIN_AT_MIGRATION}", text)
        self.assertIn("base_snapshot_policy: ALWAYS_REFETCH_CURRENT_COMPLETED_MAIN", text)
        self.assertIn("google_sheets_policy: COMPATIBILITY_ONLY_MIGRATION_SOURCE_UNTIL_REMOVAL", text)

    def test_unprotected_entry_surfaces_route_to_v48(self) -> None:
        for path, required in UNPROTECTED_CURRENT_OWNER_EXPECTATIONS.items():
            self.assertTrue(path.is_file(), f"missing current owner: {path}")
            text = path.read_text(encoding="utf-8")
            self.assertIn(required, text, f"{path} is not routed to v4.8 current authority")

    def test_project_base_adapter_uses_v2_and_sheet_is_migration_compatibility_only(self) -> None:
        adapter = json.loads(PROJECT_ADAPTER.read_text(encoding="utf-8"))
        self.assertEqual(2, adapter["schema_version"])
        self.assertEqual("switchy-express-cargo-puzzle", adapter["project"]["project_id"])
        self.assertEqual(PR_BASE_AT_MIGRATION, adapter["protected_baseline"]["commit"])
        sheet = adapter["gdd_sheet"]
        self.assertEqual("GOOGLE_SHEETS_LEGACY_MIGRATION_SOURCE", sheet["role"])
        self.assertEqual("MIGRATION_COMPATIBILITY_SURFACE", sheet["workspace_status"])
        self.assertEqual("NOT_CONFIGURED", sheet["sync_status"])
        self.assertEqual("HISTORICAL_SYNCED", sheet["declared_sync_status"])
        self.assertFalse(sheet["new_input_allowed"])
        planning = adapter["shared_overrides"]["managing-project-intake-and-work-contract"]["planning_first_governance"]
        self.assertEqual("NOTION_DEFAULT_PROJECT_WORKSPACE", planning["current_human_workspace"])
        self.assertEqual("GITHUB_REPOSITORY_AND_ACTUAL_RUNTIME", planning["runtime_structured_authority"])

    def test_project_skill_routes_the_current_sx059_acceptance_sequence(self) -> None:
        text = PROJECT_SKILL.read_text(encoding="utf-8")
        for required in (
            "developer self-run / screen QA",
            "exact acceptance build",
            "Windows physical smoke",
            "Android device smoke",
            "Five-person first-contact comprehension",
        ):
            self.assertIn(required, text)
        self.assertNotIn("FIVE-PERSON COMPREHENSION: NOT_RUN · BLOCKED_BY_ANDROID", text)
        self.assertNotIn("DEFAULT ENTRYPOINT: LEGACY", text)

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
