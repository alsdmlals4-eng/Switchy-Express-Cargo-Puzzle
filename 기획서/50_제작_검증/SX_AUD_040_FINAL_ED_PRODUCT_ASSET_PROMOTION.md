# SX-AUD-040 · Final E+D Product Asset Promotion

**Date:** 2026-08-09 KST  
**Decision:** `SX-DEC-053`  
**Baseline main:** `95dda145b518ce29bead78a5cbf5566cfa675419`  
**Product PR:** `#122`  
**Product merge/main:** `57dbdd9be2cc70e0c9b973d502f57bd725b045cb`  
**Status:** `MERGED_MAIN_VERIFIED · DISPOSITION_31_COMPLETE · IMPORT_SAFE_31_PROMOTED · HERO_CONTROLS_RECOVERED · CONTROL_NORMAL_BYTE_INTEGRITY_REPAIRED · RUNTIME_POC_DEFERRED`

## Scope

Audit the deterministic product-asset promotion batch for the user-approved `E+D HYBRID · NEO-ARCADE READABILITY` direction. This work is asset/provenance/static-contract only. It does not author Godot scenes/resources/themes/animations/signals and does not claim runtime integration.

## Test-first lineage

Legitimate RED/GREEN evidence was produced throughout PR #122:

- missing product authority RED: head `8930a9543b90711328e2210372d18a3fdcdf07ab`, Project Contract `31310286681` expected FAILURE;
- validator-absent RED: head `491ce03b8964f16a7beae5e2daac8f13653af23d`, Project Contract `31310521719` expected FAILURE;
- core-batch-absent RED: head `e6e03ee5921548251f6013ad53cbce411629c541`, Project Contract `31310641256` expected FAILURE;
- source-health recovery established PNG signature/chunk CRC/IDAT decompression/dimensions/transparency checks;
- the 23-asset intermediate batch passed Contract/GUT/Godot/Thin/Windows at `fc886198cebde08f6c57e04de46e8c1b07530d2d` before later hero/control recovery expanded the physical product set.

Earlier passing heads remain historical TDD/regression evidence only. The final merge gate used the final exact PR head described below.

## Source-health result

All 31 `SX-DEC-051` source candidates have exactly one disposition.

Deep source scan result:

- healthy source PNGs: **29**;
- corrupt historical candidates: **2**;
- corrupt candidates: locomotive source and controls-atlas source;
- both corrupt sources remain preserved for provenance and are classified `REPLACE`, never `PROMOTE_AS_IS`.

Current disposition counts:

- `PROMOTE_AS_IS`: **18**;
- `PROMOTE_AFTER_REVISION`: **11**;
- `REPLACE`: **2**;
- total: **31**.

## Current promoted product set

Physical product PNGs: **31**.

Coverage:

- core world: blue hero locomotive, three smaller cargo wagons, red/blue/yellow cargo stars, red/blue/yellow stations, committed rail primitives, start/route-end markers;
- RUN: documented switch left-selected + occupied-lock slices and Reduced-Motion-compatible combo primitive;
- BUILD: ghost-route and cost-HUD primitives;
- UI: seven independent square-blue control states (`normal/hover/pressed/selected/disabled/locked/focus`);
- shells/meta: text-safe success/failure shells and progress primitive.

The three cargo wagon v02 assets retain the approved centered visual scale **0.74** on the original 128×96 canvas. Gameplay collision/domain geometry is unchanged.

## Hero/control recovery

The corrupt historical locomotive candidate and control-atlas candidate were not overwritten. Product replacements were recovered under exact approved E+D reference provenance:

- locomotive reference SHA-256: `edd9b76558755e1fa603d5d3c373be57e9325055a2a1f5c92ff0b0bda88f5b8d`;
- controls reference SHA-256: `34f4fefeabdd0030b0689868899cd71e4cf694e475f12280bb75ea61aa25d6d7`.

A later exact-head CI attack exposed one additional transport-integrity defect in the promoted `normal` control PNG: its recovered scanline payload remained decodable only when the invalid zlib checksum trailer was ignored, while the stored PNG IDAT CRC/zlib checksum failed the strict validator.

Bounded recovery:

- no pixel redesign and no new concept generation;
- recovered the exact original scanlines from the existing promoted file;
- re-encoded only the PNG zlib/CRC container;
- repaired Git blob: `2ed8efe5911cd93a307aaafcefa713380014a581`;
- repaired-file SHA-256: `9c1e434448915882a11589d1a9dc067d296e3613d67245512a9623055a1804bc`;
- manifest records the integrity-only repair explicitly.

This preserves the approved visual pixels while restoring import-safe file integrity.

## Still deferred inside the visual package

The 31 promoted files are the current bounded product-asset batch, not a claim that every future semantic split exists. Still deferred:

- complete Stack HUD state split, including distinct next-unload-group semantics;
- remaining selected switch directions beyond the documented current crop;
- train cargo strip reconciliation with the smaller-wagon hierarchy;
- load-mode on/off/processing semantics;
- BUILD placement/palette/preflight complete state split;
- causal VFX state split.

These remain `PROMOTE_AFTER_REVISION` work and do not justify inventing ambiguous semantics from the current atlases.

## Final exact-head validation

Final PR validation identity:

- `review_head_sha`: `e7a4f2e81355991cde632f0581baf62b6eb45a46`;
- `base_sha`: `95dda145b518ce29bead78a5cbf5566cfa675419`;
- `test_merge_sha`: `fd9e72f2fde02d0126e57c5fe86d573a4cf6cffd`;
- no PR-triggered workflow runs existed on the test-merge commit, therefore `ci_validation_target_sha = e7a4f2e81355991cde632f0581baf62b6eb45a46`.

Final exact-head results:

- Project Contract `31316685124`: **PASS**; focused `Validate final E+D product asset promotion` step **PASS**;
- GUT 9.7.1 `31316685079`: **PASS**; JUnit discovery and protected production tree verification **PASS**;
- Godot Tests `31316685077`: **PASS**;
- Validate Thin Adapter Migration `31316685080`: **PASS**;
- Windows Demo Export `31316685064`: **PASS**;
- unresolved review threads: **0**;
- PR Ready / mergeable at final check: **PASS**.

## Adversarial scope check

The final 41-file PR diff was re-read before merge. It did not mutate:

- gameplay/domain code;
- `.tscn` scenes;
- Resource/Theme/Animation/signal authoring;
- `project.godot`;
- Godot AI/GUT/Hera plugin state;
- `.asset-vault` bytes.

The Project Contract workflow change only makes the focused `SX-DEC-053` static contract an active CI consumer. No new concept image generation is part of this batch.

The PR description was also corrected before merge so its documented final scope matched the actual 41-file implementation rather than the historical three-file Draft scope. This metadata correction did not change the reviewed HEAD.

## Merge and main readback

PR `#122` was squash-merged with exact-head protection against `e7a4f2e81355991cde632f0581baf62b6eb45a46`.

- merge commit: `57dbdd9be2cc70e0c9b973d502f57bd725b045cb`;
- merged at: `2026-08-09T13:57:33Z`;
- GitHub main readback: **PASS**;
- current main contains the 31-product package, manifest, focused contract/validator, SX-DEC-053 canon, and this SX-AUD-040 audit.

The squash merge commit itself has no separate PR-triggered workflow run. That absence is not converted into a runtime/device success claim; the final PR-head CI remains the technical merge evidence and merged-main ancestry/readback is the repository delivery evidence.

## Deferred gates

Preserved:

`ASSET_VAULT_UNTRACK_DEFERRED_EXTERNAL_EXECUTOR · VAULT_LOCAL_STATE_UNVERIFIED · RUNTIME_POC_DEFERRED · WINDOWS_PHYSICAL_NOT_RUN · ANDROID_DEVICE_NOT_RUN · CONNECTED_PHYSICAL_EDITOR_NOT_RUN · HUMAN_NOT_RUN`

## Closure and Sheet rule

This same-ID closure changes only `SX-DEC-053` and `SX-AUD-040` documentation to replace `FINAL_HEAD_RECHECK_REQUIRED` with the verified merged-main evidence above. It does not reopen the approved visual direction and does not mutate product assets or runtime surfaces.

Google Sheet synchronization is intentionally performed after this closure is merged, using the closure merge/main SHA as the Sheet's final canonical commit reference. The Sheet must preserve the same `SX-DEC-053` and `SX-AUD-040` IDs and must not claim runtime/device/human validation that was not run.
