# Phase A Canonical Freshness Closure Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Remove the remaining active documentation and Google Sheet freshness contradictions while preserving all Switchy Express gameplay/runtime/product/validation boundaries.

**Architecture:** Treat `CURRENT_CONFIRMED_DECISIONS.md` and `ACTIVE_CONTEXT.md` as current-state owners and repair only stale consumers. Keep historical commit/APK/PR/CI evidence in place but label it historical when it is no longer the current execution authority. Synchronize only current Sheet surfaces; retain historical rows unchanged.

**Tech Stack:** GitHub Markdown, Google Sheets, GitHub pull requests/checks, existing project contract/GUT/Godot/Thin CI.

## Global Constraints

- Existing authority only: `SX-DEC-027~055`; no new Decision ID.
- Freshness repair authority: existing `SX-AUD-035`.
- Baseline project main: `a44891a903a384f8e1fb23e3eb9f53c241934119`.
- Project Base pin stays `v9.4.3`; upstream Base `315c66eea9614c284b9c11c4d522141065dfa4b0` is reference-only.
- `SX-DEC-055` Godot/GDScript/test implementation stays `NOT_STARTED · USER_DEFERRED_AFTER_DOR`.
- Windows physical runtime, Android device, connected physical editor, and broader human/comprehension stay `NOT_RUN`.
- No change to gameplay/domain rules, project.godot, GDScript, scenes, addons, workflows, product PNGs, semantic manifests, or asset provenance.
- Historical evidence is preserved; only its current-vs-history interpretation is repaired.

---

### Task 1: Repair Core Systems current-state boundary

**Files:**
- Modify: `기획서/20_시스템_콘텐츠/CORE_SYSTEMS.md`

**Interfaces:**
- Consumes: current state from `CURRENT_CONFIRMED_DECISIONS.md` and `ACTIVE_CONTEXT.md`.
- Produces: stable system canon that does not advertise a historical Android APK as the sole immediate project task.

- [ ] **Step 1.1: Preserve the product contract body**

Do not alter MapDefinition/TrackLayout, BUILD, LIFO, Combo, retry, score/campaign, or legacy classification sections.

- [ ] **Step 1.2: Reframe the implementation evidence block**

Replace the heading/body framing so the existing automated/APK values are explicitly a historical bounded evidence snapshot. Keep exact historical SHA/hash/package ID values unchanged.

- [ ] **Step 1.3: Replace the stale immediate-next-work statement**

Use current authority text equivalent to:

```text
CURRENT EXECUTION AUTHORITY: CURRENT_CONFIRMED_DECISIONS + ACTIVE_CONTEXT
SX-DEC-055: SPEC/DoR APPROVED · USER_DEFERRED_AFTER_DOR · IMPLEMENTATION_NOT_STARTED
WINDOWS PHYSICAL / ANDROID DEVICE / CONNECTED EDITOR / HUMAN: NOT_RUN
PRODUCTION CUTOVER: BLOCKED_DEFERRED
```

Do not call Android device smoke the immediate current task.

- [ ] **Step 1.4: Verify focused text**

Search the branch version and require:

```text
no active sentence: "다음 작업은 동일 APK 전체 hash를 확인하고"
contains: SX-DEC-055
contains: IMPLEMENTATION_NOT_STARTED
contains: ANDROID DEVICE
contains: NOT_RUN
```

- [ ] **Step 1.5: Commit through the GitHub branch**

Commit message:

```text
docs: separate core systems history from current execution
```

### Task 2: Repair Development Gates completed feature status

**Files:**
- Modify: `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md`

**Interfaces:**
- Consumes: SX-DEC-041/042/046 status from current decision registry.
- Produces: gate chain where implemented route-end/switch behavior is not repeated as pending work.

- [ ] **Step 2.1: Update PC chain summary**

Change PC4A from `PENDING` to a state that preserves the exact evidence ceiling:

```text
MERGED_MAIN_VERIFIED · AUTOMATED_PASS · USER_FEATURE_F5_PASS
```

Leave PC5, PC7, Android, and human gates open.

- [ ] **Step 2.2: Update PC4A details**

Record that SX-DEC-041/042/046 are implemented/merged and feature-scoped F5 evidence exists. Explicitly state that this does not close full local PC flow, Windows artifact runtime, Android, or human gates.

- [ ] **Step 2.3: Refresh Current Transition**

Use live-main semantics and remaining manual gates. Do not instruct implementation of PC4A again.

- [ ] **Step 2.4: Preserve Base history**

Keep Base v9.4.3 pin and PR #94 historical candidate text unchanged except where needed to prevent it from appearing as current adoption authority.

- [ ] **Step 2.5: Focused verification**

Require:

```text
no current PC4A status: PENDING
contains: SX-DEC-041
contains: SX-DEC-042
contains: NOT_RUN for Windows/Android/human boundaries
```

- [ ] **Step 2.6: Commit**

Commit message:

```text
docs: refresh completed gameplay gates
```

### Task 3: Repair Vertical Slice active handoff and PR status

**Files:**
- Modify: `기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md`

**Interfaces:**
- Consumes: current live-main/current-decision authority while retaining first-slice historical evidence.
- Produces: vertical-slice contract with no false current Draft/branch claim.

- [ ] **Step 3.1: Add current-state authority note near the top**

State that the file owns first vertical-slice contract/history but current execution state is resolved from `CURRENT_CONFIRMED_DECISIONS.md` and `ACTIVE_CONTEXT.md`.

- [ ] **Step 3.2: Classify old automated evidence as historical snapshot**

Keep old case/assertion/run data but label it historical/bounded rather than current exact-head evidence.

- [ ] **Step 3.3: Repair User Handoff Contract**

Set:

```yaml
branch: main
current_main_source: LIVE_GITHUB_DEFAULT_BRANCH
historical_minimum_verified_product_commit: 8807cdbdd670a0cb67948e97f922c9bd9700e1a7
```

Retain current manual/physical gate limits.

- [ ] **Step 3.4: Remove false PR #83 Draft gate**

Replace the current-Draft claim with historical merged status and generic future PR safety conditions. Do not claim a current PR exists.

- [ ] **Step 3.5: Refresh Current Conclusion**

Keep automated/package PASS and physical/device/human open statuses, and add SX-DEC-055 `IMPLEMENTATION_NOT_STARTED` as the current presentation/runtime boundary.

- [ ] **Step 3.6: Focused verification**

Require:

```text
absent: "PR #83은 현재 Draft"
absent active handoff branch: agent/pc-vertical-slice-demo-design
contains: branch: main
contains: LIVE_GITHUB_DEFAULT_BRANCH
contains: SX-DEC-055
contains: IMPLEMENTATION_NOT_STARTED
```

- [ ] **Step 3.7: Commit**

Commit message:

```text
docs: refresh vertical slice handoff authority
```

### Task 4: Synchronize current Google Sheet surfaces

**Files / ranges:**
- Modify: `05_GDD_요약` current rows only.
- Modify: `50_제작_검증` by adding a new current SX-DEC-055 row.
- Inspect only: `00_프로젝트_허브`, `01_작업순서`, `02_현재_확정결정`, `04_누락_충돌_감사`.

**Interfaces:**
- Consumes: GitHub branch design plus current Decision/Audit rows.
- Produces: Sheet current surfaces that route cold-start work to the same authority without rewriting history.

- [ ] **Step 4.1: Refresh GDD-CURRENT-01~06 operational metadata**

Preserve each product summary and owner path. Refresh stale main/status/next-check metadata only where the current row incorrectly points to the 2026-08-04 planning baseline.

- [ ] **Step 4.2: Add GDD-CURRENT-07**

Create one current module with:

```text
area: 시각 semantic asset + runtime POC boundary
decisions: SX-DEC-049~055
state: 73 product PNGs complete · SX-DEC-055 spec/DoR approved · runtime implementation NOT_STARTED
next: Phase A freshness closure → user planning-complete gate → Phase B final review → approved RED-first implementation
```

- [ ] **Step 4.3: Add a current production/validation row**

In `50_제작_검증`, add one current row for SX-DEC-055/SX-AUD-035 that preserves:

```text
implementation: NOT_STARTED · USER_DEFERRED_AFTER_DOR
runtime_integrated: false
Windows/Android/connected editor/human: NOT_RUN
production cutover: BLOCKED_DEFERRED
```

- [ ] **Step 4.4: Re-read all touched ranges**

Require that no historical row is overwritten and current rows point to the correct Sheet/Decision IDs.

### Task 5: Adversarial regression review and PR

**Files:**
- Inspect all branch changes against `a44891a903a384f8e1fb23e3eb9f53c241934119`.

**Interfaces:**
- Consumes: Tasks 1-4.
- Produces: bounded docs-only PR ready for exact-head CI.

- [ ] **Step 5.1: Compare branch to frozen main**

Require changed paths to be limited to:

```text
docs/superpowers/specs/2026-08-11-phase-a-canonical-freshness-closure-design.md
docs/superpowers/plans/2026-08-11-phase-a-canonical-freshness-closure.md
기획서/20_시스템_콘텐츠/CORE_SYSTEMS.md
기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md
기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md
```

Google Sheet changes are external synchronized evidence and do not appear in the git diff.

- [ ] **Step 5.2: Run adversarial content checks**

Attack for:

```text
reintroduced PR #83 Draft claim
PC4A still pending
Android smoke promoted to immediate work despite SX-DEC-055 boundary
runtime implementation accidentally promoted to PASS/STARTED
physical/device/human PASS inflation
Base repin
new gameplay/semantic rule
historical evidence deletion
```

- [ ] **Step 5.3: Open PR**

PR title:

```text
docs: close phase A canonical freshness drift
```

PR body must identify `SX-AUD-035`, user approval, no new Decision ID, docs-only git scope, Sheet synchronization, and validation ceilings.

- [ ] **Step 5.4: Verify PR exact head**

Read changed filenames, diff, combined/Actions checks actually emitted, and unresolved review threads. Do not infer PASS from old runs.

- [ ] **Step 5.5: Merge only after applicable required checks pass**

Use expected-head protection. If a required check fails or main moves, stop merge, inspect/reconcile, and re-run verification on the new exact head.

- [ ] **Step 5.6: Post-merge adversarial closure**

Re-read:

```text
new main HEAD
open project PRs
CURRENT_CONFIRMED_DECISIONS.md
ACTIVE_CONTEXT.md
CORE_SYSTEMS.md
DEVELOPMENT_GATES.md
VERTICAL_SLICE_CONTRACT.md
Sheet 00/01/02/04/05/50 current surfaces
```

Final decision must be one of `NO_CONFLICT`, `CONFLICT_FIXED`, `USER_DECISION_REQUIRED`, or `BLOCKED_UNVERIFIED`, with all remaining runtime/device/human ceilings stated explicitly.
