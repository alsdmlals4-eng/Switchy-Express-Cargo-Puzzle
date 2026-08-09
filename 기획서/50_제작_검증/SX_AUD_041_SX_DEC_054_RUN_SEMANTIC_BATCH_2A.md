# SX-AUD-041 · SX-DEC-054 RUN Semantic Batch 2A

**Date:** 2026-08-10 KST  
**Decision:** `SX-DEC-054`  
**Implementation baseline main:** `bf0146bf51eb6b7a54d1ac219b021a6a41225c4c`  
**Implementation branch:** `agent/sx-dec-054-run-semantic-batch-2a`  
**Product PR:** `#129`  
**Product merge/main:** `35b93f3a15f35780b12cd4e8887c8e06f8ade72b`  
**Status:** `MERGED_MAIN_VERIFIED · RUN_BATCH_2A_20_SEMANTIC_PNGS · STATIC_PACKAGE_PASS · RUNTIME_NOT_INTEGRATED`

## Scope

Audit the first implementation batch of the user-approved semantic-first independent asset strategy. RUN Batch 2A covers Stack HUD remainder, train cargo strip composition semantics, load-mode semantics, and switch presentation states while preserving the existing procedural direction authority.

This audit does not claim Godot runtime hookup, Windows physical runtime, Android device, connected physical editor, human/playtest, `.asset-vault` cleanup, or release cutover.

## Authority and ownership

- visual authority: `SX-DEC-053` / `E+D HYBRID · NEO-ARCADE READABILITY`;
- component-state authority: `SX-DEC-050`;
- switch directional authority: `SX-DEC-042 · SX-DEC-046 · VIS-014`;
- baseline product owner: `art/product_assets/ed_hybrid_v1/manifest.json` / `SX-DEC-053` / 39 PNGs;
- semantic owner: `art/product_assets/ed_hybrid_v1/semantic_manifest_sx_dec_054.json` / `SX-DEC-054` RUN 2A / 20 PNGs;
- ownership overlap: forbidden and statically checked;
- physical product-root total after product merge: 59 PNGs.

The three ambiguous historical RUN atlases for train cargo strip, load mode, and switch direction are preserved under `PRESERVE_REFERENCE_ONLY_NO_STATE_MAPPING`. No unnamed atlas region is assigned a new semantic meaning.

## TDD lineage

### RED

Exact RED head: `f774a56e64e257aaf347baa8847b259269fcf7cc`.

The focused `SX-DEC-054` contract existed before the sidecar/assets. Windows Demo Export failed in `Run Python contracts`, establishing the missing semantic package before GREEN. Contract/GUT/Godot/Thin baseline workflows otherwise remained healthy.

### Initial GREEN and root-cause correction

20 deterministic semantic PNG primitives plus the sidecar were added and the `SX-DEC-053` validator ownership boundary was partitioned.

First GREEN candidate `3ff7408495cab552c4fd17795114350438369e06` exposed a legacy test assumption: `tests/python/test_final_ed_product_asset_promotion.py` still asserted that every PNG under the shared product root belonged to the 053 manifest. This was a stale single-owner test contract, not a product-asset defect.

The minimal correction requires:

- 053 paths unique;
- 054 paths unique;
- 053/054 ownership disjoint;
- union of both manifests equals the physical product-root PNG set.

No 053 disposition, recovery, crop, scale, CRC/zlib, or runtime check was weakened.

### Confirmed intermediate GREEN

Exact head after the ownership-test correction: `4bcb414108cf2f1893e66acbd742a1802b2cdec9`.

- Project Contract `31342060979`: **PASS**;
- GUT 9.7.1 `31342060990`: **PASS**;
- Godot Tests `31342060973`: **PASS**;
- Validate Thin Adapter Migration `31342060986`: **PASS**;
- Windows Demo Export `31342060975`: **PASS**.

## RUN Batch 2A coverage

### Stack HUD

Physical semantic assets: 5.

States: `compact`, `8plus`, `16plus`, distinct predicted `unload_group`, `paused`.

The existing 053 `unloading` slice remains a separate event state and is not relabeled.

### Train cargo strip

Physical reusable primitives: 3.

Composition states: `empty`, `tokens_1_3`, `compressed_plus_n`, `unload_transition`.

Existing cargo token assets and the approved 0.74 smaller-wagon hierarchy remain reusable inputs; `N` remains runtime data rather than baked copy.

### Load mode

Physical reusable primitives: 8.

Composition states: `manual_idle`, `manual_held`, `auto_off`, `auto_on`, `paused_disabled`, `input_received`.

The old load-mode atlas is preserved as reference only and is not used as semantic crop authority.

### Switch presentation

Physical reusable overlays: 4.

Composition states: `three_visible`, `selected`, `unselected`, `occupied_locked`, `inactive`.

No new directional arrow coordinate system was created. Direction geometry remains procedural under the existing authority.

## Static contract

The focused validator checks:

- `SX-DEC-054` authority fields and `RUN_2A` batch identity;
- exact required semantic state sets;
- exactly 20 unique physical semantic PNG paths;
- PNG signature/chunk CRC/IDAT decode/dimensions/alpha capability;
- filename/path convention;
- sidecar↔physical 054 ownership agreement;
- disjoint ownership from the 39 053 paths;
- preservation of ambiguous atlases without semantic crop claims;
- existence/authority of composition inputs;
- procedural switch authority;
- `runtime_integrated=false` globally and per asset/composition;
- baseline 053 ownership count remains 39.

The existing 053 validator continues to own and verify its disposition/recovery/crop/scale/integrity contract while excluding explicitly sidecar-owned 054 PNGs from its own physical ownership set.

## Final exact-head validation and merge

PR `#129` final review identity:

- base: `bf0146bf51eb6b7a54d1ac219b021a6a41225c4c`;
- exact review head: `34ab2b907190f69775ace8e89c32f689ba17bc35`;
- compare: ahead 10 / behind 0;
- changed files: 29;
- mergeable: true;
- unresolved review threads: 0.

Exact-head workflows:

- Project Contract `31342194367`: **PASS**;
- GUT 9.7.1 `31342194376`: **PASS**;
- Godot Tests `31342194392`: **PASS**;
- Validate Thin Adapter Migration `31342194374`: **PASS**;
- Windows Demo Export `31342194375`: **PASS**.

PR `#129` was squash-merged with expected-head protection against `34ab2b907190f69775ace8e89c32f689ba17bc35`.

- product merge/main: `35b93f3a15f35780b12cd4e8887c8e06f8ade72b`;
- merged-main readback: **PASS**;
- product package: 39 `SX-DEC-053` PNGs + 20 `SX-DEC-054` RUN 2A PNGs = 59 physical product PNGs with disjoint ownership.

Hosted Windows Demo Export PASS is build/package evidence only and is not Windows physical runtime evidence.

## Adversarial scope result

The product comparison contained only approved semantic-asset package surfaces: 20 new RUN PNGs, 054 sidecar, plan/decision/audit/asset-list docs, focused validators/tests, and minimal 053 ownership coexistence changes.

It did **not** mutate gameplay/domain rules, `.tscn`, `project.godot`, Godot Resource/Theme/Animation/signal authoring, plugin state, runtime hookup, or `.asset-vault` bytes.

## Deferred evidence

`RUNTIME_POC_DEFERRED · WINDOWS_PHYSICAL_NOT_RUN · ANDROID_DEVICE_NOT_RUN · CONNECTED_PHYSICAL_EDITOR_NOT_RUN · HUMAN_NOT_RUN · ASSET_VAULT_UNTRACK_DEFERRED`

## Closure and Sheet rule

This docs-only merged-main closure records the verified product merge evidence without changing product assets or runtime surfaces. After the closure PR merges, synchronize Google Sheet using the same `SX-DEC-054` and `SX-AUD-041` IDs, with the closure merge/main as the final Sheet canonical reference. Do not promote hosted CI into physical/device/human evidence.