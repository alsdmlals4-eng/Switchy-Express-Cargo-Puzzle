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

## 기차·화차

- 기관차는 cells-per-second 속도를 외부에서 주입받음
- RailGraph 경로를 연속 보간하며 cell boundary 이벤트 발생
- 최대 8개 화차
- 이동 거리 기준 1칸 간격의 제한된 route history
- 직선·곡선·분기에서 겹침·즉시 반전 방지
- 현재 열차 점유 칸과 전방 경로 조회 API 제공

상태: `IMPLEMENTED · PASSED`.

총기획 공백: CargoStack item 수와 실제 표시 화차 수의 관계·빈 화차 표현·화차 추가/제거 시점.

## 화물 스택

- 타입: `RED_STAR`, `BLUE_DIAMOND`, `YELLOW_TRIANGLE`
- capacity: 8
- LOAD 활성 시에만 적재
- BOOST 요청이 있으면 LOAD 비활성
- stack top은 마지막 적재
- `unload_order()`는 실제 stack의 역순
- 제품 HUD는 이 ViewModel을 소비

상태: `IMPLEMENTED · PASSED`.

## 화물 생성

- 맵 pickup 최소: 색상별 4개
- 적재 후 1초 지연 재생성
- 금지: 기차·화차, 역, 분기기, 기존 pickup, 전방 2칸, 직전 수집 칸
- 한 칸에 pickup 최대 1개
- 동일 seed·점유 상태에서 재현
- 유효 칸이 없으면 `SPAWN_DEFERRED`
- DeliveryLoop가 pending request를 처리해 실제 런타임 최소 수량을 회복

상태: `IMPLEMENTED · PASSED`.

남은 검증: 장시간 starvation, 10분 soak, 실제 플레이 공정성.

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

상태: `IMPLEMENTED · PASSED`.

## VS-03 생존 경제 권위

권장 책임 경계:

```text
DeliveryLoop
→ 픽업·하역 도메인 이벤트

RunBalance
→ 순수 속도·연료·배송 보상 계산

RunState
→ elapsed·fuel·score·combo·game-over의 단일 상태

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

| 연속 하역 | 기본 점수 | 연료 |
|---:|---:|---:|
| 1 | 100 | 5 |
| 2 | 260 | 12 |
| 3 | 540 | 21 |
| 4 | 960 | 32 |
| 5+ | `300 × 개수` + 콤보 | `8 × 개수` |

추가 시험식:

```text
speed_bonus = 1.25 if 이전 배송 후 8초 이내 else 1.0
heavy_bonus = 1.15 if 배송 직전 화물 6개 이상 else 1.0
final_score = round(base_combo_score × speed_bonus × heavy_bonus)
```

BOOST 사용 시간 자체, 무입력 이동, 빈 역 통과에는 점수를 주지 않는다.

## 콤보·보상 의미 공백

다음은 상세 수치가 아니라 플레이어 경험 의미를 바꿀 수 있어 총기획 감사 대상이다.

- 콤보가 한 번의 동일색 그룹 크기인지, 연속 배송 streak인지
- 큰 stack의 위험을 점수 보너스로 얼마나 직접 보상할지
- 실패 직전의 저연료 배송을 별도 위험 보상으로 강조할지
- 이 선택은 기존 문서가 혼용하는지 확인한 뒤 필요할 경우 Grill Me로 확정

## 무조작·악용 방지

- 입력 0회에서 180초 이내 fuel 0·score 0을 기본 자동 검증 목표로 둠
- 기본 노선 반복의 기대 연료 수지는 음수
- 화물 감속으로 연료 소모를 줄일 수 없음
- BOOST 상시 사용이 평균 생존 최적해가 아니어야 함
- 빈 역·무입력·같은 셀 반복으로 보상 없음
- spawn·event·route history는 무한 증가하지 않음

분류: 자동 검증 가능한 계약 + 실제 밸런스는 플레이테스트 필요.

## 결과·저장 권장 계약

분류: `RECOMMENDED_DEFAULT`

저장 대상:

- `best_score`
- `longest_survival_seconds`
- `max_combo`
- `schema_version`

원칙:

- 기록 구현은 VS-03B 소유
- Issue #7은 지속성·손상 fallback·soak 검증을 소유
- 저장 실패가 현재 run 결과를 파괴하지 않음
- 손상·알 수 없는 버전은 안전한 기본값으로 격리하고 원본을 덮어쓰기 전 오류 기록
- 게임 규칙·레벨·seed history 전체 저장은 Vertical Slice 범위 밖

## 구현 상태

| 영역 | 상태 |
|---|---|
| Godot·RailGraph·분기 | IMPLEMENTED · PASSED |
| 기차·화차 | IMPLEMENTED · PASSED |
| 화물·역·LIFO | IMPLEMENTED · PASSED |
| DeliveryLoop 런타임 최소 수량 | IMPLEMENTED · PASSED |
| 속도·연료·점수·BOOST | NOT_STARTED · TEST_VALUES_DEFINED |
| 게임오버·결과·기록 | NOT_STARTED |
| 제품 HUD·Android·플레이테스트 | NOT_RUN |
