# Switchy Express Vertical Slice Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a playable Godot 4.7.1 Android-landscape Vertical Slice that proves connected rail routing, multi-state switches, selective cargo loading, LIFO unloading, fuel survival, cargo slowdown, boost risk, score competition, readable product UI, persistence, and actual play evidence.

**Architecture:** Represent the 15×10 rail board as a deterministic graph. `RailGraph` owns connectivity and switch states; `TrainController` advances along graph edges without physics; `CargoStack` owns LIFO data; `DeliveryLoop` owns pickup/unload integration; pure run services compute speed, fuel, scoring, and game-over. Rendering, motion, audio, haptics, result panels, and persistence consume domain state without owning gameplay outcomes.

**Tech Stack:** Godot 4.7.1-stable, GDScript, built-in Resource/Node/Control APIs, custom headless test runner, Android landscape export.

## Global Constraints

- Grid is exactly 15×10 for the Vertical Slice.
- Every rail cell belongs to one connected graph; no degree-1 endpoint.
- At least four 2-state and two 3-state switches.
- Straight travel is default route A when a straight exit exists.
- Route preview first cell and actual next cell must match.
- Red, blue, and yellow each have exactly two stations and at least four map cargo pickups.
- Unloading is LIFO; only the consecutive top group matching the station unloads.
- Cargo slows the train; fuel drain is time-based and does not fall with speed.
- Boost increases speed and multiplies fuel drain; LOAD and BOOST cannot be active together.
- No branch slow motion.
- Color is paired with shape: red/star, blue/diamond, yellow/triangle.
- UI animation and completion signals never own score, fuel, cargo, routing, game-over, or save outcomes.
- Detailed balance values are `TEST_VALUE` until playtest evidence.
- Android, visual, performance, accessibility, and human gates remain `NOT_RUN` until executed.
- Total planning and required Grill Me Decisions must close before Codex Build.

---

## Current Status

| Area | Status | Evidence |
|---|---|---|
| Task 1 · Godot project/test harness | COMPLETE | PR #9 |
| Task 2 · deterministic RailGraph | COMPLETE | seeds 1~100 PASS |
| Task 3 · multi-state RailSwitch | COMPLETE | preview parity·straight-first PASS |
| Task 4 · train movement/wagons | COMPLETE | PR #12 |
| Task 5 · cargo/station/LIFO/runtime recovery | COMPLETE | PR #12·#13 |
| Post-VS02 canonical recovery | IN_PROGRESS | `SX-AUD-003` |
| Total planning and Grill Me | IN_PROGRESS | `G3P` |
| Task 6 · run economy | BLOCKED_BY_PLANNING | Issue #6 / VS-03A |
| Task 7 · product UI/result/save | BLOCKED_BY_PLANNING | Issue #6 / VS-03B |
| Task 8 · telemetry/soak/device/playtest | NOT_STARTED | Issue #7 |

Implementation baseline: `4e435a1a6d10ab146197671049da80709fd18c1f`
Current main: `539d2bae18d20e303649f047b9df69e8e224b2e7`
Post-VS02 audit: `기획서/50_제작_검증/POST_VS02_ADVERSARIAL_AUDIT.md`
Current planning Goal: `기획서/00_프로젝트_허브/EXECUTABLE_PROMPTS/CODEX_GOAL_VS_03.md`

---

## Completed Foundation

### Task 1: Godot project and headless test harness · COMPLETE

- [x] Godot 4.7.1 project and 1920×1080 landscape main scene.
- [x] Bounded headless runner and watchdog.
- [x] CI fails on Godot `SCRIPT ERROR` or runtime `ERROR`.

### Task 2: Deterministic connected rail graph · COMPLETE

- [x] 15×10 connected graph, zero dead ends.
- [x] cycle rank at least three.
- [x] deterministic safe fallback.
- [x] seeds 1~100 PASS.

### Task 3: Multi-state switch routing · COMPLETE

- [x] 2-state and 3-state switches.
- [x] straight-first route A.
- [x] no immediate reversal.
- [x] five-cell preview parity.
- [x] passage reset.

### Task 4: Train movement and wagon following · COMPLETE

**Implemented files:**

```text
game/train/train_state.gd
game/train/train_controller.gd
game/train/wagon_view.gd
tests/train/test_train_movement.gd
```

- [x] continuous cells-per-second movement.
- [x] active-segment target lock.
- [x] exact multi-cell event timing.
- [x] max eight wagons at one-cell spacing.
- [x] bounded history.
- [x] interpolated locomotive and wagon positions.
- [x] `forward_cells(step_count)` for safe spawn exclusion.

### Task 5: Cargo population, stations, LIFO, and DeliveryLoop · COMPLETE

**Implemented files:**

```text
game/cargo/cargo_type.gd
game/cargo/cargo_stack.gd
game/cargo/cargo_spawner.gd
game/input/gameplay_input_state.gd
game/station/station.gd
game/station/station_placer.gd
game/delivery/delivery_loop.gd
tests/cargo/**
tests/station/**
tests/integration/test_delivery_loop.gd
```

- [x] capacity 8 and reverse unload order.
- [x] LOAD-only pickup and BOOST priority.
- [x] exactly two stations per type.
- [x] at least four map pickups per type.
- [x] deterministic placement and bounded failure.
- [x] delayed respawn and deferred recovery.
- [x] train/current/forward/last-collected exclusions.
- [x] matching LIFO group unloading.
- [x] DeliveryLoop processes pending respawns.
- [x] Godot `9 cases / 6915 assertions / 0 failures`.

---

## Planning Gate Before Remaining Tasks

### Task P1: Restore post-VS02 canonical state

**Files:**

- Modify project Hub, Decisions, Gates, Roadmap, Changelog.
- Modify Core Gameplay and Core Systems.
- Create `POST_VS02_ADVERSARIAL_AUDIT.md`.
- Update Documentation Map and Registry.
- Mark VS-02 Goal historical.
- Create VS-03 planning Goal.
- Synchronize the configured Switchy Express Sheet after merge.

Acceptance:

- [ ] GitHub main, Issue, Plan, actual code, and Sheet show VS-02 complete.
- [ ] `EV-VS02-001`, `EV-VS02-FIX-001`, `EV-BASE-V94-001`, `SX-AUD-003` are traceable.
- [ ] wrong `19Ff...` Sheet is not modified.
- [ ] exact canonical merge commit is present in Sheet readback.
- [ ] sync closure PR marks `SYNCED`.

### Task P2: Total planning, adversarial review, and Grill Me

- [ ] Audit product/experience/system/content/world/UX/art/audio/data/technology/QA/production coverage.
- [ ] Compare player promise against core loop, economy, UI, accessibility, data, and Vertical Slice.
- [ ] Classify findings as `AUTO_FIX_ELIGIBLE / USER_DECISION_REQUIRED / RESEARCH_OR_TEST_REQUIRED`.
- [ ] Apply safe planning fixes.
- [ ] Ask one most-blocking Grill Me Decision at a time.
- [ ] Update canon, Issues, Plan, Active Context, and Sheet after each approved Decision.
- [ ] Close `G3P_TOTAL_PLANNING_AND_REVIEW_COMPLETE`.

---

## Remaining Vertical Slice

### Task 6: VS-03A — Speed, fuel, score, boost, and game over

**Files:**

- Create: `game/run/run_balance.gd`
- Create: `game/run/run_state.gd`
- Create: `game/run/run_controller.gd`
- Create: `tests/run/test_run_balance.gd`
- Create: `tests/run/test_run_controller.gd`
- Create: `tests/run/test_no_input_survival.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**

- Consumes:
  - `TrainController.set_speed(cells_per_second: float)`
  - `DeliveryLoop.advance_time(delta_seconds: float) -> Array[Dictionary]`
  - `GameplayInputState.is_boosting() -> bool`
  - `CargoStack.size() -> int`
- Produces:
  - `RunBalance.speed(...) -> float`
  - `RunBalance.fuel_drain_per_second(...) -> float`
  - `RunBalance.delivery_reward(...) -> Dictionary`
  - `RunController.advance_time(...) -> Array[Dictionary]`
  - `signal run_ended(summary: Dictionary)`

- [ ] Write formula and boundary tests from `CORE_SYSTEMS.md`.
- [ ] Run them and verify RED for missing run classes.
- [ ] Implement pure `RunBalance`.
- [ ] Run focused tests and verify GREEN.
- [ ] Write DeliveryLoop reward and single-game-over integration tests.
- [ ] Run and verify RED.
- [ ] Implement `RunState` and `RunController`.
- [ ] Verify input 0 reaches fuel 0 within 180 seconds and score stays zero.
- [ ] Verify cargo slowdown never lowers fuel drain.
- [ ] Verify boost is not free and LOAD remains blocked.
- [ ] Run the full suite.
- [ ] Commit: `feat: add survival score and boost economy`.

### Task 7: VS-03B — Gameplay Scene, HUD, results, restart, and records

**Files:**

- Create: `game/play/play_scene.tscn`
- Create: `game/play/play_scene.gd`
- Create: `game/rail/rail_board_view.gd`
- Create: `game/rail/switch_view.gd`
- Create: `game/ui/game_hud.tscn`
- Create: `game/ui/game_hud.gd`
- Create: `game/ui/result_panel.tscn`
- Create: `game/ui/result_panel.gd`
- Create: `game/save/record_store.gd`
- Create: `tests/ui/test_switch_view_model.gd`
- Create: `tests/ui/test_hud_state.gd`
- Create: `tests/save/test_record_store.gd`
- Modify: `game/main/main.tscn`
- Modify: `tests/run_tests.gd`

**Interfaces:**

- Consumes:
  - RunController state and events.
  - RailGraph switch and preview state.
  - CargoStack unload order.
- Produces:
  - display-only ViewModels.
  - result summary rendering.
  - versioned best score/time/combo persistence.

- [ ] Write failing ViewModel, touch-state, result, restart, and save tests.
- [ ] Verify RED.
- [ ] Build the minimal playable scene using domain state as authority.
- [ ] Verify highlighted path and actual route parity.
- [ ] Verify HUD unload order equals CargoStack.
- [ ] Verify animations cannot duplicate pickup, unload, reward, game-over, or save.
- [ ] Verify Reduced Motion and instant-complete preserve information.
- [ ] Verify corrupted/unknown save falls back without destroying current run.
- [ ] Capture 1920×1080 representative states without claiming Android proof.
- [ ] Run the full suite.
- [ ] Commit: `feat: build mobile gameplay UI results and records`.

### Task 8: VS-04 — Telemetry, persistence verification, soak, Android, and playtest

**Files:**

- Create: `game/telemetry/run_event_log.gd`
- Create: `tools/run_soak_test.gd`
- Create: `기획서/50_제작_검증/VERTICAL_SLICE_REVIEW.md`
- Modify: Hub, Gates, Decisions, Sheet.

- [ ] Implement bounded run/cargo/switch/station/boost/fuel/end events.
- [ ] Verify record persistence and corruption fallback in integration.
- [ ] Run all project and Godot tests.
- [ ] Run a 10-minute soak and inspect memory/event/history growth.
- [ ] Export and run on a target Android device.
- [ ] Capture frame time, memory, safe area, and touch evidence.
- [ ] Run first-experience playtests with at least five people.
- [ ] Attack preview mismatch, fake branch, starvation, slowdown exploit, permanent boost, no-input farming, touch overlap, color-only information, and event growth.
- [ ] Add regression tests for approved P0/P1 findings.
- [ ] Record `PASS / REVISE / PIVOT / STOP`.
- [ ] Synchronize GitHub canon and Sheet.

## Global Completion Evidence

```bash
python tools/validate_project_contract.py
python -m unittest tests.test_base_v94_ai_operations_adoption -v
godot --headless --path . --script res://tests/run_tests.gd
git diff --check
git status --short
```

Never report Android, visual, performance, accessibility, playtest, or persistence-integration checks as passed unless actually executed and evidence is attached.
