# Roadmap

Last updated: `2026-08-11 KST`

## Current execution overlay

```text
GMB-002 · SX-DEC-027~058
→ finite delivery core implemented with automated evidence
→ route-end / switch direction / cargo pickup merged with bounded user F5 evidence
→ SX-DEC-053/054 semantic asset production complete: 73 product PNGs
→ SX-DEC-055 Runtime Semantic POC decision/spec/DoR approved and merged
→ PHASE A COMPLETE
→ user explicit "기획 완료" GRANTED · 2026-08-11 KST
→ PHASE B FINAL PLANNING REVIEW PASS · SX-AUD-047
→ PHASE-B CANON/SHEET SYNC
→ SX-DEC-055 Task 1 / Step 1.1 RED when Phase C resumes

Post-Phase-B additive planning:
SX-BMK-001 R01~R08 user-approved
→ SX-DEC-056 / SX-DEC-057 / SX-DEC-058
→ SX-DEC-056A delta DoR planning PASS · implementation not authorized
→ SX-DEC-056B blocked by authoritative score/combo runtime metrics
→ SX-DEC-057/058 delta DoR pending
→ R09/R10 POST_VALIDATION_HOLD
```

## Milestones

### M0 · Product baseline

`PASS`

- finite handcrafted delivery puzzle
- current product baseline `GMB-002`
- decisions `SX-DEC-027~058`
- historical endless/fuel/BOOST family is non-current.

### M1 · Representative buildable map

`PASS`

- finite buildable representative map
- structural reachability/preflight
- recommended layout evidence.

### M2 · Finite delivery core

`PASS · AUTOMATED`

- free rail build with blocked cells
- cost/refund
- manual/auto load
- unlimited LIFO
- route controls
- contiguous TOP unload
- time/failure/success/retry.

### M3 · PC vertical slice

`IMPLEMENTED · AUTOMATED CORE PASS · MANUAL GATES OPEN`

Open evidence:

- full PC local route/mid-run retest
- Windows exported-artifact physical runtime/visual/audio/input smoke.

### M4 · Production visual/semantic package

`PASS · PRODUCTION COMPLETE`

```yaml
SX-DEC-053_product_assets: 39
SX-DEC-054_RUN_2A: 20
SX-DEC-054_BUILD_2B: 8
SX-DEC-054_VFX_2C: 6
total_product_pngs: 73
runtime_integrated: false
```

### M5 · SX-DEC-055 Runtime Semantic POC

`BUILD AUTHORIZED · IMPLEMENTATION NOT_STARTED`

Phase B readiness:

```yaml
phase_a: COMPLETE
user_planning_complete_gate: GRANTED
phase_b: PASS · SX-AUD-047
implementation_dor: PASS
build_authority_scope: SX-DEC-055_ONLY
first_step: Task 1 / Step 1.1 RED
```

Approved architecture:

```text
product semantic manifests
→ presentation-owned SemanticAssetCatalog
→ pure semantic runtime-state mapping
→ existing presenter/snapshot/events
→ HUD + BUILD + route + event presentation
```

Mandatory Phase B amendment before final packaging acceptance:

- narrow non-resource JSON export inclusion for runtime map/semantic manifest directories;
- exported-pack proof that required JSON is readable;
- no broad unrelated JSON export;
- packaging proof is not physical runtime proof.

Owner:
`docs/superpowers/plans/2026-08-11-sx-dec-055-phase-b-readiness-amendment.md`

The user is temporarily spending the current work window on additional planning because Codex execution quota is unavailable. This does not cancel M5 authorization.

### M5B · Post-Phase-B approved product-depth planning

`USER_APPROVED · IMPLEMENTATION AUTHORITY SEPARATE FROM M5`

This lane is additive and does **not** enter the already-reviewed `SX-DEC-055` implementation package.

#### SX-DEC-056 · Route Causality Learning and Result Feedback

Approved product direction:

- route-causality feature triage language;
- request-only Route Probe / Encounter Strip;
- Prediction → Execution → Debrief;
- actual-event-only encounter trace;
- independent Fastest / Cheapest / Highest Score PBs;
- Route Fingerprint explanatory metadata.

Delta DoR review: `SX-AUD-051`.

Current split:

```yaml
056A_route_probe: DELTA_DOR_PASS_PLANNING
056A_actual_trace_debrief: DELTA_DOR_PASS_PLANNING
056A_fastest_cheapest_pb: DELTA_DOR_PASS_PLANNING
056A_fingerprint_v1: DELTA_DOR_PASS_PLANNING
056A_implementation_authority: NOT_GRANTED
056B_highest_score: BLOCKED_BY_AUTHORITATIVE_SCORE_RUNTIME
056B_score_max_combo_fingerprint: BLOCKED_BY_AUTHORITATIVE_RUNTIME_METRICS
```

056A exact implementation-ready contracts now include:

- Probe traversal starts from the first actual next entered cell, not the configured occupied start cell;
- LOOP = repeated directed `(previous,current)` traversal state;
- `next_cell == current` = DEAD_END;
- graph construction failure = ROUTE_INVALID;
- Probe is ordered cell-step projection, not temporal event trace;
- station mismatch evidence reuses the existing single `Station.try_unload()` result;
- route-control change is recorded only when existing `cycle_route_control()` actually accepts the change;
- fingerprint v1 is score-independent and exact;
- finite PB store is keyed by map ID + map revision + ruleset version;
- no-solution-leakage automated contracts are explicit.

Implementation plan:

`docs/superpowers/plans/2026-08-11-sx-dec-056-route-causality-delta.md`

056B cannot invent score/combo calculations. It begins only after existing approved score/combo authority exposes authoritative finite runtime metrics.

#### SX-DEC-057 · Yard Labs and Mastery Curriculum

`USER_APPROVED · DELTA_DOR_PENDING`

Approved:

- Stack Lab after Tutorial Stage 5 candidate unlock;
- Switch Lab after Stage 6;
- Builder Lab after Stage 8;
- Tutorial 1~10 exact order remains unchanged;
- optional Mastery Spur, not progression-required;
- Topology Complexity / Stack Entropy / Execution Branching authoring model.

Before implementation/content production:

- exact Lab content schema and allowed-rule whitelist;
- actual handcrafted Lab puzzle set with learning/failure/transfer objective;
- unlock/skip/re-entry/progression state;
- Mastery Spur content template/count/reward guardrails;
- numeric level-design calibration;
- scoped delta DoR/final review.

#### SX-DEC-058 · Fixed-Seed Challenge Quality Policy

`USER_APPROVED · DELTA_DOR_PENDING`

Approved:

- preserve Daily 1 / Weekly 1 fixed-seed procedural contract;
- deterministic challenge identity;
- structural validity gate;
- minimum one legal success proof before publication;
- offline solver/witness only;
- quality screening and immutable published identity;
- base rules only at initial launch.

Before implementation:

- exact solvability state/search algorithm boundary;
- deterministic generator/seed/version identity;
- generation/solver performance budget;
- generated-corpus size and calibration thresholds;
- degenerate/trivial/one-path rejection metrics;
- timeout/failure publication behavior;
- witness isolation proof;
- scoped delta DoR/final review.

Held outside current authority:

- BMK-R09 Shareable Route Card — `POST_VALIDATION_HOLD`;
- BMK-R10 Editor/Workshop/UGC — `POST_VALIDATION_HOLD`.

### M6 · Historical Android validation lane

`OPTIONAL DIAGNOSTIC · DEVICE SMOKE NOT_RUN`

Historical APK/package evidence must not be reused as the post-POC acceptance build.

### M6A · Post-POC acceptance build

`NOT_READY · BUILD ID UNASSIGNED`

This milestone begins only after the SX-DEC-055 implementation is merged and reviewed.

Sequence:

```text
exact merged implementation
→ assign exact acceptance-build identity
→ reviewed physical smoke on that exact build
```

The presence of approved SX-DEC-056~058 planning does not delay or silently alter this exact SX-DEC-055 acceptance lane unless a later explicit delta review intentionally includes player-facing changes in the tested build.

### M7 · Five-person Comprehension

`NOT_RUN · BLOCKED BY M6A`

- recruit target 6
- minimum analyzable first-contact sessions 5
- FS-01~FS-12
- behavior → prediction → explanation → transfer
- unresolved P0/P1 comprehension/accessibility finding = 0 for PASS.

If SX-DEC-056 or SX-DEC-057 is implemented before a future comprehension round, the tested acceptance build must include its exact identity and the test matrix must explicitly measure route-prediction/debrief and Lab transfer behavior. Previous human evidence must not be silently inherited across such player-facing changes.

### M8 · Production cutover

`BLOCKED_DEFERRED`

Requires separate decision after implementation + physical/device/human evidence. Automated or hosted export evidence cannot authorize cutover.

## Future product roadmap — nonblocking for SX-DEC-055

These approved/future product packages are intentionally outside the current POC implementation scope:

- `SX-DEC-033` speed/cost/score stars + leaderboard — APPROVED · NOT_STARTED; current finite runtime score field not exposed
- `SX-DEC-034` tutorial/theme chapter — APPROVED · NOT_STARTED
- `SX-DEC-035` daily/weekly fixed-seed challenge — APPROVED · NOT_RUN
- `SX-DEC-056A` route causality learning/result feedback — DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
- `SX-DEC-056B` Highest Score/score+combo extension — BLOCKED_DEPENDENCY
- `SX-DEC-057` Yard Labs/Mastery curriculum — APPROVED · DELTA_DOR_PENDING
- `SX-DEC-058` fixed-seed challenge publication quality — APPROVED · DELTA_DOR_PENDING
- localization/accessibility stress beyond bounded plans
- official map/content expansion
- Google Play store/rating/target-audience consistency
- remaining asset-rights/provenance completion.

They do not block the current authorized runtime semantic POC.

## Protected boundaries

- no gameplay/domain widening during M5;
- no SX-DEC-056A implementation without explicit implementation authority even though its delta DoR planning is complete;
- no SX-DEC-056B guessed score/combo formula;
- no SX-DEC-057/058 implementation before their delta DoR;
- no new event solely for semantic art;
- no Base repin;
- no product PNG/semantic sidecar rewrite;
- no historical provenance mutation;
- no `.asset-vault` cleanup;
- no physical/device/human PASS inflation;
- no production cutover implication;
- no R09/R10 implementation before post-validation approval.
