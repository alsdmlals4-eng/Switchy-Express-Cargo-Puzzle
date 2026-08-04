# Finite Puzzle Definition of Ready — First Vertical Slice

```yaml
status: DRAFT_USER_REVIEW
spec_id: FP-DOR-001
product_canon: GMB-002 · SX-DEC-027~036
source_audit: SX-AUD-012
base_main: 1f0cfd499ee93f5804147426d6b4a3316daaa388
approved_approach: FP-01 + FP-02 MINIMUM_PLAYABLE_CORE
implementation_authority: NOT_GRANTED
next_gate: USER_SPEC_APPROVAL
```

## 1. 목적

첫 구현 Slice는 다음 핵심 인과가 실제 플레이에서 성립하는지만 증명한다.

```text
선로 건설
→ 화물 조우 순서
→ 수동/자동 적재
→ LIFO 스택
→ 분기 선택과 역 방문
→ 모든 화물 배송 또는 제한 시간 실패
→ 노선을 유지한 수정·재도전
```

이 Slice는 완성된 제품 화면이나 많은 콘텐츠를 만드는 단계가 아니다. 새 핵심 재미가 기존 endless 코드에 왜곡되지 않고 구현 가능한지 검증하는 단계다.

## 2. 채택 접근

### FP-01 + FP-02 통합 최소 플레이 가능 코어

- `FP-01`: 플레이어 선로 건설 domain, 비용, 그래프 변환, 구조 검사
- `FP-02`: 수동/자동 적재, 무제한 LIFO, 역 하역, 제한 시간 성공·실패, 재도전

두 package는 하나의 Vertical Slice 목표 아래 순차 PR로 구현한다. 선로 건설만 완료한 상태는 Slice 완료가 아니다. 실제 LIFO 배송 성공까지 연결돼야 한다.

다른 접근은 제외한다.

- FP-01만 구현하면 선로가 적재 순서를 만드는 핵심 재미를 검증할 수 없다.
- Combo·특수 선로·별·튜토리얼·온라인까지 포함하면 범위가 커져 실패 원인을 분리하기 어렵다.

## 3. Slice 성공 정의

다음 대표 상황을 플레이어가 직접 완주할 수 있어야 한다.

```text
화물 조우: A → B → A → A
CargoStack: [A][B][A][A TOP]
A역 도착: A 2개 하역
B역 도착: B 1개 하역
A역 재방문: A 1개 하역
마지막 하역 완료: 즉시 성공
```

성공 원인은 빠른 탭이나 기존 연료 경제가 아니라 다음 판단이어야 한다.

1. 어느 선로로 어떤 화물을 먼저 만날지 결정
2. 수동 적재와 자동 적재 중 적절한 방식 선택
3. LIFO TOP을 예상해 역 방문 순서 구성
4. 분기를 미리 바꾸며 실행
5. 실패 후 같은 노선을 수정해 재도전

## 4. 범위

### 포함

- 수작업 대표 맵 1개
- 건설 가능·불가 셀
- 직선·곡선·분기·교차 선로
- 설치·회전·교체·철거·전체 초기화
- 최종 TrackLayout 기준 건설비와 전액 환급
- 구조적 preflight 검사
- 자동 운행
- 기본 수동 홀드 적재와 자동 적재 토글
- 제한 없는 CargoStack domain
- TOP 연속 동일 종류 자동 하역
- TOP 불일치 역 무정차 통과
- 전체 최대 1초의 가시 하역
- 제한 시간 성공·실패
- 일시정지 무결성
- 실패 후 TrackLayout 유지
- 동일 맵·동일 노선 재도전
- 임시 Build/Run/Result HUD
- 색상+모양 이중 화물 식별

### 제외

- 가속·저비용·일방통행·회차 선로
- 터널·교량
- Combo 가속과 Combo 점수
- 신속·절약·점수 별과 리더보드
- 튜토리얼 1~10 전체와 챕터
- 추천 ghost 노선
- 일일·주간 절차 생성
- 꾸미기·보상
- 최종 아트·사운드 품질
- UGC·온라인 backend

제외 항목을 위한 과도한 일반화나 미사용 hook을 첫 Slice에 만들지 않는다.

## 5. Identity 계약

### MapDefinition v2

`MapDefinition`은 완성된 RailGraph가 아니라 변경되지 않는 수작업 스테이지 입력을 소유한다.

```text
definition_schema_version = 2
map_id
map_revision
ruleset_version
start_cell
incoming_cell
buildable_cells
blocked_cells
station_placements
cargo_placements
time_limit_seconds
```

기존 generated-map manifest는 schema v1 역사 자료로 남긴다. finite pipeline은 v1을 암묵 변환하지 않으며 v2만 받는다. 기존 `graph_signature`, generated `layout_signature`, pickup respawn signature는 새 제품 identity로 사용하지 않는다.

### TrackLayout

플레이어가 만든 해답은 별도 `TrackLayout`이 소유한다.

```text
cell
geometry: STRAIGHT | CURVE | SWITCH | CROSSING
rotation_quarters: 0..3
switch_initial_exit
```

`layout_signature`는 조각을 셀 좌표와 geometry 순으로 정렬해 canonical serialization한 뒤 SHA-256으로 계산한다. 설치 순서, 철거 이력, UI 선택 상태는 포함하지 않는다.

### Attempt identity

```text
map_identity = map_id + map_revision
solution_identity = map_identity + ruleset_version + layout_signature
attempt_identity = solution_identity + attempt_serial
```

같은 맵·같은 TrackLayout 재도전은 같은 `solution_identity`를 유지하고 `attempt_serial`만 증가한다.

## 6. 건설 domain

### BuildSurface

- `buildable_cells`: 선로 설치 가능
- `blocked_cells`: 선로 설치 불가
- 역·화물·시작점 셀은 맵이 명시한 rail anchor를 제공
- 장식물은 buildability 권위가 아님

### 편집 명령

- `place_piece`
- `rotate_piece`
- `replace_piece`
- `remove_piece`
- `clear_layout`

모든 명령은 성공 여부와 이유를 반환한다. 실패한 편집은 비용·layout·signature를 변경하지 않는다.

### 비용

| 형태 | 비용 |
|---|---:|
| 직선·곡선 | 100 `TEST_VALUE` |
| 분기·교차 | 200 `TEST_VALUE` |

```text
build_cost = 현재 TrackLayout에 존재하는 조각 비용 합
```

철거·교체 시 이전 조각 비용을 전액 차감한다. 설치·철거 누적 소비액은 기록하지 않는다.

### 최소 UX

- 선택 셀과 설치 미리보기
- 유효·무효 설치를 색상+형태로 구분
- 현재 비용
- 무효 이유 한 문장
- preflight PASS 전 시작 버튼 비활성
- Undo/Redo history는 필수 아님

## 7. 선로 그래프 의미

- 직선: 반대쪽 두 edge
- 곡선: 직각 두 edge
- 분기: 한 진입과 두 출구, 활성 출구 하나
- 교차: 가로 pair와 세로 pair가 독립, 교차점 회전 금지

첫 Slice에는 일방통행과 회차가 없으므로 rail edge는 분기 선택을 제외하고 양방향이다. 열차 진행 방향은 이전 셀과 현재 셀로 결정한다.

분기 규칙:

- 다시 조작할 때까지 상태 유지
- 열차가 분기 셀을 점유한 동안 변경 금지
- 통과 후 자동 복귀 없음
- 탭할 때 다음 유효 출구로 순환

## 8. Preflight 계약

Preflight는 구조적으로 명백한 실패만 막고 LIFO 해답을 대신 풀지 않는다.

### 검사함

1. 시작점과 incoming 연결 유효성
2. 조각 edge와 이웃 조각·anchor의 대칭 연결
3. 모든 역·화물 anchor가 시작점과 같은 component에 있음
4. 교차의 두 독립 pair가 junction으로 합쳐지지 않음
5. 분기의 모든 선택 출구가 유효 선로로 이어짐
6. reachable permanent dead-end 없음
7. 고립 조각과 dangling edge 없음

첫 Slice에는 종착역 규칙이 없으므로 reachable degree-1 rail endpoint는 permanent trap이다. 시작점도 폐쇄 순환망의 일부여야 한다. 향후 terminal 규칙이 별도로 승인되면 ruleset을 올려 확장한다.

### 검사하지 않음

- 적재 순서 정답
- 수동 적재 타이밍
- 분기 조작 순서
- 제한 시간 내 성공 가능성
- 최소 비용과 최대 그룹

### 결과 코드

```text
PASS
EMPTY_LAYOUT
INVALID_START
DANGLING_EDGE
DISCONNECTED_REQUIRED_POINT
INVALID_CROSSING
INVALID_SWITCH_EXIT
PERMANENT_TRAP
```

실패 결과는 문제 셀 목록과 단일 핵심 설명을 제공한다.

## 9. 운행 상태 계약

```text
BUILD → READY → RUNNING → UNLOADING → RUNNING
                    ↕          ↕
                  PAUSED ←─────┘
RUNNING | UNLOADING → SUCCESS | FAILURE → BUILD
```

- BUILD/READY에서 run clock은 0
- RUNNING과 UNLOADING에서 run clock 진행
- RUNNING 또는 UNLOADING에서 pause 가능
- PAUSED는 이전 active state를 기억하고 그 상태로 복귀
- PAUSED에서 clock·이동·하역 animation·분기·적재 모드 변경 모두 정지
- SUCCESS/FAILURE seal 이후 domain mutation 금지
- FAILURE 후 MapDefinition과 TrackLayout 유지
- 열차·화물·스택·분기·clock은 초기 상태로 재생성

## 10. 적재·LIFO 계약

### Cargo placement

- 지점당 화물 1개
- 적재 전까지 맵에 유지
- 적재 후 제거
- run 중 재생성 없음

### 적재 입력

```text
manual_mode: 기본
auto_mode: 토글
manual_load_active: 적재 버튼 hold 중 true
```

화물 셀 진입 시 auto mode거나 manual hold 중이면 적재한다. 그 외에는 맵에 남긴다. 적재 때문에 정차·감속하지 않는다.

### CargoStack

- domain capacity 제한 없음
- push는 TOP에 추가
- 역은 TOP부터 같은 종류가 연속되는 수만 pop
- 기존 capacity 8 guard와 cargo-count slowdown을 호출하지 않음

## 11. 역·하역 계약

```text
unload_count = TOP부터 station_type과 연속 일치하는 수
```

- 0개면 무정차 통과
- 1개 이상이면 정차 후 그룹 전체 하역
- domain pop은 하나의 원자적 결과로 확정
- 표현 계층은 각 화물이 내려가는 모습을 모두 보여줌
- `0 < unload_duration_seconds <= 1.0`
- 화물이 많을수록 개당 간격을 줄이되 총 시간이 1초를 넘지 않음
- 하역 중 pause하면 animation과 clock이 함께 정지
- 첫 Slice에서는 Combo 가속·점수를 적용하지 않음
- `unload_count` event는 FP-03 소비를 위해 보존

하역 domain commit timestamp는 역 진입 시점이다. 성공 화면은 하역 animation 종료 후 표시하되, 제한 시간과 성공 우선순위는 commit timestamp를 기준으로 판정한다.

## 12. 성공·실패 계약

### 성공

```text
remaining_map_cargo == 0
and cargo_stack_size == 0
and delivered_cargo_count == authored_total_cargo
```

마지막 하역 animation이 끝나면 성공 화면을 표시한다. 시작점 복귀와 종착지 도착은 요구하지 않는다.

### 실패

run clock이 `time_limit_seconds`에 도달했을 때 미배송 화물이 하나라도 있으면 실패한다.

```text
undelivered = remaining_map_cargo + cargo_stack_size
```

같은 simulation step에서 마지막 하역과 제한 시간이 겹치면:

- 하역 commit timestamp가 제한 시각 이하: SUCCESS
- 제한 시각을 초과: FAILURE

## 13. 대표 Slice 맵

`FP_CORE_PROOF_01` 수작업 맵을 추가한다.

- A/B 화물, 색상+모양 동시 사용
- 화물 4개: A, B, A, A
- A역 1개, B역 1개
- 분기 최소 1개
- 교차 최소 1개
- 건설 불가 셀 최소 4개
- 단순 최단 연결만으로는 LIFO 완주 불가
- 최소 2개의 완주 가능한 TrackLayout
- 권장 정답 runtime 내장 금지
- 제한 시간 90초 `TEST_VALUE`

이 맵은 아트 품질이 아니라 핵심 인과 증명용이다.

## 14. 임시 제품 화면

### Build HUD

- 선로 형태, 회전, 철거, 전체 초기화
- 현재 비용
- preflight 상태와 문제 셀
- 운행 시작

### Run HUD

- 남은 시간
- 수동 적재 hold
- 자동 적재 토글과 현재 상태
- CargoStack bottom→TOP 순서와 TOP 강조
- 남은 맵 화물 수
- 일시정지

### Result HUD

- 성공/실패
- 완료/경과 시간
- 최종 건설비
- 배송 수·미배송 수
- 최대 연속 하역 수는 분석값으로만 표시 가능
- 같은 노선 재도전
- 노선 수정

최종 아트가 아니더라도 Android landscape에서 조작 가능한 최소 터치 크기와 색상+모양 구분을 지킨다.

## 15. 기존 코드 처리

### 직접 재사용 후보

- `TrainController`: 셀 기반 자동 이동과 진행 방향 의미
- `CargoStack`: push와 TOP 연속 pop 의미
- `Station.try_unload`: station type과 TOP group 비교 의미
- `RunIdentity` 계열: immutable identity 패턴
- 기존 테스트 harness

### 수정 후 재사용

- `MapDefinition`: generated graph 소유에서 authored stage 입력 소유로 전환
- `MapBuildPipeline`: generator 조합에서 authored MapDefinition + TrackLayout build로 교체
- `DeliveryLoop`: pickup respawn 제거, fixed cargo와 manual/auto 적재 사용
- `RunController`: fuel·difficulty·BOOST 제거, finite clock과 seal 사용
- `RunState/RunSummary`: finite state·result로 교체
- gameplay input: BOOST 대신 load hold·auto toggle·pause

### Legacy 격리

- `game/difficulty/*`
- fuel drain/recovery/fuel-zero
- BOOST 입력
- cargo capacity 8
- cargo-count slowdown
- CargoSpawner respawn/process loop
- switch auto-reset
- endless score/survival summary

첫 Slice 개발 중 legacy 파일을 바로 삭제하지 않는다. 새 Slice가 독립 harness와 대표 맵에서 PASS한 뒤 제품 entrypoint를 전환하고, 후속 migration PR에서 삭제 또는 `legacy/` 격리를 결정한다.

## 16. 구현 package

### FP-01A — Identity and TrackLayout

- authored MapDefinition v2
- TrackPiece/TrackLayout
- canonical signature와 비용
- unit tests

### FP-01B — Graph and Preflight

- TrackGraphBuilder
- switch/crossing semantics
- PreflightValidator
- adversarial fixtures

### FP-01C — Minimal Build Surface

- 편집 command
- 임시 Build HUD
- cost/preflight feedback
- 대표 맵 배치

### FP-02A — Fixed Cargo and Loading

- fixed cargo placement
- manual hold/auto toggle
- unlimited CargoStack
- respawn/capacity/slowdown 비활성

### FP-02B — Finite Delivery Run

- station skip/group unload
- maximum-one-second presentation
- finite clock·pause·success/failure

### FP-02C — Integration and Cutover Evidence

- Build→Run→Result→Build
- same-layout retry
- 대표 맵 acceptance
- Android smoke
- human comprehension

각 package는 별도 PR로 만들 수 있지만 전체 수용 기준을 만족하기 전에는 Vertical Slice 완료로 표시하지 않는다.

## 17. 테스트 계획

### Unit

- `tests/build/test_track_layout.gd`
- `tests/build/test_track_graph_builder.gd`
- `tests/build/test_preflight_validator.gd`
- `tests/map/test_authored_map_definition.gd`
- `tests/run/test_finite_run_state.gd`
- `tests/run/test_finite_run_controller.gd`
- `tests/cargo/test_unlimited_cargo_stack.gd`
- `tests/delivery/test_fixed_delivery_loop.gd`

### Integration

- `tests/integration/test_build_to_delivery_slice.gd`
- `tests/integration/test_lifo_revisit_proof.gd`
- `tests/integration/test_failed_run_preserves_layout.gd`
- `tests/integration/test_pause_integrity.gd`
- `tests/integration/test_solution_identity_retry.gd`

### Adversarial fixtures

- disconnected station/cargo
- dangling edge와 고립 조각
- crossing을 junction으로 잘못 처리
- switch exit dead-end
- duplicate piece와 invalid rotation
- failure exactly at limit
- last unload exactly at limit
- 32 cargo stack
- repeated pause/resume
- auto toggle immediately before cargo entry

### Regression

- 재사용되는 RailGraph·TrainController·CargoStack 의미 유지
- fuel/BOOST/difficulty 테스트는 old contract 역사로 분리
- old tests를 새 finite product PASS 수치에 합산하지 않음

## 18. 검증 Gate

### 자동

- Project Contract PASS
- Godot headless full suite PASS
- 새 Slice tests 0 failure
- `layout_signature` 100회 반복 일치
- 대표 맵 100회 동일 초기 상태 재구성
- 준비된 structural invalid fixture false-negative 0

### Android smoke

- landscape 실제 기기 또는 공식 emulator
- 설치·회전·철거 가능
- 적재 hold와 분기 탭이 충돌하지 않음
- Stack TOP 판독 가능
- pause 후 상태 손상 없음
- 실패 후 layout 유지

### 사람 검증

최소 5명에게 정답 설명 없이 대표 맵을 제공한다.

- 4명 이상이 마지막 적재가 TOP임을 설명
- 4명 이상이 A/B/A/A 재방문 이유를 설명
- 4명 이상이 실패 후 노선을 수정해 재도전
- 성공자가 성공 원인을 반응속도가 아닌 노선·적재·LIFO 판단으로 설명

작은 표본이므로 제품 전체 사용자성 확정 증거로 과장하지 않는다.

## 19. Rollback·cutover

1. FP-01A~FP-02B 동안 기존 default runtime entrypoint 유지
2. 새 Slice는 별도 integration harness 또는 scene에서 검증
3. FP-02C PASS 후 default product entrypoint를 finite Slice로 전환
4. cutover는 old entrypoint로 되돌리는 단일 revert가 가능해야 함
5. 기존 profile을 파괴하지 않고 finite progress namespace 추가
6. legacy 삭제는 안정화 뒤 별도 PR

테스트용 병렬 존재는 허용하지만 player-facing entrypoint는 한 시점에 하나만 권위다. 두 제품 규칙을 한 run에 섞는 feature flag 운영은 금지한다.

## 20. Stop Conditions

다음 중 하나라도 발생하면 후속 package를 멈추고 설계를 재검토한다.

- 선로 배치가 화물 조우 순서를 안정적으로 결정하지 못함
- preflight가 LIFO 해답까지 자동으로 품
- 무제한 stack 때문에 TOP 판독 불가
- 수동 적재가 짧은 프레임 반응 시험이 됨
- 분기 조작과 적재 hold가 모바일에서 충돌
- fuel/BOOST/difficulty가 새 결과에 영향
- 같은 MapDefinition+TrackLayout 재도전 결과가 비결정적
- 대표 맵 완주 해법이 사실상 하나뿐임

## 21. 완료 선언 조건

다음을 모두 충족해야 `FP-01 + FP-02 FIRST SLICE COMPLETE`로 선언한다.

- FP-01A~C·FP-02A~C 수용 기준 PASS
- 대표 A/B/A/A 맵 수동 완주 증거
- 실패·수정·재도전 증거
- headless tests PASS
- Android smoke PASS
- 5명 comprehension 기준 PASS
- legacy runtime을 새 product PASS로 오표기하지 않음
- GitHub 정본·감사·correct Google Sheet same-ID readback PASS
- 미해결 PR thread 0, REQUEST_CHANGES 0

## 22. 자체 검토

- 빈 섹션·TBD·TODO 없음
- 제품 정본과 LIFO 충돌 없음
- MapDefinition v1/v2 구분 명시
- 하역 중 pause와 제한 시간 우선순위 명시
- FP-03 이후 기능을 선행 구현하지 않음
- 재사용과 legacy 제거를 구분
- 실행 전 구현·Android·사람 검증을 PASS로 표시하지 않음
- 현재 상태는 사용자 문서 검토 대기이며 코드 구현 권한이 아님
