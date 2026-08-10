# Final Product Asset List V1

Decisions: `SX-DEC-053` · `SX-DEC-054`  
Direction: `E+D HYBRID · NEO-ARCADE READABILITY`  
Status: `053_39 · RUN_2A_20 · BUILD_2B_8 · VFX_2C_6 · 73_TOTAL_PRODUCT_PNGS · VFX_2C_IMPLEMENTED_VALIDATION_PENDING · RUNTIME_NOT_INTEGRATED`

## Production hierarchy

- Blue locomotive = hero anchor.
- Red/blue/yellow trailing cargo wagons = `0.74` visual scale.
- Domain collision/route geometry is unchanged.
- Color semantics retain shape/marker redundancy.
- No localized copy is baked into reusable PNGs.
- `SX-DEC-054` reuses the approved E+D visual language and approved component-state/result authority.

## Product ownership

The shared root `art/product_assets/ed_hybrid_v1/` is partitioned into four pairwise-disjoint owners:

- `manifest.json` → `SX-DEC-053`: **39** PNGs;
- `semantic_manifest_sx_dec_054.json` → RUN Batch 2A: **20** PNGs;
- `semantic_manifest_sx_dec_054_build_2b.json` → BUILD Batch 2B: **8** PNGs;
- `semantic_manifest_sx_dec_054_vfx_2c.json` → VFX Batch 2C: **6** PNGs.

Expected physical total after VFX product merge: **73** PNGs.

Shared static ownership validation requires every owner list to be unique, all four sets pairwise disjoint, and their union equal every physical PNG under the product root.

## Baseline product package

`SX-DEC-053` remains the 39-asset E+D baseline with:
- blue locomotive hero recovery;
- three 0.74 trailing wagons;
- cargo/station color+shape products;
- committed rail and route-marker products;
- recovered 7-state UI controls;
- 8 exact manifest-authoritative named crops;
- exact source/disposition/recovery/integrity provenance.

No `SX-DEC-054` batch weakens these 053 checks.

## RUN Batch 2A · merged-main verified

Physical semantic assets: **20**.

Coverage:
- Stack HUD remainder;
- train cargo strip composition;
- load-mode semantics;
- switch selected/unselected/occupied-locked/inactive presentation.

Directional switch geometry remains procedural under `SX-DEC-042 · SX-DEC-046 · VIS-014`.

Product PR #129:
- exact head `34ab2b907190f69775ace8e89c32f689ba17bc35`;
- merge/main `35b93f3a15f35780b12cd4e8887c8e06f8ade72b`;
- exact-head Contract/GUT/Godot/Thin/Windows: PASS.

## BUILD Batch 2B · merged-main verified

Physical semantic assets: **8**.  
Semantic compositions: **28**.

Placement:
- `valid`;
- `invalid`;
- `rotate_preview`;
- `replacement_preview`.

Track palette:
- 4 forms × 5 interaction states = **20** semantic compositions;
- reuses existing committed rail silhouettes and existing normal/selected/disabled/focus/pressed UI frames;
- new form×interaction PNG count = **0**.

Preflight:
- `clear`;
- `primary_issue`;
- `multi_issue_summary`;
- `focused_location`.

Product PR #131:
- exact head `6efe4c71e88799f886f136c98d0c4a4396e58808`;
- merge/main `77276ec9b60aa91afd13f994ded8e0925e68be08`;
- Contract/GUT/Godot/Thin/Windows: PASS.

## VFX Batch 2C · implementation complete / exact-head validation pending

### Required event semantics

Eight information events:
- `cargo_pickup`;
- `cargo_unload`;
- `combo`;
- `route_selection`;
- `success`;
- `failure`;
- `route_end`;
- `time_expired`.

### Six new physical information glyphs

- `vfx/vfx_cargo_pickup_feedback_v01.png`;
- `vfx/vfx_cargo_unload_feedback_v01.png`;
- `vfx/vfx_success_feedback_v01.png`;
- `vfx/vfx_failure_feedback_v01.png`;
- `vfx/vfx_route_end_feedback_v01.png`;
- `vfx/vfx_time_expired_feedback_v01.png`.

All are 64×64 alpha-capable, text-free, shape-distinct, independently authored semantic assets. They do not claim an atlas crop.

### Two exact product reuses

- `combo` reuses `run/run_combo_feedback_static_v01.png`;
- `route_selection` reuses `run/run_switch_state_selected_overlay_v01.png`.

No redundant duplicate VFX PNG is created for these already-authoritative meanings.

### Standard / Reduced Motion composition

Exactly **16** semantic composition records = 8 events × 2 presentation modes.

For each event:
- `standard` → same information glyph with `RUNTIME_ANIMATION_OPTIONAL_LATER`;
- `reduced_motion` → same information glyph with `STATIC_INFORMATION_EQUIVALENT`.

The two modes share the same `information_key` and primary product input. Therefore Reduced Motion preserves meaning rather than merely disabling an effect.

Every composition records:
- `DO_NOT_COVER_NEXT_CRITICAL_BRANCH_OR_CARGO_TARGET`;
- `mute_independent=true`;
- `runtime_integrated=false`.

`standard_runtime_animation_authored=false`: this package does not author Godot Animation/Scene/Resource runtime behavior.

### VFX source preservation

`art/production_candidates/ed_hybrid_v1/vfx/vfx_feedback_static_states_v01.png` remains:
`PRESERVE_REFERENCE_ONLY_NO_STATE_MAPPING`.

It has no authoritative named semantic slices and is never used as pixel/crop authority for the six new VFX assets.

### VFX TDD lineage

- RED head `5f2bd865bce5ca2934419e7533546984c051f680`: Python contracts failed because VFX package/validator was absent;
- atomic package commit `cbfc99e25335cc5ddbcc5c6be392b75a32b7d783`: six PNGs + VFX sidecar exposed together;
- ownership widened from 39/20/8 to 39/20/8/6 without weakening baseline checks;
- final exact-head workflow evidence is recorded only after the owner documents stop changing.

## Counts

- SX-DEC-051 source candidates: **31**
- dispositions complete: **31 / 31**
- `PROMOTE_AS_IS`: **18**
- `PROMOTE_AFTER_REVISION`: **11**
- `REPLACE`: **2**
- SX-DEC-053 baseline PNG ownership: **39**
- RUN Batch 2A ownership: **20**
- BUILD Batch 2B ownership: **8**
- VFX Batch 2C ownership: **6**
- expected physical product PNG total after VFX merge: **73**
- BUILD Batch 2B compositions: **28**
- VFX Batch 2C event identities: **8**
- VFX Batch 2C compositions: **16**
- Reduced Motion information-equivalent pairs: **8**
- runtime Animation resources authored by VFX Batch 2C: **0**
- corrupt source candidates overwritten: **0**

## Remaining gate after semantic production

After VFX Batch 2C product merge + docs closure + same-ID Sheet synchronization, the approved semantic asset-production backlog under `SX-DEC-054` is complete.

The next gate is **not** another asset-splitting batch. It is the separately deferred runtime integration/POC boundary, including later Godot Scene/Resource/Theme/Animation/signal wiring and actual runtime occlusion/motion validation only if/when that gate is authorized.

Still `NOT_RUN`: Windows physical runtime, Android device, connected physical editor, human comprehension/playtest, and release cutover.