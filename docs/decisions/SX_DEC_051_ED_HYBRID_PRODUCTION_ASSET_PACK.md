# SX-DEC-051 · E+D Hybrid Production Asset Pack

**Status:** `USER_APPROVED · PRODUCTION_CANDIDATE_CREATED · COMPLETE_P0_ROLE_COVERAGE · CONTENT_STATIC_VERIFIED · RUNTIME_POC_DEFERRED`  
**Date:** 2026-08-09 KST  
**Project baseline:** `827c5b9ffe2a9170ec099083cdd2a6942dff97f8`  
**Working branch:** `agent/ed-hybrid-asset-production-v1`

## Decision

승인된 `E+D HYBRID · NEO-ARCADE READABILITY` 방향으로 실제 제작/검토에 넘길 수 있는 production-candidate 이미지 패키지를 추적한다. 이 Decision은 Godot runtime integration 또는 final product-asset approval을 의미하지 않는다.

## Candidate package

- root: `art/production_candidates/ed_hybrid_v1/`
- tracked PNG candidates: **31**
- families: `core_world`, `run_lifo`, `build_states`, `controls`, `vfx`, `shells_result_meta`
- state: `GENERATED_PRODUCTION_CANDIDATE · PROJECT_TRACKED · NOT_RUNTIME_INTEGRATED · NOT_FINAL_ASSET_APPROVED`
- Godot import boundary: `art/production_candidates/.gdignore`
- provenance: `manifest.json` records source reference filename + SHA256 and per-file state.

## P0 coverage

Core/world:
- blue locomotive anchor + smaller red/blue/yellow cargo wagons
- red/blue/yellow cargo stars
- red/blue/yellow stations
- straight / curve / crossing / three-way-switch rail
- start marker / route-end marker

RUN/LIFO:
- stack HUD
- switch direction states
- train cargo strip
- load mode
- combo feedback

BUILD:
- placement preview
- track palette
- ghost route
- cost HUD
- preflight notice

Controls:
- normal / hover / pressed / selected / disabled / locked / focus

## P1 bounded first set

- static/Reduced Motion-compatible feedback/VFX
- text-safe success/failure result shells
- text-safe progress/meta primitives

## TDD and static verification

RED identity: `261f25eda5a4cb8b545c7d11e1f14f60ba503cd0`.

At that head the focused contract was strengthened to require the complete approved P0 role list while the manifest still contained 16 records. The missing 15 roles made that state RED.

The approved-scope correction brings the package to 31 candidates. The final two station candidates were additionally aligned to the manifest's 64×64 alpha contract at content head:

`97bc24fb87eb34229b790483470f939f0c66fec1`

Fresh composed static verification for that content identity:

- current manifest blob: 31/31 records, required roles complete, required RUN/BUILD/control slices complete;
- pre-existing 16 PNG candidates: previously focused-validated 16/16 and unchanged from validated head `b7cf608239cb59bd3d3989492d1478ab0c0090f2` to the content head;
- added compact P0 candidates: 15/15 local bytes match the GitHub blob SHA exactly; all are 64×64 and alpha-capable;
- `station_red` blob: `6cf21640eb0c9bd56cd081c2eb440183657f3393`;
- `station_yellow` blob: `a9f51a0d987a8f1531a541ba97a06ca4903aeeb8`.

The composed verification is equivalent to the focused validator's relevant invariants but is not mislabeled as a literal final-head pytest invocation.

## Content-head PR validation

For content head `97bc24fb87eb34229b790483470f939f0c66fec1`, GitHub PR workflows checked out test-merge:

`0421633b9d9431450a420b878c75492358c24d3f`

which merged that head into concurrent main `6a7d1018fd235d564191fed3c05e946d07c129cf`.

PASS runs:

- Project Contract `31280856490`
- GUT 9.7.1 Tests `31280856479`
- Godot Tests `31280856465`
- Validate Thin Adapter Migration `31280856475`

This documentation update changes the PR head, so the final closure head must receive a fresh PR validation set before merge. The user approval remains valid; only technical evidence is refreshed.

## Explicit boundary

Still deferred / NOT_RUN:
- Godot Scene/Resource/Theme/Animation/signal authoring
- runtime sprite hookup and actual HUD implementation
- POC
- Windows physical runtime
- Android device validation
- connected HiGodot validation
- human comprehension testing
- final product-asset approval
- cutover
