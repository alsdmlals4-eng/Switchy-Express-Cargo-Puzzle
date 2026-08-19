# First Session Screen · Content · Data Contract

```yaml
owner_decision: SX-DEC-059
status: PLAN_CURRENT · GM-SX059-01_PENDING · BUILD_NOT_AUTHORIZED
baseline_main: 0a88f707e1e4131ae4372929f2871d2b8a3a74b7
core_authority: GMB-002
runtime_authority: SX-DEC-055
protected_open_pr: "#154 · READ_ONLY"
```

## 1. 목적

첫 세션을 위해 새 finite gameplay domain을 만들지 않는다. 현재 `ProductFiniteSlice`가 이미 `map_path`를 받아 동일 core를 다른 맵에 적용할 수 있다는 점을 재사용하고, Tutorial 진행·정보 노출·문구·허용 입력만 **presentation/onboarding sidecar**가 소유한다.

```text
FirstSessionDirector / StagePolicy   # 신규 onboarding/presentation owner
        ↓ map_path + UI/input policy
ProductFiniteSlice                  # 기존 소비자
        ↓
FiniteSliceSessionController        # 기존 domain authority
```

`FiniteMapDefinition`, LIFO, delivery, timer, route, preflight, result rule은 수정 권위가 아니다.

## 2. 현재 코드에서 재사용 가능한 것

### ProductFiniteSlice

현재 이미:

- `@export_file("*.json") var map_path`
- 기존 finite session controller 초기화
- current HUD / Board / RouteControl
- `SemanticEventOverlay`
- `DemoEffects`
- `DemoAudioDirector`
- Retry same layout / Edit layout

을 묶고 있다.

판정: `REUSE`.

### FiniteMapDefinition schema v2

현재 map data가 이미 소유:

- map id/revision/ruleset
- board/start/incoming
- buildable/blocked cells
- station/cargo placements
- time limit

판정: Tutorial map도 **동일 schema v2 사용**. Tutorial metadata를 map schema에 밀어 넣지 않는다.

### Product HUD / Presenter

현재 이미:

- BUILD preflight status / problem cells / cost
- RUN time
- manual/auto state
- Stack + TOP
- Retry/Edit
- semantic badges

을 갖는다.

판정: 새 HUD 재구축 금지. `StagePolicy`가 progressive disclosure를 적용하는 consumer로 확장한다.

## 3. 새 owner 경계

### `FirstSessionDirector`

책임:
- Tutorial learning-goal 순서
- 현재 lesson / content map
- 다음 lesson 전환
- lesson completion evidence
- contextual copy key
- capstone 진입

비책임:
- cargo/load/LIFO/delivery rule
- track graph/preflight rule
- score/economy/save
- route solver

### `FirstSessionStagePolicy`

책임:
- 어떤 HUD 영역을 노출할지
- 어떤 command를 tutorial 단계에서 허용할지
- 어떤 contextual cue를 보여줄지
- current learning goal을 어떤 semantic element로 강조할지

비책임:
- domain command의 의미 변경
- input 결과 위조
- tutorial-only 성공 규칙으로 finite result를 덮어쓰기

### 정책 적용 위치

```text
HUD touch/button path
+ desktop input path
+ later Android input adapter
→ same StagePolicy allowed-command contract
→ ProductFiniteSlice dispatch boundary
→ existing FiniteSliceSessionController
```

UI에서 버튼만 숨기고 keyboard shortcut은 살아 있는 상태를 금지한다.

## 4. 데이터 분리

권장 경로:

```text
data/first_session/first_session_v1.json
```

이 파일은 gameplay map가 아니라 **onboarding sequence data**다.

권장 schema:

```json
{
  "schema_version": 1,
  "sequence_id": "FIRST_SESSION_V1",
  "lessons": [
    {
      "lesson_id": "T1",
      "map_path": "res://data/maps/tutorial/tut_01_02.json",
      "learning_goal": "TRACK_CONNECTION",
      "completion_evidence": "PREFLIGHT_PASS",
      "objective_key": "SX_TUT_T1_OBJECTIVE",
      "context_key": "SX_TUT_T1_CONTEXT",
      "visible_build_tools": ["STRAIGHT", "CURVE"],
      "allowed_commands": ["BUILD_TOOL", "BOARD_CELL", "ROTATE", "REMOVE", "CLEAR"],
      "stack_visibility": "HIDDEN",
      "load_controls": "HIDDEN",
      "auto_control": "HIDDEN",
      "switch_control": "HIDDEN",
      "result_debrief": "NONE"
    }
  ]
}
```

실제 implementation에서는 hardcoded string보다 enum/StringName validator를 둔다. 위 JSON은 계약 예시이며 BUILD 전 exact schema test를 먼저 만든다.

## 5. Lesson / Map 구조

### 핵심 선택: learning goal과 map을 1:1로 강제하지 않는다

T1과 T2는 **같은 작은 맵을 공유하는 2-phase lesson**을 권장한다.

이유:
- current finite run의 성공은 cargo delivery와 연결돼 있어 cargo/station 없는 별도 T1 run을 만들면 tutorial-only 성공 규칙을 새로 만들게 된다.
- 같은 맵에서 먼저 선로 연결을 완료한 뒤, 그 상태에서 cargo/station 의미와 pickup을 소개하면 domain을 바꾸지 않고 학습 순서를 보존할 수 있다.

```text
T1 · same map BUILD
→ preflight PASS
→ layout 유지
→ T2 cue 활성화
→ RUN
→ cargo pickup / station unload
→ success
```

T1의 성공 감정은 기존 초안의 `열차가 움직였다`에서 **`연결되지 않던 지점이 내가 만든 선로로 하나의 운행 가능한 노선이 됐다`**로 수정한다. 첫 실제 운행 보상은 T2가 담당한다.

### Recommended tutorial map count

```text
MAP-01 · T1 + T2 shared
MAP-02 · T3 LIFO
MAP-03 · T4 selective manual load
MAP-04 · T5 manual vs auto comparison
MAP-05 · T6 switch
MAP-06 · VS_DEMO_01 existing capstone
```

6개 lesson + capstone이지만 신규 tutorial map은 **5개**면 충분하다.

## 6. T1 · Track Connection

```yaml
map: MAP-01 shared with T2
phase: BUILD_ONLY_LESSON
learning_goal: TRACK_CONNECTION
completion_evidence: PREFLIGHT_PASS
build_tools: [STRAIGHT, CURVE]
run_action: LOCKED_UNTIL_T2
recommended_time: 45~60s
```

콘텐츠 제약:
- board는 capstone보다 훨씬 작게.
- cargo 1 / matching station 1은 map에 존재하되 T1 정보 위계의 1차 대상이 아님.
- start→cargo→station을 모두 연결해야 preflight가 PASS하도록 배치.
- crossing/switch/recommended-layout button 숨김.
- 최소 1회 curve 선택이 자연스럽게 필요하도록 지형을 둔다.
- 실패는 `연결이 안 됨`이라는 구조적 피드백만 사용.

T1에서 설명하지 않음:
- TOP
- manual/auto 전략
- switch
- combo
- cost optimization

## 7. T2 · Cargo → Station

```yaml
map: MAP-01 continued
phase: RUN
learning_goal: CARGO_STATION_CAUSALITY
completion_evidence: FINITE_SUCCESS
load_behavior: GM-SX059-01_PENDING
recommended_time: 45~60s
```

이미 T1에서 만든 layout을 그대로 run한다.

공통 확정:
- cargo 1, station 1, 동일 type.
- color + shape + text redundancy.
- station unload는 current domain의 자동 하역만 사용.
- 별도 stop/interaction 버튼 추가 금지.

`GM-SX059-01=A`가 승인되면:
- cargo 접근 직전 `적재` cue 1회.
- player가 current manual-load input을 사용해 pickup.
- T2는 selective loading 전략을 요구하지 않는다.

## 8. T3 · LIFO

```yaml
map: MAP-02
learning_goal: LIFO_TOP
completion_evidence: FINITE_SUCCESS
recommended_time: 60~90s
stack_visibility: EMPHASIZED
```

콘텐츠 제약:
- cargo type A/B 최소 2종.
- load order와 station visit order가 단순 최단거리와 다르게 느껴지는 배치.
- TOP mismatch가 한 번 발생할 수 있으나 scripted failure는 금지.
- `TOP부터 내림` contextual copy는 최초 필요 시 최대 1줄.
- stack panel이 board보다 커져서는 안 되지만 TOP token은 stack 내 최고 대비.

성공 증거:
- player action으로 load order가 바뀌고 성공.
- 정답 노선 자동 제공 없음.

## 9. T4 · Selective Manual Load

```yaml
map: MAP-03
learning_goal: SELECTIVE_MANUAL_LOAD
completion_evidence: FINITE_SUCCESS
recommended_time: 60~90s
```

`GM-SX059-01=A` 승인 시 exact meaning:
- T2에서 manual pickup의 조작 자체는 이미 경험.
- T4는 `누를 때`가 아니라 **`누르지 않을 때`**가 핵심.
- 한 cargo를 첫 통과에서 의도적으로 skip해야 더 좋은/가능한 LIFO order가 생김.
- skip한 cargo는 current rule대로 map에 남아 재방문 가능.

금지:
- 임의 cargo lock
- tutorial-only pickup eligibility
- capacity 제한

## 10. T5 · Manual vs Auto

```yaml
map: MAP-04
learning_goal: LOAD_MODE_COMPARISON
auto_toggle: ENABLED
recommended_time: 60~90s
```

목표:
- auto가 manual의 상위호환이 아니라 **계획에 따라 편한 도구**임을 경험.

콘텐츠 제약:
- auto를 켜도 성공 가능한 해법이 존재.
- manual을 사용해도 성공 가능한 해법이 존재.
- 한 방식만 강제하는 퍼즐 금지.
- 처음 auto를 켤 때 semantic badge + text로 상태 변화 즉시 표시.

## 11. T6 · Switch Execution

```yaml
map: MAP-05
learning_goal: SWITCH_EXECUTION
switch_control: ENABLED
recommended_time: 75~105s
```

콘텐츠 제약:
- switch 1개부터 시작.
- initial state가 읽혀야 함.
- 운행 전에 미리 바꿔도 되고, RUN 중 비점유 상태에서 바꿔도 됨.
- train이 switch cell 위에 있을 때 lock state를 semantic asset + disabled interaction으로 보여줌.
- 한 번의 switch decision이 delivery order에 관찰 가능한 영향을 줌.

금지:
- auto reset
- hidden switch timer
- reflex timing gate

## 12. Capstone · VS_DEMO_01

기존 current map을 수정하지 않고 첫 후보로 재사용한다.

실제 current data:
- board 15×11
- time limit 150s
- station RED/BLUE 2개
- cargo RED×3 + BLUE×1
- blocked cell 6개
- recommended layout ALPHA/BETA two-variant evidence 있음

Capstone은 다음을 동시에 요구한다.

```text
BUILD
→ preflight
→ RUN
→ manual/auto choice
→ LIFO TOP
→ switch
→ RED/BLUE delivery
→ success/failure
→ Retry or Edit
```

`recommended layout`은 접근성/복구 도구로 남길 수 있지만 첫 시도에서 자동 제시하거나 자동 적용하지 않는다. player가 요청하지 않은 정답 제공으로 사용하지 않는다.

## 13. Screen flow

현재 `Title → Controls/Briefing → Gameplay → Result`를 다음 방향으로 정돈한다.

```text
TITLE
→ FIRST SESSION START
→ compact Lesson Card
→ GAMEPLAY
   ├─ inline one-line contextual cue when needed
   ├─ BUILD/RUN information hierarchy
   └─ no modal tutorial during active decision
→ LESSON COMPLETE
→ next compact Lesson Card
→ ...
→ CAPSTONE RESULT
→ Retry / Edit / Continue
```

### Title

유지:
- `SWITCHY EXPRESS`
- 한 줄 product promise
- Start

변경 후보:
- `PC VERTICAL SLICE` 같은 내부 개발 표시는 player-facing release-near Slice에서 제거.
- `조작 방법`은 optional Help로 유지하되 필수 선행 읽기 금지.

### Lesson Card

최대:
- 학습 목표 한 줄
- 필요한 새 입력 1개
- 작은 semantic icon 1~2개
- 시작 CTA

긴 Rules 목록 금지.

### Gameplay contextual cue

- 화면 1개 cue만 동시에.
- 행동에 가까운 위치 또는 HUD 영역에 표시.
- action performed 후 사라짐.
- 같은 lesson에서 반복 실패할 때만 재표시.

## 14. Progressive UI policy

### T1
- show: board, straight, curve, rotate/remove/clear, preflight
- hide: switch, crossing, recommend, stack, load, auto, time pressure emphasis

### T2
- show: previous + manual load cue during RUN + cargo/station signifiers
- hide: auto, switch

### T3
- show: Stack/TOP
- hide: auto, switch

### T4
- show: manual load persistent state
- hide: auto, switch

### T5
- show: manual + auto side by side
- hide: switch if map does not require it

### T6
- show: switch state/lock + prior load/stack tools needed by map

### Capstone
- show: complete current core surface

`StagePolicy`는 visible state와 allowed-command state를 동시에 소유하여 hidden shortcut bypass를 막는다.

## 15. Failure Debrief · evidence-safe revision

`SX-DEC-059`은 현재 runtime summary가 실제로 증명하는 정보만 사용한다.

Current `FiniteRunSummary` fields:
- outcome
- failure_reason
- completion_time
- final_delivery_commit_time
- time_limit_seconds
- remaining_map_cargo
- stack_size

따라서 Slice 기본 Debrief는:

```text
ROUTE_END
노선이 끝났습니다.
맵에 남은 화물: 1 · 열차에 실린 화물: 2

TIME_EXPIRED
시간이 끝났습니다.
맵에 남은 화물: 0 · 열차에 실린 화물: 1
```

까지만 자동 설명한다.

금지:
- `B역에서 TOP=A였다`처럼 current summary가 증명하지 않는 causal sentence
- runtime history 재구성 추측
- optimal/recommended solution

향후 `SX-DEC-056A`가 planned observational event fields를 구현하면 station mismatch 등 세부 Debrief를 확장할 수 있다.

## 16. Localization contract

현재 repository에서 active localization implementation은 확인되지 않았다.

이번 기획에서는 player-facing copy를 literal GDScript/Scene string으로 추가하지 않고 key 기준으로 설계한다.

```text
SX_TUT_T1_OBJECTIVE
SX_TUT_T2_LOAD_CUE
SX_TUT_T3_TOP_RULE
SX_TUT_T4_SKIP_CUE
SX_TUT_T5_AUTO_STATE
SX_TUT_T6_SWITCH_STATE
SX_RESULT_ROUTE_END
SX_RESULT_TIME_EXPIRED
```

지원 목표:
- ko
- en
- ja
- zh-* exact variant는 implementation package 전 확정

기존 Korean literal을 한 번에 대규모 migration하지 않는다. Slice가 건드리는 copy surface부터 최소 localization owner를 만들고 소비자 범위를 증명한다.

## 17. Accessibility / responsive

- cargo/station: color + shape + text 유지.
- TOP: position + semantic badge + text.
- switch: direction + selected state + lock state, color-only 금지.
- Reduced Motion: 동일 정보, 이동/scale 연출만 축소.
- current PC targets: 1280×720 / 1600×900 / 1920×1080.
- Android landscape는 shared semantic/layout contract로 설계하되 현재 Slice의 첫 manual validation은 PC를 우선할 수 있다.
- touch target min 48px existing contract 유지.

## 18. TDD / acceptance-first contract for future BUILD

### RED families

```text
FIRST_SESSION_SEQUENCE_SCHEMA_RED
T1_PREFLIGHT_PHASE_TRANSITION_RED
STAGE_POLICY_HIDDEN_COMMAND_BYPASS_RED
GM_SX059_01_SELECTED_T2_LOAD_BEHAVIOR_RED
T3_TOP_PROGRESSIVE_DISCLOSURE_RED
T4_SELECTIVE_LOAD_REQUIRED_RED
T5_MANUAL_AUTO_BOTH_VALID_RED
T6_SWITCH_STATE_LOCK_RED
CAPSTONE_CURRENT_MAP_UNCHANGED_RED
DEBRIEF_SUMMARY_EVIDENCE_CEILING_RED
LOCALIZATION_KEY_CONSUMER_RED
```

### Regression protection

- existing finite core tests all remain GREEN.
- `VS_DEMO_01` map JSON bytes or semantic meaning unchanged unless separate finding/approval.
- existing ProductFiniteSlice can still run outside FirstSessionDirector.
- no domain command meaning change.
- PR #154 paths/deltas not absorbed.

## 19. Remaining planning blocker

```yaml
GM-SX059-01:
  topic: T2/T4 manual-load learning dependency
  recommended: A_PREREQUISITE_ACTION_EARLY_STRATEGY_LATER
  status: USER_DECISION_REQUIRED
```

이 Decision이 닫히면 T2/T4 map challenge constraints와 exact copy를 최종 잠글 수 있다.

현재 판정: `INDEPENDENT_SCREEN_DATA_PLAN_COMPLETE · EXACT_T2_T4_PENDING_USER_DECISION · BUILD_NOT_AUTHORIZED`.
