from __future__ import annotations

import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
PROJECT_ADAPTER = ROOT / "skills/PROJECT_BASE_ADAPTER.json"
V48_ADAPTER = ROOT / "PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md"
AGENTS = ROOT / "AGENTS.md"
START_HERE = ROOT / "기획서/00_프로젝트_허브/START_HERE.md"
CURRENT_DECISIONS = ROOT / "기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md"
ACTIVE_CONTEXT = ROOT / "기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md"
BASE_RULES = ROOT / "docs/BASE_RULES_VERSION.md"


class GoogleSheetRetirementTests(unittest.TestCase):
    def test_active_adapter_has_no_sheet_workspace_or_sync_route(self) -> None:
        adapter = json.loads(PROJECT_ADAPTER.read_text(encoding="utf-8"))
        sheet = adapter["gdd_sheet"]
        self.assertEqual("RETIRED_HISTORICAL_REFERENCE", sheet["role"])
        self.assertEqual("RETIRED_NO_ACTIVE_USE", sheet["workspace_status"])
        self.assertEqual("RETIRED", sheet["sync_status"])
        self.assertFalse(sheet["new_input_allowed"])
        self.assertFalse(sheet["read_for_normal_work"])
        self.assertNotIn("spreadsheet_id", sheet)
        self.assertNotIn("url", sheet)

        planning = adapter["shared_overrides"]["managing-project-intake-and-work-contract"]["planning_first_governance"]
        self.assertEqual("NOTION_DEFAULT_PROJECT_WORKSPACE", planning["current_human_workspace"])
        self.assertEqual("GITHUB_REPOSITORY_AND_ACTUAL_RUNTIME", planning["runtime_structured_authority"])
        self.assertNotIn("legacy_post_merge_sheet_state", planning)
        self.assertNotIn("legacy_pre_merge_sheet_state", planning)

    def test_current_human_and_execution_owners_mark_sheet_retired(self) -> None:
        expected = "GOOGLE_SHEETS: RETIRED_NO_ACTIVE_USE"
        for path in (AGENTS, START_HERE, CURRENT_DECISIONS, ACTIVE_CONTEXT, BASE_RULES):
            text = path.read_text(encoding="utf-8")
            self.assertIn(expected, text, f"{path} does not retire Google Sheets from active work")

    def test_v48_adapter_routes_only_notion_and_github_for_active_work(self) -> None:
        text = V48_ADAPTER.read_text(encoding="utf-8")
        self.assertIn("google_sheets_policy: RETIRED_NO_ACTIVE_USE", text)
        self.assertIn("GOOGLE_SHEETS: RETIRED_NO_ACTIVE_USE", text)
        self.assertNotIn("COMPATIBILITY_ONLY_MIGRATION_SOURCE_UNTIL_REMOVAL", text)


if __name__ == "__main__":
    unittest.main()
