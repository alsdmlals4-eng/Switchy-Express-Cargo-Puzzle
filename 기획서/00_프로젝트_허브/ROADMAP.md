# Roadmap

Last updated: `2026-08-10 KST`

## 현재 제품 권위와 실행 오버레이

```text
FINITE_DELIVERY_PUZZLE_BASELINE · SX-DEC-027~055
→ finite delivery core implemented and automated evidence preserved
→ route-end / switch direction / cargo pickup later decisions merged with bounded user F5 evidence
→ SX-DEC-053/054 semantic asset production complete: 73 product PNGs
→ SX-DEC-055 Runtime Semantic POC decision/spec/DoR approved and merged
→ USER_DEFERRED_AFTER_DOR
→ Godot/GDScript runtime semantic implementation NOT_STARTED
```

정본:

- `기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md`
- `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
- `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
- `docs/decisions/SX_DEC_055_RUNTIME_SEMANTIC_POC.md`
- `docs/superpowers/specs/2026-08-10-runtime-semantic-poc-design.md`
- `docs/superpowers/plans/2026-08-10-sx-dec-055-runtime-semantic-poc.md`

`ACTIVE_CONTEXT.md`가 현재 실행 순서를 소유한다. 이 Roadmap의 오래된 validation lane을 현재 즉시 실행 작업으로 해석하지 않는다.

## 현재 재개 계약

사용자의 2026-08-10 최신 지시에 따라 `SX-DEC-055` runtime POC 구현은 **승인 취소가 아니라 실행 보류**다.

```yaml
sx_dec_055_decision: APPROVED
sx_dec_055_spec: APPROVED_AND_MERGED
sx_dec_055_dor_plan: MERGED
sx_dec_055_runtime_implementation: USER_DEFERRED_AFTER_DOR · NOT_STARTED
runtime_integrated: false
resume_requires_new_approval_for_same_scope: false
resume_requires_live_authority_refresh: true
```

사용자가 나중에 재개를 명시하면 다음 순서로 이어간다.

```text
Base current structure/latest main 재조회
→ project current main/open PR/latest commit 재조회
→ configured Sheet SX-DEC-055 재조회
→ owner docs + actual code/test/manifests 충돌 검사
→ plan exact-file assumptions 재검증
→ Task 1 / Step 1.1 RED
```

새 gameplay/product/semantic 결정이나 승인 범위 확장이 없으면 동일 승인 reference를 재사용한다.

## 완료된 기반

### M0 — 제품 기준선·실행 계약 · PASS

- [x] finite delivery product pivot
- [x] `SX-DEC-027~036` finite baseline decisions
- [x] correct Sheet same-ID sync and readback
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
- [x] 실패 후 same-layout retry/fresh runtime
- [x] persistent branch direct selection and occupied lock

### M3 — PC Vertical Slice / route refinement · IMPLEMENTED_WITH_OPEN_MANUAL_GATES

- [x] F5 Title → Briefing → BUILD → RUN → Result flow implemented
- [x] recommended route automated proof
- [x] reciprocal one-sided station parity automated proof
- [x] mid-run exit automated contract
- [x] ROUTE_END implementation and automated proof
- [x] three-direction switch arrows/direct select/U-turn/occupied lock implementation and automated proof
- [x] cargo pickup marker hide/retry restore implementation and bounded user F5 proof
- [ ] full PC manual flow closure
- [ ] Windows physical exported-artifact runtime/visual/audio/input smoke

Current detailed decision/evidence status is owned by `CURRENT_CONFIRMED_DECISIONS.md`; do not revive old PR #83~100 pending labels from historical Active Context.

### M4 — Visual planning and production package · COMPLETE

- [x] `SX-DEC-050` finite visual component/requirement package
- [x] `SX-DEC-051` E+D hybrid source candidate package
- [x] `SX-DEC-053` 39 product assets + authoritative slice batch 1
- [x] `SX-DEC-054 RUN_2A` 20 semantic assets
- [x] `SX-DEC-054 BUILD_2B` 8 semantic assets / reusable compositions
- [x] `SX-DEC-054 VFX_2C` 6 semantic assets / 8 standard+Reduced Motion event pairs
- [x] total physical product PNGs = 73
- [x] legacy unnamed atlas regions remain reference-only/non-authoritative
- [ ] runtime hookup — intentionally separate under SX-DEC-055

### M5 — SX-DEC-055 Runtime Semantic POC · APPROVED_DOR · USER_DEFERRED

Authority:

- `docs/decisions/SX_DEC_055_RUNTIME_SEMANTIC_POC.md`
- `docs/superpowers/specs/2026-08-10-runtime-semantic-poc-design.md`
- `docs/superpowers/plans/2026-08-10-sx-dec-055-runtime-semantic-poc.md`

Completed:

- [x] runtime POC decision approval
- [x] written spec approval
- [x] PR #135 decision/spec merge
- [x] exact-file RED-first implementation plan/DoR
- [x] PR #136 DoR/registry merge

Deferred, not started:

- [ ] SemanticAssetCatalog RED/GREEN
- [ ] pure semantic runtime-state resolver RED/GREEN
- [ ] manual-load actual-state projection
- [ ] representative HUD/BUILD/route/VFX integration
- [ ] Reduced Motion runtime information-equivalence proof
- [ ] exact-head implementation regression/Windows export when applicable

Status: `USER_DEFERRED_AFTER_DOR · GODOT_IMPLEMENTATION_NOT_STARTED · runtime_integrated=false`.

## 별도 검증·출시 Lane

이 Lane들은 여전히 유효하지만 **현재 인수인계 세션의 즉시 실행 작업이 아니다.** 자동화 또는 SX-DEC-055 결과로 PASS를 대체하지 않는다.

`CANONICAL MAIN APK EXPORT · PASS`는 기존 canonical Android 패키징/해시 무결성 증거다. 이 PASS는 물리 Android 실행, 화면, 입력, 성능 또는 사람 이해도 PASS를 의미하지 않는다.

### M6 — Android Device Smoke · OPEN_NOT_RUN

Authority:

- `기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_RUNBOOK.md`
- `기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_EVIDENCE_TEMPLATE.md`

- [ ] physical Android landscape device record
- [ ] install / first boot / cold reboot
- [ ] BUILD / preflight / RUN / pause-resume / result / retry-edit
- [ ] LOAD hold / auto-load / route controls / occupied lock
- [ ] safe area / touch target / clipping / overlap / input omission
- [ ] crash / ANR / script error / severe frame degradation check
- [ ] reviewed evidence closure

Status: `NOT_RUN`.

### M7 — Five-person Comprehension · OPEN_BLOCKED_BY_DEVICE_GATE

- [ ] first-contact sessions
- [ ] LIFO TOP comprehension
- [ ] route revisit comprehension
- [ ] same-layout retry vs edit comprehension
- [ ] color-independent shape/text recognition

Status: `NOT_RUN`.

### M8 — Production Cutover Review · BLOCKED_DEFERRED

- [ ] required physical/device/human evidence
- [ ] P0/P1 open finding 0
- [ ] production entrypoint/package/signing review
- [ ] release compliance / asset rights evidence completion

Status: `BLOCKED_DEFERRED`.

## 추가 보류 항목

- `.asset-vault` legacy untrack: `DEFERRED_PENDING_LOCAL_PRESERVATION_ATTESTATION`
- connected physical Godot/Hera authoring validation: `NOT_RUN`
- broader human/comprehension beyond recorded feature-scoped user F5 evidence: `NOT_RUN`

## 후속 제품 Roadmap

다음은 승인된 기존 결정 또는 장기 backlog이며 현재 SX-DEC-055 handoff와 섞지 않는다.

### Scoring / campaign / challenge

- `SX-DEC-033`: speed/cost/score stars + leaderboard · `APPROVED · NOT_STARTED`
- `SX-DEC-034`: tutorial/theme chapter · `APPROVED · NOT_STARTED`
- `SX-DEC-035`: daily/weekly fixed-seed challenge · `APPROVED · NOT_RUN`

### Release / content expansion

- final production validation and icon/store package
- localization/accessibility stress
- official map/content expansion
- Google Play rating/target audience/store consistency
- asset-rights/provenance completion

새로운 구체 콘텐츠·규칙·과금·온라인 범위는 기존 승인 범위를 넘으면 별도 사용자 결정을 요구한다.

## 역사 경계

- endless survival, fuel/fuel-zero, player BOOST, cargo capacity 8, cargo-count slowdown, pickup respawn, switch auto-reset은 `LEGACY_IMPLEMENTATION · HISTORICAL_EVIDENCE`다.
- old VS03 queue와 과거 Android-immediate Roadmap 표시는 당시 상태 기록일 뿐 현재 next-executable 권위가 아니다.
- 과거 구현·감사·계획은 계보를 보존하지만 현재 작업 순서는 `ACTIVE_CONTEXT.md`와 최신 사용자 지시가 결정한다.
