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
→ SX-DEC-056A delta DoR PASS · implementation not authorized
→ SX-DEC-056B blocked by authoritative score/combo runtime metrics
→ SX-DEC-057 delta DoR PASS · implementation not authorized
→ SX-DEC-057 fast/cheap content blocked by Stage-8 track-attribute runtime
→ SX-DEC-058 delta DoR PASS · implementation not authorized
→ R01~R08 detailed planning closed
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

`R01~R08 DETAILED PLANNING CLOSED · IMPLEMENTATION AUTHORITY SEPARATE FROM M5`

This lane is additive and does **not** enter the already-reviewed `SX-DEC-055` implementation package.

#### SX-DEC-056 · Route Causality Learning and Result Feedback

Delta DoR: `SX-AUD-051`.

```yaml
056A_route_probe: DELTA_DOR_PASS_PLANNING
056A_actual_trace_debrief: DELTA_DOR_PASS_PLANNING
056A_fastest_cheapest_pb: DELTA_DOR_PASS_PLANNING
056A_fingerprint_v1: DELTA_DOR_PASS_PLANNING
056A_implementation_authority: NOT_GRANTED
056B_highest_score: BLOCKED_BY_AUTHORITATIVE_SCORE_RUNTIME
056B_score_max_combo_fingerprint: BLOCKED_BY_AUTHORITATIVE_RUNTIME_METRICS
```

Implementation plan:
`docs/superpowers/plans/2026-08-11-sx-dec-056-route-causality-delta.md`

Key contract:

- current player route only, no solver/recommended route;
- first actual entered cell starts Probe encounter order;
- exact LOOP/DEAD_END/ROUTE_INVALID semantics;
- actual-event-only Debrief;
- independent finite PB records;
- score-independent Fingerprint v1;
- score/max-combo extension waits for existing authoritative runtime truth.

#### SX-DEC-057 · Yard Labs and Mastery Curriculum

Delta DoR: `SX-AUD-052`.

`DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED`

Launch content blueprint:

```text
Stage 5 → Stack Lab   SL-01~04
Stage 6 → Switch Lab  SW-01~04
Stage 8 → Builder Lab BL-01~04
```

- initial total 12 micro puzzles;
- Lab lanes optional; lane internal order 01→04;
- completion mark only; no power/currency/XP/leaderboard;
- Mastery max 1 per chapter;
- 2 Core clears independently unlock both next chapter and current Mastery;
- Topology / Stack Entropy / Execution Branching authoring rubric fixed at 0..3;
- exact request-only hint boundary fixed;
- FS-16/17 human transfer/optionality linkage fixed.

Dependency-gated content:

- `BL-03 Fast vs Cheap`;
- `M-EXPRESS`;
- future BL-04 attribute variant.

Reason: current `TrackPiece` has no authoritative Stage-8 fast/cheap attribute representation. SX-DEC-057 does not invent that gameplay owner.

Catalog:
`기획서/20_시스템_콘텐츠/YARD_LAB_AND_MASTERY_CONTENT_CATALOG_V1.md`

Implementation/content plan:
`docs/superpowers/plans/2026-08-11-sx-dec-057-yard-labs-mastery-delta.md`

#### SX-DEC-058 · Fixed-Seed Challenge Quality Policy

Delta DoR: `SX-AUD-053`.

`DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED`

Implementation-ready planning contract:

- Daily UTC date and Weekly ISO-week canonical identity;
- versioned `SHA256_COUNTER_V1` deterministic entropy;
- `CONSTRUCTIVE_WITNESS_REPLAY_V1` legal-success existence proof;
- deterministic operation budgets;
- at least 2 structural layout alternatives;
- nontrivial cargo/stack/route quality gates;
- Daily one-primary-axis and Weekly multi-axis quality profiles;
- release calibration corpus minimum `1000 Daily + 1000 Weekly` candidates;
- deterministic map-hash parity and accepted-pool diversity thresholds;
- immutable publication identity + archive parity;
- private witness/generator artifacts excluded from runtime/export package;
- backend/transport remains separate authority.

Implementation plan:
`docs/superpowers/plans/2026-08-11-sx-dec-058-fixed-seed-quality-delta.md`

Held outside current authority:

- BMK-R09 Shareable Route Card — `POST_VALIDATION_HOLD`;
- BMK-R10 Editor/Workshop/UGC — `POST_VALIDATION_HOLD`.

### M6 · Historical Android validation lane

`OPTIONAL DIAGNOSTIC · DEVICE SMOKE NOT_RUN`

Historical APK/package evidence must not be reused as the post-POC acceptance build.

### M6A · Post-POC acceptance build

`NOT_READY · BUILD ID UNASSIGNED`

This milestone begins only after the SX-DEC-055 implementation is merged and reviewed.

```text
exact merged implementation
→ assign exact acceptance-build identity
→ reviewed physical smoke on that exact build
```

Approved post-Phase-B planning does not silently alter the exact SX-DEC-055 acceptance lane.

### M7 · Five-person Comprehension

`NOT_RUN · BLOCKED BY M6A`

- recruit target 6
- minimum analyzable first-contact sessions 5
- base FS-01~FS-12 + conditional 056/057 observations when those exact features/content are included
- behavior → prediction → explanation → transfer
- unresolved P0/P1 comprehension/accessibility finding = 0 for PASS.

### M8 · Production cutover

`BLOCKED_DEFERRED`

Requires separate decision after implementation + physical/device/human evidence. Automated or hosted export evidence cannot authorize cutover.

## Future product roadmap — nonblocking for SX-DEC-055

- `SX-DEC-033` speed/cost/score stars + leaderboard — APPROVED · NOT_STARTED; finite score runtime field not exposed
- `SX-DEC-034` tutorial/theme chapter — APPROVED · NOT_STARTED
- `SX-DEC-035` daily/weekly fixed-seed challenge — APPROVED · NOT_RUN
- `SX-DEC-056A` — DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
- `SX-DEC-056B` — BLOCKED_DEPENDENCY
- `SX-DEC-057` — DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
- `SX-DEC-057` fast/cheap content — BLOCKED_DEPENDENCY
- `SX-DEC-058` — DELTA_DOR_PASS_PLANNING · IMPLEMENTATION_NOT_AUTHORIZED
- localization/accessibility stress beyond bounded plans
- official map/content production
- Google Play store/rating/target-audience consistency
- remaining asset-rights/provenance completion.

## Protected boundaries

- no gameplay/domain widening during M5;
- no SX-DEC-056/057/058 implementation without separate explicit authority;
- no guessed score/combo formula;
- no invented fast/cheap TrackPiece field under 057;
- no challenge optimum/player-hint solver under 058;
- no new event solely for semantic art;
- no Base repin;
- no product PNG/semantic sidecar rewrite;
- no historical provenance mutation;
- no `.asset-vault` cleanup;
- no physical/device/human PASS inflation;
- no production cutover implication;
- no R09/R10 implementation before post-validation approval.
