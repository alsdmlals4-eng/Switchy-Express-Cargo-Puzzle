# SX-DEC-056 Route Causality Learning / Result Feedback Design

Status: `USER_APPROVED_DESIGN · DELTA_DOR_REVIEWED · IMPLEMENTATION_NOT_AUTHORIZED`

Decision owner: `docs/decisions/SX_DEC_056_ROUTE_CAUSALITY_LEARNING_AND_RESULT_FEEDBACK.md`

Delta DoR audit: `기획서/50_제작_검증/SX_AUD_051_SX_DEC_056_DELTA_DOR_FINAL_REVIEW.md`

Implementation plan: `docs/superpowers/plans/2026-08-11-sx-dec-056-route-causality-delta.md`

## Goal

플레이어가 `선로 → 조우 순서 → LIFO/TOP → 실제 결과 → 재설계` 인과를 정답 힌트 없이 읽고 설명하게 만든다. 구현은 기존 finite graph/delivery/run truth를 관찰·투영하며 새 승패·적재·하역·점수 규칙을 만들지 않는다.

## Architecture summary

```text
BUILD MapDefinition + TrackLayout snapshot
→ FiniteTrackGraphBuilder
→ read-only FiniteRouteProbe
→ RouteProbeSnapshot
→ request-only Encounter Strip

RUN existing accepted actions/events
→ bounded observation fields on existing delivery seam
→ FiniteRunEncounterRecorder
→ immutable EncounterTrace
→ Debrief
→ score-independent Fingerprint v1
→ Fastest/Cheapest PB metadata

future authoritative score/combo runtime truth
→ 056B Highest Score / score+max_combo fingerprint activation
```

Route Probe와 Actual Trace는 반드시 다른 모델이다. Probe는 현재 player route의 spatial prediction이며, Trace는 실제 run에서 이미 발생한 event의 historical record다.

## 1. Route Probe Controller

### File owner

Planned new owner: `game/finite/route/finite_route_probe.gd`.

### Inputs

```text
FiniteMapDefinition definition
TrackLayout layout_snapshot
```

Input은 caller가 이미 duplicate한 read-only snapshot이어야 한다. Probe public API는 recommended layout, developer solution, solver, score target을 받지 않는다.

### Graph construction

`FiniteTrackGraphBuilder.build(definition, layout_snapshot)`을 사용한다. `PreflightValidator` 전체 PASS는 요구하지 않는다. 이유는 player가 아직 모든 station/cargo reachability를 완성하지 않은 BUILD 상태에서도 현재 자신이 만든 경로가 어디로 가는지 읽을 수 있어야 하기 때문이다.

단, graph builder가 구조 자체를 만들 수 없는 topology이면 `ROUTE_INVALID`이다.

### Traversal algorithm

```text
previous = definition.incoming_cell
current  = definition.start_cell
visited_directed_states = {}

loop:
  state = (previous, current)
  if state already visited:
      terminal = LOOP
      stop
  add state

  next = graph.next_cell(current, previous)
  if next == current:
      terminal = DEAD_END
      stop

  previous = current
  current = next
  append current as the next predicted entered-cell step
```

Start cell은 actual `TrainController`가 initial configure 시 이미 점유하고 있고 `cell_entered` delivery event를 발생시키지 않으므로 Encounter Strip의 first encounter step으로 취급하지 않는다.

Probe 중 route-control state를 변경하지 않는다. BUILD layout의 `switch_initial_exit`와 finite graph가 생성한 current crossing/default state를 그대로 읽는다.

### Loop correctness

현재 Probe는 route-control state가 traversal 중 고정이므로 directed `(previous,current)` repeat가 같은 future suffix의 반복을 뜻한다. arbitrary `step_count` truncation을 정상 LOOP 판정으로 사용하지 않는다.

안전용 upper bound가 필요하면 graph의 finite directed-state 수보다 큰 진단 bound만 사용하고, 초과는 `ROUTE_INVALID`로 취급한다.

## 2. RouteProbeSnapshot

Planned owner: `game/finite/route/finite_route_probe_snapshot.gd`.

```text
RouteProbeSnapshot
- status: OK | ROUTE_INVALID
- terminal_reason: LOOP | DEAD_END | NONE
- steps[]
  - index
  - cell
  - cargo_type?          # placement fact only
  - station_type?        # placement fact only
  - route_control_kind?  # SWITCH | CROSSING
  - route_control_state? # current selected state only
```

`steps[]`는 execution event list가 아니라 ordered entered-cell bundles다. 같은 cell에 cargo/station/control이 같이 있어도 temporal event 순서를 추론하지 않는다.

### Forbidden output fields

다음 의미의 field를 만들지 않는다.

```text
optimal_*
recommended_*
correct_*
best_route_*
star_solution_*
unload_answer_*
skip_recommendation_*
```

## 3. Encounter Strip Presenter

Presentation owner는 기존 finite presenter/HUD 구조에 얇게 추가한다.

Responsibilities:

- BUILD에서 explicit `ROUTE_PROBE` request가 있을 때만 snapshot을 표시;
- cargo/station identity는 기존 `CargoType` color+shape+text redundancy 사용;
- route-control은 current selected state만 표현;
- LOOP / DEAD END / ROUTE INVALID를 text+icon으로 표시;
- close 후 persistent HUD footprint 제거;
- Reduced Motion에서도 동일 정보 key를 static 표현.

Probe open 상태에서 layout signature가 바뀌면 stale snapshot을 유지하지 않는다. 두 허용 UX 중 구현 계획은 **즉시 재계산**을 선택한다. 재계산은 새 duplicate snapshot을 입력으로 하고 이전 snapshot을 mutate하지 않는다.

## 4. Actual Run Observation Seam

### Existing truth

현재 `FiniteDeliveryLoop.handle_cell_entered()`는 실제 entered cell마다 한 `FiniteDeliveryEvent`를 만든다. pickup은 station unload보다 먼저 처리된다.

현재 `Station.try_unload()`는 다음 관찰 사실을 이미 계산한다.

```text
station_cell
cargo_type
top_before
matched
items
count
unload_order_before
unload_order_after
```

현재 `FiniteDeliveryEvent`는 이 station detail을 보존하지 않는다. 056A는 **게임 규칙을 복제하지 않고 이미 계산된 observation을 event payload에 보존하는 최소 확장**만 허용한다.

### Bounded FiniteDeliveryEvent additions

Planned observational fields:

```text
station_present: bool
station_type: StringName
station_top_before: StringName
station_matched: bool
stack_size_after_pickup: int
pickup_top_before: StringName
```

기존 pickup/unload fields와 semantics는 변경하지 않는다.

- `stack_size_after_pickup`은 pickup 성공 직후, station unload 전에 관찰한다.
- `pickup_top_before`는 push 직전 실제 TOP이다.
- station detail은 같은 `try_unload()` 호출의 returned Dictionary에서 복사한다.

## 5. FiniteRunEncounterRecorder

Planned owner: `game/finite/result/finite_run_encounter_recorder.gd`.

Recorder는 append-only이며 gameplay 계산에 사용되지 않는다.

### Trace kinds

```text
PICKUP
STATION_PASS
UNLOAD
ROUTE_CONTROL_CHANGED
TERMINAL
```

### Trace DTO

Planned owner: `game/finite/result/finite_encounter_trace_event.gd`.

```text
FiniteEncounterTraceEvent
- event_index: int
- kind: StringName
- cell: Vector2i
- event_time: float
- cargo_type: StringName
- station_type: StringName
- station_top_before: StringName
- count: int
- route_control_kind: StringName
- route_control_before: Variant
- route_control_after: Variant
- terminal_reason: StringName
- stack_size_after: int
```

Optional fields use neutral empty defaults. DTO is immutable after creation.

### Delivery observation mapping

For one actual `FiniteDeliveryEvent`:

1. if `picked_up == true`, append `PICKUP`;
2. if `station_present == true` and `station_matched == false`, append `STATION_PASS`;
3. if `unload_count > 0`, append `UNLOAD`.

This preserves actual pickup-before-station semantics.

### Route-control mapping

Current session controller has two run paths that call `graph.cycle_route_control(cell)`: direct board-cell route input and the explicit `SWITCH` command path.

Implementation must:

1. capture route-control state for the target cell before request;
2. call existing `cycle_route_control()` exactly once;
3. append `ROUTE_CONTROL_CHANGED` only if it returns `true`;
4. capture after-state from existing `route_control_states()`;
5. never append on locked/invalid/no-op requests.

This records actual accepted state change without becoming route authority.

### Pause metric

`pause_count` is recorder metadata, not a visible causal trace event. Increment only when user-originated `_handle_pause()` calls current `FiniteRunController.pause()` and it returns `true`.

### Terminal mapping

When `FiniteRunSummary` first becomes non-null, append exactly one `TERMINAL`.

```text
summary.outcome == SUCCESS → terminal_reason SUCCESS
summary.failure_reason == ROUTE_END → ROUTE_END
summary.failure_reason == TIME_EXPIRED → TIME_EXPIRED
```

No other causal reason is synthesized.

### Lifetime

- new attempt activation → new empty recorder;
- Retry → previous trace frozen, active trace reset for new attempt;
- terminal → freeze current trace;
- Edit → terminal trace can remain in last-result view, but new BUILD/RUN has no active events from prior attempt.

## 6. Debrief Presenter

Debrief consumes only frozen trace DTOs. It may summarize a real state, but cannot recommend a correction.

Allowed examples:

```text
A station passed · TOP was B
Route ended · 2 cargo remain
Time expired · 1 cargo remains on map
```

Not allowed:

```text
Switch East here
Pick B later
Use this 3-star route
```

If optional observational detail is absent, omit that clause; do not infer it from map/solver state after the run.

## 7. Fingerprint v1

Planned owner: `game/finite/result/finite_route_fingerprint.gd`.

### Exact 056A fields

```text
fingerprint_schema_version
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

Definitions:

- `track_cost`: sealed `TrackLayout.build_cost()`;
- `completion_time`: successful `FiniteRunSummary.completion_time`;
- `rail_tile_count`: sealed layout `pieces().size()`;
- `switch_count`: number of sealed pieces whose geometry is `SWITCH`;
- `route_control_change_count`: accepted route-control changes recorded during attempt;
- `station_revisit_count`: actual station visits after first visit to the same cell;
- `max_stack_depth`: max `stack_size_after_pickup` from actual pickup events;
- `cargo_type_transition_count`: successful pickup where `pickup_top_before` is non-empty and differs from picked type;
- `pause_count`: accepted user pause count.

### Deferred fields

`score` and `max_combo` are not part of 056A v1 because current finite runtime exposes no authoritative field for them. They become a versioned fingerprint extension only after the existing approved score/combo owners expose readable runtime truth.

Fingerprint never feeds back into gameplay, eligibility, scoring, routing, or hints.

## 8. PB persistence

Planned owners:

```text
game/finite/progress/finite_personal_best_schema.gd
game/finite/progress/finite_personal_best_store.gd
```

This is a finite-puzzle-specific bounded store. It does not revive the old GMB-001 survival/combo profile plan.

### Namespace

```text
map_id + map_revision + ruleset_version
```

### Schema shape

```text
schema_version
records_by_identity:
  <identity_key>:
    fastest:
      value_seconds
      fingerprint
    cheapest:
      value_cost
      fingerprint
    highest_score:
      value_score | null
      fingerprint | null
```

`highest_score` key is reserved but remains null until authoritative score runtime truth exists.

### Update rules

- only SUCCESS qualifies;
- fastest: strictly lower wins;
- cheapest: strictly lower wins;
- highest score: strictly higher wins only when authoritative score exists;
- tie keeps existing record;
- independent comparisons;
- write error never changes run outcome;
- unknown/newer schema fails closed to PB update but leaves gameplay usable;
- ruleset/map-revision mismatch never silently cross-compares.

## 9. No-solution-leakage tests

Required automated contracts:

1. RouteProbe public API contains no recommended/developer/solver parameter.
2. same definition/layout snapshot → byte-equivalent semantic Probe snapshot.
3. changing recommended-layout fixture does not change Probe output.
4. unselected branch cargo/station absent.
5. Probe leaves input layout signature unchanged.
6. Probe does not change graph route-control state passed by caller; implementation uses a constructed copy.
7. LOOP terminates by directed-state repeat.
8. DEAD_END/ROUTE_INVALID return bounded results without mutation.
9. trace only contains observations from accepted current events/actions.
10. locked route-control request does not produce change trace.
11. Retry attempt trace cannot contain previous attempt events.
12. fingerprint builder is pure and score-independent in v1.
13. PB updates are independent and failed runs do not write.
14. store contains no solver witness/developer route/recommended layout.

## 10. Human validation linkage

When 056A is actually included in an exact acceptance build, activate existing PLAYTEST_PLAN conditional observations:

- FS-13 Route Probe interpretation;
- FS-14 Probe → actual comparison;
- FS-15 Debrief causality.

Existing minimum analyzable first-contact sessions `5`, threshold `4/5`, and FS-01~12/HUM-01~13 meanings remain unchanged.

## 11. Delta DoR outcome

```yaml
056A_route_probe: READY_PLANNING
056A_trace_debrief: READY_PLANNING
056A_fastest_cheapest_pb: READY_PLANNING
056A_fingerprint_v1: READY_PLANNING
056B_highest_score: BLOCKED_BY_AUTHORITATIVE_SCORE_RUNTIME
056B_score_max_combo_fingerprint: BLOCKED_BY_AUTHORITATIVE_RUNTIME_METRICS
implementation_plan: WRITTEN
implementation_authority: NOT_GRANTED
sx_dec_055_phase_b_authority: UNCHANGED · SX-DEC-055_ONLY
```

This spec does not authorize code/content changes and must not be inserted into the already-approved SX-DEC-055 implementation plan.
