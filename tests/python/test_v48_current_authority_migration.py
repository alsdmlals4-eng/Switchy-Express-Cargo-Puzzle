from __future__ import annotations

import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
V48_ADAPTER = ROOT / "PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md"
V47_ADAPTER = ROOT / "PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.7_SWITCHY_ADAPTER.md"
PROJECT_ADAPTER = ROOT / "skills/PROJECT_BASE_ADAPTER.json"
PROJECT_SKILL = ROOT / "skills/switchy-express-design/SKILL.md"
ACTIVE_CONTEXT = ROOT / "기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md"

HISTORICAL_R2_SHA256 = "6f0541048e084746f6777223521361d0339dbfb2e223c70947f694f1c050f508"
PR_BASE_AT_MIGRATION = "ae8f4aeae111c5cce4284499b851c0c3f80f6bf3"

UNPROTECTED_CURRENT_OWNER_EXPECTATIONS = {
    ROOT / "AGENTS.md": "revision: 2026-08-24-r4",
    ROOT / "README.md": "work_instruction: v4.8 · revision 2026-08-24-r4 · SWITCHY_THIN_ADAPTER",
}


class V48CurrentAuthorityMigrationTests(unittest.TestCase):
    def test_v48_thin_adapter_binds_r4_without_deleting_history(self) -> None:
        self.assertTrue(V48_ADAPTER.is_file(), "current v4.8 project thin adapter is missing")
        self.assertTrue(V47_ADAPTER.is_file(), "v4.7 rollback/history adapter must be retained")
        text = V48_ADAPTER.read_text(encoding="utf-8")
        self.assertIn("contract_version: '4.8'", text)
        self.assertIn("revision: '2026-08-24-r4'", text)
        self.assertIn("current_user_contract_role: USER_PROVIDED_V4_8_R4_CONTRACT", text)
        self.assertIn(f"historical_r2_sha256: {HISTORICAL_R2_SHA256}", text)
        self.assertIn("historical_r2_hash_is_not_r4_hash: true", text)
        self.assertIn("base_snapshot_policy: ALWAYS_REFETCH_CURRENT_COMPLETED_MAIN", text)
        self.assertIn("google_sheets_policy: COMPATIBILITY_ONLY_MIGRATION_SOURCE_UNTIL_REMOVAL", text)
        self.assertNotIn("revision: '2026-08-24-r2'", text)
        self.assertNotIn("source_v4_8_sha256:", text)

    def test_unprotected_entry_surfaces_route_to_r4(self) -> None:
        for path, required in UNPROTECTED_CURRENT_OWNER_EXPECTATIONS.items():
            self.assertTrue(path.is_file(), f"missing current owner: {path}")
            text = path.read_text(encoding="utf-8")
            self.assertIn(required, text, f"{path} is not routed to v4.8 r4 current authority")

    def test_current_validation_routes_to_candidate_003(self) -> None:
        adapter = V48_ADAPTER.read_text(encoding="utf-8")
        active = ACTIVE_CONTEXT.read_text(encoding="utf-8")
        for text in (adapter, active):
            self.assertIn("SX59-POC-ACCEPT-003", text)
            self.assertIn("candidate_003_physical_visual_recheck: NOT_RUN", text)
        self.assertNotIn("acceptance_candidate: SX59-ACCEPT-001", adapter)
        self.assertIn("historical_candidate: SX59-ACCEPT-001 · SUPERSEDED_FOR_CURRENT_POC", active)

    def test_r4_toolchain_overlay_is_routed_without_floating_latest(self) -> None:
        text = V48_ADAPTER.read_text(encoding="utf-8")
        for required in (
            "LOCATION_THEN_GIT_FETCH_SAFE_FF_PULL_THEN_UPDATE_THEN_EDITOR",
            "REVIEW_CANARY_ROLLBACK_THEN_AUTO_APPLY_AND_EXACT_PIN",
            "SHARED_APPROVED_EXACT_PIN_DEFAULT_NO_PER_PROJECT_DUPLICATE_BINARY",
            "FIXED_DEFAULT_PORTS_WITH_EXACT_SESSION_ROUTING",
        ):
            self.assertIn(required, text)
        self.assertNotIn("floating latest", text.lower())

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
