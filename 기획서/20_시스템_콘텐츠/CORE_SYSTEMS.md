# Core Systems

## 화물 스택

- 색상: 빨강, 파랑, 노랑
- 색상+모양: 빨강/별, 파랑/마름모, 노랑/삼각형
- 맵 위 최소 존재량: 색상별 4개
- 적재 시 같은 색 화물을 다른 유효 선로 칸에 재생성
- 생성 금지: 기차·화차 점유 칸, 역, 분기기, 기존 화물, 기차 전방 2칸, 직전 위치
- Vertical Slice 초기 적재 상한: 8개

## 스테이션

- 빨강·파랑·노랑 각 2개, 총 6개
- 분기기 칸이 아닌 일반 선로에 배치
- 같은 색 두 역의 최단 경로 거리는 5칸 이상
- 역 도착 시 자동 하역
- 하역 가능한 화물이 없으면 보상 없음

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
