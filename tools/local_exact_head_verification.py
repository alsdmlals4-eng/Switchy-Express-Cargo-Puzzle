#!/usr/bin/env python3
"""Run fail-closed local verification for an exact Switchy Express Git HEAD."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import sys
import time
from datetime import datetime, timezone
import xml.etree.ElementTree as ET
from typing import Sequence


EXPECTED_GODOT_PREFIX = "4.7.1"
DEFAULT_MINIMUM_GUT_TESTS = 6
PRODUCTION_ROOTS = ("game", "data", "assets", "scenes", "resources", "ui")
PRODUCTION_SUFFIXES = {".tscn", ".tres", ".res"}
EXCLUDED_TOP_LEVEL = {".git", ".godot", "tests"}


class VerificationError(RuntimeError):
    """Fail-closed validation error carrying a stable machine-readable code."""

    def __init__(self, code: str, detail: str = "") -> None:
        self.code = code
        self.detail = detail
        message = code if not detail else f"{code}: {detail}"
        super().__init__(message)


def _sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def _is_relative_to(path: Path, parent: Path) -> bool:
    try:
        path.relative_to(parent)
    except ValueError:
        return False
    return True


def _is_production_file(relative: Path) -> bool:
    if not relative.parts:
        return False
    if relative.as_posix() == "project.godot":
        return True
    if relative.parts[0] in PRODUCTION_ROOTS:
        return True
    return relative.suffix.lower() in PRODUCTION_SUFFIXES


def hash_production_files(root: Path, artifact_dir: Path) -> dict[str, str]:
    """Return stable SHA-256 hashes for production files only."""

    resolved_root = root.resolve()
    resolved_artifact = artifact_dir.resolve()
    hashes: dict[str, str] = {}
    for path in sorted(resolved_root.rglob("*"), key=lambda item: item.as_posix()):
        if not path.is_file():
            continue
        if _is_relative_to(path.resolve(), resolved_artifact):
            continue
        relative = path.relative_to(resolved_root)
        if relative.parts and relative.parts[0] in EXCLUDED_TOP_LEVEL:
            continue
        if not _is_production_file(relative):
            continue
        hashes[relative.as_posix()] = _sha256(path)
    return hashes


def parse_junit(path: Path) -> tuple[int, int, int, int]:
    """Return tests, failures, errors and skipped totals from JUnit XML."""

    if not path.is_file():
        raise VerificationError("GUT_JUNIT_MISSING", str(path))
    root = ET.parse(path).getroot()
    suites = [root] if root.tag == "testsuite" else list(root.iter("testsuite"))
    if not suites:
        raise VerificationError("GUT_JUNIT_EMPTY", str(path))

    # Some JUnit producers put aggregate values on the testsuites root and also
    # repeat child suite values. Prefer direct child suites to avoid double count.
    if root.tag == "testsuites":
        direct = [child for child in root if child.tag == "testsuite"]
        if direct:
            suites = direct

    totals = [0, 0, 0, 0]
    for suite in suites:
        totals[0] += int(suite.attrib.get("tests", "0"))
        totals[1] += int(suite.attrib.get("failures", "0"))
        totals[2] += int(suite.attrib.get("errors", "0"))
        totals[3] += int(suite.attrib.get("skipped", suite.attrib.get("disabled", "0")))
    return tuple(totals)  # type: ignore[return-value]


def verify_evidence(
    *,
    expected_head: str,
    actual_head: str,
    dirty_entries: Sequence[str],
    post_dirty_entries: Sequence[str],
    godot_version: str,
    command_results: Sequence[dict[str, object]],
    before_hashes: dict[str, str],
    after_hashes: dict[str, str],
    junit_counts: tuple[int, int, int, int],
    minimum_discovered_tests: int,
    artifact_dir: str,
    started_at: str,
    completed_at: str,
    limitations: Sequence[str],
) -> dict[str, object]:
    """Validate collected evidence and return a PASS manifest or raise."""

    if len(expected_head) != 40 or any(ch not in "0123456789abcdefABCDEF" for ch in expected_head):
        raise VerificationError("INVALID_EXACT_HEAD", expected_head)
    if len(actual_head) != 40 or any(ch not in "0123456789abcdefABCDEF" for ch in actual_head):
        raise VerificationError("INVALID_ACTUAL_HEAD", actual_head)
    if actual_head != expected_head:
        raise VerificationError("HEAD_MISMATCH", f"expected {expected_head}, actual {actual_head}")
    if dirty_entries:
        raise VerificationError("DIRTY_WORKTREE", " | ".join(dirty_entries))
    if post_dirty_entries:
        raise VerificationError("POST_RUN_DIRTY_WORKTREE", " | ".join(post_dirty_entries))
    if not godot_version.strip().startswith(EXPECTED_GODOT_PREFIX):
        raise VerificationError("GODOT_VERSION_MISMATCH", godot_version.strip())

    for result in command_results:
        exit_code = int(result.get("exit_code", -1))
        if exit_code != 0:
            raise VerificationError(
                "COMMAND_FAILED",
                f"{result.get('name', 'unnamed')} exited {exit_code}",
            )

    discovered, failures, errors, skipped = junit_counts
    if discovered < minimum_discovered_tests:
        raise VerificationError(
            "GUT_DISCOVERY_BELOW_MINIMUM",
            f"discovered {discovered}, minimum {minimum_discovered_tests}",
        )
    if failures or errors:
        raise VerificationError(
            "GUT_JUNIT_FAILURE",
            f"failures {failures}, errors {errors}",
        )
    if before_hashes != after_hashes:
        changed = sorted(set(before_hashes) | set(after_hashes))
        changed = [name for name in changed if before_hashes.get(name) != after_hashes.get(name)]
        raise VerificationError("PRODUCTION_MUTATION", ", ".join(changed))

    return {
        "schema_version": 1,
        "status": "PASS",
        "exact_head": actual_head,
        "expected_head": expected_head,
        "godot_version": godot_version.strip(),
        "started_at": started_at,
        "completed_at": completed_at,
        "artifact_dir": artifact_dir,
        "commands": [
            {
                key: result[key]
                for key in ("name", "exit_code", "duration_seconds")
                if key in result
            }
            for result in command_results
        ],
        "gut": {
            "discovered": discovered,
            "failures": failures,
            "errors": errors,
            "skipped": skipped,
            "minimum_required": minimum_discovered_tests,
        },
        "production_file_count": len(before_hashes),
        "production_hashes_before": before_hashes,
        "production_hashes_after": after_hashes,
        "production_mutation": False,
        "limitations": list(limitations),
    }


def write_manifest(path: Path, manifest: dict[str, object]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    temporary = path.with_suffix(path.suffix + ".tmp")
    temporary.write_text(
        json.dumps(manifest, ensure_ascii=False, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    temporary.replace(path)


def _run(argv: Sequence[str], cwd: Path, name: str) -> dict[str, object]:
    started = time.monotonic()
    completed = subprocess.run(
        list(argv),
        cwd=cwd,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=False,
    )
    duration = round(time.monotonic() - started, 3)
    result = {
        "name": name,
        "argv": list(argv),
        "exit_code": completed.returncode,
        "duration_seconds": duration,
        "stdout": completed.stdout,
        "stderr": completed.stderr,
    }
    sys.stdout.write(completed.stdout)
    sys.stderr.write(completed.stderr)
    return result


def _git(root: Path, *args: str) -> str:
    completed = subprocess.run(
        ["git", *args ],
        cwd=root,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=False,
    )
    if completed.returncode != 0:
        raise VerificationError("GIZßCOMMAND_FAILED", completed.stderr.strip())
    return completed.stdout.strip()


def _now() -> str:
    return datetime.now(timezone.utc).astimezone().isoformat(timespec="seconds")


def _artifact_inside_repo(root: Path, artifact_dir: Path) -> bool:
    return _is_relative_to(artifact_dir.resolve(), root.resolve())


def _build_commands(
    root: Path,
    python_executable: str,
    godot_executable: str,
    junit_path: Path,
) -> list[tuple[str, list[str]]]:
    return [
        (
            "python-unittest",
            [python_executable, "-m", "unittest", "discover", "-s", "tests/python", "-p", "test_*.py", "-v"],
        ),
        (
            "project-contract",
            [python_executable, "tools/validate_project_contract.py"],
        ),
        (
            "legacy-godot-regression",
            [
                godot_executable,
                "--headless",
                "--path",
                str(root),
                "--script",
                "res://tests/run_tests.gd",
            ],
        ),
        (
            "gut-9.7.1",
            [
                godot_executable,
                "--headless",
                "--path",
                str(root),
                "-s",
                "res://addons/gut/gut_cmdln.gd",
                "-gdir=res://tests/gut",
                "-ginclude_subdirs",
                "-gexit",
                "-glog=1",
                f"-gjunit_xml_file={junit_path}",
            ],
        ),
    ]


def run_verification(args: argparse.Namespace) -> dict[str, object]:
    root = Path(args.repo_root).resolve()
    artifact_dir = Path(args.artifact_dir).resolve()
    output = Path(args.output).resolve()
    junit_path = Path(args.junit_output).resolve()

    if not (root / ".git").exists():
        raise VerificationError("REPOSITORY_NOT_FOUND", str(root))
    if _artifact_inside_repo(root, artifact_dir):
        ignored = subprocess.run(
            ["git", "check-ignore", "-q", str(artifact_dir)],
            cwd=root,
            check=False,
        )
        if ignored.returncode != 0:
            raise VerificationError("ARTIFACT_DIR_NOT_IGNORED", str(artifact_dir))

    actual_head = _git(root, "rev-parse", "HEAD")
    dirty_text = _git(root, "status", "--porcelain=v1")
    dirty_entries = [line for line in dirty_text.splitlines() if line.strip()]
    started_at = _now()

    version_result = _run([args.godot_executable, "--version"], root, "godot-version")
    godot_version = str(version_result["stdout"]).strip() or str(version_result["stderr"]).strip()
    before_hashes = hash_production_files(root, artifact_dir)

    artifact_dir.mkdir(parents=True, exist_ok=True)
    command_results: list[dict[str, object]] = [version_result]
    for name, argv in _build_commands(
        root,
        args.python_executable,
        args.godot_executable,
        junit_path,
    ):
        command_results.append(_run(argv, root, name))

    after_hashes = hash_production_files(root, artifact_dir)
    post_dirty_text = _git(root, "status", "--porcelain=v1")
    post_dirty_entries = [line for line in post_dirty_text.splitlines() if line.strip()]
    junit_counts = parse_junit(junit_path)
    completed_at = _now()
    return verify_evidence(
        expected_head=args.expected_head,
        actual_head=actual_head,
        dirty_entries=dirty_entries,
        post_dirty_entries=post_dirty_entries,
        godot_version=godot_version,
        command_results=command_results,
        before_hashes=before_hashes,
        after_hashes=after_hashes,
        junit_counts=junit_counts,
        minimum_discovered_tests=args.minimum_gut_tests,
        artifact_dir=(
            artifact_dir.relative_to(root).as_posix()
            if _artifact_inside_repo(root, artifact_dir)
            else "EXTERNAL_TO_REPOSITORY"
        ),
        started_at=started_at,
        completed_at=completed_at,
        limitations=[
            "HIGODOT_CONNECTION_NOT_VERIFIED",
            "WINDOWS_RUNTIME_SMOKE_NOT_INCLUDED",
            "ANDROID_DEVICE_NOT_RUN",
            "HUMAN_COMPREHENSION_NOT_RUN",
        ],
    )


def _parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    subparsers = parser.add_subparsers(dest="command", required=True)
    verify = subparsers.add_parser("verify", help="run exact-HEAD verification")
    verify.add_argument("--repo-root", default=".")
    verify.add_argument("--expected-head", required=True)
    verify.add_argument("--godot-executable", required=True)
    verify.add_argument("--python-executable", default=sys.executable)
    verify.add_argument("--artifact-dir", required=True)
    verify.add_argument("--output", required=True)
    verify.add_argument("--junit-output", required=True)
    verify.add_argument("--minimum-gut-tests", type=int, default=DEFAULT_MINIMUM_GUT_TESTS)
    return parser


def main(argv: Sequence[str] | None = None) -> int:
    args = _parser().parse_args(argv)
    output = Path(args.output).resolve()
    try:
        manifest = run_verification(args)
    except VerificationError as error:
        failure = {
            "schema_version": 1,
            "status": "FAIL",
            "error_code": error.code,
            "detail": error.detail,
            "expected_head": getattr(args, "expected_head", None),
            "completed_at": _now(),
        }
        write_manifest(output, failure)
        print(str(error), file=sys.stderr)
        return 1
    write_manifest(output, manifest)
    print(f"LOCAL_EXACT_HEAD_VERIFICATION_PASS {manifest['exact_head']}")
    print(f"EVIDENCE_MANIFEST {output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
