# Development Gates

## Active Gate Chains

### PC Vertical Slice chain

```text
PC0 SX-DEC-037 APPROVAL: PASS
→ PC1 AUTOMATED VERTICAL SLICE: PASS
→ PC2 DEFAULT PROJECT PLAY BOOT: PASS · AUTOMATED
→ PC3 LOCAL PROJECT PLAY RETEST: FAIL · RETEST_REQUIRED
→ PC4 WINDOWS DEBUG EXPORT·INTEGRITY: PASS
→ PC5 WINDOWS ARTIFACT RUNTIME·VISUAL·AUDIO SMOKE: NOT_RUN
→ PC6 PR #83 MERGE REVIEW: BLOCKED_BY_PC3_PC5
```

### Product·Android chain

```text
G0 PROJECT_IDENTIFIED: PASS
→ G1 FINITE_PRODUCT_AUTHORITY: PASS
→ G2 AUTOMATED_CORE: PASS
→ G3 VALIDATION_PREPARATION: PASS
→ G4 CANONICAL MAIN APK EXPORT: PASS
→ G5 ANDROID DEVICE SMOKE: NOT_RUN
→ G6 FIVE-PERSON COMPREHENSION: NOT_RUN · BLOCKED_BY_G5
→ G7 PRODUCTION CUTOVER REVIEW: BLOCKED_BY_G5_G6
```

PC Gate는 Android·HUMAN Gate를 대체하지 않는다.

## G0 — PROJECT_IDENTIFIED

Status: `PASS`

- Repository: `alsdmlals4-eng/Switchy-Express-Cargo-Puzzle`
- Engine: Godot `4.7.1-stable` · GDScript
- Platforms: PC · Android landscape
- Correct Sheet: `1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo`
- Wrong `19Ff...` Sheet: `DO_NOT_MODIFY`

## G1 — FINITE_PRODUCT_AUTHORITY

Status: `PASS · GMB-002 · SX-DEC-027~036`

유한 authored delivery puzzle, 자유 선로 건설, preflight, 수동/자동 적재, unlimited LIFO, persistent branch, TOP 그룹 하역, 제한 시간 성공·실패, same-layout retry가 현재 권위다.

## G2 — AUTOMATED_CORE

Status: `PASS`

- map·layout·preflight·build·sealed snapshot
- cargo field·manual/auto load·unlimited LIFO
- delivery·pause·result·retry·identity
- `A → B → A → A` / `2 → 1 → 1` proof

## G3 — VALIDATION_PREPARATION

Status: `PASS · SX-AUD-018`

- isolated Android validation launcher
- `PROOF / STACK 8 / STACK 16 / STACK 32`
- on-device Selector·Back
- validation feature override와 isolated package ID

기본 PC Project Play 변경은 validation feature override를 제거하지 않는다.

## G4 — CANONICAL MAIN APK EXPORT

Status: `PASS · SX-AUD-019 · EV-FP-APK-001`

```yaml
source_commit: 536911449018a3caf3511bc64e7bf1a66edf2016
apk_sha256: eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
package_id: com.alsdmlals4.switchyexpress.validation
```

APK export PASS는 device·HUMAN·production PASS가 아니다.

## G5 — ANDROID DEVICE SMOKE

Status: `NOT_RUN`

- full canonical APK SHA-256 match
- physical Android landscape device
- AND-01~20
- BUILD→RUN→pause/resume→result→retry/edit
- LOAD hold·auto-load·branch direct tap
- safe area·touch target·clipping·overlap
- crash·ANR·script error·심각한 frame 저하 없음

## G6 — FIVE-PERSON COMPREHENSION

Status: `NOT_RUN · BLOCKED_BY_G5`

## G7 — PRODUCTION CUTOVER REVIEW

Status: `BLOCKED_BY_G5_G6`

기본 PC Project Play는 현재 Vertical Slice 검수 진입점이며 store production cutover를 의미하지 않는다.

## PC0 — SX-DEC-037 APPROVAL

Status: `PASS · EV-USER-023`

- mouse-first + keyboard shortcuts
- touch command path 보존
- one representative stage
- default Project Play로 실제 Demo 진입
- Windows debug export
- Android validation evidence 보존

## PC1 — AUTOMATED VERTICAL SLICE

Status: `PASS · SX-AUD-020`

```yaml
feature_head: 8807cdbdd670a0cb67948e97f922c9bd9700e1a7
project_contract: 822 · PASS
godot_tests: 757 · PASS
godot_cases: 85
godot_assertions: 11284
godot_failures: 0
thin_adapter: 82 · PASS
asset_rights: 47 · PASS
```

- Title→Briefing→BUILD→RUN→Result→Retry/Edit/Title
- shared finite controller와 validation parity
- mouse·keyboard·touch command parity
- Korean HUD·Theme·ghost·TOP·problem feedback
- responsive layout와 effects/audio non-authority

## PC2 — DEFAULT PROJECT PLAY BOOT

Status: `PASS · AUTOMATED`

```text
project.godot
→ res://game/main/main.tscn
→ VerticalSliceDemo
→ TITLE
→ BRIEFING
→ GAMEPLAY
→ HUD·BUILD toolbar visible
```

- [x] 별도 Scene 선택 불필요
- [x] Project Settings 변경 불필요
- [x] F5 / ▶ 기본 실행
- [x] gameplay surface 자동 회귀 테스트
- [x] Android validation feature override 보존

## PC3 — LOCAL PROJECT PLAY RETEST

Status: `FAIL · RETEST_REQUIRED`

이전 로컬 실행에서 타이틀 이후 보드만 표시되고 HUD·도구·입력 표면이 누락됐다.

수정 완료:

- HUD full anchors
- HUD `z_index=10`
- default main product bootstrap
- F5 gameplay/HUD/toolbar boot regression
- CI timeout 30초→60초

재검수 절차:

```text
GitHub Desktop에서 branch 확인
→ Fetch origin
→ Pull origin
→ Godot 프로젝트 다시 열기
→ Project Play(F5 / ▶)
→ Title·Briefing·BUILD HUD/도구 확인
→ 실제 성공·실패·Retry/Edit 완주
```

사용자 재실행 전에는 PASS로 변경하지 않는다.

## PC4 — WINDOWS DEBUG EXPORT·INTEGRITY

Status: `PASS`

- Windows preset isolated
- EXE/PCK non-empty
- SHA-256 contract PASS
- latest workflow: `Windows Demo Export #40`

## PC5 — WINDOWS ARTIFACT RUNTIME·VISUAL·AUDIO SMOKE

Status: `NOT_RUN`

- EXE/PCK 같은 폴더
- process launch·clean exit
- 전체 제품 흐름
- mouse·keyboard physical input
- clipping·overlap·readability
- audio cue·train loop·pause·success/failure
- crash·script error·심각한 frame 저하 없음

## PC6 — PR #83 MERGE REVIEW

Status: `BLOCKED_BY_PC3_PC5`

PR #83은 Draft다. 최신 로컬 Project Play 재검수와 Windows artifact smoke가 완료되기 전에는 Ready 또는 merge로 전환하지 않는다.

## Current Transition

```text
PC: 최신 Branch Fetch/Pull → F5 local retest → artifact smoke → PR #83 review
Android: canonical APK device smoke → evidence review → Five-person Comprehension
Both: separate production cutover review
```

금지:

- Fetch만 수행한 상태를 최신 파일 적용으로 표현
- F6·별도 Scene 선택을 사용자 필수 절차로 안내
- 자동·export PASS를 수동 runtime PASS로 확대
- PC 증거를 Android/HUMAN 증거로 대체
- 사용자 실패 증거를 무시하고 PR Ready·merge 진행
