# GMB-001 Grill Me Decision Ledger

```yaml
batch_id: GMB-001
baseline_main: 993c3ed1aaee172be52a8a8899685b419f7f6d97
branch: batch/gmb-001
draft_pr: 29
batch_size: 10
approved_count: 2/10
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
| 3 | — | — | — | OPEN | — |
| 4 | — | — | — | OPEN | — |
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

현재 P0/P1 open finding은 없다. 실제 카메라 배율·전환 속도·Android framing·터치 좌표·사람 반응은 `TEST_REQUIRED / HUMAN_NOT_RUN`이다.

## 다음 후보

`SX-DEC-019` — run 밖의 영구 진행을 순수 기록 경쟁, cosmetic-only 수집, 기능 성장 중 어떤 정책으로 제한할지.

상태: `NEXT_GRILL_ME · GMB-001 SLOT 3`.
