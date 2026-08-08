from __future__ import annotations

import importlib.util
import json
import sys
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
IGNORE_FILE = ROOT / ".gitignore"
ALLOWLIST_FILE = ROOT / "docs/tooling/asset_vault_legacy_tracked_allowlist.txt"
STATE_FILE = ROOT / "docs/tooling/local_godot_tooling_state.json"
VALIDATOR_FILE = ROOT / "tools/validate_local_tooling_reconciliation.py"
PREFLIGHT_FILE = ROOT / "tools/asset_vault_preservation_preflight.py"


def load_module(path: Path, name: str):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise AssertionError(f"cannot load module: {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def read_allowlist() -> set[str]:
    return {
        line.strip()
        for line in ALLOWLIST_FILE.read_text(encoding="utf-8").splitlines()
        if line.strip() and not line.startswith("#")
    }


class LocalToolingReconciliationContractTests(unittest.TestCase):
    def test_local_only_roots_are_ignored(self) -> None:
        lines = {
            line.strip()
            for line in IGNORE_FILE.read_text(encoding="utf-8").splitlines()
            if line.strip() and not line.lstrip().startswith("#")
        }
        self.assertIn(".asset-vault/", lines)
        self.assertIn("assets/_vault_local/", lines)

    def test_godot_ai_repo_manifest_is_3_1_3(self) -> None:
        plugin = (ROOT / "addons/godot_ai/plugin.cfg").read_text(encoding="utf-8")
        self.assertIn('version="3.1.3"', plugin)
        self.assertNotIn('version="3.1.2"', plugin)

    def test_gut_remains_9_7_1_and_repo_plugins_remain_enabled(self) -> None:
        gut = (ROOT / "addons/gut/plugin.cfg").read_text(encoding="utf-8")
        project = (ROOT / "project.godot").read_text(encoding="utf-8")
        self.assertIn('version="9.7.1"', gut)
        self.assertIn('res://addons/godot_ai/plugin.cfg', project)
        self.assertIn('res://addons/gut/plugin.cfg', project)

    def test_authority_files_record_bounded_state(self) -> None:
        self.assertTrue(ALLOWLIST_FILE.is_file(), "legacy allowlist must exist")
        self.assertTrue(STATE_FILE.is_file(), "tooling state manifest must exist")
        allowed = read_allowlist()
        self.assertEqual(14, len(allowed))
        self.assertTrue(all(path.startswith(".asset-vault/") for path in allowed))

        state = json.loads(STATE_FILE.read_text(encoding="utf-8"))
        self.assertEqual("SX-DEC-052", state["decision_id"])
        self.assertEqual("3.1.3", state["godot_ai"]["user_local_version"])
        self.assertEqual("3.1.3", state["godot_ai"]["repo_version"])
        self.assertEqual("v3.1.3", state["godot_ai"]["upstream_tag"])
        self.assertEqual(
            "22678e5f9b038d7203d6b43b0aae20a5417c500e",
            state["godot_ai"]["upstream_commit"],
        )
        self.assertTrue(state["godot_ai"]["user_enabled_approved"])
        self.assertEqual("9.7.1", state["gut"]["repo_version"])
        self.assertTrue(state["gut"]["repo_enabled"])
        self.assertTrue(state["gut"]["user_enabled_approved"])
        self.assertEqual("NotNull92/hera-agent-godot", state["hera"]["identity"])
        self.assertEqual("1.0.0", state["hera"]["stable_upstream_version"])
        self.assertTrue(state["hera"]["user_enabled_approved"])
        self.assertIsNone(state["hera"]["local_version"])
        self.assertFalse(state["hera"]["repo_tracked"])
        self.assertEqual("LOCAL_VERSION_UNVERIFIED", state["hera"]["status"])

    def test_validator_rejects_local_only_expansion(self) -> None:
        self.assertTrue(VALIDATOR_FILE.is_file(), "validator must exist")
        validator = load_module(VALIDATOR_FILE, "local_tooling_validator_test")
        allowed = {".asset-vault/library/existing.png"}
        clean = validator.validate_tracked_paths(sorted(allowed), allowed)
        self.assertEqual([], clean)
        violations = validator.validate_tracked_paths(
            [
                ".asset-vault/library/existing.png",
                ".asset-vault/library/new.png",
                "assets/_vault_local/private.png",
            ],
            allowed,
        )
        self.assertTrue(any("new.png" in item for item in violations))
        self.assertTrue(any("_vault_local" in item for item in violations))

    def test_validator_reads_the_current_head_legacy_paths(self) -> None:
        self.assertTrue(VALIDATOR_FILE.is_file(), "validator must exist")
        validator = load_module(VALIDATOR_FILE, "local_tooling_validator_head_test")
        self.assertEqual(read_allowlist(), set(validator.tracked_local_only_paths(ROOT)))

    def test_preservation_preflight_is_inventory_only_and_output_safe(self) -> None:
        self.assertTrue(PREFLIGHT_FILE.is_file(), "preservation preflight must exist")
        preflight = load_module(PREFLIGHT_FILE, "asset_vault_preflight_test")
        payload = preflight.build_inventory(ROOT / "path-that-does-not-exist", ROOT)
        self.assertEqual("SX-DEC-052", payload["decision_id"])
        self.assertEqual("inventory_only", payload["preservation_status"])
        self.assertFalse(payload["vault_present"])
        self.assertEqual([], payload["entries"])
        with self.assertRaises(ValueError):
            preflight.validate_output_path(ROOT / ".asset-vault/report.json", ROOT)
        with self.assertRaises(ValueError):
            preflight.validate_output_path(ROOT / "assets/_vault_local/report.json", ROOT)
        safe = preflight.validate_output_path(ROOT / "test-results/vault-report.json", ROOT)
        self.assertEqual((ROOT / "test-results/vault-report.json").resolve(), safe)


if __name__ == "__main__":
    unittest.main()
