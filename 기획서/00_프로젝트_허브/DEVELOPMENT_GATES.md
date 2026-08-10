# Development Gates

현재 제품/실행 상태는 `CURRENT_CONFIRMED_DECISIONS.md`와 `ACTIVE_CONTEXT.md`가 우선한다. 이 문서는 제품·PC·Android·human·Base 검증 Gate의 관계와 역사 증거를 책임지며, 저장된 commit/PR/run 값은 해당 시점의 증거다.

## Active Gate Chains

### v4.5 planning/build chain

```text
A0 PHASE A GPT CHAT PLANNING: COMPLETE · SX-AUD-044
→ A1 READY_FOR_USER_PLANNING_COMPLETE_GATE: READY
→ A2 explicit user "기획 완료": NOT_GRANTED
→ A3 PHASE B FINAL PLANNING REVIEW: NOT_RUN
→ A4 BUILD AUTHORITY: BLOCKED
→ only after A3 PASS: SX-DEC-055 Task 1 / Step 1.1 RED
```

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

### Product·Android·human chain

```text
G0 PROJECT_IDENTIFIED: PASS
→ G1 FINITE_PRODUCT_AUTHORITY: PASS
→ G2 AUTOMATED_CORE: PASS
→ G3 VALIDATION_PREPARATION: PASS
→ G4 CANONICAL MAIN APK EXPORT: PASS · HISTORICAL VALIDATION-HARNESS PACKAGING EVIDENCE
→ G5 ANDROID DEVICE SMOKE · HISTORICAL VALIDATION-HARNESS: NOT_RUN · OPTIONAL DIAGNOSTIC LANE

Current acceptance lane:
A4 BUILD AUTHORITY
→ G5A SX-DEC-055 MERGED AUTOMATED POC: NOT_STARTED
→ G5B POST-POC ACCEPTANCE BUILD IDENTITY: UNASSIGNED
→ G5C POST-POC ACCEPTANCE BUILD PHYSICAL SMOKE: NOT_READY / NOT_RUN
→ G6 FIVE-PERSON COMPREHENSION: NOT_RUN · BLOCKED_BY_G5C
→ G7 PRODUCTION CUTOVER REVIEW: BLOCKED_BY_REQUIRED_PHYSICAL_HUMAN_EVIDENCE
```

### Base integration chain

```text
B0 BASE v9.4.3 RELEASE PIN: PASS
→ B1 CURRENT BASE MAIN DELTA REVIEW: PASS · NOT_ADOPTED_AS_RELEASE
→ B2 PR #94 CANDIDATE PILOT: CLOSED · ARCHIVED · NOT_MERGED
→ B3 MERGED IMMUTABLE PIN + SUCCESSFUL PILOT + SINGLE_AUTHORITY REVIEW: NOT_RUN
```

PC Gate는 Android·human Gate를 대체하지 않는다. historical Android harness는 future post-POC acceptance build를 대체하지 않는다. Base 후보 Pilot은 제품 수동 Gate를 대체하지 않는다.

## G0 — PROJECT_IDENTIFIED

Status: `PASS`

- Repository: `alsdmlals4-eng/Switchy-Express-Cargo-Puzzle`
- Engine: Godot `4.7.1-stable` · GDScript
- Platforms: Windows · Android landscape
- Correct Sheet: `1EpQ8j5XN6EjMhb5DG4DxPl_kNr0EqinK7HtP05IhoIo`
- Wrong `19Ff...` Sheet: `DO_NOT_MODIFY`

## G1 — FINITE_PRODUCT_AUTHORITY

Status: `PASS · GMB-003 · SX-DEC-027~055`

현재 권위는 유한 authored delivery puzzle, 자유 선로 건설, preflight, 수동/자동 적재, unlimited LIFO, persistent branch·crossing, TOP 그룹 하역, 제한 시간 성공·실패, 한쪽 연결 최종 종착역, ROUTE_END, 분기 세 방향 화살표·U턴·점유 잠금, same-layout retry, mid-run exit와 승인된 semantic presentation 방향이다.

무한 생존·fuel·BOOST·capacity 8·pickup respawn·switch auto-reset은 역사 계약이며 현재 제품 권위가 아니다.

## G2 — AUTOMATED_CORE

Status: `PASS`

- map·layout·preflight·build·sealed snapshot
- cargo field·manual/auto load·unlimited LIFO
- delivery·pause·result·retry·identity
- recommended route full delivery
- route-end / switch-direction / pickup regression evidence

## G3 — VALIDATION_PREPARATION

Status: `PASS · HISTORICAL VALIDATION-HARNESS PREPARATION`

- isolated Android validation launcher
- `PROOF / STACK 8 / STACK 16 / STACK 32`
- on-device Selector·Back
- validation feature override와 isolated package ID

기본 product entrypoint와 이 historical validation-harness launcher를 혼동하지 않는다.

## G4 — CANONICAL MAIN APK EXPORT

Status: `PASS · SX-AUD-019 · EV-FP-APK-001 · HISTORICAL_PACKAGING_EVIDENCE`

```yaml
source_commit: 536911449018a3caf3511bc64e7bf1a66edf2016
apk_sha256: eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
package_id: com.alsdmlals4.switchyexpress.validation
```

APK export PASS는 device·human·production PASS가 아니다. 이 pre-SX-DEC-055 artifact는 post-POC 사람 이해도 build가 아니다.

## G5 — ANDROID DEVICE SMOKE · HISTORICAL VALIDATION-HARNESS

Status: `NOT_RUN · OPTIONAL_DIAGNOSTIC_LANE`

Authority:

- `ANDROID_DEVICE_SMOKE_RUNBOOK.md`
- `ANDROID_DEVICE_SMOKE_EVIDENCE_TEMPLATE.md`

이 fixed-hash lane은 AND-01~20과 STACK 8/16/32 diagnostic을 보존한다. 실행한다면 해당 historical artifact의 device evidence만 생성하며 G5C 또는 G6을 자동 통과시키지 않는다.

## G5A — SX-DEC-055 MERGED AUTOMATED POC

Status: `NOT_STARTED · BLOCKED_BY_A2_A3`

선행 조건:

1. explicit user `기획 완료`
2. Phase B final planning review PASS
3. 기존 SX-DEC-055 exact-file RED-first plan 실행
4. exact-head automated regression + merge/readback

## G5B — POST-POC ACCEPTANCE BUILD IDENTITY

Status: `UNASSIGNED`

```yaml
source_commit: UNASSIGNED
artifact_sha256: UNASSIGNED
package_identity: UNASSIGNED
assignment_rule: ONLY_AFTER_AUTHORIZED_SX_DEC_055_IMPLEMENTATION_MERGE
```

현재 Phase A에서 future hash/SHA를 발명하지 않는다.

## G5C — POST-POC ACCEPTANCE BUILD PHYSICAL SMOKE

Status: `NOT_READY · NOT_RUN`

- exact G5B build identity 확인
- actual product entrypoint/representative flow
- relevant input/readability/safe-area/stability
- semantic stack/load/preflight/switch/event presentation 확인
- visual feedback이 gameplay authority를 바꾸지 않는지 관찰
- evidence를 exact source/artifact identity에 연결

PC physical evidence는 진단에 사용할 수 있지만 Android-oriented human Gate를 PC-only evidence로 대체하지 않는다.

## G6 — FIVE-PERSON COMPREHENSION

Status: `NOT_RUN · BLOCKED_BY_G5C`

Authority: `기획서/50_제작_검증/PLAYTEST_PLAN.md`

- minimum analyzable first-contact sessions = 5
- recruit target = 6 `TEST_VALUE`
- behavior/prediction/transfer first
- neutral moderator prompts
- same exact accepted build identity as G5C
- unresolved P0/P1 comprehension/accessibility finding = 0 for PASS

## G7 — PRODUCTION CUTOVER REVIEW

Status: `BLOCKED_BY_REQUIRED_PHYSICAL_HUMAN_EVIDENCE`

## PC0 — SX-DEC-037~042 AUTHORITY

Status: `PASS`

- default Project Play로 대표 Demo 진입
- recommended route와 운행 중 분기·교차 전환
- 한쪽 reciprocal 연결 최종 종착역
- BUILD·RUN 중 현재 플레이 종료 확인
- Windows debug export
- historical Android validation evidence 보존

## PC1 — AUTOMATED VERTICAL SLICE

Status: `PASS`

```yaml
latest_automated_verified_product_main: 1339a9467312d0ac680725894a9efb59746ec2cc
project_contract: 922 · PASS
godot_tests: 853 · PASS
godot_cases: 92
godot_assertions: 11457
godot_failures: 0
```

이 값은 당시 자동화 제품 증거이며 현재 default branch HEAD를 고정하지 않는다.

## PC2 — DEFAULT PROJECT PLAY BOOT

Status: `PASS · AUTOMATED`

```text
project.godot
→ res://game/main/main.tscn
→ VerticalSliceDemo
→ TITLE → BRIEFING → GAMEPLAY
```

## PC3 — PR #83 MERGE

Status: `PASS`

```yaml
pr: 83
merged_at: 2026-08-06T04:43:25Z
merge_commit: 4189cd13bebc34649cdca39aa78bfd045805b7c8
```

PR #83 병합 여부는 더 이상 수동 runtime Gate의 차단점이 아니다.

## PC4 — ROUTE·TERMINAL·MID-RUN AUTOMATED REGRESSION

Status: `PASS`

- 15×11 권장 배치 full delivery
- 분기·교차 runtime control
- one-sided station Preflight PASS
- final unload success priority
- mid-run menu state contract

## PC4A — COLOR PARITY·ROUTE-END·SWITCH ARROW IMPLEMENTATION

Status: `MERGED_MAIN_VERIFIED · AUTOMATED_PASS · USER_FEATURE_F5_PASS`

- `SX-DEC-040`: one-sided station parity automated PASS
- `SX-DEC-041`: SUCCESS priority + FAILURE/ROUTE_END merged/automated/user F5 PASS
- `SX-DEC-042`: three-direction direct select/U-turn/occupied lock merged/automated/user F5 PASS
- `SX-DEC-046`: procedural direction-arrow reinforcement merged/user F5 PASS

이 feature-scoped 증거는 full PC local flow PASS가 아니다.

## PC5 — LOCAL ROUTE·MID-RUN RETEST

Status: `RETEST_REQUIRED`

```text
LIVE_GITHUB_DEFAULT_BRANCH
→ Fetch/Pull
→ F5 product entrypoint
→ representative route/build/run
→ route-end/switch/load/station/result/retry-edit
→ crash/script-error observation
```

## PC6 — WINDOWS DEBUG EXPORT·INTEGRITY

Status: `PASS · HISTORICAL_PACKAGE_EVIDENCE`

## PC7 — WINDOWS ARTIFACT RUNTIME·VISUAL·AUDIO SMOKE

Status: `NOT_RUN`

- process launch·clean exit
- 전체 제품 흐름
- mouse·keyboard physical input
- clipping·overlap·readability
- audio cue·pause·success/failure
- crash·script error·심각한 frame 저하 없음

## B0 — BASE v9.4.3 RELEASE PIN

Status: `PASS`

프로젝트의 채택 release는 Base `v9.4.3`이다. 최신 Base `main`은 비교·학습 대상이지 자동 승격된 release가 아니다.

## B1 — CURRENT BASE MAIN DELTA REVIEW

Status: `PASS · NOT_ADOPTED_AS_RELEASE`

## B2 — PR #94 CANDIDATE PILOT

Status: `CLOSED · ARCHIVED · NOT_MERGED`

## B3 — MERGED IMMUTABLE PIN + SUCCESSFUL PILOT + SINGLE_AUTHORITY REVIEW

Status: `NOT_RUN`

## Current Transition

```text
Current state owner: CURRENT_CONFIRMED_DECISIONS + ACTIVE_CONTEXT + PHASE_A_PLANNING_COMPLETION_GATE
Planning: READY_FOR_USER_PLANNING_COMPLETE_GATE
→ await explicit user "기획 완료"
→ Phase B final planning review
→ only after Phase B PASS: SX-DEC-055 RED-first implementation
→ merged automated POC
→ exact post-POC acceptance build identity
→ G5C physical acceptance smoke
→ G6 Five-person Comprehension
→ separate production cutover review
```

## 금지

- prior approval/continuous-work를 user `기획 완료` Gate로 해석
- Phase B 전에 SX-DEC-055 BUILD 시작
- 이미 병합된 PR #83을 Draft·MAIN_PENDING·merge blocked로 표시
- PC4A를 PENDING으로 되돌림
- historical validation APK를 post-POC human acceptance build로 자동 사용
- future build SHA/hash를 Phase A에서 발명
- 자동·export PASS를 physical/human PASS로 확대
- Five-person gate를 six-person mandatory product rule로 변경
- PC 증거를 Android-oriented human evidence로 대체
- Base candidate를 release pin으로 자동 승격
- legacy endless·fuel·BOOST 보호 규칙 재활성화
