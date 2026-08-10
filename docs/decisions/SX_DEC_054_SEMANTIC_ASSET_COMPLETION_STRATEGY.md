# SX-DEC-054 · Semantic Asset Completion Strategy

**Status:** `USER_APPROVED · DESIGN_SPEC_MERGED · RUN_BATCH_2A_MERGED_MAIN_VERIFIED · BUILD_BATCH_2B_MERGED_MAIN_VERIFIED · VFX_2C_PENDING · RUNTIME_POC_DEFERRED`  
**Date:** 2026-08-10 KST  
**Baseline main:** `de302e7cfd56a23d53a6ec97509195564e36749d`  
**RUN implementation baseline:** `bf0146bf51eb6b7a54d1ac219b021a6a41225c4c`  
**RUN Batch 2A merge/main:** `35b93f3a15f35780b12cd4e8887c8e06f8ade72b`  
**BUILD Batch 2B baseline:** `fb229b2ef522fb29c70f43787549fb2e20bf89b0`  
**BUILD Batch 2B merge/main:** `77276ec9b60aa91afd13f994ded8e0925e68be08`  
**Source visual authority:** `SX-DEC-053`  
**Source component authority:** `SX-DEC-050`

## Decision

Complete the remaining `SX-DEC-053` semantic-asset backlog by preserving ambiguous historical atlases as provenance/reference and authoring new independent semantic product assets from already-approved component-state contracts.

Do **not** assign new state meanings to unnamed or ambiguously mapped atlas regions.

This decision authorizes semantic asset production only. It does not authorize new gameplay rules, Godot runtime integration, Scene/Resource/Theme/Animation/signal changes, device validation, human validation, or `.asset-vault` cleanup.

## Approved strategy

`SEMANTIC_FIRST_INDEPENDENT_ASSETS`

1. Preserve `art/production_candidates/ed_hybrid_v1/` and all existing `SX-DEC-051` atlas provenance unchanged.
2. Preserve the 39 current `SX-DEC-053` product PNGs and batch-1 authoritative crops unchanged unless a later exact implementation defect requires a versioned repair.
3. Do not reinterpret an unnamed atlas region merely because its appearance seems to resemble an approved state.
4. Create new product assets from the approved component/state semantics instead.
5. Reuse the current `E+D HYBRID · NEO-ARCADE READABILITY` shape/palette/material language; no new visual direction is opened.
6. Reuse existing product primitives where possible so semantic completion does not create an unnecessary state cross-product.
7. Every new semantic product asset must record `decision_id: SX-DEC-054`, source authority, role/state, dimensions, alpha contract, and derivation kind in the product manifest or a dedicated semantic-completion manifest extension.
8. Runtime integration remains false until a later explicit runtime/POC gate.

## Semantic completion scope

### RUN

Completed under RUN Batch 2A:
- Stack HUD: `compact`, `8plus`, `16plus`, distinct predicted `unload_group`, `paused` while preserving 053 `empty`, `32plus`, `unloading`, `top_highlight`;
- train cargo strip: `empty`, `tokens_1_3`, `compressed_plus_n`, `unload_transition`;
- load mode: `manual_idle`, `manual_held`, `auto_off`, `auto_on`, `paused_disabled`, `input_received`;
- switch presentation: `three_visible`, `selected`, `unselected`, `occupied_locked`, `inactive`, with direction geometry retained under `SX-DEC-042 · SX-DEC-046 · VIS-014`.

### BUILD

Completed under BUILD Batch 2B:
- placement: `valid`, `invalid`, `rotate_preview`, `replacement_preview`;
- track forms: straight / curve / switch / crossing;
- palette interaction: idle / selected / unavailable / keyboard-focus / touch-pressed;
- preflight: `clear`, `primary_issue`, `multi_issue_summary`, `focused_location`.

Track Palette avoids a form×interaction binary explosion: 4 committed rail silhouettes and existing normal/selected/disabled/focus/pressed UI frames are reused to define 20 semantic compositions with zero new form×interaction PNGs.

Committed/placed rail remains under committed core rail authority; BUILD placement overlays remain preview-only.

### VFX / feedback

Still pending as VFX Batch 2C under the same approved strategy:
- cargo pickup;
- cargo unload;
- combo;
- route selection;
- success;
- failure;
- `ROUTE_END`;
- `TIME_EXPIRED`.

Each meaning-bearing effect requires a Reduced Motion information-equivalent presentation. Effects must not cover the next critical branch/cargo input target.

## Architecture rules

- Product root remains `art/product_assets/ed_hybrid_v1/`.
- New files use lowercase snake_case and the existing versioned naming contract.
- One semantic state per exported file where pixels encode the state; shared neutral primitives/overlays are allowed when they prevent duplicate state cross-products.
- Dedicated semantic-completion sidecars may preserve already-verified batch manifests without reserializing their ownership records.
- Localized copy is never baked into PNGs.
- Color-only state communication is forbidden.
- Cargo/station identity retains color+shape redundancy.
- Runtime/domain collision and route geometry remain unchanged.
- Existing candidates and existing product files are never silently overwritten.

## RUN Batch 2A merged-main evidence

RUN Batch 2A was squash-merged through PR `#129`.

- exact review head: `34ab2b907190f69775ace8e89c32f689ba17bc35`;
- merge/main: `35b93f3a15f35780b12cd4e8887c8e06f8ade72b`;
- sidecar: `art/product_assets/ed_hybrid_v1/semantic_manifest_sx_dec_054.json`;
- ownership: **20** independent RUN semantic PNGs;
- Project Contract `31342194367`: PASS;
- GUT `31342194376`: PASS;
- Godot `31342194392`: PASS;
- Thin `31342194374`: PASS;
- Windows Demo Export `31342194375`: PASS packaging only;
- unresolved review threads: 0;
- behind: 0.

## BUILD Batch 2B merged-main evidence

BUILD Batch 2B was squash-merged through PR `#131`.

- implementation baseline: `fb229b2ef522fb29c70f43787549fb2e20bf89b0`;
- exact review head: `6efe4c71e88799f886f136c98d0c4a4396e58808`;
- merge/main: `77276ec9b60aa91afd13f994ded8e0925e68be08`;
- dedicated BUILD sidecar: `art/product_assets/ed_hybrid_v1/semantic_manifest_sx_dec_054_build_2b.json`;
- RUN sidecar remains independently owned at exactly 20 assets;
- BUILD Batch 2B ownership: exactly **8** new independent semantic PNG primitives;
- shared physical product root: `SX-DEC-053 39 + RUN 2A 20 + BUILD 2B 8 = 67` PNGs;
- BUILD compositions: **28** = placement 4 + palette 20 + preflight 4;
- palette new form×interaction binary count: **0**;
- placement atlas policy: `PRESERVE_NAMED_SLICES_ONLY_NO_NEW_STATE_MAPPING`;
- track palette atlas policy: `PRESERVE_REFERENCE_ONLY_NO_STATE_MAPPING`;
- `runtime_integrated=false` globally and per BUILD asset/composition.

TDD lineage:
- initial RED `7d10ed2289e57fd1644c8a4c5bcf84bb86aff47b`;
- final-architecture RED `7444886f5aa3ecfe91977778d430c227d7f083a2` after choosing a dedicated BUILD sidecar;
- final exact GREEN/merge head `6efe4c71e88799f886f136c98d0c4a4396e58808`.

Final exact-head workflows:
- Project Contract `31343802460`: **PASS**;
- GUT 9.7.1 `31343802437`: **PASS**;
- Godot Tests `31343802472`: **PASS**;
- Validate Thin Adapter Migration `31343802445`: **PASS**;
- Windows Demo Export `31343802461`: **PASS**;
- unresolved review threads: **0**;
- final compare: behind **0**, mergeable **true**.

Hosted Windows Demo Export PASS is build/package evidence only and is not Windows physical runtime evidence.

## Acceptance contract status

Static verification proves:
- all new BUILD files are registered under `SX-DEC-054` with exact role/state ownership;
- no new record claims an unnamed `SX-DEC-051` atlas crop as authority;
- existing 39 `SX-DEC-053`, 20 RUN 2A, and 8 BUILD 2B paths are unique and pairwise disjoint;
- their union equals all **67** physical product PNGs;
- placement, palette, and preflight state coverage exactly matches approved component contracts;
- PNG signature/chunk CRC/IDAT decode, dimensions, alpha capability, SHA-256, and physical-file agreement pass;
- existing 053 disposition/recovery/crop/scale/CRC/zlib checks remain intact;
- no `.tscn`, `project.godot`, gameplay/domain, Resource/Theme/Animation/signal, plugin, runtime hookup, or `.asset-vault` bytes changed in BUILD Batch 2B.

## Verification boundary

Automated/static verification establishes product-asset package correctness only.

Still `NOT_RUN` / deferred:
- Godot runtime hookup and POC;
- Windows physical runtime;
- Android device validation;
- connected physical editor validation;
- human comprehension/playtest validation;
- `.asset-vault` legacy untrack;
- release cutover.

## Delivery rule

RUN Batch 2A and BUILD Batch 2B are merged and technically closed under this same `SX-DEC-054` Decision ID. Remaining approved semantic production is VFX Batch 2C. After the docs-only merged-main closure and same-ID Google Sheet synchronization, continue VFX Batch 2C; runtime integration/POC remains a later separate gate.