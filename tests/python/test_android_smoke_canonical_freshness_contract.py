from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
HUB = ROOT / "기획서" / "00_프로젝트_허브"
RUNBOOK = ROOT / "기획서" / "50_제작_검증" / "ANDROID_DEVICE_SMOKE_RUNBOOK.md"
SKILL = ROOT / "skills" / "switchy-express-design" / "SKILL.md"
SKILL_REGISTRY = ROOT / "skills" / "SKILL_REGISTRY.json"
APK_SHA256 = "eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea"


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def read_json(path: Path) -> object:
    return json.loads(read_text(path))


def test_active_project_hub_points_to_android_smoke() -> None:
    combined = "\n".join(
        read_text(HUB / name)
        for name in ("START_HERE.md", "ACTIVE_CONTEXT.md", "DEVELOPMENT_GATES.md")
    )
    for required in ("SX-AUD-019", "EV-FP-APK-001", "ANDROID_DEVICE_SMOKE"):
        assert required in combined
    assert "FIVE-PERSON COMPREHENSION: NOT_RUN" in combined
    assert "PRODUCTION CUTOVER: BLOCKED" in combined


def test_active_consumers_do_not_restore_legacy_product_authority() -> None:
    active = "\n".join(
        [
            read_text(HUB / "START_HERE.md"),
            read_text(HUB / "ACTIVE_CONTEXT.md"),
            read_text(HUB / "DEVELOPMENT_GATES.md"),
            read_text(HUB / "DOCUMENTATION_MAP.md"),
            read_text(SKILL),
        ]
    ).lower()
    forbidden_current_phrases = (
        "vs03-03 is current",
        "current package: vs03-03",
        "fuel is the current core",
        "boost is the current core",
        "capacity eight is current",
    )
    for phrase in forbidden_current_phrases:
        assert phrase not in active


def test_registries_route_to_finite_android_validation_authority() -> None:
    design_registry = read_json(HUB / "DESIGN_DOCUMENT_REGISTRY.json")
    skill_registry = read_json(SKILL_REGISTRY)
    serialized = json.dumps(
        {"design": design_registry, "skills": skill_registry},
        ensure_ascii=False,
        sort_keys=True,
    )
    for required in (
        "FINITE_DELIVERY_PUZZLE_BASELINE",
        "ANDROID_DEVICE_SMOKE",
        "SX-AUD-019",
    ):
        assert required in serialized


def test_project_skill_describes_finite_delivery_core() -> None:
    text = read_text(SKILL).lower()
    for required in (
        "manual",
        "automatic loading",
        "unlimited lifo stack",
        "finite-time completion",
        "android device smoke",
    ):
        assert required in text


def test_android_smoke_runbook_is_same_hash_and_fail_closed() -> None:
    text = read_text(RUNBOOK)
    for required in (
        APK_SHA256,
        "PASS | FAIL | BLOCKED | NOT_RUN",
        "BLOCKED_HASH_MISMATCH",
        "PROOF",
        "STACK 8",
        "STACK 16",
        "STACK 32",
        "crash",
        "ANR",
        "48dp",
        "safe area",
        "tester_alias",
        "device_alias",
    ):
        assert required in text
