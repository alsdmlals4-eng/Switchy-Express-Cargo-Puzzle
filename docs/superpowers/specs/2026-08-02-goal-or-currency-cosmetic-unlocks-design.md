# Goal-or-Currency Cosmetic Unlocks Design

```yaml
decision_id: SX-DEC-020
evidence_id: EV-USER-009
batch_id: GMB-001
batch_slot: 4/10
status: APPROVED_PENDING_BATCH_MERGE
authority: USER_APPROVED_HYBRID_A_PLUS_C
implementation_status: NOT_STARTED
validation_status: NOT_RUN
```

## 목적

`SX-DEC-019`의 cosmetic-only 영구 진행에 실제 획득 경로를 추가한다. 플레이어는 목표를 달성해 꾸미기를 즉시 해금할 수 있고, 목표를 달성하지 못하거나 원하지 않더라도 꾸미기 전용 재화로 같은 꾸미기를 해금할 수 있다. 동시에 일부 꾸미기는 재화로만 해금되도록 배치한다.

이 구조는 숙련의 기념품과 장기 수집 선택권을 함께 제공하되, 목표 우회 구매가 목표 달성 기록까지 위조하거나 꾸미기가 성능 우위를 제공해서는 안 된다.

## 사용자 확정 결정

사용자는 2026-08-02 Grill Me에서 다음 결합안을 승인했다.

```text
A + C:
- 목표 달성 시 꾸미기 즉시 해금
- 목표를 달성하지 않아도 재화로 대체 해금 가능
- 일부 꾸미기는 목표 경로 없이 재화로만 해금
```

## 해금 유형

모든 꾸미기 해금 정의는 정확히 하나의 유형을 사용한다.

```text
DEFAULT
DUAL_PATH
CURRENCY_ONLY
```

### DEFAULT

- 신규 Profile에서 항상 해금된다.
- 가격과 목표가 없다.
- save 손상·누락 ID fallback의 최종 안전 자산이다.

### DUAL_PATH

- 지정 목표를 달성하면 비용 없이 즉시 해금된다.
- 목표를 달성하지 않아도 지정 가격의 꾸미기 전용 재화로 구매할 수 있다.
- 재화로 먼저 구매해도 목표 진행·완료 여부는 별도로 유지된다.
- 구매는 목표 달성이나 업적 표식을 대신하지 않는다.

### CURRENCY_ONLY

- 목표 ID를 가지지 않는다.
- 꾸미기 전용 재화 구매로만 해금된다.
- 목표형 꾸미기보다 강하거나 유리하다는 의미를 갖지 않는다.
- 기간 한정·시즌 소멸·실제 화폐·광고 전용은 이번 Decision 범위가 아니다.

`GOAL_ONLY` 유형은 두지 않는다. 목표형 꾸미기도 재화 대체 경로를 제공한다는 사용자 결정을 보존하기 위해서다.

## 해금 정의 분리

시각·오디오 자산 metadata와 경제·목표 규칙을 분리한다.

```text
CosmeticDefinition
→ cosmetic_id, category, asset, preview, localization, accessibility

CosmeticUnlockDefinition
→ cosmetic_id, unlock_mode, goal_id, currency_price,
  goal_completion_compensation, catalog_version
```

`CosmeticDefinition`에는 gameplay modifier와 경제 상태를 넣지 않는다. `CosmeticUnlockDefinition`은 가격과 목표 연결만 설명하며 speed·fuel·score·collision 같은 run 수치를 절대 포함하지 않는다.

권장 immutable 해금 정의:

```text
cosmetic_id: StringName
unlock_mode: DEFAULT | DUAL_PATH | CURRENCY_ONLY
goal_id: StringName | EMPTY
currency_price: int
goal_completion_compensation: int
catalog_version: int
```

검증 규칙:

- DEFAULT: `goal_id=EMPTY`, `currency_price=0`, compensation=0.
- DUAL_PATH: non-empty goal_id, price>0, compensation>=0.
- CURRENCY_ONLY: `goal_id=EMPTY`, price>0, compensation=0.
- 모든 가격·보상은 정수이며 음수가 될 수 없다.
- 가격과 대체 보상 수치는 `TEST_VALUE`이며 영구 밸런스 승인값이 아니다.

## 목표 달성 계약

### 목표 권위

목표 진행은 UI가 아니라 authoritative domain event 또는 최종 `RunSummary`가 갱신한다.

```text
Run domain / immutable RunSummary
→ GoalEligibilityPolicy
→ CosmeticGoalProgress
→ CosmeticUnlockService
→ Profile transaction
```

UI animation, toast, collection panel은 목표 진행·완료·해금 권위가 아니다.

### 목표 자격

꾸미기 목표는 다음 조건을 모두 만족하는 run 증거만 소비한다.

```text
goal_evidence_eligible =
    run_completed
    AND NOT assisted_first_run
    AND ruleset_id == current_goal_ruleset_id
    AND integrity_state == VALID
```

- first-run assist, debug, 변형 ruleset, integrity invalid run은 숙련 목표를 완료하지 않는다.
- 목표 진행은 동일 event ID를 반복 처리해도 한 번만 반영된다.
- 단순 UI 체류 시간이나 앱 실행 시간은 목표 증거가 아니다.
- 구체 목표 목록과 threshold는 content data이며 `TEST_VALUE`다.

### DUAL_PATH 목표 달성

목표 완료 시:

1. goal completion을 영구 기록한다.
2. 꾸미기가 잠겨 있으면 비용 없이 즉시 해금한다.
3. 이미 재화로 구매한 꾸미기라면 소유권을 중복 지급하지 않는다.
4. 대신 정의된 `goal_completion_compensation`을 정확히 한 번 지급한다.
5. 목표 완료 표식은 구매 여부와 관계없이 유지한다.

대체 보상은 목표 달성의 가치를 완전히 없애지 않으면서 중복 소유·중복 지급을 방지한다. 대체 보상 값은 item 가격 이하의 bounded `TEST_VALUE`로 검증한다.

## 재화 구매 계약

### 전용 재화

이 Decision은 cosmetic-only soft currency의 보유·차감·거래 경계를 확정한다. 일반 run에서 얼마를 어떤 공식으로 획득하는지는 `SX-DEC-021`에서 결정한다.

Profile 최소 상태:

```text
cosmetic_currency_balance
completed_cosmetic_goal_ids
unlocked_cosmetic_ids
unlock_provenance_by_cosmetic_id
processed_progression_event_ids
```

권장 provenance:

```text
DEFAULT
GOAL
CURRENCY_PURCHASE
MIGRATED
```

### 구매 전제

구매는 다음 조건을 모두 만족해야 한다.

```text
valid cosmetic_id
AND unlock_mode in [DUAL_PATH, CURRENCY_ONLY]
AND cosmetic not already unlocked
AND balance >= currency_price
AND transaction_id not previously processed
```

### 원자적 거래

재화 차감과 꾸미기 해금은 하나의 Profile transaction으로 처리한다.

- 차감 성공 후 해금 실패 상태를 남기지 않는다.
- 해금 성공 후 차감이 누락되지 않는다.
- 같은 transaction ID 재처리는 추가 차감·추가 해금을 만들지 않는다.
- 저장 실패 시 메모리 상태와 저장 상태를 일관된 이전 상태로 rollback하거나, 확정된 transaction journal로 재실행한다.
- Collection UI는 balance를 직접 변경하지 않는다.

### 이미 보유한 꾸미기

- 이미 보유한 꾸미기는 다시 구매할 수 없다.
- 중복 purchase request는 `ALREADY_UNLOCKED` 또는 기존 transaction 결과를 반환한다.
- 중복 구매를 재화 환전 수단으로 사용하지 않는다.

## Catalog 배치 정책

정식 catalog는 세 역할을 명시적으로 배치한다.

1. category별 기본 DEFAULT item.
2. 플레이 목표와 연결된 DUAL_PATH item.
3. 목표 연결 없이 재화로만 구매하는 CURRENCY_ONLY item.

Vertical Slice 대표 catalog 최소 구성:

```text
locomotive.default       → DEFAULT
locomotive.goal_sample   → DUAL_PATH
locomotive.currency_sample → CURRENCY_ONLY
```

대표 ID·가격·목표 threshold는 구현 fixture에서 `TEST_VALUE`로 사용하며 최종 이름·아트·경제 승인으로 간주하지 않는다.

### 표현 원칙

DUAL_PATH item은 다음을 함께 표시한다.

```text
목표 이름·진행도
또는
재화 가격·구매 버튼
```

CURRENCY_ONLY item은 명확한 `재화 전용` 표식을 표시한다. 단, 희귀도·테두리·문구가 성능 우위나 실제 화폐 전용으로 오해되게 표현하지 않는다.

## 구매와 목표의 의미 분리

재화 구매는 꾸미기 사용 권한만 연다.

구매로 얻지 못하는 것:

- 목표 완료 상태
- 목표 달성 날짜
- 업적 표식
- 목표 관련 통계
- 목표 달성 대체 보상

따라서 플레이어는 접근성·시간 제약 때문에 재화 경로를 선택할 수 있지만, 숙련 목표를 실제로 달성한 기록은 별도 의미를 유지한다.

## 재화 전용 꾸미기 보호 규칙

- CURRENCY_ONLY item은 gameplay 성능·정보량·충돌·가독성을 바꾸지 않는다.
- 재화 전용이라는 이유로 DUAL_PATH item보다 높은 수치·더 작은 collision·더 명확한 token을 제공하지 않는다.
- 실제 화폐 구매, 광고 시청, 시즌 패스, loot box는 별도 사용자 Decision 없이는 연결하지 않는다.
- catalog에서 영구적으로 구매 가능한 기본 정책을 사용한다. 기간 한정 FOMO는 범위 밖이다.
- 가격 차이는 제작 복잡도·수집 pacing의 표현일 뿐 gameplay tier가 아니다.

## Profile·마이그레이션

`SX-DEC-019` Profile에 다음 필드를 추가한다.

```text
cosmetic_currency_balance: int
completed_cosmetic_goal_ids: Array[String]
unlock_provenance_by_cosmetic_id: Dictionary
processed_progression_event_ids: bounded set or journal
```

마이그레이션 원칙:

- 기존 unlocked ID는 `MIGRATED` provenance로 보존한다.
- 기존 기본 item은 DEFAULT로 정규화한다.
- 음수·비정상 currency 값은 0으로 복구한다.
- 알 수 없는 goal ID는 완료 목록에서 격리하거나 무시하되 전체 Profile을 폐기하지 않는다.
- processed event journal은 크기 상한과 pruning 정책을 가진다.
- 해금 정의가 사라져도 이미 보유한 시각 자산이 없으면 category default로 fallback한다.

## 권위와 데이터 흐름

```text
Authoritative run evidence
→ GoalEligibilityPolicy
→ CosmeticGoalProgress
→ CosmeticUnlockService

ProfileStore + CosmeticCurrencyWallet
→ CosmeticUnlockService
→ atomic Profile transaction
→ CosmeticCollectionState
→ CosmeticViewModel
→ UI / Visual / Audio views
```

- `CosmeticUnlockService`가 goal completion과 purchase의 유일한 해금 권위다.
- `CosmeticCurrencyWallet`은 balance 산술과 bounded grant/debit만 담당한다.
- 일반 run 보상 산식은 `SX-DEC-021` 전에는 production grant source로 연결하지 않는다.
- `CosmeticCollectionState`는 unlock 결과를 소비하며 가격·목표를 계산하지 않는다.
- view는 진행도·가격·상태를 표시할 뿐 거래·목표 event를 확정하지 않는다.

## 계측

권장 bounded event:

```text
cosmetic_goal_progressed
cosmetic_goal_completed
cosmetic_unlocked_by_goal
cosmetic_purchase_succeeded
cosmetic_purchase_rejected
cosmetic_goal_compensation_granted
cosmetic_currency_balance_changed
```

필수 field는 event_id, cosmetic_id, goal_id, unlock_mode, reason_code, catalog_version으로 제한한다. 원시 Profile, 전체 run history, 무제한 transaction payload를 telemetry에 저장하지 않는다.

## Vertical Slice 최소 범위

1. DEFAULT, DUAL_PATH, CURRENCY_ONLY 각 1개 registry fixture.
2. DUAL_PATH 목표 완료 해금.
3. DUAL_PATH 재화 대체 구매.
4. CURRENCY_ONLY 구매.
5. 구매 후 목표 달성 시 1회 대체 보상.
6. 중복 goal/purchase event idempotency.
7. balance 부족·invalid item·이미 보유·저장 실패 안전 처리.
8. Profile migration과 provenance 보존.
9. Collection UI에서 목표 진행과 가격을 함께 표시.
10. 장착 전후 gameplay parity는 `SX-DEC-019` 계약을 그대로 재검증.

일반 run 재화 획득 공식, 전체 상점, 실제 화폐, 광고, 시즌, loot box, 온라인 account sync는 범위 밖이다.

## 합격 기준

자동 검증:

- DUAL_PATH item은 목표 완료와 재화 구매 중 어느 경로로도 해금된다.
- 구매는 goal completion을 자동 기록하지 않는다.
- CURRENCY_ONLY item은 goal event로 해금되지 않는다.
- 같은 purchase transaction을 반복 처리해도 재화 차감은 정확히 1회다.
- 구매 뒤 목표를 완료하면 goal completion은 기록되고 compensation은 정확히 1회다.
- 이미 보유한 item 재구매는 balance를 변경하지 않는다.
- invalid/assisted/ruleset-mismatch run은 목표를 완료하지 않는다.
- Profile migration 후 balance·goal completion·unlock provenance가 보존된다.
- unlock 경로와 관계없이 gameplay parity는 100% 동일하다.

Android·사람 검증:

- 5명 이상 중 4명 이상이 `목표를 달성하거나 재화로 살 수 있다`고 설명할 수 있다.
- 5명 이상 중 4명 이상이 구매와 목표 완료가 별도 상태임을 이해한다.
- CURRENCY_ONLY 표식이 실제 화폐 전용 또는 성능 우위로 오해되지 않는다.
- 목표·가격·장착 UI가 active run과 빠른 RESTART를 방해하지 않는다.

## 적대적 검토 결과

- `SX-AUD-004-F41 · ACHIEVEMENT_VALUE_EROSION_RISK`: 재화 구매가 목표 달성 의미까지 대체할 위험. ownership과 goal completion·provenance를 분리한다.
- `SX-AUD-004-F42 · DOUBLE_DEBIT_REWARD_RISK`: 중복 event·save 재시도로 재화가 여러 번 차감되거나 보상이 중복될 위험. transaction ID와 atomic idempotent 처리로 차단한다.
- `SX-AUD-004-F43 · CURRENCY_ONLY_POWER_FOMO_RISK`: 재화 전용 item이 성능 우위·실제 화폐·기간 한정으로 오해될 위험. cosmetic parity·영구 catalog·별도 승인 경계로 차단한다.
- `SX-AUD-004-F44 · ASSISTED_GOAL_FARM_RISK`: first-run assist·debug·무결성 손상 run으로 목표를 쉽게 완료할 위험. GoalEligibilityPolicy로 제외한다.
- `SX-AUD-004-F45 · ECONOMY_PACING_RISK`: 가격과 획득량이 맞지 않아 무의미한 파밍 또는 즉시 고갈이 발생할 위험. 모든 수치를 TEST_VALUE로 두고 재화 획득 정책을 `SX-DEC-021`로 분리한다.

현재 알려진 P0/P1 open finding은 없다. 제품 구현, 가격 튜닝, 일반 run 재화 획득, 대표 자산, Android, migration, 사람 검증은 `NOT_STARTED / NOT_DECIDED / NOT_RUN`이다.
