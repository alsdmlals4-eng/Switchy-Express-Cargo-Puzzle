from __future__ import annotations

import copy
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ADAPTER_PATH = ROOT / "skills/PROJECT_BASE_ADAPTER.json"
HEALTH_PATH = ROOT / "docs/PROJECT_OPERATING_HEALTH.json"
MIGRATION_PATH = ROOT / "docs/operations/PROJECT_BASE_ADAPTER_MIGRATION_2026-08-06.md"
PROJECT_REGISTRY_PATH = ROOT / "skills/SKILL_REGISTRY.json"

DECISION = "DEC-BASE-20260805-001"
SOURCE_MAIN = "a45176a3655ae6b36e69f1d58a8556626ca9df86"
TRUSTED_BASE = "bfdc9e44d4a6920dc085eaa3f9d19d31b1acd2a1"
BASE_REGISTRY_SHA = "693a0dff3f054ecdd653079909e044211473838e73dd9aff07734d1ce5694c59"


def read_json(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8"))


def write_json(path: Path, value: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        json.dumps(value, ensure_ascii=False, indent=2, sort_keys=False) + "\n",
        encoding="utf-8",
    )


def sha256_bytes(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def protected_policy_hash(paths: list[str]) -> str:
    payload = json.dumps(paths, ensure_ascii=False, indent=2).encode("utf-8") + b"\n"
    return sha256_bytes(payload)


def route(value: str) -> dict:
    return {"route_id": value, "skill_id": value, "status": "ACTIVE"}


def main() -> None:
    original_bytes = ADAPTER_PATH.read_bytes()
    original = json.loads(original_bytes.decode("utf-8"))

    health = {
        "schema_version": 1,
        "artifact_role": "PROJECT_OPERATING_HEALTH",
        "project": "Switchy Express: Cargo Puzzle",
        "repository": "alsdmlals4-eng/Switchy-Express-Cargo-Puzzle",
        "current_main_at_migration": SOURCE_MAIN,
        "current_authority": {
            "design_registry": "기획서/00_프로젝트_허브/DESIGN_DOCUMENT_REGISTRY.json",
            "android_device_smoke_readiness": "기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_READINESS_CLOSURE.md",
            "android_device_smoke_runbook": "기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_RUNBOOK.md",
            "android_apk_pipeline_probe": "기획서/50_제작_검증/SX_AUD_019_ANDROID_APK_PIPELINE_PROBE.md",
            "godot_live_editor_adoption": "docs/GODOT_LIVE_EDITOR_ADOPTION.md",
        },
        "adapter_migration": {
            "decision_id": DECISION,
            "status": "PRESERVED_AND_MIGRATED_ON_DRAFT_BRANCH",
            "source_main_commit": SOURCE_MAIN,
            "trusted_base_validator": TRUSTED_BASE,
            "source_adapter_sha256": sha256_bytes(original_bytes),
            "preserved_from_adapter": {
                "gdd_sheet": copy.deepcopy(original["gdd_sheet"]),
                "protected_baseline": copy.deepcopy(original["protected_baseline"]),
                "routing": copy.deepcopy(original["routing"]),
                "validators": copy.deepcopy(original["validators"]),
            },
            "normalized_contract": {
                "adapter_schema": "BASE_V1_THIN_ADAPTER",
                "protected_baseline_policy": "OPTION_A_EXACT_TRUSTED_BASE_EQUALITY",
                "gdd_sheet_contract_status": "CURRENT",
                "project_state_authority": "docs/PROJECT_OPERATING_HEALTH.json",
                "product_files": "UNCHANGED",
                "google_sheets": "UNCHANGED",
            },
        },
        "evidence_boundaries": {
            "repository_contract_validation": "PENDING_GREEN_CI",
            "godot_project_tests": "PRESERVED_EXISTING_EVIDENCE_REQUIRES_EXACT_HEAD_RERUN",
            "android_apk_pipeline": "PRESERVED_EXISTING_REPOSITORY_EVIDENCE",
            "physical_device_validation": "NOT_RUN",
            "human_validation": "HUMAN_NOT_RUN",
            "production_adapter_ready": "NOT_READY",
        },
    }
    write_json(HEALTH_PATH, health)

    protected_paths = copy.deepcopy(original["protected_paths"])
    project_registry_sha = sha256_bytes(PROJECT_REGISTRY_PATH.read_bytes())
    gdd_sheet = copy.deepcopy(original["gdd_sheet"])
    gdd_sheet["declared_sync_status"] = original["gdd_sheet"]["sync_status"]
    gdd_sheet["sync_status"] = "CURRENT"

    adapter = {
        "artifact_role": "PROJECT_BASE_ADAPTER",
        "base_release": copy.deepcopy(original["base_release"]),
        "compatibility": copy.deepcopy(original["compatibility"]),
        "gdd_sheet": gdd_sheet,
        "project": copy.deepcopy(original["project"]),
        "protected_baseline": {
            "authority_kind": "REMOTE_TRACKING_REF",
            "authority_ref": "refs/remotes/origin/main",
            "commit": SOURCE_MAIN,
            "policy_sha256": protected_policy_hash(protected_paths),
            "policy_source_path": "skills/PROJECT_BASE_ADAPTER.json",
            "policy_source_type": "CANONICAL_ADAPTER_SOURCE",
            "protected_paths_pointer": "/protected_paths",
        },
        "protected_paths": protected_paths,
        "routing": {
            "aliases": copy.deepcopy(original["routing"]["aliases"]),
            "base_routes": [route(value) for value in original["routing"]["base_routes"]],
            "inactive_routes": [],
            "precedence": "PROJECT_LOCAL_THEN_BASE_SHARED",
            "project_routes": [route(value) for value in original["routing"]["project_routes"]],
        },
        "schema_version": 1,
        "shared_overrides": copy.deepcopy(original["shared_overrides"]),
        "skill_registry": {
            "base": {
                "hash_definition": "RAW_FILE_BYTES_SHA256",
                "path": "skills/SKILL_REGISTRY.json",
                "sha256": BASE_REGISTRY_SHA,
            },
            "project": {
                "hash_definition": "RAW_FILE_BYTES_SHA256",
                "path": "skills/SKILL_REGISTRY.json",
                "sha256": project_registry_sha,
            },
        },
        "validators": [value["command"] for value in original["validators"]]
        + [
            "python -m unittest tests.test_project_base_adapter_thin_migration -v",
            "python -m pytest tests/test_godot_live_editor_adoption.py -q",
        ],
    }
    write_json(ADAPTER_PATH, adapter)

    mapping_rows = [
        ("/gdd_sheet/sync_status", "/adapter_migration/preserved_from_adapter/gdd_sheet/sync_status", "SYNCED retained; adapter token CURRENT"),
        ("/protected_baseline", "/adapter_migration/preserved_from_adapter/protected_baseline", "invalid legacy enums retained; canonical exact-base contract replaces them"),
        ("/routing/base_routes", "/adapter_migration/preserved_from_adapter/routing/base_routes", "strings retained and converted to ACTIVE typed records"),
        ("/routing/project_routes", "/adapter_migration/preserved_from_adapter/routing/project_routes", "strings retained and converted to ACTIVE typed records"),
        ("/validators", "/adapter_migration/preserved_from_adapter/validators", "status and evidence preserved; executable command strings remain in adapter"),
    ]
    table = "\n".join(f"| `{source}` | `{target}` | {rule} |" for source, target, rule in mapping_rows)
    MIGRATION_PATH.parent.mkdir(parents=True, exist_ok=True)
    MIGRATION_PATH.write_text(
        f"""# Switchy Express Project Base Adapter Migration — 2026-08-06

```yaml
decision_id: {DECISION}
source_main: {SOURCE_MAIN}
trusted_base_validator: {TRUSTED_BASE}
strategy: OPTION_A_EXACT_TRUSTED_BASE_EQUALITY
adapter_authority: BASE_V1_THIN_ADAPTER
project_state_authority: docs/PROJECT_OPERATING_HEALTH.json
PRODUCT_FILES_UNCHANGED: true
GOOGLE_SHEETS_UNCHANGED: true
physical_device_validation: NOT_RUN
human_validation: HUMAN_NOT_RUN
production_adapter_ready: NOT_READY
```

## Preserved project evidence

- `기획서/00_프로젝트_허브/DESIGN_DOCUMENT_REGISTRY.json`
- `기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_READINESS_CLOSURE.md`
- `기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_RUNBOOK.md`
- `기획서/50_제작_검증/SX_AUD_019_ANDROID_APK_PIPELINE_PROBE.md`
- `docs/GODOT_LIVE_EDITOR_ADOPTION.md`

These references remain project-owned. Repository and CI evidence does not promote physical-device, human, or production-adapter readiness.

## Field map

| Original adapter field | Project-owned destination | Treatment |
|---|---|---|
{table}

## Scope boundary

The migration changes the Base connection contract and official generated views only. It does not edit `project.godot`, `game/**`, `assets/**`, `기획서/**`, APK evidence, Godot Pilot adoption content, or Google Sheet cells.
""",
        encoding="utf-8",
    )


if __name__ == "__main__":
    main()
