# Switchy Express Vertical Slice Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a playable Godot 4.7.1 Android-landscape Vertical Slice that proves connected rail routing, multi-state switches, selective cargo loading, compact token LIFO unloading, fuel survival, cargo slowdown, boost risk, unload-group Combo scoring, readable product UI, persistence, and actual play evidence.

**Architecture:** Represent the 15×10 rail board as a deterministic graph. `RailGraph` owns connectivity and switch states; `TrainController` advances along graph edges without physics; `CargoStack` owns LIFO data; `DeliveryLoop` owns pickup/unload integration; compact token ViewModels project CargoStack into a compressed train presentation; pure run services compute speed, fuel, scoring, Combo, and game-over. Rendering, motion, audio, haptics, result panels, and persistence consume domain state without owning gameplay outcomes.

**Tech Stack:** Godot 4.7.1-stable, GDScript, built-in Resource/Node/Control APIs, custom headless test runner, Android landscape export.

## Global Constraints

- Grid is exactly 15×10 for the Vertical Slice.
- Every rail cell belongs to one connected graph; no degree-1 endpoint.
- At least four 2-state and two 3-state switches.
- Straight travel is default route A when a straight exit exists.
- Route preview first cell and actual next cell must match.
- Red, blue, and yellow each have exactly two stations and at least four map cargo pickups.
- Unloading is LIFO; only the consecutive top group matching the station unloads.
- `Combo` is the number of matching cargo items unloaded during one station arrival; `max_combo` is the largest such group in the run.
- Fast consecutive delivery is a separate `speed_bonus` `TEST_VALUE`, not a Combo streak.
- One cargo item maps to one compact wagon token; empty tokens are not shown.
- Front-to-rear compact tokens map to CargoStack bottom-to-top; the rear token is the next LIFO item.
- Eight tokens must fit within the configured compact chain and reserve no more than three trailing rail cells.
- Cargo slows the train; fuel drain is time-based and does not fall with speed.
- Boost increases speed and multiplies fuel drain; LOAD and BOOST cannot be active together.
- No branch slow motion.
- Color is paired with shape: red/star, blue/diamond, yellow/triangle.
- UI animation and completion signals never own score, fuel, cargo, token count/order, occupancy, routing, game-over, or save outcomes.
- Detailed balance and compact geometry values are `TEST_VALUE` until playtest evidence.
- Android, visual, performance, accessibility, and human gates remain `NOT_RUN` until executed.
- Total planning and required Grill Me Decisions must close before Codex Build.

---

## Current Status

| Area | Status | Evidence |
|---|---|---|
| Task 1 · Godot project/test harness | COMPLETE | PR #9 |
| Task 2 · deterministic RailGraph | COMPLETE | seeds 1~100 PASS |
| Task 3 · multi-state RailSwitch | COMPLETE | preview parity·straight-first PASS |
| Task 4 · train movement/wagon position foundation | COMPLETE | PR #12 |
| Task 5 · cargo/station/LIFO/runtime recovery | COMPLETE | PR #12·#13 |
| Post-VS02 canonical recovery | COMPLETE | PR #16 / `8245e229…` |
| Post-VS02 Sheet closure | COMPLETE | PR #17 / `474bef44…` |
| `SX-DEC-014` Combo | CONFIRMED · GITHUB_SHEET_SYNCED · IMPLEMENTATION_NOT_STARTED | PR #18/#19 |
| `SX-DEC-015` compact wagon tokens | CONFIRMED · CANON_IN_PROGRESS · IMPLEMENTATION_NOT_STARTED | `EV-USER-003` |
| `SX-DEC-016` onboarding | USER_DECISION_REQUIRED_NEXT | `SX-AUD-004-F03` |
| Task 6 · run economy | BLOCKED_BY_PLANNING | Issue #6 / VS-03A |
| Task 7 · compact token product UI/result/save | BLOCKED_BY_PLANNING | Issue #6 / VS-03B |
| Task 8 · telemetry/soak/device/playtest | NOT_STARTED | Issue #7 |

Implementation baseline: `4e435a1a6d10ab146197671049da80709fd18c1f`
Latest synchronized main before `SX-DEC-015`: `11c6914b0fdcfb946c85e303d05017a77b969e55`
Historical Post-VS02 audit: `기획서/50_제작_검증/POST_VS02_ADVERSARIAL_AUDIT.md`
Current planning audit: `기획서/50_제작_검증/TOTAL_PLANNING_AUDIT.md`
Compact token spec: `docs/superpowers/specs/2026-08-02-compact-cargo-wagon-tokens-design.md`
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

### Task 4: Train movement and wagon position foundation · COMPLETE

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
- [x] max eight wagon positions at one-cell spacing.
- [x] bounded history.
- [x] interpolated locomotive and wagon positions.
- [x] `forward_cells(step_count)` for safe spawn exclusion.
- [x] Decide product mapping through `SX-DEC-015`.
- [ ] Adapt view spacing from full-cell wagons to compact token offsets in Task 7.
- [ ] Replace wagon-count spawn occupancy with compressed footprint in Task 7.

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

### Task P1: Restore post-VS02 canonical state · COMPLETE

- [x] Project Hub, Decisions, Gates, Roadmap, Changelog, Core documents updated.
- [x] `POST_VS02_ADVERSARIAL_AUDIT.md` created and registered.
- [x] VS-02 Goal marked historical and VS-03 planning Goal created.
- [x] GitHub main, Issue, Plan, actual code, and Sheet show VS-02 complete.
- [x] Evidence and audit IDs traceable.
- [x] wrong `19Ff...` Sheet not modified.
- [x] PR #17 closed synchronization as `SYNCED`.

### Task P2: Total planning, adversarial review, and Grill Me · IN_PROGRESS

- [x] Create and register `SX-AUD-004` coverage and conflict audit.
- [x] Audit product/experience/system/content/world/UX/art/audio/data/technology/QA/production coverage.
- [x] Apply safe planning fixes for Skill freshness, playtest thresholds, telemetry fields, and audio/haptic fallbacks.
- [x] Confirm and sync `SX-DEC-014` Combo semantics.
- [x] Confirm `SX-DEC-015`: cargo 1 = compact wagon token 1.
- [x] Define compressed geometry, LIFO ordering, domain authority, and spawn footprint.
- [x] Add compact token spec and update Core/Visual/VS/Playtest contracts.
- [ ] Merge `SX-DEC-015` canonical PR and sync `EV-USER-003` to Sheet.
- [ ] Confirm `SX-DEC-016` onboarding approach.
- [ ] Re-evaluate failure-learning gap after onboarding Decision.
- [ ] Ensure all approved Decisions are reflected in canon, Issues, Plan, Active Context, and Sheet.
- [ ] Close `G3P_TOTAL_PLANNING_AND_REVIEW_COMPLETE`.

---

## Remaining Vertical Slice

### Task 6: VS-03A — Speed, fuel, score, boost, Combo, and game over

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
  - `RunBalance.delivery_reward(unload_group_size, seconds_since_delivery, cargo_before_delivery) -> Dictionary`
  - `RunController.advance_time(...) -> Array[Dictionary]`
  - `signal run_ended(summary: Dictionary)`

- [ ] Write formula and boundary tests from `CORE_SYSTEMS.md`.
- [ ] Verify `combo_count == unload_group_size == try_unload().count`.
- [ ] Verify `max_combo` updates once per valid unload event.
- [ ] Verify `speed_bonus` never changes Combo state.
- [ ] Implement pure `RunBalance`, `RunState`, and `RunController` test-first.
- [ ] Verify input 0 reaches fuel 0 within 180 seconds and score stays zero.
- [ ] Verify cargo slowdown never lowers fuel drain.
- [ ] Verify boost is not free and LOAD remains blocked.
- [ ] Verify empty or mismatched station arrival grants Combo/score/fuel 0.
- [ ] Run the full suite.
- [ ] Commit: `feat: add survival score combo and boost economy`.

### Task 7: VS-03B — Compact tokens, gameplay Scene, HUD, results, restart, and records

**Files:**

- Create: `game/play/play_scene.tscn`
- Create: `game/play/play_scene.gd`
- Create: `game/rail/rail_board_view.gd`
- Create: `game/rail/switch_view.gd`
- Create: `game/train/compact_wagon_token_view.gd`
- Create: `game/train/train_footprint.gd`
- Create: `game/ui/game_hud.tscn`
- Create: `game/ui/game_hud.gd`
- Create: `game/ui/result_panel.tscn`
- Create: `game/ui/result_panel.gd`
- Create: `game/save/record_store.gd`
- Create: `tests/train/test_compact_wagon_tokens.gd`
- Create: `tests/train/test_train_footprint.gd`
- Create: `tests/ui/test_switch_view_model.gd`
- Create: `tests/ui/test_hud_state.gd`
- Create: `tests/save/test_record_store.gd`
- Modify: existing Train/Wagon/Spawner integration files only as required by exact-code review.
- Modify: `game/main/main.tscn`
- Modify: `tests/run_tests.gd`

**Interfaces:**

- Consumes:
  - RunController state and events.
  - RailGraph switch and preview state.
  - CargoStack items and unload order.
  - TrainController bounded path history.
- Produces:
  - compact token count/order ViewModel.
  - compressed train footprint for spawn exclusion.
  - display-only HUD/ViewModels.
  - `COMBO ×N` event feedback and run `max_combo` display.
  - result summary and versioned records.

#### TDD sequence

1. Write failing token count/order tests for cargo 0~8.
2. Write failing rear-token/CargoStack-top/HUD-first parity tests.
3. Write failing load append and group-unload removal tests.
4. Write failing geometry tests for body 0.22, spacing 0.28, 8-token chain ≤2.18 cells.
5. Write failing compressed footprint tests: capacity-eight trailing cells ≤3.
6. Write failing corner tests: no order swap, no path cutting.
7. Write failing spawn tests: no pickup inside committed footprint or forward exclusion.
8. Implement the smallest domain/ViewModel changes to pass.
9. Build product views without moving domain authority into animation.
10. Run full regression after each boundary is connected.

#### Acceptance checks

- [ ] `token_count == CargoStack.size()` for 0~8.
- [ ] front→rear token types equal stack bottom→top.
- [ ] rear token equals stack top and HUD first unload item.
- [ ] load adds one rear token exactly once.
- [ ] valid unload removes exact rear matching group exactly once.
- [ ] 8-token chain length and footprint stay within configured bounds.
- [ ] compressed footprint updates in the same domain step as CargoStack.
- [ ] fractional path samples preserve order on straight, curve, and switch passage.
- [ ] highlighted path and actual route parity remain unchanged.
- [ ] Combo feedback uses unload-group size; speed bonus is separate.
- [ ] animations cannot duplicate pickup, unload, occupancy, reward, game-over, or save.
- [ ] Reduced Motion and instant-complete preserve information.
- [ ] corrupted/unknown save falls back without destroying current run.
- [ ] capture 0/1/4/8 and curved 8-token 1920×1080 states without claiming Android proof.
- [ ] run the full suite.
- [ ] Commit: `feat: build compact cargo train and mobile gameplay UI`.

### Task 8: VS-04 — Telemetry, persistence verification, soak, Android, and playtest

**Files:**

- Create: `game/telemetry/run_event_log.gd`
- Create: `tools/run_soak_test.gd`
- Create: `기획서/50_제작_검증/VERTICAL_SLICE_REVIEW.md`
- Modify: Hub, Gates, Decisions, Sheet.

- [ ] Implement bounded run/cargo/switch/station/boost/fuel/end events.
- [ ] Record cargo events with `cargo_type`, color, shape, stack size, token count, rear token type, and footprint cells.
- [ ] Record unload events with `unload_group_size`, token count after, and `speed_bonus_applied` separately.
- [ ] Verify record persistence and corruption fallback in integration.
- [ ] Run all project and Godot tests.
- [ ] Run a 10-minute soak and inspect memory/event/history growth.
- [ ] Attack pickup spawning inside compressed token footprint.
- [ ] Export and run on a target Android device.
- [ ] Capture frame time, memory, safe area, touch evidence, and token shape readability.
- [ ] Run first-experience playtests with at least five people using percentage and concrete-count gates.
- [ ] Attack preview mismatch, starvation, slowdown exploit, permanent boost, no-input farming, touch overlap, color-only information, Combo/streak confusion, token order reversal, and event growth.
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
