# Post-Merge Canon Recovery Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Restore post-merge canonical freshness, align the Base adapter with the finite product authority, and prevent stale PR/branch guidance from returning.

**Architecture:** Keep product code and gameplay rules unchanged. Repair only active documentation, adapter metadata, regression contracts, and the user-facing Google Sheet. Preserve Base v9.4.3 as the adopted release pin while treating newer Base main changes as reviewed but not automatically adopted.

**Tech Stack:** Markdown, JSON, Python contract tests, GitHub Actions, Google Sheets.

## Global Constraints

- Repository: `alsdmlals4-eng/Switchy-Express-Cargo-Puzzle`
- Base release pin: `v9.4.3`
- Current product authority: `GMB-002 · SX-DEC-027~039`
- Correct Sheet: `1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo`
- Wrong `19Ff...` Sheet: `DO_NOT_MODIFY`
- Product code, Scenes, assets, game rules, Android APK evidence, and balance values remain unchanged.
- Automated PASS must not be expanded to unverified later commits or manual runtime gates.

---

### Task 1: Add a freshness regression contract

**Files:**
- Create: `tests/test_post_merge_canon_freshness.py`

**Interfaces:**
- Consumes: active canonical documents and `skills/PROJECT_BASE_ADAPTER.json`
- Produces: a pytest contract that fails on stale PR #83 Draft state, stale feature-branch execution guidance, legacy product authority, or unbounded Base candidate adoption

- [ ] Write assertions that reject `agent/pc-vertical-slice-demo-design`, `PR #83: DRAFT`, `MAIN_PENDING`, and legacy endless/fuel/BOOST as current protection.
- [ ] Assert `main`, `PR #83 MERGED`, `SX-AUD-025`, finite authority, separate repository/verified SHAs, and Base v9.4.3 pin.
- [ ] Run the focused test and confirm RED against the pre-repair branch.
- [ ] Repair documents and adapter.
- [ ] Run the focused test and confirm GREEN.

### Task 2: Repair active canonical documents

**Files:**
- Modify: `README.md`
- Modify: `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
- Modify: `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md`
- Create: `기획서/50_제작_검증/SX_AUD_025_POST_MERGE_CANON_FRESHNESS_AND_GATE_RECOVERY.md`

**Interfaces:**
- Consumes: merged PR #83 metadata, verified product commit `1339a946...`, observed main `212d37e...`
- Produces: a single main-branch execution path and truthful manual-gate boundary

- [ ] Replace obsolete feature-branch instructions with `main`.
- [ ] Record PR #83 as merged and remove merge-review blocking language.
- [ ] Separate observed repository HEAD from latest automated verified product HEAD.
- [ ] Preserve local F5, Windows runtime, Android, human, and production gates as open where evidence is absent.
- [ ] Add `SX-AUD-025` with findings, corrections, and non-claims.

### Task 3: Align Base adapter protection

**Files:**
- Modify: `docs/BASE_RULES_VERSION.md`
- Modify: `skills/PROJECT_BASE_ADAPTER.json`

**Interfaces:**
- Consumes: Base v9.4.3 immutable release pin and current finite product authority
- Produces: adapter metadata that protects GMB-002/SX-DEC-027~039 without promoting current Base main or PR #94 candidate SHA

- [ ] Keep the Base v9.4.3 release SHA and lock unchanged.
- [ ] Add current product authority and historical-not-current boundaries.
- [ ] Refresh Sheet and protected-baseline metadata.
- [ ] Preserve the Base adoption sentinel fields as `NOT_RUN`; record this recovery in separate freshness and pending-branch metadata.
- [ ] Add the freshness test to validators.

### Task 4: Synchronize Sheet and handle PR #94

**Files:**
- Update Sheet tabs: `00_프로젝트_허브`, `01_작업순서`, `02_현재_확정결정`, `04_누락_충돌_감사`, `50_제작_검증`

**Interfaces:**
- Consumes: Draft PR number and branch head
- Produces: same-ID `SX-AUD-025` pre-merge synchronization and an archived stale Pilot PR

- [ ] Update stale PR #83 and feature-branch cells.
- [ ] Add `SX-AUD-025` rows with `APPROVED_PENDING_MERGE`.
- [ ] Re-read changed ranges.
- [ ] Comment on and close PR #94 as superseded by the current Base authority review.
- [ ] Open a Draft PR for this recovery branch.

### Task 5: Verification

- [ ] Run focused freshness test.
- [ ] Run Project Contract.
- [ ] Run Godot regression.
- [ ] Inspect PR changed files and unresolved review threads.
- [ ] Report manual gates without expanding PASS claims.
