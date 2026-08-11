# SX-DEC-055 Phase B Readiness Amendment

**Decision:** `SX-DEC-055`  
**Audit:** `SX-AUD-047`  
**Date:** 2026-08-11 KST  
**Status:** `PHASE_B_APPROVED_PLAN_DELTA · NO_NEW_PRODUCT_DECISION`

This document is a narrow amendment to the existing implementation plan:

`docs/superpowers/plans/2026-08-10-sx-dec-055-runtime-semantic-poc.md`

It does not replace or duplicate that plan. All original task ordering, interfaces, protected areas, RED/GREEN requirements, semantic boundaries, and merge gates remain authoritative except for the packaging addition below.

## Why this amendment exists

Phase B found one deployment-readiness gap that the original DoR plan did not make explicit.

The approved runtime catalog reads semantic JSON sidecars as plain files. The existing finite map loader also reads map JSON with `FileAccess`. Current `export_presets.cfg` uses `export_filter="all_resources"` but has an empty non-resource `include_filter` for both `Android Validation` and `Windows Demo`.

Godot's export contract distinguishes resources from non-resource files such as `.json`; a successful export command therefore does not by itself prove those JSON files are present in the resulting PCK/APK.

The POC must not be considered acceptance-build-capable until exported runtime data presence is proven.

## Added protected constraint

Do not use a broad `*.json` export include if a narrower filter can satisfy runtime needs. The repository contains operational/tooling/docs JSON that does not belong in the product package.

The intended non-resource export scope is limited to runtime-owned data:

```text
data/maps/*.json
art/product_assets/ed_hybrid_v1/*.json
```

If Godot's preset filter syntax requires equivalent path/glob spelling, use the narrowest functionally equivalent form and test the exported pack.

Do not add docs, skill registries, tooling snapshots, work-instruction JSON, or production-candidate manifests to the product package merely to make a broad wildcard easy.

## Task 9A — Non-resource JSON export contract

Insert this task after existing Task 8 and before the original full-regression/export-acceptance portion of Task 9.

**Expected files:**

- Modify: `export_presets.cfg`
- Add or extend a focused automated contract test under `tests/` or `tests/python/` that can inspect the preset and/or exported pack deterministically.
- Do not modify `project.godot` for this purpose.

### Step 9A.1 — RED

Add a focused test that fails on current main because the acceptance-relevant presets do not explicitly include the runtime JSON paths.

The test must require both presets to cover at minimum:

```text
res://data/maps/vs_demo_01.json
res://data/maps/fp_core_proof_01.json
res://data/maps/map_catalog_vs03.json
res://art/product_assets/ed_hybrid_v1/manifest.json
res://art/product_assets/ed_hybrid_v1/semantic_manifest_sx_dec_054.json
res://art/product_assets/ed_hybrid_v1/semantic_manifest_sx_dec_054_build_2b.json
res://art/product_assets/ed_hybrid_v1/semantic_manifest_sx_dec_054_vfx_2c.json
```

Use the current preset semantics rather than assuming that `export_filter="all_resources"` includes non-resource JSON.

Verify the RED failure is specifically the missing non-resource inclusion contract.

### Step 9A.2 — Minimal GREEN

Update `export_presets.cfg` for both `Android Validation` and `Windows Demo` with the narrow runtime JSON include scope.

Do not alter:

- preset names;
- package ID;
- custom features;
- export paths except where the test harness uses a temporary override;
- architecture/signing policy;
- main-scene feature overrides;
- resource exclusion behavior unrelated to runtime JSON.

Re-run the focused contract test and require GREEN.

### Step 9A.3 — Exported-pack proof

For the Windows acceptance-relevant preset, produce a temporary exported pack/build on the exact implementation head and verify that the required runtime JSON files can be opened from the exported project/PCK context.

Preferred proof order:

1. export using the normal `Windows Demo` preset;
2. inspect or execute a deterministic probe against the exported package;
3. require the finite map JSON and all four approved semantic product manifests above to be readable;
4. require catalog initialization from exported paths to succeed;
5. keep this result classified as packaging/runtime-data evidence, not physical Windows runtime PASS.

If the repository's existing export workflow cannot execute the probe inside the packaged runtime, add the smallest deterministic package-content inspection available in CI. Do not substitute a source-tree existence check for exported-pack proof.

### Step 9A.4 — Android consistency

The `Android Validation` preset must use the same runtime JSON inclusion rule so the finite map/semantic data contract is not platform-dependent.

Android export/package proof remains distinct from Android physical-device PASS.

## Regression addition

Original Task 9 must additionally verify:

- runtime JSON export filter is still present for both acceptance-relevant presets;
- exported package contains the exact runtime-owned JSON set required by the finite demo and semantic catalog;
- no broad unrelated JSON export was introduced without explicit review;
- source semantic sidecars remain byte-identical and `runtime_integrated=false` provenance is unchanged.

## Phase B conclusion

This amendment closes a deployment-mechanics P1 without changing gameplay, semantic meaning, product assets, domain events, or the first implementation step.

The first Phase C action is still:

`Task 1 / Step 1.1 — RED: tests/demo/test_semantic_asset_catalog.gd`

Task 9A becomes mandatory before hosted export evidence can satisfy the POC's final automated packaging gate.