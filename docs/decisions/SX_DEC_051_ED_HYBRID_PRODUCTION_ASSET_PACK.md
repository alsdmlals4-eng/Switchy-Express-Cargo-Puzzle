# SX-DEC-051 · E+D Hybrid Production Asset Pack

**Status:** `USER_APPROVED · PRODUCTION_CANDIDATE_CREATED · COMPLETE_P0_ROLE_COVERAGE · RUNTIME_POC_DEFERRED`  
**Date:** 2026-08-08 KST  
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

## Continuous-work TDD correction

At head `261f25eda5a4cb8b545c7d11e1f14f60ba503cd0`, the focused test was strengthened to require the complete approved P0 role list. The then-current 16-record manifest did not contain 15 required roles, so that state is the RED contract state.

The approved-scope correction adds 15 compact, text-free 64×64 alpha candidates for the missing star/station/rail/start/route-end and BUILD ghost/cost/preflight roles, bringing the package to 31 candidates. This is a candidate-package completeness fix only; it does not expand runtime scope.

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

## Verification

Static candidate contract:
- `tests/test_ed_hybrid_asset_pack.py`
- `tools/validate_ed_hybrid_asset_pack.py`

Current exact-head CI/static evidence and merge SHA must be recorded only after they actually run.
