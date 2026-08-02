# Playtest Plan

## 가설

1. 플레이어는 3분 안에 마지막 적재 화물이 먼저 하역된다는 규칙을 이해한다.
2. 플레이어는 원하는 역을 위해 분기기를 사전에 조작한다.
3. 화물 4개 이상에서 더 싣기와 먼저 배송 사이의 고민이 발생한다.
4. 부스터를 연료와 시간을 교환하는 선택으로 사용한다.
5. 한 번의 동일 타입 연속 하역 개수가 Combo라는 것을 이해한다.
6. 작은 토큰형 화차 수로 현재 적재량을 읽고, 가장 뒤 token을 다음 하역 대상으로 인식한다.
7. 첫 세션 종료 후 점수 개선 재도전 의도가 발생한다.

## 대상

- 첫 경험 사용자 5명 이상
- 모바일 캐주얼 퍼즐 경험자와 비경험자 혼합
- Android 실제 기기 플레이

## 과제

1. `RED_STAR` 화물 2개를 한 번의 빨강 역 도착에서 연속 하역해 `COMBO ×2` 달성
2. 3단계 분기기를 사용해 파랑 역 방문
3. 화물 6개 이상 적재 후 token 수와 다음 하역 token 설명
4. 부스터로 연료 위기에서 배송
5. 한 판 자유 플레이

## 대표 상태 캡처

- 0 token: 기관차만
- 1 token: 종류·rear 위치 식별
- 4 token: stack order와 HUD parity
- 8 token: 전체 chain 길이·분기/역/preview 가독성
- 곡선 위 8 token: 순서 유지·corner cutting 없음

## 계측 이벤트

| Event | 주요 값 |
|---|---|
| `run_started` | seed, map_version |
| `cargo_seen` | cargo_type, color, shape, position |
| `cargo_loaded` | cargo_type, color, shape, stack_size, token_count, trailing_footprint_cells |
| `switch_toggled` | switch_id, state, distance_to_train |
| `station_arrived` | station_id, station_type, stack_top_type, rear_token_type |
| `cargo_unloaded` | cargo_type, color, shape, unload_group_size, token_count_after, speed_bonus_applied |
| `boost_started/stopped` | fuel, stack_size |
| `fuel_changed` | cause, delta |
| `run_ended` | score, survival_time, max_combo, cause |

`unload_group_size`는 `SX-DEC-014`의 Combo와 같은 값이다. 여러 배송을 이어간 streak는 계측하지 않으며, 빠른 배송 보너스는 `speed_bonus_applied`로 분리한다.

`token_count`는 `SX-DEC-015`에 따라 CargoStack size와 같아야 한다. `rear_token_type`은 CargoStack top과 일치해야 하며, capacity 8에서도 `trailing_footprint_cells`는 3 이하를 목표로 한다.

## 내부 성공 기준

최소 표본이 5명일 때의 실제 판정 명수를 함께 사용한다.

| 기준 | 비율 기준 | 5명 기준 |
|---|---:|---:|
| LIFO 규칙을 말로 설명 | 80% 이상 | 4명 이상 |
| 3단계 분기기를 의도대로 사용 | 70% 이상 | 4명 이상 |
| 화물 4개 이상 적재 후 위험 인식 | 60% 이상 | 3명 이상 |
| Combo를 한 번의 연속 하역량으로 설명 | 80% 이상 | 4명 이상 |
| token 수로 적재량을 맞게 설명 | 80% 이상 | 4명 이상 |
| 가장 뒤 token을 다음 하역 대상으로 지목 | 80% 이상 | 4명 이상 |
| 같은 빌드에서 즉시 재도전 | 50% 이상 | 3명 이상 |
| 활성 선로 방향을 오해하지 않음 | 100% | 5명 전원 |

6명 이상에서는 `ceil(대상 인원 × 기준 비율)`을 통과 인원으로 사용한다. 조작 실수보다 판단 실수가 주요 실패 원인이어야 한다.

## 실패 신호

- 분기 방향을 읽지 못함
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
