# Cargo Pickup Marker Visibility Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make successfully collected map cargo markers disappear immediately while leaving skipped cargo visible and restoring authored markers on retry/fresh attempts.

**Architecture:** Keep authored map placements immutable. `FiniteSliceSessionController` remains the render-snapshot boundary and derives visible cargo placements from the active attempt's `FixedCargoField.remaining_cells()`. `ProductBoardRenderer` remains a pure snapshot consumer.

**Tech Stack:** Godot 4.7.1, GDScript, GUT 9.7.1, GitHub Actions.

## Global Constraints

- Decision authority: `SX-DEC-049`.
- Baseline: `main@21a98f534c4479d710a3ec33972c8eda73ca6805`.
- Base authority: `Base@fa69a77a14f923a756064f6ae151d34cadb374f7`.
- Do not edit `.tscn`, Resource, Theme, Animation, signal wiring, `project.godot`, or binary visual/audio assets.
- Preserve `ProductBoardRenderer` as a snapshot-only consumer.
- Preserve authored `_definition.cargo_placements`; runtime visibility comes from `FixedCargoField.remaining_cells()`.
- TDD order is mandatory: failing focused test first, then minimal production implementation.

---

### Task 1: Add the failing runtime-to-render-snapshot contract

**Files:**
- Create: `tests/gut/integration/test_cargo_pickup_marker_visibility.gd`

**Interfaces:**
- Consumes: `FiniteSliceSessionController.initialize()`, `install_layout_for_test()`, `request_command()`, `advance_time()`, `render_snapshot()`, `delivery_history()`, `active_run_session_for_test()`.
- Consumes: `tests/fixtures/finite/fp_core_solution_alpha.gd` and `tests/fixtures/finite/three_direction_switch_driver.gd`.
- Produces: a focused GUT regression proving the exact `cargo_placements` snapshot behavior required by `SX-DEC-049`.

- [ ] **Step 1: Write the failing GUT test**

Create one integration test that:

```gdscript
extends GutTest

const ControllerScript := preload("res://game/finite/main/finite_slice_session_controller.gd")
const AlphaSolution := preload("res://tests/fixtures/finite/fp_core_solution_alpha.gd")
const SwitchDriver := preload("res://tests/fixtures/finite/three_direction_switch_driver.gd")
const MAP_PATH := "res://data/maps/fp_core_proof_01.json"

func test_pickup_hides_marker_and_retry_restores_authored_markers() -> void:
    var controller: RefCounted = ControllerScript.new()
    assert_true(controller.initialize(MAP_PATH, 4500, 2.0))
    assert_true(controller.install_layout_for_test(AlphaSolution.pieces()))

    var initial: Dictionary = controller.render_snapshot()
    var authored_cargo: Array = initial["cargo_placements"]
    var authored_stations: Array = initial["station_placements"]
    assert_eq(authored_cargo.size(), 4)

    controller.request_command(&"START")
    controller.request_command(&"AUTO_TOGGLE")
    var runtime: Variant = controller.active_run_session_for_test()
    var branch_targets: Dictionary = SwitchDriver.capture_branch_targets(runtime.graph)

    var pickup_event: Variant = null
    for _step: int in range(4000):
        SwitchDriver.prepare_next_switch(runtime, branch_targets)
        controller.advance_time(0.05)
        for event: Variant in controller.delivery_history():
            if event.picked_up:
                pickup_event = event
                break
        if pickup_event != null:
            break

    assert_not_null(pickup_event)
    var after_pickup: Dictionary = controller.render_snapshot()
    assert_eq(after_pickup["cargo_placements"].size(), authored_cargo.size() - 1)
    assert_false(_placement_cells(after_pickup["cargo_placements"]).has(pickup_event.cell))
    assert_eq(after_pickup["station_placements"], authored_stations)

    for _step: int in range(4000):
        var phase: StringName = controller.phase()
        if phase == &"SUCCESS" or phase == &"FAILURE":
            break
        SwitchDriver.prepare_next_switch(runtime, branch_targets)
        controller.advance_time(0.05)

    assert_eq(controller.phase(), &"SUCCESS")
    controller.request_command(&"RETRY_SAME_LAYOUT")
    assert_eq(controller.render_snapshot()["cargo_placements"].size(), authored_cargo.size())
    assert_eq(controller.render_snapshot()["station_placements"], authored_stations)
```

Include a local `_placement_cells()` helper that accepts `Vector2i`, `[x, y]`, or `{x, y}` placement cell shapes and returns `Array[Vector2i]`.

- [ ] **Step 2: Run exact-head GUT via a draft PR and verify RED**

Push/open the draft PR with the test but without production changes. Expected: the focused assertion after first pickup fails because current `_build_render_snapshot()` still copies all authored `cargo_placements`.

The RED evidence is valid only if the failure is the marker-count/cell-visibility assertion, not a parse/setup error.

- [ ] **Step 3: Record RED evidence**

Capture the PR head SHA and failing GUT workflow/check details in the PR body or audit notes before production code is changed.

---

### Task 2: Derive visible cargo from the active runtime field

**Files:**
- Modify: `game/finite/main/finite_slice_session_controller.gd`
- Test: `tests/gut/integration/test_cargo_pickup_marker_visibility.gd`

**Interfaces:**
- Consumes: `_definition.cargo_placements`, `_run_session.delivery_loop.cargo_field()`, `FixedCargoField.remaining_cells()`.
- Produces: `_visible_cargo_placements() -> Array[Dictionary]` used only by `_build_render_snapshot()`.

- [ ] **Step 1: Implement the minimal helper**

Add a focused helper equivalent to:

```gdscript
func _visible_cargo_placements() -> Array[Dictionary]:
    if _definition == null:
        return []
    if _run_session == null:
        return _definition.cargo_placements.duplicate(true)

    var field: Variant = _run_session.delivery_loop.cargo_field()
    if field == null:
        return []
    var remaining: Array[Vector2i] = field.remaining_cells()
    var result: Array[Dictionary] = []
    for placement: Dictionary in _definition.cargo_placements:
        if remaining.has(placement["cell"]):
            result.append(placement.duplicate(true))
    return result
```

Do not mutate `_definition`, the cargo field, renderer, station placements, or delivery semantics.

- [ ] **Step 2: Switch the render snapshot to the helper**

Replace:

```gdscript
snapshot["cargo_placements"] = _definition.cargo_placements.duplicate(true)
```

with:

```gdscript
snapshot["cargo_placements"] = _visible_cargo_placements()
```

- [ ] **Step 3: Verify GREEN on exact head**

Expected focused contract:
- initial BUILD snapshot: 4 authored cargo markers,
- first successful pickup: 3 visible markers and collected cell absent,
- stations unchanged,
- terminal success reached,
- `RETRY_SAME_LAYOUT`: 4 authored cargo markers restored.

Expected full regression: all existing GUT, Godot, Project Contract, Thin Adapter, and applicable product checks remain green.

- [ ] **Step 4: Commit minimal implementation**

Commit only the controller change plus the already-added focused test and plan/design documentation. No Scene/Resource/Theme/signal/project setting/asset changes.

---

### Task 3: Review, evidence, and authority synchronization

**Files:**
- Create or update: `기획서/50_제작_검증/SX_AUD_034_CARGO_PICKUP_MARKER_VISIBILITY_IMPLEMENTATION.md`
- Update after merge: Google Sheet rows carrying `SX-DEC-049`, `VIS-015`, and `CURRENT-14`.

**Interfaces:**
- Consumes: exact PR head SHA, CI run/check results, PR diff.
- Produces: auditable implementation closure while keeping physical F5 after merged-main sync explicitly separate.

- [ ] **Step 1: Review the full PR diff**

Confirm the changed production surface is restricted to `finite_slice_session_controller.gd`; no renderer/domain/map/Scene/Resource/signal/asset authority drift.

- [ ] **Step 2: Verify exact-head checks**

Record exact-head outcomes. Never infer unrun checks. If a check is unavailable, mark it `NOT_RUN` rather than PASS.

- [ ] **Step 3: Write SX-AUD-034**

Record:
- root cause,
- RED evidence,
- implementation head,
- GREEN/regression evidence,
- authority boundaries,
- remaining physical F5 pickup/retry validation.

- [ ] **Step 4: Merge only after review and required automated checks pass**

After merge, re-read main and open PR state, then synchronize the Google Sheet using the same `SX-DEC-049` ID.

- [ ] **Step 5: Leave physical acceptance open**

Final user validation after syncing merged main must confirm:
1. RED star disappears immediately after successful pickup,
2. skipped cargo remains visible,
3. Retry Same Layout restores markers.

Do not mark this physical gate PASS before that user evidence exists.
