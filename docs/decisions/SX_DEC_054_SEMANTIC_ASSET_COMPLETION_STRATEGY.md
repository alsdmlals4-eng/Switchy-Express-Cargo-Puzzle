# SX-DEC-054 · Semantic Asset Completion Strategy

**Status:** `USER_APPROVED · DESIGN_SPEC_MERGED · RUN_BATCH_2A_MERGED_MAIN_VERIFIED · BUILD_BATCH_2B_MERGED_MAIN_VERIFIED · VFX_BATCH_2C_MERGED_MAIN_VERIFIED · SEMANTIC_ASSET_PRODUCTION_COMPLETE · RUNTIME_POC_DEFERRED`  
**Date:** 2026-08-10 KST  
**Baseline main:** `de302e7cfd56a23d53a6ec97509195564e36749d`  
**RUN Batch 2A merge/main:** `35b93f3a15f35780b12cd4e8887c8e06f8ade72b`  
**BUILD Batch 2B merge/main:** `77276ec9b60aa91afd13f994ded8e0925e68be08`  
**VFX Batch 2C baseline:** `251ab46f757bd6741e5b1ea3f937fcd58ac18bb0`  
**VFX Batch 2C exact review head:** `603a1a0330d651b4d7068487c17e88ef1657a009`  
**VFX Batch 2C product merge/main:** `13db4ddd991bdb3162884c1b85fdc3d20e3eee8a`  
**Source visual authority:** `SX-DEC-053`  
**Source component authority:** `SX-DEC-050`

## Decision

Complete the remaining `SX-DEC-053` semantic-asset backlog by preserving ambiguous historical atlases as provenance/reference and authoring new independent semantic product assets from already-approved component-state contracts.

Do **not** assign new state meanings to unnamed or ambiguously mapped atlas regions.

This decision authorizes semantic asset production only. It does not authorize new gameplay rules, Godot runtime integration, Scene/Resource/Theme/Animation/signal changes, device validation, human validation, audio implementation, or `.asset-vault` cleanup.

## Approved strategy

`SEMANTIC_FIRST_INDEPENDENT_ASSETS`

1. Preserve `art/production_candidates/ed_hybrid_v1/` and existing `SX-DEC-051` provenance unchanged.
2. Preserve `SX-DEC-053` ownership and named authoritative crops unchanged unless a later exact defect requires a versioned repair.
3. Never reinterpret unnamed atlas regions as semantic authority by visual guesswork.
4. Create independent semantic product assets from approved component/state meaning.
5. Reuse the approved `E+D HYBRID · NEO-ARCADE READABILITY` shape/palette/material language.
6. Reuse existing product primitives where exact information meaning already exists.
7. Record every semantic asset/composition with source authority, role/state, dimensions/alpha contract, derivation, and runtime-deferred status.
8. Dedicated semantic-completion sidecars may preserve earlier verified manifests without reserialization.
9. Runtime integration remains false until a later explicit runtime/POC gate.

## Completed semantic scope

### RUN Batch 2A · merged-main verified

- Stack HUD: `compact`, `8plus`, `16plus`, distinct predicted `unload_group`, `paused`;
- train cargo strip: `empty`, `tokens_1_3`, `compressed_plus_n`, `unload_transition`;
- load mode: `manual_idle`, `manual_held`, `auto_off`, `auto_on`, `paused_disabled`, `input_received`;
- switch presentation: `three_visible`, `selected`, `unselected`, `occupied_locked`, `inactive`, while direction geometry remains under `SX-DEC-042 · SX-DEC-046 · VIS-014`.

RUN product ownership: **20** semantic PNGs.

### BUILD Batch 2B · merged-main verified

- placement: `valid`, `invalid`, `rotate_preview`, `replacement_preview`;
- track palette: straight / curve / switch / crossing × idle / selected / unavailable / keyboard-focus / touch-pressed;
- preflight: `clear`, `primary_issue`, `multi_issue_summary`, `focused_location`.

BUILD product ownership: **8** semantic PNGs.  
BUILD compositions: **28** = placement 4 + palette 20 + preflight 4.  
Track palette adds **0** new form×interaction PNGs by reusing existing committed rails and UI frames.

### VFX Batch 2C · merged-main verified

Exactly eight information events:
- `cargo_pickup`;
- `cargo_unload`;
- `combo`;
- `route_selection`;
- `success`;
- `failure`;
- `route_end` / `ROUTE_END`;
- `time_expired` / `TIME_EXPIRED`.

Physical VFX ownership is **6** new independent glyph PNGs: pickup, unload, success, failure, route end, and time expired.

Two exact information assets are reused:
- `combo` → `run_combo_feedback_static_v01.png`;
- `route_selection` → `run_switch_state_selected_overlay_v01.png`.

Every event has two semantic presentation records:
- `standard` with `RUNTIME_ANIMATION_OPTIONAL_LATER`;
- `reduced_motion` with `STATIC_INFORMATION_EQUIVALENT`.

Each standard/reduced pair shares the same information-bearing product input and `information_key`. Every composition records `DO_NOT_COVER_NEXT_CRITICAL_BRANCH_OR_CARGO_TARGET`, `mute_independent=true`, and `runtime_integrated=false`.

The historical `art/production_candidates/ed_hybrid_v1/vfx/vfx_feedback_static_states_v01.png` remains `PRESERVE_REFERENCE_ONLY_NO_STATE_MAPPING`; it has no authoritative named semantic slices.

## Current ownership model

- `SX-DEC-053`: **39** PNGs;
- `SX-DEC-054 RUN 2A`: **20** PNGs;
- `SX-DEC-054 BUILD 2B`: **8** PNGs;
- `SX-DEC-054 VFX 2C`: **6** PNGs;
- total: **73** PNGs.

The four sets are required to remain unique, pairwise disjoint, and together equal every physical PNG under `art/product_assets/ed_hybrid_v1/`.

## Exact VFX product evidence

PR #133 final exact head: `603a1a0330d651b4d7068487c17e88ef1657a009`.

- Project Contract `31345334561`: PASS;
- GUT 9.7.1 Tests `31345334543`: PASS;
- Godot Tests `31345334535`: PASS;
- Validate Thin Adapter Migration `31345334542`: PASS;
- Windows Demo Export `31345334553`: PASS;
- review threads: **0**;
- product merge/main: `13db4ddd991bdb3162884c1b85fdc3d20e3eee8a`.

Hosted Windows Demo Export is package/build evidence only. It is not physical Windows runtime evidence.

## Verification boundary

Automated/static verification establishes product-package correctness only.

Still `NOT_RUN` / deferred:
- Godot runtime hookup and POC;
- actual standard-mode animation timing;
- live occlusion capture against next branch/cargo targets;
- Windows physical runtime;
- Android device validation;
- connected physical editor validation;
- human comprehension/playtest validation;
- `.asset-vault` legacy untrack;
- release cutover.

## Closure rule

Semantic asset production is complete through the PR #133 product merge. This same-ID docs-only authority repair closes the stale post-merge documentation state and must be synchronized to the configured Google Sheet after its actual merge. The docs closure merge SHA is intentionally not self-referenced before merge; the Sheet records the actual closure PR and merge SHA after GitHub readback.

The next boundary is a separate runtime integration/POC gate. Do not auto-cross it from this decision alone.