from __future__ import annotations

import hashlib
import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
PROJECT_ADAPTER = ROOT / "skills/PROJECT_BASE_ADAPTER.json"
PROJECT_SNAPSHOT = ROOT / "skills/PROJECT_SKILL_SNAPSHOT.json"
V48_ADAPTER = ROOT / "PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md"
AGENTS = ROOT / "AGENTS.md"
BASE_RULES = ROOT / "docs/BASE_RULES_VERSION.md"
MIGRATION_STATE = ROOT / "docs/operations/SWITCHY_ADAPTER_MIGRATION_STATE_2026-08-06.json"
BASE_ADAPTER_WORKFLOW = ROOT / ".github/workflows/validate-project-base-adapter.yml"


class GoogleSheetRetirementTests(unittest.TestCase):
    def test_active_adapter_has_no_sheet_workspace_or_sync_route(self) -> None:
        adapter = json.loads(PROJECT_ADAPTER.read_text(encoding="utf-8"))
        sheet = adapter["gdd_sheet"]
        # These three values remain schema-v2 compatibility labels until Base
        # publishes retirement enums. retirement_state is the active semantic.
        self.assertEqual("GOOGLE_SHEETS_LEGACY_MIGRATION_SOURCE", sheet["role"])
        self.assertEqual("MIGRATION_COMPATIBILITY_SURFACE", sheet["workspace_status"])
        self.assertEqual("NOT_CONFIGURED", sheet["sync_status"])
        self.assertEqual("RETIRED_NO_ACTIVE_USE", sheet["retirement_state"])
        self.assertFalse(sheet["new_input_allowed"])
        self.assertFalse(sheet["read_for_normal_work"])
        self.assertNotIn("spreadsheet_id", sheet)
        self.assertNotIn("url", sheet)

        planning = adapter["shared_overrides"]["managing-project-intake-and-work-contract"]["planning_first_governance"]
        self.assertEqual("NOTION_DEFAULT_PROJECT_WORKSPACE", planning["current_human_workspace"])
        self.assertEqual("GITHUB_REPOSITORY_AND_ACTUAL_RUNTIME", planning["runtime_structured_authority"])
        self.assertNotIn("legacy_post_merge_sheet_state", planning)
        self.assertNotIn("legacy_pre_merge_sheet_state", planning)

    def test_current_entry_surfaces_mark_sheet_retired(self) -> None:
        expected = "GOOGLE_SHEETS: RETIRED_NO_ACTIVE_USE"
        for path in (AGENTS, BASE_RULES):
            text = path.read_text(encoding="utf-8")
            self.assertIn(expected, text, f"{path} does not retire Google Sheets from active work")

    def test_v48_adapter_routes_only_notion_and_github_for_active_work(self) -> None:
        text = V48_ADAPTER.read_text(encoding="utf-8")
        self.assertIn("google_sheets_policy: RETIRED_NO_ACTIVE_USE", text)
        self.assertIn("GOOGLE_SHEETS: RETIRED_NO_ACTIVE_USE", text)
        self.assertNotIn("COMPATIBILITY_ONLY_MIGRATION_SOURCE_UNTIL_REMOVAL", text)

    def test_historical_migration_state_keeps_sheet_provenance(self) -> None:
        state = json.loads(MIGRATION_STATE.read_text(encoding="utf-8"))
        legacy = state["legacy_gdd_sheet"]
        self.assertEqual("USER_FACING_GDD_WORKSPACE", legacy["role"])
        self.assertTrue(legacy["spreadsheet_id"])
        self.assertTrue(legacy["url"])
        self.assertEqual("NONE", state["google_sheet_mutation"])

    def test_stale_protected_approval_manifest_is_not_injected_without_label(self) -> None:
        workflow = BASE_ADAPTER_WORKFLOW.read_text(encoding="utf-8")
        self.assertIn('if [ -f "$APPROVAL_PATH" ] && [ "$EXTERNAL_APPROVAL" = "true" ]; then', workflow)
        self.assertNotIn('if [ -f "$APPROVAL_PATH" ]; then\n            APPROVAL_ARGS=', workflow)

    def test_generated_snapshot_tracks_current_adapter_raw_bytes(self) -> None:
        snapshot = json.loads(PROJECT_SNAPSHOT.read_text(encoding="utf-8"))
        actual = hashlib.sha256(PROJECT_ADAPTER.read_bytes()).hexdigest()
        self.assertEqual(actual, snapshot["source_registry"]["sha256"])


if __name__ == "__main__":
    unittest.main()
