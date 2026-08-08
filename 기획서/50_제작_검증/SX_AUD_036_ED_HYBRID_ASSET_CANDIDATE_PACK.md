# SX-AUD-036 · E+D Hybrid Asset Candidate Pack Audit

**Decision:** `SX-DEC-051`  
**Status:** `P0_COMPLETENESS_FIX_PREPARED · FINAL_HEAD_RECHECK_REQUIRED`  
**Date:** 2026-08-09 KST

## Scope audited

`art/production_candidates/ed_hybrid_v1/` is a GitHub-tracked production-candidate tree isolated from current Godot runtime import authority by `.gdignore`. No runtime hookup is part of this audit.

## Candidate counts after P0 completeness correction

| Family | Count | Main roles |
|---|---:|---|
| core_world | 16 | locomotive, 3 wagons, 3 cargo stars, 3 stations, 4 rail types, start, route-end |
| run_lifo | 5 | stack HUD, switch states, train strip, load mode, combo |
| build_states | 5 | placement preview, track palette, ghost route, cost HUD, preflight notice |
| controls | 1 | seven common interaction states |
| vfx | 1 | static/Reduced Motion feedback primitives |
| shells_result_meta | 3 | success shell, failure shell, progress/meta |
| **Total** | **31** | |

## TDD completeness finding

RED head: `261f25eda5a4cb8b545c7d11e1f14f60ba503cd0`

That commit strengthened `tests/test_ed_hybrid_asset_pack.py` to require the full approved P0 roles. The manifest at that head still contained 16 assets and lacked:
- `cargo_star_red/blue/yellow`
- `station_red/blue/yellow`
- `rail_straight/curve/crossing/switch_three_way`
- `start_marker`
- `route_end_marker`
- `ghost_route`
- `cost_hud`
- `preflight_notice`

Therefore the new focused role contract was RED even though the repository's existing four GitHub workflows all completed successfully on that head. Those workflow successes are not substituted for the focused asset-contract result.

## Approved-scope technical correction

Fifteen text-free 64×64 alpha candidates were created under the existing E+D visual contract. They use shape/form redundancy, preserve rail-connectivity readability, contain no localized/generated copy, and remain:
`GENERATED_PRODUCTION_CANDIDATE · NOT_RUNTIME_INTEGRATED · NOT_FINAL_ASSET_APPROVED`.

No `.tscn`, `.tres`, Theme, Animation, signal, project setting, gameplay code, or runtime sprite hookup is changed.

## Provenance

Existing source-reference SHA256 records are preserved. The new compact candidates cite approved visual-language anchors:
- `네온_기차_퍼즐_게임_자산_시트.png` → `edd9b76558755e1fa603d5d3c373be57e9325055a2a1f5c92ff0b0bda88f5b8d`
- `imagegen.png` → `739b1caacd691851a29e6cb6b0803e37d0413d5cdce69b1ff6df634806b8fa3b`

## Historical PR validation

Earlier PR heads had focused validator/test PASS for the 16-asset contract. One earlier Godot live-editor nested-regression attempt timed out while standalone 92-case / 11,494-assertion regression passed; a no-source-change rerun passed. It remains classified:
`TRANSIENT_CI_RUNTIME_TIMEOUT · REPRODUCTION_NOT_CONFIRMED`.

That historical evidence is not counted as current-head proof after the strengthened P0 test.

## Current verification requirement

After the completeness-fix commit:
1. focused static test/validator must be actually run against the 31 candidate bytes when available;
2. Project Contract, GUT, Godot Tests and Thin Adapter must be read on the new PR validation identity;
3. full diff must remain candidate/tests/docs only with runtime integration absent;
4. PR body, Sheet, and Decision/Audit authority must use the actual current head/test-merge identity.

Until then:
`FINAL_HEAD_RECHECK_REQUIRED`.

## Deferred

- runtime/POC
- Windows physical runtime
- Android device
- connected HiGodot
- human comprehension
- final product-asset approval
- cutover
