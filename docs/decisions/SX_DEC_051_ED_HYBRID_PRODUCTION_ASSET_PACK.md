# SX-DEC-051 · E+D Hybrid Production Asset Pack

**Status:** `USER_APPROVED · PRODUCTION_CANDIDATE_CREATED · RUNTIME_POC_DEFERRED`  
**Date:** 2026-08-08 KST  
**Project baseline:** `827c5b9ffe2a9170ec099083cdd2a6942dff97f8`  
**Working branch:** `agent/ed-hybrid-asset-production-v1`

## Decision

승인된 `E+D HYBRID · NEO-ARCADE READABILITY` 방향으로 실제 제작/검토에 넘길 수 있는 production-candidate 이미지 패키지를 추적한다. 이 Decision은 Godot runtime integration 또는 final product-asset approval을 의미하지 않는다.

## Candidate package

- root: `art/production_candidates/ed_hybrid_v1/`
- tracked PNG candidates: **16**
- families: `core_world`, `run_lifo`, `build_states`, `controls`, `vfx`, `shells_result_meta`
- state: `GENERATED_PRODUCTION_CANDIDATE · PROJECT_TRACKED · NOT_RUNTIME_INTEGRATED · NOT_FINAL_ASSET_APPROVED`
- Godot import boundary: `art/production_candidates/.gdignore`
- provenance: `manifest.json` records source reference filename + SHA256 and per-file state.

## P0 coverage

- blue locomotive anchor + smaller red/blue/yellow cargo wagons
- RUN/LIFO stack, switch, train cargo strip, load mode, combo feedback
- BUILD placement preview + track palette
- common control/button states including normal/hover/pressed/selected/disabled/locked/focus

## P1 bounded first set

- static/Reduced Motion-compatible feedback/VFX
- text-safe success/failure result shells
- text-safe progress/meta primitives

## Adversarial review fixes

Within the approved scope, three technical findings were auto-fixed under continuous-work execution:

1. generated labels were removed from reusable train/switch candidates;
2. result shells were rebuilt as text-safe blank panels rather than generated localized copy;
3. progress/meta candidates were rebuilt without generated localized copy.

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

Static candidate contract is defined by:

- `tests/test_ed_hybrid_asset_pack.py`
- `tools/validate_ed_hybrid_asset_pack.py`

PR/exact-head CI evidence and merge SHA are recorded only after those checks actually run.
