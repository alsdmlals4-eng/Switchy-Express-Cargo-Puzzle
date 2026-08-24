# Switchy Express v4.8 Current Authority Reconciliation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the user-provided v4.8 r2 contract the current Switchy Express project execution authority without changing finite cargo gameplay, the merged SX-DEC-059 implementation, or the authorization state of SX-DEC-056~058.

**Architecture:** Keep the historical v4.7 adapter as rollback/evidence, add a new thin v4.8 project adapter, and route only current owner surfaces to the new adapter. Reclassify the old Google Sheet metadata as migration compatibility, repair active validator/Skill consumers that currently freeze stale authority, then synchronize the human-facing Notion Home and verify the exact PR head before merge.

**Tech Stack:** Markdown, JSON, Python unittest/pytest, GitHub Actions, Notion project workspace. Product runtime remains Godot 4.7.1/GDScript and is protected from this package.

**Spec:** user-provided `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8(6).md` · revision `2026-08-24-r2` · SHA-256 `6f0541048e084746f6777223521361d0339dbfb2e223c70947f694f1c050f508`

## Global Constraints

- Base latest completed main is refetched; observed at migration start: `2828a74f60c1ed09546171040f4178c8848ea686`.
- `GMB-002` finite delivery core is unchanged.
- `SX-DEC-059` remains `MERGED_MAIN_VERIFIED`; no `game/**`, Scene, Resource, map/data, product asset, or gameplay rule mutation.
- `SX-DEC-056A/057/058` remain implementation-not-authorized; `SX-DEC-056B` remains blocked by authoritative score/combo runtime.
- Notion is the human-facing project workspace; GitHub/runtime is structured implementation authority.
- Google Sheets is compatibility-only migration evidence and must not remain labelled current/user-facing GDD authority.
- Historical v4.7 adapter is retained, not deleted.
- TDD requires observed RED before GREEN; exact-head CI and post-merge readback are required before completion claims.
- Open/unrelated PRs remain read-only; only PR #164 is the current-task write surface.

---

### Task 1: RED authority contract

**Files:**
- Create: `tests/python/test_v48_current_authority_migration.py`
- Modify: `.github/workflows/project-contract.yml`

**Interfaces:**
- Consumes: v4.8 contract identity and current project owner paths.
- Produces: executable regression contract for v4.8 routing, Sheet role, current validation sequence, and deferred-package protection.

- [x] **Step 1: Write the failing regression test.**
- [x] **Step 2: Add the test to Project Contract CI.**
- [x] **Step 3: Observe RED on PR #164.**
  - Project Contract: failed specifically at `Validate v4.8 current authority migration`.
  - New suite: 5 tests; 4 failures + 1 error at initial RED.
  - Windows Demo Export: stopped at the same Python contract suite; actual Godot export steps did not run, so it is not independent export-regression evidence.

### Task 2: Add the v4.8 Switchy thin adapter and route current owners

**Files:**
- Create: `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md`
- Modify: `AGENTS.md`
- Modify: `README.md`
- Modify: `기획서/00_프로젝트_허브/START_HERE.md`
- Modify: `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
- Modify: `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`

**Interfaces:**
- Consumes: user v4.8 r2 identity, existing GMB-002/SX-DEC-059 state, v4.7 historical adapter.
- Produces: one current execution route to v4.8 while keeping historical evidence intact.

- [ ] **Step 1: Create a project-only v4.8 thin adapter.**
- [ ] **Step 2: Replace current v4.7 execution pointers on entry/owner surfaces with v4.8 pointers.**
- [ ] **Step 3: Preserve all product/evidence ceilings and deferred package states.**

### Task 3: Reclassify Google Sheets and repair validator consumers

**Files:**
- Modify: `skills/PROJECT_BASE_ADAPTER.json`
- Modify: `tests/python/test_project_base_adapter_thin_migration.py`
- Modify: `tests/test_post_merge_canon_freshness.py`
- Modify: `tests/test_base_shared_external_ai_adapter.py`
- Modify: `tests/test_base_v942_planning_first_adoption.py`
- Modify: `tests/test_base_v943_first_prompt_adoption.py`
- Modify: `tests/python/test_sx_dec_059_implementation_canonical_freshness.py`

**Interfaces:**
- Consumes: v4.8 domain split and historical Sheet provenance.
- Produces: migration-only Sheet metadata while keeping historical IDs/commit evidence and regression coverage.

- [ ] **Step 1: Add explicit workspace/domain-split metadata to the project adapter.**
- [ ] **Step 2: Change Sheet role/status from active current workspace to historical compatibility-only migration source without deleting provenance.**
- [ ] **Step 3: Update every active test that would otherwise force the stale Sheet authority or v4.7 adapter path back into current state.**

### Task 4: Repair the project-local Switchy routing Skill

**Files:**
- Modify: `skills/switchy-express-design/SKILL.md`

**Interfaces:**
- Consumes: merged SX-DEC-059 implementation plus current acceptance-candidate state.
- Produces: current validation sequence and accurate evidence ceiling for future AI/Codex routing.

- [ ] **Step 1: Replace the stale Android-first/current-legacy gate with `developer self-run / screen QA → exact acceptance build → Windows physical smoke → Android device smoke → Five-person first-contact comprehension`.**
- [ ] **Step 2: Keep old APK/hash material as historical packaging evidence only where useful.**
- [ ] **Step 3: Preserve finite core architecture and no-product-mutation boundary.**

### Task 5: GREEN and regression verification

**Files:**
- Test/CI only; no new product runtime files.

**Interfaces:**
- Consumes: Tasks 2-4 candidate state.
- Produces: executable evidence for current PR head.

- [ ] **Step 1: Run Project Contract and full Python contracts through CI.**
- [ ] **Step 2: Run Godot/GUT/Thin Adapter/Windows export workflows triggered by the exact head.**
- [ ] **Step 3: Inspect any failure with case lookup/systematic debugging; do not lower evidence or delete tests to make CI green.**

### Task 6: Notion Human Home information architecture repair

**Files/Surfaces:**
- Update: Notion `Switchy Express · Home` only for clear AI-system metadata leakage.

**Interfaces:**
- Consumes: v4.8 Human Home boundary and current Home readback.
- Produces: human-facing Home without the `AI가 이해한 핵심` meta/debug section; all project/domain subpages remain intact.

- [ ] **Step 1: Remove only the AI-meta section/callout from Home.**
- [ ] **Step 2: Preserve Project Home content, child Domain pages, visual references, links, and human-facing design information.**
- [ ] **Step 3: Fetch exact destination and record readback.**

### Task 7: Five full adversarial loops and merge gate

**Files/Surfaces:**
- Review: entire PR #164 diff, current project authority, Notion readback, relevant market evidence.

**Interfaces:**
- Consumes: GREEN exact-head candidate.
- Produces: clean-exit decision or new required findings.

- [ ] **Step 1: Full loop 1 — authority/owner/routing/consumer attack.**
- [ ] **Step 2: Full loop 2 — product-scope/evidence-ceiling/authorization attack.**
- [ ] **Step 3: Full loop 3 — validator/CI/rollback/failure-recovery attack.**
- [ ] **Step 4: Full loop 4 — human workspace/Notion/domain-split/maintenance attack.**
- [ ] **Step 5: Full loop 5 — benchmark/better-alternative/long-term-fit/full-state re-attack.**
- [ ] **Step 6: Continue with loop 6+ if any new valid blocking finding remains.**
- [ ] **Step 7: Verify review threads, reviews, required checks, exact head, then mark current-task PR ready and merge only if all repository gates permit.**
- [ ] **Step 8: Read back new `main`, recheck current PR/canon/Notion state, and leave physical/human evidence explicitly NOT_RUN.**

## Self-Review

- Spec coverage: current-authority routing, domain split, Sheets migration-only, TDD, IRG/evidence ceiling, open-PR isolation, Notion Human Home, five-loop review, exact-head/postmerge verification are all mapped.
- Placeholder scan: no TBD/TODO/unspecified implementation step is used.
- Boundary consistency: all tasks preserve GMB-002 and SX-DEC-059 runtime; only canon/consumer/validator/Notion IA surfaces are write targets.
