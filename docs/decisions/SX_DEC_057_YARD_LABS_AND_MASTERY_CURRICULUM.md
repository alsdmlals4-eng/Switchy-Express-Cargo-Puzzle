# SX-DEC-057 · Yard Labs and Mastery Curriculum

Status: `USER_APPROVED · PLANNING_CANON · DELTA_DOR_REVIEWED · IMPLEMENTATION_NOT_AUTHORIZED`

Approved: `2026-08-11 KST`

Delta DoR review: `SX-AUD-052`

Source benchmark: `SX-BMK-001 · BMK-R04/R05/R06`

Product baseline: `GMB-002`

Existing campaign authority: `SX-DEC-034`

## Decision

현재 승인된 Tutorial 1~10 순서와 `3개 중 2개 clear → 다음 묶음` 챕터 진행 구조를 유지하면서, 기존 gameplay rule을 격리해 연습하는 `Yard Labs`와 진행을 막지 않는 `Mastery Spur`를 추가한다.

이 Decision은 새 규칙이나 성장 파워를 추가하는 권위가 아니다. 이미 승인된 BUILD/LIFO/load/switch/cost 규칙을 `격리 학습 → 짧은 반복 → 본편 전이 → 선택형 숙련`으로 연결하는 콘텐츠 구조의 권위다.

## 1. Tutorial 1~10 순서 보호

`SX-DEC-034 / GMB-002`의 현재 순서는 변경하지 않는다.

1. 기본 선로 연결
2. 화물과 대응 역·자동 하역
3. LIFO
4. 수동 적재
5. 자동 적재 전환
6. 분기 조작
7. Combo와 출발 가속
8. 가속·저비용 선로와 비용
9. 회차 중심 복합 노선
10. 건설·LIFO·분기·Combo·비용·시간 종합 시험

Yard Lab은 해당 Stage를 클리어한 뒤 선택형 보조 lane으로만 열린다. Tutorial Stage 자체를 삽입·재번호화·대체하지 않는다.

## 2. Yard Lab 제품 구조

초기 Yard Lab은 정확히 3개 lane, lane당 4개 micro puzzle로 시작한다.

```text
Stack Lab   · SL-01~SL-04 · Stage 5 clear 후 unlock
Switch Lab  · SW-01~SW-04 · Stage 6 clear 후 unlock
Builder Lab · BL-01~BL-04 · Stage 8 clear 후 unlock
```

총 초기 blueprint 수: `12`.

각 lane 내부는 `01 → 02 → 03 → 04` 순서로 연다. 그러나 Lab lane 전체가 optional이므로 어떤 Lab도 Tutorial/Chapter/랭킹 unlock을 막지 않는다.

초기 목표 세션 길이는 문제당 `30~90초 TEST_VALUE`다. 이것은 사람 calibration 전의 authoring target이며 hard success rule이 아니다. 실제 성공/실패는 기존 finite map의 delivery/time contract를 그대로 쓴다.

## 3. Lab 공통 schema

각 Lab puzzle은 최소 다음 authoring metadata를 갖는다.

```text
content_id
lab_type: STACK | SWITCH | BUILDER
sequence_index: 1..4
unlock_anchor_stage: 5 | 6 | 8
primary_learning_target
transfer_target
required_existing_rules[]
allowed_existing_rules[]
forbidden_rules[]
track_policy: PRESET | PLAYER_BUILD
cargo_types[]
expected_encounter_pattern
common_failure_observation
request_only_hint_ladder[]
target_duration_seconds: [30, 90] TEST_VALUE
difficulty:
  topology: 0..3
  stack_entropy: 0..3
  execution_branching: 0..3
progression_required: false
leaderboard_enabled: false
reward_class: COMPLETION_MARK_ONLY
runtime_dependency: NONE | <existing authority dependency>
```

`expected_encounter_pattern`과 `common_failure_observation`은 authoring/validation metadata이며 정답 sequence를 player-facing UI에 자동 노출하는 권위가 아니다.

## 4. Stack Lab · SL-01~04

Stage 5까지 이미 배운 규칙만 사용한다. Switch/Crossing 조작, Combo 최적화, speed/cheap attribute는 금지한다.

### SL-01 · Reverse Pair

- 목표: `나중에 실은 화물이 TOP`이라는 기본 LIFO 역순을 행동으로 확인.
- track: PRESET 단순 loop.
- cargo: RED_STAR → BLUE_DIAMOND.
- station visit: RED → BLUE → RED.
- 의도: auto load로 두 화물을 싣고 첫 RED station을 TOP=BLUE 때문에 통과한 뒤 BLUE unload → 재방문 RED unload를 경험.
- common failure observation: `RED station PASS · TOP=BLUE`를 원인으로 설명하지 못함.
- difficulty: `Topology 0 / Stack 1 / Execution 0`.

### SL-02 · Intentional Skip

- 목표: manual load hold를 `덜 싣는 페널티`가 아니라 stack 계획 도구로 사용.
- track: PRESET loop, switch 없음.
- cargo sequence: RED → BLUE → RED station → BLUE station → revisit.
- time budget은 모든 cargo를 첫 조우에 auto-load하면 불필요한 추가 lap 때문에 실패하고, BLUE를 첫 lap에서 의도적으로 skip한 뒤 재방문해 싣는 해법은 성공하도록 calibration한다.
- 새 win condition을 만들지 않는다. 차이는 기존 time limit 하나로만 만든다.
- difficulty: `0 / 2 / 0`.

### SL-03 · Toggle Window

- 목표: auto/manual toggle을 구간별로 바꿔 contiguous same-type TOP group을 만든다.
- track: PRESET loop.
- cargo sequence candidate: RED → RED → BLUE → RED station → BLUE station → revisit BLUE.
- 의도: RED cluster 구간은 auto, BLUE 앞은 manual/skip 등 이미 배운 모드 전환을 사용해 불필요한 TOP block을 줄임.
- difficulty: `0 / 2 / 0`.

### SL-04 · Three-Type Stack

- 목표: 세 종류 stack을 눈으로 추적하고 reverse unload를 예측.
- track: PRESET loop.
- cargo: RED → BLUE → YELLOW.
- stations: YELLOW → BLUE → RED.
- skip이 필수는 아니며 pure LIFO mental model transfer를 확인한다.
- difficulty: `0 / 2 / 0`.

## 5. Switch Lab · SW-01~04

Stage 6까지 배운 규칙만 사용한다. 기본은 preset track이며 load complexity를 낮춘다. Pause 허용 원칙을 유지하고 train start/stop 직접 조작을 만들지 않는다.

### SW-01 · One Fork, Two Visits

- 목표: switch selected direction이 방문 순서를 만든다는 점을 확인.
- 1 switch, 2 branch, cargo/station 각각 한 쪽에 배치.
- 한 번 선택하고 끝내는 문제가 아니라 동일 switch를 재방문하도록 구성해 `상태가 유지됨`을 체험.
- difficulty: `Topology 1 / Stack 0 / Execution 1`.

### SW-02 · Return Order

- 목표: 한 switch를 두 번 이상 계획적으로 바꿔 방문 순서를 실행.
- 1 switch, loop/revisit 1회 이상.
- cargo는 최대 2종, stack depth 2 이하.
- expected meaningful route-control changes: 2~3.
- difficulty: `1 / 1 / 2`.

### SW-03 · Occupied Lock

- 목표: switch 위에 열차가 있을 때만 조작이 잠긴다는 현재 rule을 반사신경이 아니라 `미리 결정할 상태`로 이해.
- 1 switch, 접근 전 충분한 판단 구간.
- pause로 생각할 수 있지만 pause 중 switch 조작은 금지인 기존 규칙을 유지한다.
- 성공 해법은 빠른 탭을 요구하지 않고 switch 접근 전에 상태를 결정할 수 있어야 한다.
- difficulty: `1 / 0 / 2`.

### SW-04 · Branch + LIFO Transfer

- 목표: switch는 LIFO 해답을 대신하는 게 아니라 계획된 cargo/station visit order를 실행하는 도구임을 통합 확인.
- 2 switch 이하.
- cargo 2종, stack depth 2~3.
- switch 선택만 맞고 stack order가 틀리면 station PASS가 발생하도록 구성.
- difficulty: `1 / 2 / 2`.

## 6. Builder Lab · BL-01~04

Stage 8까지 가르친 BUILD/cost/속성 개념을 적용한다. 다만 current runtime seam과 승인된 제품 규칙을 구분한다.

### BL-01 · Blocked Detour

- 목표: 단순 연결이 아니라 blocked cell을 피해 cargo encounter order까지 고려해 route를 만든다.
- track: PLAYER_BUILD.
- cargo 2종, station 2개.
- switch는 선택적 0~1개.
- 현재 finite runtime의 STRAIGHT/CURVE/SWITCH/CROSSING 범위에서 제작 가능.
- difficulty: `Topology 2 / Stack 1 / Execution 0~1`.

### BL-02 · Geometry Cost Choice

- 목표: 같은 필수 지점을 연결해도 geometry 선택으로 build cost가 달라짐을 이해.
- track: PLAYER_BUILD.
- 최소 하나의 route는 불필요한 SWITCH/CROSSING 사용으로 더 비싸고, 단순 geometry route는 더 저렴하게 설계 가능.
- 현재 `STRAIGHT/CURVE=100`, `SWITCH/CROSSING=200` runtime truth만 사용한다.
- difficulty: `2 / 1 / 1`.

### BL-03 · Fast vs Cheap Attribute

- 목표: Stage 8의 `가속 선로 vs 저비용 선로` tradeoff를 격리.
- track: PLAYER_BUILD.
- 동일 topology 안에서 time headroom과 build cost가 다른 2개 이상의 합법 선택을 만들도록 설계.
- **runtime_dependency:** authoritative fast/cheap track-attribute runtime representation.
- current main의 `TrackPiece`에는 geometry/rotation/switch state와 기본 geometry cost만 있고 speed/cheap attribute field가 없으므로, 이 blueprint의 제품 기획은 완료하되 실제 content/runtime 제작은 dependency가 닫힐 때까지 금지한다.
- difficulty target: `1 / 0~1 / 0`, cost/speed decision이 주 학습.

### BL-04 · Plan the Whole Yard

- 목표: build topology + encounter order + LIFO + 기존 switch/cost를 한 문제에서 통합하되 새 규칙은 넣지 않음.
- track: PLAYER_BUILD.
- cargo 2~3종.
- switch 0~2개.
- 현재 simple geometry/cost만으로도 제작 가능한 057A variant와, 향후 speed/cheap attribute가 준비된 뒤 해당 속성까지 포함하는 versioned 057B variant를 분리한다.
- difficulty current variant: `Topology 2 / Stack 2 / Execution 1~2`.

## 7. Hint contract

Lab은 답안을 주는 tutorial pop-up이 아니다. 기존 request-only hint 철학을 그대로 사용한다.

최대 3단계:

```text
1. 문제 유형: "TOP 순서를 다시 확인해 보세요"
2. 관련 위치/상태: "첫 RED 역에 도착할 때 TOP이 무엇인지 보세요"
3. 행동 방향: "BLUE를 지금 싣지 않고 나중에 다시 만나는 방법도 있습니다"
```

금지:

- exact route polyline;
- exact switch timeline;
- complete cargo load/skip sequence;
- one-tap solve;
- developer solution overlay.

## 8. Lab progression / persistence

```text
Stage 5 clear → Stack Lab lane permanently unlocked
Stage 6 clear → Switch Lab lane permanently unlocked
Stage 8 clear → Builder Lab lane permanently unlocked
```

- Lab unlock은 뒤의 Tutorial/campaign unlock 조건에 추가되지 않는다.
- lane 내부는 01부터 순차 unlock하지만 사용자는 언제든 lane을 나가 core progression을 계속할 수 있다.
- 각 puzzle clear 상태는 영구 기록 가능하나 실패/retry 횟수에 불이익을 주지 않는다.
- 모든 4개 clear 시 해당 lane `completion_mark=true`만 기록한다.
- completion mark는 UI badge/check 상태이며 item/power/currency/stat을 지급하지 않는다.
- cosmetic item 자체를 새 asset/reward로 지급하려면 별도 콘텐츠/asset 승인이 필요하다.
- leaderboard는 초기 Lab에 없다.

## 9. Optional Mastery Spur

각 `3 Core stage` chapter group에는 최대 1개 Mastery Spur를 둘 수 있다.

Unlock timing을 명확히 한다.

```text
Core A/B/C 중 2개 clear
→ 다음 chapter unlock
→ 동시에 현재 chapter의 Mastery Spur unlock
```

따라서 Mastery unlock 때문에 다음 chapter가 늦어질 수 없다.

Mastery Spur 규칙:

- chapter-known rules subset만 사용;
- 새 rule 소개 금지;
- progression requirement 금지;
- 중도 포기/실패 후 즉시 core/chapter 선택 화면 복귀;
- unlimited retry;
- leaderboard 초기 없음;
- reward는 `MASTERY_COMPLETION_MARK` metadata only;
- completion mark는 unlock/power/stat/currency에 사용하지 않음.

## 10. Difficulty scale · exact authoring rubric

각 축은 `0..3` integer ordinal이다. 서로 합산한 단일 difficulty score를 player-facing으로 표시하지 않는다.

### Topology Complexity

- `0`: 단일 선형/고정 loop, 의미 있는 alternate path 없음.
- `1`: 하나의 단순 branch/blocked detour/revisit 요소.
- `2`: 2개 이상의 연결 선택 또는 loop/crossing/revisit가 서로 영향을 줌.
- `3`: 3개 이상 interacting route-choice element 또는 late special topology와 다중 revisit가 결합.

### Stack Entropy

- `0`: 한 cargo type 또는 stack decision 사실상 없음.
- `1`: 2종, depth ≤2, reverse order가 단일 명확 관계.
- `2`: 2~3종, expected depth 3~4 또는 최소 1개 meaningful skip/revisit/grouping decision.
- `3`: 3종, expected depth ≥4와 2개 이상의 TOP-block/grouping/skip decision이 상호작용.

### Execution Branching

- `0`: route-control 없음.
- `1`: 1 control, meaningful change ≤1 또는 단일 방문 선택.
- `2`: 1~2 controls, meaningful changes 2~3 또는 명시적 occupied-lock planning moment 1개.
- `3`: 2~3 controls, meaningful changes ≥4 또는 여러 visit-order/lock moment가 상호작용.

Authoring targets:

```text
Lab 01: primary axis 1, other axes 0~1
Lab 02: primary axis 2, other axes 0~1
Lab 03: primary axis 2, other axes 0~1
Lab 04: primary axis 2, secondary axis 최대 2
Core: 한 primary axis 중심
Chapter exam: 2 axes combination 가능
Mastery: primary 2~3 + at least one secondary 1~2
```

Mastery는 난이도 합계로 자동 판정하지 않는다. 위 ordinal은 author/review lens이며 실제 사람 calibration이 우선한다.

## 11. Mastery chapter archetype library

실제 campaign map 좌표가 확정되기 전에도 author가 사용할 수 있는 bounded archetype을 고정한다.

- `M-JUNCTION`: branch/revisit + 낮은 stack entropy. Execution primary.
- `M-CARGO`: alternating cargo + TOP block + 한 번 이상의 revisit. Stack primary.
- `M-BUDGET`: blocked topology + geometry cost 선택. Topology/cost primary.
- `M-EXPRESS`: speed/cheap track attribute가 authoritative runtime에 존재할 때만 사용. dependency-gated.
- `M-LOOP`: loop/revisit + 2~3 cargo type LIFO. Topology+Stack.
- `M-GRAND`: 해당 chapter까지 배운 2~3축 종합. 새 rule 없음.

Chapter에 맞는 archetype 하나만 선택한다. 하나의 chapter에 Mastery를 여러 개 만들지 않는다.

## 12. Content validation contract

자동/content 검증은 최소 다음을 거부해야 한다.

1. Tutorial Stage 1~10 순서 변경.
2. Lab unlock anchor가 5/6/8이 아닌 값.
3. Stack Lab에 Stage 6+ switch/crossing-control 또는 Stage 7+ Combo optimization을 필수 해법으로 요구.
4. Switch Lab이 3개 초과 route control이나 반사신경-only success window를 요구.
5. Builder Lab이 해당 runtime에서 존재하지 않는 speed/cheap attribute를 `dependency=NONE`으로 선언.
6. Lab/Mastery `progression_required=true`.
7. power/stat/currency reward.
8. leaderboard-enabled initial Lab/Mastery.
9. Mastery가 chapter-known-rules 밖 rule 참조.
10. exact solution/hint sequence를 normal UI로 공개.

## 13. Human transfer contract

057 player-facing content가 exact acceptance build에 포함되면 기존 `PLAYTEST_PLAN.md`의 `FS-16 Yard Lab transfer`, `FS-17 Mastery optionality`를 활성화한다.

최소 성공 기준은 기존 사람검증 원칙을 그대로 쓴다.

- 최소 analyzable first-contact 5명.
- required observation threshold 4/5.
- Lab 직후 다음 campaign 문제에서 같은 rule을 새 설명 없이 적용.
- Mastery를 progression requirement로 오해하지 않고 포기/skip 후 다음 chapter로 이동 가능.

30~90초 authoring target은 사람 검증 결과에 따라 조정할 수 있지만, core rule이나 unlock guardrail은 자동으로 바꾸지 않는다.

## 14. Runtime dependency split

현재 main 기준:

- manual/auto load truth: existing finite input/runtime seam 존재.
- switch/crossing route-control truth: existing finite graph/runtime seam 존재.
- geometry build cost: current `TrackPiece`에서 STRAIGHT/CURVE 100, SWITCH/CROSSING 200.
- fast/cheap track attribute: current `TrackPiece`에 authoritative runtime field가 없음.
- campaign/tutorial progression store: current product direction은 승인됐지만 full runtime owner는 아직 구현 권위/구현 상태가 확정되지 않음.

따라서:

```yaml
057A_content_blueprints: COMPLETE_PLANNING
057A_stack_switch_and_basic_builder_content: READY_PLANNING
057B_fast_cheap_attribute_content: BLOCKED_BY_STAGE8_TRACK_ATTRIBUTE_RUNTIME
057_progression_runtime: REQUIRES_SEPARATE_IMPLEMENTATION_AUTHORITY_AND_OWNER
implementation_authority: NOT_GRANTED
```

## 15. Authority boundary

- `SX-DEC-034` Tutorial 1~10과 2-of-3 chapter progression은 계속 상위 기존 권위다.
- `SX-DEC-057`은 Lab/Mastery additive content structure만 소유한다.
- `SX-DEC-055` Phase B BUILD authority는 확대되지 않는다.
- `SX-DEC-056` Route Probe/Trace는 Lab의 필수 해법이 아니다. 056이 미구현이어도 Lab은 본래 gameplay/HUD로 풀 수 있어야 한다.
- speed/cheap Builder content는 Stage 8 runtime authority를 057에서 새로 발명하지 않는다.
- 실제 Lab/Mastery map data, UI entry, persistence/runtime 구현은 별도 explicit implementation authority 전에는 시작하지 않는다.
