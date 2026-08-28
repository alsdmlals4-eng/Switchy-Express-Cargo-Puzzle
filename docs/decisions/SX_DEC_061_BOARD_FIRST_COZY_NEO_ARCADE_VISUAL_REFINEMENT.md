# SX-DEC-061 · Board-first Cozy Neo-Arcade Visual Refinement

Status: `APPROVED · 2026-08-28 KST · DOCUMENTATION_ONLY · RUNTIME_UNCHANGED`

Tracking: GitHub Issue #228

## Decision

Keep the approved E+D Hybrid / Neo-Arcade railway world, but make the board and action-feedback hierarchy the visual authority during play:

```text
cozy miniature railway world
→ board-first planning and execution
→ dark framed control-deck UI
→ redundant state feedback
→ visible LIFO/TOP and cause-based result learning
```

The user selected this direction after comparing it with a storybook-first alternative and a dense simulation-dashboard alternative. The selected option gives the finite rail puzzle its clearest player-facing identity without adding systems or replacing existing runtime art.

## Adopted elements

- Warm, readable miniature terrain; brass/navy locomotive; practical warm light; elevated isometric 3/4 board camera.
- Deep-navy/charcoal panels with restrained gold trim. The board, rails, cargo, stations, switches, and their current Godot feedback remain more visually important than decoration.
- Lime for valid/selected states, crimson for invalid/`ROUTE_END`, violet for a bounded tutorial focus; all decision-critical states retain a non-colour signal such as route direction, icon, outline, lock, shape, brightness, or Godot text.
- Cargo remains color + silhouette redundant. Unlimited LIFO is represented with a compact train token plus a Stack HUD: TOP and the next unload group must remain legible without extending the train horizontally.
- Failure is a short causal debrief that leads to same-layout Retry or Edit. It does not invent a score, economy, save, leaderboard, or fabricated trace.

## Rejected elements

- Reference-image layout, logos, typography, copied chrome, or text embedded in raster images.
- Coin/budget dashboards, score/ranking/three-star states, save buttons, and any other unimplemented system.
- Diagonal/station-footprint delivery, invented station radius, fuel, BOOST, capacity limit, endless mode, or auto-generated gameplay asset work.

## Confirmed flow and visual anchors

The planning owner `기획서/40_표현/PROJECT_CORE_SCENE_VISUAL_BOARD.md` is the exact flow reference:

```text
Title → T1 build → T2 cardinal station service → T3 LIFO reverse planning
→ T4 selective non-load/revisit → T5 manual/auto choice → T6 switch execution
→ VS_DEMO_01 capstone → result/retry/edit
```

This entire chain, not one attractive still, is the approved Phase 5 human-validation unit.

## Scope and proof boundary

- This is a visual-direction and structured-planning decision. It changes no GDScript, Scene, Resource, map, asset consumer, runtime screenshot, test result, acceptance candidate, or human/device evidence.
- Existing runtime consumers and the 73 existing semantic product PNGs remain the production baseline. Any future runtime visual work requires an exact Godot node/key/path consumer, a separate implementation approval, tracked project-local GitHub file, SHA-256/provenance, and the relevant runtime/human validation.
- The generated `PROJECT_CORE_SCENE_VISUAL_BOARD` is `GENERATED_EXPLORATION`, not a runtime asset, approved project asset, or Godot implementation. Its binary is not being promoted until the user explicitly accepts that specific board as a durable reference.

## Validation

| Validation | Status |
|---|---|
| Current visual direction vs GMB-002/SX-DEC-060 product rules | PASS · documentation comparison |
| Current visual direction vs actual runtime asset consumers | PASS · no consumer change proposed |
| Generated board semantic review | PARTIAL · text owner is the structured scene-board document; generated pictograms are non-canonical |
| Godot runtime/UI validation | NOT_RUN · unchanged runtime |
| Windows/Android/audio/five-person/player-experience | NOT_RUN · existing Phase 5 gate remains open |

## Provenance

- Current owner: `기획서/40_표현/VISUAL_DIRECTION.md`
- Planning flow owner: `기획서/40_표현/PROJECT_CORE_SCENE_VISUAL_BOARD.md`
- Generated-board record: `docs/ASSET_RIGHTS_AND_PROVENANCE_RECORD.md` · `SX-VIS-061-CORE-SCENE-BOARD-EXPLORATION-001`
- User-provided comparison collage: reference-only; no embedded instruction, approval label, fake UI state, or claimed runtime proof was inherited.
