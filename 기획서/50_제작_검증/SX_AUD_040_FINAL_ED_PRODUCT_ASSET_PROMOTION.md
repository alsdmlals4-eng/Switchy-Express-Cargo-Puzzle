# SX-AUD-040 · Final E+D Product Asset Promotion

**Date:** 2026-08-09 KST  
**Decision:** `SX-DEC-053`  
**Original baseline main:** `95dda145b518ce29bead78a5cbf5566cfa675419`  
**Original product PR:** `#122`  
**Original product merge/main:** `57dbdd9be2cc70e0c9b973d502f57bd725b045cb`  
**Prior canonical closure/main:** `9db05c0cc9866eb3e4a7f014a1cfe289aa4447bd` · PR `#123`  
**Semantic-slice continuation baseline:** `24d2e1121be7f967dfdd5246e1070cde4214772c`  
**Status:** `ORIGINAL_PRODUCT_MERGED_MAIN_VERIFIED · DISPOSITION_31_COMPLETE · IMPORT_SAFE_39_CURRENT_BRANCH · AUTHORITATIVE_SLICE_BATCH_1_PROMOTED · BATCH_1_EXACT_HEAD_VALIDATION_PENDING · RUNTIME_POC_DEFERRED`

## Scope

Audit the deterministic product-asset promotion work for the user-approved `E+D HYBRID · NEO-ARCADE READABILITY` direction, including the bounded authoritative semantic-slice continuation. This work is asset/provenance/static-contract only. It does not author Godot scenes/resources/themes/animations/signals and does not claim runtime integration.

## Test-first lineage

Legitimate RED/GREEN evidence was produced throughout PR #122:

- missing product authority RED: head `8930a9543b90711328e2210372d18a3fdcdf07ab`, Project Contract `31310286681` expected FAILURE;
- validator-absent RED: head `491ce03b8964f16a7beae5e2daac8f13653af23d`, Project Contract `31310521719` expected FAILURE;
- core-batch-absent RED: head `e6e03ee5921548251f6013ad53cbce411629c541`, Project Contract `31310641256` expected FAILURE;
- source-health recovery established PNG signature/chunk CRC/IDAT decompression/dimensions/transparency checks;
- the 23-asset intermediate batch passed Contract/GUT/Godot/Thin/Windows at `fc886198cebde08f6c57e04de46e8c1b07530d2d` before later hero/control recovery expanded the physical product set.

Earlier passing heads remain historical TDD/regression evidence only. The original merge gate used the final PR #122 exact head described below. The semantic-slice continuation has its own independent exact-head gate and is not considered PASS until that gate completes.

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

Original merged PR #122 product PNGs: **31**.  
Semantic-slice continuation branch product PNGs: **39**.

Coverage before the continuation:

- core world: blue hero locomotive, three smaller cargo wagons, red/blue/yellow cargo stars, red/blue/yellow stations, committed rail primitives, start/route-end markers;
- RUN: documented switch left-selected + occupied-lock slices and Reduced-Motion-compatible combo primitive;
- BUILD: ghost-route and cost-HUD primitives;
- UI: seven independent square-blue control states (`normal/hover/pressed/selected/disabled/locked/focus`);
- shells/meta: text-safe success/failure shells and progress primitive.

Semantic-slice continuation adds, on its branch only until merge:

- RUN Stack HUD: `run_stack_empty_v01`, `run_stack_32plus_v01`, `run_stack_unloading_v01`, `run_stack_top_highlight_v01`;
- BUILD placement/port: `build_track_straight_valid_ghost_v01`, `build_track_straight_invalid_ghost_v01`, `build_track_curve_valid_ghost_v01`, `build_port_marker_left_v01`.

The three cargo wagon v02 assets retain the approved centered visual scale **0.74** on the original 128×96 canvas. Gameplay collision/domain geometry is unchanged.

## Hero/control recovery

The corrupt historical locomotive candidate and control-atlas candidate were not overwritten. Product replacements were recovered under exact approved E+D reference provenance:

- locomotive reference SHA-256: `edd9b76558755e1fa603d5d3c373be57e9325055a2a1f5c92ff0b0bda88f5b8d`;
- controls reference SHA-256: `34f4fefeabdd0030b0689868899cd71e4cf694e475f12280bb75ea61aa25d6d7`.

A later exact-head CI attack exposed one additional transport-integrity defect in the promoted `normal` control PNG: its recovered scanline payload remained decodable only when the invalid zlib checksum trailer was ignored, while the stored PNG IDAT CRC/zlib checksum failed the strict validator.

Bounded recovery:

- no pixel redesign and no new concept generation;
- recovered the exact original scanlines from the existing promoted file;
- re-encoded only the PNG zlib/CRC container;
- repaired Git blob: `2ed8efe5911cd93a307aaafcefa713380014a581`;
- repaired-file SHA-256: `9c1e434448915882a11589d1a9dc067d296e3613d67245512a9623055a1804bc`;
- manifest records the integrity-only repair explicitly.

This preserves the approved visual pixels while restoring import-safe file integrity.

## Semantic-slice continuation · bounded authority proof

The continuation inspected the immutable `SX-DEC-051` candidate manifest before modifying product assets. Only two pending source atlases already had explicit named slices with crop bounds:

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

The branch's 39 product files are not a claim that every semantic split exists. Still deferred:

- remaining Stack HUD state coverage, especially distinct predicted next-unload-group semantics plus compact/intermediate/paused coverage;
- remaining selected switch directions beyond the documented current crop;
- train cargo strip reconciliation with the smaller-wagon hierarchy;
- load-mode atlas mapping for the already approved component states;
- remaining BUILD placement states plus track palette and complete preflight state split;
- causal VFX state split and Reduced Motion equivalents.

These remain `PROMOTE_AFTER_REVISION` work and do not justify inventing ambiguous semantics from current atlases.

## Original final exact-head validation

PR #122 final validation identity:

- `review_head_sha`: `e7a4f2e81355991cde632f0581baf62b6eb45a46`;
- `base_sha`: `95dda145b518ce29bead78a5cbf5566cfa675419`;
- `test_merge_sha`: `fd9e72f2fde02d0126e57c5fe86d573a4cf6cffd`;
- no PR-triggered workflow runs existed on the test-merge commit, therefore `ci_validation_target_sha = e7a4f2e81355991cde632f0581baf62b6eb45a46`.

Final exact-head results:

- Project Contract `31316685124`: **PASS**; focused `Validate final E+D product asset promotion` step **PASS**;
- GUT 9.7.1 `31316685079`: **PASS**; JUnit discovery and protected production tree verification **PASS**;
- Godot Tests `31316685077`: **PASS**;
- Validate Thin Adapter Migration `31316685080`: **PASS**;
- Windows Demo Export `31316685064`: **PASS**;
- unresolved review threads: **0**;
- PR Ready / mergeable at final check: **PASS**.

## Original adversarial scope check and merge

The final 41-file PR #122 diff was re-read before merge. It did not mutate:

- gameplay/domain code;
- `.tscn` scenes;
- Resource/Theme/Animation/signal authoring;
- `project.godot`;
- Godot AI/GUT/Hera plugin state;
- `.asset-vault` bytes.

PR `#122` was squash-merged with exact-head protection against `e7a4f2e81355991cde632f0581baf62b6eb45a46`.

- merge commit: `57dbdd9be2cc70e0c9b973d502f57bd725b045cb`;
- GitHub main readback: **PASS**;
- same-ID canonical closure PR `#123` later produced main `9db05c0cc9866eb3e4a7f014a1cfe289aa4447bd`.

The squash merge commits themselves have no separate PR-triggered workflow evidence. That absence is not converted into a runtime/device success claim; exact PR-head CI remains the technical merge evidence and merged-main ancestry/readback is repository-delivery evidence.

## Semantic-slice continuation validation state

Continuation branch: `agent/sx-dec-053-authoritative-slice-batch-1`  
Base: `24d2e1121be7f967dfdd5246e1070cde4214772c`

Before closure, the continuation must still satisfy:

- exact final implementation HEAD identity;
- Project Contract focused validator PASS;
- GUT/Godot/Thin and any scope-triggered export checks;
- branch-vs-main diff review proving no runtime/product-rule mutation;
- unresolved review threads = 0;
- mergeability and test-merge evidence classification;
- expected-head protected merge;
- merged-main readback;
- same-ID canonical closure for `SX-DEC-053` / `SX-AUD-040`;
- post-closure Google Sheet synchronization.

None of those pending continuation gates are pre-marked PASS here.

## Deferred gates

Preserved:

`ASSET_VAULT_UNTRACK_DEFERRED_EXTERNAL_EXECUTOR · VAULT_LOCAL_STATE_UNVERIFIED · RUNTIME_POC_DEFERRED · WINDOWS_PHYSICAL_NOT_RUN · ANDROID_DEVICE_NOT_RUN · CONNECTED_PHYSICAL_EDITOR_NOT_RUN · HUMAN_NOT_RUN`

## Closure and Sheet rule

The existing #123 closure remains valid historical evidence for the original 31-product batch. The semantic-slice continuation requires a new same-ID closure only after its own exact-head validation and merge; that closure must update this audit and `SX-DEC-053` without creating a new product Decision ID.

Google Sheet synchronization is intentionally performed after that closure is merged, using the closure merge/main SHA as the final canonical reference. The Sheet must preserve the same `SX-DEC-053` and `SX-AUD-040` IDs and must not claim runtime/device/human validation that was not run.
