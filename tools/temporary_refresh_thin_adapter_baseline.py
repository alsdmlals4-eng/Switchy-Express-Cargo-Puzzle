from __future__ import annotations

import hashlib
import json
import os
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / ".base-contract" / "tools"))
import project_operating_contract as contract

BASE_SHA = os.environ["PROJECT_BASE_SHA"]
ADAPTER = ROOT / "skills/PROJECT_BASE_ADAPTER.json"
REGISTRY = ROOT / "skills/SKILL_REGISTRY.json"
HEALTH = ROOT / "docs/PROJECT_OPERATING_HEALTH.json"
MIGRATION = ROOT / "docs/operations/SWITCHY_ADAPTER_MIGRATION_STATE_2026-08-06.json"
SHEET = ROOT / "docs/operations/SWITCHY_SHEET_AUTHORITY_EVIDENCE_2026-08-06.json"


def write(path: Path, value: object) -> None:
    path.write_bytes(contract.canonical_json(value))


def evidence(record_id: str, source: str) -> dict[str, str]:
    path = ROOT / source
    return {"id": record_id, "source": source, "sha256": contract.sha256_file(path)}


def main() -> None:
    adapter = json.loads(ADAPTER.read_text(encoding="utf-8"))
    migration = json.loads(MIGRATION.read_text(encoding="utf-8"))
    sheet = json.loads(SHEET.read_text(encoding="utf-8"))

    baseline_adapter_raw = subprocess.check_output(
        ["git", "-C", str(ROOT), "show", f"{BASE_SHA}:skills/PROJECT_BASE_ADAPTER.json"]
    )
    baseline_registry_raw = subprocess.check_output(
        ["git", "-C", str(ROOT), "show", f"{BASE_SHA}:skills/SKILL_REGISTRY.json"]
    )
    baseline_adapter = json.loads(baseline_adapter_raw.decode("utf-8"))
    baseline_registry = json.loads(baseline_registry_raw.decode("utf-8"))

    adapter["protected_baseline"]["commit"] = BASE_SHA
    adapter["protected_baseline"]["policy_sha256"] = contract._protected_policy_hash(
        baseline_adapter["protected_paths"]
    )
    adapter["skill_registry"]["project"]["sha256"] = hashlib.sha256(REGISTRY.read_bytes()).hexdigest()
    write(ADAPTER, adapter)

    migration["baseline_commit"] = BASE_SHA
    migration["legacy_adapter_snapshot"] = baseline_adapter
    migration["legacy_project_registry"] = baseline_registry
    write(MIGRATION, migration)

    sheet["source_adapter_baseline"] = BASE_SHA
    sheet["legacy_gdd_sheet"] = baseline_adapter["gdd_sheet"]
    write(SHEET, sheet)

    health = {
        "schema_version": 1,
        "artifact_role": "PROJECT_OPERATING_HEALTH",
        "operating_maturity": "OM-L1",
        "product_evidence_maturity": "PE-0",
        "critical_gates": {
            "static": "PASS",
            "runtime": "NOT_RUN",
            "device": "NOT_RUN",
            "accessibility": "NOT_RUN",
            "human": "NOT_RUN"
        },
        "integrity_verdict": "PASS_WITH_NOT_RUN_GATES",
        "evidence": {
            "operating": [evidence("SX-ADAPTER-MIGRATION-20260806", MIGRATION.relative_to(ROOT).as_posix())],
            "product": [],
            "sheet": [evidence("SX-SHEET-AUTHORITY-20260806", SHEET.relative_to(ROOT).as_posix())],
            "gates": {
                "static": [evidence("SX-BASE-RULES-STATIC", "docs/BASE_RULES_VERSION.md")],
                "runtime": [],
                "device": [],
                "accessibility": [],
                "human": []
            }
        }
    }
    write(HEALTH, health)


if __name__ == "__main__":
    main()
