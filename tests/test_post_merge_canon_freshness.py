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
AUDIT = ROOT / "기획서" / "50_제작_검증" / "SX_AUD_025_POST_MERGE_CANON_FRESHNESS_AND_GATE_RECOVERY.md"


def read(path: Path) -> str:
    return path.read_text(encoding="utf-8")


class PostMergeCanonFreshnessTests(unittest.TestCase):
    def test_active_canon_uses_main_and_merged_pr_83(self) -> None:
        combined = "\n".join((read(README), read(ACTIVE), read(GATES)))

        for stale in (
            "branch: agent/pc-vertical-slice-demo-design",
            "`agent/pc-vertical-slice-demo-design` 브랜치",
            "PR #83: DRAFT",
            "pull_request_83: DRAFT",
            "PR #83은 Draft",
            "MAIN_PENDING",
            "PR #83 MERGE REVIEW: BLOCKED",
        ):
            self.assertNotIn(stale, combined)

        for required in (
            "branch: main",
            "pull_request_83: MERGED",
            "PR #83 MERGE: PASS",
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
        self.assertIn("SX-DEC-027~039", rules)
        self.assertIn("Base v9.4.3 release pin은 유지", rules)
        self.assertIn("현재 제품 보호 권위가 아니다", rules)

        self.assertEqual("9.4.3", adapter["base_release"]["version"])
        self.assertEqual(
            "1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo",
            adapter["gdd_sheet"]["spreadsheet_id"],
        )
        self.assertEqual("SYNCED", adapter["gdd_sheet"]["declared_sync_status"])
        self.assertEqual("CURRENT", adapter["gdd_sheet"]["sync_status"])
        self.assertNotIn("5e803762f3c4f93b7cb31669312111d708507ef5", serialized_adapter)

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
