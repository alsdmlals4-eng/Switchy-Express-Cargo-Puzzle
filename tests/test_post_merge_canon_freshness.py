from __future__ import annotations

import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
README = ROOT / "README.md"
ACTIVE = ROOT / "기획서" / "00_프로젝트_허브" / "ACTIVE_CONTEXT.md"
GATES = ROOT / "기획서" / "00_프로젝트_허브" / "DEVELOPMENT_GATES.md"
BASE_RULES = ROOT / "docs" / "BASE_RULES_VERSION.md"
ADAPTER = ROOT / "skills" / "PROJECT_BASE_ADAPTER.json"
MIGRATION = ROOT / "docs" / "operations" / "SWITCHY_ADAPTER_MIGRATION_STATE_2026-08-06.json"
AUDIT = ROOT / "기획서" / "50_제작_검증" / "SX_AUD_025_POST_MERGE_CANON_FRESHNESS_AND_GATE_RECOVERY.md"

HISTORICAL_SHEET_CANON_MAIN = "dff1653738f1eead3cacff303080924d662767e2"
CURRENT_ADAPTER_PR_BASE = "cf207f29cd4dcabc5796769f0eb0ca6764c2370e"
VERIFIED_PRODUCT_MAIN = "1339a9467312d0ac680725894a9efb59746ec2cc"


def read(path: Path) -> str:
    return path.read_text(encoding="utf-8")


class PostMergeCanonFreshnessTests(unittest.TestCase):
    def test_active_canon_uses_phase_b_semantics_and_preserves_pr83_history(self) -> None:
        readme = read(README)
        active = read(ACTIVE)
        gates = read(GATES)
        combined = "\n".join((readme, active, gates))

        for stale_active_state in (
            "branch: agent/pc-vertical-slice-demo-design",
            "active_user_branch: agent/pc-vertical-slice-demo-design",
            "PR #83: DRAFT",
            "pull_request_83: DRAFT",
            "pr_83: DRAFT",
            "sheet_state: MAIN_PENDING",
            "PR #83 MERGE REVIEW: BLOCKED",
            "SX-DEC-055_RUNTIME_IMPLEMENTATION_USER_DEFERRED",
            "USER_DEFERRED_AFTER_DOR",
            "user_planning_complete_gate: NOT_GRANTED",
            "phase_b_final_planning_review: NOT_RUN",
            "sx_dec_055_runtime_implementation: NOT_STARTED",
        ):
            self.assertNotIn(stale_active_state, combined)

        self.assertIn("default_branch: main", active)
        self.assertIn("user_planning_complete_gate: GRANTED", active)
        self.assertIn("phase_b_final_planning_review: SX-AUD-047 · PASS", active)
        self.assertIn("build_authority: AUTHORIZED_AFTER_PHASE_B_CANON_SYNC_MERGE", active)
        self.assertIn("sx_dec_055_runtime_implementation: MERGED_MAIN_VERIFIED", active)
        self.assertIn("runtime_integrated: true", active)
        self.assertIn("sx_dec_055_merge_main: 534a7318b349cd3e784a3467125f9ebd23124d8a", active)

        self.assertIn("pr_83: MERGED", readme)
        self.assertIn("PR #83/#99/#100 MERGE: PASS", gates)

        for required in (
            "SX-AUD-025",
            "repository_main_observed",
            "latest_automated_verified_product_main",
            "RETEST_REQUIRED",
        ):
            self.assertIn(required, combined)

    def test_base_release_pin_and_finite_protection_are_truthful(self) -> None:
        rules = read(BASE_RULES)
        adapter = json.loads(read(ADAPTER))
        serialized_adapter = json.dumps(adapter, ensure_ascii=False)

        self.assertIn("GMB-002", rules)
        self.assertIn("SX-DEC-027~036", rules)
        self.assertIn("SX-DEC-037~039", rules)
        self.assertIn("Base v9.4.3 release pin은 유지", rules)
        self.assertIn("현재 제품 보호 권위가 아니다", rules)
        self.assertIn("GOOGLE_SHEETS: RETIRED_NO_ACTIVE_USE", rules)

        self.assertEqual(2, adapter["schema_version"])
        self.assertEqual("9.4.3", adapter["base_release"]["version"])
        sheet = adapter["gdd_sheet"]
        self.assertEqual("HISTORICAL_SYNCED", sheet["declared_sync_status"])
        self.assertEqual("NOT_CONFIGURED", sheet["sync_status"])
        self.assertEqual("GOOGLE_SHEETS_LEGACY_MIGRATION_SOURCE", sheet["role"])
        self.assertEqual("MIGRATION_COMPATIBILITY_SURFACE", sheet["workspace_status"])
        self.assertEqual("RETIRED_NO_ACTIVE_USE", sheet["retirement_state"])
        self.assertFalse(sheet["read_for_normal_work"])
        self.assertNotIn("spreadsheet_id", sheet)
        self.assertNotIn("url", sheet)
        self.assertNotIn("5e803762f3c4f93b7cb31669312111d708507ef5", serialized_adapter)

    def test_adapter_baseline_is_current_while_sheet_provenance_moves_to_history(self) -> None:
        adapter = json.loads(read(ADAPTER))
        migration = json.loads(read(MIGRATION))
        sheet = adapter["gdd_sheet"]
        baseline = adapter["protected_baseline"]
        legacy_sheet = migration["legacy_gdd_sheet"]

        self.assertEqual(CURRENT_ADAPTER_PR_BASE, baseline["commit"])
        self.assertEqual(HISTORICAL_SHEET_CANON_MAIN, sheet["decision_commit"])
        self.assertEqual(HISTORICAL_SHEET_CANON_MAIN, sheet["repository_main_observed"])
        self.assertEqual(VERIFIED_PRODUCT_MAIN, sheet["latest_automated_verified_product_main"])
        self.assertEqual("SX-AUD-025", sheet["canonical_freshness_audit"])
        self.assertEqual("HISTORICAL_COMPATIBILITY_EVIDENCE", sheet["provenance_status"])
        self.assertEqual("RETIRED_NO_ACTIVE_USE", sheet["retirement_state"])
        self.assertFalse(sheet["new_input_allowed"])
        self.assertFalse(sheet["read_for_normal_work"])
        self.assertTrue(legacy_sheet["spreadsheet_id"])
        self.assertTrue(legacy_sheet["url"])
        self.assertEqual("NONE", migration["google_sheet_mutation"])
        planning = adapter["shared_overrides"]["managing-project-intake-and-work-contract"]["planning_first_governance"]
        self.assertEqual("NOTION_DEFAULT_PROJECT_WORKSPACE", planning["current_human_workspace"])
        self.assertIn("python tests/test_post_merge_canon_freshness.py", adapter["validators"])

    def test_audit_preserves_manual_evidence_ceiling_and_split_boundary(self) -> None:
        text = read(AUDIT)

        for required in (
            "F143",
            "F144",
            "F145",
            "F146",
            "F147",
            "DEFERRED_TO_ADAPTER_ONLY_FOLLOWUP",
            "pc_local_route_and_mid_run_retest: RETEST_REQUIRED",
            "windows_artifact_runtime: NOT_RUN",
            "android_device_smoke: NOT_RUN",
            "production_cutover: BLOCKED",
        ):
            self.assertIn(required, text)

        self.assertNotIn("pc_local_route_and_mid_run_retest: PASS", text)
        self.assertNotIn("windows_artifact_runtime: PASS", text)
        self.assertNotIn("android_device_smoke: PASS", text)
        self.assertNotIn("production_cutover: PASS", text)


if __name__ == "__main__":
    unittest.main()
