# Switchy Express Project Base Adapter Migration — 2026-08-06

```yaml
decision_id: DEC-BASE-20260805-001
source_main: a45176a3655ae6b36e69f1d58a8556626ca9df86
trusted_base_validator: bfdc9e44d4a6920dc085eaa3f9d19d31b1acd2a1
strategy: OPTION_A_EXACT_TRUSTED_BASE_EQUALITY
adapter_authority: BASE_V1_THIN_ADAPTER
project_registry: skills/SKILL_REGISTRY.json
project_registry_authority: PROJECT_ONLY_REGISTRY
project_state_authority: docs/PROJECT_OPERATING_STATE.json
machine_health_authority: docs/PROJECT_OPERATING_HEALTH.json
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

| Original adapter or Registry field | Project-owned destination | Treatment |
|---|---|---|
| `skills/SKILL_REGISTRY.json base-owned entries` | `/adapter_migration/original_project_skill_registry` | removed from project Registry; Base Registry remains authority |
| `skills/SKILL_REGISTRY.json#/skills/*/id` | `/adapter_migration/original_project_skill_registry` | project legacy id retained; matching skill_id added |
| `/gdd_sheet/sync_status` | `/adapter_migration/preserved_from_adapter/gdd_sheet/sync_status` | SYNCED retained; adapter token CURRENT |
| `/protected_baseline` | `/adapter_migration/preserved_from_adapter/protected_baseline` | invalid legacy enums retained; canonical exact-base contract replaces them |
| `/routing/base_routes` | `/adapter_migration/preserved_from_adapter/routing/base_routes` | strings retained and converted to ACTIVE typed records |
| `/routing/project_routes` | `/adapter_migration/preserved_from_adapter/routing/project_routes` | strings retained and converted to ACTIVE typed records |
| `/validators` | `/adapter_migration/preserved_from_adapter/validators` | status and evidence preserved; executable command strings remain in adapter |

## Registry authority correction

The former project Registry duplicated Base-owned Skill entries and used legacy `id` keys. The active Registry now contains project-owned Skills only. `switchy-express-design` keeps its original `id` and receives the identical canonical `skill_id`. No project Skill is renamed, removed, or redirected. The original complete Registry and raw-byte hash are preserved in `docs/PROJECT_OPERATING_STATE.json`.

## Evidence separation

- operating maturity: `docs/PROJECT_OPERATING_STATE.json`;
- product evidence: `기획서/50_제작_검증/SX_AUD_019_ANDROID_APK_PIPELINE_PROBE.md`;
- Sheet-current contract: this migration record;
- static adapter gate: `skills/PROJECT_BASE_ADAPTER.json`.

Each health evidence ID and source is unique. One operating and one product record cap the conservative machine levels at `OM-L1` and `PE-1`. Existing Godot and APK evidence is preserved, but runtime remains `NOT_RUN` in this adapter migration until exact-head project execution is separately evaluated.

## Scope boundary

The migration changes the project Registry authority, Base connection contract, standard machine health, project-owned state, and official generated views only. It does not edit `project.godot`, `game/**`, `assets/**`, `기획서/**`, APK evidence, Godot Pilot adoption content, or Google Sheet cells.
