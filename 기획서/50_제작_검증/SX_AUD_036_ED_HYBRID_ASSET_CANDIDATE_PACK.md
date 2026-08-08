# SX-AUD-036 · E+D Hybrid Asset Candidate Pack Audit

**Decision:** `SX-DEC-051`  
**Status:** `MERGED_MAIN_VERIFIED · COMPOSED_STATIC_VERIFICATION_PASS · POST_MERGE_AUTOMATED_PASS · RUNTIME_POC_DEFERRED`  
**Date:** 2026-08-09 KST

## Scope audited

`art/production_candidates/ed_hybrid_v1/` is a GitHub-tracked production-candidate tree isolated from current Godot runtime import authority by `.gdignore`. No runtime hookup is part of this audit.

## Candidate counts

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

RED head: `261f25eda5a4cb8b545c7d11e1f14f60ba503cd0`.

The focused contract was strengthened to require the full approved P0 role list while the manifest still contained 16 assets. It exposed 15 missing roles: cargo stars, stations, four rail roles, start/route-end markers, and BUILD ghost-route/cost-HUD/preflight roles.

Those roles were added inside the approved candidate-only scope. No `.tscn`, `.tres`, Theme, Animation, signal, project setting, gameplay code, or runtime sprite hookup was changed.

## Station dimension integrity correction

A byte audit found the prepared red/yellow station sources were 128×128 while the manifest contract is 64×64. At content head `97bc24fb87eb34229b790483470f939f0c66fec1` they were replaced with fresh 64×64 alpha-capable text-free candidates:

- `core_station_red_normal_v01.png` → Git blob `6cf21640eb0c9bd56cd081c2eb440183657f3393`
- `core_station_yellow_normal_v01.png` → Git blob `a9f51a0d987a8f1531a541ba97a06ca4903aeeb8`

GitHub readback confirmed both exact blob identities.

## Focused static verification

Current manifest contract contains 31 records and all required P0 roles/slices. Every candidate remains `runtime_integrated=false` and `final_asset_approved=false`.

The original 16 candidate PNGs received focused execution at validated head `b7cf608239cb59bd3d3989492d1478ab0c0090f2`:
- `python -m pytest tests/test_ed_hybrid_asset_pack.py -q` → PASS · 3/3;
- `python tools/validate_ed_hybrid_asset_pack.py` → PASS · 16/16.

A compare from that validated head through content head `97bc24fb...` showed none of those original 16 PNGs changed.

For the 15 compact P0 additions, fresh byte-level cross-check against current GitHub metadata showed:
- Git object SHA exact match: 15/15;
- dimensions: 64×64 for 15/15;
- alpha-capable PNG: 15/15.

Verdict: `COMPOSED_STATIC_VERIFICATION_PASS`. This is intentionally not mislabeled as a literal final-head pytest invocation.

## Final PR validation identity

PR `#113`  
Final review head: `d821d5df322ca01c4c1ba4f90cf4e7fc9a9ea817`  
Concurrent main: `6a7d1018fd235d564191fed3c05e946d07c129cf`  
Final test merge: `2317ace7e515b7b0ced4960677973d04cb1d0080`

PASS:
- Project Contract `31281126087`
- GUT 9.7.1 Tests `31281126091`
- Godot Tests `31281126089`
- Validate Thin Adapter Migration `31281126092`

PR #113 had zero review/comment threads, was Ready and mergeable, and was squash-merged using exact expected head protection.

## Merged-main readback and regression

SX-DEC-051 product merge/main anchor:
`21c229cd0dbc6895040176ca030a80d82abb4035`

GitHub main readback confirmed the signed merge commit and open PR count returned to zero.

Post-merge PASS on that merged main:
- Project Contract `31281240244`
- GUT 9.7.1 Tests `31281240267`
- Godot Tests `31281240234`
- Validate Godot Live-Editor Pilot `31281240589`

Therefore the previous `CLOSURE_HEAD_RECHECK_REQUIRED` state is closed. This post-merge documentation reconciliation changes no candidate bytes and no runtime code.

## Concurrent main asset-vault policy drift

Fresh recovery found files tracked under `.asset-vault/library/gpt-imports/...` while project contract v4.4 treats `.asset-vault/` as LOCAL ONLY.

Classification:
`P2 · ASSET_VAULT_LOCAL_ONLY_TRACKED_ON_MAIN · USER_WORK_PRESERVATION_BLOCKS_AUTODELETE · FOLLOWUP_RECONCILIATION_REQUIRED`.

The conflict is preserved rather than destructively cleaned inside SX-DEC-051. A separate bounded reconciliation must prove local-user safety before removal or migration.

## Historical transient CI note

An earlier PR head had one live-editor nested-regression timeout while standalone 92-case / 11,494-assertion regression passed; a no-source-change rerun passed. It remains historical only:
`TRANSIENT_CI_RUNTIME_TIMEOUT · REPRODUCTION_NOT_CONFIRMED`.

## Godot/runtime authority boundary

No `.tscn`, `.tres`, Theme, Animation, signal, project setting, gameplay code, or runtime sprite integration is part of this Decision. Connected HiGodot and physical runtime evidence remain NOT_RUN.

Windows physical runtime, Android device, human comprehension, runtime integration/POC, final product-asset approval, and cutover remain deferred.

## Current verdict

`MERGED_MAIN_VERIFIED · COMPLETE_P0_ROLE_COVERAGE · COMPOSED_STATIC_VERIFICATION_PASS · POST_MERGE_AUTOMATED_PASS · RUNTIME_POC_DEFERRED · ASSET_VAULT_RECONCILIATION_FOLLOWUP`
