# VS03-R1 Difficulty Authority Alignment Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make `DifficultyDirector` the single authoritative owner of every speed/fuel pressure boundary before the first product difficulty presentation is built.

**Architecture:** Keep `RunBalance` as the pure formula owner, but stop letting production code infer hidden schedule changes directly from elapsed time. Add an immutable `DifficultyPressureSnapshot`; make `DifficultyDirector` emit the union of 30-second speed boundaries and 45-second fuel boundaries; make `RunController` calculate speed and fuel drain from the current snapshot. Preserve existing level/event accessors for compatibility while adding snapshot and changed-axis accessors.

**Tech Stack:** Godot 4.7.1, GDScript, repository custom headless runner (`tests/run_tests.gd`), existing `RunController` boundary-sliced loop.

## Global Constraints

- Start only after `VS03-03` is merged and synchronized.
- Finish before `VS03-05A` begins.
- Do not change player-facing balance constants in `RunBalance`.
- Do not add UI, Profile, map, Scene, asset, or online work.
- `DifficultyDirector` owns schedule/forecast/commit; `RunBalance` owns numeric formulas.
- Exact-timestamp consumers must observe the same `RunState.elapsed_seconds()` as the committed event.
- Pause produces no commit and resume performs no wall-clock catch-up.
- Existing 16 suites must remain green.
- Use `func run() -> void`; do not use `run(test)`, `test.case()`, `run_single.gd`, or `--suite`.

---

## File Responsibility Map

### Create

- `game/difficulty/difficulty_pressure_snapshot.gd` — immutable speed/fuel step counts effective at one authoritative time.
- `tests/difficulty/test_difficulty_pressure_schedule.gd` — union-boundary, forecast, combined-boundary, reset coverage.
- `tests/run/test_run_controller_pressure_boundaries.gd` — production consumption and event/run-clock consistency.

### Modify

- `game/difficulty/difficulty_director.gd` — union schedule, current snapshot, next boundary, ordered multi-commit.
- `game/difficulty/difficulty_event.gd` — preserve levels; add snapshots and changed axes.
- `game/difficulty/difficulty_forecast.gd` — preserve current API; add next snapshot and changed axes.
- `game/run/run_balance.gd` — add step/snapshot-based formula entrypoints while retaining compatibility wrappers.
- `game/run/run_controller.gd` — read the director snapshot for speed/drain and keep boundary order.
- `tests/difficulty/test_difficulty_director.gd` — update old 30-second-only assumptions.
- `tests/run/test_run_balance.gd` — prove old wrappers and new step entrypoints agree.
- `tests/run/test_run_controller_difficulty_events.gd` — preserve same-authority time checks with 45/90-second cases.
- `tests/run_tests.gd` — register the two new suites after their scripts exist.

## Interfaces

### `DifficultyPressureSnapshot`

```gdscript
class_name DifficultyPressureSnapshot
extends RefCounted

func _init(speed_step: int, fuel_step: int, effective_at: float) -> void
func speed_step() -> int
func fuel_step() -> int
func effective_at() -> float
func equals(other: Variant) -> bool
```

### `DifficultyDirector`

```gdscript
func reset(
    speed_step_seconds: float = RunBalance.SPEED_STEP_SECONDS,
    fuel_step_seconds: float = RunBalance.FUEL_STEP_SECONDS,
    warning_lead_seconds: float = 5.0
) -> void
func current_snapshot() -> DifficultyPressureSnapshot
func next_snapshot() -> DifficultyPressureSnapshot
func seconds_to_next_boundary() -> float
func forecast() -> DifficultyForecast
func advance(delta_seconds: float) -> Array[DifficultyEvent]
```

`current_level()` remains available and equals the number of committed union boundaries, not either individual step count.

### `RunBalance`

```gdscript
func base_speed_for_step(speed_step: int) -> float
func base_fuel_drain_for_step(fuel_step: int) -> float
func current_speed_for_snapshot(
    snapshot: DifficultyPressureSnapshot,
    cargo_count: int,
    boosting: bool
) -> float
func fuel_drain_rate_for_snapshot(
    snapshot: DifficultyPressureSnapshot,
    boosting: bool
) -> float
```

Existing elapsed-time methods remain compatibility wrappers and must return the same values for the same elapsed time.

---

### Task 1: Add the Immutable Pressure Snapshot

**Files:**
- Create: `game/difficulty/difficulty_pressure_snapshot.gd`
- Test: `tests/difficulty/test_difficulty_pressure_schedule.gd`

**Interfaces:**
- Consumes: integer step counts and authoritative effective time.
- Produces: immutable snapshot consumed by the director, balance, events, forecasts, and run controller.

- [ ] **Step 1: Write the failing snapshot test**

```gdscript
extends "res://tests/test_case.gd"

const SNAPSHOT_PATH := "res://game/difficulty/difficulty_pressure_snapshot.gd"

func run() -> void:
    assert_true(ResourceLoader.exists(SNAPSHOT_PATH, "Script"), "pressure snapshot script must exist")
    if not ResourceLoader.exists(SNAPSHOT_PATH, "Script"):
        return
    var snapshot: Variant = load(SNAPSHOT_PATH).new(2, 1, 90.0)
    assert_equal(snapshot.speed_step(), 2, "snapshot must preserve speed step")
    assert_equal(snapshot.fuel_step(), 1, "snapshot must preserve fuel step")
    assert_almost_equal(snapshot.effective_at(), 90.0, 0.0001, "snapshot must preserve effective time")
    assert_true(snapshot.equals(load(SNAPSHOT_PATH).new(2, 1, 90.0)), "equal snapshots must compare equal")
    assert_false(snapshot.equals(load(SNAPSHOT_PATH).new(3, 1, 90.0)), "different step snapshots must not compare equal")
```

- [ ] **Step 2: Run the full runner and verify RED**

Run:

```bash
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tests/run_tests.gd
```

Expected: existing suites pass; the new suite is not registered yet. Run a temporary branch-only registration commit and expect failure because `difficulty_pressure_snapshot.gd` does not exist.

- [ ] **Step 3: Implement the minimal immutable snapshot**

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
        and absf(other.effective_at() - _effective_at) <= 0.000001
    )
```

- [ ] **Step 4: Register the suite and verify GREEN**

Add:

```gdscript
preload("res://tests/difficulty/test_difficulty_pressure_schedule.gd"),
```

to `TEST_SCRIPTS` only after both files exist. Run the full runner and expect zero failures.

- [ ] **Step 5: Commit**

```bash
git add game/difficulty/difficulty_pressure_snapshot.gd tests/difficulty/test_difficulty_pressure_schedule.gd tests/run_tests.gd
git commit -m "test: define authoritative difficulty pressure snapshots"
```

---

### Task 2: Make DifficultyDirector Own the Union Schedule

**Files:**
- Modify: `game/difficulty/difficulty_director.gd`
- Modify: `game/difficulty/difficulty_event.gd`
- Modify: `game/difficulty/difficulty_forecast.gd`
- Modify: `tests/difficulty/test_difficulty_pressure_schedule.gd`
- Modify: `tests/difficulty/test_difficulty_director.gd`

**Interfaces:**
- Consumes: speed interval 30 seconds, fuel interval 45 seconds, warning lead 5 seconds.
- Produces: ordered commits at 30, 45, 60, 90, 120, 135 seconds and so on.

- [ ] **Step 1: Extend the failing schedule test**

Add assertions equivalent to:

```gdscript
var director: Variant = load("res://game/difficulty/difficulty_director.gd").new()
director.reset(30.0, 45.0, 5.0)
assert_almost_equal(director.seconds_to_next_boundary(), 30.0, 0.0001, "first union boundary must be 30 seconds")
var events: Array = director.advance(90.0)
assert_equal(events.size(), 4, "90 seconds must commit 30, 45, 60, and 90")
assert_almost_equal(events[0].committed_at(), 30.0, 0.0001, "first event time")
assert_equal(events[0].changed_axes(), [&"SPEED"], "30 seconds changes speed only")
assert_almost_equal(events[1].committed_at(), 45.0, 0.0001, "second event time")
assert_equal(events[1].changed_axes(), [&"FUEL"], "45 seconds changes fuel only")
assert_almost_equal(events[3].committed_at(), 90.0, 0.0001, "combined event time")
assert_equal(events[3].changed_axes(), [&"SPEED", &"FUEL"], "90 seconds changes both axes")
assert_equal(director.current_snapshot().speed_step(), 3, "90 seconds must reach speed step three")
assert_equal(director.current_snapshot().fuel_step(), 2, "90 seconds must reach fuel step two")
```

- [ ] **Step 2: Run and verify RED**

Expected failure: current director emits only 30, 60, and 90; event has no `changed_axes()` or snapshots.

- [ ] **Step 3: Implement union-boundary calculation**

Use two next-boundary cursors:

```gdscript
var _next_speed_time: float
var _next_fuel_time: float

func _next_boundary_time() -> float:
    return minf(_next_speed_time, _next_fuel_time)
```

At each boundary:

```gdscript
var commit_time := _next_boundary_time()
var changes_speed := absf(_next_speed_time - commit_time) <= TIME_EPSILON
var changes_fuel := absf(_next_fuel_time - commit_time) <= TIME_EPSILON
var from_snapshot := current_snapshot()
if changes_speed:
    _speed_step += 1
    _next_speed_time += _speed_step_seconds
if changes_fuel:
    _fuel_step += 1
    _next_fuel_time += _fuel_step_seconds
var to_snapshot := DifficultyPressureSnapshotScript.new(_speed_step, _fuel_step, commit_time)
```

Emit one event for a combined boundary, never two events at the same timestamp.

- [ ] **Step 4: Extend event and forecast without breaking old accessors**

`DifficultyEvent` must expose:

```gdscript
func from_snapshot() -> Variant
func to_snapshot() -> Variant
func changed_axes() -> Array[StringName]
```

Keep `from_level()`, `to_level()`, and `committed_at()`.

`DifficultyForecast` must expose:

```gdscript
func from_snapshot() -> Variant
func to_snapshot() -> Variant
func changed_axes() -> Array[StringName]
```

Keep `from_level()`, `to_level()`, `commit_time()`, `seconds_until_commit()`, and `is_within_warning_window()`.

- [ ] **Step 5: Verify forecast behavior**

Add assertions:

```gdscript
director.reset(30.0, 45.0, 5.0)
director.advance(25.0)
var forecast: Variant = director.forecast()
assert_true(forecast.is_within_warning_window(), "30 second boundary must warn at 25 seconds")
assert_equal(forecast.changed_axes(), [&"SPEED"], "first forecast must identify speed")
director.advance(5.0)
forecast = director.forecast()
assert_almost_equal(forecast.commit_time(), 45.0, 0.0001, "next forecast after 30 must target 45")
assert_equal(forecast.changed_axes(), [&"FUEL"], "45 second forecast must identify fuel")
```

- [ ] **Step 6: Run full tests and commit**

```bash
git add game/difficulty tests/difficulty
git commit -m "feat: unify speed and fuel difficulty boundaries"
```

---

### Task 3: Move Production Balance Consumption to Snapshots

**Files:**
- Modify: `game/run/run_balance.gd`
- Modify: `tests/run/test_run_balance.gd`

**Interfaces:**
- Consumes: `DifficultyPressureSnapshot` step counts.
- Produces: the same speed/fuel values as the current elapsed-time formulas.

- [ ] **Step 1: Write failing parity tests**

```gdscript
var balance: Variant = load("res://game/run/run_balance.gd").new()
var snapshot_script: Script = load("res://game/difficulty/difficulty_pressure_snapshot.gd")
var at_90: Variant = snapshot_script.new(3, 2, 90.0)
assert_almost_equal(balance.base_speed_for_step(3), balance.base_speed(90.0), 0.0001, "step speed must match elapsed wrapper")
assert_almost_equal(balance.base_fuel_drain_for_step(2), balance.base_fuel_drain(90.0), 0.0001, "step fuel must match elapsed wrapper")
assert_almost_equal(
    balance.current_speed_for_snapshot(at_90, 4, true),
    balance.current_speed(90.0, 4, true),
    0.0001,
    "snapshot speed must preserve current balance"
)
assert_almost_equal(
    balance.fuel_drain_rate_for_snapshot(at_90, true),
    balance.fuel_drain_rate(90.0, true),
    0.0001,
    "snapshot fuel drain must preserve current balance"
)
```

- [ ] **Step 2: Run and verify RED**

Expected: new methods do not exist.

- [ ] **Step 3: Implement step entrypoints**

```gdscript
func base_speed_for_step(speed_step: int) -> float:
    return minf(SPEED_MAX, SPEED_START + SPEED_STEP_AMOUNT * float(maxi(speed_step, 0)))

func base_fuel_drain_for_step(fuel_step: int) -> float:
    return FUEL_DRAIN_START + FUEL_STEP_AMOUNT * float(maxi(fuel_step, 0))
```

Make the elapsed wrappers delegate to the step functions. Implement snapshot methods by reading `speed_step()` and `fuel_step()`.

- [ ] **Step 4: Run full tests and commit**

```bash
git add game/run/run_balance.gd tests/run/test_run_balance.gd
git commit -m "refactor: consume difficulty pressure snapshots in balance"
```

---

### Task 4: Connect RunController to the Authoritative Snapshot

**Files:**
- Modify: `game/run/run_controller.gd`
- Create: `tests/run/test_run_controller_pressure_boundaries.gd`
- Modify: `tests/run/test_run_controller_difficulty_events.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Consumes: `DifficultyDirector.current_snapshot()` and union `seconds_to_next_boundary()`.
- Produces: speed/fuel changes only after the corresponding committed boundary.

- [ ] **Step 1: Write the failing controller test**

Use fake train/delivery/cargo/input objects matching existing run-controller tests. Record each `set_speed()` value and inspect fuel around boundaries:

```gdscript
controller.advance_time(29.999)
var speed_before_30: float = train.speed
controller.advance_time(0.001)
controller.advance_time(0.001)
assert_true(train.speed > speed_before_30, "speed must change only after the 30 second commit")

var fuel_before_45: float = controller.run_state().fuel()
controller.advance_time(14.998)
var drain_before_45: float = fuel_before_45 - controller.run_state().fuel()
controller.advance_time(0.002)
controller.advance_time(1.0)
var drain_after_45: float = controller.run_state().fuel_at_previous_probe - controller.run_state().fuel()
assert_true(drain_after_45 > drain_before_45, "fuel pressure must increase after the 45 second commit")
```

Do not add a production-only probe to `RunState`; structure the test with one-second windows on separate fresh controllers so the before/after fuel deltas are directly comparable.

- [ ] **Step 2: Verify RED**

Expected: current `RunController` still calls elapsed-time balance methods and 45-second changes are not represented by a director commit.

- [ ] **Step 3: Change RunController calculation calls**

Replace elapsed-time production calls with:

```gdscript
var pressure_snapshot: Variant = _difficulty_director.current_snapshot()
var speed: float = _balance.current_speed_for_snapshot(pressure_snapshot, cargo_count, boosting)
var fuel_drain_rate: float = _balance.fuel_drain_rate_for_snapshot(pressure_snapshot, boosting)
```

Keep segment order:

```text
old snapshot applies through the boundary
→ run clock advances to boundary
→ director commits boundary
→ signal emits with matching run time
→ next segment uses new snapshot
```

- [ ] **Step 4: Expand event-time tests**

Verify commits at 30, 45, 60, and 90 seconds. For every signal callback:

```gdscript
assert_almost_equal(
    observed_run_times[index],
    committed_events[index].committed_at(),
    0.0001,
    "event consumers must observe the authoritative commit time"
)
```

- [ ] **Step 5: Register, run, and commit**

```bash
git add game/run/run_controller.gd tests/run/test_run_controller_pressure_boundaries.gd tests/run/test_run_controller_difficulty_events.gd tests/run_tests.gd
git commit -m "fix: align run pressure changes with difficulty commits"
```

---

### Task 5: Adversarial Boundary and Regression Gate

**Files:**
- Modify only if a test exposes a defect in files already owned by Tasks 1–4.

**Interfaces:**
- Consumes: final branch state.
- Produces: exact-head merge evidence and rollback boundary.

- [ ] **Step 1: Add large-delta ordered commit coverage**

```gdscript
director.reset(30.0, 45.0, 5.0)
var events: Array = director.advance(180.0)
var times: Array[float] = []
for event: Variant in events:
    times.append(event.committed_at())
assert_equal(times, [30.0, 45.0, 60.0, 90.0, 120.0, 135.0, 150.0, 180.0], "large delta must emit ordered unique boundaries")
```

- [ ] **Step 2: Add reset and pause-controller coverage**

Prove:

```text
reset → snapshot (0,0,0)
pause → advance_time produces no run clock or commits
resume → next boundary remains simulation-time based
restart/new controller → schedule returns to 30/45 union origin
```

- [ ] **Step 3: Run all repository checks**

```bash
python tools/validate_project_contract.py
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tests/run_tests.gd
```

Expected: Project Contract PASS, all Godot suites PASS, zero object/resource leaks.

- [ ] **Step 4: Review the exact diff**

Reject the PR if any of the following appears:

```text
balance constants changed
UI/Scene/Profile/map files changed
same timestamp emits separate speed and fuel events
RunBalance elapsed wrappers remain in RunController
presentation code mutates the schedule
pause uses wall clock
```

- [ ] **Step 5: Commit audit fixes and open package PR**

PR body must include:

```text
Finding: SX-AUD-007-F87
Evidence: EV-USER-018
30/45/60/90 boundary traces
exact-head checks
changed-file inventory
rollback: revert VS03-R1 PR as one unit
NOT_RUN: Scene, Android, soak, localization, accessibility, economy simulation, human playtest
```

---

## Self-Review Result

- Spec coverage: all F87 requirements map to Tasks 1–5.
- Placeholder scan: no TBD/TODO/“similar to” steps remain.
- Type consistency: `DifficultyPressureSnapshot`, `current_snapshot()`, `changed_axes()`, and snapshot-based `RunBalance` methods use the same names across tasks.
- Package boundary: no product presentation or Profile work enters VS03-R1.
