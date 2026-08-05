from __future__ import annotations

import json
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
ADAPTER = ROOT / "skills/PROJECT_BASE_ADAPTER.json"
HEALTH = ROOT / "docs/PROJECT_OPERATING_HEALTH.json"
MIGRATION = ROOT / "docs/operations/SWITCHY_ADAPTER_MIGRATION_STATE_2026-08-06.json"


class SwitchyThinAdapterMigrationTests(unittest.TestCase):
    def test_incompatible_adapter_shapes_are_preserved_in_migration_state(self) -> None:
        adapter = json.loads(ADAPTER.read_text(encoding="utf-8"))
        state = json.loads(MIGRATION.read_text(encoding="utf-8"))
        for key in ("legacy_routing", "legacy_validators", "legacy_gdd_sheet", "legacy_protected_baseline"):
            self.assertIn(key, state)
        for key in ("base_routes", "project_routes", "inactive_routes"):
            self.assertTrue(all(isinstance(route, dict) for route in adapter["routing"][key]))
        self.assertTrue(all(isinstance(command, str) and command for command in adapter["validators"]))

    def test_adapter_uses_canonical_baseline_and_sheet_states(self) -> None:
        adapter = json.loads(ADAPTER.read_text(encoding="utf-8"))
        self.assertIn(adapter["protected_baseline"]["authority_kind"], {"REMOTE_TRACKING_REF", "GITHUB_PR_BASE"})
        self.assertIn(adapter["protected_baseline"]["policy_source_type"], {"FIRST_MIGRATION_LEGACY_SOURCE", "CANONICAL_ADAPTER_SOURCE"})
        self.assertEqual("CURRENT", adapter["gdd_sheet"]["sync_status"])
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
