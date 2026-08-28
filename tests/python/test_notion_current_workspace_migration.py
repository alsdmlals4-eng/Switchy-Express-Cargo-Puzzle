from __future__ import annotations

import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
MIGRATION = ROOT / "docs" / "migrations" / "2026-08-28-notion-current-workspace-migration.md"
BASELINE = ROOT / "기획서" / "00_프로젝트_허브" / "FINITE_DELIVERY_PUZZLE_BASELINE.md"
ACTIVE = ROOT / "기획서" / "00_프로젝트_허브" / "ACTIVE_CONTEXT.md"
GDD = ROOT / "docs" / "design" / "PROJECT_AI_PRODUCTION_SPEC.md"


def read(path: Path) -> str:
    return path.read_text(encoding="utf-8")


class NotionCurrentWorkspaceMigrationTests(unittest.TestCase):
    def test_current_notion_structure_has_a_github_only_migration_receipt(self) -> None:
        migration = read(MIGRATION)

        self.assertIn("COMPLETE_FOR_CURRENT_STRUCTURE · GITHUB_ONLY_ACTIVE_WORKSPACE", migration)
        for source_id in (
            "3c41b237-eb1c-8103-9537-ede6dfc5f07e",
            "3c91b237-eb1c-8197-bf13-debb96d444c8",
            "3c51b237-eb1c-81fc-9c39-eca6a5cbdc8e",
            "3c01b237-eb1c-81a0-8bae-dee2470e0576",
            "3c51b237-eb1c-81fa-8d47-d043dae17e11",
            "3c51b237-eb1c-8183-9ec4-ea913a27b697",
        ):
            self.assertIn(source_id, migration)

        for destination in (
            "CURRENT_CONFIRMED_DECISIONS.md",
            "ACTIVE_CONTEXT.md",
            "FINITE_DELIVERY_PUZZLE_BASELINE.md",
            "PROJECT_CORE_SCENE_VISUAL_BOARD.md",
            "PROJECT_AI_PRODUCTION_SPEC.md",
            "ASSET_RIGHTS_AND_PROVENANCE_RECORD.md",
        ):
            self.assertIn(destination, migration)

    def test_current_owners_keep_notion_out_of_the_active_workflow(self) -> None:
        self.assertIn("project_workspace: GITHUB_ONLY", read(ACTIVE))
        self.assertIn("Historical Notion", read(BASELINE))
        self.assertIn("Notion no longer active", read(GDD))
