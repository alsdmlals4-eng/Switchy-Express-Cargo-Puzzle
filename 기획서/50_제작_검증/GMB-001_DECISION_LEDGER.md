# GMB-001 Grill Me Decision Ledger

```yaml
batch_id: GMB-001
baseline_main: 993c3ed1aaee172be52a8a8899685b419f7f6d97
branch: batch/gmb-001
draft_pr: 29
batch_size: 10
approved_count: 4/10
status: IN_PROGRESS · APPROVED_PENDING_BATCH_MERGE
canonical_main_sync: NOT_YET_MERGED
sheet_state: APPROVED_PENDING_BATCH_MERGE
codex_state: CODEX_NOT_READY
```

## 운영 경계

- 이 원장은 `SX-OPS-001`에 따른 첫 정규 Grill Me 배치의 branch authority다.
- 승인된 Decision은 이 branch와 Draft PR, 올바른 Google Sheet에 즉시 기록한다.
- 10/10 전에는 main에 병합하거나 `SYNCED`로 표시하지 않는다.
- 10번째 승인 후 새 Decision을 멈추고 GitHub·PR·Issue·정본·Registry·Sheet 12탭 적대적 전수감사를 수행한다.
- 제품 코드·Scene·Resource·asset은 별도 구현 승인과 `READY_FOR_BUILD` 전에는 변경하지 않는다.

## Batch Inventory

| Slot | Decision | Evidence | 요약 | 상태 | 책임 정본 |
|---:|---|---|---|---|---|
| 1 | `SX-DEC-017` | `EV-USER-006` | 결과 화면에 검증된 실패 원인 1개와 다음 행동 1개를 표시하고, 불확실하면 중립 fallback 사용 | APPROVED_PENDING_BATCH_MERGE | `docs/superpowers/specs/2026-08-02-result-failure-feedback-design.md` |
| 2 | `SX-DEC-018` | `EV-USER-007` | 최초 준비 화면은 기관차 주변을 약간 확대하고 START 뒤 run 시작 전에 전체 맵으로 복귀하며 실제 운행은 고정 전체 맵 유지 | APPROVED_PENDING_BATCH_MERGE | `docs/superpowers/specs/2026-08-02-preparation-zoom-full-map-camera-design.md` |
| 3 | `SX-DEC-019` | `EV-USER-008` | 영구 진행은 표준 개인 기록과 성능 없는 꾸미기 해금·장착만 허용하며 기능 성장은 금지 | APPROVED_PENDING_BATCH_MERGE | `docs/superpowers/specs/2026-08-02-records-cosmetic-only-progression-design.md` |
| 4 | `SX-DEC-020` | `EV-USER-009` | 목표형 꾸미기는 목표 달성 또는 재화 구매로 해금하고 일부 꾸미기는 재화 전용으로 배치 | APPROVED_PENDING_BATCH_MERGE | `docs/superpowers/specs/2026-08-02-goal-or-currency-cosmetic-unlocks-design.md` |
| 5 | — | — | — | OPEN | — |
| 6 | — | — | — | OPEN | — |
| 7 | — | — | — | OPEN | — |
| 8 | — | — | — | OPEN | — |
| 9 | — | — | — | OPEN | — |
| 10 | — | — | — | OPEN | — |

## SX-DEC-017 — 결과 화면 실패 학습

### 사용자 승인

사용자는 2026-08-02 Grill Me에서 권장안 A를 승인했다.

### 결정

```text
연료 0 결과 화면은 기본 기록을 유지한 채,
실제 run telemetry로 뒷받침되는 핵심 실패 원인 1개와
다음 판에서 실행할 행동 1개를 표시한다.
원인 신뢰도가 부족하거나 후보가 비슷하면 중립 fallback을 사용한다.
```

### Evidence

```yaml
evidence_id: EV-USER-006
evidence_type: CONFIRMED_USER_DECISION
source: 2026-08-02 conversation · recommended option A approved
status: RECORDED_IN_BATCH_BRANCH
```

### 파생 계약

- 결과 핵심 기록: score, survival time, max_combo, new record.
- insight card: cause 1줄 + action 1줄.
- RESTART는 primary action이다.
- 원인 판정은 immutable RunSummary를 읽는 deterministic analyzer가 담당한다.
- UI·animation은 원인 계산·저장·게임오버·재시작 권위가 아니다.
- 후보가 약하거나 동률이면 `NEUTRAL` fallback.
- 문구는 비난 대신 관측 상태와 다음 행동을 분리한다.
- first-run assist 판은 `assisted_first_run`으로 일반 밸런스 증거와 분리한다.
- 원인 threshold는 `TEST_VALUE`이며 사용자 확정 영구 수치가 아니다.

### 권장 1차 cause code

```text
BOOST_OVERUSE
HEAVY_LOAD_DELAY
DELIVERY_GAP
ROUTE_MISMATCH_LOOP
NEUTRAL
```

### 구현·검증 상태

```yaml
planning_spec: APPROVED
implementation: NOT_STARTED
automated_tests: NOT_RUN
android: NOT_RUN
human_validation: NOT_RUN
```

### 책임 문서

- 설계: `docs/superpowers/specs/2026-08-02-result-failure-feedback-design.md`
- TDD 계획: `docs/superpowers/plans/2026-08-02-result-failure-feedback.md`
- 구현 목표 소비자: `기획서/00_프로젝트_허브/EXECUTABLE_PROMPTS/CODEX_GOAL_VS_03.md` — 10/10 사전감사에서 최종 전파
- 표현 소비자: `기획서/40_표현/VISUAL_DIRECTION.md` — 10/10 사전감사에서 최종 전파
- 검증 소비자: `기획서/50_제작_검증/PLAYTEST_PLAN.md` — 10/10 사전감사에서 최종 전파

## SX-DEC-018 — 준비 확대 + 실제 운행 전체 맵 고정

### 사용자 승인

사용자는 2026-08-02 Grill Me에서 A안인 전체 맵 고정을 선택하고, 준비 단계·게임 시작 시에는 조금 더 확대해서 보도록 보정했다.

### 결정

```text
최초 PREP/READY 화면에서는 기관차와 출발 주변을 약간 확대한다.
START 입력 뒤 simulation·fuel·difficulty·spawn progression을 시작하기 전에
카메라를 전체 15×10 맵 framing으로 복귀시킨다.
FULL_MAP_READY 뒤 실제 운행을 시작하며 ACTIVE_RUN 동안 카메라는 고정 전체 맵을 유지한다.
```

### Evidence

```yaml
evidence_id: EV-USER-007
evidence_type: CONFIRMED_USER_DECISION
source: 2026-08-02 conversation · option A refined with preparation/start zoom
status: RECORDED_IN_BATCH_BRANCH
```

### 파생 계약

- PREP magnification 권장 baseline은 full-map 대비 `1.20× TEST_VALUE`다.
- START→FULL_MAP transition 권장 baseline은 `0.75초 TEST_VALUE`다.
- 전환 중 fuel·timer·difficulty·spawn·board input·onboarding assist timer는 진행하지 않는다.
- FULL_MAP_READY와 run start는 preparation generation마다 정확히 한 번만 확정한다.
- 실제 운행 중 열차 추적·자동 줌·화면 회전·상황형 확대 창은 사용하지 않는다.
- FIRST_LOAD·FIRST_SWITCH 온보딩은 카메라 이동 대신 외곽선·아이콘·경로 강조를 사용한다.
- Reduced Motion은 즉시 전체 맵 cut을 사용한다.
- 즉시 RESTART는 재도전 속도를 위해 준비 확대를 반복하지 않고 전체 맵으로 복귀하는 것을 권장 기본값으로 둔다.
- Camera2D·Tween·animation은 run·점수·연료·분기·spawn·온보딩 권위가 아니다.

### 구현·검증 상태

```yaml
planning_spec: APPROVED
implementation: NOT_STARTED
automated_tests: NOT_RUN
android: NOT_RUN
human_validation: NOT_RUN
```

### 책임 문서

- 설계: `docs/superpowers/specs/2026-08-02-preparation-zoom-full-map-camera-design.md`
- TDD 계획: `docs/superpowers/plans/2026-08-02-preparation-zoom-full-map-camera.md`
- 구현 목표 소비자: `기획서/00_프로젝트_허브/EXECUTABLE_PROMPTS/CODEX_GOAL_VS_03.md` — 10/10 사전감사에서 최종 전파
- 표현 소비자: `기획서/40_표현/VISUAL_DIRECTION.md` — 10/10 사전감사에서 최종 전파
- 온보딩 소비자: `docs/superpowers/specs/2026-08-02-first-session-contextual-onboarding-design.md` — 10/10 사전감사에서 최종 전파
- 검증 소비자: `기획서/50_제작_검증/PLAYTEST_PLAN.md` — 10/10 사전감사에서 최종 전파

## SX-DEC-019 — 표준 기록 + cosmetic-only 영구 진행

### 사용자 승인

사용자는 2026-08-02 Grill Me에서 A안의 순수 기록 경쟁과 B안의 성능 없는 꾸미기 수집을 결합한 `A+B`를 승인했다.

### 결정

```text
run 밖 영구 진행은 표준 개인 기록과 꾸미기 해금·장착으로 제한한다.
모든 표준 run은 같은 속도·연료·적재·점수·BOOST·맵·충돌 규칙을 사용한다.
꾸미기는 외형·소리·연출만 변경하며 어떤 gameplay 수치와 기록 자격도 변경하지 않는다.
first-run assist 판은 표준 경쟁 기록을 덮어쓰지 않는다.
```

### Evidence

```yaml
evidence_id: EV-USER-008
evidence_type: CONFIRMED_USER_DECISION
source: 2026-08-02 conversation · hybrid A+B approved
status: RECORDED_IN_BATCH_BRANCH
```

### 파생 계약

- 표준 기록: `best_score`, `longest_survival_seconds`, `best_max_combo`.
- 최소 권위는 로컬 개인 기록이며 온라인 리더보드는 이번 범위가 아니다.
- assisted first run, ruleset mismatch, integrity invalid run은 표준 기록 비적격이다.
- cosmetic category는 기관차, 기관사 의상, 역·맵 테마, 기적음·배기, cargo token 스킨으로 확장 가능하다.
- CosmeticDefinition에는 gameplay modifier field를 두지 않는다.
- cosmetic 장착 전후 speed·fuel·score·capacity·collision·footprint·seed·record eligibility는 동일해야 한다.
- token 스킨은 색상+모양 의미와 rear/HUD parity를 유지한다.
- 테마·파티클·기적음은 P0/P1 시각·오디오 신호를 가리지 않는다.
- 누락·삭제·호환 불가 cosmetic ID는 category 기본값으로 fallback한다.
- Vertical Slice는 기록 저장과 대표 기관차 스킨 1종만 검증하며 상점·통화·시즌은 만들지 않는다.
- 꾸미기 획득 방식·가격·희귀도·유료 판매·광고 보상은 아직 미확정이다.

### 구현·검증 상태

```yaml
planning_spec: APPROVED
implementation: NOT_STARTED
automated_tests: NOT_RUN
android: NOT_RUN
human_validation: NOT_RUN
```

### 책임 문서

- 설계: `docs/superpowers/specs/2026-08-02-records-cosmetic-only-progression-design.md`
- TDD 계획: `docs/superpowers/plans/2026-08-02-records-cosmetic-only-progression.md`
- 시스템 소비자: `기획서/20_시스템_콘텐츠/CORE_SYSTEMS.md` — 10/10 사전감사에서 최종 전파
- 표현 소비자: `기획서/40_표현/VISUAL_DIRECTION.md` — 10/10 사전감사에서 최종 전파
- 구현 목표 소비자: `기획서/00_프로젝트_허브/EXECUTABLE_PROMPTS/CODEX_GOAL_VS_03.md` — 10/10 사전감사에서 최종 전파
- 검증 소비자: `기획서/50_제작_검증/PLAYTEST_PLAN.md` — 10/10 사전감사에서 최종 전파

## SX-DEC-020 — 목표 또는 재화 해금 + 재화 전용 배치

### 사용자 승인

사용자는 2026-08-02 Grill Me에서 A안과 C안을 결합해, 목표 달성 시 해금되지만 목표를 달성하지 않아도 재화로 대체 해금할 수 있게 하고 재화로만 해금 가능한 꾸미기도 배치하도록 승인했다.

### 결정

```text
꾸미기 해금 유형은 DEFAULT, DUAL_PATH, CURRENCY_ONLY로 분리한다.
DUAL_PATH 꾸미기는 목표 달성 또는 꾸미기 전용 재화 구매 중 하나로 해금한다.
CURRENCY_ONLY 꾸미기는 목표 경로 없이 재화 구매로만 해금한다.
재화 구매는 목표 완료·업적 표식을 대신하지 않으며,
구매 뒤 실제 목표를 달성하면 중복 소유 대신 1회 대체 보상을 지급한다.
```

### Evidence

```yaml
evidence_id: EV-USER-009
evidence_type: CONFIRMED_USER_DECISION
source: 2026-08-02 conversation · hybrid A+C with currency-only placement approved
status: RECORDED_IN_BATCH_BRANCH
```

### 파생 계약

- `GOAL_ONLY` 유형은 두지 않는다. 목표형 꾸미기에도 재화 대체 경로를 제공한다.
- DEFAULT는 항상 보유하며 가격·목표가 없다.
- DUAL_PATH는 non-empty goal ID와 양수 가격을 가진다.
- CURRENCY_ONLY는 goal ID가 없고 양수 가격을 가진다.
- 구매로 해금해도 목표 진행·완료 상태는 변경하지 않는다.
- 구매 후 목표 달성 시 목표 완료 기록은 남기고, 소유권 대신 bounded 1회 compensation을 지급한다.
- compensation은 item 가격 이하 `TEST_VALUE`다.
- goal evidence는 completed, non-assisted, current ruleset, integrity VALID run만 사용한다.
- 재화 차감과 해금은 동일 transaction에서 atomic·idempotent하게 처리한다.
- 동일 transaction/event를 재처리해도 추가 차감·진행·보상이 없다.
- 재화 전용 꾸미기는 성능·충돌·정보 가독성 우위를 제공하지 않는다.
- 실제 화폐·광고·시즌·loot box·기간 한정 FOMO는 별도 승인 전까지 금지한다.
- 일반 run 재화 획득 공식은 `SX-DEC-021`에서 별도 확정한다.
- 가격·compensation·대표 목표 threshold는 모두 `TEST_VALUE`다.

### Vertical Slice 대표 배치

```text
locomotive.default         → DEFAULT
locomotive.goal_sample     → DUAL_PATH
locomotive.currency_sample → CURRENCY_ONLY
```

대표 ID·가격·목표는 구현 fixture이며 최종 콘텐츠·경제 승인값이 아니다.

### 구현·검증 상태

```yaml
planning_spec: APPROVED
implementation: NOT_STARTED
automated_tests: NOT_RUN
android: NOT_RUN
human_validation: NOT_RUN
```

### 책임 문서

- 설계: `docs/superpowers/specs/2026-08-02-goal-or-currency-cosmetic-unlocks-design.md`
- TDD 계획: `docs/superpowers/plans/2026-08-02-goal-or-currency-cosmetic-unlocks.md`
- 기반 설계: `docs/superpowers/specs/2026-08-02-records-cosmetic-only-progression-design.md`
- 시스템 소비자: `기획서/20_시스템_콘텐츠/CORE_SYSTEMS.md` — 10/10 사전감사에서 최종 전파
- 표현 소비자: `기획서/40_표현/VISUAL_DIRECTION.md` — 10/10 사전감사에서 최종 전파
- 구현 목표 소비자: `기획서/00_프로젝트_허브/EXECUTABLE_PROMPTS/CODEX_GOAL_VS_03.md` — 10/10 사전감사에서 최종 전파
- 검증 소비자: `기획서/50_제작_검증/PLAYTEST_PLAN.md` — 10/10 사전감사에서 최종 전파

## Adversarial Findings

| Finding ID | 유형 | 문제 | 처리 |
|---|---|---|---|
| `SX-AUD-004-F26` | CAUSALITY_OVERCLAIM_RISK | 상관관계 지표를 단일 실패 원인으로 단정할 위험 | 우세 score·margin 기준 미달 시 neutral fallback |
| `SX-AUD-004-F27` | PLAYER_BLAME_RISK | 결과 문구가 플레이어 비난으로 느껴질 위험 | 관측 상태+행동 제안 문장 원칙, 5명+ human validation |
| `SX-AUD-004-F28` | AUTHORITY_RISK | ResultPanel이 기록·종료·재시작 또는 원인 계산을 소유할 위험 | RunSummary→Analyzer→ViewModel→View 단방향 계약 |
| `SX-AUD-004-F29` | EVIDENCE_CONTAMINATION | assisted first run이 일반 원인·밸런스 분포를 오염할 위험 | `assisted_first_run` 분석 분리 |
| `SX-AUD-004-F30` | RESULT_DENSITY_RISK | 여러 원인·그래프가 모바일 재시작 흐름을 늦출 위험 | 기본 cause 1+action 1, optional details만 secondary |
| `SX-AUD-004-F31` | FAIRNESS_RISK | 전체 맵 전환 중 fuel·timer·spawn이 진행되면 첫 선택 전에 손해가 발생 | FULL_MAP_READY 전 모든 run progression 정지 |
| `SX-AUD-004-F32` | ORIENTATION_RISK | 준비 확대가 과하면 첫 pickup·출발 경로·가까운 분기 관계를 숨김 | 1.15×~1.25× TEST_VALUE와 필수 포함 요소 검증 |
| `SX-AUD-004-F33` | INPUT_MAPPING_RISK | zoom transition 중 board tap이 잘못된 world target으로 변환될 위험 | transition 중 board input lock, FULL_MAP 후 좌표 parity 테스트 |
| `SX-AUD-004-F34` | RETRY_FRICTION_MOTION_RISK | 매 재시작마다 줌 연출을 반복하면 재도전 속도 저하·멀미 가능 | 즉시 RESTART는 full-map direct 기본, Reduced Motion 즉시 cut |
| `SX-AUD-004-F35` | INTERRUPTION_AUTHORITY_RISK | Tween 완료를 유일한 시작 조건으로 사용하면 suspend·skip·오류에서 deadlock | generation-safe idempotent state와 synchronous full-map fallback |
| `SX-AUD-004-F36` | HIDDEN_POWER_LEAK_RISK | cosmetic metadata나 Profile이 숨은 speed·fuel·score modifier를 제공할 위험 | modifier field 금지와 gameplay parity 자동 테스트 |
| `SX-AUD-004-F37` | READABILITY_COLLISION_RISK | 스킨·테마·파티클이 collision·경로·station·token 의미를 바꿀 위험 | collision/footprint 불변과 Android 비교 캡처 |
| `SX-AUD-004-F38` | ASSISTED_RECORD_CONTAMINATION | first-run assist 기록이 표준 최고 기록을 덮어쓸 위험 | RecordEligibilityPolicy에서 assisted run 제외 |
| `SX-AUD-004-F39` | IDLE_GRIND_EXPLOIT_RISK | 무조작 시간·중복 종료 event가 cosmetic 파밍 수단이 될 위험 | 유효 run 근거와 idempotent unlock 계약 |
| `SX-AUD-004-F40` | SAVE_MIGRATION_LOCKOUT_RISK | 삭제 cosmetic·save 손상으로 장착 UI나 게임 시작이 막힐 위험 | default cosmetic fallback과 field-level partial recovery |
| `SX-AUD-004-F41` | ACHIEVEMENT_VALUE_EROSION_RISK | 재화 구매가 목표 달성 의미까지 대체할 위험 | ownership과 goal completion·provenance 분리 |
| `SX-AUD-004-F42` | DOUBLE_DEBIT_REWARD_RISK | 중복 event·save 재시도로 재화가 여러 번 차감되거나 보상이 중복될 위험 | transaction ID와 atomic idempotent 처리 |
| `SX-AUD-004-F43` | CURRENCY_ONLY_POWER_FOMO_RISK | 재화 전용 item이 성능 우위·실제 화폐·기간 한정으로 오해될 위험 | cosmetic parity·영구 catalog·별도 승인 경계 |
| `SX-AUD-004-F44` | ASSISTED_GOAL_FARM_RISK | first-run assist·debug·무결성 손상 run으로 목표를 쉽게 완료할 위험 | GoalEligibilityPolicy에서 제외 |
| `SX-AUD-004-F45` | ECONOMY_PACING_RISK | 가격과 획득량 불일치로 무의미한 파밍 또는 즉시 고갈이 발생할 위험 | 가격을 TEST_VALUE로 두고 재화 획득 정책을 다음 Decision으로 분리 |

현재 P0/P1 open finding은 없다. 제품 구현, 일반 run 재화 획득, 가격 튜닝, 대표 자산, Profile runtime, Android 가독성, 사람 반응은 `NOT_STARTED / NOT_DECIDED / NOT_RUN`이다.

## 다음 후보

`SX-DEC-021` — 꾸미기 전용 재화를 의미 있는 run 기본 보상, 성과 비례 보너스, 또는 bounded 혼합 방식 중 어떤 구조로 획득할지.

상태: `NEXT_GRILL_ME · GMB-001 SLOT 5`.
