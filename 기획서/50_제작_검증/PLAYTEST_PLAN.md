# Playtest Plan

## 가설

1. 플레이어는 3분 안에 마지막 적재 화물이 먼저 하역된다는 규칙을 이해한다.
2. 플레이어는 원하는 역을 위해 분기기를 사전에 조작한다.
3. 화물 4개 이상에서 더 싣기와 먼저 배송 사이의 고민이 발생한다.
4. 부스터를 연료와 시간을 교환하는 선택으로 사용한다.
5. 첫 세션 종료 후 점수 개선 재도전 의도가 발생한다.

## 대상

- 첫 경험 사용자 5명 이상
- 모바일 캐주얼 퍼즐 경험자와 비경험자 혼합
- Android 실제 기기 플레이

## 과제

1. 빨강 화물 2개 연속 하역
2. 3단계 분기기를 사용해 파랑 역 방문
3. 화물 6개 이상 적재 후 배송
4. 부스터로 연료 위기에서 배송
5. 한 판 자유 플레이

## 계측 이벤트

| Event | 주요 값 |
|---|---|
| `run_started` | seed, map_version |
| `cargo_seen` | color, position |
| `cargo_loaded` | color, stack_size |
| `switch_toggled` | switch_id, state, distance_to_train |
| `station_arrived` | station_id, stack_top |
| `cargo_unloaded` | color, combo_size |
| `boost_started/stopped` | fuel, stack_size |
| `fuel_changed` | cause, delta |
| `run_ended` | score, survival_time, max_combo, cause |

## 내부 성공 기준

- 80% 이상이 LIFO 규칙을 말로 설명
- 70% 이상이 3단계 분기기를 의도대로 사용
- 60% 이상이 화물 4개 이상 적재 후 위험을 인식
- 50% 이상이 같은 빌드에서 즉시 재도전
- 조작 실수보다 판단 실수가 주요 실패 원인
- 모든 테스터가 활성 선로 방향을 오해하지 않음

## 실패 신호

- 분기 방향을 읽지 못함
- 화물을 무조건 전부 적재함
- LIFO를 기억하지 못해 무작위 플레이
- 화물 감속을 이득으로만 이용해 생존
- 부스터 상시 홀드 또는 완전 미사용
- 운에 의해 필요한 색이 장시간 나오지 않음
