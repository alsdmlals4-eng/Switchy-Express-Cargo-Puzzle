"""Exercise the local contract checker with real copied inputs, not prose markers."""
import importlib.util
import json
from pathlib import Path
import shutil
import tempfile
import unittest
from unittest.mock import patch

ROOT = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location("local_contract", ROOT / "tools/validate_project_contract.py")
contract = importlib.util.module_from_spec(spec)
spec.loader.exec_module(contract)


class RoutingIntegrityTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        for relative in set(contract.REQUIRED + [
            "skills/PROJECT_SKILL_SNAPSHOT.json", "skills/switchy-express-design/SKILL.md"
        ]):
            target = self.root / relative
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(ROOT / relative, target)

    def run_check(self):
        with patch.object(contract, "ROOT", self.root):
            return contract.main()

    def test_current_local_contract(self):
        self.assertEqual(self.run_check(), 0)

    def test_missing_selected_project_skill_is_rejected(self):
        (self.root / "skills/switchy-express-design/SKILL.md").unlink()
        with self.assertRaisesRegex(SystemExit, "project skill"):
            self.run_check()

    def test_stale_snapshot_adapter_hash_is_rejected(self):
        path = self.root / "skills/PROJECT_SKILL_SNAPSHOT.json"
        data = json.loads(path.read_text(encoding="utf-8"))
        data["source_registry"]["sha256"] = "0" * 64
        path.write_text(json.dumps(data), encoding="utf-8")
        with self.assertRaisesRegex(SystemExit, "snapshot"):
            self.run_check()

    def test_missing_effective_project_route_is_rejected(self):
        path = self.root / "skills/PROJECT_SKILL_SNAPSHOT.json"
        data = json.loads(path.read_text(encoding="utf-8"))
        del data["effective_routes"]["switchy-express-design"]
        path.write_text(json.dumps(data), encoding="utf-8")
        with self.assertRaisesRegex(SystemExit, "route"):
            self.run_check()


if __name__ == "__main__":
    unittest.main()
