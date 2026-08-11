# Roadmap

Last updated: `2026-08-11 KST`

## Current execution overlay

```text
GMB-002 · SX-DEC-027~055
→ finite delivery core implemented with automated evidence
→ route-end / switch direction / cargo pickup merged with bounded user F5 evidence
→ SX-DEC-053/054 semantic asset production complete: 73 product PNGs
→ SX-DEC-055 Runtime Semantic POC decision/spec/DoR approved and merged
→ PHASE A COMPLETE
→ user explicit "기획 완료" GRANTED · 2026-08-11 KST
→ PHASE B FINAL PLANNING REVIEW PASS · SX-AUD-047
→ PHASE-B CANON/SHEET SYNC
→ SX-DEC-055 Task 1 / Step 1.1 RED
```

## Milestones

### M0 · Product baseline

`PASS`

- finite handcrafted delivery puzzle
- current product baseline `GMB-002`
- decisions `SX-DEC-027~055`
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

### M7 · Five-person Comprehension

`NOT_RUN · BLOCKED BY M6A`

- recruit target 6
- minimum analyzable first-contact sessions 5
- FS-01~FS-12
- behavior → prediction → explanation → transfer
- unresolved P0/P1 comprehension/accessibility finding = 0 for PASS.

### M8 · Production cutover

`BLOCKED_DEFERRED`

Requires separate decision after implementation + physical/device/human evidence. Automated or hosted export evidence cannot authorize cutover.

## Future product roadmap — nonblocking for SX-DEC-055

These approved/future product packages are intentionally outside the current POC implementation scope:

- `SX-DEC-033` speed/cost/score stars + leaderboard — APPROVED · NOT_STARTED
- `SX-DEC-034` tutorial/theme chapter — APPROVED · NOT_STARTED
- `SX-DEC-035` daily/weekly fixed-seed challenge — APPROVED · NOT_RUN
- localization/accessibility stress beyond the bounded POC
- official map/content expansion
- Google Play store/rating/target-audience consistency
- remaining asset-rights/provenance completion.

They do not block the current authorized runtime semantic POC.

## Protected boundaries

- no gameplay/domain widening during M5;
- no new event solely for semantic art;
- no Base repin;
- no product PNG/semantic sidecar rewrite;
- no historical provenance mutation;
- no `.asset-vault` cleanup;
- no physical/device/human PASS inflation;
- no production cutover implication.
