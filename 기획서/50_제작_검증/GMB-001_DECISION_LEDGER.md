# GMB-001 Grill Me Decision Ledger

```yaml
batch_id: GMB-001
baseline_main: 993c3ed1aaee172be52a8a8899685b419f7f6d97
branch: batch/gmb-001
draft_pr: PENDING_CREATION
batch_size: 10
approved_count: 1/10
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
| 2 | — | — | — | OPEN | — |
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

## Adversarial Findings

| Finding ID | 유형 | 문제 | 처리 |
|---|---|---|---|
| `SX-AUD-004-F26` | CAUSALITY_OVERCLAIM_RISK | 상관관계 지표를 단일 실패 원인으로 단정할 위험 | 우세 score·margin 기준 미달 시 neutral fallback |
| `SX-AUD-004-F27` | PLAYER_BLAME_RISK | 결과 문구가 플레이어 비난으로 느껴질 위험 | 관측 상태+행동 제안 문장 원칙, 5명+ human validation |
| `SX-AUD-004-F28` | AUTHORITY_RISK | ResultPanel이 기록·종료·재시작 또는 원인 계산을 소유할 위험 | RunSummary→Analyzer→ViewModel→View 단방향 계약 |
| `SX-AUD-004-F29` | EVIDENCE_CONTAMINATION | assisted first run이 일반 원인·밸런스 분포를 오염할 위험 | `assisted_first_run` 분석 분리 |
| `SX-AUD-004-F30` | RESULT_DENSITY_RISK | 여러 원인·그래프가 모바일 재시작 흐름을 늦출 위험 | 기본 cause 1+action 1, optional details만 secondary |

현재 P0/P1 open finding은 없다. 실제 임계값·문구 품질·Android 가독성은 `TEST_REQUIRED / HUMAN_NOT_RUN`이다.

## 다음 후보

`SX-DEC-018` — 실제 플레이 화면 카메라가 열차 중심 추적, 고정 전체 맵, 상황형 혼합 중 어떤 정책을 사용할지.

상태: `NEXT_GRILL_ME · GMB-001 SLOT 2`.
