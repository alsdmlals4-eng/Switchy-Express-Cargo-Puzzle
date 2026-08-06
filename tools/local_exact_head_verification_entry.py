#!/usr/bin/env python3
"""Compatibility entry that binds Python matrix evidence to the base verifier."""

from __future__ import annotations

import hashlib
import importlib.util
import json
import os
from pathlib import Path
import subprocess
import sys
from typing import Sequence


BASE_PATH = Path(__file__).with_name("local_exact_head_verification.py")
MATRIX_PATH = Path(__file__).with_name("local_python_matrix.py")


def _load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"unable to load {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def _option_value(argv: Sequence[str], flag: str) -> str:
    try:
        index = list(argv).index(flag)
        return str(argv[index + 1])
    except (ValueError, IndexError) as error:
        raise RuntimeError(f"MATRIX_ARGUMENT_MISSING: {flag}") from error


def _without_option(argv: Sequence[str], flag: str) -> list[str]:
    result = list(argv)
    try:
        index = result.index(flag)
        del result[index : index + 2]
    except ValueError:
        pass
    return result


def _sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def bind_matrix_to_manifest(
    output_path: Path,
    matrix_path: Path,
    matrix_summary: dict[str, object],
) -> None:
    payload = json.loads(output_path.read_text(encoding="utf-8-sig"))
    if not isinstance(payload, dict) or payload.get("status") != "PASS":
        raise RuntimeError("BASE_MANIFEST_NOT_PASS")
    payload["schema_version"] = 2
    payload["python_matrix"] = matrix_summary
    payload["python_matrix_sha256"] = _sha256(matrix_path)
    temporary = output_path.with_suffix(output_path.suffix + ".matrix.tmp")
    temporary.write_text(
        json.dumps(payload, ensure_ascii=False, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )
    temporary.replace(output_path)


def main(argv: Sequence[str] | None = None) -> int:
    os.environ["PYTHONDONTWRITEBYTECODE"] = "1"
    raw_argv = list(sys.argv[1:] if argv is None else argv)
    base = _load_module("switchy_local_exact_head_base", BASE_PATH)
    matrix = _load_module("switchy_local_python_matrix", MATRIX_PATH)

    def stable_git(root: Path, *args: str) -> str:
        completed = subprocess.run(
            ["git", *args],
            cwd=root,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            check=False,
        )
        if completed.returncode != 0:
            raise base.VerificationError("GIT_COMMAND_FAILED", completed.stderr.strip())
        return completed.stdout.strip()

    base._git = stable_git

    try:
        expected_head = _option_value(raw_argv, "--expected-head")
        matrix_manifest = Path(_option_value(raw_argv, "--python-matrix-manifest")).resolve()
        output_path = Path(_option_value(raw_argv, "--output")).resolve()
        matrix_summary = matrix.validate_matrix(matrix.load_matrix(matrix_manifest), expected_head)
    except (RuntimeError, matrix.MatrixError) as error:
        print(str(error), file=sys.stderr)
        return 1

    base_argv = _without_option(raw_argv, "--python-matrix-manifest")
    result = int(base.main(base_argv))
    if result != 0:
        return result

    try:
        bind_matrix_to_manifest(output_path, matrix_manifest, matrix_summary)
    except (OSError, ValueError, RuntimeError, json.JSONDecodeError) as error:
        print(f"MATRIX_BIND_FAILED: {error}", file=sys.stderr)
        return 1

    print(f"PYTHON_MATRIX_BOUND {matrix_manifest}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
