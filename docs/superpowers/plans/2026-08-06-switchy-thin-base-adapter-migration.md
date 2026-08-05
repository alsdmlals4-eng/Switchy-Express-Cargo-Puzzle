# Switchy Express Thin Base Adapter Migration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rebuild Switchy Express's schema-v1-labelled but non-v1 adapter as a strict Base v1 thin adapter while preserving Sheet, validator, Android/APK, finite-product, and project evidence in project-owned authority.

**Architecture:** The canonical adapter will contain only Base release identity, project binding, typed routes, current Registry hashes, project-specific overrides, a canonical Sheet state token, exact protected baseline, protected paths, executable validators, and compatibility declarations. Historical validator results, the original Sheet status, baseline enums, and product evidence references will move into a new `docs/PROJECT_OPERATING_HEALTH.json`; `docs/operations/PROJECT_BASE_ADAPTER_MIGRATION_2026-08-06.md` will provide a lossless field map. Base validator and generator commit `bfdc9e44d4a6920dc085eaa3f9d19d31b1acd2a1` is immutable.

**Tech Stack:** JSON, Markdown, Python 3.12 `unittest`, GitHub Actions, Base v1 validator/generator, existing Godot 4.7.1 project tests.

## Global Constraints

- Governing decision: `DEC-BASE-20260805-001`.
- Exact PR-base baseline: `782feadb0362428c85c2b82b4b8b7abbc7293461`.
- Trusted Base validator: `bfdc9e44d4a6920dc085eaa3f9d19d31b1acd2a1`.
- Preserve active finite product canon, Android smoke readiness, APK pipeline evidence, Godot Pilot adoption, and Google Sheet authority without promoting evidence.
- `physical_device_validation` and `human_validation` remain `NOT_RUN`.
- No changes to `project.godot`, `game/**`, `assets/**`, `기획서/**`, product behavior, APK bytes, or Google Sheet cells.
- Generated adapter views are created only with Base `build_project_operating_artifacts.py --write`.

---

### Task 1: Establish RED migration contract

**Files:**
- Create: `tests/test_project_base_adapter_thin_migration.py`
- Create: `.github/workflows/validate-project-base-adapter.yml`

**Interfaces:**
- Consumes: current noncanonical adapter and trusted Base validator.
- Produces: exact failing evidence for untyped routes, object validators, invalid status enums, stale baseline, and missing state authority.

- [ ] **Step 1: Write the failing test**

The test must require the strict twelve-key adapter root; typed route records; executable string validators; `gdd_sheet.sync_status == "CURRENT"`; canonical baseline enums and exact PR-base commit; three-field Registry records with raw-byte SHA-256; and `docs/PROJECT_OPERATING_HEALTH.json` containing original Sheet, baseline, and validator evidence.

- [ ] **Step 2: Add immutable Base validator workflow**

Check out Base exactly at `bfdc9e...`, run the focused migration test, then run `check_project_operating_contract.py --check` with `${{ github.event.pull_request.base.sha }}`.

- [ ] **Step 3: Verify RED on Draft PR**

Expected failures: route strings, validator objects, `SYNCED`, `GIT_COMMIT`, `VERIFIED_PROJECT_MAIN`, stale baseline, absent project health, and stale generated outputs.

- [ ] **Step 4: Commit RED evidence**

```bash
git add tests/test_project_base_adapter_thin_migration.py .github/workflows/validate-project-base-adapter.yml
git commit -m "test: expose Switchy thin adapter drift"
```

### Task 2: Create project-owned operating health and migration map

**Files:**
- Create: `docs/PROJECT_OPERATING_HEALTH.json`
- Create: `docs/operations/PROJECT_BASE_ADAPTER_MIGRATION_2026-08-06.md`

**Interfaces:**
- Consumes: exact original adapter at `main@782feadb...` and current canonical evidence paths.
- Produces: lossless project-state authority independent from the Base connection adapter.

- [ ] **Step 1: Preserve original noncanonical values**

Record exact copies of the original `gdd_sheet`, `protected_baseline`, `routing`, and validator objects under `adapter_migration.preserved_from_adapter`.

- [ ] **Step 2: Record project evidence boundaries**

Reference:

```text
기획서/00_프로젝트_허브/DESIGN_DOCUMENT_REGISTRY.json
기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_READINESS_CLOSURE.md
기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_RUNBOOK.md
기획서/50_제작_검증/SX_AUD_019_ANDROID_APK_PIPELINE_PROBE.md
docs/GODOT_LIVE_EDITOR_ADOPTION.md
```

State explicitly that repository/CI evidence does not promote physical-device, human, or production-adapter readiness.

- [ ] **Step 3: Write complete field map**

Map route strings to typed records, validator objects to command strings plus health evidence, `SYNCED` to adapter token `CURRENT`, and invalid baseline enums to canonical values. Record all previous tokens verbatim in health.

- [ ] **Step 4: Run focused test**

Expected: preservation tests pass while adapter-shape tests remain RED.

- [ ] **Step 5: Commit project authority**

```bash
git add docs/PROJECT_OPERATING_HEALTH.json docs/operations/PROJECT_BASE_ADAPTER_MIGRATION_2026-08-06.md
git commit -m "docs: preserve Switchy adapter-owned evidence"
```

### Task 3: Build canonical typed adapter

**Files:**
- Modify: `skills/PROJECT_BASE_ADAPTER.json`

**Interfaces:**
- Consumes: project health and Base v1 Schema.
- Produces: strict adapter with no project-state database behavior.

- [ ] **Step 1: Keep only Schema-owned root keys**

Use exactly:

```python
{
    "artifact_role", "base_release", "compatibility", "gdd_sheet",
    "project", "protected_baseline", "protected_paths", "routing",
    "schema_version", "shared_overrides", "skill_registry", "validators",
}
```

- [ ] **Step 2: Normalize Sheet and baseline**

Keep Sheet ID, URL, decision commit, and verification timestamp, add `declared_sync_status: "SYNCED"`, and set the contract status to `CURRENT`. Set baseline authority to `REMOTE_TRACKING_REF`, ref to `refs/remotes/origin/main`, source type to `CANONICAL_ADAPTER_SOURCE`, source path to the canonical adapter, and commit to `782feadb...`.

- [ ] **Step 3: Calculate policy and Registry hashes**

Serialize protected paths using `json.dumps(..., ensure_ascii=False, indent=2) + "\n"` and SHA-256 those bytes. Compute the project Registry SHA from raw bytes of `skills/SKILL_REGISTRY.json`; retain Base Registry SHA `693a0dff3f054ecdd653079909e044211473838e73dd9aff07734d1ce5694c59`.

- [ ] **Step 4: Convert routes**

Every existing Base route string becomes an ACTIVE `{route_id, skill_id, status}` record. `switchy-express-design` becomes an ACTIVE project route record. No route is silently deleted.

- [ ] **Step 5: Convert validator evidence**

Adapter validators become executable command strings. Original status/evidence/summary objects remain in project health. Include the current Godot live-editor adoption test without claiming production readiness.

- [ ] **Step 6: Run focused test**

Expected: adapter ownership and state-preservation tests pass; generated-view validation may remain RED until Task 4.

- [ ] **Step 7: Commit adapter**

```bash
git add skills/PROJECT_BASE_ADAPTER.json
git commit -m "fix: rebuild Switchy thin Base adapter"
```

### Task 4: Regenerate and validate Base-owned outputs

**Files:**
- Modify only official generator outputs.

**Interfaces:**
- Consumes: strict adapter.
- Produces: fresh Snapshot, Dashboard, router, and declared compatibility views.

- [ ] **Step 1: Run official generator**

```bash
python .base-contract/tools/build_project_operating_artifacts.py \
  --project-root . \
  --base-repository .base-contract \
  --protected-base 782feadb0362428c85c2b82b4b8b7abbc7293461 \
  --write
```

- [ ] **Step 2: Reject unexpected paths**

No product, planning canon, APK, or Godot Pilot adoption file may be changed by generation.

- [ ] **Step 3: Run Base validator and project tests**

```bash
python .base-contract/tools/check_project_operating_contract.py \
  --project-root . \
  --base-repository .base-contract \
  --protected-base 782feadb0362428c85c2b82b4b8b7abbc7293461 \
  --check
python -m unittest tests.test_project_base_adapter_thin_migration -v
python tools/validate_project_contract.py
godot --headless --path . --script res://tests/run_tests.gd
```

- [ ] **Step 4: Commit generated outputs**

```bash
git add skills/ docs/PROJECT_OPERATING_DASHBOARD.html .agents/
git commit -m "chore: regenerate Switchy adapter views"
```

### Task 5: Adversarial closure

**Files:**
- Modify: PR description only unless findings require corrections.

**Interfaces:**
- Consumes: complete diff, exact-head CI, migration map, and project health.
- Produces: Draft PR ready for explicit merge decision.

- [ ] **Step 1: Prove scope**

Confirm `project.godot`, `game/**`, `assets/**`, `기획서/**`, APK evidence, Godot Pilot adoption, and Google Sheet cells are unchanged.

- [ ] **Step 2: Prove information preservation**

Every noncanonical original adapter value must appear either in canonical adapter metadata or `docs/PROJECT_OPERATING_HEALTH.json`, with the migration map identifying the destination.

- [ ] **Step 3: Verify exact-head checks and review state**

Require Base adapter validator, finite validation, Android/APK contracts, Godot project tests, current adoption contracts, mergeability, zero behind, and zero unresolved review threads.

- [ ] **Step 4: Record truthful evidence**

```yaml
adapter_contract: PASS
state_and_evidence_preservation: PASS
product_files: UNCHANGED
google_sheets: UNCHANGED
physical_device_validation: NOT_RUN
human_validation: HUMAN_NOT_RUN
production_adapter_ready: NOT_READY
merge_authorization: NOT_GRANTED
```

- [ ] **Step 5: Keep Draft for explicit approval**
