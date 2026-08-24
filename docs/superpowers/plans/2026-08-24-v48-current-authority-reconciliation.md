# Switchy Express v4.8 Current Authority Reconciliation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the user-provided v4.8 r2 contract the current Switchy Express project execution authority without changing finite cargo gameplay, the merged SX-DEC-059 implementation, or the authorization state of SX-DEC-056~058.

**Architecture:** Keep the historical v4.7 adapter as rollback/evidence, add a new thin v4.8 project adapter, and route the unprotected entry/adapter/Skill surfaces to it first. Reclassify the old Google Sheet metadata as migration compatibility and repair active validator consumers. Because `기획서/**` is a protected path under the adapter contract, do not weaken that guard or mix those protected canon edits into the adapter-migration PR. Merge the validated adapter migration first, then create one sequential latest-main follow-up PR that synchronizes the protected current-canon documents. Finish with Notion system-record synchronization and destination readback.

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
- Open/unrelated PRs remain read-only; only one current-task PR is writable at a time. PR #164 is completed/merged before the protected-canon follow-up PR is created.
- `기획서/**` protection is not bypassed, removed, narrowed, or worked around to make this migration pass.

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

### Task 2: Add the v4.8 Switchy thin adapter and route unprotected entry owners

**Files:**
- Create: `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md`
- Modify: `AGENTS.md`
- Modify: `README.md`

**Interfaces:**
- Consumes: user v4.8 r2 identity, existing GMB-002/SX-DEC-059 state, v4.7 historical adapter.
- Produces: one current top-level execution route to v4.8 while keeping historical evidence intact.

- [x] **Step 1: Create a project-only v4.8 thin adapter.**
- [x] **Step 2: Route unprotected top-level entry owners to v4.8.**
- [x] **Step 3: Preserve all product/evidence ceilings and deferred package states.**
- [x] **Step 4: Leave protected `기획서/**` current-canon files unchanged in PR #164 and register their synchronization as the immediate sequential post-merge task.**

### Task 3: Reclassify Google Sheets and repair validator consumers

**Files:**
- Modify: `skills/PROJECT_BASE_ADAPTER.json`
- Modify: `tests/python/test_project_base_adapter_thin_migration.py`
- Modify: `tests/test_post_merge_canon_freshness.py`
- Modify: `tests/test_base_shared_external_ai_adapter.py`
- Modify: `tests/test_base_v942_planning_first_adoption.py`
- Modify: `tests/test_base_v943_first_prompt_adoption.py`
- Modify: `tests/python/test_sx_dec_059_implementation_canonical_freshness.py`
- Regenerate: `skills/PROJECT_SKILL_SNAPSHOT.json`
- Regenerate: `docs/PROJECT_OPERATING_DASHBOARD.html`

**Interfaces:**
- Consumes: v4.8 domain split and historical Sheet provenance.
- Produces: migration-only Sheet metadata while keeping historical IDs/commit evidence and regression coverage.

- [x] **Step 1: Add explicit workspace/domain-split metadata to the project adapter.**
- [x] **Step 2: Change Sheet role/status from active current workspace to historical compatibility-only migration source without deleting provenance.**
- [x] **Step 3: Update active tests that would otherwise force stale Sheet authority or the v4.7 adapter path back into current state.**
- [x] **Step 4: Regenerate deterministic operating derivatives after the adapter changed.**
  - Initial exact-head validator failure identified stale `PROJECT_SKILL_SNAPSHOT.json` and `PROJECT_OPERATING_DASHBOARD.html`.
  - Root cause: their generated adapter raw-byte hash still referenced the pre-migration adapter.
  - Minimal regeneration restored `Validate Project Base Adapter` to GREEN without weakening a validator or deleting a test.

### Task 4: Repair the project-local Switchy routing Skill

**Files:**
- Modify: `skills/switchy-express-design/SKILL.md`

**Interfaces:**
- Consumes: merged SX-DEC-059 implementation plus current acceptance-candidate state.
- Produces: current validation sequence and accurate evidence ceiling for future AI/Codex routing.

- [x] **Step 1: Replace the stale Android-first/current-legacy gate with `developer self-run / screen QA → exact acceptance build → Windows physical smoke → Android device smoke → Five-person first-contact comprehension`.**
- [x] **Step 2: Keep old APK/hash material as historical packaging evidence only where useful.**
- [x] **Step 3: Preserve finite core architecture and no-product-mutation boundary.**

### Task 5: GREEN and regression verification for PR #164

**Files:**
- Test/CI only; no product runtime files.

**Interfaces:**
- Consumes: Tasks 2-4 candidate state.
- Produces: executable evidence for the exact PR head.

- [x] **Step 1: Run Project Contract and Python contract workflows through CI.**
- [x] **Step 2: Run Godot/GUT/Thin Adapter/Windows export workflows triggered by the exact head.**
- [x] **Step 3: Inspect the adapter-validator failure with systematic debugging and restore GREEN by deterministic regeneration rather than lowering evidence.**

### Task 6: Notion Human Home readback

**Files/Surfaces:**
- Inspect: Notion `Switchy Express · Home`.
- Update only if clear AI-system metadata leakage actually exists.

**Interfaces:**
- Consumes: v4.8 Human Home boundary and current Home readback.
- Produces: human-facing Home preserving project/domain pages and human-readable design information.

- [x] **Step 1: Fetch the exact Human Home.**
- [x] **Step 2: Confirm the current fetched Home is already human-facing and does not contain the planned `AI가 이해한 핵심` debug/meta section.**
- [x] **Step 3: Apply no destructive/no-op rewrite; preserve Project Home content, child Domain pages, visual references, links, and design information.**

### Task 7: PR #164 adversarial review and merge gate

**Files/Surfaces:**
- Review: entire PR #164 diff, current project authority, Notion readback, Base current main, and current product/evidence boundaries.

**Interfaces:**
- Consumes: GREEN exact-head candidate.
- Produces: clean bounded-PR exit or new required findings.

- [ ] **Step 1: Full loop 1 — authority/owner/routing/consumer attack.**
- [ ] **Step 2: Full loop 2 — product-scope/evidence-ceiling/authorization attack.**
- [ ] **Step 3: Full loop 3 — validator/CI/rollback/failure-recovery attack.**
- [ ] **Step 4: Full loop 4 — human workspace/Notion/domain-split/maintenance attack.**
- [ ] **Step 5: Full loop 5 — better-alternative/long-term-fit/full-state re-attack.**
- [ ] **Step 6: Continue with loop 6+ if any new valid blocking finding remains.**
- [ ] **Step 7: Verify review threads, reviews, required checks, exact head, then mark PR #164 ready and merge only if repository gates permit.**
- [ ] **Step 8: Read back new `main`; physical/human/player evidence remains explicitly NOT_RUN.**

### Task 8: Sequential protected-canon synchronization after PR #164

**Files:**
- Modify only as needed from latest merged `main`:
  - `기획서/00_프로젝트_허브/START_HERE.md`
  - `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
  - `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
  - `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md`
  - `기획서/00_프로젝트_허브/ROADMAP.md`
- Test: current-authority/canonical-freshness regression first.

**Interfaces:**
- Consumes: merged #164 main SHA and v4.8 authority.
- Produces: protected current-canon documents that no longer advertise v4.7 as the current work instruction.

- [ ] **Step 1: After #164 is merged, create one new branch from exact latest `main`; do not keep two writable current-task PRs open.**
- [ ] **Step 2: Add RED-first regression requiring the protected current owners to identify v4.8 as current while preserving historical v4.7 provenance.**
- [ ] **Step 3: Apply the smallest protected-canon edits; do not change gameplay/runtime, decisions, or physical/human evidence state.**
- [ ] **Step 4: Run Project Contract/relevant checks, adversarial review, safe merge, and post-merge readback.**

### Task 9: Final Notion system-record synchronization

**Surfaces:**
- Update: Notion system registry row `Switchy Express: Cargo Puzzle`.
- Re-read: `Switchy Express · Home`.

- [ ] **Step 1: Bind `Repo Main SHA` and synchronization notes to the final protected-canon merge SHA.**
- [ ] **Step 2: Preserve Human Home/System Record separation and Sheets migration-only policy.**
- [ ] **Step 3: Fetch destination readback and report remaining physical/device/human gates as NOT_RUN.**

## Self-Review

- Spec coverage: current-authority routing, domain split, Sheets migration-only, TDD, IRG/evidence ceiling, protected-path preservation, one-current-PR concurrency, Notion Human Home, five-loop review, exact-head/postmerge verification are mapped.
- Placeholder scan: no TBD/TODO/unspecified implementation step is used.
- Boundary consistency: all tasks preserve GMB-002 and SX-DEC-059 runtime; adapter/consumer changes and protected current-canon synchronization are intentionally separated instead of bypassing the project protection contract.
