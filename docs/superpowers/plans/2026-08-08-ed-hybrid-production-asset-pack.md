# E+D Hybrid Production Asset Pack Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build the first GitHub-tracked E+D hybrid production-candidate art package for SX-DEC-051 without integrating it into Godot runtime.

**Architecture:** Generate/curate bounded candidates, keep them under `art/production_candidates/ed_hybrid_v1/`, isolate with `.gdignore`, and use a machine-readable manifest plus focused static contract. Runtime/POC remains a later Decision.

**Current correction:** the strengthened P0 contract at `261f25eda5a4cb8b545c7d11e1f14f60ba503cd0` exposed 15 missing approved roles. Continuous-work execution treats this as an in-scope technical completeness defect. The correction expands the candidate count from 16 to 31 without changing runtime authority.

## Required constraints

- Decision: `SX-DEC-051`
- Art direction: `E+D HYBRID · NEO-ARCADE READABILITY`
- Candidate state: `GENERATED_PRODUCTION_CANDIDATE · PROJECT_TRACKED · NOT_RUNTIME_INTEGRATED · NOT_FINAL_ASSET_APPROVED`
- locomotive remains visual anchor; wagons smaller
- color-only identity/state forbidden
- generated localized copy not used as reusable final art
- no `.tscn`, Resource, Theme, Animation, signal, gameplay code, project settings, runtime hookup, POC, Windows/Android physical validation or connected HiGodot work

## Task 1 — skeleton / validator

Completed on branch:
- `.gdignore`
- candidate README / manifest
- `tools/validate_ed_hybrid_asset_pack.py`
- `tests/test_ed_hybrid_asset_pack.py`

## Task 2 — P0 core + RUN/LIFO

Required core roles:
- locomotive_blue
- cargo_wagon_red/blue/yellow
- cargo_star_red/blue/yellow
- station_red/blue/yellow
- rail_straight/curve/crossing/switch_three_way
- start_marker / route_end_marker

Required RUN roles:
- stack_hud
- switch_direction
- train_cargo_strip
- load_mode
- combo_feedback

Current implementation adds the missing 12 core-world roles as text-free transparent candidates while preserving the pre-existing locomotive/wagon/RUN candidates.

## Task 3 — BUILD + controls

Required BUILD roles:
- build_states
- track_palette
- ghost_route
- cost_hud
- preflight_notice

Required control family:
- normal / hover / pressed / selected / disabled / locked / focus

Current implementation adds the missing ghost-route, cost-HUD and preflight candidates; existing placement/palette/control atlases remain.

## Task 4 — bounded P1

Existing bounded first set remains:
- static/Reduced Motion VFX
- text-safe success/failure shells
- text-safe progress/meta primitives

## Task 5 — exact-head closure

After current candidate commit is attached to the PR branch:
1. run/read focused candidate contract and validator against the 31 bytes;
2. read current PR head/base/test-merge identity;
3. require current-head Project Contract / GUT / Godot / Thin Adapter success;
4. inspect full diff for runtime-scope leakage and provenance violations;
5. update `SX-DEC-051`, `SX-AUD-036`, PR body, and configured Sheet with actual evidence only;
6. move Draft → Ready once gates are current;
7. merge under inherited user approval only if exact-head gates pass;
8. read back merged main and preserve all deferred runtime/device/human/final-asset gates.
