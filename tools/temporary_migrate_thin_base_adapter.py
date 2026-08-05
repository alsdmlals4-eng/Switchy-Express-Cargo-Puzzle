from __future__ import annotations

import hashlib
import json
import os
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
BASE_TOOLS = ROOT / ".base-contract" / "tools"
sys.path.insert(0, str(BASE_TOOLS))

import project_operating_contract as contract


BASE_SHA = os.environ["PROJECT_BASE_SHA"]
ADAPTER_PATH = ROOT / "skills/PROJECT_BASE_ADAPTER.json"
REGISTRY_PATH = ROOT / "skills/SKILL_REGISTRY.json"
HEALTH_PATH = ROOT / "docs/PROJECT_OPERATING_HEALTH.json"
MIGRATION_PATH = ROOT / "docs/operations/SWITCHY_ADAPTER_MIGRATION_STATE_2026-08-06.json"
SHEET_PATH = ROOT / "docs/operations/SWITCHY_SHEET_AUTHORITY_EVIDENCE_2026-08-06.json"


def write_json(path: Path, value: object) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(contract.canonical_json(value))


def evidence(record_id: str, source: str) -> dict[str, str]:
    path = ROOT / source
    if not path.is_file():
        raise SystemExit(f"missing evidence source: {source}")
    return {"id": record_id, "source": source, "sha256": contract.sha256_file(path)}


def active_route(skill_id: object) -> dict[str, str]:
    value = str(skill_id)
    return {"route_id": value, "skill_id": value, "status": "ACTIVE"}


def main() -> None:
    old = json.loads(ADAPTER_PATH.read_text(encoding="utf-8"))
    legacy_registry_raw = subprocess.check_output(
        ["git", "-C", str(ROOT), "show", f"{BASE_SHA}:skills/SKILL_REGISTRY.json"]
    )
    legacy_registry = json.loads(legacy_registry_raw.decode("utf-8"))
    current_registry = json.loads(REGISTRY_PATH.read_text(encoding="utf-8"))

    migration = {
        "artifact_role": "SWITCHY_ADAPTER_MIGRATION_STATE",
        "schema_version": 1,
        "decision_id": "DEC-BASE-20260805-001",
        "repository": "alsdmlals4-eng/Switchy-Express-Cargo-Puzzle",
        "baseline_commit": BASE_SHA,
        "migration_policy": "LOSSLESS_INCOMPATIBLE_SHAPES_OUTSIDE_BASE_ADAPTER",
        "legacy_routing": old["routing"],
        "legacy_validators": old["validators"],
        "legacy_gdd_sheet": old["gdd_sheet"],
        "legacy_protected_baseline": old["protected_baseline"],
        "legacy_adapter_snapshot": old,
        "legacy_project_registry": legacy_registry,
        "registry_compatibility_addition": {
            "project_skill_id": "switchy-express-design",
            "legacy_field_preserved": "id",
            "base_v1_field_added": "skill_id",
            "base_owned_entries_changed": false,
        },
        "preserved_project_evidence": [
            "기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md",
            "기획서/20_시스템_콘텐츠/CORE_SYSTEMS.md",
            "기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_RUNBOOK.md",
            "기획서/50_제작_검증/FP_01_02_IMPLEMENTATION_AUDIT.md",
            "기획서/50_제작_검증/SX_AUD_018_VALIDATION_PREPARATION_AUDIT.md",
            "docs/superpowers/specs/2026-08-05-android-validation-apk-ci-design.md",
            "docs/superpowers/plans/2026-08-05-android-validation-apk-ci.md",
            "docs/GAME_RELEASE_COMPLIANCE_EVIDENCE_PACK.md",
            "docs/PLATFORM_RELEASE_AND_ASSET_RIGHTS_PROFILE.md",
        ],
        "product_mutation": "NONE",
        "google_sheet_mutation": "NONE",
    }
    write_json(MIGRATION_PATH, migration)

    sheet_evidence = {
        "artifact_role": "SWITCHY_SHEET_AUTHORITY_EVIDENCE",
        "schema_version": 1,
        "decision_id": "DEC-BASE-20260805-001",
        "repository": "alsdmlals4-eng/Switchy-Express-Cargo-Puzzle",
        "source_adapter_baseline": BASE_SHA,
        "legacy_gdd_sheet": old["gdd_sheet"],
        "sheet_mutation": "NONE",
        "interpretation": "Existing synchronized Sheet authority is preserved; this adapter migration performs no Sheet write.",
    }
    write_json(SHEET_PATH, sheet_evidence)

    project_registry_path = str(old["skill_registry"]["project"]["path"])
    if project_registry_path != REGISTRY_PATH.relative_to(ROOT).as_posix():
        raise SystemExit(f"unexpected project Registry path: {project_registry_path}")
    project_entries = [
        item
        for item in current_registry.get("skills", [])
        if isinstance(item, dict) and item.get("owner") == "project"
    ]
    if len(project_entries) != 1 or project_entries[0].get("skill_id") != "switchy-express-design":
        raise SystemExit("project Skill compatibility identity is not established")
    project_registry_hash = hashlib.sha256(REGISTRY_PATH.read_bytes()).hexdigest()

    gdd_sheet = dict(old["gdd_sheet"])
    gdd_sheet["declared_sync_status"] = old["gdd_sheet"].get("sync_status")
    gdd_sheet["sync_status"] = "CURRENT"

    strict_adapter = {
        "schema_version": 1,
        "artifact_role": "PROJECT_BASE_ADAPTER",
        "base_release": {
            key: old["base_release"][key]
            for key in (
                "repository",
                "version",
                "release_commit",
                "release_evidence_commit",
                "finalization_commit",
            )
            if key in old["base_release"]
        },
        "project": old["project"],
        "routing": {
            "base_routes": [active_route(item) for item in old["routing"]["base_routes"]],
            "project_routes": [active_route(item) for item in old["routing"]["project_routes"]],
            "inactive_routes": [],
            "aliases": old["routing"].get("aliases", []),
            "precedence": "PROJECT_LOCAL_THEN_BASE_SHARED",
        },
        "skill_registry": {
            "base": {
                "path": old["skill_registry"]["base"]["path"],
                "sha256": old["skill_registry"]["base"]["sha256"],
                "hash_definition": "RAW_FILE_BYTES_SHA256",
            },
            "project": {
                "path": project_registry_path,
                "sha256": project_registry_hash,
                "hash_definition": "RAW_FILE_BYTES_SHA256",
            },
        },
        "shared_overrides": old["shared_overrides"],
        "gdd_sheet": gdd_sheet,
        "protected_baseline": {
            "authority_kind": "REMOTE_TRACKING_REF",
            "authority_ref": "refs/remotes/origin/main",
            "commit": BASE_SHA,
            "policy_source_type": "CANONICAL_ADAPTER_SOURCE",
            "policy_source_path": "skills/PROJECT_BASE_ADAPTER.json",
            "protected_paths_pointer": "/protected_paths",
            "policy_sha256": contract._protected_policy_hash(old["protected_paths"]),
        },
        "protected_paths": old["protected_paths"],
        "validators": [str(item["command"]) for item in old["validators"]],
        "compatibility": {
            "cycle": old["compatibility"]["cycle"],
            "views": old["compatibility"]["views"],
            "legacy_inputs": old["compatibility"]["legacy_inputs"],
        },
    }
    write_json(ADAPTER_PATH, strict_adapter)

    strict_health = {
        "schema_version": 1,
        "artifact_role": "PROJECT_OPERATING_HEALTH",
        "operating_maturity": "OM-L1",
        "product_evidence_maturity": "PE-0",
        "critical_gates": {
            "static": "PASS",
            "runtime": "NOT_RUN",
            "device": "NOT_RUN",
            "accessibility": "NOT_RUN",
            "human": "NOT_RUN",
        },
        "integrity_verdict": "PASS_WITH_NOT_RUN_GATES",
        "evidence": {
            "operating": [
                evidence("SX-ADAPTER-MIGRATION-20260806", MIGRATION_PATH.relative_to(ROOT).as_posix())
            ],
            "product": [],
            "sheet": [
                evidence("SX-SHEET-AUTHORITY-20260806", SHEET_PATH.relative_to(ROOT).as_posix())
            ],
            "gates": {
                "static": [
                    evidence("SX-BASE-RULES-STATIC", "docs/BASE_RULES_VERSION.md")
                ],
                "runtime": [],
                "device": [],
                "accessibility": [],
                "human": [],
            },
        },
    }
    write_json(HEALTH_PATH, strict_health)


if __name__ == "__main__":
    main()
