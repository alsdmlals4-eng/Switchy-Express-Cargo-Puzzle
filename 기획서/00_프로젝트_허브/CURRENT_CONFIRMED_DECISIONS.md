# Current Confirmed Decisions

Last updated: `2026-08-05`

```yaml
current_product_baseline: FINITE_DELIVERY_PUZZLE_BASELINE
current_decision_batch: GMB-002
current_decisions: SX-DEC-027~036
current_execution_authority: FP-DOR-001 · EV-USER-021 · EV-USER-022
current_evidence: EV-FP-APK-001
current_audit: SX-AUD-019
canonical_export_source: 536911449018a3caf3511bc64e7bf1a66edf2016
planning_state: MERGED_AND_SYNCED
implementation_state: AUTOMATED_CORE_PASS · VALIDATION_PREP_PASS · APK_EXPORT_PASS · LEGACY_RUNTIME_DEFAULT
manual_gate_state: ANDROID_NOT_RUN · HUMAN_NOT_RUN
cutover_state: BLOCKED
next_gate: ANDROID_DEVICE_SMOKE → FIVE_PERSON_COMPREHENSION
sheet_state: SX-AUD-019_SYNC_PENDING
old_vs03_execution_order: REPLACED · HISTORICAL_EVIDENCE
```

## Current Core Fun Authority

```text
선로 건설로 화물 조우 순서 설계
→ 수동/자동 적재로 LIFO 스택 구성
→ 분기 전환으로 역 방문 순서 실행
→ TOP 연속 동일 화물 하역
→ 제한 시간 안에 모든 배송 완료
→ 시간·건설비·점수별 후속 재설계와 기록 경쟁
```

첫 Slice는 `A → B → A → A` 적재와 `2 → 1 → 1` 하역으로 A역 재방문 LIFO 핵심을 자동 증명했다. Combo 보상·별·랭킹·캠페인은 후속 package다.

## Current Authority Files

- `기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md`
- `기획서/50_제작_검증/GMB_002_APPROVAL_LEDGER.md`
- `docs/superpowers/specs/2026-08-04-finite-puzzle-definition-of-ready-design.md`
- `docs/superpowers/plans/2026-08-05-finite-puzzle-first-vertical-slice.md`
- `docs/superpowers/specs/2026-08-05-finite-validation-harness-design.md`
- `docs/superpowers/plans/2026-08-05-finite-validation-harness.md`
- `docs/superpowers/specs/2026-08-05-android-validation-apk-ci-design.md`
- `docs/superpowers/plans/2026-08-05-android-validation-apk-ci.md`
- `기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md`
- `기획서/50_제작_검증/FP_01_02_IMPLEMENTATION_AUDIT.md`
- `기획서/50_제작_검증/SX_AUD_018_VALIDATION_PREPARATION_AUDIT.md`
- `기획서/50_제작_검증/SX_AUD_019_ANDROID_APK_PIPELINE_PROBE.md`
- `기획서/00_프로젝트_허브/CANON_REPLACEMENT_REGISTER.md`

## Current Decision Registry

| Decision ID | 분야 | 현재 결정 | 상태 |
|---|---|---|---|
| SX-DEC-027 | 제품 핵심 | 제한 시간 안에 모든 고정 화물을 배송하는 유한 수작업 퍼즐 | CORE PASS · APK PASS |
| SX-DEC-028 | 건설 | 자유 선로 건설, 조각 비용, 시간 정지, 전액 환급, 추천 비용 | 핵심 PASS · ghost route 후속 |
| SX-DEC-029 | 운행·판정 | 구조 검사, 런 중 건설 금지, 제한 시간 실패, 마지막 하역 성공, 확인 pause | PASS |
| SX-DEC-030 | 선로 | 직선·곡선·분기·교차 기본, 성능·특수·지형 선로 후속 | 기본 4종 PASS |
| SX-DEC-031 | 적재·LIFO | 수동 hold·auto toggle, 무제한 stack, 정차 없는 적재, TOP 그룹 하역 | PASS |
| SX-DEC-032 | Combo | 하역 그룹을 Combo로 사용, 최대 1초 표시, 가속·점수 후속 | 그룹·표시 PASS |
| SX-DEC-033 | 별·랭킹 | 신속·절약·점수 별과 3종 leaderboard | NOT_STARTED |
| SX-DEC-034 | 캠페인 | 1~10 tutorial과 theme chapter·시험 | NOT_STARTED |
| SX-DEC-035 | 반복 도전 | 일일·주간 fixed-seed challenge | ONLINE NOT_RUN |
| SX-DEC-036 | 진행·공정성 | cosmetic-only, power progression·타인 route/replay 공개 금지 | 원칙 유지 |

## First Slice Evidence

### 자동 코어

```text
PR #55~#60 MERGED
main 3a4aeaa63561f78e6b1065c80bda9a64af220051
Project Contract #490 PASS
Godot Tests #451 PASS
60 cases · 10,382 assertions · 0 failures
```

### Validation 준비

```text
PR #62/#63 MERGED
Project Contract #508 PASS
Godot Tests #464 PASS
63 cases · 10,714 assertions · 0 failures
```

### Selector·APK workflow

```text
PR #65/#66/#69/#70/#71 MERGED
TDD RED/GREEN contracts PASS
canonical source 536911449018a3caf3511bc64e7bf1a66edf2016
```

### Canonical APK export

```yaml
workflow_run_id: 31011620357
workflow_run_attempt: 1
result: SUCCESS
tests: 65 cases · 10,792 assertions · 0 failures
artifact_id: 8932725351
artifact_name: switchy-express-validation-53691144
apk_size_bytes: 28771631
apk_sha256: eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
artifact_zip_sha256: 1802ca52dd90eb674f89b0a6e4678152d314c5644d135a84033388b4d3ee7193
attestation_id: 39044925
artifact_expiry: 2026-08-19T13:45:27Z
```

APK, `.sha256`, manifest, run source와 provenance가 일치해 `APK_EXPORT: PASS`로 승격한다.

## Open Manual Gates

- Android landscape device smoke: `NOT_RUN`
- five-person comprehension: `NOT_RUN`
- production default cutover: `BLOCKED`

두 수동 Gate는 동일 APK SHA-256 `eb49225a...759ea`로 수행한다. 새 APK가 생성되면 이전 기기·사람 증거를 새 hash에 자동 승계하지 않는다.

## Non-blocking Follow-ups

- F141: project icon 미지정 — production art Gate 전에 validation/product icon 지정
- F142: 일부 GitHub Action runtime 노후화 경고 — 별도 CI 유지보수 package에서 TDD 갱신

현재 export 생성·서명·artifact 증거에는 영향을 주지 않아 APK Gate를 차단하지 않는다.

## Preserved Decisions

- SX-DEC-001: 정식 제목 `Switchy Express: Cargo Puzzle`
- SX-DEC-008: LIFO와 TOP 연속 동일 종류 그룹 하역. capacity 8은 대체됨.
- SX-DEC-011: 프리미엄 캐주얼 3D 카툰·토끼 기관사
- SX-DEC-012: Godot 4.7.1·GDScript·Android·가로형
- SX-DEC-014: 한 역 도착의 연속 동일 화물 하역 수가 Combo
- SX-DEC-015: rear/TOP을 읽는 compact token 의미
- SX-DEC-019: cosmetic-only 공정성
- SX-DEC-023: 같은 조건 재도전과 immutable identity

## Superseded·Held Decisions

| 기존 결정 | 상태 | 대체 권위 |
|---|---|---|
| SX-DEC-002 무한 생존 | `[대체됨]` | SX-DEC-027 |
| SX-DEC-003 LOAD+분기+BOOST | `[부분 대체]` | SX-DEC-029/031; BOOST 폐기 |
| SX-DEC-004 완성형 rail | `[대체됨]` | SX-DEC-028/030 |
| SX-DEC-006 역 2개 고정 | `[대체됨]` | authored stage content |
| SX-DEC-007 pickup respawn | `[폐기]` | SX-DEC-031 |
| SX-DEC-008 capacity 8 | `[대체됨]` | SX-DEC-031 |
| SX-DEC-009 fuel/fuel-zero | `[폐기]` | SX-DEC-027/029 |
| SX-DEC-010 cargo slowdown·BOOST | `[폐기]` | SX-DEC-030/032 |
| SX-DEC-013 switch auto-reset | `[대체됨]` | persistent switch |
| SX-DEC-016 endless onboarding | `[대체됨]` | SX-DEC-034 |
| SX-DEC-017 fuel result | `[대체됨]` | 제한 시간 미배송 분석 |
| SX-DEC-022 timed pressure | `[폐기]` | SX-DEC-029 |
| SX-DEC-024 endless discovery | `[보류/재설계]` | campaign·challenge 선택 |
| SX-DEC-025~026 UGC | `[보류]` | production 재검토 |

## Legacy Implementation Boundary

`fuel`, `BOOST`, capacity 8, cargo slowdown, timed pressure, pickup respawn, switch auto-reset, endless score는 `[대체됨 · 역사 증거]`다. old 테스트는 finite PASS 수치에 합산하지 않으며, APK export·Android·HUMAN 완료 전까지 기본 진입점은 legacy다.

## Audit Registry

| Audit ID | 범위 | 상태 |
|---|---|---|
| SX-AUD-001~011 | 기존 endless | `[역사 증거]` |
| SX-AUD-012 | finite pivot | CLOSED |
| SX-AUD-013~016 | core·clock·identity·surface | PASS_WITH_NEXT_GATES |
| SX-AUD-017 | end-to-end·수동 Gate 준비 | PASS_WITH_PREREQUISITE_BLOCKERS |
| SX-AUD-018 | validation 준비 | PASS |
| SX-AUD-019 | selector·APK pipeline·canonical main export | APK_EXPORT_PASS · ANDROID/HUMAN_OPEN |

## Current Execution Authority

```text
GMB-002 MERGED
→ FP-DOR-001 APPROVED
→ FP-01/FP-02 AUTOMATED PASS
→ VALIDATION PREPARATION PASS
→ CANONICAL APK EXPORT PASS
→ ANDROID DEVICE SMOKE
→ FIVE-PERSON COMPREHENSION
→ production cutover review
```

Android·HUMAN 증거 전에는 finite를 product default 또는 제품 검증 완료로 표시하지 않는다. Correct Sheet는 `1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo`이며 wrong `19Ff...` Sheet는 변경 금지다.
