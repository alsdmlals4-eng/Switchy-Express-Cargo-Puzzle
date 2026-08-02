# VS03-R1 Difficulty Authority Alignment Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make `DifficultyDirector` the single authoritative owner of every speed/fuel pressure boundary before difficulty presentation is built.

**Architecture:** `RunBalance` keeps numeric formulas, while `DifficultyDirector` owns the union schedule of 30-second speed boundaries and 45-second fuel boundaries. An immutable `DifficultyPressureSnapshot` carries effective speed/fuel steps. `RunController` calculates speed and drain from the current snapshot, so no balance change occurs without a forecast/commit event.

**Tech Stack:** Godot 4.7.1, GDScript, repository custom runner (`tests/run_tests.gd`), existing boundary-sliced `RunController`.

## Global Constraints

- Start only after VS03-03 merge and synchronization.
- Finish before VS03-05A.
- Preserve all current balance constants.
- Do not add UI, Scene, Profile, map, asset, or online work.
- Exact-timestamp event consumers observe matching `RunState.elapsed_seconds()`.
- Pause produces no commit; resume has no wall-clock catch-up.
- Use `func run() -> void`; do not use unsupported runner APIs.

## File Map

Create:

```text
game/difficulty/difficulty_pressure_snapshot.gd
tests/difficulty/test_difficulty_pressure_schedule.gd
tests/run/test_run_controller_pressure_boundaries.gd
```

Modify:

```text
game/difficulty/difficulty_director.gd
game/difficulty/difficulty_event.gd
game/difficulty/difficulty_forecast.gd
game/run/run_balance.gd
game/run/run_controller.gd
tests/difficulty/test_difficulty_director.gd
tests/run/test_run_balance.gd
tests/run/test_run_controller_difficulty_events.gd
tests/run_tests.gd
```

## Public Interfaces

```gdscript
# DifficultyPressureSnapshot
func _init(speed_step: int, fuel_step: int, effective_at: float) -> void
func speed_step() -> int
func fuel_step() -> int
func effective_at() -> float
func equals(other: Variant) -> bool

# DifficultyDirector
func reset(speed_step_seconds: float = 30.0, fuel_step_seconds: float = 45.0, warning_lead_seconds: float = 5.0) -> void
func current_snapshot() -> Variant
func next_snapshot() -> Variant
func seconds_to_next_boundary() -> float
func forecast() -> Variant
func advance(delta_seconds: float) -> Array

# RunBalance
func base_speed_for_step(speed_step: int) -> float
func base_fuel_drain_for_step(fuel_step: int) -> float
func current_speed_for_snapshot(snapshot: Variant, cargo_count: int, boosting: bool) -> float
func fuel_drain_rate_for_snapshot(snapshot: Variant, boosting: bool) -> float
```

Existing elapsed-time `RunBalance` methods and existing Difficulty event/forecast accessors remain compatibility APIs.

---

### Task 1: Immutable Pressure Snapshot

**Files:**
- Create: `game/difficulty/difficulty_pressure_snapshot.gd`
- Create: `tests/difficulty/test_difficulty_pressure_schedule.gd`
- Modify: `tests/run_tests.gd`

- [ ] **Step 1: Create and register the failing test**

```gdscript
extends "res://tests/test_case.gd"

const SNAPSHOT_PATH := "res://game/difficulty/difficulty_pressure_snapshot.gd"

func run() -> void:
    var exists := ResourceLoader.exists(SNAPSHOT_PATH, "Script")
    assert_true(exists, "pressure snapshot script must exist")
    if not exists:
        return
    var script: Script = load(SNAPSHOT_PATH)
    var snapshot: Variant = script.new(2, 1, 90.0)
    assert_equal(snapshot.speed_step(), 2, "speed step")
    assert_equal(snapshot.fuel_step(), 1, "fuel step")
    assert_almost_equal(snapshot.effective_at(), 90.0, 0.0001, "effective time")
    assert_true(snapshot.equals(script.new(2, 1, 90.0)), "equal snapshots")
    assert_false(snapshot.equals(script.new(3, 1, 90.0)), "different snapshots")
```

Register the suite in `tests/run_tests.gd`, run the full runner, and expect only this existence assertion to fail.

- [ ] **Step 2: Implement the snapshot**

```gdscript
class_name DifficultyPressureSnapshot
extends RefCounted

var _speed_step: int
var _fuel_step: int
var _effective_at: float

func _init(speed_step: int, fuel_step: int, effective_at: float) -> void:
    _speed_step = maxi(speed_step, 0)
    _fuel_step = maxi(fuel_step, 0)
    _effective_at = maxf(effective_at, 0.0)

func speed_step() -> int:
    return _speed_step

func fuel_step() -> int:
    return _fuel_step

func effective_at() -> float:
    return _effective_at

func equals(other: Variant) -> bool:
    return (
        other != null
        and other.has_method("speed_step")
        and other.has_method("fuel_step")
        and other.has_method("effective_at")
        and other.speed_step() == _speed_step
        and other.fuel_step() == _fuel_step
        and absf(float(other.effective_at()) - _effective_at) <= 0.000001
    )
```

- [ ] **Step 3: Run GREEN and commit**

```bash
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tests/run_tests.gd
git add game/difficulty/difficulty_pressure_snapshot.gd tests/difficulty/test_difficulty_pressure_schedule.gd tests/run_tests.gd
git commit -m "test: define difficulty pressure snapshots"
```

---

### Task 2: Union Schedule in DifficultyDirector

**Files:**
- Modify: `game/difficulty/difficulty_director.gd`
- Modify: `game/difficulty/difficulty_event.gd`
- Modify: `game/difficulty/difficulty_forecast.gd`
- Modify: `tests/difficulty/test_difficulty_pressure_schedule.gd`
- Modify: `tests/difficulty/test_difficulty_director.gd`

- [ ] **Step 1: Add failing union-boundary assertions**

```gdscript
var director: Variant = load("res://game/difficulty/difficulty_director.gd").new()
director.reset(30.0, 45.0, 5.0)
var events: Array = director.advance(90.0)
assert_equal(events.size(), 4, "30, 45, 60, and 90 must commit")
assert_equal(events[0].changed_axes(), [&"SPEED"], "30 changes speed")
assert_equal(events[1].changed_axes(), [&"FUEL"], "45 changes fuel")
assert_equal(events[2].changed_axes(), [&"SPEED"], "60 changes speed")
assert_equal(events[3].changed_axes(), [&"SPEED", &"FUEL"], "90 combines axes")
assert_equal(director.current_snapshot().speed_step(), 3, "speed step at 90")
assert_equal(director.current_snapshot().fuel_step(), 2, "fuel step at 90")
```

Run and expect failure because the current director emits 30-second-only commits.

- [ ] **Step 2: Implement two cursors and one combined event per timestamp**

```gdscript
func _next_boundary_time() -> float:
    return minf(_next_speed_time, _next_fuel_time)
```

At each boundary, compare both cursors to `commit_time` with `TIME_EPSILON`, increment matching steps, advance matching cursors, and emit exactly one event containing `from_snapshot`, `to_snapshot`, and ordered `changed_axes` (`SPEED` before `FUEL`).

- [ ] **Step 3: Extend immutable event and forecast APIs**

Add:

```gdscript
func from_snapshot() -> Variant
func to_snapshot() -> Variant
func changed_axes() -> Array[StringName]
```

Return duplicated arrays. Preserve `from_level()`, `to_level()`, `committed_at()`, `commit_time()`, `seconds_until_commit()`, and `is_within_warning_window()`.

- [ ] **Step 4: Verify forecast sequence**

```gdscript
director.reset(30.0, 45.0, 5.0)
director.advance(25.0)
var forecast: Variant = director.forecast()
assert_true(forecast.is_within_warning_window(), "30-second warning window")
assert_equal(forecast.changed_axes(), [&"SPEED"], "first forecast axis")
director.advance(5.0)
forecast = director.forecast()
assert_almost_equal(forecast.commit_time(), 45.0, 0.0001, "next boundary is 45")
assert_equal(forecast.changed_axes(), [&"FUEL"], "second forecast axis")
```

- [ ] **Step 5: Run full regression and commit**

```bash
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tests/run_tests.gd
git add game/difficulty tests/difficulty
git commit -m "feat: unify speed and fuel difficulty boundaries"
```

---

### Task 3: Snapshot-Based RunBalance APIs

**Files:**
- Modify: `game/run/run_balance.gd`
- Modify: `tests/run/test_run_balance.gd`

- [ ] **Step 1: Write failing parity tests**

```gdscript
var balance: Variant = load("res://game/run/run_balance.gd").new()
var snapshot: Variant = load("res://game/difficulty/difficulty_pressure_snapshot.gd").new(3, 2, 90.0)
assert_almost_equal(balance.base_speed_for_step(3), balance.base_speed(90.0), 0.0001, "speed parity")
assert_almost_equal(balance.base_fuel_drain_for_step(2), balance.base_fuel_drain(90.0), 0.0001, "fuel parity")
assert_almost_equal(balance.current_speed_for_snapshot(snapshot, 4, true), balance.current_speed(90.0, 4, true), 0.0001, "snapshot speed parity")
assert_almost_equal(balance.fuel_drain_rate_for_snapshot(snapshot, true), balance.fuel_drain_rate(90.0, true), 0.0001, "snapshot drain parity")
```

- [ ] **Step 2: Implement methods and delegate old wrappers**

```gdscript
func base_speed_for_step(speed_step: int) -> float:
    return minf(SPEED_MAX, SPEED_START + SPEED_STEP_AMOUNT * float(maxi(speed_step, 0)))

func base_fuel_drain_for_step(fuel_step: int) -> float:
    return FUEL_DRAIN_START + FUEL_STEP_AMOUNT * float(maxi(fuel_step, 0))
```

`base_speed(elapsed)` and `base_fuel_drain(elapsed)` calculate step counts and call these methods. Snapshot methods apply existing cargo/BOOST multipliers without changing constants.

- [ ] **Step 3: Run and commit**

```bash
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tests/run_tests.gd
git add game/run/run_balance.gd tests/run/test_run_balance.gd
git commit -m "refactor: calculate run pressure from snapshots"
```

---

### Task 4: RunController Boundary Consumption

**Files:**
- Modify: `game/run/run_controller.gd`
- Create: `tests/run/test_run_controller_pressure_boundaries.gd`
- Modify: `tests/run/test_run_controller_difficulty_events.gd`
- Modify: `tests/run_tests.gd`

- [ ] **Step 1: Write valid failing before/after tests using separate controllers**

```gdscript
func _fuel_used(start_time: float, duration: float) -> float:
    var fixture: Dictionary = _build_controller(1000.0, 1000.0)
    var controller: Variant = fixture.controller
    controller.start()
    controller.advance_time(start_time)
    var before: float = controller.run_state().fuel()
    controller.advance_time(duration)
    return before - controller.run_state().fuel()

func run() -> void:
    var before_45: float = _fuel_used(43.0, 1.0)
    var after_45: float = _fuel_used(45.0, 1.0)
    assert_true(after_45 > before_45, "fuel drain must increase after the 45-second commit")

    var fixture: Dictionary = _build_controller(1000.0, 1000.0)
    var controller: Variant = fixture.controller
    var train: Variant = fixture.train
    controller.start()
    controller.advance_time(29.999)
    var speed_before: float = train.speed
    controller.advance_time(0.001)
    controller.advance_time(0.001)
    assert_true(train.speed > speed_before, "speed must increase only after the 30-second commit")
```

`_build_controller()` must use the same fake dependency shapes as existing run-controller tests and return `{ "controller": controller, "train": train }`. No test-only production probe is added.

- [ ] **Step 2: Run RED**

Expected: 45-second drain changes without a corresponding director event and production still uses elapsed-time methods.

- [ ] **Step 3: Switch production calls to the current snapshot**

```gdscript
var snapshot: Variant = _difficulty_director.current_snapshot()
var speed: float = _balance.current_speed_for_snapshot(snapshot, cargo_count, boosting)
var fuel_drain_rate: float = _balance.fuel_drain_rate_for_snapshot(snapshot, boosting)
```

Preserve order:

```text
old snapshot applies through boundary
→ run clock reaches boundary
→ director commits
→ signal emits at matching run time
→ next segment uses new snapshot
```

- [ ] **Step 4: Expand event time consistency**

Record commits at 30, 45, 60, and 90. For every callback, assert observed run time equals `committed_at()` within `0.0001`.

- [ ] **Step 5: Run and commit**

```bash
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tests/run_tests.gd
git add game/run/run_controller.gd tests/run/test_run_controller_pressure_boundaries.gd tests/run/test_run_controller_difficulty_events.gd tests/run_tests.gd
git commit -m "fix: align run pressure changes with difficulty commits"
```

---

### Task 5: Adversarial Regression Gate

**Files:** Modify only Task 1–4 owned files if a test exposes a defect.

- [ ] **Step 1: Add ordered large-delta coverage**

```gdscript
director.reset(30.0, 45.0, 5.0)
var events: Array = director.advance(180.0)
var times: Array[float] = []
for event: Variant in events:
    times.append(event.committed_at())
assert_equal(times, [30.0, 45.0, 60.0, 90.0, 120.0, 135.0, 150.0, 180.0], "ordered unique union boundaries")
```

- [ ] **Step 2: Add pause/reset coverage**

Prove pause advances neither run clock nor schedule, resume has no catch-up, and a fresh/reset director returns snapshot `(0,0,0)` with next boundary 30 seconds.

- [ ] **Step 3: Run repository gates**

```bash
python tools/validate_project_contract.py
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tests/run_tests.gd
```

- [ ] **Step 4: Reject scope or authority regressions**

Reject if balance constants, UI/Scene/Profile/map files change; if a combined boundary emits twice; if `RunController` still calls elapsed-time balance methods; or if pause uses wall time.

- [ ] **Step 5: Open the package PR**

The PR body lists `SX-AUD-007-F87`, `EV-USER-018`, boundary traces, exact-head checks, changed files, rollback by reverting the R1 PR, and explicit `NOT_RUN` evidence.

## Self-Review Result

- Every F87 requirement maps to a task.
- All test examples call existing or explicitly created APIs.
- The invalid production probe example is removed.
- Balance constants and player-facing meaning remain unchanged.
- UI, Profile, map, Scene, and online scope remain excluded.
