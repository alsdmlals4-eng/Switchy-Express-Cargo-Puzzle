# SX-AUD-036 · E+D Hybrid Asset Candidate Pack Audit

**Decision:** `SX-DEC-051`  
**Status:** `P0_CONTENT_VERIFIED · CLOSURE_HEAD_RECHECK_REQUIRED`  
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

That commit strengthened `tests/test_ed_hybrid_asset_pack.py` to require the full approved P0 roles. The manifest at that head still contained 16 assets and lacked:
- `cargo_star_red/blue/yellow`
- `station_red/blue/yellow`
- `rail_straight/curve/crossing/switch_three_way`
- `start_marker`
- `route_end_marker`
- `ghost_route`
- `cost_hud`
- `preflight_notice`

Therefore the strengthened role contract was RED even though the repository's general GitHub workflows succeeded. Those workflow successes are not substituted for the focused asset contract.

## Approved-scope correction

Fifteen text-free 64×64 alpha candidates complete the missing P0 roles. They preserve the approved E+D visual contract and remain:

`GENERATED_PRODUCTION_CANDIDATE · NOT_RUNTIME_INTEGRATED · NOT_FINAL_ASSET_APPROVED`.

No `.tscn`, `.tres`, Theme, Animation, signal, project setting, gameplay code, or runtime sprite hookup is changed.

## Station dimension integrity correction

A final byte audit found that the prepared red/yellow station sources were 128×128 while the manifest contract is 64×64. They were not accepted as-is.

At content head `97bc24fb87eb34229b790483470f939f0c66fec1` they were replaced with fresh 64×64 alpha-capable text-free candidates:

- `core_station_red_normal_v01.png` → Git blob `6cf21640eb0c9bd56cd081c2eb440183657f3393`
- `core_station_yellow_normal_v01.png` → Git blob `a9f51a0d987a8f1531a541ba97a06ca4903aeeb8`

GitHub readback confirmed both exact blob identities.

## Focused static verification

Current manifest blob remains the 31-record contract. Fresh checks against its exact bytes show:
- candidate count 31;
- all required P0 roles present;
- all required RUN/BUILD/control named slices present;
- every candidate remains `runtime_integrated=false` and `final_asset_approved=false` in the manifest.

The original 16 candidate PNGs received focused execution at validated head `b7cf608239cb59bd3d3989492d1478ab0c0090f2`:
- `python -m pytest tests/test_ed_hybrid_asset_pack.py -q` → PASS · 3/3;
- `python tools/validate_ed_hybrid_asset_pack.py` → PASS · 16/16.

A compare from that validated head to content head `97bc24fb...` shows none of those original 16 PNGs changed.

For the 15 compact P0 additions, a fresh byte-level cross-check against current GitHub directory/blob metadata shows:
- Git object SHA exact match: 15/15;
- dimensions: 64×64 for 15/15;
- alpha-capable PNG: 15/15.

This is recorded as `COMPOSED_STATIC_VERIFICATION_PASS`, not as a fictitious literal final-head pytest invocation.

## Content-head GitHub PR validation

Review/content head:
`97bc24fb87eb34229b790483470f939f0c66fec1`

Concurrent project main:
`6a7d1018fd235d564191fed3c05e946d07c129cf`

GitHub checkout evidence shows PR workflows tested merge ref:
`0421633b9d9431450a420b878c75492358c24d3f`

with commit message equivalent to merging `97bc24fb...` into `6a7d1018...`.

PASS:
- Project Contract `31280856490`
- GUT 9.7.1 Tests `31280856479`
- Godot Tests `31280856465`
- Validate Thin Adapter Migration `31280856475`

Because this audit/decision closure update itself changes the PR head, these runs are content-head evidence. The new closure head must receive a fresh exact PR validation set before merge.

## Concurrent main asset-vault policy drift

During fresh recovery, project `main` advanced to `6a7d1018fd235d564191fed3c05e946d07c129cf` with files tracked under `.asset-vault/library/gpt-imports/...` while project contract v4.4 treats `.asset-vault/` as LOCAL ONLY.

Classification:
`P2 · ASSET_VAULT_LOCAL_ONLY_TRACKED_ON_MAIN · USER_WORK_PRESERVATION_BLOCKS_AUTODELETE · FOLLOWUP_RECONCILIATION_REQUIRED`.

This is not silently fixed inside SX-DEC-051. The concurrent main commit does not alter SX-DEC-051 candidate/runtime integration, and the actual PR test-merge including that main commit passes the current automated gates. Removing those user-local candidate files is deferred to a bounded reconciliation task because destructive cleanup without proving local-user safety is forbidden.

## Historical transient CI note

An earlier PR head had one live-editor nested-regression timeout while standalone 92-case / 11,494-assertion regression passed; a no-source-change rerun passed. It remains classified:

`TRANSIENT_CI_RUNTIME_TIMEOUT · REPRODUCTION_NOT_CONFIRMED`.

It is historical evidence only and is not counted as final-head proof.

## Godot/runtime authority boundary

No `.tscn`, `.tres`, Theme, Animation, signal, project setting, gameplay code, or runtime sprite integration is part of this Decision. Connected HiGodot and physical runtime evidence remain NOT_RUN.

Windows physical runtime, Android device, human comprehension, runtime integration/POC, final product-asset approval, and cutover remain deferred.

## Current verdict

`P0_CONTENT_VERIFIED · COMPOSED_STATIC_VERIFICATION_PASS · TEST_MERGE_AUTOMATED_PASS · CLOSURE_HEAD_RECHECK_REQUIRED · RUNTIME_POC_DEFERRED`
