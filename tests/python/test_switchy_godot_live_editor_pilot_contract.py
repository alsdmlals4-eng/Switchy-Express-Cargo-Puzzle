from __future__ import annotations

import importlib.util
import json
import shutil
import sys
import tempfile
import unittest
from pathlib import Path
from unittest import mock


ROOT = Path(__file__).resolve().parents[2]
PILOT_ROOT = ROOT / "tools/godot-live-editor-pilot"
MATERIALIZER = ROOT / "tools/materialize_switchy_godot_live_editor_pilot.py"
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
    MATERIALIZER,
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
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def _copy_minimal_source(destination: Path) -> Path:
    source = destination / "source"
    source.mkdir(parents=True)
    shutil.copy2(ROOT / "project.godot", source / "project.godot")
    target = source / "game/finite/presentation/finite_slice_view.tscn"
    target.parent.mkdir(parents=True)
    shutil.copy2(TARGET_SCENE, target)
    (source / "assets").mkdir()
    (source / "기획서").mkdir()
    pilot = source / "tools/godot-live-editor-pilot"
    shutil.copytree(PILOT_ROOT, pilot)
    plugin = pilot / "pilot_plugin"
    plugin.mkdir(parents=True, exist_ok=True)
    (plugin / "plugin.cfg").write_text(
        '[plugin]\nname="Fixture Pilot"\nscript="plugin.gd"\n',
        encoding="utf-8",
    )
    (plugin / "plugin.gd").write_text(
        "@tool\nextends EditorPlugin\n",
        encoding="utf-8",
    )
    return source


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

    def test_canonical_source_hash_ignores_checkout_line_endings_but_raw_hash_does_not(self) -> None:
        contract = _load_module(PILOT_ROOT / "pilot_contract.py", "switchy_pilot_contract_line_endings")
        self.assertIsNotNone(contract, "missing or unloadable pilot_contract.py")
        with tempfile.TemporaryDirectory() as temporary:
            lf = Path(temporary) / "lf.txt"
            crlf = Path(temporary) / "crlf.txt"
            lf.write_bytes(b"first\nsecond\n")
            crlf.write_bytes(b"first\r\nsecond\r\n")
            self.assertNotEqual(contract.sha256_file(lf), contract.sha256_file(crlf))
            self.assertEqual(
                contract.canonical_text_sha256_file(lf),
                contract.canonical_text_sha256_file(crlf),
            )

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
        module = _load_module(MATERIALIZER, "switchy_pilot_materializer_inside")
        self.assertIsNotNone(module, f"missing or unloadable {MATERIALIZER.relative_to(ROOT)}")
        with tempfile.TemporaryDirectory(dir=ROOT) as temporary:
            with self.assertRaisesRegex(ValueError, "OUTPUT_INSIDE_REPOSITORY"):
                module.materialize(ROOT, Path(temporary) / "pilot")

    def test_materializer_rejects_existing_output(self) -> None:
        module = _load_module(MATERIALIZER, "switchy_pilot_materializer_existing")
        self.assertIsNotNone(module, "missing or unloadable materializer")
        with tempfile.TemporaryDirectory() as temporary:
            source = _copy_minimal_source(Path(temporary))
            output = Path(temporary) / "existing"
            output.mkdir()
            with self.assertRaisesRegex(ValueError, "OUTPUT_ALREADY_EXISTS"):
                module.materialize(source, output)

    def test_materializer_rejects_source_baseline_mismatch(self) -> None:
        module = _load_module(MATERIALIZER, "switchy_pilot_materializer_baseline")
        self.assertIsNotNone(module, "missing or unloadable materializer")
        with tempfile.TemporaryDirectory() as temporary:
            source = _copy_minimal_source(Path(temporary))
            (source / "project.godot").write_text("changed\n", encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "SOURCE_BASELINE_MISMATCH"):
                module.materialize(source, Path(temporary) / "output")

    def test_materializer_rejects_base_snapshot_mismatch(self) -> None:
        module = _load_module(MATERIALIZER, "switchy_pilot_materializer_base")
        self.assertIsNotNone(module, "missing or unloadable materializer")
        with tempfile.TemporaryDirectory() as temporary:
            source = _copy_minimal_source(Path(temporary))
            vendor = source / "tools/godot-live-editor-pilot/vendor/base_live_editor_adapter/plugin.cfg"
            vendor.write_text(vendor.read_text(encoding="utf-8") + "# changed\n", encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "BASE_SNAPSHOT_MISMATCH"):
                module.materialize(source, Path(temporary) / "output")

    def test_materializer_rejects_configured_source_manifest(self) -> None:
        module = _load_module(MATERIALIZER, "switchy_pilot_materializer_manifest")
        self.assertIsNotNone(module, "missing or unloadable materializer")
        with tempfile.TemporaryDirectory() as temporary:
            source = _copy_minimal_source(Path(temporary))
            path = source / "tools/godot-live-editor-pilot/GODOT_LIVE_EDITOR_CAPABILITY_MANIFEST.source.json"
            manifest = json.loads(path.read_text(encoding="utf-8"))
            manifest["configuration_state"] = "CONFIGURED"
            path.write_text(json.dumps(manifest), encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "SOURCE_MANIFEST_CONFIGURED"):
                module.materialize(source, Path(temporary) / "output")

    def test_materializer_rejects_source_plugin_activation(self) -> None:
        module = _load_module(MATERIALIZER, "switchy_pilot_materializer_plugins")
        self.assertIsNotNone(module, "missing or unloadable materializer")
        with tempfile.TemporaryDirectory() as temporary:
            source = _copy_minimal_source(Path(temporary))
            project = source / "project.godot"
            project.write_text(
                project.read_text(encoding="utf-8")
                + '\n[editor_plugins]\nenabled=PackedStringArray("res://addons/base_live_editor_adapter/plugin.cfg")\n',
                encoding="utf-8",
            )
            baseline = source / "tools/godot-live-editor-pilot/SOURCE_BASELINE.json"
            value = json.loads(baseline.read_text(encoding="utf-8"))
            contract = _load_module(source / "tools/godot-live-editor-pilot/pilot_contract.py", "fixture_contract_plugins")
            value["project_godot"]["raw_sha256"] = contract.canonical_text_sha256_file(project)
            baseline.write_text(json.dumps(value), encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "SOURCE_PLUGIN_ALREADY_ENABLED"):
                module.materialize(source, Path(temporary) / "output")

    def test_materializer_rejects_target_scene_contract_mismatch(self) -> None:
        module = _load_module(MATERIALIZER, "switchy_pilot_materializer_target")
        self.assertIsNotNone(module, "missing or unloadable materializer")
        with tempfile.TemporaryDirectory() as temporary:
            source = _copy_minimal_source(Path(temporary))
            scene = source / "game/finite/presentation/finite_slice_view.tscn"
            scene.write_text(scene.read_text(encoding="utf-8").replace("BoardTitle", "WrongTitle"), encoding="utf-8")
            baseline = source / "tools/godot-live-editor-pilot/SOURCE_BASELINE.json"
            value = json.loads(baseline.read_text(encoding="utf-8"))
            contract = _load_module(source / "tools/godot-live-editor-pilot/pilot_contract.py", "fixture_contract_target")
            value["target_scene"]["raw_sha256"] = contract.canonical_text_sha256_file(scene)
            baseline.write_text(json.dumps(value), encoding="utf-8")
            with self.assertRaisesRegex(ValueError, "TARGET_SCENE_CONTRACT_MISMATCH"):
                module.materialize(source, Path(temporary) / "output")

    def test_materializer_detects_copy_integrity_mismatch(self) -> None:
        module = _load_module(MATERIALIZER, "switchy_pilot_materializer_copy")
        self.assertIsNotNone(module, "missing or unloadable materializer")
        with tempfile.TemporaryDirectory() as temporary:
            source = _copy_minimal_source(Path(temporary))
            original = module._copy_repository

            def corrupt_copy(source_root: Path, output: Path) -> None:
                original(source_root, output)
                scene = output / "game/finite/presentation/finite_slice_view.tscn"
                scene.write_text(scene.read_text(encoding="utf-8") + "# corrupt\n", encoding="utf-8")

            with mock.patch.object(module, "_copy_repository", side_effect=corrupt_copy):
                with self.assertRaisesRegex(ValueError, "COPY_INTEGRITY_MISMATCH"):
                    module.materialize(source, Path(temporary) / "output")

    def test_materializer_detects_source_integrity_failure(self) -> None:
        module = _load_module(MATERIALIZER, "switchy_pilot_materializer_source")
        self.assertIsNotNone(module, "missing or unloadable materializer")
        with tempfile.TemporaryDirectory() as temporary:
            source = _copy_minimal_source(Path(temporary))
            original = module._copy_repository

            def mutate_source(source_root: Path, output: Path) -> None:
                original(source_root, output)
                project = source_root / "project.godot"
                project.write_text(project.read_text(encoding="utf-8") + "# changed\n", encoding="utf-8")

            with mock.patch.object(module, "_copy_repository", side_effect=mutate_source):
                with self.assertRaisesRegex(ValueError, "SOURCE_INTEGRITY_FAILURE"):
                    module.materialize(source, Path(temporary) / "output")

    def test_target_scene_and_node_contract_is_exact(self) -> None:
        self.assertTrue(TARGET_SCENE.is_file(), f"missing {TARGET_SCENE.relative_to(ROOT)}")
        source = TARGET_SCENE.read_text(encoding="utf-8")
        declaration = '[node name="BoardTitle" type="Label" parent="Board"]'
        self.assertEqual(1, source.count(declaration))
        self.assertNotIn('NodePath("Board/BoardTitle")', source)

    def test_protected_source_inventory_is_stable_after_materialization(self) -> None:
        materializer = _load_module(MATERIALIZER, "switchy_pilot_materializer_integrity")
        contract = _load_module(PILOT_ROOT / "pilot_contract.py", "switchy_pilot_contract_integrity")
        self.assertIsNotNone(materializer, "missing or unloadable materializer")
        self.assertIsNotNone(contract, "missing or unloadable pilot_contract.py")
        with tempfile.TemporaryDirectory() as temporary:
            source = _copy_minimal_source(Path(temporary))
            before = contract.protected_inventory(source)
            report = materializer.materialize(source, Path(temporary) / "pilot")
            after = contract.protected_inventory(source)
            self.assertEqual(before, after)
            self.assertEqual(before, report.source_protected_inventory)

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
