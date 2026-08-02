# Core Systems

## 상태 범례

- `CONFIRMED`: 사용자 승인 규칙
- `IMPLEMENTED`: 실제 코드 존재
- `PASSED`: 자동 검증 통과
- `RECOMMENDED_DEFAULT`: 권장 초기 구조
- `TEST_VALUE`: 플레이테스트 전 시험 수치
- `NOT_RUN`: 실행 증거 없음

## 시스템 위계

핵심 시스템:

```text
선택 적재 LIFO
+ 자동 운행·선행 분기
+ station 연속 그룹 하역
+ 생존 경제
+ BOOST 위험 교환
+ compact rear-item 가독성
```

보조 시스템:

```text
onboarding·HUD/camera/result
+ restart/maps
+ records/cosmetics/Profile
+ telemetry/evidence
+ target100/UGC Production
```

기술 구현은 보조 시스템의 편의보다 LIFO 적재 순서와 노선 계획의 가독성·신뢰성을 우선한다.

상세 위계: `기획서/10_경험/CORE_FUN_SYSTEM_HIERARCHY.md`.

## 현재 구현 증거

```text
VS03-01 PR #37 merge 43972d3d23e931af3dbc81ab9b1c7d942fffb201
Project Contract 227 PASS
Godot Tests 214 PASS
16 cases · 7110 assertions · 0 failures
```

현재 권위:

```text
VS03-01 run core · MERGED_AND_VERIFIED
→ VS03-02 compact token/TrainFootprint/occupancy · READY_FOR_BUILD
```

## RailGraph·분기 기반

- 맵 크기 15×10
- 전체 선로 하나의 연결 요소
- degree-1 막다른길 0
- cycle rank 최소 3
- 2단계 분기 최소 4개
- 3단계 분기 최소 2개
- 각 유효 분기 경로 최소 3칸
- 같은 seed는 같은 graph signature
- 32회 후보 실패 시 결정론적 safe fallback
- 직진 가능한 경우 기본 A 노선은 직진 우선
- 5칸 preview 첫 칸과 실제 다음 칸 동일
- segment 진입 뒤 목표 exit 잠금

상태: `IMPLEMENTED · PASSED`.

남은 증거: target3/target100 unique layout, 경로 entropy, 제품 화면 가독성.

## 기차·compact wagon tokens — SX-DEC-015

기존 구현:

- cells-per-second 속도를 외부에서 주입
- RailGraph 경로 연속 보간과 cell boundary event
- bounded route history
- `seconds_to_next_cell()`
- fractional path sampling seam
- 직선·곡선·분기 추종
- 현재 열차 점유와 전방 경로 조회

확정 제품 계약:

```text
compact_wagon_token_count = cargo_stack.size()
front → rear token order = stack bottom → stack top
rear token = next LIFO unload item
```

- 화물 0이면 기관차만 표시
- 적재하면 chain 뒤에 cargo token 1개 추가
- 유효 하역은 뒤쪽부터 같은 type 연속 그룹 제거
- 색상+모양 이중 부호
- full-size 1-cell wagon을 cargo마다 추가하지 않음
- CargoStack·token count/order·점유를 같은 domain step에서 commit
- rendering·motion은 committed state 표현만 담당

상태: `CONFIRMED · VS03-02_READY_FOR_BUILD`.

### compact geometry 시험값

```text
token_body_length = 0.22 cell
token_center_spacing = 0.28 cell
8-token chain length = 2.18 cells
max_reserved_trailing_footprint = 3 cells
```

- 불변조건: 8개 개별 식별, trailing 점유 최대 3칸, route/station/switch 가독성
- fractional path-history offset 사용
- curve 안쪽 corner cutting 금지
- tight turn에서 token order swap 금지

### spawn occupancy 계약

- cargo 8개를 8 full-size occupied cells로 계산하지 않음
- 기관차와 compressed token chain이 실제 교차하는 rail cells만 점유
- trailing exclusion 최대 3칸
- 기존 forward 2-cell safety exclusion 별도 유지
- animation 중에도 committed compact footprint가 spawn authority

상세: `docs/superpowers/specs/2026-08-02-compact-cargo-wagon-tokens-design.md`.

## 화물 스택

- type: `RED_STAR`, `BLUE_DIAMOND`, `YELLOW_TRIANGLE`
- capacity 8
- LOAD 활성 시에만 적재
- BOOST 요청 시 LOAD 비활성
- stack top은 마지막 적재
- `unload_order()`는 실제 stack 역순
- HUD와 compact token ViewModel은 같은 상태 소비

상태: `IMPLEMENTED · PASSED`.

## 화물 생성

- map pickup 최소 색상별 4개
- 적재 후 1초 지연 재생성
- 금지: committed train footprint, station, switch, existing pickup, forward 2 cells, last collected cell
- 한 칸 pickup 최대 1개
- 동일 seed·occupancy에서 재현
- 유효 칸 없으면 `SPAWN_DEFERRED`
- DeliveryLoop가 pending request를 처리해 runtime 최소 수량 회복

현재 구현은 `train.train_cells()` full-cell occupancy를 사용한다. VS03-02에서 optional occupancy provider를 추가하고 product path에 TrainFootprint를 주입한다. legacy null-provider behavior는 보존한다.

상태: 생성·회복 `IMPLEMENTED · PASSED`; compact occupancy `READY_FOR_BUILD`.

남은 증거: 0/1/4/8 token occupancy, long-run starvation, 10-minute soak, 실제 공정성.

## 스테이션

- 빨강·파랑·노랑 각 2개, 총 6개
- 일반 선로 위 배치
- switch·train start cell 제외
- 동색 두 역 그래프 최단거리 최소 5칸
- 동일 seed에서 동일 배치
- 실패는 명시적 bounded failure

상태: `IMPLEMENTED · PASSED`.

## LIFO 하역

- top과 station type이 다르면 0개
- top부터 같은 type 연속 그룹만 하역
- 적재 `R,R,B,R`의 하역 순서 `R,B,R,R`
- 하역 전후 Unload Order·count·items·station을 result Dictionary로 반환
- 같은 event가 compact rear group·HUD first group·RunController Combo의 입력

상태: LIFO domain `IMPLEMENTED · PASSED`; token consumer `VS03-02_READY`.

## Combo — SX-DEC-014

```text
combo_count = one-arrival unload_group_size = try_unload().count
max_combo = run 최대 combo_count
```

- 배송 이벤트 local 값이며 streak state가 아님
- `seconds_since_delivery` 기반 speed bonus와 분리
- empty/mismatch arrival은 Combo·score·fuel reward 0
- telemetry는 unload group과 bonus flags 분리
- 저장은 max_combo

상태: `IMPLEMENTED · PASSED`.

## VS03-01 생존 경제 권위

책임 경계:

```text
DeliveryLoop
→ pickup/unload domain event

RunBalance
→ pure speed/fuel/delivery reward formula

RunState
→ elapsed/fuel/score/last_combo/max_combo/phase/end reason

RunMetricsAccumulator
→ bounded pickup/delivery/unload/boost metrics

DifficultyDirector
→ pressure forecast/commit level and band

RunController
→ boundary-sliced time, DeliveryLoop event, Train speed, difficulty, fuel-zero, summary

HUD·Animation
→ read-only presentation
```

상태: `IMPLEMENTED · HEADLESS_PASSED`.

### 속도 시험식

```text
base_speed(t) = min(3.4, 1.8 + 0.08 × floor(t / 30초))
cargo_multiplier(n) = max(0.64, 1.0 - 0.045 × n)
boost_multiplier = 1.45 if BOOST else 1.0
current_speed = base_speed × cargo_multiplier × boost_multiplier
```

검증됨:

- cargo 0~8 multiplier
- cargo slowdown이 fuel drain을 할인하지 않음
- compact geometry는 slowdown에 영향 없음; CargoStack size만 사용
- BOOST speed multiplier

남은 증거: 실제 분기 판단 시간, Android 화면, economy simulation.

### 연료 시험식

```text
fuel_max = 100
fuel_start = 65
base_drain(t) = 1.0 + 0.12 × floor(t / 45초)
boost_drain_multiplier = 2.4
```

검증됨:

- 실제 경과 시간 기준 drain
- cargo slowdown과 drain 분리
- pause 중 clock/drain 정지
- fuel-zero one-shot end
- 종료 뒤 mutation 없음
- summary immutable

### 하역 보상 시험값

| Combo | base score | fuel |
|---:|---:|---:|
| 1 | 100 | 5 |
| 2 | 260 | 12 |
| 3 | 540 | 21 |
| 4 | 960 | 32 |
| 5+ | `300 × count` | `8 × count` |

```text
speed_bonus = 1.25 if previous valid delivery ≤8 sec else 1.0
heavy_bonus = 1.15 if pre-unload cargo ≥6 else 1.0
final_score = round(base_unload_score × speed_bonus × heavy_bonus)
```

- base score는 이번 unload group만으로 결정
- bonus는 Combo 정의가 아님
- BOOST uptime, no-input movement, empty station은 score 0
- speed와 heavy 동시 최대 multiplier는 1.4375
- 모든 값은 `TEST_VALUE`

## Difficulty authority alignment finding — SX-AUD-007-F87

승인 계약은 DifficultyDirector가 escalation schedule·commit을 단독 소유하도록 요구한다.

현재 코드:

```text
speed boundary: 30 sec
fuel-drain boundary: 45 sec
difficulty commit: 30 sec
```

따라서 45초·135초 등의 fuel pressure change는 별도 forecast/commit 없이 발생할 수 있다.

상태: `P1 SAFE_IMPLEMENTATION_CORRECTION_CANDIDATE`.

권장 보정:

- 모든 실제 speed/fuel pressure boundary를 DifficultyDirector schedule에 포함하거나
- DifficultyDirector가 next balance boundary와 pressure snapshot을 소유하도록 통합
- balance 값이 바뀌었는데 authoritative forecast/commit이 없는 시각 0 테스트
- presentation 구현 전 수정

이는 player-facing 규칙 변경이 아니라 승인된 authority contract 정렬이다.

## 핵심 재미 적대적 검증

### 단색 적재 지배 위험 — F89

LOAD가 선택형이므로 한 색만 골라 싣고 같은 색 역으로 배달하는 방식이 거의 항상 우월하면 mixed-stack LIFO 계획이 사라진다.

필수 지표:

- mixed-stack run/segment 비율
- stack distinct-type count
- mono-color delivery 비율
- blocked/mismatch cargo 보유 시간
- Combo 1/2/3/4/5+ 분포
- score 중 base/speed/heavy 기여

수치 목표는 simulation과 human play에서 정한다. 지금 즉시 강제 혼합 규칙을 추가하지 않는다.

### bonus 위계

- 큰 group의 cargo당 base score: 100 →130 →180 →240 →300
- large group을 직접 보상하는 방향은 적합
- speed/heavy bonus가 planning choice를 역전하는지 측정 필요
- 성공 설명이 “빠르게 눌렀다”보다 “순서와 경로를 만들었다”여야 함

### BOOST exploit

- 항상 켜는 것이 생존·점수 모두 최적이면 실패
- BOOST로 LOAD를 포기하는 기회비용이 실제로 발생해야 함
- 저연료 panic button으로만 쓰여도 반복 전략이 얕아질 수 있음

### heavy bonus exploit

- 무관한 cargo를 계속 들고 다니는 것이 점수 최적이면 실패
- heavy bonus는 intentional risk를 보상하되 blocked stack을 장려하지 않아야 함

## 무조작·악용 방지

- 입력 0회에서 configured bound 내 fuel zero, score 0
- 기본 노선 반복의 기대 fuel 수지 음수
- cargo slowdown으로 drain 할인 불가
- BOOST 상시 사용이 평균 생존 최적해가 아니어야 함
- empty station·no-input·same-cell repeat reward 없음
- spawn/event/route history bounded
- compact token 적용 뒤 pickup이 footprint 위에 생성되면 안 됨

자동 계약은 일부 검증됐고 실제 밸런스·지배 전략은 simulation/human test가 필요하다.

## 결과·저장 계약

표준 기록:

- `best_score`
- `longest_survival_seconds`
- `best_max_combo`

- current-map + global official scope atomic commit은 VS03-04
- save failure가 current result/restart를 파괴하지 않음
- corrupt/unknown version은 안전 격리
- compact token visual state는 저장하지 않고 CargoStack에서 재구성
- ProfileStore/TransactionService single writer

## 구현 상태

| 영역 | 상태 |
|---|---|
| Godot·RailGraph·분기 | IMPLEMENTED · PASSED |
| 화물·역·LIFO·spawn recovery | IMPLEMENTED · PASSED |
| VS03-01 Combo·속도·연료·BOOST·game-over·summary·difficulty core | IMPLEMENTED · HEADLESS_PASSED |
| compact wagon token·TrainFootprint·occupancy provider | VS03-02 READY_FOR_BUILD |
| target3 map/session/restart/selection | BLOCKED · VS03-03 |
| Profile·records·cosmetics·rewards | BLOCKED · VS03-04 |
| product Scene·HUD·result·camera | BLOCKED · VS03-05 |
| contextual onboarding | BLOCKED · VS03-06 |
| Android·economy simulation·human playtest | NOT_RUN |
| target100·online UGC | PRODUCTION · NOT_STARTED/NOT_RUN |
