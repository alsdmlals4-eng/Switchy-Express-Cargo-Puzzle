# SX-DEC-056 · Route Causality Learning and Result Feedback

Status: `USER_APPROVED · PLANNING_CANON · DELTA_DOR_REVIEWED · IMPLEMENTATION_NOT_AUTHORIZED`

Approved: `2026-08-11 KST`

Delta DoR review: `SX-AUD-051`

Source benchmark: `SX-BMK-001 · BMK-R01/R02/R03/R07`

Product baseline: `GMB-002`

## Decision

Switchy Express는 새 gameplay rule을 추가하지 않고, 이미 승인된 핵심 인과인 `노선 → 화물 조우 순서 → LIFO/TOP → 방문/하역 결과 → 재설계`를 플레이어가 스스로 예측하고 설명할 수 있도록 다음 학습·결과 피드백 구조를 제품 방향으로 승인한다.

1. 내부 feature triage 문장은 `노선을 그리는 순간 화물 스택의 순서가 정해지고, 운행은 그 계획을 실행한다.`로 둔다.
2. BUILD에는 사용자가 요청할 때만 여는 `Route Probe / Encounter Strip`을 둔다.
3. RUN 후에는 실제로 발생한 사건만 보여주는 `Actual Encounter Trace / Debrief`를 둔다.
4. Result에서는 `Fastest / Cheapest / Highest Score` 개인 기록을 서로 독립적으로 유지하고, route fingerprint를 보조 정보로 제공한다.

## 1. Route Probe / Encounter Strip — exact contract

Route Probe는 solver가 아니다. 현재 BUILD 상태의 `MapDefinition + TrackLayout`만 read-only snapshot으로 받고, `FiniteTrackGraphBuilder`가 만드는 finite graph와 그 graph의 기존 `next_cell()` traversal authority를 그대로 사용한다.

### Traversal truth

- 시작 traversal state는 `(previous = definition.incoming_cell, current = definition.start_cell)`이다.
- 실제 RUN과 맞추기 위해 **start cell 자체는 encounter로 소비하지 않고**, `graph.next_cell(start_cell, incoming_cell)`로 계산되는 첫 진입 cell부터 strip에 기록한다.
- BUILD의 route-control 선택값은 TrackLayout piece의 현재 `switch_initial_exit`/crossing 기본 상태를 graph가 구성한 결과를 읽는다.
- Probe는 route-control state를 cycle하거나 mutate하지 않는다.
- 동일 `(previous_cell, current_cell)` directed traversal state가 두 번째 나타나면 `LOOP`로 종료한다. 현재 finite graph에서 route-control state는 Probe 중 고정이므로 이 반복은 이후 suffix도 동일함을 뜻한다.
- `next_cell(current, previous) == current`이면 `DEAD_END`로 종료한다.
- graph construction 자체가 실패하면 `ROUTE_INVALID`로 종료한다.
- correctness는 visited directed-state detection으로 보장한다. 별도 임의 step-count를 제품 의미로 사용하지 않는다. 내부 safety bound를 두더라도 초과는 정상 `LOOP`로 위장하지 않고 `ROUTE_INVALID` 진단으로 처리한다.

### Encounter projection

Probe는 정답 계산이 아니라 경로 위 공간 정보를 투영한다. 각 진입 cell은 하나의 ordered step이며 다음 existing facts만 포함할 수 있다.

- cargo placement identity, if present;
- station identity, if present;
- route-control kind/current selected state, if present;
- cell identity/index.

같은 cell에 여러 요소가 있어도 이를 실제 RUN event timing으로 과장하지 않는다. Encounter Strip은 **cell step bundle**이며 Actual Encounter Trace와 별도 모델이다.

필수 표현:

- 현재 선택 상태를 따라 만나는 cargo/station/route-control을 순서대로 표시;
- cycle은 `LOOP` text+icon;
- 진행 불가 지점은 `DEAD END` text+icon;
- invalid current topology는 `ROUTE INVALID` text+icon;
- TrackLayout/route-control initial selection이 바뀌면 명시적 재요청 또는 열린 Probe refresh에서 같은 snapshot 규칙으로 다시 계산;
- 요청하지 않으면 상시 HUD를 점유하지 않음;
- cargo/station은 기존 color+shape+text redundancy 사용.

금지:

- 최적 노선 또는 developer/recommended layout 사용;
- 정답 switch sequence;
- unload success/failure prediction;
- 최종 unload order 정답;
- 3-star route/threshold delta;
- cargo skip recommendation;
- score/cost optimization;
- solver/witness 호출;
- TrackLayout/route-control/gameplay state mutation;
- 자동 수정·자동 건설.

## 2. Prediction → Execution → Debrief — exact trace contract

승인된 학습 루프:

```text
BUILD
→ request-only Route Probe로 내가 만든 조우 순서를 확인/예측
→ RUN
→ 실제 Stack/TOP/load mode/route-control state를 관찰
→ RESULT
→ Actual Encounter Trace로 실제 사건과 실패/성공 원인을 확인
→ EDIT
→ 같은 문제를 다시 설계
```

Actual Encounter Trace는 별도 append-only observation model이다. 기존 `FiniteDeliveryEvent`를 station/switch/terminal 전부의 의미로 재정의하지 않는다.

### Required trace kinds

```text
PICKUP
STATION_PASS
UNLOAD
ROUTE_CONTROL_CHANGED
TERMINAL
```

`TERMINAL.reason`은 current run authority에서만 `SUCCESS | ROUTE_END | TIME_EXPIRED`를 받는다.

### Required observation fields

```text
event_index
kind
cell
event_time
cargo_type?          # pickup/unload identity when existing truth provides it
station_type?        # station observation only
station_top_before?  # station visit immediately before pop_matching_group
count?               # unload count
route_control_kind?  # SWITCH | CROSSING
route_control_before?
route_control_after?
terminal_reason?
stack_size_after?
```

### Source-of-truth seams

- `FiniteDeliveryLoop.handle_cell_entered()` remains pickup-before-station gameplay authority.
- `Station.try_unload()` already computes station cargo type, `top_before`, `matched`, unloaded items/count. The implementation may preserve these existing observations in a bounded delivery observation payload; it must not rerun or duplicate unload rules in the recorder.
- successful pickup comes only from the existing delivery result where `picked_up == true`.
- `STATION_PASS` exists only when a station was actually entered and existing `try_unload()` result is unmatched/zero-unload.
- `UNLOAD` exists only from actual non-empty unload items.
- route-control change exists only when current `cycle_route_control()` returns accepted/true; merely requesting a locked/invalid control creates no change event.
- terminal is appended exactly once from the current `FiniteRunSummary`/run-controller outcome.
- Retry clears the active attempt recorder and starts a new trace.
- Edit may preserve the previous terminal trace only as immutable Result/Debrief history; it cannot leak into the next run attempt.

허용 인과 설명 예:

```text
A pickup
→ B pickup
→ A station PASS · TOP=B
→ route control changed
→ B unload 1
→ A unload 1
```

금지:

- 발생하지 않은 cargo/station/switch/terminal 사건 합성;
- trace를 다시 시뮬레이션해 실제 event 대신 사용;
- 정답 next action 추천;
- developer solution과 비교한 failure message.

## 3. Three PBs — persistence contract

PB는 map/ruleset namespace 아래 서로 독립적인 record다.

```text
FASTEST
CHEAPEST
HIGHEST_SCORE
```

PB key identity는 최소 다음을 포함한다.

```text
map_id
map_revision
ruleset_version
```

규칙:

- 성공 run만 PB 자격이 있다.
- FASTEST는 더 작은 authoritative completion time만 갱신한다.
- CHEAPEST는 더 작은 sealed TrackLayout build cost만 갱신한다.
- HIGHEST_SCORE는 **별도 authoritative score runtime field가 존재할 때만** 더 큰 score로 갱신한다.
- 세 축은 독립 비교한다. 한 run이 0~3개 PB를 동시에 갱신할 수 있다.
- 동률이면 기존 record를 유지한다. 숨은 composite tiebreaker를 만들지 않는다.
- 실패 run은 어느 PB도 갱신하지 않는다.
- PB write 실패가 현재 run의 success/failure를 바꾸지 않는다.
- unknown/newer persistence schema는 fail-safe하며 current gameplay를 막지 않는다.
- ruleset/map revision이 달라지면 silent cross-compare하지 않는다.
- historical GMB-001 survival/combo profile 계획을 current finite PB schema로 자동 승격하지 않는다.

### Score dependency

현재 main의 finite runtime에는 authoritative `score` field가 없다. `SX-DEC-056`은 새 score 계산식을 만들 권한이 없다.

따라서 구현 sequencing은 다음과 같다.

```text
SX-DEC-056A
Route Probe + Actual Trace/Debrief + FASTEST/CHEAPEST + score-independent Fingerprint
→ delta DoR planning complete
→ implementation still needs separate explicit authority

SX-DEC-056B
HIGHEST_SCORE + score/max-combo fingerprint extensions
→ BLOCKED until existing approved score/combo authority exposes authoritative runtime truth
→ no guessed score formula allowed
```

`SX-DEC-033`의 별·기록/score 실행 authority와 `SX-DEC-032`의 Combo authority를 침범하지 않는다.

## 4. Route Fingerprint v1 — exact non-ranking fields

056A에서 허용되는 v1 fields:

- `track_cost`: sealed TrackLayout `build_cost()`;
- `completion_time`: successful `FiniteRunSummary.completion_time`;
- `rail_tile_count`: sealed layout piece count;
- `switch_count`: sealed layout에서 geometry `SWITCH` piece 수;
- `route_control_change_count`: RUN 중 `cycle_route_control()`이 실제 accepted/true였던 횟수(SWITCH/CROSSING 합계);
- `station_revisit_count`: 같은 station cell의 두 번째 이후 실제 진입 횟수;
- `max_stack_depth`: 각 actual pickup 직후, station unload 전 stack size의 최대값;
- `cargo_type_transition_count`: actual successful pickup 시 push 직전 TOP이 비어 있지 않고 새 cargo type과 달랐던 횟수;
- `pause_count`: RUN/UNLOADING에서 `FiniteRunController.pause()`가 실제 true를 반환한 user-originated pause 횟수.

056A에서 금지/보류:

- `score`: authoritative finite score runtime truth가 생길 때까지 없음;
- `max_combo`: authoritative readable combo metric이 생길 때까지 없음;
- optimality, developer solution delta, global percentile, hidden efficiency score.

Fingerprint는 PB metadata/회고용 snapshot일 뿐 gameplay 계산으로 다시 입력하지 않는다.

## 5. No-solution-leakage contract

Automated tests는 최소 다음을 강제한다.

1. Probe public API는 developer/recommended solution, solver, 3-star route를 input으로 받지 않는다.
2. 같은 MapDefinition+TrackLayout snapshot은 동일 Probe snapshot을 만든다.
3. unselected branch의 encounter는 출력에 나타나지 않는다.
4. recommended-layout fixture를 바꿔도 동일 player snapshot Probe 결과는 변하지 않는다.
5. Probe 전후 TrackLayout signature, route-control state, stack, score/time/run phase는 불변이다.
6. malformed topology는 `ROUTE_INVALID` 또는 `DEAD_END`로 종료하며 state를 mutate하지 않는다.
7. output schema에는 `optimal/recommended/correct/best_route/star_solution` authority field가 없다.
8. Trace는 실제 accepted event만 append하며 Retry attempt 사이에 섞이지 않는다.
9. PB store는 developer solution/witness를 저장하지 않는다.

## 6. Accessibility / human validation

- Encounter Strip cargo/station identity는 color+shape+text redundancy를 재사용한다.
- LOOP/DEAD END/ROUTE INVALID는 text+shape/icon으로 중복 표현한다.
- Reduced Motion에서는 같은 정보 key를 static presentation으로 보여준다.
- `PLAYTEST_PLAN.md`의 conditional FS-13~15를 056 player-facing build에서 활성화한다.
- Five-person comprehension은 기존 최소 5명/4-of-5 threshold를 유지한다.

## 7. Protected boundaries

이 Decision은 다음을 변경하지 않는다.

- unlimited cargo LIFO;
- manual/auto load;
- contiguous TOP unload;
- route-control input/lock/cycle/U-turn authority;
- free build + piece cost + full refund;
- time/success/failure/scoring rules;
- pause 허용;
- map content;
- save/ruleset identity semantics;
- semantic asset provenance;
- SX-DEC-055 implementation package.

## 8. Delta DoR result / authority boundary

`SX-AUD-051`의 결과:

```yaml
route_probe_contract: READY_PLANNING
actual_trace_debrief_contract: READY_PLANNING
fastest_cheapest_pb_contract: READY_PLANNING
fingerprint_v1_score_independent: READY_PLANNING
highest_score_pb: BLOCKED_BY_AUTHORITATIVE_SCORE_RUNTIME
score_max_combo_fingerprint: BLOCKED_BY_AUTHORITATIVE_RUNTIME_METRICS
sx_dec_056a_delta_dor: PASS_PLANNING
sx_dec_056b_delta_dor: BLOCKED_DEPENDENCY
implementation_authority: NOT_GRANTED
phase_b_build_authority_scope: SX-DEC-055_ONLY
```

- SX-DEC-055 first implementation step는 계속 `Task 1 / Step 1.1 RED`다.
- 056A planning PASS는 구현 승인을 뜻하지 않는다.
- 056B는 기존 approved score/combo runtime truth가 생기기 전 구현할 수 없다.
- Phase C는 사용자 선택으로 여전히 일시 보류 중이다.
