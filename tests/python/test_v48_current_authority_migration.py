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

CURRENT_R54_REVISION = "2026-08-26-r5.4-superset-final"
CURRENT_R54_ROLE = "USER_PROVIDED_V4_8_R5_4_SUPERSET_FINAL_CONTRACT"
CURRENT_R54_SHA256 = "fdf238c202cfac6d3a824aae49b8ac525fba023e31bba7df6ece64a2790365a0"
HISTORICAL_R4_REVISION = "2026-08-24-r4"
HISTORICAL_R2_SHA256 = "6f0541048e084746f6777223521361d0339dbfb2e223c70947f694f1c050f508"
PR_BASE_AT_MIGRATION = "383b323658e9669345722367a1f17e4cc9d170bb"

UNPROTECTED_CURRENT_OWNER_EXPECTATIONS = {
    ROOT / "AGENTS.md": f"revision: {CURRENT_R54_REVISION}",
    ROOT / "README.md": f"work_instruction: v4.8 · revision {CURRENT_R54_REVISION} · SWITCHY_THIN_ADAPTER",
}


class V48CurrentAuthorityMigrationTests(unittest.TestCase):
    def test_v48_thin_adapter_binds_r54_without_deleting_history(self) -> None:
        self.assertTrue(V48_ADAPTER.is_file(), "current v4.8 project thin adapter is missing")
        self.assertTrue(V47_ADAPTER.is_file(), "v4.7 rollback/history adapter must be retained")
        text = V48_ADAPTER.read_text(encoding="utf-8")
        for required in (
            "contract_version: '4.8'",
            f"revision: '{CURRENT_R54_REVISION}'",
            f"current_user_contract_role: {CURRENT_R54_ROLE}",
            f"source_r5_4_sha256: {CURRENT_R54_SHA256}",
            f"historical_r4_revision: {HISTORICAL_R4_REVISION}",
            f"historical_r2_sha256: {HISTORICAL_R2_SHA256}",
            "base_snapshot_policy: ALWAYS_REFETCH_CURRENT_COMPLETED_MAIN",
            "google_sheets_policy: RETIRED_NO_ACTIVE_USE",
            "fresh_read_bootstrap_policy: PROJECT_GITHUB_ONLY_RECONSTRUCTION_REQUIRED",
            "gpt_local_codex_orchestration_policy: RETIRED",
            "skill_coverage_policy: TRIGGERED_PROGRESSIVE_LOAD_WITH_EXECUTION_RECEIPT",
        ):
            self.assertIn(required, text)
        self.assertNotIn("revision: '2026-08-24-r2'", text)
        self.assertNotIn("current_user_contract_role: USER_PROVIDED_V4_8_R4_CONTRACT", text)

    def test_entry_routes_to_adapter_source_identity(self) -> None:
        agents = (ROOT / "AGENTS.md").read_text(encoding="utf-8")
        self.assertIn(V48_ADAPTER.name, agents)
        self.assertTrue(V48_ADAPTER.is_file())
        source = V48_ADAPTER.read_text(encoding="utf-8")
        self.assertIn(CURRENT_R54_SHA256, source)
        self.assertIn(CURRENT_R54_ROLE, source)

    def test_candidate_history_is_owned_by_context_not_execution_adapter(self) -> None:
        active = ACTIVE_CONTEXT.read_text(encoding="utf-8")
        for token in ("SX59-POC-ACCEPT-003", "SX60-POC-ACCEPT-003",
                      "candidate_003_role_after_sx_dec_060: HISTORICAL_EXACT_BYTES_ONLY"):
            self.assertIn(token, active)
        adapter = V48_ADAPTER.read_text(encoding="utf-8")
        self.assertIn("Active Context", adapter)
        self.assertNotIn("current_candidate:", adapter)

    def test_current_execution_preserves_pins_without_forced_handoff_or_updates(self) -> None:
        text = V48_ADAPTER.read_text(encoding="utf-8")
        for token in ("PROJECT_FIRST_CURRENT_AUTHORITY_READ",
                      "NO_PLUGIN_GLOBAL_OR_ENGINE_CHANGE_WITHOUT_SEPARATE_APPROVAL",
                      "UNIFIED_WORK_EXECUTION_CAPABILITY_BASED",
                      "SHARED_APPROVED_EXACT_PIN_DEFAULT_NO_PER_PROJECT_DUPLICATE_BINARY",
                      "gpt_local_codex_orchestration_policy: RETIRED"):
            self.assertIn(token, text)
        self.assertNotIn("INDEPENDENT_GODOT_PRODUCT_IMPLEMENTATION_HANDOFF_ONLY", text)

    def test_project_base_adapter_uses_v2_and_sheet_is_retired(self) -> None:
        adapter = json.loads(PROJECT_ADAPTER.read_text(encoding="utf-8"))
        self.assertEqual(2, adapter["schema_version"])
        self.assertEqual("switchy-express-cargo-puzzle", adapter["project"]["project_id"])
        self.assertEqual(PR_BASE_AT_MIGRATION, adapter["protected_baseline"]["commit"])
        sheet = adapter["gdd_sheet"]
        self.assertEqual("GOOGLE_SHEETS_LEGACY_MIGRATION_SOURCE", sheet["role"])
        self.assertEqual("MIGRATION_COMPATIBILITY_SURFACE", sheet["workspace_status"])
        self.assertEqual("NOT_CONFIGURED", sheet["sync_status"])
        self.assertEqual("HISTORICAL_SYNCED", sheet["declared_sync_status"])
        self.assertEqual("RETIRED_NO_ACTIVE_USE", sheet["retirement_state"])
        self.assertFalse(sheet["new_input_allowed"])
        self.assertFalse(sheet["read_for_normal_work"])
        self.assertNotIn("spreadsheet_id", sheet)
        self.assertNotIn("url", sheet)
        planning = adapter["shared_overrides"]["managing-project-intake-and-work-contract"]["planning_first_governance"]
        self.assertEqual("GITHUB_REPOSITORY_ONLY_PROJECT_WORKSPACE", planning["current_human_workspace"])
        self.assertEqual("GITHUB_REPOSITORY_AND_ACTUAL_RUNTIME", planning["runtime_structured_authority"])

    def test_project_skill_routes_package_identity_to_current_owner(self) -> None:
        text = PROJECT_SKILL.read_text(encoding="utf-8")
        self.assertIn("Active Context", text)
        self.assertIn("PLAYTEST_PLAN.md", text)
        self.assertNotIn("SX60-POC-ACCEPT-010", text)
        self.assertIn("Five-person comprehension and a player-experience study are not required", text)

    def test_migration_does_not_authorize_deferred_product_packages(self) -> None:
        text = V48_ADAPTER.read_text(encoding="utf-8")
        self.assertIn("보류된 SX-DEC-056~058 계획을 이번 운영 개선 승인으로 구현하지 않는다.", text)
        active = ACTIVE_CONTEXT.read_text(encoding="utf-8")
        self.assertIn("IMPLEMENTATION_NOT_AUTHORIZED", active)
        self.assertIn("BLOCKED_BY_AUTHORITATIVE_SCORE_COMBO_RUNTIME", active)


if __name__ == "__main__":
    unittest.main()
