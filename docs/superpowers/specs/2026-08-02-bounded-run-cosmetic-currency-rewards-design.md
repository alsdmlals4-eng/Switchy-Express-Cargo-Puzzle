# Bounded Run Cosmetic Currency Rewards Design

## Status

```yaml
decision_id: SX-DEC-021
evidence_id: EV-USER-010
batch: GMB-001
slot: 5/10
status: APPROVED_PENDING_BATCH_MERGE
implementation: NOT_STARTED
runtime_validation: NOT_RUN
android_validation: NOT_RUN
human_validation: NOT_RUN
```

## Decision

꾸미기 전용 재화는 **유효한 일반 run의 기본 보상 + 상한 있는 성과 보너스**로 획득한다.

```text
총 재화 =
유효 run 기본 보상
+ 성공 배송 보너스
+ 최고 Combo 단계 보너스
+ 표준 개인 신기록 보너스

단, 각 항목과 run 총액에 상한을 적용한다.
```

생존 시간만으로는 재화를 지급하지 않는다. 결과 화면, 애니메이션, HUD는 보상 계산·차감·저장 권위를 소유하지 않는다.

## Product Intent

이 정책은 다음 네 목표를 동시에 만족해야 한다.

1. 초보자도 의미 있는 배송을 한 run이라면 소량의 수집 진척을 얻는다.
2. 더 나은 배송·Combo·신기록은 추가 보상으로 인정한다.
3. 무조작 생존, 짧은 반복 종료, 중복 종료 이벤트가 재화 파밍 수단이 되지 않는다.
4. 상위권의 긴 run이 초보자보다 수십 배 많은 재화를 얻어 가격 경제를 붕괴시키지 않는다.

## Non-Goals

이번 Decision은 다음을 확정하지 않는다.

- 최종 꾸미기 가격표
- 실제 화폐 판매
- 광고 보상
- 일일 임무·출석·시즌 패스
- loot box·gacha
- 온라인 계정 동기화
- 글로벌 리더보드 보상
- 기간 한정 이벤트 재화
- 소급 보상

이 항목들은 별도 Decision 없이는 구현하지 않는다.

## Authoritative Flow

```text
RunController
  → immutable RunSummary
  → RunCurrencyRewardEligibilityPolicy
  → authoritative RecordCommitResult
  → CosmeticCurrencyRewardCalculator
  → RunCurrencyGrantIntent
  → CosmeticProgressionService / ProfileStore atomic transaction
  → committed RunCurrencyRewardReceipt
  → ResultViewModel
  → ResultPanel
```

### Authority Boundaries

- `RunSummary`는 run 결과 증거의 권위다.
- `RecordCommitResult`는 어떤 표준 개인 기록이 실제로 갱신됐는지의 권위다.
- `RunCurrencyRewardEligibilityPolicy`는 일반 run 보상 자격의 권위다.
- `CosmeticCurrencyRewardCalculator`는 순수 deterministic 계산기다.
- `CosmeticProgressionService`와 `ProfileStore`는 재화 잔액·processed reward event의 권위다.
- `ResultViewModel`과 `ResultPanel`은 이미 commit된 receipt만 표시한다.
- UI, animation, Tween, sound, telemetry sink는 재화를 생성하거나 잔액을 변경하지 않는다.

## Standard Run Eligibility

일반 run 보상은 아래 조건을 모두 만족해야 한다.

```yaml
run_completed: true
run_end_reason: authoritative terminal reason
successful_deliveries: ">= 1"
assisted_first_run: false
ruleset_version: current
integrity_state: VALID
debug_or_test_run: false
reward_event_id: non-empty and not previously processed
```

### Explicit Exclusions

다음 run에는 일반 계산 보상을 지급하지 않는다.

- 첫 세션 assist가 활성화된 run
- 중도 포기·강제 종료·크래시로 authoritative 완료 증거가 없는 run
- 배송 성공 0회 run
- ruleset mismatch run
- integrity invalid run
- debug·developer·test run
- 동일 reward event가 이미 처리된 run
- 손상되거나 필수 증거가 없는 RunSummary

### Why Delivery Is Required

생존 시간은 플레이어가 핵심 행동을 하지 않아도 증가할 수 있다. 따라서 최소 1회 성공 배송을 일반 보상의 자격 기준으로 사용한다. 분기 조작 횟수, 이동 거리, 단순 pickup만으로는 기본 보상을 열지 않는다.

## First-Run Assist Policy

first-run assist는 일반 성과 계산에서 제외한다.

대신 실제 온보딩 완료 조건을 만족한 경우 별도의 1회 입문 보상을 허용한다.

```yaml
intro_grant_event: ONBOARDING_COMPLETION_GRANT
requires:
  onboarding_completed: true
  successful_deliveries: ">= 1"
  profile_intro_grant_claimed: false
amount: 10 TEST_VALUE
repeatable: false
record_bonus: false
performance_bonus: false
```

- skip만 누르고 배송하지 않은 세션에는 입문 보상을 지급하지 않는다.
- 동일 Profile에서 한 번만 지급한다.
- 일반 run reward event journal과 동일한 atomic·idempotent 원칙을 사용한다.
- 입문 보상은 표준 기록·밸런스 증거와 별도 telemetry segment로 남긴다.

## Reward Formula

### Initial TEST_VALUE Baseline

```yaml
policy_version: 1
base_reward: 10
successful_delivery_reward_each: 2
successful_delivery_reward_cap: 10
combo_tiers:
  - min_max_combo: 3
    reward: 2
  - min_max_combo: 5
    reward: 5
  - min_max_combo: 8
    reward: 8
new_record_reward: 5
new_record_reward_cap_per_run: 5
run_total_cap: 30
intro_grant: 10
```

모든 값은 `TEST_VALUE`다. 플레이테스트·경제 시뮬레이션 없이 영구 밸런스로 간주하지 않는다.

### Component Rules

#### Base Reward

- 자격을 통과한 일반 run에 정확히 한 번 지급한다.
- 배송 1회만 반복하는 파밍을 완전히 없애지는 못하므로 배송 보너스와 가격은 telemetry로 검증한다.
- 완료되지 않은 run에는 없다.

#### Delivery Bonus

```text
delivery_bonus = min(successful_deliveries × 2, 10)
```

- 성공적으로 하역 완료된 배송만 센다.
- pickup, 역 진입, mismatch, 취소된 하역은 세지 않는다.
- 같은 delivery event ID를 중복 집계하지 않는다.

#### Combo Bonus

- `max_combo`가 도달한 가장 높은 단계 하나만 지급한다.
- 단계 보너스를 누적 합산하지 않는다.

```text
max_combo < 3 → 0
3~4          → 2
5~7          → 5
8+           → 8
```

#### New Record Bonus

- `RecordCommitResult`에서 표준 기록이 실제 갱신된 경우에만 지급한다.
- 한 run에서 score, survival, max Combo가 모두 갱신돼도 최대 5만 지급한다.
- assisted·ruleset mismatch·integrity invalid run은 RecordEligibilityPolicy에서 제외되므로 보너스도 없다.
- UI의 “신기록” 연출 상태를 입력으로 사용하지 않는다.

#### Total Cap

```text
raw_total = base + delivery_bonus + combo_bonus + record_bonus
committed_total = min(raw_total, 30)
```

- 상한은 초보자와 고수의 획득 속도 격차를 제한한다.
- 초과분은 저장하거나 이월하지 않는다.
- 상한에 도달했다는 표시를 필수로 노출하지 않는다.

## No Direct Score or Survival Reward

이번 정책은 점수와 생존 시간에 직접 비례하는 재화를 지급하지 않는다.

이유:

- 점수 공식 변경이 경제를 즉시 흔드는 결합을 피한다.
- 무조작 생존과 안전한 저위험 루프를 보상하지 않는다.
- 긴 run이 짧은 run보다 과도한 재화를 얻는 snowball을 제한한다.
- 신기록 보너스가 이미 장기 개선을 bounded하게 인정한다.

점수·생존 직접 보상은 별도 Decision 없이는 추가하지 않는다.

## Idempotency and Atomicity

각 일반 run은 안정적인 reward event ID를 가진다.

```text
run_reward:<run_id>:policy_v1
```

입문 보상은 별도 고정 ID를 가진다.

```text
onboarding_completion:<profile_id>:v1
```

Profile transaction은 다음을 한 번에 commit한다.

1. reward event가 미처리인지 확인
2. 계산된 grant amount 검증
3. cosmetic currency balance 증가
4. processed reward event ID 기록
5. reward receipt 기록 또는 반환

중간 실패 시 잔액과 journal이 함께 롤백된다.

### Retry Rule

- save 실패 뒤 같은 event ID를 재시도할 수 있다.
- 이미 commit된 event ID는 동일 receipt를 반환하거나 `ALREADY_COMMITTED`로 종료한다.
- 추가 잔액 증가는 없다.
- result UI는 commit 성공 전 예상 보상을 확정 보상처럼 표시하지 않는다.

## Record Ordering

신기록 보너스는 다음 순서를 사용한다.

```text
RunSummary freeze
→ RecordEligibilityPolicy
→ RecordStore atomic compare-and-commit
→ RecordCommitResult
→ RewardCalculator
→ currency grant commit
```

`RecordCommitResult`에는 다음 최소 정보가 필요하다.

```yaml
eligible: bool
updated_record_keys: Array[StringName]
record_transaction_id: StringName
```

- reward calculator가 기존 Profile 기록을 다시 비교하지 않는다.
- 동일 run의 record commit 결과와 reward event ID를 연결한다.
- record commit 성공·currency commit 실패 시 currency grant는 같은 event ID로 재시도할 수 있다.

## Data Contract

### RunSummary Required Fields

```yaml
run_id: StringName
completed: bool
end_reason: StringName
successful_delivery_count: int
unique_successful_delivery_event_ids: Array[StringName]
max_combo: int
assisted_first_run: bool
ruleset_version: int
integrity_state: StringName
debug_or_test_run: bool
```

### Reward Receipt

```yaml
reward_event_id: StringName
policy_version: int
eligibility: StringName
base_reward: int
delivery_bonus: int
combo_bonus: int
record_bonus: int
raw_total: int
committed_total: int
balance_before: int
balance_after: int
commit_state: StringName
```

Receipt는 UI 표시와 telemetry를 위한 immutable 결과다.

## Configuration Contract

보상 수치는 versioned `CosmeticCurrencyRewardPolicyConfig`에서 읽는다.

필수 검증:

- 모든 값은 0 이상의 정수
- delivery cap <= run total cap
- combo tiers는 오름차순이며 reward도 감소하지 않음
- new record cap <= run total cap
- intro grant >= 0
- policy version은 양수
- raw arithmetic는 overflow-safe

config가 잘못되면 0을 암묵적으로 지급하지 않고 policy를 invalid로 표시하며 일반 reward grant를 중단한다. 기본 게임 run과 기록 저장은 계속 가능해야 한다.

## Presentation Contract

Result 화면에는 commit된 값만 다음처럼 표시할 수 있다.

```text
이번 운행 재화 +24
  기본 +10
  배송 +8
  Combo +6
```

단, 기본 결과 화면 밀도를 해치지 않도록 세부 breakdown은 secondary detail로 둔다.

- RESTART primary CTA는 유지한다.
- reward animation 완료가 restart나 save의 조건이 아니다.
- 긴 localization에서 금액과 원인 insight가 서로 가리지 않아야 한다.
- Reduced Motion에서는 숫자 증가 animation 없이 최종 값 즉시 표시.
- 색상만으로 보상 종류를 구분하지 않는다.

## Telemetry

표준 run과 입문 보상을 분리한다.

권장 event:

```text
cosmetic_currency_reward_evaluated
cosmetic_currency_reward_committed
cosmetic_currency_reward_rejected
onboarding_intro_grant_committed
```

최소 속성:

```yaml
policy_version
eligibility_code
base_reward
delivery_bonus
combo_bonus
record_bonus
raw_total
committed_total
successful_deliveries
max_combo
record_keys_updated
assisted_first_run
ruleset_version
integrity_state
```

player identity나 불필요한 상세 행동 로그를 수집하지 않는다.

## Adversarial Findings

### SX-AUD-004-F46 — SHORT_IDLE_FARM_RISK

**문제:** 생존 시간 또는 종료 횟수만으로 재화를 주면 무조작·짧은 반복 run이 최적 파밍이 된다.

**처리:** authoritative 완료 + 성공 배송 1회 이상을 일반 자격으로 요구하고 생존 시간 직접 보상을 금지한다.

### SX-AUD-004-F47 — PERFORMANCE_REWARD_SNOWBALL_RISK

**문제:** 배송·Combo·점수에 무제한 비례하면 상위권 획득 속도가 폭증하고 가격이 초보자에게 과도해진다.

**처리:** 각 component cap, 최고 Combo tier 하나, 신기록 run당 1회, 총액 cap을 적용한다.

### SX-AUD-004-F48 — DUPLICATE_GRANT_RETRY_RISK

**문제:** 종료 이벤트 중복, restart 연타, save 재시도에서 동일 run 보상이 여러 번 지급될 수 있다.

**처리:** stable reward event ID와 balance+journal atomic transaction을 사용한다.

### SX-AUD-004-F49 — ASSISTED_REWARD_CONTAMINATION_RISK

**문제:** first-run assist가 일반 성과 재화를 쉽게 얻거나 경제 telemetry를 왜곡할 수 있다.

**처리:** 일반 계산에서 제외하고 실제 온보딩 완료 시 1회 고정 intro grant만 별도 지급한다.

### SX-AUD-004-F50 — RECORD_ORDER_UI_AUTHORITY_RISK

**문제:** UI의 신기록 연출이나 commit 전 예상 상태가 record bonus·잔액의 권위가 될 수 있다.

**처리:** authoritative `RecordCommitResult` 뒤 reward를 계산하고 commit된 receipt만 UI에 전달한다.

## Validation Matrix

### Automated

- 자격 run은 정확한 base reward를 얻는다.
- 배송 0회는 0 reward다.
- incomplete, assisted, mismatch, invalid, debug run은 일반 reward가 없다.
- delivery bonus와 combo tier가 상한을 지킨다.
- 여러 기록이 갱신돼도 record bonus는 1회다.
- raw total이 cap을 넘으면 committed total은 cap이다.
- 동일 event ID 재처리는 잔액을 늘리지 않는다.
- transaction 실패는 잔액과 journal을 모두 롤백한다.
- onboarding intro grant는 한 번만 지급된다.
- result UI는 committed receipt만 표시한다.

### Runtime / Android

- 결과 화면에서 reward summary가 원인 insight·RESTART를 가리지 않음.
- 빠른 restart 연타에서도 중복 지급 0.
- suspend/resume·강제 종료 뒤 동일 run 재처리에서 중복 지급 0.
- 긴 한국어·영어 문자열과 다양한 화면비에서 숫자 clipping 0.
- Reduced Motion에서 정보 손실 0.

### Human / Economy

최소 5명 테스트와 run telemetry에서 다음을 본다.

- 5명 중 4명 이상이 “배송을 해야 재화를 얻는다”를 이해.
- first-run intro grant와 일반 reward의 차이를 혼동하지 않음.
- 초보·중간·상위 실력군의 시간당 획득량 격차가 허용 범위인지 확인.
- 1회 배송 반복이 최적 파밍인지 검증.
- 대표 DUAL_PATH/CURRENCY_ONLY 가격까지의 예상 run 수 검증.

정확한 목표 범위는 가격표 Decision과 함께 확정한다.

## Vertical Slice Scope

Vertical Slice에서는 다음만 검증한다.

- policy config v1
- 일반 run eligibility
- base + delivery + combo + new-record bounded formula
- atomic idempotent grant
- one-time onboarding intro grant
- result reward summary 최소 표현
- Profile save/load/migration
- 대표 꾸미기 2종 가격과 연결된 smoke test

일일 임무, 상점 추천, 시즌, 광고, 실제 결제, 온라인 sync는 만들지 않는다.

## Exit Criteria

이 설계는 다음을 만족할 때 구현 준비 후보가 된다.

- GMB-001 10/10 pre-merge audit와 canonical sync 완료
- reward policy·Profile·unlock service 책임 경계가 정본에 전파됨
- TDD 계획의 파일 경로와 테스트 명령이 실제 repo와 대조됨
- 가격·시간당 획득 목표가 후속 검증에서 명시됨
- `READY_FOR_BUILD` 승인

현재 상태는 `CODEX_NOT_READY`다.
