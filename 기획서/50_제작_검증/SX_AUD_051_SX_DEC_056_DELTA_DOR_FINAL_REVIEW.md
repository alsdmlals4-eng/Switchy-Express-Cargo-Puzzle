# SX-AUD-051 · SX-DEC-056 Delta DoR Final Review

Status: `PLANNING_REVIEW_COMPLETE · 056A_DELTA_DOR_PASS · 056B_BLOCKED_DEPENDENCY · NO_IMPLEMENTATION_AUTHORITY`

Date: `2026-08-11 KST`

Decision: `SX-DEC-056`

Baseline tree before this planning package: PR #148 merge tree `11bcfd89d7c067be89624a56c12e7d27eba5e069`.

Base observation: `315c66eea9614c284b9c11c4d522141065dfa4b0 · REFERENCE_ONLY`; project pin remains `v9.4.3`.

## 1. Review question

Can the user-approved `SX-DEC-056` route-causality package be specified to implementation-ready detail without changing GMB-002 gameplay authority, leaking a solution, or silently inheriting SX-DEC-055 Phase-B BUILD authority?

## 2. Fresh seam inspection

The review re-read current main code instead of relying on prior planning assumptions.

### Route truth

- `FiniteBuildSession.layout_snapshot()` provides the current player TrackLayout as a duplicate.
- `FiniteTrackGraphBuilder` constructs the finite graph from current MapDefinition + TrackLayout.
- `FiniteTrackGraph.next_cell()` is current finite traversal truth.
- `FiniteTrackGraph.route_control_states()` exposes current switch/crossing selection/lock state.
- `FiniteTrackGraph.cycle_route_control()` returns whether a route-control change was accepted.
- `TrainController` configures from `start_cell + incoming_cell`; `cell_entered` begins only after the train commits the next cell.

Conclusion: Route Probe can be a read-only projection with no solver and no movement-authority duplication.

### Delivery/causal truth

- `FiniteDeliveryLoop.handle_cell_entered()` processes pickup before station unload and emits one event for each entered cell.
- `Station.try_unload()` already computes the station type, actual `top_before`, matched state and unloaded items/count.
- current `FiniteDeliveryEvent` preserves pickup/unload but not all station observation details.

Conclusion: Debrief does not need a new station rule. It needs only bounded preservation of observations already computed by current gameplay.

### Run/terminal truth

- `FiniteRunController.pause()` returns whether a pause was actually accepted.
- current route-control calls are centralized in `FiniteSliceSessionController` and can observe the existing `cycle_route_control()` boolean result without a second mutation.
- `FiniteRunSummary` currently exposes outcome/failure/completion-time/time-limit/remaining cargo/stack, but **does not expose score**.

Conclusion: actual terminal/pause/control facts are recordable; score must not be guessed.

### Persistence truth

- current main has no `game/profile` implementation and no current finite PB persistence owner.
- the 2026-08-02 GMB-001 survival/combo profile plan is historical planning and cannot be silently promoted to GMB-002 authority.

Conclusion: 056 may own a bounded finite-puzzle PB schema keyed by map/revision/ruleset, but must not import historical survival/combo records.

## 3. Resolved design decisions

### F173 · Probe start semantics — CLOSED

Problem: a naive path preview could count the configured start cell as the first encounter even though current runtime does not emit a delivery `cell_entered` event for the initial occupied cell.

Resolution:

```text
(previous = incoming_cell, current = start_cell)
→ compute next_cell(current, previous)
→ first predicted encounter is that next entered cell
```

Effect: Probe prediction and actual finite delivery encounter semantics align.

### F174 · Loop semantics — CLOSED

Problem: arbitrary preview length would make LOOP vs truncation ambiguous.

Resolution: Probe route-control state is fixed during projection, so repeated directed `(previous,current)` state is the exact cycle criterion. `next_cell == current` is DEAD_END. Graph build failure is ROUTE_INVALID.

### F175 · Probe vs trace model conflation — CLOSED

Problem: a cell can contain cargo/station/route-control facts, but Route Probe is spatial prediction while Debrief is temporal actual history.

Resolution:

- Probe uses ordered cell-step bundles;
- Trace uses actual event DTOs;
- no shared model that implies fake event timing.

### F176 · Station mismatch evidence — CLOSED

Problem: current event drops `top_before`/matched observation needed for causal `station PASS · TOP=B` feedback.

Resolution: preserve the result of the **existing single** `Station.try_unload()` call in bounded observational fields; recorder must never call/reimplement unload matching.

### F177 · Route-control change evidence — CLOSED

Problem: request != accepted state change, especially when locked.

Resolution: record only when current `cycle_route_control()` returns true; capture before/after from existing route-control state. Locked/invalid/no-op requests produce no trace change.

### F178 · Fingerprint exact v1 — CLOSED

056A v1 is fixed to:

```text
track_cost
completion_time
rail_tile_count
switch_count
route_control_change_count
station_revisit_count
max_stack_depth
cargo_type_transition_count
pause_count
```

`cargo_type_transition_count` means a successful pickup whose push-before TOP was non-empty and a different cargo type. `max_stack_depth` is sampled after successful pickup and before same-cell station unload.

`score` and `max_combo` are excluded from v1 until authoritative runtime metrics exist.

### F179 · PB persistence / tie / namespace — CLOSED

- key: map_id + map_revision + ruleset_version;
- SUCCESS only;
- fastest strict-lower;
- cheapest strict-lower;
- highest score strict-higher only when authoritative score exists;
- ties preserve prior record;
- no hidden composite ranking;
- storage failure cannot change gameplay result;
- historical GMB-001 profile is not migrated as finite PB authority.

### F180 · Highest Score dependency — BLOCKED, NOT A DESIGN AMBIGUITY

Current finite runtime has no authoritative score field. SX-DEC-056 is explicitly prohibited from changing scoring rules.

Resolution:

```text
056A = Route Probe + Trace/Debrief + Fastest/Cheapest + score-independent Fingerprint
     = DELTA_DOR_PASS_PLANNING

056B = Highest Score + score/max_combo fingerprint extension
     = BLOCKED until existing approved score/combo authority exposes runtime truth
```

This is an execution dependency, not permission to invent a formula.

### F181 · No-solution-leakage — CLOSED

Implementation plan requires tests proving:

- no recommended/developer/solver input to Probe;
- unselected branch absent;
- same player snapshot deterministic;
- recommended-layout fixture changes do not affect player Probe;
- no player-state mutation;
- no optimal/correct/star-solution fields;
- actual-only trace;
- PB file contains no solver/developer/recommended route data.

## 4. Implementation plan review

Owner:

`docs/superpowers/plans/2026-08-11-sx-dec-056-route-causality-delta.md`

Plan is split into independent RED→GREEN tasks:

1. pure Route Probe;
2. request-only presenter/HUD integration;
3. preserve existing station/pickup observations;
4. append-only encounter recorder;
5. accepted control/pause/retry/terminal integration;
6. causal Debrief;
7. score-independent Fingerprint v1;
8. finite Fastest/Cheapest PB persistence;
9. Result PB integration;
10. end-to-end solution-leakage/domain-invariance gate.

The plan contains a separate 056B dependency gate and does not implement score/combo.

## 5. Authority check

```yaml
GMB-002_core: UNCHANGED
SX-DEC-055_phase_b_authority: UNCHANGED · SX-DEC-055_ONLY
SX-DEC-056_product_decision: USER_APPROVED
SX-DEC-056A_delta_dor: PASS_PLANNING
SX-DEC-056A_implementation_authority: NOT_GRANTED
SX-DEC-056B: BLOCKED_BY_AUTHORITATIVE_SCORE_COMBO_RUNTIME
SX-DEC-057: USER_APPROVED · DELTA_DOR_PENDING
SX-DEC-058: USER_APPROVED · DELTA_DOR_PENDING
BMK-R09/R10: POST_VALIDATION_HOLD
runtime_change_in_this_package: NONE
physical_device_human: NOT_RUN
production_cutover: BLOCKED_DEFERRED
```

## 6. Connector write incident during planning

During this planning turn, a connector-path check mistakenly created a one-byte root file `x` directly on `main` in commit `f9dbbb062661d0d6b42f073b5846210f9c737801`.

The mistake was immediately repaired by deleting only that file in `6ea1b48706e08e521aab0e144042400eddbdbe82`.

Verification:

```text
restored main tree = 11bcfd89d7c067be89624a56c12e7d27eba5e069
PR #148 merge tree = 11bcfd89d7c067be89624a56c12e7d27eba5e069
```

Therefore repository content was exactly restored before the `planning/sx-dec-056-delta-dor` branch was created. The two operational history commits remain visible and are not misrepresented as product work.

## 7. Final review result

`SX-DEC-056A` has no remaining product/design ambiguity that requires guessing during implementation. Its implementation plan is ready **for a future explicit authority decision**, not for immediate execution.

`SX-DEC-056B` remains intentionally blocked by an upstream runtime-metric dependency. Closing that block requires authoritative finite score/combo runtime truth, not further invention inside 056.

Next planning lane after this package: `SX-DEC-057` delta DoR, then `SX-DEC-058` delta DoR.
