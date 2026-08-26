# First Session Stage Content Spec V1

```yaml
owner_decision: SX-DEC-059 · AMENDED_BY_SX_DEC_060
approval_dependency: GM-SX059-01 · CLOSED · A_SELECTED
status: IMPLEMENTED_AUTOMATED · FIVE_PASS_REVIEW_CLOSED
product_core: GMB-002
map_schema: FiniteMapDefinition v2 historical bytes preserved · active first-session maps migrated to schema v3 for SX-DEC-060 runtime
new_tutorial_map_count: 5_IMPLEMENTED
capstone: VS_DEMO_01 · REUSE_CURRENT
```

이 문서는 **콘텐츠 의도·구조·완료 조건과 구현 중 검증된 보정**을 잠근다. 실제 좌표·JSON·private witness는 RED-first map validation으로 작성·검증됐다.

## 공통 제작 규칙

1. 각 lesson은 새 핵심 개념 1개만 추가한다.
2. 새 개념을 배우기 전에 기존 개념을 동시에 더 어렵게 만들지 않는다.
3. 실패를 강제하지 않는다. 실패가 발생하면 current finite result만 사용한다.
4. Tutorial-only gameplay rule을 만들지 않는다.
5. cargo/station 정보는 color + shape + text redundancy.
6. 현재 73 semantic production assets를 우선 재사용한다.
7. P0/P1 학습 blocker만 첫 Slice에 포함하고 장식성 P3는 보류한다.
8. 각 map은 최소 하나의 deterministic success witness를 테스트 전용으로 보유할 수 있으나 player-facing solver로 노출하지 않는다.
9. 해당 lesson에서 숨긴 command는 StagePolicy가 keyboard/touch 포함 모든 input path에서 차단한다.
10. 시간/보드 크기/비용은 아래 `TEST_VALUE` 범위에서 튜닝하며 product rule이 아니다.

---

## MAP-01 · T1 + T2 Shared · `TRACK_TO_DELIVERY`

### T1 · 기본 선로 연결

```yaml
lesson_id: T1
learning_goal: TRACK_CONNECTION
phase: BUILD_ONLY
completion_evidence: PREFLIGHT_PASS
recommended_time: 45~60s
board_complexity: VERY_LOW
new_tools: STRAIGHT + CURVE
```

### 구조

- Start 1개.
- Cargo A 1개.
- Station A 1개.
- 하나의 짧은 굽은 경로가 필요하도록 배치.
- player는 start-reachable RUN component로 cargo exact-cell과 Station A의 상·하·좌·우 service cell 중 하나를 덮어야 preflight PASS. 역 footprint 자체로 진입하거나 대각선으로 배송하지 않는다.
- required cargo/station service에 쓰이지 않는 disconnected rail island는 이 lesson의 preflight blocker가 아니다.
- straight만으로는 자연스럽게 완성되지 않으며 curve 1회 이상 사용 가치가 보여야 한다.
- Switch/Crossing은 사용하지 않는다.
- `권장 배치`는 숨긴다.

### T1 화면

보임:
- board
- start/cargo/station marker
- straight / curve
- rotate / remove / clear
- placement validity / preflight

숨김:
- Stack/TOP
- load/auto
- switch state
- ranking/score/combo

### T1 완료

`PREFLIGHT_PASS` 시 layout을 유지하고 RUN하지 않은 채 T2 Lesson Card로 전환한다.

Player feeling:
> 흩어진 지점을 내가 만든 선로가 하나의 운행 가능한 노선으로 연결했다.

---

### T2 · 화물과 대응 역

```yaml
lesson_id: T2
learning_goal: CARGO_STATION_CAUSALITY
phase: SAME_LAYOUT_RUN
completion_evidence: FINITE_SUCCESS
recommended_time: 45~60s
manual_load_depth: BASIC_PREREQUISITE_ACTION
```

### 구조

T1의 same map / same valid layout을 그대로 사용한다.

Run order의 단순 목표:

```text
Start → Cargo A → Station A cardinal service cell → terminal/open end
```

### 학습

- Cargo A 접근 전 1회 contextual cue: `적재` 입력.
- player가 직접 current manual-load action을 수행해야 pickup.
- Cargo A가 Stack에 들어가는 것을 시맨틱 feedback으로 관찰.
- Station A의 상·하·좌·우 정확히 1칸 service cell을 통과할 때 current automatic unload를 관찰한다.
- Station footprint 직접 통과와 대각선 통과는 배송이 아니라는 것을 같은 cue에서 명시한다.
- 이 stage에서는 cargo를 일부러 skip할 이유가 없다.

### 완료

current finite SUCCESS.

Player feeling:
> 화물 칸을 직접 지나 싣고, 같은 표시 역의 상·하·좌·우 한 칸을 지나면 내려간다.

### SX-DEC-060 T2 continuity

T2의 stage 수, Manual pickup prerequisite, LIFO 이후 학습 순서는 바꾸지 않는다. post-060 schema v3/map migration 뒤에는 다음 한 가지 mental model만 current로 사용한다.

- Cargo: exact-cell Manual / Auto contact.
- Station: 상·하·좌·우 정확히 1칸 service.
- Diagonal / station footprint: no delivery.

---

## MAP-02 · T3 · `LIFO_REVERSE_PLAN`

```yaml
lesson_id: T3
learning_goal: LIFO_TOP
completion_evidence: FINITE_SUCCESS
recommended_time: 60~90s
new_information: STACK_TOP
```

### 핵심 퍼즐

두 cargo A/B와 두 station A/B를 사용한다.

**정답의 핵심은 manual skip이 아니라 BUILD encounter order**다. T4 전에 selective manual load를 요구하지 않는다.

원리:

```text
원하는 하역 순서: A역 → B역
필요 TOP 순서: A → B
따라서 적재 순서: B → A
```

Map은 player가 선로를 어떻게 설계하느냐에 따라 Cargo A/B 조우 순서가 달라질 수 있어야 한다.

### 요구

- A/B 두 화물은 서로 다른 branch 없는 buildable route choice로 조우 순서를 바꿀 수 있어야 한다.
- Station order는 비교적 읽기 쉽게 고정한다.
- shortest-looking route가 반드시 올바른 LIFO order가 아니도록 설계할 수 있으나 과도한 함정은 금지.
- 첫 TOP 필요 시 `TOP부터 내림` 1줄 cue 허용.
- Stack panel의 TOP token을 강조.

### 실패가 자연 발생했을 때

Station mismatch를 상세 추측하지 않고 현재 evidence-safe result를 사용한다. 플레이어는 board + Stack TOP을 보고 Edit layout으로 돌아갈 수 있다.

### 완료 신호

- player가 load order를 BUILD로 바꾸어 SUCCESS.
- 정답 선로 자동 표시 없음.

Player feeling:
> 먼저 내릴 화물을 마지막에 싣도록 선로부터 역산해야 한다.

---

## MAP-03 · T4 · `SKIP_NOW_LOAD_LATER`

```yaml
lesson_id: T4
learning_goal: SELECTIVE_MANUAL_LOAD
completion_evidence: FINITE_SUCCESS
recommended_time: 60~90s
new_choice: DO_NOT_LOAD
runtime_layout: FIXED_FIGURE_EIGHT_STARTER_LAYOUT
```

### 핵심 퍼즐

첫 통과에서 보이는 화물을 모두 싣는 것이 오히려 불리한 상황을 만든다.

구현 보정: 외부 Start에서 진입한 직선/곡선 degree-2 경로만으로는 같은 cargo cell을 재방문할 수 없다. 새 core rule이나 T6 이전 switch 조작을 만들지 않기 위해 first-session sidecar가 검증된 8자형 고정 scaffold를 설치한다. Crossing geometry/control은 이 수업에서 편집·조작 대상으로 노출하지 않고, 플레이어의 선택은 적재/skip에만 집중한다.

권장 인과 패턴:

```text
첫 loop:
Cargo A → Cargo B → Station A

만약 둘 다 적재:
Stack [A, B TOP]
→ A를 먼저 내려야 하는 계획과 충돌

의도:
Cargo A는 적재
Cargo B는 첫 통과에서 SKIP
→ Station A에서 A 하역
→ loop/revisit에서 Cargo B 적재
→ Station B 하역
```

### 요구

- Cargo B는 skip 후 current rule대로 map에 남아 재방문 가능.
- Cargo A/B 모두 동일 route에서 재접근 가능해야 한다.
- 성공을 위해 capacity나 artificial cargo lock을 사용하지 않는다.
- manual input을 누르는 것보다 **놓는 것 / 누르지 않는 것**이 시각적으로 명확해야 한다.
- skipped cargo에는 `남아 있음` 피드백만 주고 실패 경고로 낙인찍지 않는다.

### 완료 신호

player가 최소 한 cargo를 첫 접촉에서 의도적으로 skip하고, 이후 재방문해 적재하여 SUCCESS.

Player feeling:
> 지금 안 싣는 것도 계획이다.

---

## MAP-04 · T5 · `AUTO_ON_SAFE_OFF_DECISION`

```yaml
lesson_id: T5
learning_goal: LOAD_MODE_SWITCHING
completion_evidence: FINITE_SUCCESS
recommended_time: 60~90s
new_tool: AUTO_LOAD_TOGGLE
runtime_layout: FIXED_FIGURE_EIGHT_STARTER_LAYOUT
```

### 핵심 퍼즐

Auto Load를 manual의 상위호환이 아니라 **안전한 구간에서 반복 입력을 줄이는 편의 도구**로 가르친다.

구현 보정: T4와 같은 위상 제약 때문에 검증된 8자형 고정 scaffold를 사용한다. 선로 도구와 route-control overlay는 숨기고, safe cargo 연속 적재 → Auto OFF → 선택 화물 manual pickup이라는 조작 인과만 노출한다.

권장 구조:

```text
SAFE SEGMENT
Cargo A → Cargo A
: 둘 다 싣는 것이 항상 유리
→ AUTO ON이 편함

DECISION SEGMENT
Cargo B가 나타남
: 현재 계획에서는 첫 통과에 B를 싣지 않는 편이 유리
→ AUTO OFF 후 manual 선택
```

### 요구

- Auto를 켜는 이점이 즉시 보이는 연속 cargo 2개 이상.
- 이후 Auto를 끄는 의미가 있는 optional/ordering-sensitive cargo 1개.
- auto state는 text + semantic badge로 즉시 식별.
- auto on/off를 menu가 아니라 RUN에서 직접 전환.
- auto를 한 번도 쓰지 않는 manual-only success witness도 허용한다.
- 하지만 learning goal validation session에서는 auto를 사용해보는 task를 제공한다.

### 완료 신호

- auto를 켜서 safe cargo를 적재.
- 필요 시 auto를 끄고 selective action 수행.
- current finite SUCCESS.

Player feeling:
> 자동 적재는 편하지만, 계획이 필요할 때는 다시 직접 선택해야 한다.

---

## MAP-05 · T6 · `SWITCH_EXECUTION_LOOP`

```yaml
lesson_id: T6
learning_goal: SWITCH_EXECUTION
completion_evidence: FINITE_SUCCESS
recommended_time: 75~105s
new_tool: SWITCH_CONTROL
shipped_lesson: ONE_SWITCH_PRESET_SELECTION
```

### 핵심 퍼즐

한 개의 Switch로 시작하고, 잘못된 initial branch를 읽은 뒤 열차 도착 전에 배송 branch로 바꾼다.

권장 인과:

```text
Approach → Switch(initial wrong branch)
  ├─ Route A: non-delivery branch
  └─ Route B: cargo/station delivery branch

train arrival 전 Route B preselect
→ occupied lock rejects change
→ selection persists
→ delivery success
```

### 요구

- Switch initial direction을 board에서 읽을 수 있어야 한다.
- switch state는 다시 바꿀 때까지 유지.
- 비점유 switch는 train 도착 전 미리 바꿀 수 있음.
- train이 switch cell을 점유할 때 lock semantic을 보여줌.
- 반사신경 타이밍 퍼즐로 만들지 않는다. 충분한 읽기/선택 시간이 있어야 함.
- auto-reset 금지.
- branch state 한 번 변경이 실제 encounter/delivery order에 명확한 영향을 줌.

### 완료 신호

player가 route state를 읽고 최소 1회 유효 switch change를 수행하여 배송 경로를 선택하고 SUCCESS. 한 run에서 두 branch를 모두 사용하려면 추가 junction/loop와 두 번째 인과를 가르쳐야 하므로 release-near 첫 수업에서는 제외한다.

Player feeling:
> BUILD가 계획을 만들고, 분기는 운행 중 그 계획을 실행하는 레버다.

---

## MAP-06 · Capstone · `VS_DEMO_01`

```yaml
lesson_id: CAPSTONE
map_id: VS_DEMO_01
map_revision: 2
status: REUSE_CURRENT_BYTES
recommended_first_attempt: 180~240s
```

현재 map fact:
- board 15×11
- time limit 150 seconds
- RED_STAR station 1 / BLUE_DIAMOND station 1
- RED_STAR cargo 3 / BLUE_DIAMOND cargo 1
- blocked cells 6

### 요구 경험

```text
BUILD freely
→ preflight
→ RUN
→ manual/auto decision
→ Stack TOP 읽기
→ switch 조작
→ delivery result
→ Retry same layout 또는 Edit layout
```

### 보호

- current `VS_DEMO_01` map bytes는 059 planning에서 수정하지 않는다.
- existing recommended layout ALPHA/BETA는 developer/accessibility evidence로 보존.
- 첫 시도에 recommended layout을 자동 적용/노출하지 않는다.
- `권장 배치`를 player-facing first-contact에서 어떻게 취급할지는 first-contact usability 전 별도 QA point로 기록.

---

## Lesson transition contract

```text
T1 preflight pass
→ T2 same-layout run success
→ T3 new map
→ T4 new map
→ T5 new map
→ T6 new map
→ Capstone
```

- T1/T2 전환은 map/layout을 재초기화하지 않는다.
- T2 이후 새 lesson은 fresh authored map + fresh runtime.
- lesson 완료는 전체 campaign progression/save authority가 아니다. Slice session-local progression부터 시작한다.
- later production campaign persistence는 SX-DEC-034 owner와 통합한다.

## Content acceptance gate

구현된 각 tutorial map은 다음 자동 evidence를 RED-first 테스트로 보유한다.

```yaml
schema_valid: required
preflight_success_witness: required
finite_success_witness: T2~T6 required
learning_goal_counterexample: required where meaningful
no_hidden_command_bypass: required
no_tutorial_only_domain_rule: required
same_core_session_controller: required
color_shape_text_redundancy: required
```

Player-experience acceptance는 자동 witness와 별개이며 실제 release-near Slice first-contact evidence 전 `NOT_RUN`이다.
