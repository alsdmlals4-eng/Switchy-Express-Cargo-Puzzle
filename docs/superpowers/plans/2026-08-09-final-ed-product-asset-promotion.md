# Final E+D Product Asset Promotion Implementation Plan

**Decision:** `SX-DEC-053`  
**Execution mode:** `[연속작업] · Inline Execution`  
**Baseline main:** `95dda145b518ce29bead78a5cbf5566cfa675419`

## Goal

Promote the approved E+D visual direction into a bounded product-asset package using existing SX-DEC-051 candidate bytes, deterministic transforms, and exact approved-reference recovery where corrupt source candidates prevent safe reuse. Keep runtime integration deferred.

## Constraints

- candidate source root remains immutable for provenance;
- blue locomotive remains hero design authority;
- trailing wagons use 70–75% visual hierarchy; current deterministic v02 uses `0.74`;
- no new concept-board generation;
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

Final disposition totals after source-health recovery:

- `PROMOTE_AS_IS`: 18;
- `PROMOTE_AFTER_REVISION`: 11;
- `REPLACE`: 2.

The two `REPLACE` records are the corrupt locomotive candidate and corrupt controls atlas. Their source bytes remain unchanged.

## Task 3 · Core product batch — COMPLETE

Core-absent RED: `e6e03ee5921548251f6013ad53cbce411629c541`, Contract `31310641256` expected FAIL.

Initial promotion exposed hidden defects:

- palette + `tRNS` transparency false-negative in validator;
- first red/yellow wagon transport bytes differed from verified deterministic outputs;
- source locomotive PNG IDAT is corrupt and Godot rejects it.

Recovery tests were added before fixes. Earlier import-safe recovery head `3cda0e3dbb1064899f9a25cb840b7a7ed82edf71` passed Contract/GUT/Godot/Thin and Windows subsequently passed.

Core result:

- three wagon v02 assets promoted at `0.74` centered scale;
- stars/stations/rails/markers promoted where source bytes are healthy;
- import-safe locomotive recovered from the exact approved E+D reference and registered with `REPLACE` provenance;
- corrupt locomotive candidate remains preserved under SX-DEC-051.

## Task 4 · RUN/control/support split — COMPLETE AS BOUNDED PACKAGE

Source health scan found exactly two corrupt candidates: locomotive and controls atlas. All other sources pass deep PNG stream validation.

Promoted or recovered only proven states:

- switch `left_selected` documented crop;
- switch `locked` documented crop;
- combo static;
- ghost route;
- cost HUD;
- success/failure shells;
- progress/meta primitive;
- seven control states (normal/hover/pressed/selected/disabled/locked/focus) recovered from the exact approved E+D UI reference and registered as `REPLACE` provenance.

Deliberately pending semantic work:

- stack next-unload-group and complete stack split;
- remaining switch selected directions not explicitly proven by source;
- train cargo strip smaller-wagon reconciliation;
- load-mode on/off naming because semantics are ambiguous;
- BUILD placement/palette/preflight full split;
- VFX causal split.

Product-root completeness RED head `132da08d3cdd3195d1101baa5fd4e73e80b0b5ad`: Contract `31313108286` expected FAIL while GUT/Godot/Thin/Windows PASS. After manifest registration, head `c47b05a6dbe869d2ed6f3142e1eecaab92efda84` passed Contract/GUT/Godot/Thin/Windows.

## Task 5 · Hero/control recovery metadata TDD — COMPLETE, FRESH CI PENDING

Test-first contract required the recovered locomotive and seven controls to exist in the product manifest and required the two corrupt candidates to be classified `REPLACE`.

Recovery asset head `e15f97b64e8f23efce7a281586ceae983682da0f` added the eight import-safe PNGs. Its PR test merge `804196b73a01a4640ba1e126504faed59a73add9` correctly failed the focused promotion contract because the newly added physical PNGs had not yet been registered in manifest authority.

Observed failure was exact and bounded:

- 8 unmanifested product PNGs;
- recovered locomotive/control product records missing from manifest;
- static validator failed for the same mismatch.

Root cause: recovery asset bytes and authority metadata were committed in the wrong order. No image regeneration was required.

Minimal correction:

- product manifest now declares 31 promoted PNGs;
- locomotive and controls candidate dispositions are `REPLACE`;
- recovered asset records carry product Git blob, source-candidate Git blob, exact approved-reference filename/SHA-256, dimensions, and `approved_reference_recovery` transform;
- README, Decision, and final asset list are synchronized to the recovered state.

## Task 6 · Exact-head review / merge / same-ID closure — IN PROGRESS

Current intended result before final CI:

- 31/31 candidate dispositions complete;
- 31 physical product PNGs manifested;
- 18 `PROMOTE_AS_IS` / 11 `PROMOTE_AFTER_REVISION` / 2 `REPLACE`;
- candidate provenance preserved;
- hero + seven controls import-safe recovery registered;
- runtime integration remains false;
- remaining semantic splits stay explicitly deferred.

Remaining execution is mechanical under the approved scope:

- receive fresh PR #122 exact-current-head/test-merge validation;
- adversarial full-diff review and review-thread check;
- expected-head squash merge when all required checks pass;
- merged-main readback and regression;
- same-ID Google Sheet synchronization to merged main;
- post-merge adversarial review and safe branch-cleanup decision.
