---
name: switchy-express-design
description: Use for Switchy Express finite-delivery gameplay, track construction, cargo encounter order, unlimited LIFO, persistent branch, first-session validation, Android device smoke, five-person comprehension, readability, retry, or product validation work.
---

# Switchy Express Design and Validation Discipline

## Purpose

이 Skill은 `Switchy Express: Cargo Puzzle`의 현 finite 제품 기획·검토·검증을 책임진다. 과거 endless 구현, VS03 계획, 오래된 Android-first gate를 현재 제품 권위로 부활시키지 않고, 현재 승인 결정·실제 finite 코드·SX-DEC-059 merged implementation·acceptance evidence를 연결한다.

## Read First

1. fresh Base latest completed `main` + Base root `AGENTS.md`
2. `AGENTS.md`
3. `PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.8_SWITCHY_ADAPTER.md`
4. `기획서/00_프로젝트_허브/START_HERE.md`
5. `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
6. `기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md`
7. `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
8. `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md`
9. `기획서/50_제작_검증/SX_DEC_059_RELEASE_NEAR_FIRST_SESSION_VERTICAL_SLICE.md`
10. `기획서/50_제작_검증/SX_DEC_059_ACCEPTANCE_CANDIDATE_01.md`
11. `기획서/50_제작_검증/SX_DEC_059_DEVELOPER_SELF_RUN_RECORD.md`
12. actual finite code, Scenes, data and tests

`CURRENT_CONFIRMED_DECISIONS.md`가 현재 승인 결정, `ACTIVE_CONTEXT.md`가 현재 상태와 다음 작업, `DEVELOPMENT_GATES.md`가 Gate 차단 관계를 책임진다. 과거 v4.7 adapter, VS03 계획·감사·실행문, 이전 Android APK package는 history/rollback/diagnostic evidence이며 current execution authority가 아니다.

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
SX59-ACCEPT-001 ARTIFACT INTEGRITY: PASS · PREPARATION_ONLY
DEVELOPER SELF-RUN / SCREEN QA: NOT_RUN · CURRENT
EXACT ACCEPTANCE BUILD: NOT_YET_DESIGNATED
WINDOWS PHYSICAL SMOKE: NOT_RUN
ANDROID DEVICE SMOKE: NOT_RUN
FIVE-PERSON COMPREHENSION: NOT_RUN
PLAYER EXPERIENCE: NOT_RUN
PRODUCTION CUTOVER: BLOCKED_DEFERRED
```

Current validation sequence:

```text
developer self-run / screen QA
→ exact acceptance build
→ Windows physical smoke
→ Android device smoke
→ Five-person first-contact comprehension
→ product decision
```

`SX59-ACCEPT-001`의 hash/artifact integrity PASS는 acceptance build designation, physical runtime, human comprehension, player experience PASS가 아니다.

### Historical Android packaging evidence

과거 canonical Android validation binary:

```yaml
source_commit: 536911449018a3caf3511bc64e7bf1a66edf2016
apk_sha256: eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
package_id: com.alsdmlals4.switchyexpress.validation
status: HISTORICAL_PACKAGING_DIAGNOSTIC_EVIDENCE
```

이 binary와 과거 Android runbook은 Android-specific regression/diagnostic reference로 쓸 수 있지만 post-SX-DEC-059 exact acceptance build를 대신하지 않는다.

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

Legacy code and tests may remain for history, migration analysis or isolated regression, but they do not define current product completion, current package authority or future design. Never combine their assertion counts with finite PASS evidence unless the evidence explicitly distinguishes both suites.

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

Use the repository custom runner:

```bash
./Godot_v4.7.1-stable_linux.x86_64 \
  --headless --path . --script res://tests/run_tests.gd
```

Each suite extends `res://tests/test_case.gd` and implements `func run() -> void`. Do not use nonexistent single-suite runners or unsupported test APIs.

Relevant static contracts:

```bash
python tools/validate_project_contract.py
python tests/python/test_v48_current_authority_migration.py -v
python tests/python/test_sx_dec_059_implementation_canonical_freshness.py -v
python tests/python/test_android_smoke_canonical_freshness_contract.py -v
python tests/python/test_platform_release_asset_rights_contract.py -v
```

Never report an unexecuted command as PASS.

## Adversarial Review Lenses

- current finite authority replaced by historical endless assumptions
- v4.7/current Base authority drift reintroduced
- Google Sheets promoted from migration compatibility back to active workspace
- stale VS03/Android-first package presented as next work
- LIFO meaning inverted or reduced to FIFO
- unlimited stack silently re-capped
- branch tap or occupied lock mismatch
- UI or animation becomes outcome authority
- manual/auto loading state not visible or not applied on next contact
- same-layout retry reuses stale mutable services
- acceptance candidate integrity overstated as acceptance build/physical PASS
- emulator or partial matrix overstated as physical-device PASS
- color-only cargo/TOP identification
- safe-area clipping, overlap, missed touch or undersized target
- pause changes timer, movement, unload commit or stack state
- device PASS overstated as HUMAN or production readiness
- historical files deleted instead of reclassified

## PR Gate

Every material package requires:

```text
latest main baseline
approved authority and scope
TDD RED observed for behavior/contract change
focused GREEN
Project Contract success
Godot Tests success when relevant
JSON and whitespace checks
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
- developer self-run / acceptance evidence review
- Windows/Android physical smoke preparation or evidence review
- five-person comprehension preparation or evidence review
- canonical-freshness finding and closure report
- Codex-ready implementation plan
- Gate decision with PASS/FAIL/BLOCKED/NOT_RUN and exact evidence ceiling

Always report which authority, exact commit/build hash, tests and unresolved risks support the conclusion.
