# Playtest Plan

## 가설

1. 플레이어는 3분 안에 마지막 적재 화물이 먼저 하역된다는 규칙을 이해한다.
2. 플레이어는 원하는 역을 위해 분기기를 사전에 조작한다.
3. 화물 4개 이상에서 더 싣기와 먼저 배송 사이의 고민이 발생한다.
4. 부스터를 연료와 시간을 교환하는 선택으로 사용한다.
5. 한 번의 동일 타입 연속 하역 개수가 Combo라는 것을 이해한다.
6. 작은 토큰형 화차 수로 현재 적재량을 읽고, 가장 뒤 token을 다음 하역 대상으로 인식한다.
7. 실제 첫 run 상황형 온보딩이 별도 튜토리얼 없이 LOAD·분기·LIFO·Combo를 가르친다.
8. 온보딩 안내가 자동 운행의 흐름을 과도하게 끊지 않는다.
9. 첫 세션 종료 후 점수 개선 재도전 의도가 발생한다.

## 대상

- 첫 경험 사용자 5명 이상
- 모바일 캐주얼 퍼즐 경험자와 비경험자 혼합
- Android 실제 기기 플레이
- assisted first run과 이후 일반 run을 구분해 분석

## 첫 세션 절차

1. 사용자는 사전 설명 없이 실제 첫 run을 시작한다.
2. 첫 LOAD safe pause에서 적재를 수행하거나 명시적으로 skip한다.
3. 첫 token 추가 뒤 적재량과 뒤쪽 의미를 관찰한다.
4. 첫 분기 safe pause에서 preview를 보고 경로를 선택한다.
5. 서로 다른 두 타입을 적재해 rear type부터 하역한다.
6. 같은 타입 2개 이상을 한 번에 하역해 `COMBO ×N`을 경험한다.
7. 연료 35% 이하 BOOST 안내를 본다.
8. core onboarding 완료 후 같은 run을 일반 balance로 계속한다.
9. 게임오버 뒤 자유 회고와 재도전을 관찰한다.

## 과제

1. `RED_STAR` 화물 2개를 한 번의 빨강 역 도착에서 연속 하역해 `COMBO ×2` 달성
2. 3단계 분기기를 사용해 파랑 역 방문
3. 화물 6개 이상 적재 후 token 수와 다음 하역 token 설명
4. 부스터로 연료 위기에서 배송
5. 한 판 자유 플레이

## 대표 상태 캡처

- FIRST_LOAD safe pause
- 첫 token 의미와 HUD unload order 강조
- FIRST_SWITCH safe pause와 3~5칸 preview
- mixed stack `front [A,B] rear`
- B만 먼저 하역되고 A가 남은 상태
- `COMBO ×2`
- 연료 35% 이하 BOOST hint
- core 완료 뒤 일반 run 전환
- skip·timeout·resume 상태
- Reduced Motion variants
- 0 token: 기관차만
- 1 token: 종류·rear 위치 식별
- 4 token: stack order와 HUD parity
- 8 token: 전체 chain 길이·분기/역/preview 가독성
- 곡선 위 8 token: 순서 유지·corner cutting 없음

Desktop 1920×1080 캡처는 Android 실기 증거로 간주하지 않는다.

## 계측 이벤트

| Event | 주요 값 |
|---|---|
| `run_started` | seed, map_version, assisted_first_run |
| `onboarding_started` | step, assisted_first_run |
| `onboarding_step_shown` | step, elapsed_seconds, pause_requested |
| `onboarding_step_completed` | step, elapsed_seconds, cargo_stack_size, rear_token_type |
| `onboarding_skipped` | step, elapsed_seconds, skip_reason |
| `onboarding_timeout` | step, elapsed_seconds |
| `onboarding_core_completed` | elapsed_seconds, cargo_stack_size, max_combo |
| `onboarding_boost_hint_shown` | fuel_ratio, elapsed_seconds |
| `help_opened` | source, onboarding_core_completed |
| `cargo_seen` | cargo_type, color, shape, position |
| `cargo_loaded` | cargo_type, color, shape, stack_size, token_count, trailing_footprint_cells, assisted_first_run |
| `switch_toggled` | switch_id, state, distance_to_train, onboarding_step |
| `station_arrived` | station_id, station_type, stack_top_type, rear_token_type |
| `cargo_unloaded` | cargo_type, color, shape, unload_group_size, token_count_after, speed_bonus_applied, assisted_first_run |
| `boost_started/stopped` | fuel, stack_size, assisted_first_run |
| `fuel_changed` | cause, delta, fuel_ratio, assisted_first_run |
| `run_ended` | score, survival_time, max_combo, cause, assisted_first_run |

`unload_group_size`는 `SX-DEC-014`의 Combo와 같은 값이다. 여러 배송을 이어간 streak는 계측하지 않으며, 빠른 배송 보너스는 `speed_bonus_applied`로 분리한다.

`token_count`는 `SX-DEC-015`에 따라 CargoStack size와 같아야 한다. `rear_token_type`은 CargoStack top과 일치해야 하며, capacity 8에서도 `trailing_footprint_cells`는 3 이하를 목표로 한다.

`assisted_first_run=true`의 survival time·fuel usage·score는 일반 RunBalance 합격 판단에 직접 합산하지 않는다. 온보딩 이해·흐름 검증과 일반 balance 검증을 별도 표본으로 보고한다.

## 내부 성공 기준

최소 표본이 5명일 때의 실제 판정 명수를 함께 사용한다.

| 기준 | 비율 기준 | 5명 기준 |
|---|---:|---:|
| 3분 안에 LOAD를 독립 수행 | 80% 이상 | 4명 이상 |
| 3분 안에 분기기를 의도대로 사용 | 80% 이상 | 4명 이상 |
| LIFO 규칙을 말로 설명 | 80% 이상 | 4명 이상 |
| Combo를 한 번의 연속 하역량으로 설명 | 80% 이상 | 4명 이상 |
| token 수로 적재량을 맞게 설명 | 80% 이상 | 4명 이상 |
| 가장 뒤 token을 다음 하역 대상으로 지목 | 80% 이상 | 4명 이상 |
| 안내가 플레이를 과도하게 끊지 않았다고 평가 | 60% 이상 | 3명 이상 |
| 첫 필수 입력 전 불공정 연료 0·강제 경로 실패 | 0% | 0건 |
| 화물 4개 이상 적재 후 위험 인식 | 60% 이상 | 3명 이상 |
| 같은 빌드에서 즉시 재도전 | 50% 이상 | 3명 이상 |
| 활성 선로 방향을 오해하지 않음 | 100% | 5명 전원 |

6명 이상에서는 `ceil(대상 인원 × 기준 비율)`을 통과 인원으로 사용한다. 조작 실수보다 판단 실수가 주요 실패 원인이어야 한다.

## 자동 합격 기준

- OnboardingState step 순서가 실제 domain event와 일치
- first LOAD·first switch에서만 safe pause 요청
- overlay hide·animation completion으로 unpause 또는 step complete 불가
- skip·timeout·resume 후 simulation lock 0건
- pickup·unload·reward·Combo·save 중복 0건
- assist 종료 후 fuel multiplier 1.0·difficulty escalation 정상 복원
- 이미 완료한 사용자에게 assist 재적용 0건
- Help 재생이 spawn preference·fuel assist를 활성화하지 않음
- assisted first run과 일반 run telemetry 분리

## 실패 신호

- 분기 방향을 읽지 못함
- 첫 LOAD 전에 연료·경로로 불공정 실패
- 안내가 너무 빨라 행동보다 먼저 사라짐
- safe pause가 풀리지 않거나 UI animation을 기다림
- Help 재생이 first-run assist를 다시 켬
- assisted first run을 일반 balance 증거로 섞음
- 화물을 무조건 전부 적재함
- LIFO를 기억하지 못해 무작위 플레이
- Combo를 배송 streak로 오해함
- compact token을 장식으로 보고 적재량과 연결하지 못함
- token chain의 앞뒤를 반대로 이해함
- token이 너무 작아 color+shape를 식별하지 못함
- 8 token이 역·화물·분기·preview를 가림
- compressed footprint 밖 또는 token 위에 pickup이 생성됨
- 화물 감속을 이득으로만 이용해 생존
- 부스터 상시 홀드 또는 완전 미사용
- 운에 의해 필요한 타입이 장시간 나오지 않음
- 색상과 모양 중 어느 부호에서 오인이 발생했는지 telemetry로 분리할 수 없음

## 현재 증거 상태

- `SX-DEC-016`: PLANNING_SPEC_APPROVED
- OnboardingState·assist·overlay·Help: NOT_STARTED
- Android build·사람 테스트: NOT_RUN
- 본 문서의 수치와 타이밍은 실행 전까지 `TEST_VALUE`
