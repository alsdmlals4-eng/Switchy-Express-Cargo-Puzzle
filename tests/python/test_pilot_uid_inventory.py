from __future__ import annotations

import importlib.util
import json
import sys
import tempfile
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
CONTRACT_PATH = ROOT / "tools/godot-live-editor-pilot/pilot_contract.py"


def _load_contract():
    spec = importlib.util.spec_from_file_location("pilot_uid_contract", CONTRACT_PATH)
    if spec is None or spec.loader is None:
        return None
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


class PilotUidInventoryTests(unittest.TestCase):
    def test_uid_companions_are_ignored_but_other_files_remain_forbidden(self) -> None:
        contract = _load_contract()
        self.assertIsNotNone(contract)
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            pilot = root / "tools/godot-live-editor-pilot"
            vendor = pilot / "vendor/base_live_editor_adapter"
            vendor.mkdir(parents=True)
            source = vendor / "plugin.gd"
            source.write_text("@tool\nextends EditorPlugin\n", encoding="utf-8")
            (vendor / "plugin.gd.uid").write_text("uid://generated\n", encoding="utf-8")
            (pilot / "BASE_SOURCE.json").write_text(
                json.dumps({"files": {"plugin.gd": contract.canonical_text_sha256_file(source)}}),
                encoding="utf-8",
            )
            self.assertEqual([], contract.validate_base_snapshot(root))

            (vendor / "unexpected.txt").write_text("unexpected\n", encoding="utf-8")
            errors = contract.validate_base_snapshot(root)
            self.assertTrue(
                any(error.startswith("BASE_SNAPSHOT_INVENTORY_MISMATCH") for error in errors)
            )


if __name__ == "__main__":
    unittest.main()
