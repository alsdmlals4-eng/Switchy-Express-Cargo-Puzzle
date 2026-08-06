# Current Confirmed Decisions

Last updated: `2026-08-06`

```yaml
current_product_baseline: FINITE_DELIVERY_PUZZLE_BASELINE
current_decision_batch: GMB-002
current_product_decisions: SX-DEC-027~036
current_demo_decision: SX-DEC-037
current_execution_authority: FP-DOR-001 · EV-USER-021 · EV-USER-022 · EV-USER-023
current_android_evidence: EV-FP-APK-001
current_audit: SX-AUD-020
planning_state: APPROVED_AND_SYNCED
implementation_state: FINITE_CORE_PASS · PC_VERTICAL_SLICE_AUTOMATED_PASS · WINDOWS_EXPORT_INTEGRITY_PASS · LEGACY_RUNTIME_DEFAULT
manual_gate_state: WINDOWS_RUNTIME_NOT_RUN · ANDROID_NOT_RUN · HUMAN_NOT_RUN
cutover_state: BLOCKED
next_pc_gate: WINDOWS_RUNTIME_VISUAL_AUDIO_SMOKE
next_android_gate: ANDROID_DEVICE_SMOKE → FIVE_PERSON_COMPREHENSION
correct_sheet: 1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo
wrong_sheet: 19Ff... · DO_NOT_MODIFY
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

## Current Authority Files

- `기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md`
- `기획서/50_제작_검증/GMB_002_APPROVAL_LEDGER.md`
- `기획서/50_제작_검증/SX_DEC_037_PC_VERTICAL_SLICE_APPROVAL_LEDGER.md`
- `docs/superpowers/specs/2026-08-06-pc-vertical-slice-demo-design.md`
- `docs/superpowers/plans/2026-08-06-pc-vertical-slice-demo.md`
- `기획서/50_제작_검증/SX_AUD_020_PC_VERTICAL_SLICE_IMPLEMENTATION_AUDIT.md`
- `기획서/50_제작_검증/SX_AUD_019_ANDROID_APK_PIPELINE_PROBE.md`
- `기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md`
- `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md`

## Current Decision Registry

| Decision ID | 분야 | 현재 결정 | 상태 |
|---|---|---|---|
| SX-DEC-027 | 제품 핵심 | 제한 시간 안에 모든 고정 화물을 배송하는 유한 수작업 퍼즐 | CORE PASS · APK PASS |
| SX-DEC-028 | 건설 | 자유 선로 건설, 조각 비용, 시간 정지, 전액 환급, 추천 비용 | PASS · PC ghost 추가 |
| SX-DEC-029 | 운행·판정 | 구조 검사, 런 중 건설 금지, 제한 시간 실패, 마지막 하역 성공, pause | PASS |
| SX-DEC-030 | 선로 | 직선·곡선·분기·교차 기본 | 기본 4종 PASS |
| SX-DEC-031 | 적재·LIFO | 수동 hold·auto toggle, 무제한 stack, TOP 그룹 하역 | PASS |
| SX-DEC-032 | Combo | 하역 그룹과 최대 1초 표시, 가속·점수 후속 | 그룹·표시 PASS |
| SX-DEC-033 | 별·랭킹 | 신속·절약·점수 별과 3종 leaderboard | NOT_STARTED |
| SX-DEC-034 | 캠페인 | 1~10 tutorial과 theme chapter·시험 | NOT_STARTED |
| SX-DEC-035 | 반복 도전 | 일일·주간 fixed-seed challenge | ONLINE NOT_RUN |
| SX-DEC-036 | 진행·공정성 | cosmetic-only, power progression·타인 route 공개 금지 | 원칙 유지 |
| SX-DEC-037 | PC Vertical Slice | 마우스 중심+키보드, touch 보존, 대표 1개 스테이지, 별도 F6/Windows Demo, default/Android 불변 | AUTOMATED_AND_PACKAGE_PASS · MANUAL_RUNTIME_OPEN |

## SX-DEC-037 Implemented Direction

- `game/demo/vertical_slice_demo.tscn`은 별도 PC product shell이다.
- 기존 finite rules와 validation Scene은 공용 `FiniteSliceSessionController`를 사용한다.
- Title → Briefing → BUILD → RUN → Result → Retry/Edit/Title 흐름을 지원한다.
- `VS_DEMO_01@1`은 proof map과 독립된 대표 스테이지다.
- 마우스·키보드·touch가 같은 finite command path를 사용한다.
- 한국어 HUD, TOP, Theme, build ghost, responsive layout, procedural effects/audio를 포함한다.
- `project.godot` 기본 `run/main_scene`은 legacy로 유지한다.
- Android Validation preset·package ID·canonical APK evidence는 변경하지 않는다.

## SX-AUD-020 Evidence

```yaml
pull_request: 83
feature_head: 0f36ef9af5d37397e23272c40bb62c3599d2db37
project_contract_run: 31065293042
Godot_tests_run: 31065293026
Godot_cases: 85
Godot_assertions: 11258
Python_contracts: 56_passed · 1_skipped
windows_export_run: 31065293030
windows_artifact_id: 8953621440
windows_artifact_zip_sha256: 7c44092b3837d84d3f027fc1625aaccaa1543d5307a174eda37824b27889af9e
windows_exe_sha256: 1cb23cec5f4de7fa6c884cd61af3b5b3df52b7d0f82638aa36b241a1cfdc3244
windows_pck_sha256: 66ffec232a851d1858da6a5bc0b90ca3c3e4b3769dc472fe1e97a15c0a82c741
```

```text
PC AUTOMATED CORE: PASS
PC WINDOWS EXPORT·INTEGRITY: PASS
PC WINDOWS RUNTIME: NOT_RUN
ANDROID DEVICE SMOKE: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN
DEFAULT ENTRYPOINT: LEGACY
PRODUCTION CUTOVER: BLOCKED
```

## Canonical Android Evidence

```yaml
source_commit: 536911449018a3caf3511bc64e7bf1a66edf2016
workflow_run_id: 31011620357
artifact_id: 8932725351
apk_sha256: eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
artifact_zip_sha256: 1802ca52dd90eb674f89b0a6e4678152d314c5644d135a84033388b4d3ee7193
package_id: com.alsdmlals4.switchyexpress.validation
```

PC Demo export는 이 Android evidence를 대체하지 않는다.

## Open Manual Gates

- PC Windows runtime·visual·audio·physical input smoke: `NOT_RUN`
- Android landscape device smoke: `NOT_RUN`
- five-person comprehension: `NOT_RUN`
- production default cutover: `BLOCKED`

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

## Audit Registry

| Audit ID | 범위 | 상태 |
|---|---|---|
| SX-AUD-001~011 | 기존 endless | `[역사 증거]` |
| SX-AUD-012 | finite pivot | CLOSED |
| SX-AUD-013~016 | core·clock·identity·surface | PASS_WITH_NEXT_GATES |
| SX-AUD-017 | end-to-end·수동 Gate 준비 | PASS_WITH_PREREQUISITE_BLOCKERS |
| SX-AUD-018 | validation 준비 | PASS |
| SX-AUD-019 | selector·APK pipeline·canonical Android export | APK_EXPORT_PASS · ANDROID/HUMAN_OPEN |
| SX-AUD-020 | PC Vertical Slice implementation·Windows debug package | AUTOMATED_AND_PACKAGE_PASS · WINDOWS_RUNTIME_OPEN |

## Current Execution Authority

```text
PC: SX-DEC-037 → SX-AUD-020 → Windows runtime smoke → PR #83 merge review
Android: canonical APK export PASS → Android device smoke → Five-person Comprehension
Both: 별도 production cutover review
```

Android·HUMAN 또는 Windows runtime 증거 전에는 해당 수동 Gate를 PASS로 표시하지 않는다.
