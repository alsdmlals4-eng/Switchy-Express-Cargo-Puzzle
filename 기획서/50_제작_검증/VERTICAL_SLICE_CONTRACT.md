# Finite Delivery First Vertical Slice Contract

```yaml
status: FIRST_SLICE_CONTRACT_CURRENT · HISTORICAL_AUTOMATED_PACKAGE_EVIDENCE_PRESERVED
current_execution_state_owner: CURRENT_CONFIRMED_DECISIONS + ACTIVE_CONTEXT
current_runtime_semantic_state: SX-DEC-055 · SPEC/DoR_APPROVED · USER_DEFERRED_AFTER_DOR · IMPLEMENTATION_NOT_STARTED
historical_snapshot_status: PC_AUTOMATED_AND_PACKAGE_PASS · LOCAL_PROJECT_PLAY_RETEST_REQUIRED · ANDROID_APK_EXPORT_PASS
product_authority: GMB-002 · SX-DEC-027~036
pc_demo_authority: SX-DEC-037 · EV-USER-023
historical_first_slice_audits: SX-AUD-019 · SX-AUD-020
historical_latest_verified_commit: 8807cdbdd670a0cb67948e97f922c9bd9700e1a7
default_entrypoint: PRODUCT_VERTICAL_SLICE_BOOTSTRAP
full_pc_local_flow: NOT_CLOSED · RETEST_REQUIRED
windows_artifact_runtime: NOT_RUN
android_device_smoke: NOT_RUN
human_comprehension: NOT_RUN
cutover_status: BLOCKED_DEFERRED
```

이 문서는 첫 Vertical Slice의 제품·수동 검증 계약과 역사 증거를 책임진다. **현재 프로젝트 실행 순서·최신 main·열린 PR·SX-DEC-055 상태는 `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`와 `ACTIVE_CONTEXT.md`를 우선한다.** 아래 저장된 commit/run/PR 값은 당시 증거이며 현재 default branch HEAD를 고정하지 않는다.

## 1. 목적

이 계약은 유한 배송 퍼즐 코어, PC 대표 Vertical Slice, 기본 Project Play 진입점, Windows debug package, Android validation package의 경계를 정의한다. 자동 테스트, export 생성, 실제 로컬 실행, 실제 기기 실행, 사용자 이해도와 production cutover는 서로 다른 Gate다.

## 2. Finite Product Contract

### BUILD

- authored `FiniteMapDefinition` schema v2
- 직선·곡선·분기·교차 설치·회전·교체·철거·초기화
- 조각별 비용과 BUILD 철거 전액 환급
- 시작 연결·역·화물 도달성·dangling edge·trap 구조 검사
- PASS 뒤 배치·비용·graph 봉인

### RUN

- 자동 운행
- manual LOAD hold·auto-load toggle
- unlimited LIFO stack과 고정 화물
- TOP 연속 동일 화물 그룹 하역
- 제한 시간·pause·success/failure
- same-layout fresh-runtime retry
- map·solution·attempt identity 분리

Legacy fuel·BOOST·capacity 8·pickup respawn·endless score는 current contract가 아니다.

## 3. 기본 Project Play Contract

```text
project.godot
→ application/run/main_scene = res://game/main/main.tscn
→ Main/VerticalSliceDemo
→ Title → Briefing → BUILD → RUN → Result
→ Retry same layout · Edit layout · Title
```

- 사용자 기본 실행: `Project Play(F5 / ▶)`
- 별도 Scene 선택: 불필요
- Project Settings 수동 변경: 불필요
- 입력 모드·플러그인·feature flag 수동 설정: 불필요
- 기대 첫 화면: `Switchy Express` 타이틀
- 실제 gameplay surface: board + 상단 상태 + 하단 BUILD/RUN 도구 + TOP panel

`res://game/demo/vertical_slice_demo.tscn`은 개발·테스트용 독립 Scene으로 유지하지만 최종 사용자 검수 경로가 아니다.

## 4. PC Vertical Slice Contract

### Flow

- Title → Briefing → BUILD → RUN → Result
- Retry same layout · Edit layout · Title
- 대표 성공·실패 경로

### Presentation·input

- mouse-first + keyboard shortcuts + touch command path
- Korean HUD
- 색상+형상+텍스트 cargo/station 표현
- LIFO TOP 중복 표현
- build ghost·hover·selection·problem cells·train·track·switch
- Shell 단일 Pause/Result overlay
- 1280×720·1600×900·1920×1080 responsive contract
- 최소 48px 조작 영역
- project-owned Theme·Tween·procedural audio
- UI·effects·audio는 domain result 비권위

### Content

- map: `res://data/maps/vs_demo_01.json`
- identity: `VS_DEMO_01@1`
- representative stage 1개
- 서로 다른 successful solution 2개
- `fp_core_proof_01.json` 불변

## 5. 역사적 Automated Evidence Snapshot

아래 표는 첫 Vertical Slice 제작 당시 자동화·package 증거를 보존한다. 최신 branch exact-head 검증이나 현재 SX-DEC-055 runtime POC 구현 증거가 아니다.

| Gate | 상태 | 증거 |
|---|---|---|
| FINITE AUTOMATED CORE | PASS | historical regression snapshot |
| DEFAULT PROJECT PLAY BOOT | PASS · AUTOMATED | `Main/VerticalSliceDemo`, TITLE→BRIEFING→GAMEPLAY, HUD/tool visible |
| PC VERTICAL SLICE AUTOMATED | PASS | Godot Tests #757 · `85 cases · 11,284 assertions` |
| PROJECT CONTRACT | PASS | #822 |
| THIN ADAPTER | PASS | #82 |
| ASSET RIGHTS | PASS | #47 |
| WINDOWS DEBUG EXPORT | PASS | #40 |
| PC LOCAL PROJECT PLAY | HISTORICAL FAIL · RETEST_REQUIRED | user observed missing HUD/input on earlier local commit |
| WINDOWS ARTIFACT RUNTIME | NOT_RUN | actual Windows execution required |
| ANDROID APK EXPORT | PASS | canonical Android packaging evidence |
| ANDROID DEVICE | NOT_RUN | physical landscape device required |
| HUMAN | NOT_RUN | first-contact 5명 |
| PRODUCTION CUTOVER | BLOCKED | manual Gates and separate approval required |

## 6. Historical Runtime Failure and Fix Evidence

당시 사용자 관찰:

```yaml
finding: HUD_AND_INTERACTION_SURFACE_MISSING_AFTER_BUILD_ENTRY
status: HISTORICAL_FAIL · RETEST_REQUIRED_FOR_FULL_PC_FLOW
```

당시 수정:

- HUD full anchors
- HUD `z_index=10`
- `game/main/main.tscn` product bootstrap
- default Play TITLE→BRIEFING→GAMEPLAY·HUD·toolbar regression
- 기존 성공·실패·Retry/Edit E2E 유지
- CI test timeout 60초

이 과거 failure는 현재 feature-scoped F5 PASS를 무효화하지 않는다. 반대로 feature-scoped PASS만으로 full PC local flow를 PASS로 승격하지도 않는다. 전체 로컬 흐름 검증은 `DEVELOPMENT_GATES.md`의 PC5가 소유한다.

## 7. Canonical Android Contract

```yaml
source_commit: 536911449018a3caf3511bc64e7bf1a66edf2016
apk_sha256: eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
package_id: com.alsdmlals4.switchyexpress.validation
```

Android preset은 `validation_harness` feature override로 전용 launcher를 사용한다. 일반 PC Project Play 변경은 이 launcher·package ID·APK 증거를 대체하지 않는다. APK export/hash PASS는 Android physical device PASS가 아니다.

## 8. Current User Handoff Contract

```yaml
repository: alsdmlals4-eng/Switchy-Express-Cargo-Puzzle
branch: main
current_main_source: LIVE_GITHUB_DEFAULT_BRANCH
historical_minimum_verified_product_commit: 8807cdbdd670a0cb67948e97f922c9bd9700e1a7
update:
  - Fetch origin
  - Pull origin
  - local HEAD verification
project_file: project.godot
default_action: Project Play(F5 / ▶)
expected_first_screen: SWITCHY EXPRESS title
full_pc_local_flow: NOT_CLOSED · RETEST_REQUIRED
runtime_semantic_poc: SX-DEC-055 · USER_DEFERRED_AFTER_DOR · IMPLEMENTATION_NOT_STARTED
```

Fetch만 수행하면 로컬 파일은 최신 상태가 아닐 수 있다. 폐기된 feature branch를 현재 사용자 실행 경로로 사용하지 않는다.

## 9. Manual Gate Contracts

### PC Local Project Play Retest

- [ ] 최신 `main`·commit 적용
- [ ] 별도 Scene 선택 없이 F5
- [ ] Title/Briefing/BUILD
- [ ] HUD·BUILD toolbar·TOP panel 표시
- [ ] 선로 설치·철거·회전
- [ ] RUN·manual/auto load·branch
- [ ] success/failure·Retry/Edit/Title
- [ ] crash·script error 없음

### Windows Artifact Runtime Smoke

- [ ] EXE/PCK 동일 디렉터리
- [ ] 실행·종료
- [ ] 전체 제품 흐름
- [ ] mouse·keyboard physical input
- [ ] clipping·overlap·readability
- [ ] audio cue·pause·success/failure

### Android Device Smoke

- [ ] canonical APK SHA-256
- [ ] physical Android landscape device
- [ ] AND-01~20

## 10. Merge·Cutover Conditions

PR #83은 **역사적으로 병합 완료**된 Vertical Slice PR이며 현재 Draft/merge blocker가 아니다.

향후 제품·runtime 변경 PR은 해당 작업의 승인 범위와 current authority에 따라 최소 다음을 만족해야 한다.

1. 해당 PR exact head의 적용 required checks PASS
2. Critical/Important 결함 0
3. unresolved review thread 0
4. GitHub 정본·correct Google Sheet sync
5. 실행하지 않은 physical/device/human Gate를 PASS로 확대하지 않음

PR merge는 store production cutover가 아니다. `SX-DEC-065`의 `MACHINE_PRIMARY_FINAL_USER_REVIEW`에 따라 deterministic/runtime/export/package/CI evidence가 primary acceptance route다. Windows physical/audio는 `FINAL_USER_REVIEW_ONLY`, Android Device Smoke는 target-in-scope machine/device compatibility gate이며, `FIVE_PERSON_COMPREHENSION_NOT_REQUIRED`와 `PLAYER_EXPERIENCE_STUDY_NOT_REQUIRED`는 mandatory gate가 아니다. Release signing·store evidence remains separately owned.

## 11. Current Conclusion

```text
FINITE CORE: PASS
PC VERTICAL SLICE AUTOMATED: PASS · HISTORICAL/BOUNDED EVIDENCE
DEFAULT PROJECT PLAY BOOT: PASS · AUTOMATED
WINDOWS EXPORT·INTEGRITY: PASS · PACKAGING EVIDENCE
PC FULL LOCAL FLOW: NOT_CLOSED · RETEST_REQUIRED
WINDOWS ARTIFACT RUNTIME: NOT_RUN
ANDROID APK EXPORT: PASS · PACKAGING/HASH EVIDENCE
ANDROID DEVICE SMOKE: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_REQUIRED_BY_USER_VALIDATION_POLICY
PLAYER EXPERIENCE STUDY: NOT_REQUIRED_BY_USER_VALIDATION_POLICY
FINAL USER REVIEW: NOT_RUN · FINAL_USER_REVIEW_ONLY
SX-DEC-055 RUNTIME SEMANTIC POC: SPEC/DoR APPROVED · USER_DEFERRED_AFTER_DOR · IMPLEMENTATION_NOT_STARTED
CONNECTED PHYSICAL EDITOR: NOT_RUN
PRODUCTION CUTOVER: BLOCKED_DEFERRED
```
