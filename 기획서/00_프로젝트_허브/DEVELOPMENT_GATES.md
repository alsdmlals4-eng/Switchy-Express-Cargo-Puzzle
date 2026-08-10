# Development Gates

현재 제품/실행 상태는 `CURRENT_CONFIRMED_DECISIONS.md`와 `ACTIVE_CONTEXT.md`가 우선한다. 이 문서는 제품·PC·Android·Base 검증 Gate의 관계와 역사 증거를 책임지며, 저장된 commit/PR/run 값은 해당 시점의 증거다.

## Active Gate Chains

### PC Vertical Slice chain

```text
PC0 SX-DEC-037~042 AUTHORITY: PASS · GMB-003 PLAN
→ PC1 AUTOMATED VERTICAL SLICE: PASS
→ PC2 DEFAULT PROJECT PLAY BOOT: PASS · AUTOMATED
→ PC3 PR #83/#99/#100 MERGE: PASS
→ PC4 ROUTE·TERMINAL·MID-RUN AUTOMATED REGRESSION: PASS
→ PC4A COLOR PARITY·ROUTE-END·SWITCH ARROW IMPLEMENTATION: MERGED_MAIN_VERIFIED · AUTOMATED_PASS · USER_FEATURE_F5_PASS
→ PC5 LOCAL ROUTE·MID-RUN RETEST: RETEST_REQUIRED
→ PC6 WINDOWS DEBUG EXPORT·INTEGRITY: PASS
→ PC7 WINDOWS ARTIFACT RUNTIME·VISUAL·AUDIO SMOKE: NOT_RUN
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

### Base integration chain

```text
B0 BASE v9.4.3 RELEASE PIN: PASS
→ B1 CURRENT BASE MAIN DELTA REVIEW: PASS · NOT_ADOPTED_AS_RELEASE
→ B2 PR #94 CANDIDATE PILOT: CLOSED · ARCHIVED · NOT_MERGED
→ B3 MERGED IMMUTABLE PIN + SUCCESSFUL PILOT + SINGLE_AUTHORITY REVIEW: NOT_RUN
```

PC Gate는 Android·HUMAN Gate를 대체하지 않는다. Base 후보 Pilot은 제품 수동 Gate를 대체하지 않는다.

## G0 — PROJECT_IDENTIFIED

Status: `PASS`

- Repository: `alsdmlals4-eng/Switchy-Express-Cargo-Puzzle`
- Engine: Godot `4.7.1-stable` · GDScript
- Platforms: Windows · Android landscape
- Correct Sheet: `1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo`
- Wrong `19Ff...` Sheet: `DO_NOT_MODIFY`

## G1 — FINITE_PRODUCT_AUTHORITY

Status: `PASS · GMB-003 · SX-DEC-027~042`

현재 권위는 유한 authored delivery puzzle, 자유 선로 건설, preflight, 수동/자동 적재, unlimited LIFO, persistent branch·crossing, TOP 그룹 하역, 제한 시간 성공·실패, 색상 대칭 한쪽 연결 최종 종착역, 배송 전 노선 끝 ROUTE_END, 분기 세 방향 화살표·U턴, same-layout retry, mid-run exit다.

무한 생존·fuel·BOOST·capacity 8·pickup respawn·switch auto-reset은 역사 계약이며 현재 제품 권위가 아니다.

## G2 — AUTOMATED_CORE

Status: `PASS`

- map·layout·preflight·build·sealed snapshot
- cargo field·manual/auto load·unlimited LIFO
- delivery·pause·result·retry·identity
- recommended route full delivery
- curve renderer/domain port parity
- one-sided final station unload success
- mid-run menu·pause·confirm·input lock contract

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

## PC0 — SX-DEC-037~042 AUTHORITY

Status: `PASS`

- default Project Play로 대표 Demo 진입
- recommended route와 운행 중 분기·교차 전환
- 한쪽 reciprocal 연결 최종 종착역
- BUILD·RUN 중 현재 플레이 종료 확인
- Windows debug export
- Android validation evidence 보존

## PC1 — AUTOMATED VERTICAL SLICE

Status: `PASS`

```yaml
latest_automated_verified_product_main: 1339a9467312d0ac680725894a9efb59746ec2cc
project_contract: 922 · PASS
godot_tests: 853 · PASS
godot_cases: 92
godot_assertions: 11457
godot_failures: 0
one_sided_station_assertions: 20
```

이 값은 당시 자동화 제품 증거이며 현재 default branch HEAD를 고정하지 않는다.

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

## PC3 — PR #83 MERGE

Status: `PASS`

```yaml
pr: 83
merged_at: 2026-08-06T04:43:25Z
merge_commit: 4189cd13bebc34649cdca39aa78bfd045805b7c8
```

PR #83 병합 여부는 더 이상 수동 runtime Gate의 선행 차단점이 아니다. 병합 후 실제 로컬 검수는 PC5가 소유한다.

## PC4 — ROUTE·TERMINAL·MID-RUN AUTOMATED REGRESSION

Status: `PASS`

- 15×11 권장 배치 full delivery
- 분기·교차 runtime control
- curve render/domain port parity
- one-sided station Preflight PASS
- final unload before terminal-end failure
- mid-run menu·cancel/confirm state contract
- title exit visibility와 mid-run flow의 수동 범위 분리

## PC4A — COLOR PARITY·ROUTE-END·SWITCH ARROW IMPLEMENTATION

Status: `MERGED_MAIN_VERIFIED · AUTOMATED_PASS · USER_FEATURE_F5_PASS`

- `SX-DEC-040`: RED_STAR/BLUE_DIAMOND one-sided station parity · automated parity PASS
- `SX-DEC-041`: final delivery SUCCESS priority + no legal next cell → FAILURE/ROUTE_END · merged/automated/user current-main F5 PASS
- `SX-DEC-042`: reciprocal three-direction switch selection including incoming-direction U-turn + occupied lock · merged/automated/user current-main F5 PASS
- `SX-DEC-046`: procedural direction-arrow component reinforcement · merged/user current-main F5 PASS

이 feature-scoped 증거는 **full PC local flow PASS가 아니다**. PC5 전체 BUILD/RUN retest, PC7 Windows artifact physical runtime, Android device, connected physical editor, broader human/comprehension은 각각 별도 Gate로 남는다.

## PC5 — LOCAL ROUTE·MID-RUN RETEST

Status: `RETEST_REQUIRED`

```text
LIVE_GITHUB_DEFAULT_BRANCH 확인
→ Fetch origin
→ Pull origin
→ Godot 완전 종료 후 reopen
→ F5
→ 권장 배치 또는 재현용 배치
→ 파란 한쪽 연결 종착역 판정
→ 배송 전 노선 끝 FAILURE/ROUTE_END
→ 분기 세 화살표·진입 방향 U턴·점유 잠금
→ 마지막 하역 SUCCESS 우선순위
→ BUILD/RUN 메뉴 취소·상태 보존
→ 종료 확정·Title 복귀
```

사용자가 실제 전체 흐름을 확인하기 전에는 PC5를 PASS로 변경하지 않는다.

## PC6 — WINDOWS DEBUG EXPORT·INTEGRITY

Status: `PASS`

- Windows preset isolated
- EXE/PCK non-empty
- SHA-256 contract PASS

## PC7 — WINDOWS ARTIFACT RUNTIME·VISUAL·AUDIO SMOKE

Status: `NOT_RUN`

- process launch·clean exit
- 전체 제품 흐름
- mouse·keyboard physical input
- clipping·overlap·readability
- audio cue·train loop·pause·success/failure
- crash·script error·심각한 frame 저하 없음

## B0 — BASE v9.4.3 RELEASE PIN

Status: `PASS`

프로젝트의 채택 release는 Base `v9.4.3`이다. 최신 Base `main`은 비교·학습 대상이지 자동 승격된 release가 아니다.

## B1 — CURRENT BASE MAIN DELTA REVIEW

Status: `PASS · NOT_ADOPTED_AS_RELEASE`

최신 Base main은 비교·학습 reference다. 현 프로젝트는 검증된 실제 소비 경로와 별도 채택 근거 없이 새 Base 동작·addon·Pilot을 자동 도입하지 않는다.

## B2 — PR #94 CANDIDATE PILOT

Status: `CLOSED · ARCHIVED · NOT_MERGED`

- PR 설명은 Base C0.2를 말하지만 실제 diff는 C0.3 candidate SHA를 고정
- candidate SHA는 현재 Base main과 분기됨
- 핵심 Pilot workflow 실패
- merged immutable release pin 아님
- HiGodot 단일 저작 권위와 역할 경계 재검토 필요

## B3 — MERGED IMMUTABLE PIN + SUCCESSFUL PILOT + SINGLE_AUTHORITY REVIEW

Status: `NOT_RUN`

다음 네 조건이 모두 충족되어야 새 Pilot adoption을 merge-ready로 판단한다.

1. Base의 승인·병합된 immutable SHA
2. 프로젝트 adoption contract와 descriptor의 동일 SHA
3. Pilot과 전체 제품 회귀의 성공
4. HiGodot 또는 다른 Godot mutation authority와 중복되지 않는 실제 소비 경로

## Current Transition

```text
Current state owner: CURRENT_CONFIRMED_DECISIONS + ACTIVE_CONTEXT
PC: LIVE_GITHUB_DEFAULT_BRANCH → PC5 full local route/mid-run retest → PC7 Windows artifact physical runtime smoke
Presentation/runtime: SX-DEC-055 SPEC/DoR APPROVED · USER_DEFERRED_AFTER_DOR · IMPLEMENTATION_NOT_STARTED
Android: canonical APK device smoke → Five-person Comprehension
Base: v9.4.3 pin 유지 · upstream main은 reference-only
Production: separate cutover review · BLOCKED_DEFERRED
```

## 금지

- 이미 병합된 PR #83을 Draft·MAIN_PENDING·merge blocked로 표시
- PC4A를 구현 전 상태로 되돌려 이미 완료된 SX-DEC-041/042/046 작업을 반복
- 폐기된 feature branch를 사용자 실행 경로로 안내
- 자동·export PASS를 수동 runtime PASS로 확대
- PC 증거를 Android·HUMAN 증거로 대체
- 실패한 미병합 Base candidate를 release pin으로 승격
- legacy endless·fuel·BOOST 보호 규칙 재활성화
