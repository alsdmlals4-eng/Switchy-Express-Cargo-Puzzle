# Switchy Express r5.4 Authority Reconciliation Implementation Plan

> **Historical / superseded for current-gate use:** This plan records the pre-SX-DEC-060 r5.4 reconciliation. Its Candidate 003 next-gate language applies only to those exact pre-change bytes; current execution follows `SX-DEC-060` and its post-change fail-closed candidate locator.

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Promote the user-provided v4.8 `2026-08-26-r5.4-superset-final` contract into Switchy Express active routing without changing GMB-002 gameplay, SX-DEC-027~059 product meaning, Candidate 003 identity, or physical/human evidence ceilings.

**Architecture:** Keep the repository thin-adapter model. Update only CURRENT_MUTABLE/CANONICAL_LOCATOR consumers and their contract tests; preserve r4 plans/audits/history as historical evidence. Notion receives only a bounded human-facing authority/status correction, not IA migration or duplicated runtime truth.

**Tech Stack:** Markdown, Python `unittest`, GitHub repository/PR checks, Notion destination readback.

**Spec:** `/mnt/data/PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8-r5.4_SUPERSET_FINAL_20260826.md` · SHA-256 `fdf238c202cfac6d3a824aae49b8ac525fba023e31bba7df6ece64a2790365a0`

## Global Constraints

- Current user contract: `2026-08-26-r5.4-superset-final`.
- Base execution policy remains `ALWAYS_REFETCH_CURRENT_COMPLETED_MAIN`.
- Google Sheets remains retired for normal work; do not restore it as an active workspace.
- Preserve GMB-002 and SX-DEC-027~059 product semantics.
- Preserve `SX59-POC-ACCEPT-003` and all current `NOT_RUN` physical/device/human/player evidence ceilings.
- Preserve SX-DEC-056A/056B/057/058 authorization boundaries.
- Do not modify `game/**`, Scene, Resource, product asset/audio, save/schema, or balance data.
- Existing Draft PR #174 remains read-only.
- Historical r2/r4 plans, audits, and provenance remain historical; do not mass-rewrite them.

---

### Task 1: RED — Change active authority contract expectations

**Files:**
- Modify: `tests/python/test_v48_current_authority_migration.py`
- Modify: `tests/python/test_v48_protected_canon_freshness.py`

**Interfaces:**
- Consumes: current thin adapter and active entry-point text.
- Produces: executable assertions for r5.4 identity, user-contract role, uploaded source SHA-256, dynamic Base policy, unchanged Candidate 003/evidence boundaries.

- [ ] **Step 1: Change the tests first** so current active owners must contain `2026-08-26-r5.4-superset-final`, `USER_PROVIDED_V4_8_R5_4_SUPERSET_FINAL_CONTRACT`, and source hash `fdf238c202cfac6d3a824aae49b8ac525fba023e31bba7df6ece64a2790365a0`, while r4 is no longer accepted as current authority.
- [ ] **Step 2: Run the two tests against the pre-GREEN file set.** Expected result: FAIL because the active adapter/entry surfaces still advertise r4.

### Task 2: GREEN — Update the thin adapter and active routing surfaces

**Files:**
- Modify: `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md`
- Modify: `AGENTS.md`
- Modify: `README.md`
- Modify: `기획서/00_프로젝트_허브/START_HERE.md`
- Modify: `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
- Modify: `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
- Modify: `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md`
- Modify: `기획서/00_프로젝트_허브/ROADMAP.md`

**Interfaces:**
- Consumes: user r5.4 contract, Base latest completed main routing, current project/product facts.
- Produces: one active r5.4 routing identity across all current entry surfaces while retaining historical r2/r4 evidence.

- [ ] **Step 1: Update the thin adapter** to r5.4 identity and source hash, explicitly record r4 as historical predecessor, and preserve project-specific GMB-002/Candidate 003/tooling/evidence boundaries.
- [ ] **Step 2: Update each CURRENT_MUTABLE/CANONICAL_LOCATOR entry surface** to route to r5.4 and state that r4 is historical predecessor evidence, without changing gameplay or acceptance status.
- [ ] **Step 3: Run the two focused authority tests.** Expected result: PASS.

### Task 3: Canonical-reference and regression verification

**Files:**
- Inspect: active search results for `2026-08-24-r4`, `USER_PROVIDED_V4_8_R4_CONTRACT`, and the prior current-authority literals.
- Preserve: historical plans/specs/audits that describe the 2026-08-25 r4 migration.

**Interfaces:**
- Consumes: Task 2 output.
- Produces: classified current-vs-history reference inventory and no accidental product/evidence widening.

- [ ] **Step 1: Search the branch for old r4 literals.** Classify each as `must-update`, `history-only`, or `compatibility/provenance`.
- [ ] **Step 2: Run relevant repository Python contract/freshness tests available through CI and inspect exact-head status.**
- [ ] **Step 3: Verify the diff contains no `game/**`, product assets/audio, save/schema, map, or 056~058 implementation changes.

### Task 4: Notion bounded correction

**Files / destination:**
- Update: `Switchy Express · Home` only where current work-instruction identity/status is human-facing.
- Readback: `Switchy Express · Home`, `01 · Direction · Planning`, `04 · Production · Validation` as needed to confirm semantic alignment.

**Interfaces:**
- Consumes: merged/current repository authority meaning.
- Produces: human-facing r5.4 current-contract locator with unchanged Candidate 003 next gate and evidence ceiling.

- [ ] **Step 1: Apply a bounded text correction; do not reparent/remigrate the existing Notion IA.**
- [ ] **Step 2: Fetch the exact destination and confirm r5.4 authority plus Candidate 003 physical visual recheck remains the next product gate.

### Task 5: Review, PR, merge, post-merge readback

**Files:** all Task 1–4 changes/evidence.

**Interfaces:**
- Produces: clean current-task PR and new-main authority state.

- [ ] **Step 1: Run minimum five full adversarial review loops on the complete candidate state, including authority drift, untouched consumers, history preservation, product/evidence non-widening, and better-alternative search.**
- [ ] **Step 2: Open one current-task PR from `docs/r54-authority-reconcile-20260826`; do not alter Draft PR #174.**
- [ ] **Step 3: Verify exact PR head, required checks, review/thread/ruleset state, then squash/merge if all gates permit.**
- [ ] **Step 4: Read back new `main` and Notion destination. Recalculate remaining work; expected next product gate remains Candidate 003 Gate 0 physical visual recheck.**
