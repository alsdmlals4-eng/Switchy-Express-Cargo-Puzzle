# SX-DEC-056A Route Causality / Debrief Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking. Apply superpowers:test-driven-development to every production-code task and superpowers:verification-before-completion before any PASS claim.

**Goal:** Implement the implementation-ready SX-DEC-056A subset: request-only current-route prediction, actual-event-only debrief, score-independent route fingerprint v1, and independent Fastest/Cheapest PB persistence without changing finite gameplay authority or revealing solutions.

**Architecture:** Build Route Probe from a duplicate `MapDefinition + TrackLayout` using the existing `FiniteTrackGraphBuilder/FiniteTrackGraph.next_cell()` authority. Preserve already-computed station/pickup observations on the existing delivery seam, record accepted route-control/pause/terminal facts in a separate append-only recorder, then derive Debrief/Fingerprint/PB metadata from immutable attempt history. Keep `HIGHEST_SCORE` reserved but inactive until existing score authority exposes a finite runtime field; do not invent score or combo rules.

**Tech Stack:** Godot 4.7.1-stable, GDScript, existing finite domain/presentation classes, `FileAccess` + JSON for bounded PB persistence, repository custom headless runner (`res://tests/run_tests.gd`), GitHub Actions Project Contract/GUT/Godot/Thin.

## Global Constraints

- Decision authority: `SX-DEC-056`; exact design: `docs/superpowers/specs/2026-08-11-route-causality-learning-result-feedback-design.md`.
- Delta DoR owner: `SX-AUD-051`.
- This plan covers `SX-DEC-056A` only. `SX-DEC-056B` Highest Score and score/max-combo fingerprint extension remains blocked until authoritative score/combo runtime truth exists.
- Implementation authority is **not granted by this plan**. Phase-B BUILD authority remains `SX-DEC-055_ONLY` until a later explicit implementation authorization for 056A.
- Do not insert these tasks into the existing SX-DEC-055 plan.
- No changes to LIFO, load eligibility, pickup order, station pop rules, route-control cycle order, occupied lock, U-turn, time limit, success/failure priority, scoring formula, map content, recommended layout, ruleset identity semantics, or semantic product assets.
- Route Probe must never consume recommended/developer layout, solver/witness, star target, or optimal-route data.
- Actual trace may contain only facts from accepted current events/actions; never reconstruct a run from map state after the fact.
- Existing `FiniteDeliveryEvent` pickup/unload semantics remain compatible; only observational fields already computed by existing gameplay operations may be added.
- Fingerprint v1 is metadata only and must never feed routing, scoring, eligibility, difficulty, or hints.
- Existing accessibility redundancy remains color+shape+text; LOOP/DEAD END/ROUTE INVALID require text+icon/shape.
- Existing human validation thresholds remain unchanged.

## Exact Verification Commands

From repository root:

```bash
godot --headless --path . --script res://tests/run_tests.gd
```

Before merge require final unchanged PR head to pass:

```text
Project Contract
GUT 9.7.1 Tests
Godot Tests (including Switchy real-project live-editor Pilot)
Validate Thin Adapter Migration
```

Do not treat hosted CI as Windows physical runtime, Android device, connected editor, or human PASS.

---

## Planned File Structure

### New route-projection owners

```text
game/finite/route/finite_route_probe_snapshot.gd
    Immutable semantic snapshot for one current player-route projection.

game/finite/route/finite_route_probe.gd
    Pure read-only traversal over a freshly constructed finite graph.
```

### New result/history owners

```text
game/finite/result/finite_encounter_trace_event.gd
    Immutable actual-event DTO.

game/finite/result/finite_run_encounter_recorder.gd
    Append-only per-attempt history + route-control/pause counters.

game/finite/result/finite_route_fingerprint.gd
    Pure score-independent fingerprint v1 builder.
```

### New finite PB persistence owners

```text
game/finite/progress/finite_personal_best_schema.gd
    Versioned finite PB JSON shape and normalization.

game/finite/progress/finite_personal_best_store.gd
    Map/revision/ruleset-namespaced atomic-ish load/update/save.
```

### Existing seams to modify

```text
game/finite/delivery/finite_delivery_event.gd
game/finite/delivery/finite_delivery_loop.gd
game/finite/main/finite_slice_session_controller.gd
game/finite/presentation/finite_slice_presenter.gd
game/demo/presentation/product_hud.gd
game/demo/presentation/product_hud.tscn
game/demo/product_finite_slice.gd
tests/run_tests.gd
```

Do not modify `game/finite/rail/finite_track_graph.gd`, `game/train/train_controller.gd`, or `game/station/station.gd` unless a failing contract proves the current read-only interfaces are insufficient. The plan is designed so they remain authority owners unchanged.

### Focused tests

```text
tests/finite/route/test_finite_route_probe.gd
tests/finite/result/test_finite_run_encounter_recorder.gd
tests/finite/result/test_finite_route_fingerprint.gd
tests/finite/progress/test_finite_personal_best_store.gd
tests/finite/presentation/test_route_probe_debrief_presenter.gd
tests/finite/main/test_sx_dec_056a_session_integration.gd
```

---

### Task 1: Add immutable RouteProbeSnapshot and pure finite traversal

**Files:**
- Create: `tests/finite/route/test_finite_route_probe.gd`
- Modify: `tests/run_tests.gd`
- Create: `game/finite/route/finite_route_probe_snapshot.gd`
- Create: `game/finite/route/finite_route_probe.gd`

**Interfaces:**
- Produces: `FiniteRouteProbe.build(definition: Variant, layout: Variant) -> Variant`
- Produces snapshot getters: `status`, `terminal_reason`, `steps()`.
- Consumes only duplicate `FiniteMapDefinition`/`TrackLayout`; internally calls current `FiniteTrackGraphBuilder.build()` and `FiniteTrackGraph.next_cell()`.

- [ ] **Step 1: Register the new focused test and write the first RED contract**

```gdscript
func test_probe_starts_with_first_entered_cell_not_start_cell() -> void:
    var result := FiniteRouteProbe.build(_definition(), _valid_layout())
    assert_eq(result.status, &"OK")
    assert_false(result.steps().is_empty())
    assert_ne(result.steps()[0].cell, _definition().start_cell)
```

Also register the test file in `tests/run_tests.gd` using the existing custom-suite pattern.

- [ ] **Step 2: Run the custom suite and verify RED**

```bash
godot --headless --path . --script res://tests/run_tests.gd
```

Expected: RED because `FiniteRouteProbe`/snapshot owners do not exist.

- [ ] **Step 3: Implement immutable snapshot owner**

Create `finite_route_probe_snapshot.gd` with constructor shape:

```gdscript
class_name FiniteRouteProbeSnapshot
extends RefCounted

var _status: StringName
var _terminal_reason: StringName
var _steps: Array[Dictionary]

func _init(status: StringName, terminal_reason: StringName, steps: Array[Dictionary]) -> void:
    _status = status
    _terminal_reason = terminal_reason
    _steps = steps.duplicate(true)

func steps() -> Array[Dictionary]:
    return _steps.duplicate(true)
```

Expose read-only getters for `status` and `terminal_reason` using the same immutable property style already used by finite DTOs.

- [ ] **Step 4: Implement the minimal pure traversal**

`FiniteRouteProbe.build()` must:

```gdscript
var graph_result: Dictionary = FiniteTrackGraphBuilder.build(definition, layout)
if not bool(graph_result.get("ok", false)):
    return FiniteRouteProbeSnapshot.new(&"ROUTE_INVALID", &"NONE", [])

var graph: Variant = graph_result["graph"]
var previous: Vector2i = definition.incoming_cell
var current: Vector2i = definition.start_cell
var visited: Dictionary = {}
var steps: Array[Dictionary] = []

while true:
    var key := "%d,%d>%d,%d" % [previous.x, previous.y, current.x, current.y]
    if visited.has(key):
        return FiniteRouteProbeSnapshot.new(&"OK", &"LOOP", steps)
    visited[key] = true

    var next: Vector2i = graph.next_cell(current, previous)
    if next == current:
        return FiniteRouteProbeSnapshot.new(&"OK", &"DEAD_END", steps)

    previous = current
    current = next
    steps.append(_step_for_cell(definition, graph, current, steps.size()))
```

`_step_for_cell` may read only map placements and `graph.route_control_states()`; it must not call `cycle_route_control`.

- [ ] **Step 5: Add deterministic loop/dead-end/invalid tests**

Tests must assert:

```text
same definition/layout → same semantic snapshot
loop → LOOP without step-count truncation
route end → DEAD_END
malformed layout → ROUTE_INVALID
start cell never appears merely because it is the configured start
```

- [ ] **Step 6: Add no-solution-leakage API tests**

The test should instantiate/call Route Probe without any recommended-layout provider and assert every step key belongs to this allow-list:

```gdscript
["index", "cell", "cargo_type", "station_type", "route_control_kind", "route_control_state"]
```

Also assert no output key contains case-insensitive substrings `optimal`, `recommended`, `correct`, `solution`, or `star`.

- [ ] **Step 7: Run suite and verify GREEN**

Run the exact custom suite. Expected: all existing + new route-probe tests PASS.

- [ ] **Step 8: Commit**

```bash
git add tests/finite/route/test_finite_route_probe.gd tests/run_tests.gd game/finite/route/finite_route_probe_snapshot.gd game/finite/route/finite_route_probe.gd
git commit -m "feat: add read-only finite route probe"
```

---

### Task 2: Expose request-only Route Probe through current session/presenter seams

**Files:**
- Modify: `game/finite/main/finite_slice_session_controller.gd`
- Modify: `game/finite/presentation/finite_slice_presenter.gd`
- Modify: `game/demo/presentation/product_hud.gd`
- Modify: `game/demo/presentation/product_hud.tscn`
- Modify: `game/demo/product_finite_slice.gd`
- Create: `tests/finite/presentation/test_route_probe_debrief_presenter.gd`

**Interfaces:**
- New command: `ROUTE_PROBE_TOGGLE`.
- Presenter model fields: `route_probe_visible`, `route_probe_status`, `route_probe_terminal_reason`, `route_probe_steps`.
- Controller owns no persistent solver state; it stores only the latest immutable Probe snapshot while visible.

- [ ] **Step 1: Write RED controller/presenter tests**

Test BUILD-only request behavior:

```gdscript
controller.request_command(&"ROUTE_PROBE_TOGGLE")
var model := controller.model()
assert_true(model.route_probe_visible)
assert_gt(model.route_probe_steps.size(), 0)
```

Then mutate a BUILD piece through existing command path and assert the open Probe recomputes from the new layout signature rather than retaining stale steps.

- [ ] **Step 2: Verify RED with custom suite**

Expected: missing command/model fields.

- [ ] **Step 3: Add controller command and refresh rule**

Rules:

```text
BUILD only
first request opens + computes from _build_session.layout_snapshot()
second request closes + clears visible step model
while open, every successful BUILD layout mutation recomputes from a fresh duplicate snapshot
START closes Probe before run activation
Probe never calls _build_session.begin_run()
```

- [ ] **Step 4: Extend presenter model with neutral empty defaults**

`show_build()` preserves current preflight/status/cost fields and updates Probe fields from controller-provided snapshot. `show_run()` and `show_result()` set `route_probe_visible=false`.

- [ ] **Step 5: Add one request-only HUD control**

Wire a single `Route Probe` button/signal in BUILD only. It must not share the existing recommended-layout action. The recommended layout button remains separate and is never called by Probe.

- [ ] **Step 6: Add accessibility presentation tests**

Assert rendered/model entries include identity label information and terminal text for LOOP/DEAD END/ROUTE INVALID; tests must not depend on color alone.

- [ ] **Step 7: Run suite and verify GREEN**

- [ ] **Step 8: Commit**

```bash
git add game/finite/main/finite_slice_session_controller.gd game/finite/presentation/finite_slice_presenter.gd game/demo/presentation/product_hud.gd game/demo/presentation/product_hud.tscn game/demo/product_finite_slice.gd tests/finite/presentation/test_route_probe_debrief_presenter.gd
git commit -m "feat: expose request-only route probe"
```

---

### Task 3: Preserve existing station/pickup observations without changing delivery rules

**Files:**
- Modify: `game/finite/delivery/finite_delivery_event.gd`
- Modify: `game/finite/delivery/finite_delivery_loop.gd`
- Extend existing delivery-loop tests under the repository's finite delivery test path.

**Interfaces:**
- Add read-only observational fields: `station_present`, `station_type`, `station_top_before`, `station_matched`, `stack_size_after_pickup`, `pickup_top_before`.
- Preserve all current fields and constructor semantics.

- [ ] **Step 1: Write RED observation tests**

Cover three exact cases:

```text
successful pickup with no station → pickup_top_before + stack_size_after_pickup correct
station mismatch → station_present true, station_matched false, station_top_before equals actual TOP
matching unload → station_matched true and existing unloaded_items unchanged
```

- [ ] **Step 2: Run suite and verify RED**

- [ ] **Step 3: Capture pickup observations around the existing push**

Immediately before existing `_cargo_stack.push(candidate)` read `peek()`; immediately after successful push and before station handling read `size()`. Do not change push eligibility or collect order.

- [ ] **Step 4: Preserve the existing `Station.try_unload()` result**

Use the exact returned dictionary from the one existing call. Do not call `try_unload()` a second time and do not reimplement matching logic.

- [ ] **Step 5: Extend `FiniteDeliveryEvent` constructor/read-only getters**

All new fields receive neutral defaults so existing tests/callers remain source-compatible.

- [ ] **Step 6: Run suite and verify GREEN**

- [ ] **Step 7: Commit**

```bash
git add game/finite/delivery/finite_delivery_event.gd game/finite/delivery/finite_delivery_loop.gd tests
git commit -m "feat: preserve finite delivery observations for debrief"
```

---

### Task 4: Add append-only Encounter Trace recorder

**Files:**
- Create: `game/finite/result/finite_encounter_trace_event.gd`
- Create: `game/finite/result/finite_run_encounter_recorder.gd`
- Create: `tests/finite/result/test_finite_run_encounter_recorder.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- `record_delivery_event(event: Variant) -> void`
- `record_route_control_change(cell, kind, before_state, after_state, event_time) -> void`
- `record_pause_accepted() -> void`
- `record_terminal(summary: Variant, cell: Vector2i) -> void`
- `freeze() -> Array`
- metric getters: `route_control_change_count`, `pause_count`, `max_stack_depth`, `cargo_type_transition_count`, `station_revisit_count`.

- [ ] **Step 1: Write RED ordered-event test**

Feed one actual-style delivery observation that contains pickup plus station mismatch and assert output order is:

```text
PICKUP
STATION_PASS
```

Feed matching station result and assert `UNLOAD` instead of `STATION_PASS`.

- [ ] **Step 2: Verify RED**

- [ ] **Step 3: Implement immutable event DTO**

Use constructor arguments for every field and duplicate mutable payloads. No setter may mutate a created event.

- [ ] **Step 4: Implement delivery mapping and metrics**

Rules:

```text
PICKUP iff event.picked_up
STATION_PASS iff station_present && !station_matched
UNLOAD iff unload_count > 0
max_stack_depth from stack_size_after_pickup
cargo transition iff pickup_top_before != empty && pickup_top_before != pickup_type
station revisit increments after first seen station cell
```

- [ ] **Step 5: Implement accepted-action/terminal methods**

`record_terminal` must be idempotent: a second call after terminal freeze adds nothing.

- [ ] **Step 6: Add freeze/mutation tests**

After `freeze()`, attempts to record must not change returned history. Returned arrays/events must not expose mutable recorder internals.

- [ ] **Step 7: Run suite and verify GREEN**

- [ ] **Step 8: Commit**

```bash
git add game/finite/result/finite_encounter_trace_event.gd game/finite/result/finite_run_encounter_recorder.gd tests/finite/result/test_finite_run_encounter_recorder.gd tests/run_tests.gd
git commit -m "feat: record actual finite encounter trace"
```

---

### Task 5: Integrate accepted route-control, pause, retry and terminal facts

**Files:**
- Modify: `game/finite/main/finite_slice_session_controller.gd`
- Create: `tests/finite/main/test_sx_dec_056a_session_integration.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Controller creates one recorder per `_activate_run_session`.
- Exposes `current_encounter_trace() -> Array` and immutable last-result trace/model only for presentation/test readback.

- [ ] **Step 1: Write RED integration tests for locked/no-op route control**

Set up a finite run where a route control is locked. Request a cycle and assert trace change count stays zero. Then cycle an unlocked control and assert exactly one `ROUTE_CONTROL_CHANGED` with before/after current graph states.

- [ ] **Step 2: Write RED retry isolation test**

Generate at least one trace event, call `RETRY_SAME_LAYOUT`, and assert active trace begins empty for the new attempt while solution identity/layout remain preserved by existing factory rules.

- [ ] **Step 3: Verify RED**

- [ ] **Step 4: Wire delivery events to recorder**

In `_on_delivery_event_created`, keep current history/VFX flow and additionally pass the same event to recorder. Do not reorder existing gameplay/presentation calls in a way that changes unload behavior.

- [ ] **Step 5: Wrap existing route-control calls only to observe acceptance**

For both current cycle call sites:

```gdscript
var before := _route_control_state_for_cell(cell)
var changed: bool = _run_session.graph.cycle_route_control(cell)
if changed:
    var after := _route_control_state_for_cell(cell)
    _encounter_recorder.record_route_control_change(cell, kind, before, after, _current_elapsed())
```

No additional cycle call is allowed.

- [ ] **Step 6: Observe accepted pause only**

Change controller wrapper to read the existing boolean result:

```gdscript
if _run_session.run_controller.pause():
    _encounter_recorder.record_pause_accepted()
```

Do not change run-controller pause semantics.

- [ ] **Step 7: Append terminal exactly once**

At the same one-shot branch guarded by `_terminal_emitted`, record terminal from current summary before publishing the immutable result trace.

- [ ] **Step 8: Run suite and verify GREEN**

- [ ] **Step 9: Commit**

```bash
git add game/finite/main/finite_slice_session_controller.gd tests/finite/main/test_sx_dec_056a_session_integration.gd tests/run_tests.gd
git commit -m "feat: integrate actual debrief recording"
```

---

### Task 6: Present causal Debrief without recommendations

**Files:**
- Modify: `game/finite/presentation/finite_slice_presenter.gd`
- Modify: `game/demo/presentation/product_hud.gd`
- Modify: `game/demo/presentation/product_hud.tscn`
- Modify: `tests/finite/presentation/test_route_probe_debrief_presenter.gd`

**Interfaces:**
- Result model fields: `debrief_available`, `debrief_summary`, `debrief_entries`.
- Presenter receives already-frozen trace; it never reads MapDefinition to infer missing events.

- [ ] **Step 1: Write RED causal-copy tests**

Given a recorded `STATION_PASS` with station type A and `station_top_before=B`, assert the model contains a causal message equivalent to `A station passed · TOP was B` and contains no route recommendation field/text.

- [ ] **Step 2: Verify RED**

- [ ] **Step 3: Add pure trace-to-model formatter**

Map only recorded facts. If a detail field is empty, omit that phrase instead of consulting map/solver state.

- [ ] **Step 4: Add Result Debrief disclosure UI**

Debrief is available from Result, collapsed/secondary by default. Retry/Edit controls remain available and retain existing behavior.

- [ ] **Step 5: Add forbidden-copy guard test**

For generated debrief model text, assert no copy contains recommendation verbs/labels established by the design contract such as `optimal route`, `correct switch`, `3-star route`, or `skip cargo`.

- [ ] **Step 6: Run suite and verify GREEN**

- [ ] **Step 7: Commit**

```bash
git add game/finite/presentation/finite_slice_presenter.gd game/demo/presentation/product_hud.gd game/demo/presentation/product_hud.tscn tests/finite/presentation/test_route_probe_debrief_presenter.gd
git commit -m "feat: add actual-event result debrief"
```

---

### Task 7: Build score-independent Route Fingerprint v1

**Files:**
- Create: `game/finite/result/finite_route_fingerprint.gd`
- Create: `tests/finite/result/test_finite_route_fingerprint.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Produces `FiniteRouteFingerprint.build(layout: Variant, summary: Variant, recorder: Variant) -> Dictionary`.
- Requires SUCCESS summary for `completion_time`; caller may still build diagnostic fingerprint for failure only if `completion_time` is omitted/null, but PB persistence must only consume SUCCESS.

- [ ] **Step 1: Write RED exact-field test**

Assert fingerprint keys are exactly:

```gdscript
[
    "fingerprint_schema_version",
    "track_cost",
    "completion_time",
    "rail_tile_count",
    "switch_count",
    "route_control_change_count",
    "station_revisit_count",
    "max_stack_depth",
    "cargo_type_transition_count",
    "pause_count",
]
```

- [ ] **Step 2: Write RED purity test**

Capture layout signature and recorder trace before/after build; assert unchanged.

- [ ] **Step 3: Verify RED**

- [ ] **Step 4: Implement exact calculations**

Use only sealed layout methods, current `FiniteRunSummary.completion_time`, and recorder metric getters. Do not derive score or max combo.

- [ ] **Step 5: Add explicit absence tests**

Assert fingerprint has no `score`, `max_combo`, `optimality`, `developer_solution`, or `star_delta` key.

- [ ] **Step 6: Run suite and verify GREEN**

- [ ] **Step 7: Commit**

```bash
git add game/finite/result/finite_route_fingerprint.gd tests/finite/result/test_finite_route_fingerprint.gd tests/run_tests.gd
git commit -m "feat: build score-independent route fingerprint"
```

---

### Task 8: Add versioned finite Personal Best persistence for Fastest/Cheapest

**Files:**
- Create: `game/finite/progress/finite_personal_best_schema.gd`
- Create: `game/finite/progress/finite_personal_best_store.gd`
- Create: `tests/finite/progress/test_finite_personal_best_store.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- `FinitePersonalBestSchema.create_default() -> Dictionary`
- `FinitePersonalBestSchema.normalize(raw: Variant) -> Dictionary`
- `FinitePersonalBestStore.identity_key(map_id, map_revision, ruleset_version) -> String`
- `apply_success(profile, identity, completion_time, cost, fingerprint, authoritative_score = null) -> Dictionary`
- Disk path constant dedicated to finite PBs, e.g. `user://finite_personal_bests.json`.

- [ ] **Step 1: Write RED schema/default tests**

Default identity record shape must reserve all three independent keys:

```text
fastest = null
cheapest = null
highest_score = null
```

- [ ] **Step 2: Write RED independent-update tests**

Scenario:

```text
existing fastest 40s / cheapest 300
new success 35s / cost 350
→ fastest updates
→ cheapest stays 300
→ highest_score stays null
```

Second scenario: 45s / 250 → only cheapest updates.

- [ ] **Step 3: Write RED tie/failure/namespace tests**

- equal value keeps previous record/fingerprint;
- failed attempt API path never calls PB update;
- map revision or ruleset version produces distinct identity key;
- missing highest score remains null and is not guessed from unload count/time/cost.

- [ ] **Step 4: Verify RED**

- [ ] **Step 5: Implement schema normalization**

Rules:

```text
CURRENT_VERSION = 1
unknown/malformed identity entries repaired or omitted deterministically
unknown newer schema → load result marks update-disabled rather than rewriting it
valid older/current fields preserved
```

- [ ] **Step 6: Implement pure comparison before file I/O**

Comparison must be independently unit-testable. Fastest uses strict `<`; Cheapest strict `<`; optional score uses strict `>` only when caller provides an authoritative numeric score.

- [ ] **Step 7: Implement bounded FileAccess JSON load/save**

Write only the finite PB file. Never read/import historical GMB-001 profile records or recommended-layout data. File error returns a result that preserves gameplay and reports PB persistence failure separately.

- [ ] **Step 8: Run suite and verify GREEN**

- [ ] **Step 9: Commit**

```bash
git add game/finite/progress/finite_personal_best_schema.gd game/finite/progress/finite_personal_best_store.gd tests/finite/progress/test_finite_personal_best_store.gd tests/run_tests.gd
git commit -m "feat: persist finite fastest and cheapest personal bests"
```

---

### Task 9: Wire successful attempt metadata to Result PB display

**Files:**
- Modify: `game/finite/main/finite_slice_session_controller.gd`
- Modify: `game/finite/presentation/finite_slice_presenter.gd`
- Modify: `game/demo/presentation/product_hud.gd`
- Extend: `tests/finite/main/test_sx_dec_056a_session_integration.gd`

**Interfaces:**
- On first terminal SUCCESS only, build fingerprint and apply PB store update.
- Result model fields: `fastest_pb`, `cheapest_pb`, `highest_score_pb_available=false`, `fingerprint`.

- [ ] **Step 1: Write RED success-only PB integration test**

Run a success and assert Fastest/Cheapest update. Run a failure in a separate attempt and assert persisted records unchanged.

- [ ] **Step 2: Write RED independent PB display test**

Assert the model has separate Fastest and Cheapest values and no synthesized global efficiency grade.

- [ ] **Step 3: Verify RED**

- [ ] **Step 4: Integrate on the one-shot terminal path**

Order:

```text
record terminal
freeze trace
build fingerprint
if SUCCESS: compare/write PB
show_result(summary, cost, trace/fingerprint/PB metadata)
emit terminal_reached
```

PB write errors must be represented as non-gameplay metadata and must not alter `summary.outcome`.

- [ ] **Step 5: Present Highest Score as unavailable, not zero**

Until authoritative score exists, do not show `0` as a legitimate PB. Use an unavailable/hidden state according to current Result UI conventions.

- [ ] **Step 6: Run suite and verify GREEN**

- [ ] **Step 7: Commit**

```bash
git add game/finite/main/finite_slice_session_controller.gd game/finite/presentation/finite_slice_presenter.gd game/demo/presentation/product_hud.gd tests/finite/main/test_sx_dec_056a_session_integration.gd
git commit -m "feat: connect finite PB metadata to results"
```

---

### Task 10: Add end-to-end no-solution-leakage and authority regression gate

**Files:**
- Extend: `tests/finite/main/test_sx_dec_056a_session_integration.gd`
- Extend: `tests/finite/route/test_finite_route_probe.gd`
- Extend: `tests/finite/progress/test_finite_personal_best_store.gd`
- Modify: current project-contract test only if the repository already has a canonical freshness pattern for new current-authority docs; do not weaken existing assertions.

**Interfaces:** none; verification gate only.

- [ ] **Step 1: Add recommended-layout independence regression**

Build a player layout directly through `FiniteBuildSession`/controller, capture Probe result, modify only a test double/fixture representing recommended layout, and assert player Probe result unchanged.

- [ ] **Step 2: Add domain invariance regression**

Compare an existing deterministic run with Probe closed vs Probe opened/closed before START. Assert identical:

```text
layout signature
attempt solution identity
actual pickup/unload sequence
terminal outcome/reason
completion time under same deterministic advance steps
```

- [ ] **Step 3: Add state-mutation regression**

Probe invocation must not change any BuildSession layout signature or any passed graph route-control state. Debrief viewing must not change retry identity or run summary.

- [ ] **Step 4: Add persistence content guard**

Serialized PB JSON must not contain strings/keys for `recommended`, `developer_solution`, `solver`, `witness`, or `optimal_route`.

- [ ] **Step 5: Run full custom suite**

```bash
godot --headless --path . --script res://tests/run_tests.gd
```

Expected: PASS.

- [ ] **Step 6: Review `git diff --check` and changed-file scope**

Expected implementation scope is only the listed 056A code/tests/UI surfaces. No map/product asset/semantic manifest/SX-DEC-055 task modification.

- [ ] **Step 7: Commit**

```bash
git add tests
git commit -m "test: lock SX-DEC-056A solution-leakage boundaries"
```

---

## SX-DEC-056B Dependency Gate

Do **not** implement a score formula in this plan.

056B may begin only when fresh current canon/code prove both:

```text
1. an authoritative finite run score field exists under the approved score/record authority;
2. if max_combo is included, an authoritative presentation/read-only combo metric exists under current Combo authority.
```

At that point create a new scoped delta plan that:

- consumes those fields read-only;
- activates `highest_score` strict-higher comparison;
- versions fingerprint schema rather than silently changing v1;
- proves Fastest/Cheapest history is preserved;
- adds no new score/combo calculation.

## Self-Review Results

- Spec coverage: Route Probe, LOOP/DEAD_END/INVALID, request-only UX, actual trace, station TOP mismatch, accepted route-control changes, pause count, Retry isolation, Debrief, fingerprint v1, Fastest/Cheapest PB, persistence namespace, no-solution-leakage, accessibility, and 056B dependency are each mapped to a task.
- Placeholder scan: no implementation step requires an undefined TODO/TBD. Score/max-combo are explicitly blocked dependencies, not placeholders.
- Type consistency: Probe uses `definition/layout -> snapshot`; recorder owns metrics consumed by fingerprint; PB store consumes only SUCCESS result values/fingerprint; Result presentation consumes frozen metadata.

## Execution Handoff

Plan complete at `docs/superpowers/plans/2026-08-11-sx-dec-056-route-causality-delta.md`.

Execution is intentionally **not started**. A later explicit implementation authority for SX-DEC-056A is required, and the already-authorized SX-DEC-055 Task 1 / Step 1.1 RED remains the first legitimate Phase C build action while current authority is unchanged.
