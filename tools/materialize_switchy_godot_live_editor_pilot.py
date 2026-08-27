from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import re
import shutil
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Any, Sequence


PILOT_RELATIVE = Path("tools/godot-live-editor-pilot")
VENDOR_RELATIVE = PILOT_RELATIVE / "vendor/base_live_editor_adapter"
PILOT_PLUGIN_RELATIVE = PILOT_RELATIVE / "pilot_plugin"
SOURCE_MANIFEST_RELATIVE = (
    PILOT_RELATIVE / "GODOT_LIVE_EDITOR_CAPABILITY_MANIFEST.source.json"
)
TARGET_SCENE_RELATIVE = Path("game/finite/presentation/finite_slice_view.tscn")
TARGET_DECLARATION = '[node name="BoardTitle" type="Label" parent="Board"]'
MANIFEST_NAME = "GODOT_LIVE_EDITOR_CAPABILITY_MANIFEST.json"
BASE_COMMIT = "bd72e61722ebb4e29dd66b0885fba9428b1c14fb"
EXCLUDED_NAMES = {".git", ".godot", "__pycache__", ".pytest_cache"}
EXCLUDED_TOP_LEVEL = {"artifacts"}
PILOT_PLUGIN_PATHS = (
    "res://addons/base_live_editor_adapter/plugin.cfg",
    "res://addons/switchy_live_editor_pilot/plugin.cfg",
)


class PilotMaterializationError(ValueError):
    def __init__(self, code: str, detail: str = "") -> None:
        self.code = code
        self.detail = detail
        super().__init__(f"{code}:{detail}" if detail else code)


@dataclass(frozen=True)
class MaterializationReport:
    destination: Path
    source_protected_inventory: dict[str, str]
    copied_protected_inventory: dict[str, str]
    project_godot_sha256: str
    target_scene_sha256: str
    project_fingerprint: str
    base_adapter_commit: str = BASE_COMMIT

    def to_dict(self) -> dict[str, Any]:
        return {
            "status": "PASS",
            "code": "MATERIALIZED",
            "destination": self.destination.as_posix(),
            "base_adapter_commit": self.base_adapter_commit,
            "project_godot_sha256": self.project_godot_sha256,
            "target_scene_sha256": self.target_scene_sha256,
            "project_fingerprint": self.project_fingerprint,
            "source_protected_inventory": self.source_protected_inventory,
            "copied_protected_inventory": self.copied_protected_inventory,
            "production_adapter_ready": False,
        }


def _load_contract(source_root: Path):
    path = source_root / PILOT_RELATIVE / "pilot_contract.py"
    if not path.is_file():
        raise PilotMaterializationError("SOURCE_BASELINE_MISMATCH", "pilot_contract.py missing")
    name = f"switchy_pilot_contract_{hash(path.resolve()) & 0xFFFFFFFF:x}"
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise PilotMaterializationError("SOURCE_BASELINE_MISMATCH", "pilot contract unloadable")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def _canonical_json_sha256(value: Any) -> str:
    encoded = json.dumps(
        value,
        ensure_ascii=False,
        sort_keys=True,
        separators=(",", ":"),
    ).encode("utf-8")
    return hashlib.sha256(encoded).hexdigest()


def _closed_schema(
    properties: dict[str, Any],
    required: list[str],
) -> dict[str, Any]:
    return {
        "type": "object",
        "properties": properties,
        "required": required,
        "additionalProperties": False,
    }


def _capabilities() -> list[dict[str, Any]]:
    inspect_input = _closed_schema({}, [])
    inspect_output = _closed_schema(
        {
            "scene_path": {"type": "string", "pattern": "^res://"},
            "root_name": {"type": "string", "minLength": 1},
            "child_count": {"type": "integer", "minimum": 0},
            "dirty_state": {"enum": ["CLEAN", "DIRTY"]},
            "target_revision": {"type": "string", "minLength": 1},
            "target_content_sha256": {
                "anyOf": [
                    {"type": "string", "pattern": "^[0-9a-f]{64}$"},
                    {"type": "null"},
                ]
            },
        },
        [
            "scene_path",
            "root_name",
            "child_count",
            "dirty_state",
            "target_revision",
            "target_content_sha256",
        ],
    )
    rename_input = _closed_schema(
        {
            "node_path": {"type": "string", "const": "Board/BoardTitle"},
            "new_name": {"type": "string", "minLength": 1, "maxLength": 128},
            "save_mode": {"enum": ["KEEP_DIRTY", "SAVE_CURRENT_SCENE"]},
        },
        ["node_path", "new_name", "save_mode"],
    )
    rename_output = _closed_schema(
        {
            "scene_path": {
                "type": "string",
                "const": "res://game/finite/presentation/finite_slice_view.tscn",
            },
            "node_path": {"type": "string", "const": "Board/BoardTitle"},
            "old_name": {"type": "string", "minLength": 1},
            "new_name": {"type": "string", "minLength": 1},
            "save_mode": {"enum": ["KEEP_DIRTY", "SAVE_CURRENT_SCENE"]},
            "dirty_state": {"enum": ["CLEAN", "DIRTY"]},
            "saved_scene_sha256": {
                "anyOf": [
                    {"type": "string", "pattern": "^[0-9a-f]{64}$"},
                    {"type": "null"},
                ]
            },
        },
        [
            "scene_path",
            "node_path",
            "old_name",
            "new_name",
            "save_mode",
            "dirty_state",
            "saved_scene_sha256",
        ],
    )
    return [
        {
            "capability_id": "scene.inspect",
            "description": "Inspect the active Switchy edited Scene without mutation.",
            "execution_path": "EDITOR_PLUGIN",
            "effect_kind": "READ_ONLY",
            "idempotency": "NOT_APPLICABLE",
            "approval_policy": "NOT_REQUIRED",
            "execution_mode": "SYNCHRONOUS",
            "rollback_policy": "NOT_APPLICABLE",
            "input_schema": inspect_input,
            "output_schema": inspect_output,
            "input_schema_sha256": _canonical_json_sha256(inspect_input),
            "output_schema_sha256": _canonical_json_sha256(inspect_output),
            "path_access": {
                "read_roots": ["res://game/finite/presentation/"],
                "write_roots": [],
                "artifact_root": "artifacts/godot-live-editor/",
            },
            "precondition_policy": "REQUIRED",
            "retry_policy": {
                "automatic": True,
                "maximum_attempts": 2,
                "requires_ledger": False,
            },
            "timeout_policy": {
                "milliseconds": 10000,
                "unknown_outcome": "SAFE_TO_RETRY",
            },
            "evidence_outputs": ["ENGINE_STATE"],
            "unsupported_states": ["IMPORTING", "NO_EDITED_SCENE"],
        },
        {
            "capability_id": "node.rename",
            "description": "Rename only Board/BoardTitle in the isolated Switchy Pilot.",
            "execution_path": "EDITOR_PLUGIN",
            "effect_kind": "MUTATION",
            "idempotency": "IDEMPOTENT",
            "approval_policy": "REQUIRED",
            "execution_mode": "SYNCHRONOUS",
            "rollback_policy": "EDITOR_UNDO_REDO",
            "input_schema": rename_input,
            "output_schema": rename_output,
            "input_schema_sha256": _canonical_json_sha256(rename_input),
            "output_schema_sha256": _canonical_json_sha256(rename_output),
            "path_access": {
                "read_roots": ["res://game/finite/presentation/"],
                "write_roots": ["res://game/finite/presentation/"],
                "artifact_root": "artifacts/godot-live-editor/",
            },
            "precondition_policy": "REQUIRED",
            "retry_policy": {
                "automatic": False,
                "maximum_attempts": 1,
                "requires_ledger": True,
            },
            "timeout_policy": {
                "milliseconds": 10000,
                "unknown_outcome": "RECONCILE_BEFORE_RETRY",
            },
            "evidence_outputs": ["ENGINE_STATE", "LOG"],
            "unsupported_states": ["IMPORTING", "NO_EDITED_SCENE"],
        },
    ]


def _manifest(destination: Path, project_godot_sha256: str) -> dict[str, Any]:
    normalized = destination.resolve().as_posix()
    fingerprint = hashlib.sha256(
        f"{normalized}\n{project_godot_sha256}".encode("utf-8")
    ).hexdigest()
    capabilities = _capabilities()
    return {
        "schema_version": 2,
        "artifact_role": "GODOT_LIVE_EDITOR_CAPABILITY_MANIFEST",
        "configuration_state": "CONFIGURED",
        "contract_version": "2.0.0",
        "adapter_version": "2.0.0",
        "project_identity": {
            "normalized_project_path": normalized,
            "project_godot_sha256": project_godot_sha256,
            "project_fingerprint": fingerprint,
        },
        "engine_compatibility": {
            "detected_version": "4.7.1.stable.official.a13da4feb",
            "minimum_version": "4.7.0",
            "maximum_exclusive_version": "4.8.0",
        },
        "tool_adoption": {
            "source": "base-project-local",
            "exact_version": "2.0.0",
            "telemetry_policy": "DISABLED",
            "external_data_policy": "DENY_BY_DEFAULT",
            "uninstall_procedure": "addons/base_live_editor_adapter/README.md",
            "rollback_reference": "addons/base_live_editor_adapter/README.md",
        },
        "transport": {
            "kind": "PROJECT_DEFINED",
            "enabled": True,
            "bind_host": None,
            "endpoint_identity": "in-process-editor-plugin",
            "protocol_profile": "GENERIC",
            "protocol_version": "in-process-1.0",
            "access_control": {
                "authentication_mode": "NOT_APPLICABLE",
                "origin_policy": "NOT_APPLICABLE",
                "session_binding": "NOT_APPLICABLE",
                "os_access_control": "CURRENT_USER_ONLY",
            },
        },
        "catalog": {
            "generated_at": "2026-08-06T00:00:00Z",
            "sha256": _canonical_json_sha256(capabilities),
            "freshness_state": "FRESH",
        },
        "project_test_framework": {
            "state": "NOT_CONFIGURED",
            "runner_capability_id": None,
        },
        "capabilities": capabilities,
        "validation": {
            "contract_state": "CONTRACT_PASS",
            "execution_state": "NOT_RUN",
            "runtime_state": "NOT_RUN",
            "physical_input_state": "NOT_RUN",
            "human_state": "HUMAN_NOT_RUN",
        },
    }


def _copy_ignore(directory: str, names: Sequence[str]) -> set[str]:
    path = Path(directory)
    ignored = {name for name in names if name in EXCLUDED_NAMES}
    if path.name == "source" or (path / "project.godot").is_file():
        ignored.update(name for name in names if name in EXCLUDED_TOP_LEVEL)
    return ignored


def _copy_repository(source_root: Path, output: Path) -> None:
    shutil.copytree(source_root, output, ignore=_copy_ignore)


def _validate_source(source_root: Path, contract) -> dict[str, str]:
    base_errors = contract.validate_base_snapshot(source_root)
    if base_errors:
        raise PilotMaterializationError("BASE_SNAPSHOT_MISMATCH", "|".join(base_errors))

    baseline_errors = contract.validate_source_baseline(source_root)
    target_errors = [error for error in baseline_errors if error.startswith("TARGET_")]
    if target_errors:
        raise PilotMaterializationError(
            "TARGET_SCENE_CONTRACT_MISMATCH", "|".join(target_errors)
        )
    if baseline_errors:
        raise PilotMaterializationError(
            "SOURCE_BASELINE_MISMATCH", "|".join(baseline_errors)
        )

    source_manifest = contract.load_json(source_root / SOURCE_MANIFEST_RELATIVE)
    transport = source_manifest.get("transport", {})
    if (
        source_manifest.get("configuration_state") != "NOT_CONFIGURED"
        or transport.get("kind") != "DISABLED"
        or transport.get("enabled") is not False
        or source_manifest.get("capabilities") != []
    ):
        raise PilotMaterializationError("SOURCE_MANIFEST_CONFIGURED")

    project_text = (source_root / "project.godot").read_text(encoding="utf-8")
    if any(plugin_path in project_text for plugin_path in PILOT_PLUGIN_PATHS):
        raise PilotMaterializationError("SOURCE_PLUGIN_ALREADY_ENABLED")

    plugin_root = source_root / PILOT_PLUGIN_RELATIVE
    for name in ("plugin.cfg", "plugin.gd"):
        if not (plugin_root / name).is_file():
            raise PilotMaterializationError(
                "TARGET_SCENE_CONTRACT_MISMATCH", f"Pilot plugin missing:{name}"
            )

    scene = source_root / TARGET_SCENE_RELATIVE
    if scene.read_text(encoding="utf-8").count(TARGET_DECLARATION) != 1:
        raise PilotMaterializationError("TARGET_SCENE_CONTRACT_MISMATCH")

    return contract.protected_inventory(source_root)


def _enable_temporary_plugins(project_file: Path) -> None:
    text = project_file.read_text(encoding="utf-8")
    if any(plugin_path in text for plugin_path in PILOT_PLUGIN_PATHS):
        raise PilotMaterializationError("SOURCE_PLUGIN_ALREADY_ENABLED")

    encoded_plugins = ", ".join(json.dumps(path) for path in PILOT_PLUGIN_PATHS)
    if "[editor_plugins]" not in text:
        text = text.rstrip() + (
            "\n\n[editor_plugins]\n\n"
            f"enabled=PackedStringArray({encoded_plugins})\n"
        )
        project_file.write_text(text, encoding="utf-8")
        return

    section_start = text.index("[editor_plugins]")
    section_end = text.find("\n[", section_start + len("[editor_plugins]"))
    if section_end < 0:
        section_end = len(text)
    section = text[section_start:section_end]
    enabled_match = re.search(
        r"(?m)^enabled=PackedStringArray\((.*)\)$",
        section,
    )
    if enabled_match is None:
        insertion = "\n\nenabled=PackedStringArray(%s)" % encoded_plugins
        section = section.rstrip() + insertion + "\n"
    else:
        existing = enabled_match.group(1).strip()
        merged = f"{existing}, {encoded_plugins}" if existing else encoded_plugins
        replacement = f"enabled=PackedStringArray({merged})"
        section = section[: enabled_match.start()] + replacement + section[enabled_match.end() :]
    text = text[:section_start] + section + text[section_end:]
    project_file.write_text(text, encoding="utf-8")


def materialize(source_root: Path, output: Path) -> MaterializationReport:
    source_root = source_root.resolve()
    output = output.resolve()
    if output == source_root or source_root in output.parents:
        raise PilotMaterializationError("OUTPUT_INSIDE_REPOSITORY")
    if output.exists():
        raise PilotMaterializationError("OUTPUT_ALREADY_EXISTS")

    contract = _load_contract(source_root)
    source_before = _validate_source(source_root, contract)
    created = False
    try:
        output.parent.mkdir(parents=True, exist_ok=True)
        _copy_repository(source_root, output)
        created = True

        copied_before = contract.protected_inventory(output)
        if copied_before != source_before:
            raise PilotMaterializationError("COPY_INTEGRITY_MISMATCH")

        addons = output / "addons"
        addons.mkdir(exist_ok=True)
        shutil.copytree(
            source_root / VENDOR_RELATIVE,
            addons / "base_live_editor_adapter",
        )
        shutil.copytree(
            source_root / PILOT_PLUGIN_RELATIVE,
            addons / "switchy_live_editor_pilot",
        )

        project_file = output / "project.godot"
        _enable_temporary_plugins(project_file)
        project_hash = contract.sha256_file(project_file)
        manifest = _manifest(output, project_hash)
        manifest_path = output / MANIFEST_NAME
        manifest_path.write_text(
            json.dumps(manifest, ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
        )

        target_hash = contract.canonical_text_sha256_file(output / TARGET_SCENE_RELATIVE)
        baseline = contract.load_json(source_root / PILOT_RELATIVE / "SOURCE_BASELINE.json")
        if target_hash != baseline["target_scene"]["raw_sha256"]:
            raise PilotMaterializationError("COPY_INTEGRITY_MISMATCH")

        source_after = contract.protected_inventory(source_root)
        if source_after != source_before:
            raise PilotMaterializationError("SOURCE_INTEGRITY_FAILURE")

        report = MaterializationReport(
            destination=output,
            source_protected_inventory=source_before,
            copied_protected_inventory=copied_before,
            project_godot_sha256=project_hash,
            target_scene_sha256=target_hash,
            project_fingerprint=manifest["project_identity"]["project_fingerprint"],
        )
        report_path = output / "artifacts/godot-live-editor/materialization_report.json"
        report_path.parent.mkdir(parents=True, exist_ok=True)
        report_path.write_text(
            json.dumps(report.to_dict(), ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
        )
        return report
    except Exception:
        if created and output.exists():
            shutil.rmtree(output)
        raise


def _parse_args(argv: Sequence[str] | None = None) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Materialize the isolated Switchy Godot live-editor Pilot."
    )
    parser.add_argument(
        "--source",
        type=Path,
        default=Path(__file__).resolve().parents[1],
    )
    parser.add_argument("--output", required=True, type=Path)
    return parser.parse_args(argv)


def main(argv: Sequence[str] | None = None) -> int:
    args = _parse_args(argv)
    try:
        report = materialize(args.source, args.output)
    except PilotMaterializationError as error:
        print(json.dumps({"status": "FAIL", "code": error.code, "detail": error.detail}))
        return 1
    print(json.dumps(report.to_dict(), ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())


__all__ = [
    "MaterializationReport",
    "PilotMaterializationError",
    "_copy_repository",
    "materialize",
]
