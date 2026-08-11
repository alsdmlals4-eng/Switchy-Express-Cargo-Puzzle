# Yard Lab & Mastery Content Catalog V1

Status: `SX-DEC-057 · AUTHORING_BLUEPRINT · DELTA_DOR_PLANNING`

Owner Decision: `SX-DEC-057`

Purpose: 구현 전에 초기 12개 Yard Lab과 Mastery authoring archetype을 동일한 학습·난이도·힌트·진행 계약으로 고정한다.

## 1. Global authoring rules

- 모든 content는 GMB-002 finite delivery success/failure contract를 그대로 사용한다.
- Lab 전용 승리 조건은 만들지 않는다.
- Lab/Mastery는 campaign progression 필수가 아니다.
- initial leaderboard는 없다.
- reward는 completion mark metadata only.
- hint는 request-only 3단계 이하.
- exact route/switch/load script를 기본 UI에 제공하지 않는다.
- 3 cargo identities only: `RED_STAR`, `BLUE_DIAMOND`, `YELLOW_TRIANGLE`.
- map coordinate/rail-anchor JSON은 실제 content-production authority 때 작성한다. 본 문서는 solution-bearing author blueprint이며 player runtime answer source가 아니다.

Difficulty notation: `T/S/E = Topology / Stack Entropy / Execution Branching`.

## 2. Stack Lab · after Tutorial Stage 5

### SL-01 · Reverse Pair

```yaml
track_policy: PRESET
primary: LIFO_TOP
required_rules: [AUTO_LOAD, LIFO, STATION_AUTO_UNLOAD]
forbidden_required_rules: [SWITCH, COMBO, TRACK_ATTRIBUTE]
cargo_order: [RED_STAR, BLUE_DIAMOND]
station_visit_order: [RED_STAR, BLUE_DIAMOND, RED_STAR]
expected_learning: first RED station passes because TOP=BLUE; later BLUE then RED unload
common_failure: player expects FIFO or treats station pass as bug
target_seconds: 30-60
difficulty: T0/S1/E0
runtime_dependency: NONE
```

Hint ladder:
1. `마지막에 실은 화물이 먼저 내려갑니다.`
2. `첫 RED 역에 도착할 때 TOP을 확인해 보세요.`
3. `BLUE를 먼저 내리면 RED가 TOP으로 돌아옵니다.`

### SL-02 · Intentional Skip

```yaml
track_policy: PRESET
primary: MANUAL_SKIP
required_rules: [MANUAL_LOAD, LIFO, REVISIT, TIME_LIMIT]
forbidden_required_rules: [SWITCH, COMBO, TRACK_ATTRIBUTE]
encounter_pattern: RED cargo → BLUE cargo → RED station → BLUE station → revisit
authoring_constraint: auto-loading both on first encounter requires an extra lap that exceeds calibrated time; deliberately skipping BLUE on first lap permits success
common_failure: player holds LOAD continuously and misses why extra lap occurs
target_seconds: 45-90
difficulty: T0/S2/E0
runtime_dependency: NONE
```

Hint ladder:
1. `모든 화물을 처음 만날 때 실을 필요는 없습니다.`
2. `첫 RED 역 전에 BLUE가 TOP이 되는지 보세요.`
3. `BLUE를 나중 방문으로 미루는 선택을 시험해 보세요.`

### SL-03 · Toggle Window

```yaml
track_policy: PRESET
primary: AUTO_MANUAL_WINDOW
required_rules: [AUTO_LOAD_TOGGLE, MANUAL_LOAD, LIFO, REVISIT]
cargo_pattern: RED, RED, BLUE before RED station; BLUE available again on revisit
expected_learning: use auto for useful cluster, switch mode before cargo that would create avoidable TOP block
common_failure: player treats auto mode as permanent preference rather than situational tool
target_seconds: 45-90
difficulty: T0/S2/E0
runtime_dependency: NONE
```

Hint ladder:
1. `적재 모드는 운행 중 바꿀 수 있습니다.`
2. `RED 두 개 뒤의 BLUE가 첫 RED 역을 막는지 보세요.`
3. `필요한 묶음 구간만 자동 적재하는 방법을 시험해 보세요.`

### SL-04 · Three-Type Stack

```yaml
track_policy: PRESET
primary: THREE_TYPE_MENTAL_STACK
required_rules: [AUTO_LOAD, LIFO, STATION_AUTO_UNLOAD]
cargo_order: [RED_STAR, BLUE_DIAMOND, YELLOW_TRIANGLE]
station_order: [YELLOW_TRIANGLE, BLUE_DIAMOND, RED_STAR]
expected_learning: predict all three TOP transitions before first unload
target_seconds: 30-60
difficulty: T0/S2/E0
runtime_dependency: NONE
```

Hint ladder:
1. `세 화물을 아래→위 순서로 머릿속에 쌓아 보세요.`
2. `마지막 cargo가 첫 station과 맞아야 합니다.`
3. `YELLOW → BLUE → RED 순으로 TOP이 바뀌는지 확인하세요.`

## 3. Switch Lab · after Tutorial Stage 6

### SW-01 · One Fork, Two Visits

```yaml
track_policy: PRESET
primary: SWITCH_STATE_PERSISTENCE
route_controls: 1
required_rules: [SWITCH_SELECT, SWITCH_STATE_PERSIST, REVISIT]
stack_complexity: one cargo type preferred
expected_learning: switch state persists until changed; same fork can serve different visits
target_seconds: 30-60
difficulty: T1/S0/E1
runtime_dependency: NONE
```

Hint ladder:
1. `분기 상태는 다시 바꾸기 전까지 유지됩니다.`
2. `첫 방문과 돌아오는 방문의 목적지가 같은지 확인하세요.`
3. `재방문 전에 분기 상태를 다시 계획하세요.`

### SW-02 · Return Order

```yaml
track_policy: PRESET
primary: MULTI_VISIT_SWITCH_SEQUENCE
route_controls: 1
meaningful_changes_target: 2-3
required_rules: [SWITCH_SELECT, REVISIT, LIFO_BASIC]
cargo_types: [RED_STAR, BLUE_DIAMOND]
expected_learning: one switch can execute a planned visit sequence across multiple passes
target_seconds: 45-90
difficulty: T1/S1/E2
runtime_dependency: NONE
```

Hint ladder:
1. `이 분기는 한 번 정하고 끝나는 버튼이 아닙니다.`
2. `각 재방문 직전에 다음 목적지를 정해 보세요.`
3. `cargo 방문과 station 방문을 각각 어떤 순서로 할지 먼저 써 보세요.`

### SW-03 · Occupied Lock

```yaml
track_policy: PRESET
primary: OCCUPIED_LOCK_PREPLAN
route_controls: 1
required_rules: [SWITCH_SELECT, OCCUPIED_LOCK, PAUSE_RULE]
authoring_constraint: ample pre-approach decision distance; no reaction-only success window
expected_learning: set switch before train occupies it; pause is thinking time but cannot be used to manipulate switch while paused
target_seconds: 30-60
difficulty: T1/S0/E2
runtime_dependency: NONE
```

Hint ladder:
1. `열차가 분기 위에 있을 때만 그 분기는 잠깁니다.`
2. `분기에 닿기 전에 상태를 정할 시간이 있습니다.`
3. `다음 방문 목적지를 먼저 고르고 접근 전에 전환하세요.`

### SW-04 · Branch + LIFO Transfer

```yaml
track_policy: PRESET
primary: SWITCH_EXECUTES_STACK_PLAN
route_controls: 2 max
required_rules: [SWITCH_SELECT, LIFO, REVISIT]
cargo_types: [RED_STAR, BLUE_DIAMOND]
expected_learning: correct branch choices alone cannot repair wrong TOP order
common_failure: station pass after apparently correct switch path
target_seconds: 60-90
difficulty: T1/S2/E2
runtime_dependency: NONE
```

Hint ladder:
1. `분기와 TOP은 서로 다른 문제입니다.`
2. `원하는 역에 도착할 때 TOP 종류를 같이 확인하세요.`
3. `cargo 방문 순서를 먼저 정한 뒤 분기로 그 순서를 실행하세요.`

## 4. Builder Lab · after Tutorial Stage 8

### BL-01 · Blocked Detour

```yaml
track_policy: PLAYER_BUILD
primary: TOPOLOGY_AND_ENCOUNTER_ORDER
required_rules: [BUILD, BLOCKED_CELL, LIFO_BASIC]
allowed_geometry: [STRAIGHT, CURVE, SWITCH]
cargo_types: [RED_STAR, BLUE_DIAMOND]
authoring_constraint: at least two structurally valid routes; one creates less useful cargo encounter order
target_seconds: 60-90
difficulty: T2/S1/E0-1
runtime_dependency: NONE
```

Hint ladder:
1. `연결 가능하다고 모두 같은 노선은 아닙니다.`
2. `blocked cell을 피한 뒤 cargo를 만나는 순서를 비교하세요.`
3. `역 방문보다 먼저 cargo 조우 순서를 설계해 보세요.`

### BL-02 · Geometry Cost Choice

```yaml
track_policy: PLAYER_BUILD
primary: BASIC_GEOMETRY_COST
required_rules: [BUILD, COST, FULL_REFUND]
allowed_geometry: [STRAIGHT, CURVE, SWITCH, CROSSING]
authoring_constraint: expensive valid route uses unnecessary SWITCH/CROSSING; cheaper valid route uses simpler geometry
runtime_truth: STRAIGHT/CURVE=100; SWITCH/CROSSING=200
target_seconds: 60-90
difficulty: T2/S1/E1
runtime_dependency: NONE
```

Hint ladder:
1. `같은 연결이라도 선로 형태에 따라 비용이 다릅니다.`
2. `분기·교차가 정말 필요한 칸인지 확인하세요.`
3. `불필요한 고비용 geometry를 제거해 보세요.`

### BL-03 · Fast vs Cheap Attribute

```yaml
track_policy: PLAYER_BUILD
primary: SPEED_COST_ATTRIBUTE_TRADEOFF
required_rules: [BUILD, FAST_TRACK, CHEAP_TRACK, TIME_LIMIT, COST]
authoring_constraint: same required delivery topology supports at least two legal attribute allocations with different time/cost headroom
target_seconds: 60-90
difficulty: T1/S0-1/E0
runtime_dependency: STAGE8_FAST_CHEAP_TRACK_ATTRIBUTE_RUNTIME
status: BLUEPRINT_READY_DEPENDENCY_BLOCKED
```

Hint ladder:
1. `빠른 선로와 싼 선로는 같은 목표를 최적화하지 않습니다.`
2. `시간 여유와 건설비 중 지금 부족한 쪽을 확인하세요.`
3. `모든 칸을 한 속성으로 채우지 말고 필요한 구간을 나눠 보세요.`

### BL-04 · Plan the Whole Yard

```yaml
track_policy: PLAYER_BUILD
primary: BUILD_STACK_SWITCH_INTEGRATION
required_rules: [BUILD, COST, LIFO, SWITCH]
cargo_types: [RED_STAR, BLUE_DIAMOND, YELLOW_TRIANGLE optional]
route_controls: 0-2
current_variant: BASIC_GEOMETRY_COST only
future_variant: may include FAST/CHEAP after dependency closes
target_seconds: 60-90
difficulty: T2/S2/E1-2
runtime_dependency: NONE for current variant; STAGE8_FAST_CHEAP_TRACK_ATTRIBUTE_RUNTIME for future variant
```

Hint ladder:
1. `건설 전에 cargo→station 방문 순서를 정해 보세요.`
2. `TOP을 맞춘 뒤 그 순서를 만들 선로와 분기를 선택하세요.`
3. `마지막에 불필요한 고비용 geometry가 없는지 확인하세요.`

## 5. Lab lane completion

```text
unlock stage → puzzle 01
clear 01 → 02
clear 02 → 03
clear 03 → 04
clear 04 → lane completion mark
```

- exit/skip 언제든 허용;
- failure penalty 없음;
- campaign/tutorial path는 Lab state를 읽지 않음;
- completion mark is bool/visual check only;
- no item, currency, XP, power, leaderboard.

## 6. Mastery Spur authoring templates

Mastery unlock is simultaneous with next chapter unlock after 2/3 core clears.

### M-JUNCTION

```yaml
primary_axis: EXECUTION 2-3
secondary: TOPOLOGY 1-2
rules: chapter-known SWITCH/CROSSING/REVISIT subset
new_rule: false
```

### M-CARGO

```yaml
primary_axis: STACK 2-3
secondary: TOPOLOGY 1
rules: LIFO + manual/auto + revisit subset
new_rule: false
```

### M-BUDGET

```yaml
primary_axis: TOPOLOGY 2
secondary: STACK or EXECUTION 1-2
rules: BUILD + basic geometry cost + chapter-known rules
new_rule: false
```

### M-EXPRESS

```yaml
primary_axis: TOPOLOGY/COST 1-2
secondary: STACK or EXECUTION 1
rules: FAST/CHEAP track attribute + already-known rules
runtime_dependency: STAGE8_FAST_CHEAP_TRACK_ATTRIBUTE_RUNTIME
status: DEPENDENCY_GATED
```

### M-LOOP

```yaml
primary_axis: TOPOLOGY 2-3
secondary: STACK 2
rules: LOOP/REVISIT + LIFO
new_rule: false
```

### M-GRAND

```yaml
primary_axis: chapter-selected 2-3
secondary_axes: one or two 1-2
rules: chapter-known subset only
new_rule: false
```

## 7. Mastery review checklist

Reject a Mastery candidate if any is true:

- it teaches a rule not encountered in core/tutorial before unlock;
- it is required for the next chapter;
- it grants gameplay/currency/stat reward;
- it requires a reaction-only switch window;
- it requires an unavailable runtime feature without dependency flag;
- its only difficulty increase is a much shorter time limit with no deeper planning;
- it exposes solution data by default.

## 8. Transfer validation mapping

- Stack Lab completion → first following campaign stage with LIFO/manual-auto use: observe independent application.
- Switch Lab completion → first following stage requiring route-control revisit: observe planned changes rather than random tapping.
- Builder Lab completion → first following build/cost stage: observe route-before-build reasoning and cost cleanup.
- Mastery abandon/skip → verify next chapter remains immediately reachable.

Use `PLAYTEST_PLAN` FS-16/FS-17 if this content enters the exact tested build. Existing 5-person/4-of-5 threshold remains.
