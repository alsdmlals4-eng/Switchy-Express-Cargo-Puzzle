# SX-DEC-054 · Semantic Asset Completion Strategy

**Status:** `USER_APPROVED · DESIGN_SPEC_MERGED · RUN_BATCH_2A_MERGED_MAIN_VERIFIED · BUILD_BATCH_2B_IMPLEMENTED_VALIDATION_PENDING · VFX_2C_PENDING · RUNTIME_POC_DEFERRED`  
**Date:** 2026-08-10 KST  
**Baseline main:** `de302e7cfd56a23d53a6ec97509195564e36749d`  
**RUN implementation baseline:** `bf0146bf51eb6b7a54d1ac219b021a6a41225c4c`  
**RUN Batch 2A merge/main:** `35b93f3a15f35780b12cd4e8887c8e06f8ade72b`  
**BUILD Batch 2B baseline:** `fb229b2ef522fb29c70f43787549fb2e20bf89b0`  
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

## Alternatives considered

### A. Semantic-first independent assets — **APPROVED**

Create explicit assets from approved state contracts and keep ambiguous atlases as provenance only.

Benefits:
- no invented atlas meaning;
- filenames and runtime intent become reviewable;
- state coverage can be statically validated before Godot hookup;
- preserves prior evidence and provenance.

### B. Reinterpret existing atlas regions — **REJECTED**

Visually infer unnamed regions and assign approved state names.

Rejected because `SX-DEC-053` explicitly records that those mappings are not authoritative. This would convert visual guesswork into product meaning.

### C. Defer all semantic assets until runtime integration — **NOT SELECTED**

Leave the backlog unresolved until Godot UI hookup begins.

Not selected because the component-state authority already exists and can be made implementation-ready without crossing the runtime boundary.

## Semantic completion scope

### RUN · Stack HUD

Existing `SX-DEC-053` assets remain authoritative:
- `empty`;
- `32plus`;
- `unloading`;
- `top_highlight`.

Complete the approved state model without relabeling `unloading`:
- `compact`;
- `8plus`;
- `16plus`;
- distinct predicted `unload_group`;
- `paused`.

The predicted unload group is derived from the approved contiguous TOP-group concept and must remain visually distinct from the current unloading event state.

### RUN · Switch direction

Reuse the existing `RouteControlOverlay` direction authority and interaction semantics. Complete semantic selected/unselected/occupied-locked/inactive presentation for every currently valid reciprocal direction without inventing a new direction coordinate system.

The existing left-selected and locked product assets remain valid provenance/product assets; new variants must not claim they were hidden slices of the old atlas.

### RUN · Train cargo strip

Create semantic presentation for:
- empty;
- 1–3 visible recent/TOP tokens;
- compressed `+N`;
- unload transition.

Reuse the approved smaller-wagon hierarchy (`visual_scale = 0.74`) and existing cargo token color+shape identity. The strip is a compact world-adjacent representation and never replaces the full Stack HUD.

### RUN · Load mode

Create explicit assets/presentation primitives for the already-approved states:
- `manual_idle`;
- `manual_held`;
- `auto_off`;
- `auto_on`;
- `paused_disabled`;
- `input_received` feedback where the existing owner authority consumes current input state.

Do not map these names onto the old `run_load_mode_states_v01.png` regions without new explicit evidence.

### BUILD · Placement and track palette

Preserve the four batch-1 placement crops.

Complete approved semantic presentation for:
- placement `valid` / `invalid`;
- `rotate_preview`;
- `replacement_preview`;
- track forms straight / curve / switch / crossing;
- palette idle / selected / unavailable / keyboard-focus / touch-pressed.

Avoid an unnecessary form×interaction binary explosion: reusable selection/focus/pressed/disabled frames or overlays may be shared when this preserves identical meaning and readability.

Committed/placed rail continues to use committed core rail authority; BUILD preview art must not masquerade as committed track.

### BUILD · Preflight

Reconcile the existing component contract and prior visual promotion language without inventing gameplay outcomes:
- component presentation states remain `clear`, `primary_issue`, `multi_issue_summary`, `focused_location`;
- ready/warning/blocking styling, when used, is a presentation/severity layer driven only by authoritative preflight issue data;
- optional-target misses must never be styled as general run failure.

### VFX / feedback

Create causal feedback assets or static equivalents for the already-approved events:
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
- Dedicated semantic-completion sidecars may be used to preserve already-verified batch manifests without reserializing or widening their ownership records.
- Localized copy is never baked into PNGs.
- Color-only state communication is forbidden.
- Cargo/station identity retains color+shape redundancy.
- Runtime/domain collision and route geometry remain unchanged.
- Existing candidates and existing product files are never silently overwritten.

## RUN Batch 2A merged-main status

RUN Batch 2A was implemented and squash-merged through PR `#129`.

- implementation branch: `agent/sx-dec-054-run-semantic-batch-2a`;
- implementation baseline: `bf0146bf51eb6b7a54d1ac219b021a6a41225c4c`;
- final exact review head: `34ab2b907190f69775ace8e89c32f689ba17bc35`;
- merge/main: `35b93f3a15f35780b12cd4e8887c8e06f8ade72b`;
- dedicated sidecar: `art/product_assets/ed_hybrid_v1/semantic_manifest_sx_dec_054.json`;
- `SX-DEC-053` ownership preserved at **39** product PNGs;
- `SX-DEC-054` RUN Batch 2A ownership: **20** independent semantic PNG primitives;
- total physical product PNGs after RUN 2A: **59**, with disjoint manifest ownership;
- Stack HUD coverage: `compact`, `8plus`, `16plus`, `unload_group`, `paused`;
- train cargo strip coverage: `empty`, `tokens_1_3`, `compressed_plus_n`, `unload_transition`;
- load-mode coverage: `manual_idle`, `manual_held`, `auto_off`, `auto_on`, `paused_disabled`, `input_received`;
- switch coverage: `three_visible`, `selected`, `unselected`, `occupied_locked`, `inactive`, with direction geometry procedural under `SX-DEC-042 · SX-DEC-046 · VIS-014`;
- ambiguous train-strip/load-mode/switch atlases remain `PRESERVE_REFERENCE_ONLY_NO_STATE_MAPPING`;
- `runtime_integrated=false` globally and per Batch 2A asset/composition.

Final exact-head validation for `34ab2b907190f69775ace8e89c32f689ba17bc35`:

- Project Contract `31342194367`: **PASS**;
- GUT 9.7.1 `31342194376`: **PASS**;
- Godot Tests `31342194392`: **PASS**;
- Validate Thin Adapter Migration `31342194374`: **PASS**;
- Windows Demo Export `31342194375`: **PASS**;
- unresolved review threads: **0**;
- final compare: behind **0**, mergeable **true**.

Hosted Windows export is packaging evidence only. It is not Windows physical runtime evidence.

## BUILD Batch 2B implementation status

BUILD Batch 2B is implemented on `agent/sx-dec-054-build-semantic-batch-2b` and remains pre-merge until the final exact-head gate completes.

- implementation baseline: `fb229b2ef522fb29c70f43787549fb2e20bf89b0`;
- product PR: `#131`;
- dedicated sidecar extension: `art/product_assets/ed_hybrid_v1/semantic_manifest_sx_dec_054_build_2b.json`;
- the verified RUN 2A sidecar remains unchanged and continues to own exactly **20** RUN semantic PNGs;
- BUILD Batch 2B owns exactly **8** new independent semantic PNG primitives;
- expected shared product-root ownership after merge: `SX-DEC-053 39 + RUN 2A 20 + BUILD 2B 8 = 67` physical PNGs;
- placement coverage: `valid`, `invalid`, `rotate_preview`, `replacement_preview` using four state overlays and committed core rail form authority;
- track palette coverage: straight/curve/switch/crossing × idle/selected/unavailable/keyboard-focus/touch-pressed = **20 semantic compositions with zero new form×interaction PNGs**;
- palette form identity reuses the four committed core rail products; interaction presentation reuses existing normal/selected/disabled/focus/pressed UI frames;
- preflight coverage: `clear`, `primary_issue`, `multi_issue_summary`, `focused_location` using a neutral shell plus three meaning-bearing markers;
- `build_placement_preview_states_v01.png` policy: `PRESERVE_NAMED_SLICES_ONLY_NO_NEW_STATE_MAPPING`;
- `build_track_palette_v01.png` policy: `PRESERVE_REFERENCE_ONLY_NO_STATE_MAPPING`;
- no new BUILD record claims `authoritative_slice_name` or crop bounds;
- `runtime_integrated=false` globally and per BUILD asset/composition.

TDD lineage:

- initial RED head `7d10ed2289e57fd1644c8a4c5bcf84bb86aff47b`: Windows Python contracts failed because the BUILD package did not exist;
- architecture was tightened to a separate BUILD semantic-completion sidecar so the verified RUN 2A sidecar did not need reserialization;
- final-architecture RED head `7444886f5aa3ecfe91977778d430c227d7f083a2`: Windows Python contracts again failed on BUILD sidecar absence;
- intermediate GREEN head `b68bae4ea153eb066261db4da7f2ddbad70aac98`: Project Contract, GUT, Godot, Thin and Python-contract/headless steps passed; final exact-head evidence is intentionally deferred until the documentation head is stable.

## Acceptance contract before implementation merge

Static verification must prove:

- every new file has a registered `SX-DEC-054` semantic role/state;
- no new record claims an unnamed `SX-DEC-051` atlas crop as authority;
- existing 39 `SX-DEC-053` assets remain separately manifested and owned;
- RUN Batch 2A remains exactly 20 separately owned assets;
- BUILD Batch 2B remains exactly 8 separately owned assets;
- the three ownership sets are pairwise disjoint and their union equals every physical product PNG;
- BUILD placement, palette, and preflight state coverage exactly matches the approved component contracts;
- filenames, PNG signature/chunk CRC/IDAT decode, dimensions, alpha capability, SHA-256, and manifest↔physical-file agreement pass;
- track palette reuses existing rail/frame products rather than creating an unnecessary binary cross product;
- runtime integration remains false;
- no `.tscn`, `project.godot`, gameplay/domain, Resource/Theme/Animation/signal, plugin, or `.asset-vault` bytes change in Batch 2B.

Reduced Motion meaning-equivalent verification remains applicable to the later VFX batch; no meaning-bearing VFX assets are added in BUILD Batch 2B.

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

RUN Batch 2A is merged and technically closed under this same `SX-DEC-054` Decision ID. BUILD Batch 2B remains implementation-complete but merge-pending until one unchanged exact head passes the full PR gate. After BUILD 2B merges, record the final merge/main under this same Decision ID, synchronize the configured Google Sheet, then continue to VFX Batch 2C. Runtime integration/POC remains a later separate gate.