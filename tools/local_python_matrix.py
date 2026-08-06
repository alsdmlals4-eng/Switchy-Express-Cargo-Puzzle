#!/usr/bin/env python3
"""Validate the Windows + WSL2 Python compatibility matrix for one exact HEAD."""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Sequence


REQUIRED_TARGETS = {
    "windows-python-3.11": "3.11",
    "windows-python-3.12": "3.12",
    "windows-python-3.13": "3.13",
    "wsl-ubuntu-python-3.12": "3.12",
}


class MatrixError(RuntimeError):
    def __init__(self, code: str, detail: str = "") -> None:
        self.code = code
        self.detail = detail
        super().__init__(code if not detail else f"{code}: {detail}")


def _is_sha(value: object) -> bool:
    return isinstance(value, str) and len(value) == 40 and all(
        char in "0123456789abcdefABCDEF" for char in value
    )


def _as_int(value: object, code: str, detail: str) -> int:
    try:
        return int(value)
    except (TypeError, ValueError) as error:
        raise MatrixError(code, detail) from error


def _as_float(value: object, code: str, detail: str) -> float:
    try:
        return float(value)
    except (TypeError, ValueError) as error:
        raise MatrixError(code, detail) from error


def validate_matrix(matrix: dict[str, object], expected_head: str) -> dict[str, object]:
    if not _is_sha(expected_head):
        raise MatrixError("INVALID_EXACT_HEAD", expected_head)
    if matrix.get("status") != "PASS":
        raise MatrixError("PYTHON_MATRIX_STATUS_NOT_PASS", str(matrix.get("status")))
    matrix_head = matrix.get("exact_head")
    if not _is_sha(matrix_head):
        raise MatrixError("PYTHON_MATRIX_INVALID_HEAD", str(matrix_head))
    if matrix_head != expected_head:
        raise MatrixError("PYTHON_MATRIX_HEAD_MISMATCH", f"expected={expected_head} actual={matrix_head}")

    raw_targets = matrix.get("targets")
    if not isinstance(raw_targets, list):
        raise MatrixError("PYTHON_MATRIX_TARGETS_INVALID", "targets must be a list")
    indexed: dict[str, dict[str, object]] = {}
    for raw in raw_targets:
        if not isinstance(raw, dict):
            raise MatrixError("PYTHON_MATRIX_TARGET_INVALID", repr(raw))
        target = raw.get("target")
        if not isinstance(target, str) or target in indexed:
            raise MatrixError("PYTHON_MATRIX_TARGET_INVALID", str(target))
        indexed[target] = raw

    required = set(REQUIRED_TARGETS)
    if set(indexed) != required:
        raise MatrixError(
            "PYTHON_MATRIX_TARGETS_MISMATCH",
            f"missing={sorted(required - set(indexed))} extra={sorted(set(indexed) - required)}",
        )

    sanitized: dict[str, dict[str, object]] = {}
    for target, prefix in REQUIRED_TARGETS.items():
        raw = indexed[target]
        exit_code = _as_int(raw.get("exit_code", -1), "PYTHON_MATRIX_TARGET_INVALID", f"{target} exit_code")
        version = str(raw.get("python_version", "")).strip()
        if exit_code != 0:
            raise MatrixError("PYTHON_MATRIX_TARGET_FAILED", f"{target} exit={exit_code}")
        if version != prefix and not version.startswith(prefix + "."):
            raise MatrixError(
                "PYTHON_MATRIX_VERSION_MISMATCH",
                f"{target} expected={prefix} actual={version}",
            )
        sanitized[target] = {
            "python_version": version,
            "exit_code": exit_code,
            "duration_seconds": _as_float(raw.get("duration_seconds", 0.0), "PYTHON_MATRIX_TARGET_INVALID", f"{target} duration_seconds"),
            "log_file": str(raw.get("log_file", "")),
        }
    return {"status": "PASS", "exact_head": matrix_head, "targets": sanitized}


def load_matrix(path: Path) -> dict[str, object]:
    try:
        value = json.loads(path.read_text(encoding="utf-8-sig"))
    except (OSError, json.JSONDecodeError) as error:
        raise MatrixError("PYTHON_MATRIX_INVALID_JSON", f"{path}: {error}") from error
    if not isinstance(value, dict):
        raise MatrixError("PYTHON_MATRIX_INVALID_JSON", "root must be an object")
    return value


def _parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--manifest", required=True)
    parser.add_argument("--expected-head", required=True)
    return parser


def main(argv: Sequence[str] | None = None) -> int:
    args = _parser().parse_args(argv)
    try:
        summary = validate_matrix(load_matrix(Path(args.manifest)), args.expected_head)
    except MatrixError as error:
        print(str(error))
        return 1
    print(json.dumps(summary, ensure_ascii=False, sort_keys=True))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
