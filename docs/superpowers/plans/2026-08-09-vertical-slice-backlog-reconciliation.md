# Vertical Slice Backlog Reconciliation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reconcile stale Vertical Slice GitHub issues with the current canonical project state without changing gameplay, runtime, assets, or deferred validation gates.

**Architecture:** Treat GitHub main plus the configured project Google Sheet as current authority. Preserve historical issue bodies/comments, record one audit file, close only the issue whose staged implementation sequence is superseded, and keep the epic/quality-gate issues open with current-authority notes.

**Tech Stack:** GitHub Issues/PRs, Markdown authority docs, Google Sheets authority sync.

## Global Constraints

- Baseline project main: `c8eb8c47d620a7a7aa478e0559ec3d70bd8f6858`.
- Base main: `2a6ced23f6d6de1fb6e0a281c7138beb03f1a13b`.
- `.asset-vault` untrack remains `DEFER_LOCAL` until local hash-verified preservation attestation exists.
- Do not change gameplay code, `project.godot`, Scene/Resource/Theme/Animation/signal authoring, candidate asset bytes, or runtime/POC state.
- Preserve #7 quality gates: soak, Android/device, accessibility/touch, representative runtime evidence, human playtest, and PASS/REVISE/PIVOT/STOP review.
- Preserve historical issue content; use comments for current authority and close #6 only as superseded/not-planned.

---

### Task 1: Record backlog reconciliation audit

**Files:**
- Create: `기획서/50_제작_검증/SX_AUD_038_VERTICAL_SLICE_BACKLOG_RECONCILIATION.md`

**Interfaces:**
- Consumes: current main, Issues #3/#6/#7, SX-DEC-050~052 state.
- Produces: an auditable classification for each stale issue.

- [ ] **Step 1: Write the audit file** with exact baseline SHA, current issue states, classification rationale, preserved gates, and explicit non-goals.
- [ ] **Step 2: Self-review** that #6 is the only issue marked superseded, while #3/#7 remain open.
- [ ] **Step 3: Commit** the audit on the isolated branch.

### Task 2: Verify the docs-only branch

**Files:**
- Verify only the plan and audit files changed relative to main.

**Interfaces:**
- Consumes: Task 1 branch head.
- Produces: exact-head automated evidence suitable for merge.

- [ ] **Step 1: Open a draft PR** against `main`.
- [ ] **Step 2: Run/observe Project Contract, GUT, Godot Tests, and Thin Adapter checks** on the exact PR test-merge head.
- [ ] **Step 3: Verify zero review threads/comments/request-changes and no main drift.**
- [ ] **Step 4: Mark Ready and squash-merge with expected-head protection.**
- [ ] **Step 5: Read back merged `main`.**

### Task 3: Apply issue-state reconciliation

**Files:**
- GitHub Issue #3 comment only.
- GitHub Issue #6 comment + close as `not_planned` (superseded).
- GitHub Issue #7 comment only.

**Interfaces:**
- Consumes: merged SX-AUD-038 and current canonical main.
- Produces: backlog states that no longer contradict current authority.

- [ ] **Step 1: Add a current-authority checkpoint to #3** pointing to SX-DEC-050~052/SX-AUD-038, while keeping the epic open.
- [ ] **Step 2: Add a supersession note to #6** explaining that its staged `VS03-03` sequence is no longer current authority.
- [ ] **Step 3: Close #6 as `not_planned`** rather than completed.
- [ ] **Step 4: Add a carry-forward note to #7** removing #6 as an active prerequisite and retaining only still-valid quality gates.
- [ ] **Step 5: Re-read all open issues and confirm the expected open set is #3 and #7 only.**

### Task 4: Synchronize the Google Sheet

**Files:**
- `00_프로젝트_허브`
- `04_누락_충돌_감사`
- `50_제작_검증`

**Interfaces:**
- Consumes: merged main and post-reconciliation issue states.
- Produces: Sheet/GitHub authority parity.

- [ ] **Step 1: Append `SX-AUD-038` to the next empty audit row.**
- [ ] **Step 2: Append the next `CURRENT-*` row recording backlog reconciliation.**
- [ ] **Step 3: Update Hub next-action/blocker text without claiming runtime/POC or vault cleanup.**
- [ ] **Step 4: Read back all written ranges and compare main SHA, issue states, and deferred gates.**
