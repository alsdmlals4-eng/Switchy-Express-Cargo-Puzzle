from __future__ import annotations

import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
ADAPTER = ROOT / "skills/PROJECT_BASE_ADAPTER.json"
REGISTRY = ROOT / "skills/SKILL_REGISTRY.json"
HEALTH = ROOT / "docs/PROJECT_OPERATING_HEALTH.json"
MIGRATION = ROOT / "docs/operations/SWITCHY_ADAPTER_MIGRATION_STATE_2026-08-06.json"
CURRENT_APPROVED_PROTECTED_BASE = "cf207f29cd4dcabc5796769f0eb0ca6764c2370e"
HISTORICAL_INITIAL_V48_PROTECTED_BASE = "ae8f4aeae111c5cce4284499b851c0c3f80f6bf3"


class SwitchyThinAdapterMigrationTests(unittest.TestCase):
    def test_incompatible_adapter_shapes_are_preserved_in_migration_state(self) -> None:
        adapter = json.loads(ADAPTER.read_text(encoding="utf-8"))
        state = json.loads(MIGRATION.read_text(encoding="utf-8"))
        for key in (
            "legacy_routing",
            "legacy_validators",
            "legacy_gdd_sheet",
            "legacy_protected_baseline",
            "legacy_project_registry",
        ):
            self.assertIn(key, state)
        for key in ("base_routes", "project_routes", "inactive_routes"):
            self.assertTrue(all(isinstance(route, dict) for route in adapter["routing"][key]))
        self.assertTrue(all(isinstance(command, str) and command for command in adapter["validators"]))

    def test_project_skill_keeps_legacy_id_and_adds_base_v1_skill_id(self) -> None:
        registry = json.loads(REGISTRY.read_text(encoding="utf-8"))
        project_entries = [item for item in registry["skills"] if item.get("owner") == "project"]
        self.assertEqual(1, len(project_entries))
        entry = project_entries[0]
        self.assertEqual("switchy-express-design", entry["id"])
        self.assertEqual(entry["id"], entry["skill_id"])
        self.assertTrue(all("skill_id" not in item for item in registry["skills"] if item.get("owner") == "base"))

    def test_adapter_uses_v2_approved_pr_base_and_migration_only_sheet_state(self) -> None:
        adapter = json.loads(ADAPTER.read_text(encoding="utf-8"))
        self.assertEqual(2, adapter["schema_version"])
        self.assertEqual("switchy-express-cargo-puzzle", adapter["project"]["project_id"])
        protected = adapter["protected_baseline"]
        self.assertEqual(CURRENT_APPROVED_PROTECTED_BASE, protected["commit"])
        self.assertEqual("GITHUB_PR_BASE", protected["authority_kind"])
        self.assertEqual("github.event.pull_request.base.sha", protected["authority_ref"])
        self.assertEqual("CANONICAL_ADAPTER_SOURCE", protected["policy_source_type"])
        self.assertNotEqual(HISTORICAL_INITIAL_V48_PROTECTED_BASE, protected["commit"])
        sheet = adapter["gdd_sheet"]
        self.assertEqual("NOT_CONFIGURED", sheet["sync_status"])
        self.assertEqual("HISTORICAL_SYNCED", sheet["declared_sync_status"])
        self.assertEqual("GOOGLE_SHEETS_LEGACY_MIGRATION_SOURCE", sheet["role"])
        self.assertEqual("MIGRATION_COMPATIBILITY_SURFACE", sheet["workspace_status"])
        self.assertFalse(sheet["new_input_allowed"])
        planning = adapter["shared_overrides"]["managing-project-intake-and-work-contract"]["planning_first_governance"]
        self.assertEqual("NOTION_DEFAULT_PROJECT_WORKSPACE", planning["current_human_workspace"])
        self.assertEqual("DEC-BASE-20260805-001", json.loads(MIGRATION.read_text(encoding="utf-8"))["decision_id"])

    def test_strict_operating_health_preserves_not_run_gates(self) -> None:
        health = json.loads(HEALTH.read_text(encoding="utf-8"))
        self.assertEqual("PROJECT_OPERATING_HEALTH", health["artifact_role"])
        self.assertEqual("NOT_RUN", health["critical_gates"]["device"])
        self.assertEqual("NOT_RUN", health["critical_gates"]["accessibility"])
        self.assertEqual("NOT_RUN", health["critical_gates"]["human"])
        sources = {item["source"] for item in health["evidence"]["operating"]}
        self.assertIn("docs/operations/SWITCHY_ADAPTER_MIGRATION_STATE_2026-08-06.json", sources)


if __name__ == "__main__":
    unittest.main()
