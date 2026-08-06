#!/usr/bin/env python3
"""Compatibility entry that hardens the original local exact-HEAD verifier."""

from __future__ import annotations

import importlib.util
import os
from pathlib import Path
import subprocess


BASE_PATH = Path(__file__).with_name("local_exact_head_verification.py")


def _load_base():
    spec = importlib.util.spec_from_file_location("switchy_local_exact_head_base", BASE_PATH)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"unable to load {BASE_PATH}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def main() -> int:
    os.environ["PYTHONDONTWRITEBYTECODE"] = "1"
    base = _load_base()

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
    return int(base.main())


if __name__ == "__main__":
    raise SystemExit(main())
