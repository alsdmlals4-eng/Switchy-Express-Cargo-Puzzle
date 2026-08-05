---
name: switchy-express-design
description: Use for Switchy Express finite-delivery gameplay, track construction, cargo encounter order, unlimited LIFO, persistent branch, Android device smoke, five-person comprehension, readability, retry, or product validation work.
---

# Switchy Express Design and Validation Discipline

## Purpose

이 Skill은 `Switchy Express: Cargo Puzzle`의 현 finite 제품 기획·검토·검증을 책임진다. 과거 endless 구현과 VS03 계획을 현재 제품 권위로 부활시키지 않고, 현재 승인 결정·실제 finite 코드·자동 증거·Android/HUMAN Gate를 연결한다.

## Read First

1. `기획서/00_프로젝트_허브/START_HERE.md`
2. `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
3. `기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md`
4. `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
5. `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md`
6. `기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_RUNBOOK.md`
7. `기획서/50_제작_검증/ANDROID_DEVICE_SMOKE_EVIDENCE_TEMPLATE.md`
8. `기획서/50_제작_검증/SX_AUD_019_ANDROID_APK_PIPELINE_PROBE.md`
9. `기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md`
10. actual finite code, Scenes, data and tests

`CURRENT_CONFIRMED_DECISIONS.md`가 현재 승인 결정, `ACTIVE_CONTEXT.md`가 현재 상태와 다음 작업, `DEVELOPMENT_GATES.md`가 Gate 차단 관계를 책임진다. 과거 VS03 계획·감사·실행문은 역사 증거이며 현재 실행 권위가 아니다.

## Current Product Authority

```text
track construction
→ cargo encounter order
→ manual/automatic loading
→ unlimited LIFO
→ route and persistent branch execution
→ TOP contiguous-group unloading
→ finite-time completion
→ time/cost/score redesign
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
VALIDATION PREPARATION: PASS
CANONICAL MAIN APK EXPORT: PASS
ANDROID DEVICE SMOKE: NOT_RUN · CURRENT
FIVE-PERSON COMPREHENSION: NOT_RUN · BLOCKED_BY_ANDROID
DEFAULT ENTRYPOINT: LEGACY
PRODUCTION CUTOVER: BLOCKED
```

Canonical validation binary:

```yaml
source_commit: 536911449018a3caf3511bc64e7bf1a66edf2016
apk_sha256: eb49225ab4062e5cf863f79a0d17f85d339ea176d7f0bb6f04096ed8a07559ea
package_id: com.alsdmlals4.switchyexpress.validation
```

### ANDROID DEVICE SMOKE route

Use this route for Android touch, device layout, stack readability, stability or validation APK work:

```text
full canonical APK hash verification
→ physical Android landscape device
→ AND-01~20 complete execution
→ privacy-safe evidence record
→ item completeness review
→ adversarial validation
→ reviewed Gate decision
```

Rules:

- use `ANDROID_DEVICE_SMOKE_RUNBOOK.md` and its evidence Template
- never treat emulator-only evidence as physical-device PASS
- never treat partial execution as full PASS
- bind all evidence to the full APK SHA-256
- a new APK invalidates inherited device/human evidence
- Android PASS does not imply Five-person or cutover PASS
- do not assign `SX-AUD-020` before actual reviewed evidence

### Five-person comprehension route

Only after reviewed Android PASS with the same APK hash:

- five first-contact participants, minimal aliases only
- no solution or route coaching
- observe TOP explanation, A-station revisit reasoning, failure recovery and retry distinction
- require shape/text comprehension without color-only dependence
- separate participant words, observed actions and facilitator interpretation

### Material user decisions

Ask one benchmark-backed Grill Me only when a choice changes:

- finite core loop or LIFO meaning
- BUILD/RUN authority
- loading or unloading semantics
- timer success/failure meaning
- major UX or accessibility interaction
- content scope, monetization, online policy or production cutover

Do not ask for facts available in canon, code, tests, APK evidence or device records. Safe technical corrections preserving approved meaning do not require a new Decision.

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
- validation launcher: proof/stack presentation only; not product authority

Presentation must not mutate layout, cargo, delivery, timer, result, retry identity or saves except through approved command boundaries.

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
python -m unittest tests.test_base_v94_ai_operations_adoption -v
python tests/python/test_android_smoke_canonical_freshness_contract.py -v
python tests/python/test_platform_release_asset_rights_contract.py -v
```

Never report an unexecuted command as PASS.

## Adversarial Review Lenses

- current finite authority replaced by historical endless assumptions
- stale VS03 package presented as next work
- LIFO meaning inverted or reduced to FIFO
- unlimited stack silently re-capped
- branch tap or occupied lock mismatch
- UI or animation becomes outcome authority
- manual/auto loading state not visible or not applied on next contact
- same-layout retry reuses stale mutable services
- APK hash mismatch or package mismatch
- emulator or partial matrix overstated as physical-device PASS
- color-only cargo/TOP identification
- safe-area clipping, overlap, missed touch or undersized target
- pause changes timer, movement, unload commit or stack state
- Android PASS overstated as HUMAN or production readiness
- historical files deleted instead of reclassified
- correct Sheet and wrong `19Ff...` workspace confused

## PR Gate

Every material package requires:

```text
latest main baseline
approved authority and scope
TDD RED observed for behavior change
focused GREEN
Project Contract success
Godot Tests success
JSON and whitespace checks
unresolved review threads 0
REQUEST_CHANGES 0
protected product file inventory
rollback documented
NOT_RUN evidence explicit
```

For Android readiness documents, product code, APK bytes, Android export workflow and default entrypoint must remain unchanged unless a separate approved package explicitly owns them.

## Output Contract

Depending on the request, produce one or more of:

- finite product design or review
- Android device smoke Runbook or evidence review
- five-person comprehension preparation or evidence review
- canonical-freshness finding and closure report
- Codex-ready implementation plan
- Gate decision with PASS/FAIL/BLOCKED/NOT_RUN and exact evidence ceiling

Always report which authority, exact commit/APK hash, tests and unresolved risks support the conclusion.
