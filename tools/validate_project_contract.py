#!/usr/bin/env python3
from __future__ import annotations

import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

BASE_VERSION = "9.4.2"
BASE_RELEASE_COMMIT = "dd705d7f48a7919187bc0507610ba5fc5b43a658"
BASE_RELEASE_EVIDENCE_COMMIT = "0c6cdd128bf1f5782e96b3a6240c9585f8d1ef6d"
BASE_FINALIZATION_COMMIT = "ac9466edc2d93b59f274c9ac55ca719eba2809e3"
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
    if base_release["finalization_commit"] != BASE_FINALIZATION_COMMIT:
        raise SystemExit("unexpected Base finalization commit")
    if adapter["skill_registry"]["base"]["sha256"] != BASE_REGISTRY_SHA256:
        raise SystemExit("unexpected Base Registry SHA-256")

    planning = adapter["shared_overrides"]["managing-project-intake-and-work-contract"]["planning_first_governance"]
    if planning["base_release_lock"] != "base-v9.4.2.lock.json":
        raise SystemExit("unexpected planning-first release lock")
    if planning["max_approved_decisions_per_batch"] != 10:
        raise SystemExit("unexpected Grill Me batch maximum")
    if planning["numeric_default_state"] != "RECOMMENDED_DEFAULT":
        raise SystemExit("unexpected numeric default state")
    if planning["planning_conflict_state"] != "GRILL_ME_REQUIRED":
        raise SystemExit("unexpected planning conflict state")
    if planning["actual_project_batch_execution"] != "NOT_RUN":
        raise SystemExit("project Grill Me batch execution evidence was overstated")

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
