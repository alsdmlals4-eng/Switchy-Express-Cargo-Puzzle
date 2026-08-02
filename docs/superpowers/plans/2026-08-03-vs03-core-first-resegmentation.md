# VS03 Core-First Resegmentation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Execute VS-03 in an order that proves the playable LIFO/route/survival core before investing in Profile/meta presentation, while preserving existing package ownership and current `VS03-02_ONLY` authority.

**Architecture:** Keep VS03-02 and VS03-03 unchanged, insert a small VS03-R1 corrective package, split the former VS03-05 into 05A playable core and 05B meta-dependent presentation, and move VS03-04 between them. Each package starts from synchronized main after the previous package merges; no shared-hotspot packages run in parallel.

**Tech Stack:** Existing Godot 4.7.1/GDScript project, GitHub PR package gates, custom headless runner, GitHub/Google Sheet same-evidence synchronization.

## Global Constraints

- Approval evidence: `EV-USER-018 · RECOMMENDED_OPTION_C`.
- Audit: `SX-AUD-007`.
- Current authority remains `VS03-02_ONLY` until VS03-02 merges.
- Existing approved product Decisions `SX-DEC-001~026` are unchanged.
- `F58` remains `NOT_MET` until target100 Production evidence.
- Product Scene/Android/human/online evidence remains `NOT_RUN` until executed.
- Every package requires behind 0, Project Contract success, Godot Tests success, review threads 0, REQUEST_CHANGES 0, exact file inventory, rollback, and explicit evidence ceiling.
- GitHub canonical merge precedes final correct-Sheet synchronization; a later GitHub closure commit requires Sheet resynchronization.

---

## Authoritative Package Order

```text
VS03-01 run lifecycle/economy/difficulty · DONE
→ VS03-02 compact token/TrainFootprint/DeliveryLoop occupancy · CURRENT
→ VS03-03 target3 maps/session/restart/selection
→ VS03-R1 difficulty authority alignment
→ VS03-05A minimal playable core surface
→ VS03-04 Profile/records/cosmetics/unlocks/rewards
→ VS03-05B result/collection/map browser
→ VS03-06 contextual onboarding
→ VS03-07 end-to-end integration/evidence handoff
```

The current-state owner is `기획서/50_제작_검증/VS03_PACKAGE_STATUS.md`. This plan owns the approved future order and supersedes conflicting order/status text in `2026-08-02-vs03-build-segmentation.md`; the older plan still owns unchanged detailed VS03-02, VS03-03, VS03-04, VS03-06, and VS03-07 requirements unless this plan explicitly overrides them.

## Package Responsibility Matrix

| Package | Must prove | Must not own |
|---|---|---|
| VS03-02 | token order/rear, compressed footprint, spawn occupancy seam | product token art, map/session, Profile |
| VS03-03 | three validated maps, exact reconstruction, fresh session, restart/selection | target100, Profile, Scene |
| VS03-R1 | every speed/fuel boundary forecast/commit under DifficultyDirector | UI, balance retune, map/Profile |
| VS03-05A | first playable board/train/token/switch/HUD/camera/input surface | Profile, result, records, collection, browser |
| VS03-04 | atomic Profile, records, rewards, cosmetics/unlocks | Scene authority, result/browser UI |
| VS03-05B | result insight, committed record/reward display, collection, map browser | direct Profile mutation, gameplay authority |
| VS03-06 | real-run contextual onboarding | tutorial-only map, assisted evidence contamination |
| VS03-07 | integrated local flow and evidence handoff | Android/human/online PASS without execution |

---

### Task 1: Finish VS03-02 Without Pulling Presentation Forward

**Files:** Existing VS03-02 ownership from `2026-08-02-vs03-build-segmentation.md`.

**Interfaces:**
- Produces `CompactWagonTokenState` and `TrainFootprint` APIs consumed by 05A.
- Produces optional `DeliveryLoop` occupancy-provider seam consumed by VS03-03 composition.

- [ ] Confirm current main includes PR #39 closure before creating the implementation branch.
- [ ] Follow existing VS03-02 RED→GREEN plan without creating Node2D/Control/Scene assets.
- [ ] Expose read-only `token_types()`, `rear_type()`, `token_count()`, `occupied_cells()`, and `token_positions()` APIs.
- [ ] Merge and synchronize before starting VS03-03.

### Task 2: Finish VS03-03 and Freeze the Session Consumer API

**Files:** Existing VS03-03 ownership plus its package audit.

**Interfaces:**
- Produces one `RunSessionFactory.create(selection_request) -> Dictionary` path.
- Produces the exact `RunSession` accessors listed in the 05A plan.

- [ ] Implement target3, reconstruction, fresh session, restart, and selection using the existing plan.
- [ ] Before merge, add a consumer-contract test that constructs a session and calls every accessor required by `2026-08-03-vs03-05a-minimal-playable-core-surface.md`.
- [ ] Reject duplicate/fallback maps; keep `F58 NOT_MET`.
- [ ] Merge and synchronize before VS03-R1.

### Task 3: Execute VS03-R1 as a Small Corrective Package

**Files:** Follow `docs/superpowers/plans/2026-08-03-vs03-r1-difficulty-authority-alignment.md` exactly.

**Interfaces:**
- Produces authoritative union pressure snapshots/events consumed by 05A.

- [ ] Complete all five R1 tasks.
- [ ] Preserve balance constants.
- [ ] Prove 30/45/60/90/large-delta boundary behavior.
- [ ] Merge and synchronize before creating the 05A branch.

### Task 4: Execute VS03-05A and Hold the Meta Gate

**Files:** Follow `docs/superpowers/plans/2026-08-03-vs03-05a-minimal-playable-core-surface.md` exactly.

**Interfaces:**
- Produces playable product surface and read-only snapshot/input interfaces.
- Does not produce Profile schema or transaction receipts.

- [ ] Complete 05A automated parity and smoke tests.
- [ ] Record `F89` mono-color strategy and `F92` token readability as evidence gaps, not as passed claims.
- [ ] Do not promote VS03-04 until 05A exact-head automated gate passes.
- [ ] If board/token/switch/HUD causality is not readable in representative captures, revise 05A before Profile work.

### Task 5: Execute VS03-04 Without Reopening 05A Presentation

**Files:** Existing VS03-04 ownership from the 2026-08-02 plan.

**Interfaces:**
- Consumes `RunSummary`, `MapDefinition/RunIdentity`, and no 05A Node authority.
- Produces immutable Profile transaction receipts consumed by 05B.

- [ ] Implement schema v1 and single-writer transaction service.
- [ ] Keep 05A scene functional when Profile is unavailable or save fails.
- [ ] Do not add result, collection, or browser panels in this package.
- [ ] Merge and synchronize before 05B.

### Task 6: Execute VS03-05B as Meta-Dependent Presentation

**Files:**

Create:

```text
game/result/result_insight.gd
game/result/result_insight_analyzer.gd
game/result/result_view_model.gd
game/ui/result_panel.gd
game/ui/result_panel.tscn
game/ui/collection_panel.gd
game/ui/collection_panel.tscn
game/map/map_browser_view_model.gd
game/ui/map_browser_panel.gd
game/ui/map_browser_panel.tscn
tests/result/**
tests/ui/test_result_panel.gd
tests/ui/test_collection_panel.gd
tests/map/test_map_browser_view_model.gd
tests/integration/test_result_profile_receipt_flow.gd
```

Modify narrowly:

```text
game/play/play_scene.gd
game/play/play_scene.tscn
tests/run_tests.gd
```

**Interfaces:**
- Consumes immutable `RunSummary`, Profile transaction receipt, cosmetic collection snapshot, and map-selection/discovery snapshots.
- Produces semantic `restart_requested`, `new_run_requested`, `map_selected`, and `cosmetic_selected` intents.

- [ ] Write RED tests for evidence-based cause/action and neutral fallback.
- [ ] Implement pure result analyzer with one cause and one action.
- [ ] Write RED tests proving panels cannot call `ProfileTransactionService.commit()`.
- [ ] Implement result/collection/browser ViewModels and panels.
- [ ] Connect intents through `PlayScene` to existing session/profile services.
- [ ] Prove only committed record/reward receipts are displayed.
- [ ] Run full regression and merge/synchronize.

### Task 7: Continue VS03-06 and VS03-07 Under the New Order

**Files:** Existing VS03-06/07 ownership.

- [ ] Start onboarding only after 05B merge so real presentation and Profile preference paths exist.
- [ ] Keep assisted first run excluded from standard records/rewards/balance evidence.
- [ ] Execute VS03-07 end-to-end flow across 05A, 04, and 05B boundaries.
- [ ] Hand Android, soak, localization, accessibility, economy simulation, capture, and 5+ human work to Issue #7 with `NOT_RUN` status until executed.

---

## Merge and Synchronization Protocol

For PR #39 and every future package:

```text
exact branch head
→ compare with latest main / behind 0
→ changed-file inventory
→ Project Contract PASS
→ Godot Tests PASS
→ review threads 0
→ REQUEST_CHANGES 0
→ expected-head merge
→ correct Sheet write/readback under same Evidence/Audit ID
→ closure PR when current-state consumers need final merge SHA
→ final Sheet resync/readback
```

Wrong Sheet ID beginning `19Ff...` remains excluded.

## Self-Review Result

- Approved option C appears exactly in the authoritative order.
- R1 and 05A have separate executable TDD plans.
- Existing 02/03/04/06/07 detail is reused rather than duplicated.
- 05B has explicit files, interfaces, and TDD sequence.
- Current authority remains VS03-02; future order does not falsely mark later work started.
