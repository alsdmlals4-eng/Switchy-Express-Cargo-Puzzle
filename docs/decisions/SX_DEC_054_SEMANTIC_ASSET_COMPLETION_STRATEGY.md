# SX-DEC-054 · Semantic Asset Completion Strategy

**Status:** `USER_APPROVED · DESIGN_SPEC_MERGED · RUN_BATCH_2A_IMPLEMENTED_VALIDATION_PENDING`  
**Date:** 2026-08-10 KST  
**Baseline main:** `de302e7cfd56a23d53a6ec97509195564e36749d`  
**Implementation baseline:** `bf0146bf51eb6b7a54d1ac219b021a6a41225c4c`  
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
- Localized copy is never baked into PNGs.
- Color-only state communication is forbidden.
- Cargo/station identity retains color+shape redundancy.
- Runtime/domain collision and route geometry remain unchanged.
- Existing candidates and existing product files are never silently overwritten.

## RUN Batch 2A implementation status

The approved first implementation batch now exists on `agent/sx-dec-054-run-semantic-batch-2a` and remains pre-merge until final exact-head validation completes.

- dedicated sidecar: `art/product_assets/ed_hybrid_v1/semantic_manifest_sx_dec_054.json`;
- `SX-DEC-053` ownership preserved at **39** product PNGs;
- `SX-DEC-054` RUN Batch 2A ownership: **20** independent semantic PNG primitives;
- total physical product PNGs in the shared product root: **59**, with disjoint manifest ownership;
- Stack HUD coverage added: `compact`, `8plus`, `16plus`, `unload_group`, `paused`;
- train cargo strip composition coverage: `empty`, `tokens_1_3`, `compressed_plus_n`, `unload_transition`;
- load-mode composition coverage: `manual_idle`, `manual_held`, `auto_off`, `auto_on`, `paused_disabled`, `input_received`;
- switch presentation coverage: `three_visible`, `selected`, `unselected`, `occupied_locked`, `inactive`, while direction geometry remains procedural under `SX-DEC-042 · SX-DEC-046 · VIS-014`;
- ambiguous train-strip/load-mode/switch atlases remain `PRESERVE_REFERENCE_ONLY_NO_STATE_MAPPING`;
- `runtime_integrated=false` globally and per Batch 2A asset/composition.

The implementation has already passed an intermediate exact-head CI cycle after correcting the legacy `SX-DEC-053` test assumption that every PNG in the shared product root had a single 053 owner. Final merge evidence is intentionally not recorded here until the PR's final exact head is stable.

## Acceptance contract before implementation merge

The implementation plan must add focused static verification that proves:

- every new file has a registered `SX-DEC-054` semantic role/state;
- no new record claims an unnamed `SX-DEC-051` atlas crop as authority;
- existing 39 `SX-DEC-053` assets remain manifested and byte-preserved unless an explicitly documented versioned repair occurs;
- required semantic state coverage is complete for the implementation batch;
- filenames, PNG integrity, dimensions, alpha capability, and manifest↔physical-file agreement pass;
- Reduced Motion equivalents exist for meaning-bearing VFX states in scope;
- runtime integration remains false;
- no `.tscn`, `project.godot`, gameplay/domain, Resource/Theme/Animation/signal, plugin, or `.asset-vault` bytes change in the semantic-asset-only batch.

## Verification boundary

Automated/static verification may establish product-asset package correctness only.

Still `NOT_RUN` / deferred:
- Godot runtime hookup and POC;
- Windows physical runtime;
- Android device validation;
- connected physical editor validation;
- human comprehension/playtest validation;
- `.asset-vault` legacy untrack;
- release cutover.

## Delivery rule

After the implementation PR is exact-head validated and merged, update this same Decision ID on GitHub and in the configured Google Sheet with the final merged-main evidence. Do not create a replacement Decision ID merely for technical closure.