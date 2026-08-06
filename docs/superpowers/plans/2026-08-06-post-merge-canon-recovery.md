# Post-Merge Canon Recovery Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Restore post-merge canonical freshness, preserve fail-closed Base protection, and prevent stale PR/branch guidance from returning.

**Architecture:** Keep product code and gameplay rules unchanged. PR #99 repairs active canon and user-facing Sheet state only. Because the trusted Base validator rejects Adapter changes combined with protected `기획서/**` changes, Adapter freshness is a separate follow-up after PR #99 merges.

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

- [x] Reject obsolete feature-branch guidance, PR #83 Draft state, and `MAIN_PENDING`.
- [x] Require main, PR #83 MERGED, `SX-AUD-025`, and separate observed/verified SHAs.
- [x] Preserve Base v9.4.3 pin and reject the superseded PR #94 candidate SHA.
- [ ] Confirm focused contract GREEN on the final PR #99 head.

### Task 2: Repair active canonical documents

**Files:**
- Modify: `README.md`
- Modify: `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
- Modify: `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md`
- Create: `기획서/50_제작_검증/SX_AUD_025_POST_MERGE_CANON_FRESHNESS_AND_GATE_RECOVERY.md`

- [x] Replace obsolete feature-branch instructions with `main`.
- [x] Record PR #83 as merged and remove merge-review blocking language.
- [x] Separate repository HEAD from latest automated verified product HEAD.
- [x] Preserve local F5, Windows runtime, Android, human, and production gates as open.
- [x] Restore exact Android canonical freshness status tokens consumed by existing tests.

### Task 3: Repair the human-readable Base protection boundary

**Files:**
- Modify: `docs/BASE_RULES_VERSION.md`

- [x] Keep Base v9.4.3 release SHA and lock unchanged.
- [x] Identify `GMB-002 · SX-DEC-027~039` as current finite product protection.
- [x] Classify endless/fuel/BOOST/capacity 8/respawn/auto-reset as historical, not current.
- [x] Avoid promoting current Base main or the PR #94 candidate as a release.

### Task 4: Preserve Adapter fail-closed separation

**Files:**
- Revert in PR #99: `skills/PROJECT_BASE_ADAPTER.json`
- Follow-up after merge: adapter-only branch and PR

- [x] Diagnose exact-PR-base failure as a protected-path boundary, not a schema workaround target.
- [x] Restore the Adapter to the PR-base version in PR #99.
- [ ] After PR #99 merges, create an adapter-only PR from merged main.
- [ ] Update protected baseline and allowed freshness metadata without modifying protected files.
- [ ] Run trusted Base validator against the exact follow-up PR base.

### Task 5: Synchronize Sheet and handle PR #94

- [x] Update stale PR #83 and feature-branch cells.
- [x] Add `SX-AUD-025` rows with `APPROVED_PENDING_MERGE`.
- [x] Re-read changed ranges.
- [x] Comment on and close PR #94 as superseded.
- [x] Open Draft PR #99 for canon recovery.

### Task 6: Verification

- [ ] Focused freshness test PASS.
- [ ] Project Contract PASS.
- [ ] Godot regression PASS.
- [ ] PR changed-file and unresolved-thread inspection PASS.
- [ ] Merge PR #99 with exact HEAD only after all automated checks pass.
- [ ] Complete post-merge Sheet closure.
- [ ] Start adapter-only follow-up PR.
