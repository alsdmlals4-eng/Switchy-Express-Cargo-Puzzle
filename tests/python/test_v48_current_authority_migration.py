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
PR_BASE_AT_MIGRATION = "9c3be67cf99221d5007f0332be6935e81a6954bb"

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
            "skill_coverage_policy: CURRENT_REGISTRY_FULL_INVENTORY_TRIGGERED_PROGRESSIVE_LOAD_WITH_EXECUTION_RECEIPT",
        ):
            self.assertIn(required, text)
        self.assertNotIn("revision: '2026-08-24-r2'", text)
        self.assertNotIn("current_user_contract_role: USER_PROVIDED_V4_8_R4_CONTRACT", text)

    def test_unprotected_entry_surfaces_route_to_r54(self) -> None:
        for path, required in UNPROTECTED_CURRENT_OWNER_EXPECTATIONS.items():
            self.assertTrue(path.is_file(), f"missing current owner: {path}")
            text = path.read_text(encoding="utf-8")
            self.assertIn(required, text, f"{path} is not routed to v4.8 r5.4 current authority")
            self.assertIn(CURRENT_R54_ROLE, text)

    def test_current_validation_routes_candidate_003_to_prechange_history(self) -> None:
        adapter = V48_ADAPTER.read_text(encoding="utf-8")
        active = ACTIVE_CONTEXT.read_text(encoding="utf-8")
        for text in (adapter, active):
            self.assertIn("SX59-POC-ACCEPT-003", text)
            self.assertIn("SX60-POC-ACCEPT-003", text)
            self.assertIn("SX-DEC-060", text)
            self.assertNotIn("current_candidate: SX59-POC-ACCEPT-003", text)
        self.assertIn("HISTORICAL", adapter)
        self.assertIn("candidate_003_role_after_sx_dec_060: HISTORICAL_EXACT_BYTES_ONLY", active)

    def test_r54_execution_overlay_keeps_safe_exact_pin_and_retired_local_codex(self) -> None:
        text = V48_ADAPTER.read_text(encoding="utf-8")
        for required in (
            "LOCATION_THEN_GIT_FETCH_SAFE_FF_PULL_THEN_UPDATE_THEN_EDITOR",
            "REVIEW_CANARY_ROLLBACK_THEN_AUTO_APPLY_AND_EXACT_PIN",
            "SHARED_APPROVED_EXACT_PIN_DEFAULT_NO_PER_PROJECT_DUPLICATE_BINARY",
            "FIXED_DEFAULT_PORTS_WITH_EXACT_SESSION_ROUTING",
            "GPT_LOCAL_CODEX_ORCHESTRATION_RETIRED",
            "CODEX_GODOT_PRODUCT_IMPLEMENTATION_HANDOFF",
        ):
            self.assertIn(required, text)
        self.assertNotIn("floating latest", text.lower())

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

    def test_project_skill_routes_current_sx060_candidate_sequence(self) -> None:
        text = PROJECT_SKILL.read_text(encoding="utf-8")
        current = text.split("### Current Gate authority", 1)[1].split("## SX-DEC-060 station / preflight contract", 1)[0]
        for required in (
            "SX60-POC-ACCEPT-008 machine-primary package verification",
            "five-person comprehension and player-experience study are not required gates",
            "final user review is optional, only when requested",
        ):
            self.assertIn(required, current)
        self.assertNotIn("Candidate 003 physical visual recheck", current)
        self.assertNotIn("DEFAULT ENTRYPOINT: LEGACY", text)

    def test_migration_does_not_authorize_deferred_product_packages(self) -> None:
        text = V48_ADAPTER.read_text(encoding="utf-8")
        for required in (
            "SX-DEC-056A: PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED",
            "SX-DEC-056B: BLOCKED_BY_AUTHORITATIVE_SCORE_COMBO_RUNTIME",
            "SX-DEC-057: PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED",
            "SX-DEC-058: PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED",
            "player_experience: NOT_REQUIRED_BY_USER_VALIDATION_POLICY",
        ):
            self.assertIn(required, text)


if __name__ == "__main__":
    unittest.main()
