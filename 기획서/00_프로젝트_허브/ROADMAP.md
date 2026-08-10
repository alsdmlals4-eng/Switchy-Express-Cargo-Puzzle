# Roadmap

Last updated: `2026-08-11 KST`

## 현재 제품 권위와 실행 오버레이

```text
FINITE_DELIVERY_PUZZLE_BASELINE · SX-DEC-027~055
→ finite delivery core implemented and automated evidence preserved
→ route-end / switch direction / cargo pickup merged with bounded user F5 evidence
→ SX-DEC-053/054 semantic asset production complete: 73 product PNGs
→ SX-DEC-055 Runtime Semantic POC decision/spec/DoR approved and merged
→ USER_DEFERRED_AFTER_DOR · implementation NOT_STARTED
→ PHASE A GPT CHAT PLANNING
→ explicit user "기획 완료" required
→ PHASE B FINAL PLANNING REVIEW required
→ only after Phase B PASS: BUILD / SX-DEC-055 RED-first execution
```

정본:

- `기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md`
- `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
- `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
- `기획서/50_제작_검증/PHASE_A_PLANNING_COMPLETION_GATE.md`
- `기획서/50_제작_검증/PLAYTEST_PLAN.md`
- `docs/decisions/SX_DEC_055_RUNTIME_SEMANTIC_POC.md`
- `docs/superpowers/specs/2026-08-10-runtime-semantic-poc-design.md`
- `docs/superpowers/plans/2026-08-10-sx-dec-055-runtime-semantic-poc.md`

## 현재 Phase A 계약

```yaml
phase_a: IN_PROGRESS
planning_audit: SX-AUD-044
user_planning_complete_gate: NOT_GRANTED
phase_b_final_planning_review: NOT_RUN
build_authority: BLOCKED
sx_dec_055_decision: APPROVED
sx_dec_055_spec: APPROVED_AND_MERGED
sx_dec_055_dor_plan: MERGED
sx_dec_055_runtime_implementation: USER_DEFERRED_AFTER_DOR · NOT_STARTED
runtime_integrated: false
```

과거 승인과 `연속작업`은 Phase A 기획을 계속 수행할 권한이며, v4.5의 명시적 `기획 완료` Gate 또는 Phase B PASS를 대신하지 않는다.

## 완료된 기반

### M0 — 제품 기준선·실행 계약 · PASS

- [x] finite delivery product pivot
- [x] `SX-DEC-027~036` finite baseline decisions
- [x] correct Sheet same-ID sync/readback
- [x] legacy code inventory and authority separation

### M1 — 건설 가능한 대표 맵 · PASS

- [x] authored map and buildable/non-buildable surface
- [x] 직선·곡선·분기·교차
- [x] 비용·철거 전액 환급
- [x] start·station·cargo reachability
- [x] sealed TrackLayout and graph identity

### M2 — 유한 배송 코어 · PASS

- [x] 수동 적재와 자동 적재 토글
- [x] 무제한 CargoStack
- [x] TOP 연속 그룹 하역
- [x] 제한 시간 success/failure
- [x] pause integrity
- [x] same-layout retry/fresh runtime
- [x] persistent branch direct selection and occupied lock

### M3 — PC Vertical Slice / route refinement · IMPLEMENTED_WITH_OPEN_MANUAL_GATES

- [x] F5 Title → Briefing → BUILD → RUN → Result implemented
- [x] recommended route automated proof
- [x] one-sided station parity automated proof
- [x] mid-run exit automated contract
- [x] ROUTE_END automated + bounded user F5 proof
- [x] three-direction switch arrows/direct select/U-turn/occupied lock automated + bounded user F5 proof
- [x] cargo pickup marker hide/retry restore + bounded user F5 proof
- [ ] full PC manual flow closure
- [ ] Windows physical exported-artifact runtime/visual/audio/input smoke

### M4 — Visual planning and semantic production · COMPLETE

- [x] `SX-DEC-050` component/requirement package
- [x] `SX-DEC-051` E+D source candidate package
- [x] `SX-DEC-053` final direction + 39 product assets
- [x] `SX-DEC-054 RUN_2A` 20 semantic assets
- [x] `SX-DEC-054 BUILD_2B` 8 semantic assets/compositions
- [x] `SX-DEC-054 VFX_2C` 6 semantic assets / standard+Reduced Motion event pairs
- [x] total product PNGs = 73
- [x] legacy unnamed atlas remains reference-only
- [ ] runtime consumption intentionally separate under SX-DEC-055

### M5 — SX-DEC-055 Runtime Semantic POC · APPROVED_DOR · USER_DEFERRED_AFTER_DOR

Authority:

- `docs/decisions/SX_DEC_055_RUNTIME_SEMANTIC_POC.md`
- `docs/superpowers/specs/2026-08-10-runtime-semantic-poc-design.md`
- `docs/superpowers/plans/2026-08-10-sx-dec-055-runtime-semantic-poc.md`

Completed planning:

- [x] runtime POC decision approval
- [x] written spec approval
- [x] exact-file RED-first implementation plan/DoR
- [x] function/interface decomposition
- [x] dependencies and presentation/domain boundaries
- [x] protected surfaces and forbidden changes
- [x] automated regression/merge/closure blueprint

Blocked execution:

- [ ] user explicit `기획 완료`
- [ ] Phase B final planning review PASS
- [ ] SemanticAssetCatalog RED/GREEN
- [ ] semantic runtime-state resolver RED/GREEN
- [ ] manual-load actual-state projection
- [ ] representative HUD/BUILD/route/VFX integration
- [ ] Reduced Motion information-equivalence proof
- [ ] exact-head implementation regression/merge

Status: `USER_DEFERRED_AFTER_DOR · GODOT_IMPLEMENTATION_NOT_STARTED · runtime_integrated=false`.

### M5A — Phase A Planning Completion · IN_PROGRESS

Authority:

- `기획서/50_제작_검증/PHASE_A_PLANNING_COMPLETION_GATE.md`
- `기획서/50_제작_검증/SX_AUD_044_FIRST_SESSION_COMPREHENSION_AND_PHASE_GATE.md`
- `docs/superpowers/specs/2026-08-11-first-session-comprehension-and-phase-gate-design.md`

- [x] existing implementation function/dependency/protection planning audited
- [x] post-POC acceptance-build architecture selected
- [x] behavior-first first-session research design authored
- [ ] current-owner/Sheet/PR exact-head closure
- [ ] `READY_FOR_USER_PLANNING_COMPLETE_GATE` verdict

No BUILD occurs in M5A.

## Validation Lanes

### Historical Android Validation Harness · PACKAGING PASS / DEVICE NOT_RUN

```text
CANONICAL MAIN APK EXPORT · PASS
historical source: 536911449018a3caf3511bc64e7bf1a66edf2016
historical SHA-256: eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
role: historical validation-harness packaging evidence
```

`ANDROID_DEVICE_SMOKE_RUNBOOK.md`와 Evidence Template은 이 fixed-hash diagnostic lane을 계속 소유한다. 이 APK는 post-POC human acceptance build가 아니다.

### M6 — Android Device Smoke · OPEN_NOT_RUN

Historical validation-harness physical smoke remains valid and `NOT_RUN`.

- [ ] fixed historical APK hash check
- [ ] physical Android landscape diagnostic run
- [ ] AND-01~20 evidence if/when that dedicated lane is executed

이 M6 evidence는 유용한 device/stack diagnostic이지만 presentation이 바뀐 뒤의 Five-person Comprehension을 자동 승인하지 않는다.

### M6A — Post-POC Acceptance Build Physical Smoke · NOT_READY

```yaml
acceptance_build_state: UNASSIGNED_UNTIL_AUTHORIZED_IMPLEMENTATION_MERGE
source_commit: UNASSIGNED
artifact_sha256: UNASSIGNED
physical_smoke: NOT_RUN
blocked_by: USER_PLANNING_COMPLETE_GATE + PHASE_B + SX_DEC_055_IMPLEMENTATION_MERGE
```

- [ ] exact post-POC acceptance source/build identity
- [ ] actual product entrypoint/representative flow
- [ ] relevant input/readability/safe-area/stability evidence
- [ ] semantic Stack/load/preflight/switch/event presentation visible and non-authoritative
- [ ] reviewed physical evidence tied to exact build identity

### M7 — Five-person Comprehension · OPEN_NOT_RUN

Authority: `기획서/50_제작_검증/PLAYTEST_PLAN.md`

Blocked by M6A, not silently by the historical APK.

- [ ] recruit target 6 (`TEST_VALUE`), minimum analyzable first-contact sessions 5
- [ ] objective/build/preflight comprehension
- [ ] route→encounter-order model
- [ ] LIFO TOP + contiguous unload prediction
- [ ] manual/auto load-state understanding
- [ ] selected switch direction / occupied-lock understanding
- [ ] Retry vs Edit learning loop
- [ ] color-independent shape/text/TOP recognition
- [ ] causal semantic feedback attribution
- [ ] independent transfer to later changed state
- [ ] no solution-relevant moderator intervention
- [ ] unresolved P0/P1 comprehension/accessibility finding 0

Status: `NOT_RUN · BLOCKED_BY_POST_POC_ACCEPTANCE_BUILD_PHYSICAL_SMOKE`.

### M8 — Production Cutover Review · BLOCKED_DEFERRED

- [ ] required physical/device/human evidence
- [ ] P0/P1 open finding 0
- [ ] production entrypoint/package/signing review
- [ ] release compliance / asset rights evidence completion

Status: `BLOCKED_DEFERRED`.

## 후속 제품 Roadmap

다음은 승인된 기존 방향 또는 장기 backlog이며 현재 Phase A/SX-DEC-055와 섞지 않는다.

- `SX-DEC-033`: speed/cost/score stars + leaderboard · `APPROVED · NOT_STARTED`
- `SX-DEC-034`: tutorial/theme chapter · `APPROVED · NOT_STARTED`
- `SX-DEC-035`: daily/weekly fixed-seed challenge · `APPROVED · NOT_RUN`
- localization/accessibility stress
- official map/content expansion
- Google Play rating/target audience/store consistency
- asset-rights/provenance completion

새 구체 콘텐츠·규칙·과금·온라인 범위는 기존 승인 범위를 넘으면 별도 사용자 결정을 요구한다.

## 현재 다음 순서

```text
SX-AUD-044 Phase A planning docs + Sheet + exact-head PR closure
→ READY_FOR_USER_PLANNING_COMPLETE_GATE (only if evidence supports)
→ await explicit user "기획 완료"
→ PHASE B final planning review
→ only after PHASE B PASS: SX-DEC-055 Task 1 / Step 1.1 RED
```

## 역사 경계

- endless survival, fuel/fuel-zero, player BOOST, cargo capacity 8, cargo-count slowdown, pickup respawn, switch auto-reset은 `LEGACY_IMPLEMENTATION · HISTORICAL_EVIDENCE`다.
- old validation-harness APK와 과거 Android-immediate Roadmap은 당시 증거다.
- old `resume → RED` handoff는 v4.5 sequencing으로 대체된다.
