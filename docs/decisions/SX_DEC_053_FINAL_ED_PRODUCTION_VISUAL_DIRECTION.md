# SX-DEC-053 · Final E+D Production Visual Direction

**Status:** `USER_APPROVED · MERGED_MAIN_VERIFIED · DISPOSITION_31_COMPLETE · IMPORT_SAFE_31_PROMOTED · HERO_CONTROLS_RECOVERED · CONTROL_NORMAL_BYTE_INTEGRITY_REPAIRED · RUNTIME_POC_DEFERRED`  
**Date:** 2026-08-09 KST  
**Baseline main:** `95dda145b518ce29bead78a5cbf5566cfa675419`  
**Product merge/main:** `57dbdd9be2cc70e0c9b973d502f57bd725b045cb` · PR `#122`

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

Current promoted asset count: **31**.

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
- text-safe progress/meta primitive.

No new concept board was created for this package. Wagon revisions and switch splits are deterministic transforms of tracked candidate bytes. Locomotive/control recovery uses the exact approved reference sources recorded by SHA-256 in the product manifest.

## Adversarial promotion findings and recovery

Deep PNG validation was strengthened from signature/dimension checks to chunk CRC + concatenated IDAT zlib validation.

Exactly two SX-DEC-051 candidate sources were found to have corrupt PNG streams:

1. `core/core_train_locomotive_blue_normal_v01.png`;
2. `ui/ui_button_controls_states_v01.png`.

The source candidates remain immutable provenance. Their final dispositions are `REPLACE`, and the product root contains import-safe recovery assets derived from the corresponding exact approved E+D references. The recovery records retain reference filename and SHA-256 instead of pretending the corrupt candidate bytes were usable.

Two wagon uploads also exposed a transport-integrity error during implementation: the first red/yellow Git blobs differed from the locally verified deterministic outputs. They were replaced by exact blobs matching the verified v02 bytes before acceptance.

A later recovery commit added the locomotive + seven control PNGs before authority metadata was updated. The CI-consumed promotion contract correctly failed because eight physical product PNGs were unmanifested. The fix updates only manifest/canonical metadata; the recovery PNG bytes are preserved unchanged.

The promoted `normal` control PNG then exposed an integrity-only container defect. Its exact recovered scanlines were preserved while the PNG zlib/CRC container was re-encoded. The accepted product manifest records Git blob `2ed8efe5911cd93a307aaafcefa713380014a581` and pixel SHA-256 `9c1e434448915882a11589d1a9dc067d296e3613d67245512a9623055a1804bc`; no pixel redesign was performed.

## Explicit pending semantic splits

Healthy source but still pending because the current source does not safely prove the complete product semantics:

- stack HUD semantic split, including a distinct next-unload-group state;
- remaining selected switch directions beyond the explicitly documented left-selected crop;
- train-cargo-strip composite after smaller-wagon hierarchy reconciliation;
- load-mode on/off naming because panel meaning is not authoritative enough to guess;
- BUILD placement/palette/preflight complete state split;
- VFX causal state split.

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
- runtime integration remains false.

## Exact-head and merged-main verification

PR `#122` was reviewed on the final implementation identity:

- `review_head_sha`: `e7a4f2e81355991cde632f0581baf62b6eb45a46`;
- `base_sha`: `95dda145b518ce29bead78a5cbf5566cfa675419`;
- `test_merge_sha`: `fd9e72f2fde02d0126e57c5fe86d573a4cf6cffd`;
- no PR-triggered workflow runs existed on the test-merge commit, so `ci_validation_target_sha` remained the exact review head;
- Project Contract `31316685124`: **PASS**, including `Validate final E+D product asset promotion`;
- GUT 9.7.1 `31316685079`: **PASS**, including JUnit discovery and protected-production-tree mutation guard;
- Godot Tests `31316685077`: **PASS**;
- Validate Thin Adapter Migration `31316685080`: **PASS**;
- Windows Demo Export `31316685064`: **PASS**;
- unresolved review threads: **0**.

The approved scope was squash-merged without reapproval as PR `#122`, producing main commit `57dbdd9be2cc70e0c9b973d502f57bd725b045cb`. Main readback confirms the merge commit is the current project main and contains the product package, manifest, static contract, Decision, and `SX-AUD-040` audit.

The merge commit itself has no separate PR-triggered workflow run. This is not reused as a new runtime/device claim; the exact reviewed PR head remains the technical merge evidence, and the merged main readback is the repository-delivery evidence.

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

Google Sheet synchronization is intentionally performed only after this same-ID merged-main closure is itself merged, so the Sheet can point at the final canonical main SHA rather than a closure branch SHA.
