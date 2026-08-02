# GMB-001 Grill Me Decision Ledger

```yaml
batch_id: GMB-001
baseline_main: 993c3ed1aaee172be52a8a8899685b419f7f6d97
branch: batch/gmb-001
draft_pr: 29
batch_size: 10
approved_count: 6/10
status: IN_PROGRESS · APPROVED_PENDING_BATCH_MERGE
canonical_main_sync: NOT_YET_MERGED
sheet_state: APPROVED_PENDING_BATCH_MERGE
codex_state: CODEX_NOT_READY
```

## 운영 경계

- 이 원장은 `SX-OPS-001`에 따른 첫 정규 Grill Me 배치의 branch authority다.
- 승인된 Decision은 동일 Decision ID로 branch·Draft PR·Issue·올바른 Google Sheet에 즉시 기록한다.
- 10/10 전에는 main에 병합하거나 `SYNCED`로 표시하지 않는다.
- 10번째 승인 뒤 새 Decision을 동결하고 GitHub·PR·Issue·정본·Registry·Sheet 12탭 적대적 전수감사를 수행한다.
- 제품 코드·Scene·Resource·asset은 별도 구현 승인과 `READY_FOR_BUILD` 전에는 변경하지 않는다.

## Batch Inventory

| Slot | Decision | Evidence | 요약 | 상태 | 책임 정본 |
|---:|---|---|---|---|---|
| 1 | `SX-DEC-017` | `EV-USER-006` | 결과에 검증된 실패 원인 1개와 다음 행동 1개, 불확실하면 중립 fallback | APPROVED_PENDING_BATCH_MERGE | `docs/superpowers/specs/2026-08-02-result-failure-feedback-design.md` |
| 2 | `SX-DEC-018` | `EV-USER-007` | 최초 PREP 약한 확대, START 뒤 전체 맵 복귀, active run 고정 전체 맵 | APPROVED_PENDING_BATCH_MERGE | `docs/superpowers/specs/2026-08-02-preparation-zoom-full-map-camera-design.md` |
| 3 | `SX-DEC-019` | `EV-USER-008` | 표준 개인 기록과 성능 없는 cosmetic-only 영구 진행 | APPROVED_PENDING_BATCH_MERGE | `docs/superpowers/specs/2026-08-02-records-cosmetic-only-progression-design.md` |
| 4 | `SX-DEC-020` | `EV-USER-009` | DEFAULT·DUAL_PATH·CURRENCY_ONLY 해금, 목표 또는 재화 경로 분리 | APPROVED_PENDING_BATCH_MERGE | `docs/superpowers/specs/2026-08-02-goal-or-currency-cosmetic-unlocks-design.md` |
| 5 | `SX-DEC-021` | `EV-USER-010` | 유효 run 기본 재화와 배송·Combo·신기록 bounded 보너스 | APPROVED_PENDING_BATCH_MERGE | `docs/superpowers/specs/2026-08-02-bounded-run-cosmetic-currency-rewards-design.md` |
| 6 | `SX-DEC-022` | `EV-USER-011` | 난이도 상승 전 짧은 경고와 3단계 지속 신호, 정확한 내부 공식은 비공개 | APPROVED_PENDING_BATCH_MERGE | `docs/superpowers/specs/2026-08-02-difficulty-escalation-communication-design.md` |
| 7 | — | — | — | OPEN | — |
| 8 | — | — | — | OPEN | — |
| 9 | — | — | — | OPEN | — |
| 10 | — | — | — | OPEN | — |

---

## SX-DEC-017 — 결과 화면 실패 학습

### 사용자 승인·Evidence

```yaml
evidence_id: EV-USER-006
evidence_type: CONFIRMED_USER_DECISION
source: 2026-08-02 conversation · recommended option A approved
status: RECORDED_IN_BATCH_BRANCH
```

### 결정

연료 0 결과 화면은 score·survival time·max Combo·new record를 유지하고, 실제 run telemetry로 뒷받침되는 핵심 실패 원인 1개와 다음 run 행동 1개를 표시한다. 근거가 약하거나 후보가 비슷하면 `NEUTRAL` fallback을 사용한다.

### 보호 계약

- 원인 분석은 immutable `RunSummary`를 읽는 deterministic analyzer가 담당한다.
- UI·animation은 원인 계산·저장·게임오버·reward·restart 권위가 아니다.
- 문구는 비난 대신 관측 상태와 행동 제안을 분리한다.
- assisted first run은 일반 밸런스·원인 evidence와 분리한다.
- RESTART는 primary action이다.
- cause threshold·confidence·margin은 `TEST_VALUE`다.

### 1차 cause code

```text
BOOST_OVERUSE
HEAVY_LOAD_DELAY
DELIVERY_GAP
ROUTE_MISMATCH_LOOP
NEUTRAL
```

### 책임 문서·상태

- 설계: `docs/superpowers/specs/2026-08-02-result-failure-feedback-design.md`
- TDD 계획: `docs/superpowers/plans/2026-08-02-result-failure-feedback.md`
- 구현·자동화·Android·사람 검증: `NOT_STARTED / NOT_RUN`

---

## SX-DEC-018 — 준비 확대 + 실제 운행 전체 맵 고정

### 사용자 승인·Evidence

```yaml
evidence_id: EV-USER-007
evidence_type: CONFIRMED_USER_DECISION
source: 2026-08-02 conversation · option A refined with preparation/start zoom
status: RECORDED_IN_BATCH_BRANCH
```

### 결정

최초 PREP/READY에서는 기관차와 출발 주변을 약간 확대한다. START 입력 뒤 simulation·fuel·timer·difficulty·spawn·board input을 시작하기 전에 전체 15×10 맵으로 복귀하고, `FULL_MAP_READY` 뒤 authoritative run을 시작한다. active run은 고정 전체 맵이다.

### 보호 계약

- PREP baseline `1.20×`, transition `0.75s`는 `TEST_VALUE`다.
- 실제 운행 중 추적·자동 줌·회전·free pan·context inset은 없다.
- Reduced Motion은 즉시 full-map cut을 사용한다.
- 즉시 RESTART는 준비 확대를 반복하지 않고 full-map direct를 기본으로 한다.
- Camera2D·Tween·animation은 run·fuel·spawn·route·onboarding 권위가 아니다.
- generation-safe readiness와 synchronous fallback으로 interruption deadlock을 방지한다.

### 책임 문서·상태

- 설계: `docs/superpowers/specs/2026-08-02-preparation-zoom-full-map-camera-design.md`
- TDD 계획: `docs/superpowers/plans/2026-08-02-preparation-zoom-full-map-camera.md`
- 구현·자동화·Android·사람 검증: `NOT_STARTED / NOT_RUN`

---

## SX-DEC-019 — 표준 기록 + cosmetic-only 영구 진행

### 사용자 승인·Evidence

```yaml
evidence_id: EV-USER-008
evidence_type: CONFIRMED_USER_DECISION
source: 2026-08-02 conversation · hybrid A+B approved
status: RECORDED_IN_BATCH_BRANCH
```

### 결정

run 밖 영구 진행은 표준 개인 기록과 꾸미기 해금·장착으로 제한한다. 모든 표준 run은 동일한 속도·연료·적재·점수·BOOST·맵·충돌 규칙을 사용하며, 꾸미기는 외형·소리·연출만 바꾼다.

### 보호 계약

- 표준 기록: `best_score`, `longest_survival_seconds`, `best_max_combo`.
- assisted first run, ruleset mismatch, integrity invalid run은 표준 기록 비적격이다.
- `CosmeticDefinition`에는 gameplay modifier field가 없다.
- equip 전후 speed·fuel·score·capacity·collision·footprint·seed·record eligibility parity를 유지한다.
- token 스킨은 색상+모양과 rear/HUD 의미를 보존한다.
- 누락·삭제 cosmetic ID는 category default로 fallback한다.
- Vertical Slice는 기록 저장과 대표 기관차 스킨 1종만 검증한다.

### 책임 문서·상태

- 설계: `docs/superpowers/specs/2026-08-02-records-cosmetic-only-progression-design.md`
- TDD 계획: `docs/superpowers/plans/2026-08-02-records-cosmetic-only-progression.md`
- 구현·자동화·asset·Android·사람 검증: `NOT_STARTED / NOT_RUN`

---

## SX-DEC-020 — 목표 또는 재화 해금 + 재화 전용 배치

### 사용자 승인·Evidence

```yaml
evidence_id: EV-USER-009
evidence_type: CONFIRMED_USER_DECISION
source: 2026-08-02 conversation · hybrid A+C with currency-only placement approved
status: RECORDED_IN_BATCH_BRANCH
```

### 결정

꾸미기 해금 유형은 `DEFAULT`, `DUAL_PATH`, `CURRENCY_ONLY`다. DUAL_PATH는 eligible goal 완료 또는 꾸미기 재화 구매로 해금하며, CURRENCY_ONLY는 재화로만 해금한다. 구매는 목표 완료·업적 표식을 대신하지 않는다.

### 보호 계약

- DEFAULT는 항상 보유하며 가격·목표가 없다.
- DUAL_PATH는 non-empty goal ID와 양수 가격을 가진다.
- CURRENCY_ONLY는 goal ID가 없고 양수 가격을 가진다.
- 구매 후 실제 goal 완료 시 goal 기록을 남기고 bounded 1회 compensation만 지급한다.
- compensation은 item 가격 이하 `TEST_VALUE`다.
- goal evidence는 completed, non-assisted, current ruleset, integrity VALID run만 사용한다.
- debit+unlock과 compensation은 atomic·idempotent transaction이다.
- real money·ads·season·loot box·limited FOMO는 별도 승인 전 금지한다.

### 대표 fixture

```text
locomotive.default         → DEFAULT
locomotive.goal_sample     → DUAL_PATH
locomotive.currency_sample → CURRENCY_ONLY
```

### 책임 문서·상태

- 설계: `docs/superpowers/specs/2026-08-02-goal-or-currency-cosmetic-unlocks-design.md`
- TDD 계획: `docs/superpowers/plans/2026-08-02-goal-or-currency-cosmetic-unlocks.md`
- 구현·자동화·Profile·Android·사람 검증: `NOT_STARTED / NOT_RUN`

---

## SX-DEC-021 — bounded run 꾸미기 재화 보상

### 사용자 승인·Evidence

```yaml
evidence_id: EV-USER-010
evidence_type: CONFIRMED_USER_DECISION
source: 2026-08-02 conversation · recommended option C approved
status: RECORDED_IN_BATCH_BRANCH
```

### 결정

completed·current ruleset·integrity VALID·non-debug·non-assisted이고 성공 배송이 1회 이상인 일반 run에 기본 재화를 지급한다. 성공 배송, 최고 Combo 단계, authoritative 표준 신기록에 bounded 보너스를 더하며 생존 시간과 raw score에는 직접 비례 보상을 주지 않는다.

### Formula v1 `TEST_VALUE`

```yaml
base_reward: 10
delivery_reward_each: 2
delivery_reward_cap: 10
combo_tiers:
  3: 2
  5: 5
  8: 8
new_record_reward: 5
new_record_reward_cap_per_run: 5
run_total_cap: 30
onboarding_intro_grant: 10
```

### 보호 계약

- 여러 기록이 갱신돼도 record bonus는 run당 한 번이다.
- Combo tier는 합산하지 않고 최고 단계 하나만 지급한다.
- assisted first run의 variable reward는 0이다.
- 실제 onboarding 완료+배송 1회 시 intro grant를 Profile당 한 번만 지급한다.
- reward event ID와 balance+journal은 atomic·idempotent하게 commit한다.
- record bonus는 UI가 아닌 authoritative `RecordCommitResult`를 사용한다.
- ResultPanel은 committed receipt만 표시하고 RESTART primary를 유지한다.
- 가격·시간당 획득·최종 경제 속도는 `TEST_VALUE`다.

### 책임 문서·상태

- 설계: `docs/superpowers/specs/2026-08-02-bounded-run-cosmetic-currency-rewards-design.md`
- TDD 계획: `docs/superpowers/plans/2026-08-02-bounded-run-cosmetic-currency-rewards.md`
- 구현·자동화·Profile·경제 simulation·Android·사람 검증: `NOT_STARTED / NOT_RUN`

---

## SX-DEC-022 — 난이도 상승 사전 경고 + 지속 신호

### 사용자 승인·Evidence

```yaml
evidence_id: EV-USER-011
evidence_type: CONFIRMED_USER_DECISION
source: 2026-08-02 conversation · recommended option C approved
status: RECORDED_IN_BATCH_BRANCH
```

### 결정

운행 중 난이도 상승은 정확한 내부 수치와 공식을 상시 공개하지 않는다. authoritative 난이도 시스템이 예정한 의미 있는 상승 직전에 짧은 경고를 표시하고, 상승 후에는 현재 운행 압력을 3단계 persistent indicator로 유지한다.

```text
DifficultyDirector forecast
→ short prewarning
→ authoritative DifficultyStepCommitted
→ persistent band update
```

### Initial `TEST_VALUE`

```yaml
prewarning_lead_seconds: 5.0
prewarning_allowed_range_seconds: 3.0-7.0
banner_visible_seconds: 1.5
banner_allowed_range_seconds: 1.0-2.0
banner_cooldown_seconds: 8.0
persistent_bands:
  CALM: steps 0-1
  BUSY: steps 2-3
  INTENSE: steps 4+
```

### 보호 계약

- `DifficultyDirector` 또는 기존 authoritative 동등체만 schedule·step commit을 소유한다.
- presentation은 immutable forecast와 committed event만 읽고 난이도를 advance·delay·skip·reroll하지 않는다.
- 경고는 최대 2줄이며 exact step·spawn interval·배율·임계 시각을 기본 HUD에 표시하지 않는다.
- cooldown 중 banner를 stack하지 않고 latest committed step만 coalesce한다.
- persistent indicator는 committed event마다 최신 band로 즉시 갱신한다.
- forecast가 누락돼도 committed event readback으로 indicator를 복구하고 generic fallback을 사용할 수 있다.
- warning은 simulation을 pause하거나 board input을 잠그지 않는다.
- first-run assist와 onboarding safe pause 중 authoritative escalation과 warning timer를 모두 pause한다.
- assist 종료 시 fresh forecast를 읽고 보류 시간을 catch-up하지 않는다.
- manual pause 중 authoritative countdown·banner·cooldown이 함께 멈춘다.
- restart는 새 run generation을 발급하고 pending/coalesced/Tween callback을 동기적으로 폐기한다.
- suspend/resume은 wall-clock catch-up을 사용하지 않는다.
- 같은 seed·ruleset·입력은 warning enabled/disabled/Reduced Motion과 무관하게 같은 simulation hash와 commit sequence를 만든다.
- persistent band는 텍스트+형태+채움으로 표현하며 색상에만 의존하지 않는다.
- Reduced Motion은 움직임을 제거하되 copy·band·timing 의미를 보존한다.
- mute에서도 완전한 정보가 남고 Vertical Slice 기본 haptic은 없다.
- banner는 rail·station·switch·cargo token·fuel warning·rear LIFO 정보를 가리지 않는 reserved HUD lane에 둔다.
- 모든 threshold·timing·band mapping은 `TEST_VALUE`다.

### 책임 문서·상태

- 설계: `docs/superpowers/specs/2026-08-02-difficulty-escalation-communication-design.md`
- TDD 계획: `docs/superpowers/plans/2026-08-02-difficulty-escalation-communication.md`
- 기반 계약: first-session onboarding, preparation camera, result feedback specs
- 구현·자동화·telemetry·localization·Android·사람 검증: `NOT_STARTED / NOT_RUN`

---

## Adversarial Findings

| Finding ID | 유형 | 문제 | 처리 |
|---|---|---|---|
| `SX-AUD-004-F26` | CAUSALITY_OVERCLAIM_RISK | 상관 지표를 단일 실패 원인으로 단정 | 우세 score·margin 미달 시 neutral fallback |
| `SX-AUD-004-F27` | PLAYER_BLAME_RISK | 결과 문구가 플레이어 비난으로 인식 | 관측 상태+행동 제안, 5명+ 검증 |
| `SX-AUD-004-F28` | AUTHORITY_RISK | ResultPanel이 기록·종료·재시작·원인 계산 소유 | RunSummary→Analyzer→ViewModel 단방향 |
| `SX-AUD-004-F29` | EVIDENCE_CONTAMINATION | assisted first run이 일반 원인 evidence 오염 | assisted segment 분리 |
| `SX-AUD-004-F30` | RESULT_DENSITY_RISK | 결과 화면 과밀 | cause 1+action 1, details secondary |
| `SX-AUD-004-F31` | FAIRNESS_RISK | full-map 전 progression으로 첫 선택 전 손실 | FULL_MAP_READY 전 progression 정지 |
| `SX-AUD-004-F32` | ORIENTATION_RISK | PREP 과대 확대 | 1.15~1.25×와 필수 framing 검증 |
| `SX-AUD-004-F33` | INPUT_MAPPING_RISK | zoom 중 touch 좌표 오류 | transition input lock·좌표 parity |
| `SX-AUD-004-F34` | RETRY_MOTION_RISK | restart zoom 반복·멀미 | restart full-map direct·Reduced Motion cut |
| `SX-AUD-004-F35` | INTERRUPTION_AUTHORITY_RISK | Tween 완료 의존 deadlock | generation-safe state·sync fallback |
| `SX-AUD-004-F36` | HIDDEN_POWER_LEAK_RISK | cosmetic hidden modifier | modifier field 금지·gameplay parity |
| `SX-AUD-004-F37` | READABILITY_COLLISION_RISK | 스킨이 collision·정보 의미 변경 | collision/footprint 불변·Android 비교 |
| `SX-AUD-004-F38` | ASSISTED_RECORD_CONTAMINATION | assist 기록이 표준 기록 갱신 | RecordEligibility 제외 |
| `SX-AUD-004-F39` | IDLE_GRIND_EXPLOIT_RISK | 무조작·중복 종료 파밍 | 유효 run·idempotent event |
| `SX-AUD-004-F40` | SAVE_MIGRATION_LOCKOUT_RISK | cosmetic/save 손상 lockout | default fallback·부분 복구 |
| `SX-AUD-004-F41` | ACHIEVEMENT_VALUE_EROSION_RISK | 구매가 목표 의미 대체 | ownership·goal completion 분리 |
| `SX-AUD-004-F42` | DOUBLE_DEBIT_REWARD_RISK | 중복 debit·compensation | atomic idempotent transaction |
| `SX-AUD-004-F43` | CURRENCY_ONLY_POWER_FOMO_RISK | 재화 전용이 power/FOMO로 오해 | cosmetic parity·영구 catalog 경계 |
| `SX-AUD-004-F44` | ASSISTED_GOAL_FARM_RISK | assist/debug run 목표 farming | GoalEligibility 제외 |
| `SX-AUD-004-F45` | ECONOMY_PACING_RISK | 가격·획득량 불일치 | TEST_VALUE·simulation·telemetry 대조 |
| `SX-AUD-004-F46` | SHORT_IDLE_FARM_RISK | 짧은·무조작 run 재화 최적화 | 완료+배송 1회, 생존 직접 보상 금지 |
| `SX-AUD-004-F47` | REWARD_SNOWBALL_RISK | 성과 비례 보상 폭증 | component·run cap·highest tier |
| `SX-AUD-004-F48` | DUPLICATE_GRANT_RETRY_RISK | restart/save retry 중복 지급 | stable event ID·atomic journal |
| `SX-AUD-004-F49` | ASSISTED_REWARD_CONTAMINATION | assist가 일반 경제 오염 | variable reward 0·intro 1회 분리 |
| `SX-AUD-004-F50` | RECORD_ORDER_UI_AUTHORITY_RISK | UI record flag가 bonus 권위 | RecordCommitResult 뒤 계산·committed receipt |
| `SX-AUD-004-F51` | DIFFICULTY_PRESENTATION_AUTHORITY_RISK | UI·animation이 난이도 시점·step을 소유 | DifficultyDirector 단독 권위·read-only presentation |
| `SX-AUD-004-F52` | FORECAST_DRIFT_LATE_WARNING_RISK | forecast와 commit이 어긋나 경고가 늦거나 틀림 | generation+revision 검증·committed readback·fallback |
| `SX-AUD-004-F53` | WARNING_SPAM_OCCLUSION_RISK | 반복 banner가 board를 가리고 판단 방해 | 2줄·reserved lane·cooldown·latest-only coalescing |
| `SX-AUD-004-F54` | ASSIST_PAUSE_RESTART_LIFECYCLE_RISK | assist·pause·restart·resume에서 stale/catch-up 발생 | authoritative pause·fresh forecast·generation reset·no wall-clock catch-up |
| `SX-AUD-004-F55` | ACCESSIBILITY_LOCALIZATION_PARITY_RISK | 색상·motion·짧은 문구 의존으로 정보 손실 | text+shape+fill·static Reduced Motion·140% localization 검증 |

현재 알려진 P0/P1 open finding은 없다. 제품 구현, runtime feature tests, Profile·reward·difficulty runtime, Android, localization stress, 경제 simulation, 사람 반응은 `NOT_STARTED / NOT_RUN`이다.

## 10/10 전수 전파 대상

- `기획서/20_시스템_콘텐츠/CORE_SYSTEMS.md`
- `기획서/40_표현/VISUAL_DIRECTION.md`
- `기획서/50_제작_검증/PLAYTEST_PLAN.md`
- `기획서/00_프로젝트_허브/EXECUTABLE_PROMPTS/CODEX_GOAL_VS_03.md`
- Decision Registry·Issue #6·Approval/Gate 문서

## 다음 후보

`SX-DEC-023` — 즉시 RESTART가 같은 map/seed를 재사용할지, 항상 새 seed를 만들지, 또는 `RESTART=같은 seed / NEW RUN=새 seed`로 분리할지.

상태: `NEXT_GRILL_ME · GMB-001 SLOT 7`.
