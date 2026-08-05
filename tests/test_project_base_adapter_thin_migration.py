from __future__ import annotations

import json
import re
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ADAPTER_PATH = ROOT / "skills/PROJECT_BASE_ADAPTER.json"
REGISTRY_PATH = ROOT / "skills/SKILL_REGISTRY.json"
HEALTH_PATH = ROOT / "docs/PROJECT_OPERATING_HEALTH.json"
STATE_PATH = ROOT / "docs/PROJECT_OPERATING_STATE.json"
MIGRATION_PATH = ROOT / "docs/operations/PROJECT_BASE_ADAPTER_MIGRATION_2026-08-06.md"
WORKFLOW_PATH = ROOT / ".github/workflows/validate-project-base-adapter.yml"

EXPECTED_ROOT_KEYS = {
    "artifact_role", "base_release", "compatibility", "gdd_sheet",
    "project", "protected_baseline", "protected_paths", "routing",
    "schema_version", "shared_overrides", "skill_registry", "validators",
}
BASE_KEYS = {
    "repository", "version", "release_commit",
    "release_evidence_commit", "finalization_commit",
}
COMPATIBILITY_KEYS = {"cycle", "views", "legacy_inputs"}
ROUTING_KEYS = {
    "base_routes", "project_routes", "inactive_routes", "aliases", "precedence",
}
BASELINE_KEYS = {
    "commit", "authority_kind", "authority_ref", "policy_source_type",
    "policy_source_path", "protected_paths_pointer", "policy_sha256",
}
REGISTRY_KEYS = {"path", "sha256", "hash_definition"}
HEALTH_KEYS = {
    "schema_version", "artifact_role", "operating_maturity",
    "product_evidence_maturity", "critical_gates", "integrity_verdict", "evidence",
}
SHA256 = re.compile(r"^[0-9a-f]{64}$")
TRUSTED_BASE = "bfdc9e44d4a6920dc085eaa3f9d19d31b1acd2a1"
PR_BASE = "a45176a3655ae6b36e69f1d58a8556626ca9df86"
DECISION = "DEC-BASE-20260805-001"


def load_json(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8"))


class SwitchyThinAdapterMigrationTests(unittest.TestCase):
    def test_adapter_root_and_nested_contracts_are_strict(self) -> None:
        adapter = load_json(ADAPTER_PATH)
        self.assertEqual(EXPECTED_ROOT_KEYS, set(adapter))
        self.assertEqual(BASE_KEYS, set(adapter["base_release"]))
        self.assertEqual(COMPATIBILITY_KEYS, set(adapter["compatibility"]))
        self.assertEqual(ROUTING_KEYS, set(adapter["routing"]))
        self.assertEqual(BASELINE_KEYS, set(adapter["protected_baseline"]))

    def test_routes_are_typed_and_validators_are_executable_strings(self) -> None:
        adapter = load_json(ADAPTER_PATH)
        for group in ("base_routes", "project_routes"):
            self.assertTrue(adapter["routing"][group])
            for route in adapter["routing"][group]:
                self.assertIsInstance(route, dict)
                self.assertEqual({"route_id", "skill_id", "status"}, set(route))
                self.assertEqual("ACTIVE", route["status"])
        self.assertTrue(all(isinstance(value, str) for value in adapter["validators"]))
        self.assertFalse(any(value.startswith("manual:") for value in adapter["validators"]))

    def test_project_registry_exposes_canonical_skill_ids_without_removing_legacy_ids(self) -> None:
        registry = load_json(REGISTRY_PATH)
        self.assertTrue(registry["skills"])
        for entry in registry["skills"]:
            self.assertIn("id", entry)
            self.assertIn("skill_id", entry)
            self.assertEqual(entry["id"], entry["skill_id"])
        project = next(entry for entry in registry["skills"] if entry["skill_id"] == "switchy-express-design")
        self.assertEqual("project", project["owner"])
        self.assertEqual("skills/switchy-express-design/SKILL.md", project["path"])

    def test_sheet_baseline_and_registries_use_canonical_tokens(self) -> None:
        adapter = load_json(ADAPTER_PATH)
        self.assertEqual("CURRENT", adapter["gdd_sheet"]["sync_status"])
        self.assertEqual("SYNCED", adapter["gdd_sheet"]["declared_sync_status"])
        baseline = adapter["protected_baseline"]
        self.assertEqual(PR_BASE, baseline["commit"])
        self.assertEqual("REMOTE_TRACKING_REF", baseline["authority_kind"])
        self.assertEqual("refs/remotes/origin/main", baseline["authority_ref"])
        self.assertEqual("CANONICAL_ADAPTER_SOURCE", baseline["policy_source_type"])
        self.assertEqual("skills/PROJECT_BASE_ADAPTER.json", baseline["policy_source_path"])
        self.assertRegex(baseline["policy_sha256"], SHA256)
        for registry in adapter["skill_registry"].values():
            self.assertEqual(REGISTRY_KEYS, set(registry))
            self.assertRegex(registry["sha256"], SHA256)
            self.assertEqual("RAW_FILE_BYTES_SHA256", registry["hash_definition"])

    def test_original_adapter_and_registry_evidence_are_preserved_in_project_state(self) -> None:
        state_doc = load_json(STATE_PATH)
        migration = state_doc["adapter_migration"]
        self.assertEqual(DECISION, migration["decision_id"])
        self.assertEqual(PR_BASE, migration["source_main_commit"])
        preserved = migration["preserved_from_adapter"]
        self.assertEqual("SYNCED", preserved["gdd_sheet"]["sync_status"])
        self.assertEqual("GIT_COMMIT", preserved["protected_baseline"]["authority_kind"])
        self.assertEqual("VERIFIED_PROJECT_MAIN", preserved["protected_baseline"]["policy_source_type"])
        self.assertTrue(all(isinstance(value, dict) for value in preserved["validators"]))
        self.assertIn("original_project_skill_registry", migration)
        self.assertIn("original_project_skill_registry_sha256", migration)
        evidence = state_doc["evidence_boundaries"]
        self.assertEqual("NOT_RUN", evidence["physical_device_validation"])
        self.assertEqual("HUMAN_NOT_RUN", evidence["human_validation"])
        self.assertEqual("NOT_READY", evidence["production_adapter_ready"])

    def test_health_uses_unique_verified_evidence_only(self) -> None:
        health = load_json(HEALTH_PATH)
        self.assertEqual(HEALTH_KEYS, set(health))
        self.assertEqual("PROJECT_OPERATING_HEALTH", health["artifact_role"])
        self.assertEqual("OM-L1", health["operating_maturity"])
        self.assertEqual("PE-1", health["product_evidence_maturity"])
        self.assertEqual("PASS_WITH_NOT_RUN_GATES", health["integrity_verdict"])
        self.assertEqual("PASS", health["critical_gates"]["static"])
        self.assertEqual("NOT_RUN", health["critical_gates"]["runtime"])
        self.assertEqual("NOT_RUN", health["critical_gates"]["device"])
        self.assertEqual("NOT_RUN", health["critical_gates"]["human"])
        records = (
            health["evidence"]["operating"]
            + health["evidence"]["product"]
            + health["evidence"]["sheet"]
            + [record for values in health["evidence"]["gates"].values() for record in values]
        )
        self.assertEqual(len(records), len({record["id"] for record in records}))
        self.assertEqual(len(records), len({record["source"] for record in records}))

    def test_migration_map_and_workflow_preserve_project_authority(self) -> None:
        migration = MIGRATION_PATH.read_text(encoding="utf-8")
        workflow = WORKFLOW_PATH.read_text(encoding="utf-8")
        for token in (
            DECISION, "docs/PROJECT_OPERATING_STATE.json", "skills/SKILL_REGISTRY.json",
            "ANDROID_DEVICE_SMOKE_READINESS_CLOSURE.md",
            "SX_AUD_019_ANDROID_APK_PIPELINE_PROBE.md",
            "GODOT_LIVE_EDITOR_ADOPTION.md", "PRODUCT_FILES_UNCHANGED",
            "GOOGLE_SHEETS_UNCHANGED",
        ):
            self.assertIn(token, migration)
        self.assertIn(TRUSTED_BASE, workflow)
        self.assertIn("check_project_operating_contract.py", workflow)
        self.assertIn("test_project_base_adapter_thin_migration", workflow)


if __name__ == "__main__":
    unittest.main()
