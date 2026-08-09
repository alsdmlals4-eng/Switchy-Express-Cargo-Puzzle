# SX-AUD-035 · Current Decision Registry Authority Refresh

**Date opened:** 2026-08-08 KST  
**Initial refresh date:** 2026-08-09 KST  
**Post-batch recurrence refresh:** 2026-08-09 KST  
**Related decisions:** `SX-DEC-027~053` status registry; no new Decision ID  
**Initial refresh baseline main:** `9db05c0cc9866eb3e4a7f014a1cfe289aa4447bd`  
**Initial refresh merge/main:** `24d2e1121be7f967dfdd5246e1070cde4214772c` · PR `#124`  
**Post-batch recurrence baseline main:** `2023f5c62afacfebd894010d3838880e6b7acf73`  
**Base readback:** `2a6ced23f6d6de1fb6e0a281c7138beb03f1a13b`

## Resolution

`BOUNDED_AUTHORITY_REFRESH · SAME_ID_SX-AUD-035 · POST_BATCH_RECURRENCE_REPAIRED · NO_PRODUCT_DIRECTION_CHANGE · NO_RUNTIME_CHANGE`

This audit tracks the bounded repair of `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md` when that compact registry drifts behind registered owner documents and the configured Google Sheet. It does not create gameplay/product rules and does not widen any runtime, device, physical, or human validation claim.

The original #124 refresh closed the older PR #106-era registry drift. After approved `SX-DEC-053` semantic-slice batch 1 was implemented and canonically closed by PRs #125/#126, a second bounded drift was detected: the compact registry still described 31 product assets and all semantic splits as pending while the `SX-DEC-053` / `SX-AUD-040` owner authority and Sheet correctly described 39 product assets, eight authoritative slices, and partial semantic completion.

This recurrence is repaired under the same `SX-AUD-035` because it is status-registry maintenance, not a new product decision.

## Fresh authority readback for recurrence repair

Required project-start recovery was performed again before editing:

- Base repository default branch: `main`;
- Base current main: `2a6ced23f6d6de1fb6e0a281c7138beb03f1a13b`;
- project default branch: `main`;
- project current main at recurrence-repair start: `2023f5c62afacfebd894010d3838880e6b7acf73`;
- project open PRs at recurrence-repair start: `0`;
- configured Google Sheet metadata/current `SX-DEC-053`, `SX-AUD-040`, visual-work rows, and `SX-AUD-035` were re-read live;
- `SX-DEC-053` and `SX-AUD-040` owner documents on current main were re-read;
- the compact current registry was re-read and the 31→39 drift reproduced before any write.

The project remains pinned to its configured Base authority by `AGENTS.md`; the newer Base upstream readback remains operational reference evidence and does not silently repin the project.

## Original stale conflict and #124 repair

Before PR #124, `CURRENT_CONFIRMED_DECISIONS.md` still reported an older PR #106-era snapshot and omitted decisions/evidence through `SX-DEC-053`. The bounded #124 repair refreshed exactly the registry and this audit, then synchronized the configured Sheet.

PR #124 evidence retained as historical authority-refresh proof:

- exact head `cbfbf8111d2a3aa664beef9cc917f73ef74c107f`;
- Project Contract `31318702082`: **PASS**;
- GUT `31318702125`: **PASS**;
- Godot `31318702096`: **PASS** including automated live-editor Pilot;
- Thin `31318702099`: **PASS**;
- unresolved review threads: **0**;
- test-merge had no PR-triggered runs;
- merge/main `24d2e1121be7f967dfdd5246e1070cde4214772c` readback: **PASS**.

That repair also reconciled the stale `SX-DEC-040` Sheet status to already-merged automated parity evidence without inventing physical PASS evidence.

## Post-batch recurrence reproduced

After `SX-DEC-053` semantic-slice batch 1:

- product implementation PR #125 merged as `b02649dddc88a5340695cfd18ea5a54ffe0540f0`;
- same-ID canonical closure PR #126 merged as `2023f5c62afacfebd894010d3838880e6b7acf73`;
- `SX-DEC-053`, `SX-AUD-040`, the product manifest, final product list, and configured Sheet all described **39** promoted product PNGs;
- the batch added exactly eight source-manifest-authoritative crops: Stack HUD 4 + BUILD placement/port 4;
- remaining semantic work was explicitly partial/deferred rather than wholly pending.

However, the compact registry on `2023f5c6...` still contained:

- `authority_snapshot_through_main: 9db05c0c...`;
- `visual_asset_state: ... 31_IMPORT_SAFE_PRODUCT_ASSETS ... SEMANTIC_SPLITS_PENDING`;
- `SX-DEC-053` row text saying 31 import-safe product assets / `IMPORT_SAFE_31_PROMOTED`;
- `Current Visual Asset Authority.product_assets: 31`;
- a pending list that treated the completed Stack/BUILD batch as wholly pending;
- latest delivery anchors ending at PR #122/#123 with no PR #125/#126 batch anchor.

This was a real GitHub compact-registry ↔ owner-doc/Sheet status conflict. No product semantics conflicted; only the summary lagged.

## Current evidence used for recurrence repair

### `SX-DEC-053` batch 1

Authoritative current product state:

- source candidates: **31**, immutable provenance under `SX-DEC-051`;
- dispositions unchanged: `18 PROMOTE_AS_IS / 11 PROMOTE_AFTER_REVISION / 2 REPLACE`;
- product PNGs: **39**;
- blue locomotive remains hero anchor;
- trailing wagon visual scale remains `0.74`;
- runtime integration remains false;
- authoritative semantic-slice batch 1: **8** crops.

Stack HUD authoritative crops:

- `run_stack_empty_v01`;
- `run_stack_32plus_v01`;
- `run_stack_unloading_v01`;
- `run_stack_top_highlight_v01`.

BUILD authoritative crops:

- `build_track_straight_valid_ghost_v01`;
- `build_track_straight_invalid_ghost_v01`;
- `build_track_curve_valid_ghost_v01`;
- `build_port_marker_left_v01`.

The source-authoritative `run_stack_unloading_v01` is not relabeled as predicted next-unload-group. No unnamed atlas region receives invented meaning.

Remaining semantic splits stay incomplete:

- distinct predicted next-unload-group plus compact/intermediate/paused Stack HUD coverage;
- remaining selected switch directions;
- train cargo strip reconciliation with the smaller-wagon hierarchy;
- load-mode atlas mapping for already-approved component states;
- remaining BUILD placement plus palette and complete preflight states;
- causal VFX state split and Reduced Motion equivalents.

### PR #125 technical evidence

- exact review head: `4e07fa5247a8fe743b0917b3595ce97585da82e9`;
- base: `24d2e1121be7f967dfdd5246e1070cde4214772c`;
- test merge: `32db76a79ab7a88f58969a836457f21b6aa6d732`;
- Project Contract `31320609585`: **PASS**, including focused final E+D product-asset validator;
- GUT `31320609590`: **PASS**;
- Godot `31320609574`: **PASS**;
- Thin `31320609566`: **PASS**;
- Windows Demo Export `31320609573`: **PASS**;
- unresolved review threads: **0**;
- merge/main: `b02649dddc88a5340695cfd18ea5a54ffe0540f0`.

Hosted Windows Demo Export is build/package evidence only; it is not Windows physical runtime evidence.

### PR #126 canonical closure evidence

- exact head: `c4ae59fe9bec6b8cac0f7167782ddb9c114967c7`;
- test merge: `b4095228f1e9f765becf7fbbeec30913421d36e6` with no separate PR-triggered run;
- Project Contract `31320780398`: **PASS**;
- GUT `31320780359`: **PASS**;
- Godot `31320780368`: **PASS**;
- Thin `31320780385`: **PASS**;
- unresolved review threads: **0**;
- closure/main: `2023f5c62afacfebd894010d3838880e6b7acf73`.

## Recurrence repair contract

The compact registry must now:

1. identify `2023f5c62afacfebd894010d3838880e6b7acf73` as the authority snapshot read before this repair;
2. preserve decision span `SX-DEC-027~053` and `SX-DEC-047 -> SX-DEC-048` supersession;
3. report visual state as 39 import-safe product assets, authoritative slice batch 1 = 8, semantic splits partial, runtime POC deferred;
4. update `SX-DEC-053` registry row to the same bounded 39/8 state;
5. preserve source disposition counts 18/11/2 and wagon scale 0.74;
6. record completed Stack 4 and BUILD 4 authoritative crops without conflating `unloading` with predicted next-unload-group;
7. narrow, rather than erase, the remaining six semantic work areas;
8. add PR #125/#126 delivery anchors;
9. preserve Windows physical runtime, Android device, connected physical editor, broader human validation, runtime integration, production cutover, and `.asset-vault` evidence ceilings;
10. create no new gameplay/product rule or balance choice.

## Expected changed surface

This recurrence repair is docs-only and must change exactly:

- `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`;
- `기획서/50_제작_검증/SX_AUD_035_CURRENT_DECISION_REGISTRY_STALE.md`.

No `.gd`, `.tscn`, `.tres`, `.res`, `project.godot`, workflow, plugin, candidate PNG, product PNG, test, validator, or `.asset-vault` byte belongs in this repair.

## Validation and delivery rule

Before merge:

- compare the branch against recurrence baseline `2023f5c62afacfebd894010d3838880e6b7acf73`;
- confirm exactly the two docs above changed;
- re-read exact PR HEAD and test-merge classification;
- require all applicable hosted checks green on the technical validation target;
- require unresolved review threads = 0 and mergeability true;
- use expected-head protection when merging.

After merge:

- re-read project main;
- synchronize the existing Sheet `SX-AUD-035` row with the recurrence-repair merge/main and exact CI evidence;
- do not rewrite already-correct `SX-DEC-053` / `SX-AUD-040` Sheet state unless a fresh conflict is found;
- re-read the Sheet row and compact registry state.

## Evidence ceiling after recurrence repair

Still open/deferred:

- full PC manual demo flow where separately recorded;
- remaining `SX-DEC-053` semantic splits listed above;
- `SX-DEC-053` Scene/Resource/Theme/Animation/signal/runtime integration / POC;
- Windows physical runtime / visual / audio / physical input: `NOT_RUN`;
- Android landscape device smoke: `NOT_RUN`;
- connected physical Godot/Hera authoring session: `NOT_RUN`;
- broader human/five-person comprehension: `NOT_RUN`;
- `.asset-vault` legacy untrack: `DEFERRED_PENDING_LOCAL_PRESERVATION_ATTESTATION`;
- production cutover: `BLOCKED_DEFERRED`.

The result is a current compact status registry. It is not a claim that the visual package or game is production-complete.
