# Core Systems

상태: `CURRENT_CANON · GMB-002 · IMPLEMENTATION_REPLAN_REQUIRED`

세부 제품 규칙은 `기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md`가 책임진다.

## 시스템 위계

```text
MapDefinition: 지형·시작점·역·화물·건설 가능 영역
→ TrackLayout: 플레이어가 건설한 선로·속성·비용
→ Preflight: 구조적 도달 가능성과 trap 검사
→ Run: 자동 이동·적재·분기·LIFO 하역
→ Result: 성공/실패·별·기록·분석
```

기존 `MapDefinition = 완성된 RailGraph` 계약은 `[대체됨]`이다. 새 DoR에서 base map identity와 player-built layout identity를 분리한다.

## 맵 정의

맵이 소유하는 것:

- 시작점
- 역과 종류
- 화물 지점과 종류
- 건설 가능·불가 셀
- 터널·교량 허용 지점
- 제한 시간
- 신속·절약·점수 별 목표
- 속도 리더보드 최대 비용
- 추천 설계도
- ruleset version

플레이어가 소유하는 것:

- 설치한 선로 형태
- 일반·가속·저비용 속성
- 일방통행 방향
- 분기 초기 상태
- 최종 건설비

## 건설 비용

```text
current_build_cost = 운행 시작 시 존재하는 최종 TrackLayout 비용 합
```

- 설치 시 즉시 증가
- 철거 시 전액 감소
- 과거에 설치·철거한 누적 비용은 기록하지 않음
- 일반 클리어 비용 상한 없음
- 속도 리더보드는 맵별 최대 비용 사용
- 절약 별·가격 순위는 최종 비용 사용
- 모든 수치는 `TEST_VALUE`

초기값:

| 요소 | 비용·성능 |
|---|---|
| 일반 직선·곡선 | 100 |
| 분기·교차 | 200 |
| 가속 | 300 · 1.5× |
| 저비용 | 60~70 · 0.75× |
| 일방통행 | +50 |
| 회차 | 350 |
| 교량 | 칸당 250 |
| 터널 | 600+ |

## 선로 그래프 의미

- 직선·곡선: 두 연결점
- 분기: 진입 방향에서 둘 이상의 유효 출구, 활성 출구 1개
- 교차: 가로·세로 연결은 독립이며 교차점에서 회전 불가
- 일방통행: 허용 방향으로만 edge 존재
- 회차: 열차 진행 방향을 반전
- 터널·교량: 맵이 허용한 지형만 통과

분기는 플레이어가 다시 탭할 때까지 상태를 유지한다. 열차가 해당 분기 위에 있을 때만 변경을 잠근다.

## 시작 전 검사

검사함:

- 시작점에서 모든 역 도달 가능
- 시작점에서 모든 화물 지점 도달 가능
- 일방통행 반영
- 필수 지점이 서로 방문 가능한 구조인지 확인
- 진입 후 탈출 불가능한 필수 trap 확인

검사하지 않음:

- 정확한 LIFO 해답
- 자동/수동 적재 타이밍
- 분기 조작 순서
- 제한 시간 성공 해답
- 최소 비용·최대 Combo 해답

## 화물 스택

- 화물 지점당 1개
- 고정 배치, 적재 후 재생성 없음
- domain capacity 제한 없음
- 적재 시 stack top에 push
- 하역 시 TOP 연속 일치 그룹 pop
- 화물·역은 색상+모양 이중 부호

무제한 스택은 물리 화차를 무한히 늘린다는 뜻이 아니다. 새 표현 설계는 TOP·다음 그룹과 전체 순서를 읽을 수 있어야 하며 8/16/32개 가독성을 검증한다.

## 적재 상태

```text
manual_load = 기본
load_held = 통과 화물 적재
auto_load = 활성 중 모든 통과 화물 적재
```

- 운행 중 manual/auto 전환 가능
- 화물 통과 시점에만 적재 판정
- 적재로 정차·감속 없음
- 적재하지 않은 화물은 남음

## 하역·Combo

```text
unload_count = TOP부터 station type과 연속 일치하는 수
combo_count = unload_count
```

- `unload_count == 0`: 정차 없이 통과
- `unload_count >= 1`: 자동 정차·하역
- 총 하역 시간 최대 1초
- 개수가 많을수록 개당 연출 간격 감소
- 모든 제거는 domain commit이 먼저이고 animation은 표현
- 2 Combo 이상 가속·점수

초기 가속:

```text
combo_speed = 1.25× TEST_VALUE
combo_duration = combo별 TEST_VALUE
new_remaining = max(current_remaining, new_duration)
final_speed_cap = 2.0× base TEST_VALUE
```

## 운행 시간·판정

- 건설 단계 clock 0
- 운행 시작과 동시에 run clock 시작
- pause 중 clock·이동·입력 정지
- pause 중 분기·적재 모드 변경 불가
- 마지막 하역 animation 완료 시 success seal
- time limit 도달 시 undelivered count가 1 이상이면 failure seal
- success/failure 뒤 domain mutation 금지

## 별

```text
speed_star = success && completion_time <= map.speed_target
cost_star = success && build_cost <= map.cost_target
score_star = success && total_score >= map.score_target
```

- 서로 다른 run에서 누적
- 영구 유지
- 목표 사전 공개
- 진행에 필수 아님
- 3별 획득 시 해당 맵 리더보드 등록 개방

## 리더보드

### 속도

자격: success + build_cost <= map.speed_board_cost_cap
정렬: completion_time ASC, build_cost ASC

### 가격

자격: success + completion_time <= map.time_limit
정렬: build_cost ASC, completion_time ASC

### 점수

자격: success
초기 정규화: 시간 45% + 비용 45% + Combo 10% `TEST_VALUE`
정렬: score DESC, completion_time ASC, build_cost ASC

기록은 map ID·revision·ruleset version·layout result와 결합한다. 다른 플레이어의 TrackLayout과 조작 순서는 공개하지 않는다.

## 튜토리얼·캠페인 데이터

- stage 1~10: tutorial flag, teaching objective 1개, 힌트 단계, 실패 피드백
- stage 11+: chapter, bundle, exam flag
- 3개 묶음 중 2개 clear로 다음 묶음
- 챕터 시험은 해당 chapter의 taught mechanics만 사용

## 일일·주간 도전

- fixed seed
- 기간 동안 동일 map/ruleset
- 무제한 retry
- 캠페인 미학습 기믹도 사용 가능
- 미학습 항목은 micro tutorial metadata 제공
- 기간 종료 시 official record freeze
- archive replay는 practice record만 갱신

절차 생성 Gate:

- 구조적 도달 가능성
- 최소 1개 solver-verified 또는 authored-safe solution
- 별 목표와 비용 상한의 유효 범위
- 추천 노선이 랭킹 최적해가 아님
- seed/revision/ruleset immutable

## 꾸미기·보상

- 성능 변화 0
- chapter 별 10/20/27/30 보상 `TEST_VALUE`
- 반복 도전 첫 성공·개인 개선·백분위 보상 분리
- 상위 1/10/25/50%와 성공 참가자
- 세 부문 중복 재화 100/70/50% `TEST_VALUE`
- 배지·칭호는 전부 지급

## 구형 시스템 상태

| 시스템 | 상태 |
|---|---|
| 완성형 generated connected rail | `[대체됨]` |
| capacity 8 | `[대체됨]` |
| pickup respawn | `[폐기]` |
| cargo-count slowdown | `[폐기]` |
| fuel drain/recovery/fuel-zero | `[폐기]` |
| BOOST input | `[폐기]` |
| timed difficulty pressure | `[폐기]` |
| switch auto-reset | `[대체됨]` |
| old tests/PR evidence | `[역사 증거]` |
| UGC/backend | `[보류]` |

## 다음 구현 Gate

```text
1. finite puzzle DoR
2. MapDefinition/TrackLayout identity 설계
3. track editor UX·graph rules
4. unlimited stack representation
5. star/score/time target methodology
6. package segmentation
7. TDD implementation
8. Android/human/balance evidence
```
