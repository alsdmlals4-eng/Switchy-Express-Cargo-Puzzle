# Core Systems

## 상태 범례

- `CONFIRMED`: 사용자 승인 규칙
- `IMPLEMENTED`: 실제 코드 존재
- `PASSED`: 자동 검증 통과
- `RECOMMENDED_DEFAULT`: GPT 권장 초기 설계값
- `TEST_VALUE`: 플레이테스트 전 시험 수치
- `NOT_RUN`: 실행 증거 없음

## RailGraph·분기 기반

- 맵 크기: 15×10
- 전체 선로는 하나의 연결 요소
- degree-1 막다른길 0
- cycle rank 최소 3
- 2단계 분기 최소 4개
- 3단계 분기 최소 2개
- 각 유효 분기 경로 최소 3칸
- 같은 seed는 같은 graph signature
- 32회 후보 실패 시 결정론적 safe fallback
- 직진 가능한 경우 기본 A노선은 직진 우선
- 5칸 preview 첫 칸과 실제 다음 칸 동일
- segment 진입 뒤 목표 exit 잠금

상태: `IMPLEMENTED · PASSED`.

남은 검증: unique-map 수·경로 엔트로피·실제 화면 가독성.

## 기차·compact wagon tokens — SX-DEC-015

기존 기반:

- 기관차는 cells-per-second 속도를 외부에서 주입받음
- RailGraph 경로를 연속 보간하며 cell boundary 이벤트 발생
- TrainState는 0~8 wagon count와 bounded route history 제공
- 직선·곡선·분기에서 위치 추종
- 현재 열차 점유 칸과 전방 경로 조회 API 제공

확정 제품 계약:

```text
compact_wagon_token_count = cargo_stack.size()
front → rear token order = stack bottom → stack top
rear token = next LIFO unload item
```

- 화물 0개에서는 기관차만 표시한다.
- 적재는 token chain 뒤에 해당 cargo_type 토큰 1개를 추가한다.
- 유효 하역은 뒤쪽부터 같은 cargo_type 연속 토큰 그룹을 제거한다.
- 토큰은 색상+모양 이중 부호를 가진다.
- full-size 1-cell wagon을 화물마다 추가하지 않는다.
- CargoStack 변경과 token count/order·점유 갱신은 같은 도메인 단계에서 완료한다.
- 렌더링·추가/제거 모션은 이미 확정된 상태를 표현하며 권위를 갖지 않는다.

상태: `CONFIRMED · PLANNING_SPEC_APPROVED · IMPLEMENTATION_NOT_STARTED`.

### compact geometry 시험값

분류: `TEST_VALUE`.

```text
token_body_length = 0.22 cell
token_center_spacing = 0.28 cell
8-token chain length = 2.18 cells
max_reserved_trailing_footprint = 3 cells
```

- 수치는 VS-03B에서 조정 가능하다.
- Decision을 유지하기 위한 불변조건은 8개 개별 식별, trailing 점유 최대 3칸, 경로·역·분기 가독성 보존이다.
- 토큰은 fractional path-history offset을 사용해 곡선 안쪽을 가로지르지 않는다.
- tight turn에서도 token ordering이 바뀌면 안 된다.

### spawn occupancy 계약

- 화물 8개를 8개의 full-size 점유 칸으로 계산하지 않는다.
- 생성 금지는 기관차와 압축 token chain이 실제로 교차하는 rail cell만 포함한다.
- 8개 적재의 trailing exclusion은 최대 3칸으로 bounded한다.
- 기존 전방 2칸 안전 exclusion은 별도 유지한다.
- token animation 중에도 committed compact footprint가 생성 공정성의 권위다.

상세 규격: `docs/superpowers/specs/2026-08-02-compact-cargo-wagon-tokens-design.md`.

## 화물 스택

- 타입: `RED_STAR`, `BLUE_DIAMOND`, `YELLOW_TRIANGLE`
- capacity: 8
- LOAD 활성 시에만 적재
- BOOST 요청이 있으면 LOAD 비활성
- stack top은 마지막 적재
- `unload_order()`는 실제 stack의 역순
- 제품 HUD와 compact token ViewModel은 이 상태를 소비

상태: `IMPLEMENTED · PASSED`.

## 화물 생성

- 맵 pickup 최소: 색상별 4개
- 적재 후 1초 지연 재생성
- 금지: committed compact train footprint, 역, 분기기, 기존 pickup, 전방 2칸, 직전 수집 칸
- 한 칸에 pickup 최대 1개
- 동일 seed·점유 상태에서 재현
- 유효 칸이 없으면 `SPAWN_DEFERRED`
- DeliveryLoop가 pending request를 처리해 실제 런타임 최소 수량을 회복

현재 구현은 full-cell wagon count 기반 점유를 사용하므로 `SX-DEC-015` 구현 시 compressed footprint로 교체해야 한다.

상태: 기존 생성·회복 `IMPLEMENTED · PASSED`; compact footprint 연결 `NOT_STARTED`.

남은 검증: 0/1/4/8 token 점유, 장시간 starvation, 10분 soak, 실제 플레이 공정성.

## 스테이션

- 빨강·파랑·노랑 각 2개, 총 6개
- 일반 선로
- 분기기·기차 시작 칸 제외
- 동색 두 역의 그래프 최단거리 최소 5칸
- 동일 seed에서 동일 배치
- 유효 배치 실패는 명시적 bounded failure

상태: `IMPLEMENTED · PASSED`.

## LIFO 하역

- top과 역 타입이 다르면 0개
- top부터 같은 타입인 연속 그룹만 하역
- `R,R,B,R`의 하역 순서 `R,B,R,R`
- 하역 전후 Unload Order, count, items, station을 결과 Dictionary로 반환
- 같은 결과 이벤트가 compact token rear group과 HUD first group을 함께 갱신

상태: LIFO 도메인 `IMPLEMENTED · PASSED`; token 소비자 `NOT_STARTED`.

## Combo 의미 — SX-DEC-014

상태: `CONFIRMED · NOT_STARTED`.

```text
combo_count = 이번 한 번의 역 도착에서 연속 하역된 동일 cargo_type 개수
max_combo = 한 판에서 기록한 combo_count 최댓값
```

필수 계약:

- `combo_count`는 `Station.try_unload()`가 반환한 `count`와 같다.
- Combo는 배송 이벤트 로컬 값이며 다음 배송까지 유지되는 streak state가 아니다.
- 빠른 배송은 `seconds_since_delivery`로 계산하는 별도 `speed_bonus`다.
- `speed_bonus`는 Combo를 증가·유지·리셋하지 않는다.
- 빈 역·타입 불일치는 `combo_count = 0`이고 보상 0이다.
- telemetry는 `unload_group_size`와 `speed_bonus_applied`를 별도 기록한다.
- 저장은 `max_combo`만 보존한다.

## VS-03 생존 경제 권위

권장 책임 경계:

```text
DeliveryLoop
→ 픽업·하역 도메인 이벤트

CargoTokenViewModel
→ CargoStack을 compact token count/order로 투영

TrainFootprint
→ 압축 token geometry의 occupied rail cells 계산

RunBalance
→ 순수 속도·연료·배송 보상 계산

RunState
→ elapsed·fuel·score·last_combo·max_combo·game-over의 단일 상태

RunController
→ DeliveryLoop 이벤트 소비, TrainController 속도 주입, run 종료

HUD·Animation
→ 상태 표현만 담당하고 도메인 결과를 소유하지 않음
```

이 책임 경계는 기술적 `RECOMMENDED_DEFAULT`이며 코어를 변경하지 않는다.

## 속도 시험식

분류: `TEST_VALUE`

```text
base_speed(t) = min(3.4, 1.8 + 0.08 × floor(t / 30초))
cargo_multiplier(n) = max(0.64, 1.0 - 0.045 × n)
boost_multiplier = 1.45 if BOOST else 1.0
current_speed = base_speed × cargo_multiplier × boost_multiplier
```

검증:

- cargo 0~8 범위 단위 테스트
- 화물 감속이 time-based 연료 소모를 낮추지 않음
- compact token 크기는 감속 계산에 영향을 주지 않고 CargoStack size만 사용
- 분기 탭 판단 시간이 실제 화면에서 확보되는지 사람 테스트
- 값 조정은 Decision 변경이 아니라 TEST_VALUE recalibration

## 연료 시험값

분류: `TEST_VALUE`

```text
fuel_max = 100
fuel_start = 65
base_drain(t) = 1.0 + 0.12 × floor(t / 45초)
boost_drain_multiplier = 2.4
```

필수 계약:

- 연료 소모는 실제 경과 시간 기준
- 화물 감속은 초당 연료 소모를 줄이지 않음
- pause 동안 run time과 drain 정지
- fuel 0은 한 번만 run 종료
- 재시작은 새 RunState를 생성
- 모션 중단·Reduced Motion에서도 결과 동일

## 하역 보상 시험값

분류: `TEST_VALUE`

| Combo=`unload_group_size` | 기본 점수 | 연료 |
|---:|---:|---:|
| 1 | 100 | 5 |
| 2 | 260 | 12 |
| 3 | 540 | 21 |
| 4 | 960 | 32 |
| 5+ | `300 × 개수` | `8 × 개수` |

추가 시험식:

```text
speed_bonus = 1.25 if 이전 유효 배송 후 8초 이내 else 1.0
heavy_bonus = 1.15 if 배송 직전 화물 6개 이상 else 1.0
final_score = round(base_unload_score × speed_bonus × heavy_bonus)
```

- `base_unload_score`는 이번 `unload_group_size`만으로 결정한다.
- `speed_bonus`와 `heavy_bonus`는 Combo 정의가 아니라 점수 배율이다.
- BOOST 사용 시간 자체, 무입력 이동, 빈 역 통과에는 점수를 주지 않는다.
- 모든 수치는 플레이테스트 전 `TEST_VALUE`다.

## 보상 의미 후속 검증

Combo 정의는 닫혔지만 아래 항목은 수치·위험 보상 검증으로 남는다.

- 큰 stack의 위험을 `heavy_bonus`가 충분히 보상하는지
- 저연료 배송을 별도 위험 보상으로 추가할 필요가 있는지
- `speed_bonus`가 LIFO 계획보다 속도 경쟁을 과도하게 앞세우는지

현재는 새 Decision을 만들지 않고 시뮬레이션·플레이테스트에서 검증한다.

## 무조작·악용 방지

- 입력 0회에서 180초 이내 fuel 0·score 0을 기본 자동 검증 목표로 둠
- 기본 노선 반복의 기대 연료 수지는 음수
- 화물 감속으로 연료 소모를 줄일 수 없음
- BOOST 상시 사용이 평균 생존 최적해가 아니어야 함
- 빈 역·무입력·같은 셀 반복으로 보상 없음
- spawn·event·route history는 무한 증가하지 않음
- compact token으로 압축해도 spawn exclusion을 누락하거나 pickup이 열차 위에 생성되면 안 됨

분류: 자동 검증 가능한 계약 + 실제 밸런스는 플레이테스트 필요.

## 결과·저장 권장 계약

분류: `RECOMMENDED_DEFAULT`.

저장 대상:

- `best_score`
- `longest_survival_seconds`
- `max_combo` — 한 번의 역 도착에서 기록한 최대 연속 하역 개수
- `schema_version`

원칙:

- 기록 구현은 VS-03B 소유
- Issue #7은 지속성·손상 fallback·soak 검증을 소유
- 저장 실패가 현재 run 결과를 파괴하지 않음
- 손상·알 수 없는 버전은 안전한 기본값으로 격리하고 원본을 덮어쓰기 전 오류 기록
- compact token visual state는 저장하지 않고 CargoStack/run state에서 재구성
- 게임 규칙·레벨·seed history 전체 저장은 Vertical Slice 범위 밖

## 구현 상태

| 영역 | 상태 |
|---|---|
| Godot·RailGraph·분기 | IMPLEMENTED · PASSED |
| 기차 full-cell wagon 기반 | IMPLEMENTED · PASSED · TO_BE_ADAPTED |
| 화물·역·LIFO | IMPLEMENTED · PASSED |
| DeliveryLoop 런타임 최소 수량 | IMPLEMENTED · PASSED |
| Combo 의미 | CONFIRMED · NOT_STARTED |
| compact wagon tokens | CONFIRMED · PLANNING_SPEC_APPROVED · NOT_STARTED |
| 속도·연료·점수·BOOST | NOT_STARTED · TEST_VALUES_DEFINED |
| 게임오버·결과·기록 | NOT_STARTED |
| 제품 HUD·Android·플레이테스트 | NOT_RUN |
