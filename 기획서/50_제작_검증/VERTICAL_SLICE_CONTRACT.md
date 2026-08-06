# Finite Delivery First Vertical Slice Contract

```yaml
status: PC_AUTOMATED_AND_PACKAGE_PASS · LOCAL_PROJECT_PLAY_RETEST_REQUIRED · ANDROID_APK_EXPORT_PASS
product_authority: GMB-002 · SX-DEC-027~036
pc_demo_authority: SX-DEC-037 · EV-USER-023
current_audits: SX-AUD-019 · SX-AUD-020
latest_verified_commit: 8807cdbdd670a0cb67948e97f922c9bd9700e1a7
default_entrypoint: PRODUCT_VERTICAL_SLICE_BOOTSTRAP
pc_local_runtime: FAIL · RETEST_REQUIRED
windows_artifact_runtime: NOT_RUN
next_pc_gate: LOCAL_PROJECT_PLAY_RETEST → WINDOWS_ARTIFACT_RUNTIME_SMOKE
next_android_gate: ANDROID_DEVICE_SMOKE → FIVE_PERSON_COMPREHENSION
cutover_status: BLOCKED
```

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

## 5. Automated Evidence

| Gate | 상태 | 증거 |
|---|---|---|
| FINITE AUTOMATED CORE | PASS | current regression |
| DEFAULT PROJECT PLAY BOOT | PASS · AUTOMATED | `Main/VerticalSliceDemo`, TITLE→BRIEFING→GAMEPLAY, HUD/tool visible |
| PC VERTICAL SLICE AUTOMATED | PASS | Godot Tests #757 · `85 cases · 11,284 assertions` |
| PROJECT CONTRACT | PASS | #822 |
| THIN ADAPTER | PASS | #82 |
| ASSET RIGHTS | PASS | #47 |
| WINDOWS DEBUG EXPORT | PASS | #40 |
| PC LOCAL PROJECT PLAY | FAIL · RETEST_REQUIRED | user observed missing HUD/input on earlier local commit |
| WINDOWS ARTIFACT RUNTIME | NOT_RUN | actual Windows execution required |
| ANDROID APK EXPORT | PASS | canonical Android evidence |
| ANDROID DEVICE | NOT_RUN | physical landscape device required |
| HUMAN | NOT_RUN | first-contact 5명 |
| PRODUCTION CUTOVER | BLOCKED | manual Gates and separate approval required |

## 6. Runtime Failure and Fix Contract

사용자 관찰:

```yaml
finding: HUD_AND_INTERACTION_SURFACE_MISSING_AFTER_BUILD_ENTRY
status: FAIL · RETEST_REQUIRED
```

수정:

- HUD full anchors
- HUD `z_index=10`
- `game/main/main.tscn` product bootstrap
- default Play TITLE→BRIEFING→GAMEPLAY·HUD·toolbar regression
- 기존 성공·실패·Retry/Edit E2E 유지
- CI test timeout 60초

사용자가 최신 Branch를 Fetch/Pull하고 F5로 다시 완주하기 전에는 수동 Gate를 PASS로 올리지 않는다.

## 7. Canonical Android Contract

```yaml
source_commit: 536911449018a3caf3511bc64e7bf1a66edf2016
apk_sha256: eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
package_id: com.alsdmlals4.switchyexpress.validation
```

Android preset은 `validation_harness` feature override로 전용 launcher를 사용한다. 일반 PC Project Play 변경은 이 launcher·package ID·APK 증거를 대체하지 않는다.

## 8. User Handoff Contract

```yaml
repository: alsdmlals4-eng/Switchy-Express-Cargo-Puzzle
branch: agent/pc-vertical-slice-demo-design
minimum_verified_commit: 8807cdbdd670a0cb67948e97f922c9bd9700e1a7
update:
  - Fetch origin
  - Pull origin
  - local HEAD verification
project_file: project.godot
default_action: Project Play(F5 / ▶)
expected_first_screen: SWITCHY EXPRESS title
manual_status: FAIL · RETEST_REQUIRED
```

Fetch만 수행하면 로컬 파일은 최신 상태가 아닐 수 있다.

## 9. Manual Gate Contracts

### PC Local Project Play Retest

- [ ] 최신 Branch·commit 적용
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

PR #83은 현재 Draft다. 다음 전에는 Ready·merge로 전환하지 않는다.

1. PC Local Project Play retest PASS
2. Windows artifact runtime smoke PASS 또는 명시적 별도 승인
3. Critical/Important 결함 0
4. unresolved review thread 0
5. GitHub 정본·correct Google Sheet sync

PR merge는 store production cutover가 아니다. Android Device Smoke, Five-person Comprehension, release signing·store evidence는 별도 Gate다.

## 11. Current Conclusion

```text
FINITE CORE: PASS
PC VERTICAL SLICE AUTOMATED: PASS
DEFAULT PROJECT PLAY BOOT: PASS · AUTOMATED
WINDOWS EXPORT·INTEGRITY: PASS
PC LOCAL PROJECT PLAY: FAIL · RETEST_REQUIRED
WINDOWS ARTIFACT RUNTIME: NOT_RUN
ANDROID APK EXPORT: PASS
ANDROID DEVICE SMOKE: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN
PRODUCTION CUTOVER: BLOCKED
```
