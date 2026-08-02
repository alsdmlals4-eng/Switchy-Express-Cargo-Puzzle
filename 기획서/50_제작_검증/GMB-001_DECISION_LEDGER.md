# GMB-001 Grill Me Decision Ledger

```yaml
batch_id: GMB-001
baseline_main: 993c3ed1aaee172be52a8a8899685b419f7f6d97
branch: batch/gmb-001
draft_pr: 29
batch_size: 10
approved_count: 7/10
status: IN_PROGRESS · APPROVED_PENDING_BATCH_MERGE
canonical_main_sync: NOT_YET_MERGED
sheet_state: APPROVED_PENDING_BATCH_MERGE
codex_state: CODEX_NOT_READY
next_decision: SX-DEC-024
```

## 운영 경계

- 이 파일은 `SX-OPS-001`에 따른 `GMB-001` branch authority다.
- 승인 Decision은 동일 ID로 branch·Draft PR·Issue #6·올바른 Google Sheet에 즉시 기록한다.
- 10/10 전에는 main 병합, `SYNCED`, `READY_FOR_BUILD`, 제품 구현을 금지한다.
- 10번째 승인 뒤 신규 Decision을 동결하고 GitHub·PR·Issue·정본·Registry·Sheet 12탭 적대적 전수감사를 수행한다.
- 현재 batch는 설계·TDD 계획만 포함하며 제품 코드·Scene·Resource·asset·runtime 데이터는 변경하지 않는다.

## Batch Inventory

| Slot | Decision | Evidence | 요약 | 상태 | 책임 설계 |
|---:|---|---|---|---|---|
| 1 | `SX-DEC-017` | `EV-USER-006` | 결과에 검증된 실패 원인 1개와 다음 행동 1개, 불확실하면 중립 fallback | APPROVED_PENDING_BATCH_MERGE | `docs/superpowers/specs/2026-08-02-result-failure-feedback-design.md` |
| 2 | `SX-DEC-018` | `EV-USER-007` | 최초 PREP 약한 확대, START 뒤 전체 맵 복귀, active run 고정 전체 맵 | APPROVED_PENDING_BATCH_MERGE | `docs/superpowers/specs/2026-08-02-preparation-zoom-full-map-camera-design.md` |
| 3 | `SX-DEC-019` | `EV-USER-008` | 표준 개인 기록 3종과 성능 없는 cosmetic-only 영구 진행 | APPROVED_PENDING_BATCH_MERGE | `docs/superpowers/specs/2026-08-02-records-cosmetic-only-progression-design.md` |
| 4 | `SX-DEC-020` | `EV-USER-009` | DEFAULT·DUAL_PATH·CURRENCY_ONLY 해금, 목표와 재화 경로 분리 | APPROVED_PENDING_BATCH_MERGE | `docs/superpowers/specs/2026-08-02-goal-or-currency-cosmetic-unlocks-design.md` |
| 5 | `SX-DEC-021` | `EV-USER-010` | 유효 run 기본 재화와 배송·Combo·신기록 bounded 보너스 | APPROVED_PENDING_BATCH_MERGE | `docs/superpowers/specs/2026-08-02-bounded-run-cosmetic-currency-rewards-design.md` |
| 6 | `SX-DEC-022` | `EV-USER-011` | 난이도 상승 전 짧은 경고와 3단계 지속 신호, 내부 공식은 비공개 | APPROVED_PENDING_BATCH_MERGE | `docs/superpowers/specs/2026-08-02-difficulty-escalation-communication-design.md` |
| 7 | `SX-DEC-023` | `EV-USER-012` | RESTART는 같은 map/seed, 새 seed는 100+ 검증 맵 카탈로그 제작에 사용 | APPROVED_PENDING_BATCH_MERGE | `docs/superpowers/specs/2026-08-02-same-seed-restart-curated-map-catalog-design.md` |
| 8 | — | — | — | OPEN | — |
| 9 | — | — | — | OPEN | — |
| 10 | — | — | — | OPEN | — |

---

## SX-DEC-017 — 결과 화면 실패 학습

```yaml
evidence_id: EV-USER-006
evidence_type: CONFIRMED_USER_DECISION
source: 2026-08-02 conversation · recommended option A approved
```

### 결정

결과 화면은 score·survival time·max Combo·new record를 유지하고, immutable `RunSummary`가 뒷받침하는 실패 원인 1개와 다음 run 행동 1개를 표시한다. 근거가 약하거나 후보가 비슷하면 `NEUTRAL` fallback을 사용한다.

### 보호 계약

- cause code: `BOOST_OVERUSE`, `HEAVY_LOAD_DELAY`, `DELIVERY_GAP`, `ROUTE_MISMATCH_LOOP`, `NEUTRAL`.
- 원인 분석은 deterministic analyzer가 담당한다.
- 비난·가짜 반사실·근거 없는 단정 금지.
- UI·animation은 결과 계산·저장·reward·restart 권위가 아니다.
- assisted first run evidence는 일반 run과 분리한다.
- RESTART는 primary action이다.
- threshold·confidence·margin은 `TEST_VALUE`다.

### 문서·상태

- 설계: `docs/superpowers/specs/2026-08-02-result-failure-feedback-design.md`
- 계획: `docs/superpowers/plans/2026-08-02-result-failure-feedback.md`
- 구현·runtime·Android·사람: `NOT_STARTED / NOT_RUN`

### Findings

`F26` 인과 과장 · `F27` 플레이어 비난 · `F28` UI 권위 · `F29` assist evidence 오염 · `F30` 결과 과밀

---

## SX-DEC-018 — 준비 확대 + 운행 중 전체 맵 고정

```yaml
evidence_id: EV-USER-007
evidence_type: CONFIRMED_USER_DECISION
source: 2026-08-02 conversation · option A with preparation zoom refinement
```

### 결정

최초 PREP/READY에서는 기관차와 출발 주변을 약간 확대한다. START 뒤 fuel·timer·difficulty·spawn·board input을 시작하기 전에 전체 15×10 맵으로 복귀하며, `FULL_MAP_READY` 뒤 authoritative run을 시작한다. active run은 고정 전체 맵이다.

### 보호 계약

- PREP `1.20×`, transition `0.75s`는 `TEST_VALUE`.
- active run 추적·자동 zoom·회전·free pan·inset 없음.
- Reduced Motion은 즉시 full-map cut.
- 즉시 RESTART는 준비 확대를 반복하지 않고 full-map direct.
- Camera2D·Tween·animation은 run 권위가 아니다.
- generation-safe readiness와 synchronous fallback으로 interruption deadlock 방지.

### 문서·상태

- 설계: `docs/superpowers/specs/2026-08-02-preparation-zoom-full-map-camera-design.md`
- 계획: `docs/superpowers/plans/2026-08-02-preparation-zoom-full-map-camera.md`
- 구현·runtime·Android·사람: `NOT_STARTED / NOT_RUN`

### Findings

`F31` pre-start 공정성 · `F32` 방향 상실 · `F33` 입력 좌표 · `F34` 멀미/재도전 지연 · `F35` interruption deadlock

---

## SX-DEC-019 — 표준 기록 + cosmetic-only 영구 진행

```yaml
evidence_id: EV-USER-008
evidence_type: CONFIRMED_USER_DECISION
source: 2026-08-02 conversation · hybrid A+B approved
```

### 결정

영구 진행은 표준 개인 기록 3종과 성능 없는 꾸미기 해금·장착만 허용한다.

### 보호 계약

- 기록: `best_score`, `longest_survival_seconds`, `best_max_combo`.
- assisted first run·ruleset mismatch·integrity invalid는 표준 기록 비적격.
- cosmetic metadata에 modifier/stat/multiplier/bonus field 금지.
- speed·fuel·capacity·BOOST·score·spawn·map·route·collision·camera·onboarding·record eligibility 불변.
- active route·switch·station·cargo·rear LIFO·fuel warning 가독성 불변.
- 누락/삭제 cosmetic ID는 category default fallback.
- versioned atomic Profile과 기록/꾸미기 데이터 격리.

### 문서·상태

- 설계: `docs/superpowers/specs/2026-08-02-records-cosmetic-only-progression-design.md`
- 계획: `docs/superpowers/plans/2026-08-02-records-cosmetic-only-progression.md`
- 구현·asset·runtime·Android·사람: `NOT_STARTED / NOT_RUN`

### Findings

`F36` hidden power · `F37` 가독성/collision · `F38` assisted record · `F39` grind/idempotency · `F40` migration/missing content

---

## SX-DEC-020 — 목표 또는 재화 해금 + 재화 전용 꾸미기

```yaml
evidence_id: EV-USER-009
evidence_type: CONFIRMED_USER_DECISION
source: 2026-08-02 conversation · hybrid A+C approved
```

### 결정

꾸미기 mode는 `DEFAULT`, `DUAL_PATH`, `CURRENCY_ONLY`다. DUAL_PATH는 eligible goal 또는 꾸미기 재화 구매, CURRENCY_ONLY는 재화 구매로만 해금한다.

### 보호 계약

- 구매는 목표 완료·업적 표식을 대신하지 않는다.
- 구매 후 목표 완료 시 bounded compensation을 정확히 한 번 지급한다.
- goal evidence는 completed·non-assisted·current ruleset·integrity VALID run만 사용한다.
- debit+unlock과 compensation은 atomic·idempotent transaction.
- CURRENCY_ONLY는 power·real-money exclusivity·limited FOMO를 암시하지 않는다.
- price·compensation은 `TEST_VALUE`.

### 문서·상태

- 설계: `docs/superpowers/specs/2026-08-02-goal-or-currency-cosmetic-unlocks-design.md`
- 계획: `docs/superpowers/plans/2026-08-02-goal-or-currency-cosmetic-unlocks.md`
- 구현·Profile·runtime·Android·사람: `NOT_STARTED / NOT_RUN`

### Findings

`F41` 목표 의미 침식 · `F42` 이중 차감/보상 · `F43` power/FOMO 오해 · `F44` assisted goal farm · `F45` economy pacing

---

## SX-DEC-021 — bounded run 꾸미기 재화 보상

```yaml
evidence_id: EV-USER-010
evidence_type: CONFIRMED_USER_DECISION
source: 2026-08-02 conversation · recommended option C approved
```

### 결정

completed·current ruleset·integrity VALID·non-debug·non-assisted이며 성공 배송 1회 이상인 run에 기본 재화를 지급하고 배송·최고 Combo 단계·authoritative 표준 신기록에 bounded 보너스를 더한다. 생존 시간과 raw score에는 직접 비례 보상을 주지 않는다.

### Formula v1 `TEST_VALUE`

```yaml
base_reward: 10
delivery_reward_each: 2
delivery_reward_cap: 10
combo_tiers: {3: 2, 5: 5, 8: 8}
new_record_reward: 5
new_record_reward_cap_per_run: 5
run_total_cap: 30
onboarding_intro_grant: 10
```

### 보호 계약

- Combo 보너스는 최고 단계 하나만 지급.
- record bonus는 run당 한 번.
- assisted variable reward는 0, 실제 onboarding 완료+배송의 intro grant만 Profile당 한 번.
- reward event ID와 balance+journal atomic·idempotent commit.
- `RecordCommitResult`가 신기록 증거이며 UI animation은 증거가 아님.
- ResultPanel은 committed receipt만 표시하고 RESTART primary 유지.

### 문서·상태

- 설계: `docs/superpowers/specs/2026-08-02-bounded-run-cosmetic-currency-rewards-design.md`
- 계획: `docs/superpowers/plans/2026-08-02-bounded-run-cosmetic-currency-rewards.md`
- 구현·Profile·경제 simulation·runtime·Android·사람: `NOT_STARTED / NOT_RUN`

### Findings

`F46` short/idle farm · `F47` reward snowball · `F48` duplicate grant · `F49` assisted contamination · `F50` record/UI authority

---

## SX-DEC-022 — 난이도 상승 사전 경고 + 지속 신호

```yaml
evidence_id: EV-USER-011
evidence_type: CONFIRMED_USER_DECISION
source: 2026-08-02 conversation · recommended option C approved
```

### 결정

의미 있는 authoritative 난이도 상승 직전에 짧은 사전 경고를 표시하고, commit 뒤 `CALM/BUSY/INTENSE` 3단계 지속 신호를 유지한다. 정확한 내부 formula·step·spawn interval·multiplier는 기본 HUD에 공개하지 않는다.

### Initial `TEST_VALUE`

```yaml
prewarning_lead_seconds: 5.0
banner_visible_seconds: 1.5
banner_cooldown_seconds: 8.0
bands: {CALM: steps 0-1, BUSY: steps 2-3, INTENSE: steps 4+}
```

### 보호 계약

- `DifficultyDirector`만 schedule·commit 권위 보유.
- presentation은 forecast/event를 읽을 뿐 advance·delay·skip·reroll 금지.
- 경고는 simulation pause·input lock·board 가림을 만들지 않는다.
- assist/pause는 authoritative clock과 presentation clock을 함께 멈춤.
- assist 종료는 fresh forecast, no catch-up.
- restart는 generation을 갱신하고 stale warning/callback 무효화.
- suspend/resume wall-clock catch-up 금지.
- same seed/ruleset/input은 warning mode·Reduced Motion과 무관하게 동일 simulation.

### 문서·상태

- 설계: `docs/superpowers/specs/2026-08-02-difficulty-escalation-communication-design.md`
- 계획: `docs/superpowers/plans/2026-08-02-difficulty-escalation-communication.md`
- 구현·runtime·Android·localization·사람: `NOT_STARTED / NOT_RUN`

### Findings

`F51` UI authority · `F52` forecast drift/late warning · `F53` spam/occlusion · `F54` lifecycle stale/catch-up · `F55` accessibility/localization parity

---

## SX-DEC-023 — 같은 map/seed 즉시 재시작 + 100+ 검증 맵 카탈로그

```yaml
evidence_id: EV-USER-012
evidence_type: CONFIRMED_USER_DECISION
source: 2026-08-02 conversation · option A approved with 100+ map-catalog refinement
user_statement: RESTART는 같은 seed; 새 seed 제작은 맵 개수를 늘리는 데 사용하며 약 100개 이상 목표
```

### 결정

`RESTART`는 종료된 run과 같은 `map_id`, `map_revision`, `map_seed`, generator/ruleset version, reconstruction signature를 사용한다. 새 seed를 뽑거나 다른 맵을 선택하지 않는다.

새 seed는 별도의 offline content pipeline에서 생성·검증·중복 제거한 뒤 맵 카탈로그에 추가한다. 제품 목표는 seed 정수 100개가 아니라 **고유 `layout_signature`를 가진 검증 맵 100개 이상**이다.

### Identity 계약

```text
immutable map identity
= map_id + revision + seed + generator/ruleset versions
+ graph/station/initial-pickup/layout/content signatures

mutable attempt identity
= new run_id + retry_index + restarted_from_run_id
```

- same-map retry는 map identity를 보존한다.
- 매 attempt는 새 `run_id`, reward event namespace, telemetry row를 가진다.
- `map_seed`를 run/reward/save transaction ID로 사용하지 않는다.

### Reset 계약

재시작 때 반드시 새 instance로 재구성:

- RunState·fuel·score·Combo,
- CargoStack·compact token,
- switch runtime/target lock,
- train position·speed·route history,
- station/delivery state,
- pickup collection·pending respawn,
- difficulty schedule state·forecast·warning cooldown/presentation generation,
- result evidence·pause/suspend·reward/save transaction state.

### MapDefinition 필드

```yaml
map_id: StringName
map_revision: int
map_seed: int
generator_version: StringName
ruleset_version: StringName
graph_signature: String
station_signature: String
initial_pickup_signature: String
layout_signature: String
content_signature: String
validation_status: DRAFT|VALIDATED|SHIPPED|RETIRED
used_fallback: bool
```

standard run은 `VALIDATED|SHIPPED`, complete signatures, `used_fallback=false`만 허용한다.

### 카탈로그 고유성·생성기 제약

현재 `RailGenerator`는 upper/lower row와 left/right column의 네 이진 선택만 사용하므로 선로 topology가 최대 약 16개다. 현재 코드로 seeds 1~100이 valid여도 100개의 실질적 선로 layout을 뜻하지 않는다.

권장 확장:

- interior rows `1..8`에서 서로 다른 2개,
- interior columns `1..13`에서 서로 다른 3개,
- perimeter loop 유지,
- `(seed, attempt)` deterministic shuffle,
- 기존 32 attempts와 safe fallback 유지,
- fallback·duplicate layout은 catalog promotion 거부.

### Vertical Slice·Production 경계

- VS: 고유 validated map 3개, same-map restart 1개, component signature parity, mutable reset, new IDs, duplicate/fallback rejection.
- Production: 고유 validated `layout_signature` 100개 이상 + rebuild audit + visual/readability + difficulty distribution + human evidence.
- 100개 생성 도구가 존재하는 것과 100개 제작 완료는 구분한다.

### 연동 계약

- `SX-DEC-017`: 같은 조건에서 실패 학습을 시험.
- `SX-DEC-018`: restart는 direct full-map, `FULL_MAP_READY` gate 유지.
- `SX-DEC-019~021`: retry도 새 eligible run이며 record/reward는 새 run identity 사용.
- `SX-DEC-022`: old warning/forecast 폐기, same seed/ruleset/input event parity.
- `SX-DEC-016`: map은 같되 assist state는 기존 Profile/onboarding 계약으로 재구성.

### 미결 범위

다른 맵의 선택·순환·해금·발견 방식과 global/per-map record 공정성은 `SX-DEC-024+`로 분리한다.

### 문서·상태

- 설계: `docs/superpowers/specs/2026-08-02-same-seed-restart-curated-map-catalog-design.md`
- 계획: `docs/superpowers/plans/2026-08-02-same-seed-restart-curated-map-catalog.md`
- 구현·catalog asset·runtime·Android·사람: `NOT_STARTED / NOT_RUN`

### Findings

- `F56` mutable restart leakage.
- `F57` seed와 transaction identity 충돌.
- `F58` duplicate/fallback seed로 map count 부풀림.
- `F59` generator/ruleset version drift.
- `F60` 100+ catalog 규모의 invalid·unreadable·difficulty outlier QA 실패.

---

## Cross-Decision Protected Contracts

- UI·camera·Tween·animation·result·collection·reward·warning은 non-authoritative.
- `FULL_MAP_READY` 전 run progression 없음.
- active run은 고정 전체 맵.
- assisted first run은 표준 record·goal·variable reward·balance evidence와 분리.
- currency·unlock·reward operation은 atomic·idempotent.
- map identity와 run/transaction identity는 분리.
- same-map restart는 새 mutable service graph를 만들며 reset 메서드로 기존 instance를 재사용하지 않음.
- fallback/duplicate map은 제품 map count에 포함하지 않음.
- balance·timing·price·reward·camera·difficulty band·catalog thresholds는 검증 전 `TEST_VALUE`.

## Adversarial Finding Register

| 범위 | Finding |
|---|---|
| Result | `F26~F30` |
| Camera | `F31~F35` |
| Profile/Cosmetic | `F36~F40` |
| Unlock Economy | `F41~F45` |
| Currency Reward | `F46~F50` |
| Difficulty Signal | `F51~F55` |
| Restart/Map Catalog | `F56~F60` |

현재 설계상 알려진 P0는 없다. `F58`은 현재 생성기 구현이 100 unique-layout 목표를 충족하지 못한다는 명시적 구현 의무이며, 확장·target-100 audit 전까지 production map 목표는 `NOT_MET`이다.

## Verification State

```yaml
planning_spec_review: PASS
implementation_plan_review: PASS
product_code_changed: false
scene_resource_asset_changed: false
runtime_feature_tests: NOT_RUN
android: NOT_RUN
human: NOT_RUN
localization: NOT_RUN
economy_simulation: NOT_RUN
map_catalog_target_3: NOT_RUN
map_catalog_target_100: NOT_RUN
batch_status: APPROVED_PENDING_BATCH_MERGE
codex_state: CODEX_NOT_READY
```

## 다음 Grill Me 후보

`SX-DEC-024` — 100+ 맵을 플레이어에게 어떻게 배정·노출할지 결정한다.

- 전체 맵 직접 선택,
- 자동 순환/무작위 배정,
- 비반복 자동 순환 + 플레이한 맵 직접 선택,
- 또는 별도 조합.

상태: `NEXT_GRILL_ME · GMB-001 SLOT 8`.
