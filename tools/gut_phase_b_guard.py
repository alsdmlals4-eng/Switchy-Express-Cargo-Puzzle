#!/usr/bin/env python3
"""GUT 9.7.1 vendor, JUnit, and protected-tree verification helpers."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import sys
import xml.etree.ElementTree as ET
from pathlib import Path
from typing import Iterable, Mapping, Sequence

DEFAULT_PROTECTED_PATHS: tuple[str, ...] = (
    "project.godot",
    "game",
    "scenes",
    "data",
    "assets",
)
_LOAD_STEPS_PATTERN = re.compile(r"\s+load_steps=\d+")
ALLOWED_LOAD_STEPS_METADATA_PATHS = frozenset(
    {
        "GutScene.tscn",
        "UserFileViewer.tscn",
        "gui/GutControl.tscn",
        "gui/GutLogo.tscn",
        "gui/GutRunner.tscn",
        "gui/GutSceneTheme.tres",
        "gui/MinGui.tscn",
        "gui/NormalGui.tscn",
        "gui/OutputText.tscn",
        "gui/ResizeHandle.tscn",
        "gui/RunAtCursor.tscn",
        "gui/RunExternally.tscn",
        "gui/RunResults.tscn",
        "gui/ShellOutOptions.tscn",
        "gui/ShortcutButton.tscn",
        "gui/run_from_editor.tscn",
        "gut_loader_the_scene.tscn",
    }
)
EXPECTED_BINARY_DIVERGENCES: dict[str, dict[str, object]] = {
    "source_code_pro.fnt": {
        "local_sha256": "e1149f403f4aba18913fb500e4b34aa45f44afe9e36a3e7aed923c11aacf4686",
        "official_sha256": "404094d0aae3de496a64fca1795bed8bd60c2411a3d992551f9e8f00789b71fe",
        "local_size": 42799,
        "official_size": 42799,
    }
}


def _iter_files(root: Path) -> dict[str, Path]:
    if not root.is_dir():
        raise ValueError(f"directory does not exist: {root}")
    return {
        path.relative_to(root).as_posix(): path
        for path in sorted(root.rglob("*"))
        if path.is_file()
    }


def _sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def _normalized_resource_bytes(path: Path) -> bytes:
    raw = path.read_bytes()
    try:
        text = raw.decode("utf-8")
    except UnicodeDecodeError:
        return raw
    lines = text.splitlines(keepends=True)
    if not lines or not lines[0].startswith(("[gd_scene", "[gd_resource")):
        return raw
    lines[0] = _LOAD_STEPS_PATTERN.sub("", lines[0], count=1)
    return "".join(lines).encode("utf-8")


def _evidence(local_bytes: bytes, official_bytes: bytes) -> dict[str, object]:
    return {
        "local_sha256": hashlib.sha256(local_bytes).hexdigest(),
        "official_sha256": hashlib.sha256(official_bytes).hexdigest(),
        "local_size": len(local_bytes),
        "official_size": len(official_bytes),
    }


def _matches_expected_binary_divergence(
    evidence: Mapping[str, object], expected: Mapping[str, object] | None
) -> bool:
    if expected is None:
        return False
    required = ("local_sha256", "official_sha256", "local_size", "official_size")
    return all(evidence.get(key) == expected.get(key) for key in required)


def compare_vendor(
    local_root: Path,
    official_root: Path,
    expected_binary_divergences: Mapping[str, Mapping[str, object]] | None = None,
) -> dict[str, object]:
    """Compare local and official GUT trees with explicit, frozen exceptions."""
    local_files = _iter_files(Path(local_root))
    official_files = _iter_files(Path(official_root))
    local_names = set(local_files)
    official_names = set(official_files)
    expected_binary = (
        EXPECTED_BINARY_DIVERGENCES
        if expected_binary_divergences is None
        else expected_binary_divergences
    )

    missing_local = sorted(official_names - local_names)
    extra_local = sorted(local_names - official_names)
    source_divergence: list[str] = []
    divergence_evidence: dict[str, dict[str, object]] = {}
    normalized_resource_metadata: list[str] = []
    pinned_binary_divergence: list[str] = []
    pinned_binary_evidence: dict[str, dict[str, object]] = {}
    exact_matches = 0

    for relative in sorted(local_names & official_names):
        local_bytes = local_files[relative].read_bytes()
        official_bytes = official_files[relative].read_bytes()
        if local_bytes == official_bytes:
            exact_matches += 1
            continue
        if relative in ALLOWED_LOAD_STEPS_METADATA_PATHS:
            if _normalized_resource_bytes(local_files[relative]) == _normalized_resource_bytes(
                official_files[relative]
            ):
                normalized_resource_metadata.append(relative)
                continue
        evidence = _evidence(local_bytes, official_bytes)
        if _matches_expected_binary_divergence(evidence, expected_binary.get(relative)):
            pinned_binary_divergence.append(relative)
            pinned_binary_evidence[relative] = evidence
            continue
        source_divergence.append(relative)
        divergence_evidence[relative] = evidence

    ok = not (missing_local or extra_local or source_divergence)
    return {
        "ok": ok,
        "local_file_count": len(local_files),
        "official_file_count": len(official_files),
        "exact_match_count": exact_matches,
        "normalized_resource_metadata": normalized_resource_metadata,
        "pinned_binary_divergence": pinned_binary_divergence,
        "pinned_binary_evidence": pinned_binary_evidence,
        "source_divergence": source_divergence,
        "divergence_evidence": divergence_evidence,
        "missing_local": missing_local,
        "extra_local": extra_local,
    }


def _expand_protected_paths(root: Path, protected_paths: Sequence[str]) -> Iterable[Path]:
    for relative in protected_paths:
        target = root / relative
        if not target.exists():
            continue
        if target.is_file():
            yield target
        elif target.is_dir():
            for path in sorted(target.rglob("*")):
                if path.is_file():
                    yield path


def snapshot(
    root: Path,
    protected_paths: Sequence[str] = DEFAULT_PROTECTED_PATHS,
) -> dict[str, str]:
    """Return a deterministic SHA-256 manifest for existing protected paths."""
    root = Path(root).resolve()
    if not root.is_dir():
        raise ValueError(f"project root does not exist: {root}")
    result: dict[str, str] = {}
    for path in _expand_protected_paths(root, protected_paths):
        relative = path.resolve().relative_to(root).as_posix()
        result[relative] = _sha256(path)
    return dict(sorted(result.items()))


def verify_snapshot(
    root: Path,
    before: dict[str, str],
    protected_paths: Sequence[str] = DEFAULT_PROTECTED_PATHS,
) -> dict[str, object]:
    after = snapshot(root, protected_paths)
    before_names = set(before)
    after_names = set(after)
    changed = sorted(
        relative
        for relative in before_names & after_names
        if before[relative] != after[relative]
    )
    added = sorted(after_names - before_names)
    removed = sorted(before_names - after_names)
    return {
        "ok": not (changed or added or removed),
        "changed": changed,
        "added": added,
        "removed": removed,
        "before_count": len(before),
        "after_count": len(after),
    }


def _integer_attribute(element: ET.Element, name: str) -> int:
    value = element.attrib.get(name)
    if value is None or value == "":
        return 0
    try:
        return int(value)
    except ValueError as exc:
        raise ValueError(f"invalid JUnit {name} value: {value!r}") from exc


def validate_junit(junit_path: Path, minimum_tests: int) -> dict[str, object]:
    path = Path(junit_path)
    if not path.is_file():
        raise ValueError(f"JUnit file does not exist: {path}")
    root = ET.parse(path).getroot()
    if root.tag == "testsuite":
        suites = [root]
    elif root.tag == "testsuites":
        direct_tests = root.attrib.get("tests")
        suites = [root] if direct_tests is not None else list(root.findall("testsuite"))
    else:
        raise ValueError(f"unsupported JUnit root element: {root.tag}")

    tests = sum(_integer_attribute(suite, "tests") for suite in suites)
    failures = sum(_integer_attribute(suite, "failures") for suite in suites)
    errors = sum(_integer_attribute(suite, "errors") for suite in suites)
    skipped = sum(_integer_attribute(suite, "skipped") for suite in suites)
    return {
        "ok": tests >= minimum_tests and failures == 0 and errors == 0,
        "minimum_tests": minimum_tests,
        "tests": tests,
        "failures": failures,
        "errors": errors,
        "skipped": skipped,
    }


def _write_json(path: Path, payload: object) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")


def _parse_paths(values: list[str] | None) -> tuple[str, ...]:
    return tuple(values) if values else DEFAULT_PROTECTED_PATHS


def _build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)

    compare = subparsers.add_parser("compare", help="compare local and official GUT trees")
    compare.add_argument("--local", type=Path, required=True)
    compare.add_argument("--official", type=Path, required=True)
    compare.add_argument("--report", type=Path, required=True)

    snapshot_parser = subparsers.add_parser("snapshot", help="write protected-tree hashes")
    snapshot_parser.add_argument("--root", type=Path, required=True)
    snapshot_parser.add_argument("--output", type=Path, required=True)
    snapshot_parser.add_argument("--path", action="append", dest="paths")

    verify = subparsers.add_parser("verify", help="verify protected-tree hashes")
    verify.add_argument("--root", type=Path, required=True)
    verify.add_argument("--before", type=Path, required=True)
    verify.add_argument("--report", type=Path, required=True)
    verify.add_argument("--path", action="append", dest="paths")

    junit = subparsers.add_parser("junit", help="validate a JUnit report")
    junit.add_argument("--file", type=Path, required=True)
    junit.add_argument("--minimum-tests", type=int, required=True)
    junit.add_argument("--report", type=Path, required=True)
    return parser


def main(argv: Sequence[str] | None = None) -> int:
    parser = _build_parser()
    args = parser.parse_args(argv)
    try:
        if args.command == "compare":
            report = compare_vendor(args.local, args.official)
            _write_json(args.report, report)
            return 0 if report["ok"] else 1
        if args.command == "snapshot":
            manifest = snapshot(args.root, _parse_paths(args.paths))
            _write_json(args.output, manifest)
            return 0
        if args.command == "verify":
            before = json.loads(args.before.read_text(encoding="utf-8"))
            if not isinstance(before, dict) or not all(
                isinstance(key, str) and isinstance(value, str)
                for key, value in before.items()
            ):
                raise ValueError("before manifest must be a string-to-string JSON object")
            report = verify_snapshot(args.root, before, _parse_paths(args.paths))
            _write_json(args.report, report)
            return 0 if report["ok"] else 1
        if args.command == "junit":
            if args.minimum_tests < 1:
                raise ValueError("minimum tests must be positive")
            report = validate_junit(args.file, args.minimum_tests)
            _write_json(args.report, report)
            return 0 if report["ok"] else 1
    except (OSError, ValueError, ET.ParseError, json.JSONDecodeError) as exc:
        print(f"gut-phase-b-guard: {exc}", file=sys.stderr)
        return 2
    parser.error(f"unsupported command: {args.command}")
    return 2


if __name__ == "__main__":
    raise SystemExit(main())
