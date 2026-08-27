from __future__ import annotations

import hashlib
import json
from pathlib import Path
from typing import Any, Iterable


PILOT_RELATIVE = Path("tools/godot-live-editor-pilot")
VENDOR_RELATIVE = PILOT_RELATIVE / "vendor/base_live_editor_adapter"
BASE_SOURCE_RELATIVE = PILOT_RELATIVE / "BASE_SOURCE.json"
SOURCE_BASELINE_RELATIVE = PILOT_RELATIVE / "SOURCE_BASELINE.json"
TARGET_SCENE_RELATIVE = Path("game/finite/presentation/finite_slice_view.tscn")
TARGET_DECLARATION = '[node name="BoardTitle" type="Label" parent="Board"]'
EXCLUDED_PARTS = {".git", ".godot", "__pycache__", ".pytest_cache"}
GODOT_GENERATED_SUFFIXES = {".uid"}


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(65536), b""):
            digest.update(block)
    return digest.hexdigest()


def canonical_text_sha256_file(path: Path) -> str:
    """Hash tracked text after normalizing checkout CRLF to repository LF."""
    payload = path.read_bytes().replace(b"\r\n", b"\n")
    return hashlib.sha256(payload).hexdigest()


def load_json(path: Path) -> dict[str, Any]:
    value = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(value, dict):
        raise ValueError(f"JSON_OBJECT_REQUIRED:{path}")
    return value


def inventory(root: Path, targets: Iterable[Path]) -> dict[str, str]:
    resolved_root = root.resolve()
    result: dict[str, str] = {}
    for target in targets:
        resolved = target.resolve()
        relative = resolved.relative_to(resolved_root).as_posix()
        result[relative] = sha256_file(resolved)
    return dict(sorted(result.items()))


def protected_inventory(root: Path) -> dict[str, str]:
    root = root.resolve()
    targets: list[Path] = []
    project = root / "project.godot"
    if project.is_file():
        targets.append(project)
    for relative in ("game", "assets", "기획서"):
        directory = root / relative
        if not directory.is_dir():
            continue
        for path in directory.rglob("*"):
            if not path.is_file() or any(part in EXCLUDED_PARTS for part in path.parts):
                continue
            targets.append(path)
    return inventory(root, sorted(targets))


def validate_base_snapshot(root: Path) -> list[str]:
    root = root.resolve()
    errors: list[str] = []
    source_path = root / BASE_SOURCE_RELATIVE
    vendor_root = root / VENDOR_RELATIVE
    if not source_path.is_file():
        return ["BASE_SOURCE_MISSING"]
    source = load_json(source_path)
    expected_files = source.get("files", {})
    if not isinstance(expected_files, dict):
        return ["BASE_SOURCE_FILES_INVALID"]
    for name, expected in sorted(expected_files.items()):
        path = vendor_root / name
        if not path.is_file():
            errors.append(f"BASE_SNAPSHOT_FILE_MISSING:{name}")
            continue
        actual = canonical_text_sha256_file(path)
        if actual != expected:
            errors.append(
                f"BASE_SNAPSHOT_MISMATCH:{name}:expected={expected}:actual={actual}"
            )
    actual_names = (
        {
            path.name
            for path in vendor_root.iterdir()
            if path.is_file() and path.suffix not in GODOT_GENERATED_SUFFIXES
        }
        if vendor_root.is_dir()
        else set()
    )
    if actual_names != set(expected_files):
        errors.append(
            "BASE_SNAPSHOT_INVENTORY_MISMATCH:"
            f"expected={sorted(expected_files)}:actual={sorted(actual_names)}"
        )
    return errors


def validate_source_baseline(root: Path) -> list[str]:
    root = root.resolve()
    errors: list[str] = []
    baseline_path = root / SOURCE_BASELINE_RELATIVE
    if not baseline_path.is_file():
        return ["SOURCE_BASELINE_MISSING"]
    baseline = load_json(baseline_path)
    checks = (
        ("project_godot", root / "project.godot"),
        ("target_scene", root / TARGET_SCENE_RELATIVE),
    )
    for key, path in checks:
        expected = str(baseline.get(key, {}).get("raw_sha256", ""))
        if not path.is_file():
            errors.append(f"SOURCE_BASELINE_FILE_MISSING:{key}:{path}")
            continue
        actual = canonical_text_sha256_file(path)
        if actual != expected:
            errors.append(
                f"SOURCE_BASELINE_MISMATCH:{key}:expected={expected}:actual={actual}"
            )
    scene_path = root / TARGET_SCENE_RELATIVE
    if scene_path.is_file():
        source = scene_path.read_text(encoding="utf-8")
        if source.count(TARGET_DECLARATION) != 1:
            errors.append(
                "TARGET_SCENE_CONTRACT_MISMATCH:"
                f"declaration_count={source.count(TARGET_DECLARATION)}"
            )
    target = baseline.get("target_scene", {})
    if target.get("target_node") != "Board/BoardTitle":
        errors.append("TARGET_NODE_CONTRACT_MISMATCH")
    if target.get("original_name") != "BoardTitle":
        errors.append("TARGET_NAME_CONTRACT_MISMATCH")
    return errors


__all__ = [
    "inventory",
    "load_json",
    "protected_inventory",
    "canonical_text_sha256_file",
    "sha256_file",
    "validate_base_snapshot",
    "validate_source_baseline",
]
