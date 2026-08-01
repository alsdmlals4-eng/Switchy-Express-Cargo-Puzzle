# Core Systems

## RailGraph·분기 기반

- 맵 크기: 15×10
- 전체 선로는 하나의 연결 요소
- degree-1 막다른길 0
- cycle rank 최소 3
- 2단계 분기 최소 4개
- 3단계 분기 최소 2개
- 각 유효 분기 경로는 최소 3칸 이상 진행
- 같은 seed는 같은 graph signature 생성
- 32회 후보 실패 시 결정론적 safe fallback
- 직진 가능한 경우 기본 A노선은 직진 우선
- 5칸 preview 첫 칸과 실제 다음 칸은 동일

구현 증거: PR #9 / `801632949d28564528e38d83dac59cccc6f06fb2` / seeds 1~100 PASS.

현재 생성기는 구조 계약을 통과하지만 unique-map 수·경로 엔트로피·실제 플레이 다양성은 별도 검증 전까지 `NOT_RUN`이다.

## 화물 스택

- 색상: 빨강, 파랑, 노랑
- 색상+모양: 빨강/별, 파랑/마름모, 노랑/삼각형
- 맵 위 최소 존재량: 색상별 4개
- 적재 시 같은 색 화물을 다른 유효 선로 칸에 재생성
- 생성 금지: 기차·화차 점유 칸, 역, 분기기, 기존 화물, 기차 전방 2칸, 직전 위치
- 한 선로 칸에 화물 최대 1개
- Vertical Slice 초기 적재 상한: 8개

### Vertical Slice 스폰 기술 기본값

```yaml
classification: RECOMMENDED_DEFAULT
respawn_delay_seconds: 1.0
placement: deterministic_seeded_eligible_cell_shuffle
candidate_attempts: bounded
no_valid_cell_result: SPAWN_DEFERRED
minimum_count_scope: map_pickups_only
```

유효 칸이 없으면 기존 화물을 덮어쓰거나 금지 칸에 강제 배치하지 않는다. `SPAWN_DEFERRED`로 남기고 다음 유효 시점에 재시도한다.

## 스테이션

- 빨강·파랑·노랑 각 2개, 총 6개
- 분기기 칸이 아닌 일반 선로에 배치
- 같은 색 두 역의 최단 경로 거리는 5칸 이상
- 역 도착 시 자동 하역
- 하역 가능한 화물이 없으면 보상 없음
- 동일 seed에서 동일 배치
- 제한 횟수 안에 유효 배치가 없으면 결정론적 fallback 또는 명시적 배치 실패를 반환

## LIFO 하역

- 최대 적재량: 8
- 마지막에 실은 화물이 stack top
- 역 타입과 top 타입이 다르면 하역 0개
- top부터 같은 타입인 연속 그룹만 하역
- 적재 `R,R,B,R`의 하역 순서는 `R,B,R,R`
- 실제 stack 결과와 HUD용 unload-order ViewModel은 항상 동일

## 속도 초기 시험식

```text
base_speed(t) = min(3.4, 1.8 + 0.08 × floor(t / 30초))
cargo_multiplier(n) = max(0.64, 1.0 - 0.045 × n)
boost_multiplier = 1.45 if BOOST else 1.0
current_speed = base_speed × cargo_multiplier × boost_multiplier
```

## 연료 초기 시험값

```text
fuel_max = 100
fuel_start = 65
base_drain(t) = 1.0 + 0.12 × floor(t / 45초)
boost_drain_multiplier = 2.4
```

화물 감속은 초당 연료 소모를 줄이지 않는다.

### 하역 보상

| 연속 하역 | 점수 | 연료 |
|---:|---:|---:|
| 1 | 100 | 5 |
| 2 | 260 | 12 |
| 3 | 540 | 21 |
| 4 | 960 | 32 |
| 5+ | `300 × 개수` + 콤보 | `8 × 개수` |

수치는 Vertical Slice 시험값이며 플레이테스트로 조정한다.

## 점수

```text
delivery_score = base_combo_score
speed_bonus = 1.25 if 이전 배송 후 8초 이내 else 1.0
heavy_bonus = 1.15 if 배송 직전 화물 6개 이상 else 1.0
final_score = round(delivery_score × speed_bonus × heavy_bonus)
```

부스터 사용 시간 자체에는 점수를 주지 않는다.

## 무조작 루프 방지

- 입력 0회 시 연료가 제한 시간 안에 감소
- 기본 노선 반복의 기대 연료 수지가 음수
- 같은 역·같은 색 화물만으로 영구 흑자 불가
- 화물 생성은 고정 파밍 루프를 만들지 않음
- 모든 생성 맵에서 각 역에 도달 가능한 분기 선택 존재

## 저장

Vertical Slice에서는 최고 점수·최장 생존 시간·최대 콤보만 로컬 저장한다.

## 구현 상태

| 영역 | 상태 |
|---|---|
| Godot·RailGraph·분기 로직 | IMPLEMENTED · PASSED |
| 기차·화차 | NOT_STARTED |
| 화물·역·LIFO | NOT_STARTED |
| 속도·연료·점수·BOOST | NOT_STARTED |
| 제품 HUD·Android·플레이테스트 | NOT_RUN |
