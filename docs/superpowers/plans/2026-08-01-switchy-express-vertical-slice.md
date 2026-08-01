# Switchy Express Vertical Slice Implementation Plan

> **For agentic workers:** Use `superpowers:subagent-driven-development` when available or `superpowers:executing-plans` task by task. TDD and verification-before-completion are mandatory.

**Goal:** Build a playable Godot 4.7.1 Android-landscape Vertical Slice that proves connected rail routing, multi-state switches, selective cargo loading, LIFO unloading, fuel survival, cargo slowdown, boost risk, and score competition.

**Architecture:** Represent the 15×10 rail board as a deterministic graph. `RailGraph` owns connectivity and switch states; `TrainController` advances along graph edges without physics; `CargoStack` owns LIFO data; pure services compute speed, fuel, scoring, and spawn fairness. Rendering and HUD consume domain state so logic remains headless-testable.

**Tech Stack:** Godot 4.7.1-stable, GDScript, built-in Resource/Node/Control APIs, custom headless test runner, Android landscape export.

## Current Status

| Area | Status | Evidence |
|---|---|---|
| Task 1 · Godot project/test harness | COMPLETE | PR #9 |
| Task 2 · deterministic RailGraph | COMPLETE | seeds 1~100 PASS |
| Task 3 · multi-state RailSwitch | COMPLETE | preview parity·straight-first PASS |
| Tasks 4~5 · train/cargo/station/LIFO | NEXT | Issue #5 |
| Task 6 · run economy | NOT_STARTED | Issue #6 |
| Tasks 7~8 · product UI/telemetry/review | NOT_STARTED | Issue #7 |

Implementation baseline: `801632949d28564528e38d83dac59cccc6f06fb2`
Post-VS01 audit: `기획서/50_제작_검증/POST_VS01_ADVERSARIAL_AUDIT.md`
Current executable Goal: `기획서/00_프로젝트_허브/EXECUTABLE_PROMPTS/CODEX_GOAL_VS_02.md`

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
- HTML POC and generated concept images are references, not runtime evidence.

---

## Completed Foundation

### Task 1: Godot project and headless test harness · COMPLETE

**Files:**
- `project.godot`
- `game/main/main.tscn`
- `game/main/main.gd`
- `tests/test_case.gd`
- `tests/run_tests.gd`
- `tests/smoke/test_project_boot.gd`
- `.github/workflows/godot-tests.yml`

**Result:**

- [x] Wrote boot contract first and observed failure.
- [x] Added 1920×1080 landscape project and main scene.
- [x] Added bounded headless runner and watchdog.
- [x] Made CI fail when Godot prints `SCRIPT ERROR` or runtime `ERROR` even with process exit 0.
- [x] Verified Godot 4.7.1 headless PASS.

### Task 2: Deterministic connected rail graph · COMPLETE

**Files:**
- `game/rail/rail_cell.gd`
- `game/rail/rail_graph.gd`
- `game/rail/rail_generator.gd`
- `tests/rail/test_rail_generator.gd`

**Current interfaces:**

```gdscript
RailGenerator.generate(seed: int)
RailGraph.neighbors(cell: Vector2i) -> Array[Vector2i]
RailGraph.is_fully_connected() -> bool
RailGraph.dead_end_count() -> int
RailGraph.switch_cells() -> Array[Vector2i]
RailGraph.two_state_switch_count() -> int
RailGraph.three_state_switch_count() -> int
```

`is_fully_connected()` is used because Godot already owns `Object.is_connected(signal, callable)`.

**Result:**

- [x] Seeds 1~100: 15×10, connected, zero dead ends.
- [x] Cycle rank at least three.
- [x] At least four 2-state and two 3-state switches.
- [x] Every counted switch route advances for at least three cells.
- [x] Same seed gives same signature.
- [x] Deterministic safe fallback after 32 failed candidates.

**Deferred quality check:** current generator satisfies structural contracts but unique-map count and route entropy are not yet proven.

### Task 3: 2-state and 3-state switch routing · COMPLETE

**Files:**
- `game/rail/rail_switch.gd`
- `game/rail/rail_graph.gd`
- `tests/rail/test_switch_routing.gd`

**Current interfaces:**

```gdscript
RailSwitch.cycle_state() -> void
RailSwitch.current_exit_for(incoming: Vector2i) -> Vector2i
RailSwitch.reset_after_passage() -> void
RailGraph.next_cell(current: Vector2i, previous: Vector2i) -> Vector2i
RailGraph.preview_route(current: Vector2i, previous: Vector2i, step_count: int) -> Array[Vector2i]
```

**Result:**

- [x] 2-state `A → B → A`.
- [x] 3-state `A → B → C → A`.
- [x] Straight route preferred as default A when available.
- [x] No immediate 180-degree reversal.
- [x] Passage reset API.
- [x] Five-cell preview first cell matches actual routing.

Final VS-01 verification: `3 cases / 934 assertions / 0 failures`.

---

## Next Build Package — Issue #5

### Task 4: Train movement and wagon following

**Files:**
- Create: `game/train/train_state.gd`
- Create: `game/train/train_controller.gd`
- Create: `game/train/wagon_view.gd`
- Create: `tests/train/test_train_movement.gd`

**Interfaces:**

```gdscript
TrainController.set_speed(cells_per_second: float) -> void
signal cell_entered(cell: Vector2i)
signal switch_passed(switch_id: StringName)
```

- [ ] Write failing tests for selected-exit following, no reversal, one-cell wagon spacing, eight-wagon non-overlap, and switch reset after locomotive passage.
- [ ] Test bounded traveled-position history so it cannot grow forever.
- [ ] Implement interpolation between cell centers and route-distance history; do not use collision physics for routing.
- [ ] Verify straight, curve, 2-state, and 3-state paths.
- [ ] Commit: `feat: move train and follow route history`.

### Task 5: Cargo population, station placement, and LIFO unloading

**Files:**
- Create: `game/cargo/cargo_type.gd`
- Create: `game/cargo/cargo_stack.gd`
- Create: `game/cargo/cargo_spawner.gd`
- Create: `game/input/gameplay_input_state.gd`
- Create: `game/station/station.gd`
- Create: `game/station/station_placer.gd`
- Create: `tests/cargo/test_cargo_stack.gd`
- Create: `tests/cargo/test_cargo_spawner.gd`
- Create: `tests/station/test_station_placement.gd`
- Create: `tests/station/test_station_unloading.gd`

**Interfaces:**

```gdscript
CargoStack.push(type) -> bool
CargoStack.peek()
CargoStack.unload_order() -> Array
CargoStack.pop_matching_group(type) -> Array
CargoSpawner.ensure_minimum(type, count := 4)
Station.try_unload(stack) -> Array
```

- [ ] Test load order red, red, blue, red: red station unloads one, blue one, red two.
- [ ] Test capacity eight and reversed unload-order ViewModel.
- [ ] Test LOAD inactive means no pickup; LOAD/BOOST conflict resolves to BOOST priority.
- [ ] Test exactly two stations per color, no station on a switch, same-color graph distance at least five.
- [ ] Test at least four pickups per color and all prohibited spawn cells.
- [ ] Test deterministic placement and bounded failure/deferred state.
- [ ] Implement one-second delayed respawn without same-position farming.
- [ ] Run full suite and verify PASS.
- [ ] Commit: `feat: add train cargo stations and LIFO unloading`.

Execution details: `CODEX_GOAL_VS_02.md`.

---

## Remaining Vertical Slice

### Task 6: Speed, fuel, score, boost, and game over

**Files:**
- Create: `game/run/run_balance.gd`
- Create: `game/run/run_state.gd`
- Create: `game/run/run_controller.gd`
- Create: `tests/run/test_run_balance.gd`
- Create: `tests/run/test_no_input_survival.gd`

**Interfaces:**

```gdscript
RunBalance.speed(elapsed: float, cargo_count: int, boosting: bool) -> float
RunBalance.fuel_drain(elapsed: float, boosting: bool) -> float
RunBalance.delivery_reward(combo_count: int, seconds_since_delivery: float, cargo_before: int) -> Dictionary
signal run_ended(summary: Dictionary)
```

- [ ] Write formula tests using initial values in `CORE_SYSTEMS.md`.
- [ ] Simulate 180 seconds without input and assert fuel reaches zero and score stays zero.
- [ ] Verify cargo slowdown never reduces time-based fuel drain.
- [ ] Verify BOOST blocks LOAD and is not always optimal.
- [ ] Implement pure balance functions and game-over summary.
- [ ] Commit: `feat: add survival score and boost economy`.

### Task 7: Gameplay scene and landscape HUD

**Files:**
- Create: `game/play/play_scene.tscn`
- Create: `game/play/play_scene.gd`
- Create: `game/rail/rail_board_view.gd`
- Create: `game/rail/switch_view.gd`
- Create: `game/ui/game_hud.tscn`
- Create: `game/ui/game_hud.gd`
- Create: `game/ui/result_panel.tscn`
- Create: `game/ui/result_panel.gd`
- Create: `tests/ui/test_switch_view_model.gd`
- Create: `tests/ui/test_hud_state.gd`

- [ ] Test highlighted path and arrows against selected switch exit.
- [ ] Test unload order is reversed stack and BOOST disables LOAD.
- [ ] Build placeholder vector visuals with strong rails, dim alternatives, bright active path, shape-coded cargo/stations, 48dp switch targets, and safe-area-aware HUD.
- [ ] Capture 1920×1080 default, toggled 3-state, LIFO combo, low-fuel BOOST, and result states.
- [ ] Measure unique graph signatures and route-length distribution before claiming procedural variety.
- [ ] Commit: `feat: build readable mobile gameplay UI`.

### Task 8: Telemetry, soak test, and final adversarial review

**Files:**
- Create: `game/telemetry/run_event_log.gd`
- Create: `game/save/record_store.gd`
- Create: `tools/run_soak_test.gd`
- Create: `기획서/50_제작_검증/VERTICAL_SLICE_REVIEW.md`
- Modify: `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
- Modify: `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md`

- [ ] Implement events from `PLAYTEST_PLAN.md` and local best score/time/combo save.
- [ ] Run `python tools/validate_project_contract.py`.
- [ ] Run all headless tests.
- [ ] Run a 10-minute headless soak test and verify no crash or unbounded history/event growth.
- [ ] Run Android export and target-device performance checks.
- [ ] Attack misleading previews, fake branches, spawn starvation, cargo-slowdown exploits, permanent boost, no-input loops, touch overlap, and color-only information.
- [ ] Add regression tests for approved P0/P1 findings.
- [ ] Record `PASS / REVISE / PIVOT / STOP`, evidence, and remaining risks.
- [ ] Commit: `review: close Vertical Slice gate findings`.

## Global Completion Evidence

```bash
python tools/validate_project_contract.py
godot --headless --path . --script res://tests/run_tests.gd
git diff --check
git status --short
```

Never report Android, visual, performance, or playtest checks as passed unless they were actually executed and evidence is attached.
