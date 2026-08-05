from __future__ import annotations

import importlib.util
import json
import sys
import tempfile
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
PILOT_ROOT = ROOT / "tools/godot-live-editor-pilot"
TARGET_SCENE = ROOT / "game/finite/presentation/finite_slice_view.tscn"
TARGET_NODE = "Board/BoardTitle"
PROTECTED_ROOTS = (
    ROOT / "project.godot",
    ROOT / "game",
    ROOT / "assets",
    ROOT / "기획서",
)

REQUIRED_FILES = (
    PILOT_ROOT / "pilot_contract.py",
    PILOT_ROOT / "BASE_SOURCE.json",
    PILOT_ROOT / "SOURCE_BASELINE.json",
    PILOT_ROOT / "GODOT_LIVE_EDITOR_CAPABILITY_MANIFEST.source.json",
    PILOT_ROOT / "pilot_plugin/plugin.cfg",
    PILOT_ROOT / "pilot_plugin/plugin.gd",
    PILOT_ROOT / "README.md",
    ROOT / "tools/materialize_switchy_godot_live_editor_pilot.py",
    ROOT / "tools/run_switchy_godot_live_editor_pilot.py",
    ROOT / "docs/evidence/godot-live-editor/2026-08-06-switchy-real-project-pilot.md",
)

VENDORED_FILES = {
    "README.md",
    "capability_registry.gd",
    "editor_state_probe.gd",
    "editor_transaction_executor.gd",
    "evidence_writer.gd",
    "operation_ledger.gd",
    "plugin.cfg",
    "plugin.gd",
    "request_queue.gd",
    "runtime_contract_guard.gd",
}

FORBIDDEN = (
    "TCPServer",
    "WebSocketPeer",
    "HTTPServer",
    "PacketPeerUDP",
    "Thread.new",
    "OS.execute",
    "subprocess.Popen(shell=True",
    "eval(",
    "exec(",
)


def _load_module(path: Path, name: str):
    if not path.is_file():
        return None
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        return None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


class SwitchyGodotLiveEditorPilotContractTests(unittest.TestCase):
    maxDiff = None

    def test_required_pilot_files_exist(self) -> None:
        missing = [str(path.relative_to(ROOT)) for path in REQUIRED_FILES if not path.is_file()]
        self.assertEqual([], missing, f"missing Pilot files: {missing}")

    def test_source_manifest_is_not_configured_and_disabled(self) -> None:
        path = PILOT_ROOT / "GODOT_LIVE_EDITOR_CAPABILITY_MANIFEST.source.json"
        self.assertTrue(path.is_file(), f"missing {path.relative_to(ROOT)}")
        manifest = json.loads(path.read_text(encoding="utf-8"))
        self.assertEqual("NOT_CONFIGURED", manifest.get("configuration_state"))
        transport = manifest.get("transport", {})
        self.assertEqual("DISABLED", transport.get("kind"))
        self.assertFalse(transport.get("enabled"))
        self.assertIsNone(transport.get("bind_host"))
        self.assertIsNone(transport.get("endpoint_identity"))
        self.assertEqual([], manifest.get("capabilities"))

    def test_source_project_does_not_enable_pilot_plugins(self) -> None:
        source = (ROOT / "project.godot").read_text(encoding="utf-8")
        self.assertNotIn("base_live_editor_adapter", source)
        self.assertNotIn("switchy_live_editor_pilot", source)

    def test_base_source_inventory_matches_vendored_bytes(self) -> None:
        inventory_path = PILOT_ROOT / "BASE_SOURCE.json"
        vendor_root = PILOT_ROOT / "vendor/base_live_editor_adapter"
        self.assertTrue(inventory_path.is_file(), f"missing {inventory_path.relative_to(ROOT)}")
        self.assertTrue(vendor_root.is_dir(), f"missing {vendor_root.relative_to(ROOT)}")
        inventory = json.loads(inventory_path.read_text(encoding="utf-8"))
        self.assertEqual(
            "bd72e61722ebb4e29dd66b0885fba9428b1c14fb",
            inventory.get("commit"),
        )
        self.assertEqual(VENDORED_FILES, set(inventory.get("files", {})))
        contract = _load_module(PILOT_ROOT / "pilot_contract.py", "switchy_pilot_contract")
        self.assertIsNotNone(contract, "missing or unloadable pilot_contract.py")
        self.assertEqual([], contract.validate_base_snapshot(ROOT))

    def test_source_baseline_pins_git_blob_and_raw_sha256(self) -> None:
        path = PILOT_ROOT / "SOURCE_BASELINE.json"
        self.assertTrue(path.is_file(), f"missing {path.relative_to(ROOT)}")
        baseline = json.loads(path.read_text(encoding="utf-8"))
        self.assertEqual(
            "game/finite/presentation/finite_slice_view.tscn",
            baseline.get("target_scene", {}).get("path"),
        )
        self.assertEqual(TARGET_NODE, baseline.get("target_scene", {}).get("target_node"))
        self.assertRegex(baseline.get("target_scene", {}).get("git_blob_sha", ""), r"^[0-9a-f]{40}$")
        self.assertRegex(baseline.get("target_scene", {}).get("raw_sha256", ""), r"^[0-9a-f]{64}$")
        self.assertRegex(baseline.get("project_godot", {}).get("raw_sha256", ""), r"^[0-9a-f]{64}$")
        contract = _load_module(PILOT_ROOT / "pilot_contract.py", "switchy_pilot_contract_baseline")
        self.assertIsNotNone(contract, "missing or unloadable pilot_contract.py")
        self.assertEqual([], contract.validate_source_baseline(ROOT))

    def test_materializer_rejects_output_inside_repository(self) -> None:
        path = ROOT / "tools/materialize_switchy_godot_live_editor_pilot.py"
        module = _load_module(path, "switchy_pilot_materializer")
        self.assertIsNotNone(module, f"missing or unloadable {path.relative_to(ROOT)}")
        with tempfile.TemporaryDirectory(dir=ROOT) as temporary:
            output = Path(temporary) / "pilot"
            with self.assertRaisesRegex(ValueError, "OUTPUT_INSIDE_REPOSITORY"):
                module.materialize(ROOT, output)

    def test_target_scene_and_node_contract_is_exact(self) -> None:
        self.assertTrue(TARGET_SCENE.is_file(), f"missing {TARGET_SCENE.relative_to(ROOT)}")
        source = TARGET_SCENE.read_text(encoding="utf-8")
        declaration = '[node name="BoardTitle" type="Label" parent="Board"]'
        self.assertEqual(1, source.count(declaration))
        self.assertNotIn('NodePath("Board/BoardTitle")', source)

    def test_protected_source_inventory_is_stable_after_materialization(self) -> None:
        materializer = _load_module(
            ROOT / "tools/materialize_switchy_godot_live_editor_pilot.py",
            "switchy_pilot_materializer_integrity",
        )
        contract = _load_module(PILOT_ROOT / "pilot_contract.py", "switchy_pilot_contract_integrity")
        self.assertIsNotNone(materializer, "missing or unloadable materializer")
        self.assertIsNotNone(contract, "missing or unloadable pilot_contract.py")
        before = contract.protected_inventory(ROOT)
        with tempfile.TemporaryDirectory() as temporary:
            materializer.materialize(ROOT, Path(temporary) / "pilot")
        after = contract.protected_inventory(ROOT)
        self.assertEqual(before, after)
        for protected in PROTECTED_ROOTS:
            self.assertTrue(protected.exists(), f"missing protected source path: {protected}")

    def test_pilot_sources_contain_no_network_or_shell_primitive(self) -> None:
        self.assertTrue(PILOT_ROOT.is_dir(), f"missing {PILOT_ROOT.relative_to(ROOT)}")
        sources = [
            path
            for path in PILOT_ROOT.rglob("*")
            if path.is_file() and path.suffix in {".py", ".gd"}
        ]
        self.assertTrue(sources, "no Pilot source files found")
        for path in sources:
            text = path.read_text(encoding="utf-8")
            for token in FORBIDDEN:
                with self.subTest(path=path.relative_to(ROOT), token=token):
                    self.assertNotIn(token, text)


if __name__ == "__main__":
    unittest.main()
