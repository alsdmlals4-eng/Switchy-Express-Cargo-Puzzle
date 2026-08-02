#!/usr/bin/env python3
from __future__ import annotations

import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

BASE_VERSION = "9.4.1"
BASE_RELEASE_COMMIT = "3f2c4a624d302b704c1b5322eb5c9f34ad55abb9"
BASE_RELEASE_EVIDENCE_COMMIT = "ff117d24d5bdb121314e109a6aa9b4f552e0fdc1"
BASE_REGISTRY_SHA256 = "693a0dff3f054ecdd653079909e044211473838e73dd9aff07734d1ce5694c59"

REQUIRED = [
    "AGENTS.md",
    "README.md",
    "docs/BASE_RULES_VERSION.md",
    "skills/PROJECT_BASE_ADAPTER.json",
    "skills/SKILL_REGISTRY.json",
    "기획서/00_프로젝트_허브/START_HERE.md",
    "기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md",
    "기획서/10_경험/CORE_GAMEPLAY.md",
    "기획서/20_시스템_콘텐츠/CORE_SYSTEMS.md",
    "기획서/40_표현/VISUAL_DIRECTION.md",
    "기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md",
]


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> int:
    missing = [path for path in REQUIRED if not (ROOT / path).exists()]
    if missing:
        raise SystemExit(f"missing required files: {missing}")

    adapter = json.loads(
        (ROOT / "skills/PROJECT_BASE_ADAPTER.json").read_text(encoding="utf-8")
    )
    registry_path = ROOT / adapter["skill_registry"]["project"]["path"]
    actual = sha256(registry_path)
    expected = adapter["skill_registry"]["project"]["sha256"]
    if actual != expected:
        raise SystemExit(f"project skill registry hash mismatch: {actual} != {expected}")

    base_release = adapter["base_release"]
    if base_release["version"] != BASE_VERSION:
        raise SystemExit("unexpected Base version")
    if base_release["release_commit"] != BASE_RELEASE_COMMIT:
        raise SystemExit("unexpected Base release commit")
    if base_release["release_evidence_commit"] != BASE_RELEASE_EVIDENCE_COMMIT:
        raise SystemExit("unexpected Base release evidence commit")
    if adapter["skill_registry"]["base"]["sha256"] != BASE_REGISTRY_SHA256:
        raise SystemExit("unexpected Base Registry SHA-256")

    override = adapter["shared_overrides"]["orchestrating-deepseek-worktrees"]
    if override["base_validator_adoption"] != "ADOPTED_FROM_BASE_V9_4_1":
        raise SystemExit("external-AI validator is not adopted from Base v9.4.1")
    if override["base_validator_path"] != "tools/check_external_ai_worktree_contract.py":
        raise SystemExit("unexpected external-AI validator path")
    if override["base_release_lock"] != "base-v9.4.1.lock.json":
        raise SystemExit("unexpected external-AI release lock")
    if override["actual_external_ai_worktree_execution"] != "NOT_RUN":
        raise SystemExit("external-AI execution evidence was overstated")

    if adapter["project"]["engine"] != "Godot 4.7.1":
        raise SystemExit("unexpected engine pin")

    print("project operating contract: PASS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
