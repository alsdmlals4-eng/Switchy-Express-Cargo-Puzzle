# Route End and Direct Switch Gameplay TDD Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement approved `SX-DEC-041` route-end failure ordering and `SX-DEC-042` three-direction direct switch selection/U-turn without changing Scene, Resource, Theme, signals, or project settings.

**Architecture:** `TrainController` exposes safe movement availability; `FiniteRunController` owns ordered terminal outcome and failure reason. `FiniteTrackSwitch` owns all three selectable reciprocal ports, `FiniteTrackGraph` exposes stable route-control state, and `RouteControlOverlay` computes procedural arrow targets and emits selection intent while `ProductFiniteSlice` dispatches through the existing controller command boundary. GUT 9.7.1 is the formal new RED/GREEN authority; the existing custom runner remains a full-regression safety net.

**Tech Stack:** Godot 4.7.1, typed GDScript, GUT 9.7.1, existing custom TestCase runner, GitHub Actions standard hosted runners.

## Global Constraints

- Decision authority: `SX-DEC-041`, `SX-DEC-042`, approved under `GMB-003`.
- Baseline main: `23981d0bb3d65487951be2cbbc5ee365da624e1e`.
- GUT authority: `SX-DEC-044`; new gameplay requirements must have failing GUT evidence before production implementation.
- Last required delivery `SUCCESS` has priority over same-cell `ROUTE_END`.
- Non-final unload at a route end finishes unloading before `ROUTE_END`.
- `TIME_EXPIRED` and `ROUTE_END` remain distinct failure reasons.
- SWITCH exposes all three reciprocal directions; selecting the incoming direction performs a U-turn.
- Occupied route controls reject selection changes.
- CROSSING keeps existing `STRAIGHT/RIGHT/LEFT` behavior.
- Overlay is presentation/input intent only; graph remains route authority.
- No `.tscn`, `.tres`, `.res`, binary asset, signal wiring, autoload, InputMap, or `project.godot` edits.
- No physical Windows, Android, human, or connected-HiGodot PASS is inferred from CI.

---

### Task 1: Route-end terminal ordering

**Files:**
- Modify: `tests/gut/unit/test_finite_run_outcome_ordering.gd`
- Modify: `tests/finite/run/test_finite_run_controller.gd`
- Modify: `game/train/train_controller.gd`
- Modify: `game/finite/run/finite_run_controller.gd`
- Modify: `game/finite/run/finite_run_summary.gd`
- Modify: `game/finite/presentation/finite_slice_presenter.gd`
- Modify: `game/demo/presentation/product_hud.gd`

**Interfaces:**
- Produces: `TrainController.can_advance() -> bool`
- Produces: `FiniteRunSummary.failure_reason: StringName`
- Failure reasons: `TIME_EXPIRED`, `ROUTE_END`

- [ ] **Step 1: Write GUT RED cases** for no-event dead-end, non-final unload-at-dead-end, final-delivery-at-dead-end priority, and timeout reason.
- [ ] **Step 2: Run hosted `GUT 9.7.1 Tests` and confirm RED** due to missing `can_advance`/`failure_reason` or current reverse/dead-end assertion.
- [ ] **Step 3: Implement safe train movement**: `can_advance()` returns true only when target differs from current and remains a reciprocal neighbor; `_commit_next_cell()` returns current without emission when false; remove only the unconditional immediate-reverse prohibition so a graph-authorized U-turn can execute.
- [ ] **Step 4: Implement ordered route-end resolution**: after `cell_entered` contact handling, fail immediately only when still RUNNING and `can_advance()==false`; after non-final unload, check route-end before resuming; pending final outcome resolves first.
- [ ] **Step 5: Add immutable failure reason** to `FiniteRunSummary`; all timer branches use `TIME_EXPIRED`, route exhaustion uses `ROUTE_END`, success uses empty reason.
- [ ] **Step 6: Map player-facing result copy** in presenter/HUD without changing nodes or Scene structure.
- [ ] **Step 7: Extend legacy custom runner assertions** and run GUT + full Godot GREEN.

### Task 2: Three-direction switch selection and U-turn

**Files:**
- Modify: `tests/gut/unit/test_finite_switch_reciprocity.gd`
- Modify: `tests/finite/rail/test_interactive_route_controls.gd`
- Modify: `game/finite/rail/finite_track_switch.gd`
- Modify: `game/finite/rail/finite_track_graph.gd`
- Modify: `game/finite/build/preflight_validator.gd`
- Modify: `game/train/train_controller.gd`

**Interfaces:**
- Produces: `FiniteTrackSwitch.connected_ports() -> Array[Vector2i]`
- Produces: `FiniteTrackSwitch.select_exit(port: Vector2i) -> bool`
- Produces: `FiniteTrackGraph.select_switch_exit(cell: Vector2i, port: Vector2i) -> bool`
- Extends: switch route-control descriptor with `available_exits`.

- [ ] **Step 1: Write GUT RED cases** asserting stable three-port cycle, direct selection, invalid-port rejection, and incoming-port U-turn.
- [ ] **Step 2: Add legacy graph RED cases** asserting `available_exits`, occupied-lock rejection, and graph U-turn.
- [ ] **Step 3: Run hosted RED** and record missing APIs/current two-exit behavior.
- [ ] **Step 4: Implement switch domain** with stable cardinal-order connected ports, direct selection, and three-port cycle.
- [ ] **Step 5: Implement graph selection** with existing lock authority and include `available_exits` in snapshot state.
- [ ] **Step 6: Align preflight structural search** so SWITCH may transition through any reciprocal connected port, including incoming; do not alter CROSSING behavior.
- [ ] **Step 7: Run GUT + legacy GREEN.**

### Task 3: Procedural direct-selection arrows

**Files:**
- Create: `tests/gut/integration/test_route_control_overlay_selection.gd`
- Modify: `game/demo/presentation/route_control_overlay.gd`
- Modify: `game/demo/product_finite_slice.gd`

**Interfaces:**
- Produces: signal `route_cycles_requested(cell: Vector2i, cycle_count: int)`
- Consumes: `route_controls[].available_exits`, `selected_exit`, `locked`, snapshot `phase`.

- [ ] **Step 1: Write GUT RED cases** for three direction targets, selected state, target size >= 44 px when the board cell permits it, cycle distance, lock rejection, and BUILD/PAUSED/result input rejection.
- [ ] **Step 2: Run hosted RED** and record missing interaction contract.
- [ ] **Step 3: Implement deterministic target descriptors** derived from snapshot + Control size; draw every SWITCH direction procedurally and distinguish selected state by fill/weight in addition to color.
- [ ] **Step 4: Implement pointer handling** only for RUNNING/UNLOADING, emit cycle count to reach the clicked port, and keep `mouse_filter=IGNORE` outside active phases.
- [ ] **Step 5: Connect `ProductFiniteSlice`** to dispatch existing `BOARD_CELL` command exactly `cycle_count` times; overlay never mutates graph directly.
- [ ] **Step 6: Run GUT + legacy full regression GREEN.**

### Task 4: Canon, Sheet, and exact-head delivery

**Files:**
- Modify only existing decision/audit docs needed to record implementation evidence.
- Update Sheet rows for the same IDs `SX-DEC-041` and `SX-DEC-042`.

- [ ] **Step 1: Record exact RED and GREEN commit/run evidence**, including characterization results that were already green.
- [ ] **Step 2: Open/maintain a draft PR from `feat/route-end-switch-direct-selection` to `main` and keep ordinary commits so hosted Actions run.**
- [ ] **Step 3: Require exact-head PASS** for `GUT 9.7.1 Tests`, `Godot Tests`, `Project Contract`, and `Validate Thin Adapter Migration`, plus any additional triggered repository checks.
- [ ] **Step 4: Adversarially review changed files, diff, reviews, threads, generated artifacts, and evidence ceiling.**
- [ ] **Step 5: Sync Sheet pre-merge with the same Decision IDs; merge only the reviewed expected HEAD; then re-read `main` and sync the merged SHA.**
- [ ] **Step 6: Leave local F5 arrow readability, physical Windows runtime, Android device, connected HiGodot, and human comprehension as `NOT_RUN/RETEST_REQUIRED` until separately evidenced.**
