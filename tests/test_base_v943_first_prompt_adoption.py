from __future__ import annotations

import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ADAPTER = ROOT / "skills/PROJECT_BASE_ADAPTER.json"
PAYLOAD = "7dd1a4f80388bc5faca767ff74a3eb32dc9d0ac8"
EVIDENCE = "da33a350d61b8adc52df97fccc7001708a933370"
FINAL = "0b7c94f38d959efc0fc9442274c60b2e268a3c97"


def load() -> dict:
    return json.loads(ADAPTER.read_text(encoding="utf-8"))


class AdoptionTests(unittest.TestCase):
    def test_release_and_route(self) -> None:
        adapter = load()
        release = adapter["base_release"]
        base_routes = {
            route["skill_id"] for route in adapter["routing"]["base_routes"]
        }
        self.assertEqual(
            ("9.4.3", PAYLOAD, EVIDENCE, FINAL),
            (
                release["version"],
                release["release_commit"],
                release["release_evidence_commit"],
                release["finalization_commit"],
            ),
        )
        self.assertIn("managing-project-intake-and-work-contract", base_routes)
        self.assertFalse(
            (ROOT / "skills/managing-project-intake-and-work-contract/SKILL.md").exists()
        )

    def test_first_prompt_and_planning(self) -> None:
        adapter = load()
        intake = adapter["shared_overrides"][
            "managing-project-intake-and-work-contract"
        ]
        first_prompt = intake["first_prompt_governance"]
        planning = intake["planning_first_governance"]
        self.assertEqual(
            ["route", "first-prompt", "contract", "clarify"],
            first_prompt["instruction_flow"],
        )
        self.assertEqual("AWAITING_USER_CONFIRMATION", first_prompt["unconfirmed_state"])
        self.assertEqual("REUSE_EXACT_APPROVAL_REFERENCE", first_prompt["approval_reuse"])
        self.assertEqual("base-v9.4.3.lock.json", first_prompt["base_release_lock"])
        self.assertEqual(FINAL, first_prompt["base_release_finalization_commit"])
        self.assertEqual("NOT_RUN", first_prompt["actual_project_instruction_execution"])
        self.assertEqual("base-v9.4.3.lock.json", planning["base_release_lock"])
        self.assertEqual(10, planning["max_approved_decisions_per_batch"])

    def test_boundaries(self) -> None:
        adapter = load()
        self.assertEqual("CURRENT", adapter["gdd_sheet"]["sync_status"])
        self.assertEqual("SYNCED", adapter["gdd_sheet"]["declared_sync_status"])
        self.assertEqual(
            ["project.godot", "game/**", "assets/**", "기획서/**"],
            adapter["protected_paths"],
        )
        self.assertEqual(
            "NOT_RUN",
            adapter["shared_overrides"]["orchestrating-deepseek-worktrees"][
                "actual_external_ai_worktree_execution"
            ],
        )


if __name__ == "__main__":
    unittest.main()
