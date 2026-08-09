# SX-AUD-040 · Final E+D Product Asset Promotion

**Date:** 2026-08-09 KST  
**Decision:** `SX-DEC-053`  
**Original baseline main:** `95dda145b518ce29bead78a5cbf5566cfa675419`  
**Original product PR:** `#122`  
**Original product merge/main:** `57dbdd9be2cc70e0c9b973d502f57bd725b045cb`  
**Prior canonical closure/main:** `9db05c0cc9866eb3e4a7f014a1cfe289aa4447bd` · PR `#123`  
**Semantic-slice batch 1 baseline:** `24d2e1121be7f967dfdd5246e1070cde4214772c`  
**Semantic-slice batch 1 merge/main:** `b02649dddc88a5340695cfd18ea5a54ffe0540f0` · PR `#125`  
**Status:** `MERGED_MAIN_VERIFIED · DISPOSITION_31_COMPLETE · IMPORT_SAFE_39_PROMOTED · AUTHORITATIVE_SLICE_BATCH_1_PROMOTED · HERO_CONTROLS_RECOVERED · CONTROL_NORMAL_BYTE_INTEGRITY_REPAIRED · SEMANTIC_SPLITS_PARTIAL · RUNTIME_POC_DEFERRED`

## Scope

Audit the deterministic product-asset promotion work for the user-approved `E+D HYBRID · NEO-ARCADE READABILITY` direction, including the bounded authoritative semantic-slice continuation. This work is asset/provenance/static-contract only. It does not author Godot scenes/resources/themes/animations/signals and does not claim runtime integration.

## Test-first lineage

Legitimate RED/GREEN evidence was produced throughout PR #122:

- missing product authority RED: head `8930a9543b90711328e2210372d18a3fdcdf07ab`, Project Contract `31310286681` expected FAILURE;
- validator-absent RED: head `491ce03b8964f16a7beae5e2daac8f13653af23d`, Project Contract `31310521719` expected FAILURE;
- core-batch-absent RED: head `e6e03ee5921548251f6013ad53cbce411629c541`, Project Contract `31310641256` expected FAILURE;
- source-health recovery established PNG signature/chunk CRC/IDAT decompression/dimensions/transparency checks;
- the 23-asset intermediate batch passed Contract/GUT/Godot/Thin/Windows at `fc886198cebde08f6c57e04de46e8c1b07530d2d` before later hero/control recovery expanded the physical product set.

Earlier passing heads remain historical TDD/regression evidence only. Each merge gate below uses its own final exact PR head.

## Source-health result

All 31 `SX-DEC-051` source candidates have exactly one disposition.

Deep source scan result:

- healthy source PNGs: **29**;
- corrupt historical candidates: **2**;
- corrupt candidates: locomotive source and controls-atlas source;
- both corrupt sources remain preserved for provenance and are classified `REPLACE`, never `PROMOTE_AS_IS`.

Current disposition counts remain unchanged:

- `PROMOTE_AS_IS`: **18**;
- `PROMOTE_AFTER_REVISION`: **11**;
- `REPLACE`: **2**;
- total: **31**.

## Current promoted product set

Physical product PNGs after PR #125 merge: **39**.

Coverage:

- core world: blue hero locomotive, three smaller cargo wagons, red/blue/yellow cargo stars, red/blue/yellow stations, committed rail primitives, start/route-end markers;
- RUN: switch left-selected + occupied-lock slices, Reduced-Motion-compatible combo primitive, and four source-manifest-authoritative Stack HUD slices;
- BUILD: ghost-route, cost-HUD primitives, and four source-manifest-authoritative placement/port slices;
- UI: seven independent square-blue control states (`normal/hover/pressed/selected/disabled/locked/focus`);
- shells/meta: text-safe success/failure shells and progress primitive.

The three cargo wagon v02 assets retain the approved centered visual scale **0.74** on the original 128×96 canvas. Gameplay collision/domain geometry is unchanged.

## Hero/control recovery

The corrupt historical locomotive candidate and control-atlas candidate were not overwritten. Product replacements were recovered under exact approved E+D reference provenance:

- locomotive reference SHA-256: `edd9b76558755e1fa603d5d3c373be57e9325055a2a1f5c92ff0b0bda88f5b8d`;
- controls reference SHA-256: `34f4fefeabdd0030b0689868899cd71e4cf694e475f12280bb75ea61aa25d6d7`.

A later exact-head CI attack exposed one additional transport-integrity defect in the promoted `normal` control PNG. Bounded recovery preserved the exact recovered scanlines and re-encoded only the PNG zlib/CRC container:

- repaired Git blob: `2ed8efe5911cd93a307aaafcefa713380014a581`;
- repaired-file SHA-256: `9c1e434448915882a11589d1a9dc067d296e3613d67245512a9623055a1804bc`;
- no pixel redesign;
- manifest records the integrity-only repair explicitly.

## Semantic-slice batch 1 · bounded authority proof

The continuation inspected the immutable `SX-DEC-051` candidate manifest before modifying product assets. Only two pending source atlases already had explicit named slices with crop bounds used by this batch.

### Stack HUD source

`art/production_candidates/ed_hybrid_v1/run/run_stack_hud_states_v01.png`

- `run_stack_empty_v01` → `[70,74,44,18]`;
- `run_stack_32plus_v01` → `[70,16,42,18]`;
- `run_stack_unloading_v01` → `[69,44,45,18]`;
- `run_stack_top_highlight_v01` → `[10,8,42,25]`.

### BUILD placement source

`art/production_candidates/ed_hybrid_v1/build/build_placement_preview_states_v01.png`

- `build_track_straight_valid_ghost_v01` → `[4,4,36,30]`;
- `build_track_straight_invalid_ghost_v01` → `[46,4,36,30]`;
- `build_track_curve_valid_ghost_v01` → `[88,4,36,30]`;
- `build_port_marker_left_v01` → `[6,53,30,26]`.

The eight product PNGs are deterministic crops using those exact names and bounds. Product manifest records `authoritative_slice_name`; the static validator binds it back to the source manifest and rejects filename, bounds, dimensions, unknown-slice, or partial-batch drift.

No unnamed source-atlas region was assigned a product meaning. In particular:

- `run_stack_unloading_v01` remains `unloading`; it is not silently renamed to predicted next-unload-group;
- remaining switch-direction selections are not synthesized from the two documented switch slices;
- train cargo strip regions are not named before smaller-wagon composite reconciliation;
- load-mode atlas regions are not mapped merely because component authority defines desired runtime states;
- track-palette/preflight/VFX regions are not guessed.

This is a technical extraction of pre-existing authority, not a new product-direction decision.

## Still deferred inside the visual package

The 39 product files are not a claim that every semantic split exists. Still deferred:

- remaining Stack HUD state coverage, especially distinct predicted next-unload-group semantics plus compact/intermediate/paused coverage;
- remaining selected switch directions beyond the documented current crop;
- train cargo strip reconciliation with the smaller-wagon hierarchy;
- load-mode atlas mapping for the already approved component states;
- remaining BUILD placement states plus track palette and complete preflight state split;
- causal VFX state split and Reduced Motion equivalents.

These remain `PROMOTE_AFTER_REVISION` work and do not justify inventing ambiguous semantics from current atlases.

## Original PR #122 exact-head validation

- `review_head_sha`: `e7a4f2e81355991cde632f0581baf62b6eb45a46`;
- `base_sha`: `95dda145b518ce29bead78a5cbf5566cfa675419`;
- `test_merge_sha`: `fd9e72f2fde02d0126e57c5fe86d573a4cf6cffd`;
- Project Contract `31316685124`: **PASS**;
- GUT 9.7.1 `31316685079`: **PASS**;
- Godot Tests `31316685077`: **PASS**;
- Validate Thin Adapter Migration `31316685080`: **PASS**;
- Windows Demo Export `31316685064`: **PASS**;
- unresolved review threads: **0**.

PR `#122` was squash-merged with expected-head protection; merge commit `57dbdd9be2cc70e0c9b973d502f57bd725b045cb`. Same-ID closure PR `#123` produced `9db05c0cc9866eb3e4a7f014a1cfe289aa4447bd`.

## Semantic-slice batch 1 exact-head validation

PR `#125` final validation identity:

- `review_head_sha`: `4e07fa5247a8fe743b0917b3595ce97585da82e9`;
- `base_sha`: `24d2e1121be7f967dfdd5246e1070cde4214772c`;
- `test_merge_sha`: `32db76a79ab7a88f58969a836457f21b6aa6d732`;
- no PR-triggered workflow runs existed on the test-merge commit, therefore `ci_validation_target_sha = 4e07fa5247a8fe743b0917b3595ce97585da82e9`.

Exact-head results:

- Project Contract `31320609585`: **PASS**, including focused `Validate final E+D product asset promotion`;
- GUT 9.7.1 `31320609590`: **PASS**;
- Godot Tests `31320609574`: **PASS**;
- Validate Thin Adapter Migration `31320609566`: **PASS**;
- Windows Demo Export `31320609573`: **PASS**;
- unresolved review threads: **0**;
- Ready / mergeable true at final re-read.

## Batch 1 adversarial scope and merge

Baseline comparison contained **15 files**:

- 8 new PNG crops;
- product README + manifest;
- focused Python test + validator;
- `SX-DEC-053` decision document;
- final product asset list;
- this `SX-AUD-040` audit.

It did **not** mutate gameplay/domain code, `.tscn`, `project.godot`, Resource/Theme/Animation/signal authoring, plugin state, or `.asset-vault` bytes.

PR `#125` was squash-merged with exact-head protection against `4e07fa5247a8fe743b0917b3595ce97585da82e9`.

- merge commit: `b02649dddc88a5340695cfd18ea5a54ffe0540f0`;
- GitHub merged-main readback: **PASS**;
- current main contains the 39-product package and authoritative-slice validator contract.

The merge commit itself does not create physical-runtime evidence. Exact PR-head CI remains the technical merge evidence and merged-main ancestry/readback is repository-delivery evidence.

## Deferred gates

Preserved:

`ASSET_VAULT_UNTRACK_DEFERRED_EXTERNAL_EXECUTOR · VAULT_LOCAL_STATE_UNVERIFIED · RUNTIME_POC_DEFERRED · WINDOWS_PHYSICAL_NOT_RUN · ANDROID_DEVICE_NOT_RUN · CONNECTED_PHYSICAL_EDITOR_NOT_RUN · HUMAN_NOT_RUN`

## Closure and Sheet rule

This same-ID closure updates only `SX-DEC-053` and `SX-AUD-040` from batch-1 validation pending to the verified merged-main evidence above. It does not reopen the approved visual direction and does not mutate product assets or runtime surfaces.

Google Sheet synchronization is performed after this closure merges, using the closure merge/main SHA as the Sheet's final canonical reference. The Sheet preserves the same `SX-DEC-053` and `SX-AUD-040` IDs and must not claim runtime/device/human validation that was not run.
