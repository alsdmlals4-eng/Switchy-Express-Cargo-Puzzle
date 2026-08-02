# Result Failure Feedback Design

```yaml
decision_id: SX-DEC-017
evidence_id: EV-USER-006
batch_id: GMB-001
batch_slot: 1/10
status: APPROVED_PENDING_BATCH_MERGE
authority: USER_APPROVED_RECOMMENDED_OPTION_A
implementation_status: NOT_STARTED
validation_status: NOT_RUN
```

## 목적

연료 0 결과 화면을 단순 기록판이 아니라 다음 판의 한 가지 행동을 제안하는 짧은 학습 장치로 만든다. 다만 근거가 약한 원인을 단정해 플레이어를 잘못 비난하지 않는다.

## 확정 계약

1. 결과 화면은 기본 기록인 점수, 생존 시간, 최대 Combo, 신기록 여부를 항상 표시한다.
2. 그 아래에 이번 판의 **핵심 실패 원인 1개와 다음 판 행동 1개**를 한 쌍으로 표시한다.
3. 원인은 실제 run telemetry가 뒷받침할 때만 표시한다.
4. 원인 판정의 신뢰도가 부족하거나 후보가 비슷하면 중립 fallback을 사용한다.
5. 상세 원인 목록과 그래프는 기본 결과 화면을 밀어내지 않으며, 필요하면 보조 상세 보기로만 확장한다.
6. `RESTART`는 결과 화면의 기본 주요 행동이며, 분석 카드가 재시작을 지연하거나 차단하지 않는다.
7. 결과 UI와 animation은 원인 계산, 기록 저장, 게임 종료, 재시작의 권위를 소유하지 않는다.

## 표시 구조

```text
RUN OVER
→ Score / Survival Time / Max Combo / New Record
→ Insight Card: 원인 1줄 + 다음 행동 1줄
→ RESTART primary action
→ Optional Details secondary action
```

Insight Card 권장 문장 길이는 각 줄 24자 안팎의 한국어 또는 모바일 한 줄 대응 길이를 `TEST_VALUE`로 둔다.

## ResultFailureInsight 데이터 계약

```text
cause_code
cause_text_key
action_text_key
confidence_score
evidence_metrics
is_neutral_fallback
```

- `cause_code`는 분석 가능한 고정 enum이다.
- 화면 문구는 localization key로 관리한다.
- `evidence_metrics`는 판정에 실제 사용된 bounded 수치만 담는다.
- 저장 기록에는 원문 문구가 아니라 `cause_code`와 필요한 bounded 수치만 남긴다.

## 1차 원인 후보와 TEST_VALUE

아래 값은 구현 전에 시뮬레이션과 플레이테스트로 조정할 수 있는 권장 시험값이다.

### BOOST_OVERUSE

- `boost_fuel_spent / total_fuel_spent >= 0.40`
- 안내 예: `BOOST에 사용한 연료가 많았어요.`
- 행동 예: `다음 판에는 긴 직선에서만 사용해 보세요.`

### HEAVY_LOAD_DELAY

- `time_with_cargo_count_6_plus / run_time >= 0.35`
- 동시에 `longest_delivery_gap_seconds >= 30`
- 안내 예: `화물을 많이 실은 시간이 길었어요.`
- 행동 예: `작은 묶음을 먼저 배송해 보세요.`

### DELIVERY_GAP

- `longest_delivery_gap_seconds >= 45`
- 더 강한 원인이 없을 때만 사용한다.
- 안내 예: `배송 없이 이동한 시간이 길었어요.`
- 행동 예: `다음 하역 화물과 맞는 역을 먼저 찾아보세요.`

### ROUTE_MISMATCH_LOOP

- `mismatched_station_arrivals >= 3`
- 동시에 `successful_delivery_count <= 1`
- 안내 예: `맞지 않는 역을 여러 번 지나쳤어요.`
- 행동 예: `뒤쪽 화물의 모양과 같은 역을 먼저 확인하세요.`

## 원인 선택 규칙

- 각 후보는 0~1 범위의 deterministic score로 변환한다.
- 최고 후보가 `0.70` 이상이고 2위보다 `0.15` 이상 높을 때만 특정 원인을 표시한다. 두 값 모두 `TEST_VALUE`다.
- 두 후보가 비슷하거나 run이 너무 짧아 표본이 부족하면 중립 fallback을 사용한다.
- 동일 입력 summary는 항상 동일한 insight를 반환해야 한다.
- first-run assist가 활성화된 판은 `assisted_first_run=true`로 구분하며 일반 밸런스 원인 기준을 그대로 평가했다고 주장하지 않는다.

## 중립 fallback

```text
연료가 모두 소진되었습니다.
다음 판에서는 다음 하역 화물과 맞는 역을 먼저 찾아보세요.
```

다음 상황에서는 반드시 fallback을 사용한다.

- run summary 누락 또는 손상
- 총 연료 사용량 0 또는 분모가 유효하지 않음
- 유효 후보 없음
- 최고 후보 신뢰도 미달
- 후보 간 우세 차이 미달
- 튜토리얼/assist로 일반 원인 해석이 왜곡될 가능성

## 언어 원칙

- 플레이어를 비난하는 표현을 사용하지 않는다.
- 관측된 상태와 다음 행동을 분리한다.
- `실수했다`, `잘못했다` 대신 `길었어요`, `많았어요`, `먼저 확인하세요`처럼 중립적으로 작성한다.
- 시스템이 알 수 없는 의도나 숙련도를 추정하지 않는다.

## 권위와 처리 순서

```text
RunController ends run
→ immutable RunSummary created
→ records saved independently
→ ResultInsightAnalyzer reads summary
→ ResultViewModel exposes core records + optional insight
→ ResultPanel renders
```

- insight 계산 실패는 결과·저장·재시작을 실패시키지 않는다.
- UI hide, animation complete, Reduced Motion 여부가 분석 결과를 바꾸지 않는다.
- 분석은 run 종료 후 한 번만 수행하고 보상이나 점수를 다시 계산하지 않는다.

## Telemetry

`result_insight_shown` 권장 필드:

```text
run_id
cause_code
confidence_bucket
is_neutral_fallback
assisted_first_run
score
survival_seconds
max_combo
restart_selected
optional_details_opened
```

원인 판정에 쓰지 않은 민감하거나 무제한 로그는 추가하지 않는다.

## 필수 테스트

- 같은 RunSummary는 같은 cause_code를 반환한다.
- 각 원인 후보의 경계값 바로 아래/위 테스트.
- 후보 2개가 비슷하면 fallback.
- 분모 0, 누락 필드, 음수·NaN 입력은 fallback.
- assisted first run은 별도 분석 차원으로 기록.
- insight 실패와 localization 누락에도 핵심 결과·RESTART 사용 가능.
- animation skip·Reduced Motion·mute·haptic-off에서 결과 의미 동일.
- 결과 화면에는 원인 1개와 행동 1개를 초과해 기본 표시하지 않음.
- 원인 카드가 점수·기록·Combo를 변경하지 않음.

## 범위 제외

- 머신러닝 개인화
- 장문 코칭 리포트
- 여러 원인의 기본 동시 노출
- 영구 밸런스 임계값 확정
- 온라인 계정 또는 서버 저장
- 결과 화면에서 보상 재계산

## 검증 Gate

- 헤드리스 경계 테스트
- 10분 soak의 원인 분포 확인
- 대표 run replay로 cause_code 재현성 확인
- Android 가로형에서 2줄 카드와 RESTART 동시 가독성
- 최소 5명 첫 경험 테스트에서 문구가 비난처럼 느껴지는지 확인
- 잘못된 원인 보고율과 중립 fallback 비율 측정

현재 상태는 설계 승인뿐이며 제품 구현·Android·사람 검증은 `NOT_STARTED / NOT_RUN / HUMAN_NOT_RUN`이다.
