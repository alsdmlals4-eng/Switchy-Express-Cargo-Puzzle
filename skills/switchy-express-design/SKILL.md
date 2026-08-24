---
name: switchy-express-design
description: Use for Switchy Express finite-delivery gameplay, track construction, cargo encounter order, unlimited LIFO, persistent branch, first-session validation, Candidate 003 physical/readability validation, Android device smoke, five-person comprehension, retry, or product validation work.
---

# Switchy Express Design and Validation Discipline

## Purpose

이 Skill은 `Switchy Express: Cargo Puzzle`의 현 finite 제품 기획·검토·검증을 책임진다. 과거 endless 구현, VS03 계획, 오래된 Android-first gate 또는 superseded Candidate 001/002를 current target으로 부활시키지 않고, 현재 승인 결정·실제 finite 코드·SX-DEC-059 merged implementation·current Candidate 003 evidence를 연결한다.

Current work-instruction route:

```yaml
work_instruction: v4.8 · 2026-08-24-r4 · SWITCHY_THIN_ADAPTER
work_instruction_source_sha256: 1426c2e5e25e32dc72abccf49e4a0839578e54c14b38ba0de045be426fd63ea6
base_policy: ALWAYS_REFETCH_CURRENT_COMPLETED_MAIN
```

## Read First

1. fresh Base latest completed `main` + Base root `AGENTS.md`
2. `AGENTS.md`
3. `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md`
4. `기획서/00_프로젝트_허브/START_HERE.md`
5. `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
6. `기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md`
7. `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
8. `evidence/acceptance/current_poc_candidate.json`
9. `기획서/50_제작_검증/SX_DEC_059_POC_ACCEPTANCE_CANDIDATE_03.md`
10. `기획서/50_제작_검증/SX_DEC_059_POC_DEVELOPER_SELF_RUN_RECORD_03.md`
11. `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md` + `ROADMAP.md`
12. actual finite code, Scenes, data and tests

`CURRENT_CONFIRMED_DECISIONS.md`가 현재 승인 결정, `ACTIVE_CONTEXT.md`가 현재 상태와 다음 작업, `current_poc_candidate.json`가 current candidate pointer, `DEVELOPMENT_GATES.md`가 Gate 차단 관계를 책임진다. 과거 v4.7/r2 adapter, Candidate 001/002 docs, VS03 계획, 이전 Android APK package는 history/rollback/diagnostic evidence이며 current execution authority가 아니다.

## Current Product Authority

```text
track construction
→ cargo encounter order
→ manual/automatic loading
→ unlimited LIFO
→ route and persistent branch execution
→ TOP contiguous-group unloading
→ finite-time completion
→ evidence-safe result / retry / edit
```

### Current invariants

- authored finite delivery stage
- free track construction except blocked cells
- per-piece construction cost and full refund during BUILD
- structural reachability preflight before RUN
- automatic train movement
- manual LOAD hold and auto-load toggle
- unlimited LIFO cargo stack
- last-loaded cargo is TOP
- only a contiguous same-type TOP group unloads at a matching station
- persistent branch state with direct branch tap before occupation
- occupied branch lock
- no track construction or removal during RUN
- finite timer failure while undelivered cargo remains
- immediate success when the final cargo commits delivery
- same-layout retry with fresh mutable runtime and attempt identity
- color plus silhouette plus text encoding
- landscape touch targets and safe-area requirements
- cosmetic-only fairness; no power progression
- UI, motion and presentation never own gameplay, score, save or identity authority

### Current Gate authority

```text
FINITE AUTOMATED CORE: PASS
SX-DEC-059 IMPLEMENTATION: MERGED_MAIN_VERIFIED · PR #158
PLAYABLE VISUAL/UX POC: MERGED_MAIN_VERIFIED · PR #166
CANDIDATE 002 WINDOWS STARTUP: PASS · HISTORICAL_PHYSICAL_EVIDENCE
CANDIDATE 002 ACCEPTANCE: BLOCKED_BY_CONFIRMED_P1_PREFLIGHT_VISUAL_DEFECTS
CURRENT CANDIDATE: SX59-POC-ACCEPT-003
CANDIDATE 003 PACKAGE/PCK/TEXTURE/POINTER: PASS
CANDIDATE 003 PHYSICAL VISUAL RECHECK: NOT_RUN · CURRENT
DEVELOPER SELF-RUN / SCREEN QA: NOT_RUN
AUDIO PERCEPTUAL QA: NOT_RUN
EXACT ACCEPTANCE BUILD: NOT_YET_DESIGNATED
WINDOWS FULL PHYSICAL SMOKE: NOT_RUN
ANDROID DEVICE SMOKE: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN
PLAYER EXPERIENCE: NOT_RUN
PRODUCTION CUTOVER: BLOCKED_DEFERRED
```

### Candidate 003 Gate 0

Before the normal self-run matrix, direct physical visual readback of `SX59-POC-ACCEPT-003` must confirm:

```text
A. physical visual recheck
   preflight badge compact + Korean problem copy non-overlap
B. physical visual recheck
   disconnected station/cargo color+shape+text identity visible + problem reinforcement outline only
```

If either A or B fails, return `BLOCKED_P1_VISUAL` and do not continue the self-run scenarios. If both PASS, keep the **same exact Candidate 003** for subsequent manual evidence.

Current validation sequence:

```text
SX59-POC-ACCEPT-003 · Candidate 003 Gate 0 · physical visual recheck
→ developer self-run / screen QA · 8 scenarios
→ audio perceptual QA
→ exact acceptance build
→ Windows full physical smoke
→ Android device smoke
→ Five-person first-contact comprehension
→ product decision
```

Candidate 002 startup PASS and Candidate 003 package integrity PASS do not imply corrected physical appearance, audio perception, acceptance build designation, device, human comprehension, or player-experience PASS.

### Historical Android packaging evidence

과거 canonical Android validation binary:

```yaml
source_commit: 536911449018a3caf3511bc64e7bf1a66edf2016
apk_sha256: eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
package_id: com.alsdmlals4.switchyexpress.validation
status: HISTORICAL_PACKAGING_DIAGNOSTIC_EVIDENCE
```

이 binary와 과거 Android runbook은 Android-specific regression/diagnostic reference로 쓸 수 있지만 current exact acceptance build를 대신하지 않는다.

### Android device smoke route

현재 exact acceptance build가 지정되고 Android physical validation을 수행할 때:

```text
exact acceptance build identity + full hash
→ physical Android landscape device
→ current Android smoke matrix
→ privacy-safe evidence record
→ item completeness review
→ adversarial validation
→ reviewed Gate decision
```

Rules:

- emulator-only evidence를 physical-device PASS로 올리지 않는다.
- partial execution을 full PASS로 올리지 않는다.
- evidence는 exact acceptance build identity/hash에 bind한다.
- new build는 inherited device/human evidence를 자동 승계하지 않는다.
- Android PASS does not imply Five-person or production cutover PASS.

### Five-person comprehension route

Five-person evidence는 같은 acceptance build의 physical validation 상태를 명시한 뒤 별도 human gate로 실행한다.

- five first-contact participants, minimal aliases only
- no solution or route coaching
- observe TOP/LIFO explanation, selective non-load/revisit reasoning, failure recovery, Retry/Edit distinction, switch execution
- require shape/text comprehension without color-only dependence
- separate participant words, observed actions and facilitator interpretation
- technical or device PASS를 human/player PASS로 승격하지 않는다.

### Material user decisions

Ask one benchmark-backed Grill Me only when a choice changes:

- finite core loop or LIFO meaning
- BUILD/RUN authority
- loading or unloading semantics
- timer success/failure meaning
- major UX or accessibility interaction
- content scope, monetization, online policy or production cutover

Do not ask for facts available in canon, code, tests, package evidence or current records. Safe technical/canonical corrections preserving approved meaning do not require a new Decision.

## Legacy Implementation Boundary

The following are `LEGACY_IMPLEMENTATION · HISTORICAL_EVIDENCE`:

- endless survival
- fuel and fuel-zero ending
- player BOOST input and BOOST uptime
- capacity eight cargo limit
- cargo-count slowdown
- pickup respawn
- switch auto-reset after passage
- timed speed/fuel pressure escalation
- old endless score authority
- old VS03-01/02/03/R1/04/05/06/07 package order

Legacy code and tests may remain for history, migration analysis or isolated regression, but they do not define current product completion, current package authority or future design.

## Architecture Boundaries

- `FiniteBuildSession`: BUILD edits, validation and sealing
- `TrackLayout`: authored/player track value
- `FiniteTrackGraph`: sealed routing graph
- `FiniteGameplayInputState`: manual/auto loading intent
- `UnlimitedCargoStack`: finite LIFO authority
- `FixedCargoField`: non-respawning authored cargo
- `FiniteDeliveryLoop`: contact and unload event integration
- `FiniteRunController`: timer, lifecycle, pause and outcome authority
- `FiniteRunSessionFactory`: fresh attempt object graph and identity
- `FiniteSlicePresenter`: read model only
- `FiniteSliceView`: visual state and input intent only
- `FirstSessionDefinition/StagePolicy/Director/Copy`: presentation-side onboarding owners

Presentation must not mutate layout, cargo, delivery, timer, result, retry identity or saves except through approved command boundaries.

## Deferred Package Boundary

```text
SX-DEC-056A: PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED
SX-DEC-056B: BLOCKED_BY_AUTHORITATIVE_SCORE_COMBO_RUNTIME
SX-DEC-057: PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED
SX-DEC-058: PLANNING_READY · IMPLEMENTATION_NOT_AUTHORIZED
```

Current validation work must not smuggle Route Probe/PB/Fingerprint, score/max-combo, Yard Labs/Mastery, or fixed-seed challenge pipeline into the product.

## Actual Test Contract

Use the repository custom runner when gameplay/runtime verification is relevant:

```bash
./Godot_v4.7.1-stable_linux.x86_64 \
  --headless --path . --script res://tests/run_tests.gd
```

Relevant static contracts include:

```bash
python tools/validate_project_contract.py
python tests/python/test_v48_current_authority_migration.py -v
python tests/python/test_sx_dec_059_implementation_canonical_freshness.py -v
python tests/python/test_candidate_003_postmerge_canon.py -v
python tests/python/test_current_poc_candidate_pointer.py -v
python tests/python/test_android_smoke_canonical_freshness_contract.py -v
python tests/python/test_platform_release_asset_rights_contract.py -v
```

Never report an unexecuted command as PASS.

## r4 Toolchain Boundary

- project engine canon is `Godot 4.7.1-stable`.
- local authoring/runtime uses fresh repo/location/git/update preflight.
- compatible shared exact Godot/Godot-AI pin + exact project/editor/session identity is preferred over per-project binary/port duplication.
- default Godot AI host ports are `8000/9500` when healthy; alternate ports are recovery exceptions.
- official update review + compatibility + rollback + canary + exact installed readback is required before safe auto-update; floating latest is forbidden.
- docs/Notion-only work does not require Editor/runtime proof.

## Adversarial Review Lenses

- current finite authority replaced by historical endless assumptions
- v4.7/r2 or stale Base authority drift reintroduced
- Google Sheets promoted from migration compatibility back to active workspace
- stale Candidate 001/002 or Android-first package presented as current next work
- Candidate 003 Gate 0 bypassed by starting self-run immediately
- LIFO meaning inverted or reduced to FIFO
- unlimited stack silently re-capped
- branch tap or occupied lock mismatch
- UI or animation becomes outcome authority
- manual/auto loading state not visible or not applied on next contact
- same-layout retry reuses stale mutable services
- acceptance candidate integrity overstated as physical/human PASS
- emulator or partial matrix overstated as physical-device PASS
- package audio presence overstated as audio perceptual PASS
- color-only cargo/TOP identification
- safe-area clipping, overlap, missed touch or undersized target
- pause changes timer, movement, unload commit or stack state
- device PASS overstated as HUMAN or production readiness
- historical files deleted instead of reclassified

## PR Gate

Every material package requires applicable evidence from:

```text
latest main baseline
approved authority and scope
TDD RED observed for behavior/contract change
focused GREEN
Project Contract success
Godot/GUT checks when repository change classification invokes them
unresolved review threads 0
REQUEST_CHANGES 0
protected product file inventory
rollback documented
NOT_RUN evidence explicit
```

For authority/readiness documents, product code, APK bytes, Android export workflow and gameplay/default product entrypoint remain unchanged unless a separate approved package explicitly owns them.

## Output Contract

Depending on the request, produce one or more of:

- finite product design or review
- Candidate 003 Gate 0 / developer self-run / acceptance evidence review
- Windows/Android physical smoke preparation or evidence review
- five-person comprehension preparation or evidence review
- canonical-freshness finding and closure report
- Codex-ready implementation plan
- Gate decision with PASS/FAIL/BLOCKED/NOT_RUN and exact evidence ceiling

Always report which authority, exact commit/build hash, tests and unresolved risks support the conclusion.
