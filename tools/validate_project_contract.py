#!/usr/bin/env python3
from __future__ import annotations

import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

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
    "기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md"
]

def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()

def main() -> int:
    missing = [path for path in REQUIRED if not (ROOT / path).exists()]
    if missing:
        raise SystemExit(f"missing required files: {missing}")

    adapter = json.loads((ROOT / "skills/PROJECT_BASE_ADAPTER.json").read_text(encoding="utf-8"))
    registry_path = ROOT / adapter["skill_registry"]["project"]["path"]
    actual = sha256(registry_path)
    expected = adapter["skill_registry"]["project"]["sha256"]
    if actual != expected:
        raise SystemExit(f"project skill registry hash mismatch: {actual} != {expected}")

    if adapter["base_release"]["version"] != "9.3.0":
        raise SystemExit("unexpected Base version")
    if adapter["project"]["engine"] != "Godot 4.7.1":
        raise SystemExit("unexpected engine pin")

    print("project operating contract: PASS")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
