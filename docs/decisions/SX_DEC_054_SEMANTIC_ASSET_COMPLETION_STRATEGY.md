# SX-DEC-054 · Semantic Asset Completion Strategy

**Status:** `USER_APPROVED · DESIGN_SPEC_MERGED · RUN_BATCH_2A_MERGED_MAIN_VERIFIED · BUILD_BATCH_2B_MERGED_MAIN_VERIFIED · VFX_BATCH_2C_IMPLEMENTED_VALIDATION_PENDING · RUNTIME_POC_DEFERRED`  
**Date:** 2026-08-10 KST  
**Baseline main:** `de302e7cfd56a23d53a6ec97509195564e36749d`  
**RUN Batch 2A merge/main:** `35b93f3a15f35780b12cd4e8887c8e06f8ade72b`  
**BUILD Batch 2B merge/main:** `77276ec9b60aa91afd13f994ded8e0925e68be08`  
**VFX Batch 2C baseline:** `251ab46f757bd6741e5b1ea3f937fcd58ac18bb0`  
**Source visual authority:** `SX-DEC-053`  
**Source component authority:** `SX-DEC-050`

## Decision

Complete the remaining `SX-DEC-053` semantic-asset backlog by preserving ambiguous historical atlases as provenance/reference and authoring new independent semantic product assets from already-approved component-state contracts.

Do **not** assign new state meanings to unnamed or ambiguously mapped atlas regions.

This decision authorizes semantic asset production only. It does not authorize new gameplay rules, Godot runtime integration, Scene/Resource/Theme/Animation/signal changes, device validation, human validation, audio implementation, or `.asset-vault` cleanup.

## Approved strategy

`SEMANTIC_FIRST_INDEPENDENT_ASSETS`

1. Preserve `art/production_candidates/ed_hybrid_v1/` and existing `SX-DEC-051` provenance unchanged.
2. Preserve `SX-DEC-053` product ownership and named authoritative crops unchanged unless a later exact implementation defect requires a versioned repair.
3. Never reinterpret unnamed atlas regions as semantic authority by visual guesswork.
4. Create independent semantic product assets from approved component/state meaning.
5. Reuse the approved `E+D HYBRID · NEO-ARCADE READABILITY` shape/palette/material language.
6. Reuse existing product primitives where exact information meaning already exists.
7. Record every semantic asset/composition under `SX-DEC-054` with source authority, role/state, dimensions/alpha contract, derivation, and runtime-deferred status.
8. Dedicated semantic-completion sidecars may preserve already-verified earlier batch manifests without reserialization.
9. Runtime integration remains false until a later explicit runtime/POC gate.

## Completed semantic scope

### RUN Batch 2A

Merged-main verified:
- Stack HUD: `compact`, `8plus`, `16plus`, distinct predicted `unload_group`, `paused`;
- train cargo strip: `empty`, `tokens_1_3`, `compressed_plus_n`, `unload_transition`;
- load mode: `manual_idle`, `manual_held`, `auto_off`, `auto_on`, `paused_disabled`, `input_received`;
- switch presentation: `three_visible`, `selected`, `unselected`, `occupied_locked`, `inactive`, while direction geometry remains under `SX-DEC-042 · SX-DEC-046 · VIS-014`.

RUN product ownership: **20** semantic PNGs.

### BUILD Batch 2B

Merged-main verified:
- placement: `valid`, `invalid`, `rotate_preview`, `replacement_preview`;
- track forms: straight / curve / switch / crossing;
- palette interaction: idle / selected / unavailable / keyboard-focus / touch-pressed;
- preflight: `clear`, `primary_issue`, `multi_issue_summary`, `focused_location`.

BUILD product ownership: **8** semantic PNGs.  
BUILD compositions: **28** = placement 4 + palette 20 + preflight 4.  
Track palette adds **0** new form×interaction PNGs by reusing existing committed rails and UI frames.

### VFX Batch 2C

Implemented and final exact-head validation pending:
- `cargo_pickup`;
- `cargo_unload`;
- `combo`;
- `route_selection`;
- `success`;
- `failure`;
- `route_end` / `ROUTE_END`;
- `time_expired` / `TIME_EXPIRED`.

Physical VFX ownership is intentionally **6** new independent glyph PNGs, not 8:
- pickup;
- unload;
- success;
- failure;
- route end;
- time expired.

Two exact information assets are reused:
- `combo` → existing `run_combo_feedback_static_v01.png`;
- `route_selection` → existing RUN 2A `run_switch_state_selected_overlay_v01.png`.

Every event defines two semantic presentation records:
- `standard` with `RUNTIME_ANIMATION_OPTIONAL_LATER`;
- `reduced_motion` with `STATIC_INFORMATION_EQUIVALENT`.

The standard/reduced pair shares the same information-bearing product input and `information_key`, so Reduced Motion removes future motion without removing event meaning. No Godot Animation/Scene/Resource is authored in this batch.

Every VFX composition records:
- `DO_NOT_COVER_NEXT_CRITICAL_BRANCH_OR_CARGO_TARGET`;
- `mute_independent=true`;
- `runtime_integrated=false`.

The historical `art/production_candidates/ed_hybrid_v1/vfx/vfx_feedback_static_states_v01.png` remains `PRESERVE_REFERENCE_ONLY_NO_STATE_MAPPING`; it has no authoritative named semantic slices.

## Current ownership model

After VFX Batch 2C product merge, expected physical product-root ownership is:

- `SX-DEC-053`: **39** PNGs;
- `SX-DEC-054 RUN 2A`: **20** PNGs;
- `SX-DEC-054 BUILD 2B`: **8** PNGs;
- `SX-DEC-054 VFX 2C`: **6** PNGs;
- total: **73** PNGs.

The four sets must remain unique, pairwise disjoint, and their union must equal every physical PNG under `art/product_assets/ed_hybrid_v1/`.

## Existing merged evidence

RUN Batch 2A / PR #129:
- exact head `34ab2b907190f69775ace8e89c32f689ba17bc35`;
- merge/main `35b93f3a15f35780b12cd4e8887c8e06f8ade72b`;
- Contract/GUT/Godot/Thin/Windows: PASS.

BUILD Batch 2B / PR #131:
- exact head `6efe4c71e88799f886f136c98d0c4a4396e58808`;
- merge/main `77276ec9b60aa91afd13f994ded8e0925e68be08`;
- Contract `31343802460`, GUT `31343802437`, Godot `31343802472`, Thin `31343802445`, Windows `31343802461`: PASS.

## VFX Batch 2C TDD / implementation state

- implementation baseline: `251ab46f757bd6741e5b1ea3f937fcd58ac18bb0`;
- product PR: `#133`;
- RED exact head: `5f2bd865bce5ca2934419e7533546984c051f680` — Windows Python contracts failed because the VFX sidecar/validator was absent;
- atomic VFX package commit: `cbfc99e25335cc5ddbcc5c6be392b75a32b7d783` — six PNGs + VFX sidecar attached together;
- four-way product ownership support added after the atomic package;
- final exact-head workflow IDs/merge SHA are intentionally not recorded until the documentation head is stable.

## Acceptance contract before VFX implementation merge

Static verification must prove:
- exact 39/20/8/6 physical ownership and total 73 product PNGs;
- exact 8 VFX event identities;
- exact 16 standard/reduced semantic compositions;
- exact 8 Reduced Motion information-equivalent pairs;
- six unique VFX-owned physical PNGs;
- combo and route-selection reuse their existing authoritative product inputs;
- VFX atlas remains reference-only/no-state-mapping;
- no new crop authority is claimed;
- PNG signature/chunk CRC/IDAT decode/dimensions/alpha/SHA-256 pass;
- each pair preserves the same information asset/key;
- occlusion/mute/runtime-deferred policies are present;
- existing 053/RUN/BUILD package contracts remain intact;
- no `.tscn`, `project.godot`, gameplay/domain, Resource/Theme/Animation/signal, plugin, audio implementation, runtime hookup, or `.asset-vault` bytes change.

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

## Delivery rule

RUN Batch 2A and BUILD Batch 2B are merged-main verified. VFX Batch 2C remains implementation-complete / merge-pending until one unchanged exact head passes the full PR gate. After VFX product merge, use a docs-only same-ID closure and synchronize GitHub/Google Sheet under `SX-DEC-054` and `SX-AUD-043`. Only then may work advance to the separate runtime integration/POC gate.