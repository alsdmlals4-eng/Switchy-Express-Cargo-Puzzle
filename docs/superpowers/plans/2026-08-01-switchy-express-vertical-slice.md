# Switchy Express Vertical Slice Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a playable Godot 4.7.1 Android-landscape Vertical Slice that proves connected rail routing, multi-state switches, selective cargo loading, LIFO unloading, fuel survival, cargo slowdown, boost risk, and score competition.

**Architecture:** Represent the 15×10 rail board as a deterministic graph. `RailGraph` owns connectivity and switch states; `TrainController` advances along graph edges without physics; `CargoStack` owns LIFO data; pure services compute speed, fuel, scoring, and spawn fairness. Rendering and HUD consume domain state through signals so logic remains headless-testable.

**Tech Stack:** Godot 4.7.1-stable, GDScript, built-in Resource/Node/Control APIs, custom headless test runner, Android landscape export.

## Global Constraints

- Grid is exactly 15×10 for the Vertical Slice.
- Every rail cell belongs to one connected graph; no degree-1 endpoint.
- At least four 2-way and two 3-way switches.
- Red, blue, and yellow each have exactly two stations and at least four map cargo pickups.
- Unloading is LIFO; only the consecutive top group matching the station unloads.
- Cargo slows the train; fuel drain is time-based and does not fall with speed.
- Boost increases speed and multiplies fuel drain; LOAD and BOOST cannot be active together.
- No branch slow motion.
- Color is paired with shape: red/star, blue/diamond, yellow/triangle.
- HTML POC and generated concept images are references, not runtime evidence.

---

### Task 1: Godot project and headless test harness

**Files:**
- Create: `project.godot`
- Create: `game/main/main.tscn`
- Create: `game/main/main.gd`
- Create: `tests/test_case.gd`
- Create: `tests/run_tests.gd`
- Create: `tests/smoke/test_project_boot.gd`

**Produces:** a bootable 1920×1080 landscape project and `godot --headless --path . --script res://tests/run_tests.gd` test command.

- [ ] Write a smoke test asserting application name, viewport 1920×1080, landscape orientation, and main scene.
- [ ] Run the command and verify it fails because the project and runner do not exist.
- [ ] Create `project.godot`, main scene, and a runner that loads `tests/**/test_*.gd`, prints failures, and exits non-zero.
- [ ] Run the command and verify PASS.
- [ ] Commit: `test: add Godot project and headless harness`.

### Task 2: Deterministic connected rail graph

**Files:**
- Create: `game/rail/rail_cell.gd`
- Create: `game/rail/rail_graph.gd`
- Create: `game/rail/rail_generator.gd`
- Create: `tests/rail/test_rail_generator.gd`

**Interfaces:**
- `RailGenerator.generate(seed: int) -> RailGraph`
- `RailGraph.neighbors(cell: Vector2i) -> Array[Vector2i]`
- `RailGraph.is_connected() -> bool`
- `RailGraph.dead_end_count() -> int`
- `RailGraph.switch_cells() -> Array[Vector2i]`

- [ ] Write tests for seeds 1–100: size 15×10, connected, zero dead ends, at least six switches, cycle rank at least three, and every branch diverges for at least three cells.
- [ ] Run and verify failure.
- [ ] Implement outer cycle, inner cycle, horizontal/vertical connectors, seeded optional connectors, repair pass, BFS validation, and a deterministic safe fallback after 32 failed candidates.
- [ ] Run the 100-seed suite and verify PASS.
- [ ] Commit: `feat: generate connected rail graph`.

### Task 3: 2-way and 3-way switch routing

**Files:**
- Create: `game/rail/rail_switch.gd`
- Modify: `game/rail/rail_graph.gd`
- Create: `tests/rail/test_switch_routing.gd`

**Interfaces:**
- `RailSwitch.cycle_state() -> void`
- `RailSwitch.selected_exit(incoming: Vector2i) -> Vector2i`
- `RailGraph.next_cell(current: Vector2i, previous: Vector2i) -> Vector2i`
- signal `state_changed(switch_id: StringName, state_index: int)`

- [ ] Test 2-way A→B→A, 3-way A→B→C→A, no-input preservation, passage reset, and preview/path agreement.
- [ ] Run and verify failure.
- [ ] Implement ordered exits relative to incoming direction and expose the next five preview cells.
- [ ] Run and verify PASS.
- [ ] Commit: `feat: add multi-state rail switches`.

### Task 4: Train movement and wagon following

**Files:**
- Create: `game/train/train_state.gd`
- Create: `game/train/train_controller.gd`
- Create: `game/train/wagon_view.gd`
- Create: `tests/train/test_train_movement.gd`

**Interfaces:**
- `TrainController.set_speed(cells_per_second: float)`
- signals `cell_entered(cell: Vector2i)` and `switch_passed(switch_id: StringName)`

- [ ] Test selected exit following, no 180-degree reversal, one-cell wagon spacing, eight-wagon non-overlap, and switch reset after locomotive passage.
- [ ] Run and verify failure.
- [ ] Implement interpolation between cell centers and a bounded traveled-position history; do not use collision physics for routing.
- [ ] Run and verify PASS.
- [ ] Commit: `feat: move train and follow route history`.

### Task 5: Cargo population and LIFO unloading

**Files:**
- Create: `game/cargo/cargo_type.gd`
- Create: `game/cargo/cargo_stack.gd`
- Create: `game/cargo/cargo_spawner.gd`
- Create: `game/station/station.gd`
- Create: `game/station/station_placer.gd`
- Create: `tests/cargo/test_cargo_stack.gd`
- Create: `tests/cargo/test_cargo_spawner.gd`
- Create: `tests/station/test_station_unloading.gd`

**Interfaces:**
- `CargoStack.push(type: CargoType) -> bool`
- `CargoStack.peek() -> CargoType`
- `CargoStack.pop_matching_group(type: CargoType) -> Array[CargoType]`
- `CargoSpawner.ensure_minimum(type: CargoType, count: int = 4)`
- `Station.try_unload(stack: CargoStack) -> Array[CargoType]`

- [ ] Test load order red, red, blue, red: red station unloads one, blue one, red two.
- [ ] Test exactly two stations per color, no station on a switch, same-color station graph distance at least five.
- [ ] Test at least four pickups per color and prohibited spawn cells.
- [ ] Run and verify failure.
- [ ] Implement capacity eight, deterministic eligible-cell shuffle, one-second delayed respawn, station placement, and matching top-group unload.
- [ ] Run and verify PASS.
- [ ] Commit: `feat: add LIFO cargo and stations`.

### Task 6: Speed, fuel, score, boost, and game over

**Files:**
- Create: `game/run/run_balance.gd`
- Create: `game/run/run_state.gd`
- Create: `game/run/run_controller.gd`
- Create: `tests/run/test_run_balance.gd`
- Create: `tests/run/test_no_input_survival.gd`

**Interfaces:**
- `RunBalance.speed(elapsed: float, cargo_count: int, boosting: bool) -> float`
- `RunBalance.fuel_drain(elapsed: float, boosting: bool) -> float`
- `RunBalance.delivery_reward(combo_count: int, seconds_since_delivery: float, cargo_before: int) -> Dictionary`
- signal `run_ended(summary: Dictionary)`

- [ ] Write formula tests using the exact seed values in `기획서/20_시스템_콘텐츠/CORE_SYSTEMS.md`.
- [ ] Simulate 180 seconds without input and assert fuel reaches zero and score stays zero.
- [ ] Run and verify failure.
- [ ] Implement pure balance functions; fuel drain uses real time, cargo slowdown never reduces drain, BOOST blocks LOAD.
- [ ] Run and verify PASS.
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

- [ ] Test that highlighted path cells and arrows match the selected switch exit.
- [ ] Test that unload order is the reversed stack and BOOST disables LOAD.
- [ ] Run and verify failure.
- [ ] Build placeholder vector visuals with strong rails, dim alternatives, bright active path, shape-coded cargo/stations, 48dp switch targets, and safe-area-aware HUD.
- [ ] Run headless tests and capture 1920×1080 default, toggled 3-way, LIFO combo, low-fuel BOOST, and result states.
- [ ] Commit: `feat: build readable mobile gameplay UI`.

### Task 8: Telemetry, soak test, adversarial review

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
- [ ] Attack misleading previews, fake branches, spawn starvation, cargo-slowdown exploits, permanent boost, no-input loops, touch overlap, and color-only information.
- [ ] Add regression tests for all approved P0/P1 findings.
- [ ] Record `PASS / REVISE / PIVOT / STOP`, evidence, and remaining risks.
- [ ] Commit: `review: close Vertical Slice gate findings`.
