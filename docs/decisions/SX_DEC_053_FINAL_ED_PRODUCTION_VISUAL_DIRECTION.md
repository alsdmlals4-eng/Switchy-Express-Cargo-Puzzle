# SX-DEC-053 · Final E+D Production Visual Direction

**Status:** `USER_APPROVED · FINAL_DIRECTION_APPROVED · DISPOSITION_31_COMPLETE · FIRST_PRODUCT_ASSET_BATCH_PARTIAL · IMPORT_SAFE_23_PROMOTED · LOCOMOTIVE_CONTROLS_REVISION_PENDING · FINAL_HEAD_RECHECK_REQUIRED · RUNTIME_POC_DEFERRED`  
**Date:** 2026-08-09 KST  
**Baseline main:** `95dda145b518ce29bead78a5cbf5566cfa675419`

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

Every source now has exactly one promotion disposition:

- `PROMOTE_AS_IS`: **18**;
- `PROMOTE_AFTER_REVISION`: **13**;
- `REPLACE`: **0**.

The candidate package remains intact for provenance.

## First product-asset batch

Product root: `art/product_assets/ed_hybrid_v1/`

Current promoted asset count: **23**.

Promoted groups:

- three deterministic smaller wagon v02 assets at `0.74` visual scale;
- cargo stars red/blue/yellow;
- stations red/blue/yellow;
- committed straight/curve/crossing/three-way-switch rail primitives;
- start and route-end markers;
- switch `left_selected` and `locked` documented slices;
- Reduced Motion-compatible combo primitive;
- ghost-route primitive;
- cost-HUD primitive;
- text-safe success/failure result shells;
- text-safe progress/meta primitive.

No new concept board or generative image was created for this batch. Wagon revisions and switch splits are deterministic transforms of tracked candidate bytes.

## Adversarial promotion findings

Deep PNG validation was intentionally strengthened from signature/dimension checks to chunk CRC + concatenated IDAT zlib validation.

Exactly two SX-DEC-051 candidate sources were found to have corrupt PNG streams:

1. `core/core_train_locomotive_blue_normal_v01.png`;
2. `ui/ui_button_controls_states_v01.png`.

The locomotive was initially reused into the product root and Godot correctly rejected it with `ERR_FILE_CORRUPT`. The promotion was reverted without touching the source candidate. Its disposition is now `PROMOTE_AFTER_REVISION` and it requires an import-safe revision while preserving the approved hero design.

The controls atlas is also `PROMOTE_AFTER_REVISION`; seven button-state extraction is blocked until an import-safe re-encode/replacement exists. It was not promoted as broken product art.

Two wagon uploads also exposed a transport-integrity error during implementation: the first red/yellow Git blobs differed from the locally verified deterministic outputs. They were replaced by exact blobs matching the verified v02 bytes before the batch was accepted.

## Explicit pending states

Healthy source but still pending because the current source does not safely prove the complete product semantics:

- stack HUD semantic split, including a distinct next-unload-group state;
- remaining selected switch directions beyond the explicitly documented left-selected crop;
- train-cargo-strip composite after smaller-wagon hierarchy reconciliation;
- load-mode on/off naming because panel meaning is not authoritative enough to guess;
- BUILD placement/palette/preflight complete state split;
- VFX causal state split.

These are not reported as promoted or complete.

## Static contract

`tests/python/test_final_ed_product_asset_promotion.py` and `tools/validate_final_ed_product_asset_promotion.py` require:

- source candidate authority remains SX-DEC-051 with 31 records;
- product authority is SX-DEC-053;
- all 31 dispositions are unique and complete;
- `PROMOTE_AS_IS` source PNGs are deeply decodable;
- promoted PNGs pass signature, chunk CRC, IDAT decompression, dimensions, and transparency checks;
- palette PNG + `tRNS` counts as alpha-capable;
- every physical product PNG is manifested exactly once;
- wagon visual scale remains in `0.70..0.75` with centered-scale provenance;
- runtime integration remains false.

## Boundaries

Still deferred / NOT_RUN:

- locomotive import-safe final revision;
- controls seven-state import-safe revision;
- remaining pending state splits listed above;
- Godot Scene/Resource/Theme/Animation/signal hookup;
- runtime sprite/HUD integration and POC;
- Windows physical runtime;
- Android device validation;
- connected physical editor validation;
- human comprehension/playtest validation;
- `.asset-vault` legacy untrack pending local preservation evidence;
- release cutover.
