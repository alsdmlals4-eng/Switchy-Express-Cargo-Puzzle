# SX-DEC-056 Route Causality Learning / Result Feedback Design

Status: `USER_APPROVED_DESIGN · IMPLEMENTATION_DEFERRED`

Decision owner: `docs/decisions/SX_DEC_056_ROUTE_CAUSALITY_LEARNING_AND_RESULT_FEEDBACK.md`

## Goal

플레이어가 `선로 → 조우 순서 → LIFO/TOP → 실제 결과 → 재설계` 인과를 정답 힌트 없이 읽고 설명하게 만든다.

## Components

### Route Probe Controller

책임:

- BUILD 상태에서 명시적 사용자 요청을 받는다.
- current TrackLayout + current switch selection을 read-only로 받는다.
- 현재 진행 후보를 deterministic하게 따라간다.
- encounter sequence를 presentation model로 반환한다.

출력 모델 최소형:

```text
RouteProbeSnapshot
- ordered_entries[]
  - type: CARGO | STATION | SWITCH | LOOP | DEAD_END
  - stable_id
  - display_identity
- terminal_reason: LOOP | DEAD_END | TERMINAL | NONE
```

금지:

- solver 호출
- score/cost 최적화
- skip recommendation
- automatic TrackLayout mutation

### Encounter Strip Presenter

책임:

- RouteProbeSnapshot을 아이콘/텍스트 중복 표현으로 표시한다.
- cargo/station identity는 기존 color+shape+text redundancy를 재사용한다.
- LOOP/DEAD END는 색상 단독이 아닌 형태/텍스트로도 구분한다.
- 닫으면 persistent screen space를 차지하지 않는다.

### Run Encounter Recorder

책임:

- 실제 RUN에서 이미 발생한 domain/presentation 결과를 append-only trace로 기록한다.
- 발생하지 않은 사건을 추론해 추가하지 않는다.
- Retry 시작 시 새 run trace를 시작한다.
- Edit 전환 시 직전 trace는 Result/Debrief용으로만 유지한다.

최소 event classes:

- cargo encountered
- cargo picked up
- station encountered
- station pass with observed TOP mismatch
- unload group
- switch selection/branch execution
- terminal success/failure reason

실제 구현에서 기존 seam으로 관찰 가능한 event만 사용한다. 새 gameplay rule을 만들지 않는다.

### Debrief Presenter

책임:

- trace를 시간순으로 보여준다.
- 실패 원인 문구는 실제 recorded state로부터만 만든다.
- 정답 next action을 추천하지 않는다.

### Personal Best Store Extension

세 기록은 독립 key로 관리한다.

```text
FASTEST
CHEAPEST
HIGHEST_SCORE
```

각 PB record는 해당 attempt의 route fingerprint snapshot을 함께 참조할 수 있다.

### Route Fingerprint Builder

입력은 completed attempt의 read-only result/trace/layout 데이터다.

필드:

- track_cost
- completion_time
- score
- rail_tile_count
- switch_count
- switch_change_count
- station_revisit_count
- max_stack_depth
- cargo_type_transition_count
- max_combo
- pause_count

Fingerprint는 gameplay 계산에 재입력하지 않는다.

## Data flow

```text
BUILD state
→ Route Probe Controller
→ RouteProbeSnapshot
→ Encounter Strip

RUN existing truth
→ Run Encounter Recorder
→ EncounterTrace
→ Result/Debrief
→ Fingerprint Builder
→ PB record metadata
```

## Error handling

- invalid/missing route state: Probe를 crash시키지 않고 unavailable/dead-end presentation으로 종료한다.
- unknown display identity: 기존 fallback text/semantic redundancy를 사용한다.
- trace event에 필요한 field가 없으면 해당 optional detail을 생략하고 사건 자체를 조작하지 않는다.
- PB write 실패는 current run success/failure를 바꾸지 않는다.

## UX rules

- Route Probe는 request-only.
- Debrief는 Result에서 접근 가능.
- 핵심 failure cause는 한 줄 summary + trace detail 구조를 권장한다.
- 개발자 best route / global best route / solver witness는 노출하지 않는다.

## Validation

Automated contract candidates:

1. 동일 layout/switch state는 동일 RouteProbeSnapshot.
2. switch selection 변경은 영향받는 suffix만 달라진다.
3. cycle은 무한 loop 없이 LOOP terminal로 끝난다.
4. dead end는 crash 없이 DEAD_END terminal.
5. trace는 실제 event 순서를 보존한다.
6. 존재하지 않은 pickup/unload를 합성하지 않는다.
7. FASTEST/CHEAPEST/HIGHEST_SCORE가 서로 독립 갱신된다.
8. Fingerprint 계산이 gameplay state를 mutate하지 않는다.

Human contract candidates:

- probe 사용 후 다음 3~4 encounter를 사전 예측할 수 있는가.
- station pass 뒤 `TOP mismatch` 인과를 스스로 설명하는가.
- 실패 후 정답 제시 없이 수정할 rail/load/switch 지점을 선택하는가.

## Scope boundary

이 spec은 `SX-DEC-055` 구현 계획에 삽입하지 않는다. 구현 전 별도 delta DoR가 필요하다.
