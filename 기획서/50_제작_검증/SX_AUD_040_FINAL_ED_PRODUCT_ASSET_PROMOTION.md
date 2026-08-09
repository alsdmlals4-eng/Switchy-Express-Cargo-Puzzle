# SX-AUD-040 · Final E+D Product Asset Promotion

**Date:** 2026-08-09 KST  
**Decision:** `SX-DEC-053`  
**Baseline main:** `95dda145b518ce29bead78a5cbf5566cfa675419`  
**PR:** `#122`  
**Status:** `IMPLEMENTATION_CANDIDATE · DISPOSITION_31_COMPLETE · IMPORT_SAFE_23_PROMOTED · FINAL_HEAD_RECHECK_REQUIRED · RUNTIME_POC_DEFERRED`

## Scope

Audit the first deterministic product-asset promotion batch for the user-approved `E+D HYBRID · NEO-ARCADE READABILITY` direction. The work is asset/provenance/static-contract only. It does not author Godot scenes/resources/themes/animations/signals and does not claim runtime integration.

## TDD evidence

### RED 1 · missing product authority

Head `8930a9543b90711328e2210372d18a3fdcdf07ab`  
Project Contract `31310286681` expected FAILURE.

The focused promotion contract ran before implementation and failed because `art/product_assets/ed_hybrid_v1/manifest.json` did not exist.

### GREEN 1 · disposition ledger

All 31 `SX-DEC-051` candidates received exactly one disposition. Project Contract `31310452557` passed the initial ledger contract.

### RED 2 · validator absent

Head `491ce03b8964f16a7beae5e2daac8f13653af23d`  
Project Contract `31310521719` expected FAILURE.

The sole new failure was the intentionally missing product-promotion validator.

### GREEN 2 · static validator

Head `1a5fa3fe798451509c5f727ebbb005c737808c08`  
Project Contract `31310592671` PASS.

### RED 3 · core batch absent

Head `e6e03ee5921548251f6013ad53cbce411629c541`  
Project Contract `31310641256` expected FAILURE.

The product manifest still contained no promoted core assets, so the newly required core set failed as intended.

## Adversarial recovery findings

### Initial core attempt exposed hidden candidate defects

Initial promotion commit: `791548c63006d7167f5f71a6adcf79dabbf66d60`.

This attempt failed Contract/GUT/Godot/Windows while Thin remained green. Investigation separated three causes:

1. the first validator treated only PNG color types 4/6 as alpha-capable and falsely rejected palette PNGs that use a valid `tRNS` transparency chunk;
2. first red/yellow wagon uploads did not match the locally verified deterministic outputs, exposing a transport-integrity problem;
3. the source locomotive PNG itself contains a corrupt IDAT stream. The candidate package had been hidden from Godot import by `.gdignore`, so this defect was not previously exposed.

The broken locomotive product copy was removed. The source candidate was preserved for provenance and reclassified to `PROMOTE_AFTER_REVISION`.

### Recovery RED

Head `bdadd142083295b68a63584a9ae9d6b81fdab6fe` intentionally added tests for:

- palette + `tRNS` transparency;
- corrupt IDAT rejection;
- keeping the invalid locomotive pending rather than promoting it;
- import-safe core coverage.

The expected failure proved the stricter contract before the fix.

### Import-safe recovery GREEN

Head `3cda0e3dbb1064899f9a25cb840b7a7ed82edf71`:

- Project Contract `31312215293` PASS;
- GUT `31312215273` PASS;
- Godot Tests `31312215361` PASS;
- Thin Adapter `31312215329` PASS;
- Windows Export subsequently PASS.

Red/yellow wagon v02 product blobs were replaced with exact bytes matching the verified deterministic 0.74 centered-scale outputs.

## Source health scan

The validator was strengthened to verify PNG signature, per-chunk CRC, concatenated IDAT zlib decompression, dimensions, and transparency semantics.

Result across all 31 source candidates:

- healthy source PNGs: **29**;
- corrupt source PNGs: **2**.

Corrupt sources:

1. `art/production_candidates/ed_hybrid_v1/core/core_train_locomotive_blue_normal_v01.png`;
2. `art/production_candidates/ed_hybrid_v1/ui/ui_button_controls_states_v01.png`.

Both are now non-AS-IS dispositions. No corrupt source is allowed to remain `PROMOTE_AS_IS`.

Health-report head `d9d2f29567969a8da6ad8e0d8bf4c43c0eb2b0da` passed Project Contract `31312574440` with `pending_corrupt_sources=2`.

## Safe RUN/support promotion

Only semantically proven deterministic states were promoted:

- switch `left_selected`: exact documented crop `[6,5,54,50]`;
- switch `locked`: exact documented crop `[68,5,54,50]`;
- combo static primitive;
- ghost-route primitive;
- cost-HUD primitive;
- success result shell;
- failure result shell;
- progress/meta primitive.

The product-root completeness contract was then added. Head `132da08d3cdd3195d1101baa5fd4e73e80b0b5ad` expectedly failed Project Contract `31313108286` only because the newly staged product PNGs were not yet represented in the manifest; GUT/Godot/Thin/Windows all passed, proving those bytes imported safely.

## 23-asset batch GREEN

Manifest registration commit `c47b05a6dbe869d2ed6f3142e1eecaab92efda84` passed:

- Project Contract `31313291931`;
- GUT `31313291991`;
- Godot Tests `31313291985`;
- Thin Adapter `31313291935`;
- Windows Export `31313291959`.

The validator was then aligned with the same physical-tree completeness rule.

Final implementation candidate head before this audit: `fc886198cebde08f6c57e04de46e8c1b07530d2d`.

Fresh PASS at that head:

- Project Contract `31313421289`;
- GUT `31313421335`;
- Godot Tests `31313421291`;
- Thin Adapter `31313421305`;
- Windows Demo Export `31313421296`.

## Promotion result

Source candidates: **31**.

Disposition ledger:

- `PROMOTE_AS_IS`: **18**;
- `PROMOTE_AFTER_REVISION`: **13**;
- `REPLACE`: **0**.

Current manifested product PNGs: **23**.

Three wagon v02 assets use deterministic centered scale `0.74` on the original transparent 128×96 canvas. No gameplay collision or route geometry was changed.

## Intentionally pending

Not promoted as complete:

- locomotive import-safe final revision;
- seven-state controls revision from the corrupt source atlas;
- complete stack HUD state split, especially distinct next-unload-group semantics;
- remaining switch selected directions beyond the explicitly documented crop;
- train cargo strip after smaller-wagon hierarchy reconciliation;
- load-mode state naming while on/off semantics remain ambiguous;
- BUILD placement/palette/preflight complete product state split;
- VFX causal state split.

This is intentional evidence-preserving partial delivery, not an incomplete claim disguised as completion.

## Adversarial scope check

The batch must not mutate:

- gameplay/domain code;
- `.tscn` scenes;
- Resource/Theme/Animation/signal authoring;
- `project.godot`;
- Godot AI/GUT/Hera plugin state;
- `.asset-vault` bytes.

No new concept image generation is part of this promotion batch.

## Deferred gates

Preserved:

`ASSET_VAULT_UNTRACK_DEFERRED_EXTERNAL_EXECUTOR · VAULT_LOCAL_STATE_UNVERIFIED · RUNTIME_POC_DEFERRED · WINDOWS_PHYSICAL_NOT_RUN · ANDROID_DEVICE_NOT_RUN · CONNECTED_PHYSICAL_EDITOR_NOT_RUN · HUMAN_NOT_RUN`

## Finalization rule

This audit is not the final merge claim. The documentation/audit commit that contains this text must receive a fresh exact PR test-merge validation before PR #122 may leave Draft and merge.
