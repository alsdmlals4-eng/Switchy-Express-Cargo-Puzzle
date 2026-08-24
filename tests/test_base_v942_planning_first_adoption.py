from __future__ import annotations

import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
ADAPTER = ROOT / "skills/PROJECT_BASE_ADAPTER.json"


class BaseV942PlanningFirstAdoptionTests(unittest.TestCase):
    def test_released_identity_and_planning_contract(self) -> None:
        adapter = json.loads(ADAPTER.read_text(encoding="utf-8"))
        release = adapter["base_release"]
        self.assertEqual("9.4.3", release["version"])
        self.assertEqual("7dd1a4f80388bc5faca767ff74a3eb32dc9d0ac8", release["release_commit"])
        self.assertEqual("da33a350d61b8adc52df97fccc7001708a933370", release["release_evidence_commit"])
        self.assertEqual("0b7c94f38d959efc0fc9442274c60b2e268a3c97", release["finalization_commit"])
        planning = adapter["shared_overrides"]["managing-project-intake-and-work-contract"]["planning_first_governance"]
        self.assertEqual("base-v9.4.3.lock.json", planning["base_release_lock"])
        self.assertEqual(10, planning["max_approved_decisions_per_batch"])
        self.assertEqual("RECOMMENDED_DEFAULT", planning["numeric_default_state"])
        self.assertEqual("GRILL_ME_REQUIRED", planning["planning_conflict_state"])
        self.assertEqual("APPROVED_PENDING_MERGE", planning["legacy_pre_merge_sheet_state"])
        self.assertEqual("SYNCED_TO_MAIN", planning["legacy_post_merge_sheet_state"])
        self.assertEqual("NOTION_DEFAULT_PROJECT_WORKSPACE", planning["current_human_workspace"])
        self.assertEqual("NOT_RUN", planning["actual_project_batch_execution"])

    def test_switchy_product_and_workspace_boundaries_remain_safe(self) -> None:
        adapter = json.loads(ADAPTER.read_text(encoding="utf-8"))
        self.assertEqual("MIGRATION_ONLY", adapter["gdd_sheet"]["sync_status"])
        self.assertEqual("HISTORICAL_SYNCED", adapter["gdd_sheet"]["declared_sync_status"])
        self.assertEqual("COMPATIBILITY_ONLY_MIGRATION_SOURCE", adapter["gdd_sheet"]["role"])
        self.assertEqual("NOTION_DEFAULT_PROJECT_WORKSPACE", adapter["workspace"]["human_workspace"])
        self.assertEqual("Godot 4.7.1", adapter["project"]["engine"])
        self.assertEqual("Android", adapter["project"]["platform"])
        self.assertEqual(["project.godot", "game/**", "assets/**", "기획서/**"], adapter["protected_paths"])
        self.assertEqual(
            "NOT_RUN",
            adapter["shared_overrides"]["orchestrating-deepseek-worktrees"]["actual_external_ai_worktree_execution"],
        )


if __name__ == "__main__":
    unittest.main()
