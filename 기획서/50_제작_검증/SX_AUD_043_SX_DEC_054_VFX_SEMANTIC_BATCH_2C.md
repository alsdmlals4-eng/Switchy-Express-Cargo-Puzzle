# SX-AUD-043 · SX-DEC-054 VFX Semantic Batch 2C

**Date:** 2026-08-10 KST  
**Decision:** `SX-DEC-054`  
**Implementation baseline main:** `251ab46f757bd6741e5b1ea3f937fcd58ac18bb0`  
**Branch:** `agent/sx-dec-054-vfx-semantic-batch-2c`  
**PR:** `#133`  
**Status:** `IMPLEMENTED · FINAL_EXACT_HEAD_VALIDATION_PENDING · RUNTIME_NOT_INTEGRATED`

## Scope

Audit the final approved semantic-production batch under `SX-DEC-054`: causal feedback meaning for cargo pickup, cargo unload, combo, route selection, success, failure, ROUTE_END, and TIME_EXPIRED, including a static Reduced Motion information-equivalent for every event.

This batch is product-package-only. It does not author Godot Animation/Scene/Resource runtime behavior, audio implementation, gameplay/domain rules, or physical/device/human evidence.

## Authority and ownership baseline

- visual authority: `SX-DEC-053` / `E+D HYBRID · NEO-ARCADE READABILITY`;
- component/result authority: `SX-DEC-050` plus the event-specific existing decisions/components referenced in the VFX sidecar;
- 053 owner: 39 PNGs;
- RUN 2A owner: 20 PNGs;
- BUILD 2B owner: 8 PNGs;
- VFX 2C owner: 6 new PNGs;
- expected merged physical product-root total: **73** PNGs.

All four ownership sets must be unique, pairwise disjoint, and together equal every physical PNG under `art/product_assets/ed_hybrid_v1/`.

## TDD lineage

### RED

Exact RED head:
`5f2bd865bce5ca2934419e7533546984c051f680`

The focused VFX contract existed before the VFX sidecar/validator. Windows Demo Export run `31344767018` failed in `Run Python contracts` because the required VFX package did not yet exist. This established feature-absence RED rather than syntax/import corruption.

### GREEN package

- focused validator: `tools/validate_sx_dec_054_vfx_semantic_assets.py`;
- dedicated VFX sidecar: `art/product_assets/ed_hybrid_v1/semantic_manifest_sx_dec_054_vfx_2c.json`;
- six independently authored text-free 64×64 alpha glyphs;
- six PNGs + VFX sidecar attached atomically in commit `cbfc99e25335cc5ddbcc5c6be392b75a32b7d783`;
- existing combo and route-selection product assets reused instead of duplicated;
- shared product ownership minimally widened from 39/20/8 to 39/20/8/6.

No existing 053 disposition/recovery/crop/scale/CRC/zlib/runtime check was weakened.

## Event coverage

Exactly eight information events:

1. `cargo_pickup` — authority `SX-DEC-054 · SX-DEC-049`;
2. `cargo_unload` — authority `SX-DEC-054 · VR-FINITE-RUN-04`;
3. `combo` — authority `SX-DEC-054 · CMP-RUN-COMBO-FEEDBACK`;
4. `route_selection` — authority `SX-DEC-054 · SX-DEC-042 · SX-DEC-046`;
5. `success` — authority `SX-DEC-054 · CMP-RESULT-SUMMARY`;
6. `failure` — authority `SX-DEC-054 · CMP-RESULT-SUMMARY`;
7. `route_end` — authority `SX-DEC-054 · SX-DEC-041 · CMP-RESULT-FAILURE-INSIGHT`;
8. `time_expired` — authority `SX-DEC-054 · SX-DEC-029 · CMP-RESULT-FAILURE-INSIGHT`.

## Physical VFX package

Six new semantic glyphs:

- `vfx_cargo_pickup_feedback_v01.png`;
- `vfx_cargo_unload_feedback_v01.png`;
- `vfx_success_feedback_v01.png`;
- `vfx_failure_feedback_v01.png`;
- `vfx_route_end_feedback_v01.png`;
- `vfx_time_expired_feedback_v01.png`.

Existing exact information reuse:

- `combo` → `run_combo_feedback_static_v01.png`;
- `route_selection` → `run_switch_state_selected_overlay_v01.png`.

The historical `vfx_feedback_static_states_v01.png` candidate has no authoritative named semantic slices and remains `PRESERVE_REFERENCE_ONLY_NO_STATE_MAPPING`. No new asset claims a crop or slice from it.

## Reduced Motion equivalence

There are exactly **16** semantic composition records:

- 8 events × `standard`;
- 8 events × `reduced_motion`.

Each event pair uses the same information-bearing input and the same `information_key`.

- standard: `RUNTIME_ANIMATION_OPTIONAL_LATER`;
- reduced: `STATIC_INFORMATION_EQUIVALENT`.

This establishes static information equivalence only. Actual runtime animation timing and live Reduced Motion behavior remain deferred to the runtime gate.

Every composition requires:
- `occlusion_policy = DO_NOT_COVER_NEXT_CRITICAL_BRANCH_OR_CARGO_TARGET`;
- `mute_independent = true`;
- `runtime_integrated = false`.

## Static contract

The focused VFX validator checks:

- exact 39/20/8 baseline ownership;
- `decision_id: SX-DEC-054` / `batch: VFX_2C`;
- exactly 6 VFX-owned physical PNGs;
- exactly 8 event identities;
- exactly 16 standard/reduced compositions;
- exactly 8 Reduced Motion information-equivalent pairs;
- exact event authority strings and product inputs;
- combo/route-selection reuse;
- VFX atlas reference-only/no-state-mapping;
- independent semantic derivation / no crop authority;
- PNG signature, chunk CRC, IDAT zlib, dimensions, alpha capability, SHA-256;
- no ownership overlap with 053/RUN/BUILD;
- exact motion/occlusion/mute/runtime-deferred metadata;
- `standard_runtime_animation_authored=false`.

The shared 053 product validator/test additionally requires the four owner sets 39/20/8/6 to be pairwise disjoint and total exactly 73 physical product PNGs.

## Current intermediate GREEN evidence

After four-way ownership support, exact head `645c56f34f182f076dccae20d692291a92e32b1e` showed:

- Project Contract `31345195838`: PASS;
- GUT `31345195878`: PASS;
- Godot `31345195839`: PASS;
- Thin `31345195841`: PASS;
- Windows Demo Export `31345195842`: still running when owner documentation began.

This is intermediate evidence only. Final merge evidence must use the later unchanged exact PR head after this audit/owner documentation is stable.

## Adversarial scope boundary

Authorized changes:
- 6 VFX PNGs;
- VFX 2C sidecar;
- focused VFX validator/test;
- minimal shared product ownership validator/test changes;
- plan, decision, final asset list, audit docs.

Forbidden and unchanged:
- gameplay/domain rules;
- `.tscn`;
- `project.godot`;
- Godot Resource/Theme/Animation/signal authoring;
- plugins;
- runtime hookup;
- audio implementation;
- `.asset-vault` bytes.

## Final merge gate

Before PR #133 can merge, require one unchanged exact head with:
- Project Contract PASS;
- GUT PASS;
- Godot PASS;
- Thin PASS;
- Windows Demo Export PASS;
- review threads 0;
- behind 0 / mergeable true;
- changed-file scope inside the approved asset/package/test/doc boundary.

Hosted Windows Demo Export is package/build evidence only and cannot be promoted to physical Windows runtime evidence.

## Deferred evidence

`RUNTIME_POC_DEFERRED · STANDARD_ANIMATION_RUNTIME_NOT_AUTHORED · LIVE_OCCLUSION_NOT_RUN · WINDOWS_PHYSICAL_NOT_RUN · ANDROID_DEVICE_NOT_RUN · CONNECTED_PHYSICAL_EDITOR_NOT_RUN · HUMAN_NOT_RUN · ASSET_VAULT_UNTRACK_DEFERRED`

## Closure rule

After product merge, update this same audit and `SX-DEC-054` with final exact-head workflow IDs and product merge/main. Then create a docs-only merged-main closure and synchronize Google Sheet using the same `SX-DEC-054` / `SX-AUD-043` IDs. The next gate after semantic-production closure is the separately deferred runtime integration/POC boundary.