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
implementation_state: FINITE_CORE_PASS · PC_VERTICAL_SLICE_AUTOMATED_PASS · DEFAULT_PROJECT_PLAY_BOOT_PASS · WINDOWS_EXPORT_INTEGRITY_PASS
manual_gate_state: PC_LOCAL_RETEST_REQUIRED · WINDOWS_ARTIFACT_RUNTIME_NOT_RUN · ANDROID_NOT_RUN · HUMAN_NOT_RUN
cutover_state: BLOCKED
next_pc_gate: LOCAL_PROJECT_PLAY_RETEST → WINDOWS_RUNTIME_VISUAL_AUDIO_SMOKE
next_android_gate: ANDROID_DEVICE_SMOKE → FIVE_PERSON_COMPREHENSION
correct_sheet: 1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo
wrong_sheet: 19Ff... · DO_NOT_MODIFY
```

## Current Core Fun Authority

```text
선로 건설로 화물 조우 순서 설계
→ 수동/자동 적재로 LIFO 스택 구성
→ 분기 전환으로 역 방문 순서 실행
→ TOP 연속 동일 화물 하역
→ 제한 시간 안에 모든 배송 완료
→ 후속 재설계
```

## Current Decision Registry

| Decision ID | 분야 | 현재 결정 | 상태 |
|---|---|---|---|
| SX-DEC-027 | 제품 핵심 | 제한 시간 안에 모든 고정 화물을 배송하는 유한 수작업 퍼즐 | PASS |
| SX-DEC-028 | 건설 | 자유 선로 건설·비용·전액 환급·추천 비용 | PASS |
| SX-DEC-029 | 운행·판정 | 구조 검사·제한 시간·성공/실패·pause | PASS |
| SX-DEC-030 | 선로 | 직선·곡선·분기·교차 | PASS |
| SX-DEC-031 | 적재·LIFO | 수동 hold·auto toggle·무제한 stack·TOP 그룹 하역 | PASS |
| SX-DEC-032 | Combo | 하역 그룹과 최대 1초 표시 | PASS |
| SX-DEC-033 | 별·랭킹 | 신속·절약·점수 별과 leaderboard | NOT_STARTED |
| SX-DEC-034 | 캠페인 | tutorial·theme chapter | NOT_STARTED |
| SX-DEC-035 | 반복 도전 | 일일·주간 fixed-seed challenge | NOT_RUN |
| SX-DEC-036 | 공정성 | cosmetic-only, power progression·타인 route 공개 금지 | CURRENT |
| SX-DEC-037 | PC Vertical Slice | 마우스+키보드, touch 보존, 대표 1개 스테이지, F5 기본 Project Play, Windows Demo, Android validation 보존 | AUTOMATED_PASS · LOCAL_RETEST_REQUIRED |

## SX-DEC-037 Current Direction

- 기본 `project.godot`의 `run/main_scene`은 `res://game/main/main.tscn`이다.
- `game/main/main.tscn`은 `VerticalSliceDemo`를 직접 포함해 **Project Play(F5 / ▶)** 로 대표 데모를 부트한다.
- 사용자는 별도 Scene 선택이나 editor 설정 없이 Title → Briefing → BUILD → RUN → Result → Retry/Edit/Title을 진행해야 한다.
- `game/demo/vertical_slice_demo.tscn`은 개발·테스트용 독립 Scene으로 유지한다.
- 기존 finite rules와 validation Scene은 공용 `FiniteSliceSessionController`를 사용한다.
- `VS_DEMO_01@1`은 proof map과 독립된 대표 스테이지다.
- 마우스·키보드·touch가 같은 finite command path를 사용한다.
- Android Validation feature override·package ID·canonical APK evidence는 변경하지 않는다.

## Latest Automated Evidence

```yaml
pull_request: 83
feature_head: 8807cdbdd670a0cb67948e97f922c9bd9700e1a7
project_contract: 822 · PASS
godot_tests: 757 · PASS
godot_cases: 85
godot_assertions: 11284
godot_failures: 0
thin_adapter: 82 · PASS
asset_rights: 47 · PASS
windows_export: 40 · PASS
```

```text
PC AUTOMATED CORE: PASS
DEFAULT PROJECT PLAY BOOT: PASS · AUTOMATED
PC WINDOWS EXPORT·INTEGRITY: PASS
PC LOCAL PROJECT PLAY: FAIL · RETEST_REQUIRED
PC WINDOWS ARTIFACT RUNTIME: NOT_RUN
ANDROID DEVICE SMOKE: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN
PRODUCTION CUTOVER: BLOCKED
PR #83: DRAFT
```

## Manual Runtime Finding

사용자가 이전 로컬 커밋에서 타이틀 이후 보드만 표시되고 HUD·도구·조작 표면이 보이지 않는 문제를 확인했다.

```yaml
manual_finding: HUD_AND_INTERACTION_SURFACE_MISSING
status: FAIL · RETEST_REQUIRED
```

최신 브랜치에서는 HUD anchor·z-order, 기본 F5 bootstrap, gameplay/HUD/toolbar boot 테스트를 수정했다. 사용자가 `Fetch origin → Pull origin` 후 다시 F5로 실행하기 전에는 수동 PASS로 올리지 않는다.

## Canonical Android Evidence

```yaml
source_commit: 536911449018a3caf3511bc64e7bf1a66edf2016
workflow_run_id: 31011620357
apk_sha256: eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
package_id: com.alsdmlals4.switchyexpress.validation
```

PC 기본 진입점은 일반 제품 실행을 담당하고 Android validation feature override는 전용 launcher를 담당한다. 두 증거를 섞지 않는다.

## Open Gates

- PC local Project Play retest: `FAIL · RETEST_REQUIRED`
- Windows artifact runtime·visual·audio·physical input smoke: `NOT_RUN`
- Android landscape device smoke: `NOT_RUN`
- five-person comprehension: `NOT_RUN`
- production cutover: `BLOCKED`

## Preserved Decisions

- SX-DEC-001: 정식 제목 `Switchy Express: Cargo Puzzle`
- SX-DEC-008: LIFO와 TOP 연속 동일 종류 그룹 하역
- SX-DEC-011: 프리미엄 캐주얼 3D 카툰·토끼 기관사
- SX-DEC-012: Godot 4.7.1·GDScript·PC/Android 가로형
- SX-DEC-014: 한 역 도착의 연속 동일 화물 하역 수가 Combo
- SX-DEC-015: rear/TOP을 읽는 compact token 의미
- SX-DEC-019: cosmetic-only 공정성
- SX-DEC-023: 같은 조건 재도전과 immutable identity

## Historical Boundary

무한 생존, fuel, BOOST, capacity 8, cargo slowdown, pickup respawn, switch auto-reset은 현재 제품 권위가 아니다.

## Current Execution Authority

```text
PC: 최신 Branch Fetch/Pull → F5 local retest → Windows artifact smoke → PR #83 review
Android: canonical APK export PASS → Android device smoke → Five-person Comprehension
Both: 별도 production cutover review
```

수동 증거 전에는 해당 Gate를 PASS로 표시하지 않는다.
