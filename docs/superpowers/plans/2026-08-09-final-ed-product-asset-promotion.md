# Final E+D Product Asset Promotion Implementation Plan

**Decision:** `SX-DEC-053`  
**Execution mode:** `[연속작업] · Inline Execution`  
**Baseline main:** `95dda145b518ce29bead78a5cbf5566cfa675419`

## Goal

Promote the approved E+D visual direction into a bounded product-asset package using existing SX-DEC-051 candidate bytes and deterministic transforms only. Keep runtime integration deferred.

## Constraints

- candidate source root remains immutable for provenance;
- blue locomotive remains hero design authority;
- trailing wagons use 70–75% visual hierarchy; current deterministic v02 uses `0.74`;
- no new concept-board/image generation;
- no gameplay, Scene, Resource, Theme, Animation, signal, `project.godot`, plugin-state, or `.asset-vault` mutation;
- uncertain semantic states remain pending rather than guessed.

## Task 1 · CI-consumed promotion contract — COMPLETE

RED head `8930a9543b90711328e2210372d18a3fdcdf07ab`: Project Contract `31310286681` expected FAIL because product manifest did not exist.

Implemented focused contract in `tests/python/test_final_ed_product_asset_promotion.py` and wired it into Project Contract.

## Task 2 · 31-candidate disposition ledger + validator — COMPLETE

- 31/31 candidates have exactly one disposition;
- product root and manifest created;
- validator created and strengthened to deep PNG validation;
- validator-missing RED: `491ce03b8964f16a7beae5e2daac8f13653af23d`, Contract `31310521719` expected FAIL;
- GREEN: `1a5fa3fe798451509c5f727ebbb005c737808c08`, Contract `31310592671` PASS.

Final disposition totals after adversarial source-health review:

- `PROMOTE_AS_IS`: 18;
- `PROMOTE_AFTER_REVISION`: 13;
- `REPLACE`: 0.

## Task 3 · First core product batch — COMPLETE AS BOUNDED PARTIAL

Core-absent RED: `e6e03ee5921548251f6013ad53cbce411629c541`, Contract `31310641256` expected FAIL.

Initial promotion exposed hidden defects:

- palette + `tRNS` transparency false-negative in validator;
- first red/yellow wagon transport bytes differed from verified deterministic outputs;
- source locomotive PNG IDAT is corrupt and Godot rejects it.

Recovery tests were added before fixes. Import-safe recovery head `3cda0e3dbb1064899f9a25cb840b7a7ed82edf71` passed Contract/GUT/Godot/Thin and Windows subsequently passed.

Core result:

- three wagon v02 assets promoted at `0.74` centered scale;
- stars/stations/rails/markers promoted where source bytes are healthy;
- locomotive remains `PROMOTE_AFTER_REVISION`, not falsely promoted.

## Task 4 · RUN/control/support split — COMPLETE AS BOUNDED PARTIAL

Source health scan found exactly two corrupt candidates: locomotive and controls atlas. All other sources pass deep PNG stream validation.

Promoted only proven states:

- switch `left_selected` documented crop;
- switch `locked` documented crop;
- combo static;
- ghost route;
- cost HUD;
- success/failure shells;
- progress/meta primitive.

Deliberately pending:

- controls seven states because source atlas is corrupt;
- stack next-unload-group and complete stack split;
- remaining switch selected directions not explicitly proven by source;
- train cargo strip smaller-wagon reconciliation;
- load-mode on/off naming because semantics are ambiguous;
- BUILD placement/palette/preflight full split;
- VFX causal split.

Product-root completeness RED head `132da08d3cdd3195d1101baa5fd4e73e80b0b5ad`: Contract `31313108286` expected FAIL while GUT/Godot/Thin/Windows PASS. After manifest registration, head `c47b05a6dbe869d2ed6f3142e1eecaab92efda84` passed Contract/GUT/Godot/Thin/Windows.

## Task 5 · Adversarial review / canonical docs / merge — IN PROGRESS

Final implementation candidate before canonical documentation: `fc886198cebde08f6c57e04de46e8c1b07530d2d`.

Fresh PASS:

- Project Contract `31313421289`;
- GUT `31313421335`;
- Godot Tests `31313421291`;
- Thin Adapter `31313421305`;
- Windows Demo Export `31313421296`.

Current static product result:

- 31/31 dispositions complete;
- 23 product PNGs manifested and import-safe;
- candidate provenance preserved;
- locomotive + controls corruption explicitly isolated;
- runtime integration still false.

Remaining execution:

- attach Decision/checklist/README/audit updates;
- receive fresh exact-head PR test-merge validation on that documentation-inclusive head;
- adversarial diff review;
- move PR #122 Draft → Ready and expected-head squash merge;
- merged-main readback/regression;
- docs-only canonical closure if required by final-head wording;
- same-ID Google Sheet synchronization and final readback.
