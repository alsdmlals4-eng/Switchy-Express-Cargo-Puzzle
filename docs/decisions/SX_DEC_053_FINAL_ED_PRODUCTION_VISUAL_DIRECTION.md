# SX-DEC-053 · Final E+D Production Visual Direction

**Status:** `USER_APPROVED · MERGED_MAIN_VERIFIED · DISPOSITION_31_COMPLETE · IMPORT_SAFE_39_PROMOTED · AUTHORITATIVE_SLICE_BATCH_1_PROMOTED · HERO_CONTROLS_RECOVERED · CONTROL_NORMAL_BYTE_INTEGRITY_REPAIRED · SEMANTIC_SPLITS_PARTIAL · RUNTIME_POC_DEFERRED`  
**Date:** 2026-08-09 KST  
**Baseline main:** `95dda145b518ce29bead78a5cbf5566cfa675419`  
**Product merge/main:** `57dbdd9be2cc70e0c9b973d502f57bd725b045cb` · PR `#122`  
**Prior canonical closure/main:** `9db05c0cc9866eb3e4a7f014a1cfe289aa4447bd` · PR `#123`  
**Semantic-slice batch 1 merge/main:** `b02649dddc88a5340695cfd18ea5a54ffe0540f0` · PR `#125`

## Decision

`E+D HYBRID · NEO-ARCADE READABILITY` is the final production visual direction.

- the blue locomotive remains the moving-train hero anchor;
- trailing cargo wagons are visually subordinate, targeting approximately 70–75% of locomotive visual scale;
- the first deterministic implementation uses `visual_scale = 0.74` for red/blue/yellow wagon v02 assets;
- gameplay/domain collision and route geometry do not change because of this art ratio;
- D-style readability wins whenever E-style polish competes with puzzle information;
- no candidate is silently overwritten or automatically treated as runtime-integrated.

## Source authority

Source package: `art/production_candidates/ed_hybrid_v1/`  
Source Decision: `SX-DEC-051`  
Source candidate count: **31**

Every source has exactly one promotion disposition:

- `PROMOTE_AS_IS`: **18**;
- `PROMOTE_AFTER_REVISION`: **11**;
- `REPLACE`: **2**.

The candidate package remains intact for provenance. The two `REPLACE` sources are the corrupt locomotive candidate and corrupt controls atlas; neither is overwritten.

## Product-asset package

Product root: `art/product_assets/ed_hybrid_v1/`

Current promoted asset count: **39**.

Promoted/recovered groups:

- import-safe blue locomotive hero recovered from the exact approved E+D locomotive reference;
- three deterministic smaller wagon v02 assets at `0.74` visual scale;
- cargo stars red/blue/yellow;
- stations red/blue/yellow;
- committed straight/curve/crossing/three-way-switch rail primitives;
- start and route-end markers;
- switch `left_selected` and `locked` documented slices;
- Reduced Motion-compatible combo primitive;
- ghost-route primitive;
- cost-HUD primitive;
- seven reusable blue control states: normal / hover / pressed / selected / disabled / locked / focus, recovered from the exact approved E+D UI reference;
- text-safe success/failure result shells;
- text-safe progress/meta primitive;
- four Stack HUD slices whose names and crop bounds were already registered by `SX-DEC-051`;
- four BUILD placement/port slices whose names and crop bounds were already registered by `SX-DEC-051`.

No new concept board was created for batch 1. The eight files are deterministic crops of tracked candidate bytes using only pre-existing candidate-manifest slice names and bounds. No unnamed atlas region is assigned a new meaning.

## Adversarial promotion findings and recovery

Deep PNG validation was strengthened from signature/dimension checks to chunk CRC + concatenated IDAT zlib validation.

Exactly two SX-DEC-051 candidate sources were found to have corrupt PNG streams:

1. `core/core_train_locomotive_blue_normal_v01.png`;
2. `ui/ui_button_controls_states_v01.png`.

The source candidates remain immutable provenance. Their final dispositions are `REPLACE`, and the product root contains import-safe recovery assets derived from the corresponding exact approved E+D references. The recovery records retain reference filename and SHA-256 instead of pretending the corrupt candidate bytes were usable.

Two wagon uploads also exposed a transport-integrity error during implementation: the first red/yellow Git blobs differed from the locally verified deterministic outputs. They were replaced by exact blobs matching the verified v02 bytes before acceptance.

A later recovery commit added the locomotive + seven control PNGs before authority metadata was updated. The CI-consumed promotion contract correctly failed because eight physical product PNGs were unmanifested. The fix updates only manifest/canonical metadata; the recovery PNG bytes are preserved unchanged.

The promoted `normal` control PNG then exposed an integrity-only container defect. Its exact recovered scanlines were preserved while the PNG zlib/CRC container was re-encoded. The accepted product manifest records Git blob `2ed8efe5911cd93a307aaafcefa713380014a581` and pixel SHA-256 `9c1e434448915882a11589d1a9dc067d296e3613d67245512a9623055a1804bc`; no pixel redesign was performed.

## Authoritative semantic slice batch 1

This continuation resolves only the portion of the semantic-split backlog that is already unambiguous in the immutable `SX-DEC-051` candidate manifest.

### RUN · Stack HUD

Promoted as independent product PNGs:

- `run_stack_empty_v01` from `[70,74,44,18]`;
- `run_stack_32plus_v01` from `[70,16,42,18]`;
- `run_stack_unloading_v01` from `[69,44,45,18]`;
- `run_stack_top_highlight_v01` from `[10,8,42,25]`.

The source name `run_stack_unloading_v01` is retained exactly. This continuation does **not** reinterpret that crop as the distinct predicted next-unload-group state; the latter remains a separate semantic requirement until authority proves the mapping.

### BUILD · Placement preview

Promoted as independent product PNGs:

- `build_track_straight_valid_ghost_v01` from `[4,4,36,30]`;
- `build_track_straight_invalid_ghost_v01` from `[46,4,36,30]`;
- `build_track_curve_valid_ghost_v01` from `[88,4,36,30]`;
- `build_port_marker_left_v01` from `[6,53,30,26]`.

These are not reported as full BUILD state coverage. Rotate/replacement/placed semantics plus palette and complete preflight states remain separate.

### Contract boundary

Each of the eight records carries `authoritative_slice_name`. The static validator binds that name back to the exact source candidate record and rejects:

- a missing/unknown named slice;
- product filename drift from the named source slice;
- any crop-bound drift;
- dimension drift from the authoritative bounds;
- a partial batch count other than 0 or 8.

This locks provenance without inventing additional UI/domain semantics.

## Explicit pending semantic splits

Healthy source or approved component requirement, but still pending because complete atlas-to-state meaning is not sufficiently authoritative:

- remaining Stack HUD coverage beyond the four named slices, especially distinct predicted next-unload-group readability plus compact/intermediate/paused states;
- remaining selected switch directions beyond the explicitly documented left-selected crop;
- train-cargo-strip composite after smaller-wagon hierarchy reconciliation;
- load-mode atlas mapping: approved component states exist (`manual-idle`, `manual-held`, `auto-off`, `auto-on`, `paused-disabled`, `input-received`) but current source atlas regions are not authoritatively mapped to those names;
- remaining BUILD placement states plus track-palette and complete preflight state split;
- VFX causal state split and Reduced Motion equivalents.

These are not reported as complete.

## Static contract

`tests/python/test_final_ed_product_asset_promotion.py` and `tools/validate_final_ed_product_asset_promotion.py` require:

- source candidate authority remains SX-DEC-051 with 31 records;
- product authority is SX-DEC-053;
- all 31 dispositions are unique and complete;
- `PROMOTE_AS_IS` source PNGs are deeply decodable;
- promoted PNGs pass signature, chunk CRC, IDAT decompression, dimensions, and transparency checks;
- palette PNG + `tRNS` counts as alpha-capable;
- every physical product PNG is manifested exactly once;
- recovered locomotive and controls are registered as `REPLACE` and carry exact approved-reference SHA-256 provenance;
- wagon visual scale remains in `0.70..0.75` with centered-scale provenance;
- the eight batch-1 crop records exactly match their pre-existing `SX-DEC-051` named slices and bounds;
- runtime integration remains false.

## Prior exact-head and merged-main verification

PR `#122` was reviewed on the final implementation identity:

- `review_head_sha`: `e7a4f2e81355991cde632f0581baf62b6eb45a46`;
- `base_sha`: `95dda145b518ce29bead78a5cbf5566cfa675419`;
- `test_merge_sha`: `fd9e72f2fde02d0126e57c5fe86d573a4cf6cffd`;
- Project Contract `31316685124`: **PASS**;
- GUT 9.7.1 `31316685079`: **PASS**;
- Godot Tests `31316685077`: **PASS**;
- Validate Thin Adapter Migration `31316685080`: **PASS**;
- Windows Demo Export `31316685064`: **PASS**;
- unresolved review threads: **0**.

The approved scope was squash-merged as PR `#122`, producing main commit `57dbdd9be2cc70e0c9b973d502f57bd725b045cb`. A same-ID canonical closure followed in PR `#123`, producing `9db05c0cc9866eb3e4a7f014a1cfe289aa4447bd`.

## Batch 1 exact-head and merged-main verification

PR `#125` final implementation identity:

- `review_head_sha`: `4e07fa5247a8fe743b0917b3595ce97585da82e9`;
- `base_sha`: `24d2e1121be7f967dfdd5246e1070cde4214772c`;
- `test_merge_sha`: `32db76a79ab7a88f58969a836457f21b6aa6d732`;
- no PR-triggered workflow runs existed on the test-merge commit, therefore `ci_validation_target_sha = 4e07fa5247a8fe743b0917b3595ce97585da82e9`;
- Project Contract `31320609585`: **PASS**, including `Validate final E+D product asset promotion`;
- GUT 9.7.1 `31320609590`: **PASS**;
- Godot Tests `31320609574`: **PASS**;
- Validate Thin Adapter Migration `31320609566`: **PASS**;
- Windows Demo Export `31320609573`: **PASS**;
- unresolved review threads: **0**;
- final PR state: Ready · mergeable true.

PR `#125` was squash-merged with expected-head protection against `4e07fa5247a8fe743b0917b3595ce97585da82e9`, producing main commit `b02649dddc88a5340695cfd18ea5a54ffe0540f0`. GitHub main readback confirmed the merge commit and the 39-product package.

The merge commit itself does not create new runtime/device evidence. Exact reviewed PR-head CI remains the technical evidence, and merged-main ancestry/readback is repository-delivery evidence.

## Boundaries

Still deferred / NOT_RUN:

- remaining semantic state splits listed above;
- Godot Scene/Resource/Theme/Animation/signal hookup;
- runtime sprite/HUD integration and POC;
- Windows physical runtime;
- Android device validation;
- connected physical editor validation;
- human comprehension/playtest validation;
- `.asset-vault` legacy untrack pending local preservation evidence;
- release cutover.

Google Sheet synchronization is performed only after this same-ID canonical closure merges, using the closure main SHA as the final canonical reference.
