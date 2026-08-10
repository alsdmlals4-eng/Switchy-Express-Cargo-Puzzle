# v4.5 r2 Work-Instruction Canon Replacement Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the user-supplied v4.5 r2 instruction payload the single discoverable GitHub project work-instruction canon and reconcile current routers/Sheet without changing product/runtime authority or granting BUILD.

**Architecture:** Store one root-level versioned canonical instruction file verbatim. Current high-authority routers reference that file instead of duplicating its body. A new non-product audit `SX-AUD-045` tracks source identity, freshness repair, exact-head PR evidence, post-merge readback, and the accidental main noop recovery.

**Tech Stack:** GitHub Markdown/JSON, Google Sheets current routing surfaces, GitHub Actions exact-head validation.

## Global Constraints

- Source payload: `/mnt/data/PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.5_r2.md`.
- Source SHA-256: `3f898b7e2749a2e1900e9df48183f02d4fbc735fd0e80297f28bb09317144de4`.
- Source bytes: `77734`; lines: `2850`; revision: `2026-08-11-r2`.
- Canonical GitHub path: `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.5_r2.md`.
- Do not create an unversioned duplicate body.
- No new product Decision ID; use `SX-AUD-045` for operational/canonical replacement evidence.
- Preserve `SX-DEC-027~055` semantics, especially `SX-DEC-055 IMPLEMENTATION_NOT_STARTED` and `runtime_integrated=false`.
- User `기획 완료` gate remains `NOT_GRANTED`; Phase B remains `NOT_RUN`; BUILD remains `BLOCKED`.
- No `.gd`, `.tscn`, `project.godot`, test, workflow, addon, asset, manifest, or binary mutation.
- Base project pin remains `v9.4.3`; Base current main remains reference-only.
- All current/open PR and Sheet facts must be re-read before merge.
- Merge only after exact-head applicable CI success and zero unresolved review blockers.

---

### Task 1: Establish the verbatim r2 GitHub canon

**Files:**
- Create: `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.5_r2.md`

**Interfaces:**
- Consumes: attached r2 UTF-8 payload.
- Produces: one current GitHub instruction body for router references.

- [ ] **Step 1:** Create the root canonical file with the exact attached UTF-8 content.
- [ ] **Step 2:** Fetch the branch file and verify `revision: '2026-08-11-r2'`, expected byte/line identity, and source SHA-equivalent content.
- [ ] **Step 3:** Confirm no older tracked `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION*` file exists that requires delete/rename migration.

### Task 2: Route current project authority to r2

**Files:**
- Modify: `AGENTS.md`
- Modify: `기획서/00_프로젝트_허브/START_HERE.md`
- Modify: `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
- Modify: `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
- Modify: `기획서/50_제작_검증/PHASE_A_PLANNING_COMPLETION_GATE.md`
- Modify: `기획서/00_프로젝트_허브/DESIGN_DOCUMENT_REGISTRY.json`

**Interfaces:**
- Consumes: Task 1 canonical path/revision.
- Produces: cold-start/current-owner discovery of the exact r2 execution contract.

- [ ] **Step 1:** Add an `AGENTS.md` work-instruction-canon section stating r2 is the current project execution Thin Adapter, below user/system/AGENTS safety authority and not a product-rule owner.
- [ ] **Step 2:** Reconcile `START_HERE.md` from its stale pre-139 handoff snapshot to current Phase A READY state and put the r2 canon in the must-read sequence.
- [ ] **Step 3:** Add `work_instruction_canon`, revision, and source provenance to `ACTIVE_CONTEXT.md`; preserve user gate/Phase B/BUILD boundaries.
- [ ] **Step 4:** Add current work-instruction metadata to `CURRENT_CONFIRMED_DECISIONS.md` without changing the product Decision table.
- [ ] **Step 5:** Change Phase A gate wording from generic v4.5 to the exact r2 canonical path/revision while keeping PA-14 `NOT_GRANTED`.
- [ ] **Step 6:** Register the canonical instruction and `SX-AUD-045` audit owner in `DESIGN_DOCUMENT_REGISTRY.json`.

### Task 3: Record replacement/audit provenance

**Files:**
- Create: `기획서/50_제작_검증/SX_AUD_045_V4_5_R2_WORK_INSTRUCTION_CANON.md`

**Interfaces:**
- Consumes: source hash, current Base/project/Sheet observations, accidental-noop recovery evidence.
- Produces: reviewable non-product audit for the canon replacement.

- [ ] **Step 1:** Record audit-start project main `e2e075ffb41ff1f60e22ac369ddc5e8275d98dd6`, Base main `315c66eea9614c284b9c11c4d522141065dfa4b0`, project/Base open PR counts, and Sheet state.
- [ ] **Step 2:** Record source payload identity and selected root canonical path.
- [ ] **Step 3:** Record that earlier chat/upload instruction revisions become historical external evidence after merge and no tracked predecessor existed.
- [ ] **Step 4:** Record accidental `__noop__` create/delete commits and comparison `files: []` as `NET_TREE_DELTA_ZERO`.
- [ ] **Step 5:** Keep PR/CI/merge fields `NOT_RUN` until actual evidence exists.

### Task 4: Synchronize Sheet pre-PR state

**Files/Data:**
- Modify Sheet: `00_프로젝트_허브`
- Modify Sheet: `01_작업순서`
- Modify Sheet: `04_누락_충돌_감사`

**Interfaces:**
- Consumes: same `SX-AUD-045` operational audit.
- Produces: Sheet current routing consistent with GitHub branch state.

- [ ] **Step 1:** Update Hub to show r2 canon replacement in progress while retaining Phase A READY/no-build boundaries.
- [ ] **Step 2:** Add `CURRENT-13 · SX-AUD-045 v4.5 r2 Work Instruction Canon Replacement` before historical work rows.
- [ ] **Step 3:** Add `SX-AUD-045` audit row with source SHA, branch, baseline main, `PR/CI NOT_RUN`, product conflict none, and no-build ceiling.
- [ ] **Step 4:** Reread all touched ranges.

### Task 5: Pre-PR adversarial and consumer review

**Files:** all branch changes.

- [ ] **Step 1:** Compare branch against baseline and prove changed paths are docs/canon only.
- [ ] **Step 2:** Search current owners for stale direct `resume → Task 1 RED` routing and stale generic/pre-r2 instruction authority.
- [ ] **Step 3:** Confirm stable compatibility anchors required by existing project contract tests are preserved.
- [ ] **Step 4:** Confirm instruction source body is not duplicated outside the canonical file.
- [ ] **Step 5:** Confirm no product Decision, gameplay/domain rule, Base pin, runtime, asset, or validation PASS is widened.

### Task 6: PR exact-head validation and merge

- [ ] **Step 1:** Re-read project main/open PRs and Base main/open PRs.
- [ ] **Step 2:** Create a ready PR with source hash, scope, no-build boundary, accidental-noop disclosure, and Sheet pre-PR state.
- [ ] **Step 3:** List changed filenames and review threads.
- [ ] **Step 4:** Inspect all workflows actually emitted for the exact PR head; do not count skipped/non-triggered checks as PASS.
- [ ] **Step 5:** If a check fails, use systematic debugging and make the minimum compatible correction without weakening tests/workflows.
- [ ] **Step 6:** Re-read unchanged exact head, current main freshness, mergeability, reviews/threads.
- [ ] **Step 7:** Squash merge using `expected_head_sha` only after all gates pass.

### Task 7: Post-merge canon/Sheet closure

- [ ] **Step 1:** Read new default-branch main and open PR inventory.
- [ ] **Step 2:** Fetch the canonical r2 file from new main and verify revision/source identity.
- [ ] **Step 3:** Reread `AGENTS`, `START_HERE`, `ACTIVE_CONTEXT`, `CURRENT_CONFIRMED_DECISIONS`, `PHASE_A_PLANNING_COMPLETION_GATE`, Registry, and `SX-AUD-045`.
- [ ] **Step 4:** Update Sheet Hub/CURRENT-13/SX-AUD-045 with exact-head CI and merge SHA.
- [ ] **Step 5:** Final readback must report `READY_FOR_USER_PLANNING_COMPLETE_GATE`, user gate `NOT_GRANTED`, Phase B `NOT_RUN`, BUILD `BLOCKED`, runtime/device/human `NOT_RUN`.

## Self-Review

- Spec coverage: all source identity, routing, Sheet, audit, PR, and post-merge requirements are assigned.
- Placeholder scan: runtime evidence fields intentionally use explicit `NOT_RUN/UNASSIGNED`, not TBD/TODO.
- Scope: one operational/canonical replacement package; no independent product subsystem is included.
- Type/interface consistency: canonical path, audit ID, revision, source SHA, and build-gate states are identical across tasks.
