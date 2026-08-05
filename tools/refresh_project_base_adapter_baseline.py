from __future__ import annotations

import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OLD_BASE = "a45176a3655ae6b36e69f1d58a8556626ca9df86"
NEW_BASE = "8c6dd60c634019e64178e72aa4959a2a970708e1"

ADAPTER_PATH = ROOT / "skills/PROJECT_BASE_ADAPTER.json"
STATE_PATH = ROOT / "docs/PROJECT_OPERATING_STATE.json"
HEALTH_PATH = ROOT / "docs/PROJECT_OPERATING_HEALTH.json"
MIGRATION_PATH = ROOT / "docs/operations/PROJECT_BASE_ADAPTER_MIGRATION_2026-08-06.md"
PLAN_PATH = ROOT / "docs/superpowers/plans/2026-08-06-switchy-thin-base-adapter-migration.md"
TEST_PATH = ROOT / "tests/test_project_base_adapter_thin_migration.py"
APK_EVIDENCE_PATH = ROOT / "기획서/50_제작_검증/SX_AUD_019_ANDROID_APK_PIPELINE_PROBE.md"


def read_json(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8"))


def write_json(path: Path, value: dict) -> None:
    path.write_text(
        json.dumps(value, ensure_ascii=False, indent=2, sort_keys=False) + "\n",
        encoding="utf-8",
    )


def replace_exact(path: Path) -> None:
    text = path.read_text(encoding="utf-8")
    count = text.count(OLD_BASE)
    if count == 0:
        raise SystemExit(f"expected stale baseline token in {path}")
    path.write_text(text.replace(OLD_BASE, NEW_BASE), encoding="utf-8")


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def evidence(evidence_id: str, source: str, path: Path) -> dict:
    return {"id": evidence_id, "source": source, "sha256": sha256(path)}


def main() -> None:
    adapter = read_json(ADAPTER_PATH)
    if adapter["protected_baseline"]["commit"] != OLD_BASE:
        raise SystemExit("adapter baseline does not match expected previous PR base")
    adapter["protected_baseline"]["commit"] = NEW_BASE
    write_json(ADAPTER_PATH, adapter)

    state = read_json(STATE_PATH)
    if state["current_main_at_migration"] != OLD_BASE:
        raise SystemExit("state current_main_at_migration does not match expected previous PR base")
    if state["adapter_migration"]["source_main_commit"] != OLD_BASE:
        raise SystemExit("state source_main_commit does not match expected previous PR base")
    state["current_main_at_migration"] = NEW_BASE
    state["adapter_migration"]["source_main_commit"] = NEW_BASE
    state["adapter_migration"]["baseline_refresh"] = {
        "reason": "MAIN_ADVANCED_BY_PR_89_BEFORE_ADAPTER_PR_COMPLETION",
        "previous_exact_base": OLD_BASE,
        "current_exact_base": NEW_BASE,
        "preserved_main_change": "SELF_CONTAINED_GODOT_PILOT_EVIDENCE",
        "product_files_modified_by_adapter_refresh": False,
    }
    write_json(STATE_PATH, state)

    for path in (MIGRATION_PATH, PLAN_PATH, TEST_PATH):
        replace_exact(path)

    health = read_json(HEALTH_PATH)
    health["evidence"]["operating"] = [
        evidence("switchy-operating-state", "docs/PROJECT_OPERATING_STATE.json", STATE_PATH)
    ]
    health["evidence"]["product"] = [
        evidence(
            "switchy-apk-pipeline",
            "기획서/50_제작_검증/SX_AUD_019_ANDROID_APK_PIPELINE_PROBE.md",
            APK_EVIDENCE_PATH,
        )
    ]
    health["evidence"]["sheet"] = [
        evidence(
            "switchy-sheet-migration",
            "docs/operations/PROJECT_BASE_ADAPTER_MIGRATION_2026-08-06.md",
            MIGRATION_PATH,
        )
    ]
    health["evidence"]["gates"]["static"] = [
        evidence("switchy-static-adapter", "skills/PROJECT_BASE_ADAPTER.json", ADAPTER_PATH)
    ]
    write_json(HEALTH_PATH, health)


if __name__ == "__main__":
    main()
