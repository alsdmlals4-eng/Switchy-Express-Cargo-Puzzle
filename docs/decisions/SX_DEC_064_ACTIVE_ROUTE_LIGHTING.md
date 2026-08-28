# SX-DEC-064 · Active-route lighting

**Status:** `MERGED_MAIN_VERIFIED · PR #249 · main 2b98c0b070f2d8670b6432ac769a130bdd83bc39 · CI 7 GREEN · AUTOMATED_VERIFIED`
**Date:** 2026-08-29 KST
**Tracking:** GitHub Issue #248
**Predecessors:** SX-DEC-060 finite route controls; SX-DEC-062 board-first composition; SX-DEC-063 visual alignment

## Decision

In RUN, a player sees a lime glow and direction cue only on the rail route the train will traverse under the **current** direct-control selections. A branch that the train will not take remains normal/unlit. The direct-control overlay can still show a dim alternate target so a player can configure it; that target is an input affordance, not a lit rail state.

```text
actual train cell + actual approach cell
→ existing FiniteTrackGraph reads current switch/crossing selections
→ ProductBoardRenderer projects only the deterministic forward continuation
→ lime line + direction cue
→ separate crimson occupied-lock cue
→ no predictive route light after SUCCESS / FAILURE
```

The pre-RUN fallback uses authored `start_cell + incoming_cell` only when the runtime has no train cell/approach cell yet. The projection is descriptive. It neither solves, chooses, scores, changes, nor validates the route.

## Player value

- **Action:** choose a legal branch before it becomes occupied.
- **Information:** the bright rail makes the immediate consequence of the current setting visible from the train’s real position.
- **Choice:** change a dim alternate target now, or keep the configured path and protect the current plan.
- **Feedback:** after the switch becomes occupied, the same selected route stays bright while a crimson lock tells the player why that choice can no longer change.
- **Learning:** a terminal result shows factual outcome/recovery without falsely suggesting a future route from a stopped train.

## Exact consumer and implementation contract

| Concern | Owner | Required behavior |
| --- | --- | --- |
| Current route root | `game/finite/main/finite_slice_session_controller.gd` | Include `train_previous_cell` in the render snapshot together with the existing train cell. |
| Rail projection | `game/demo/presentation/product_board_renderer.gd` | Begin at actual train state, calculate the current deterministic graph continuation, and emit selected descriptors only for that continuation. |
| Alternate input | `game/demo/presentation/route_control_overlay.gd` | Keep existing dim selectable control targets; do not add a parallel rail-light descriptor. |
| Occupied control | existing route-control snapshot | Draw lock as a separate crimson icon/cue over the selected rail, never as a red alternate route. |
| Terminal result | renderer phase gate | Return no predictive route descriptors for `SUCCESS` and `FAILURE`. |

## Scope and exclusions

**In scope:** procedural `CanvasItem` overlay, one presentation snapshot field, route-clarity/contract tests, current GitHub documents, and the approved planning-reference preservation.

**Out of scope:** finite graph semantics, route selection/movement, maps/data/schema, station service, cargo/LIFO, first-session content, result truth, AI route solver, score/economy/progression, bitmap assets, audio/locales, Base pin, Notion, and PR #174.

## Feasibility and evidence

- Official Godot `CanvasItem` documentation confirms `_draw()`/`draw_line()` and `queue_redraw()` for state-driven custom 2D overlays; the existing `ProductBoardRenderer` already uses this supported consumer boundary. [CanvasItem](https://docs.godotengine.org/en/stable/classes/class_canvasitem.html) · [Custom drawing in 2D](https://docs.godotengine.org/en/4.5/tutorials/2d/custom_drawing_in_2d.html)
- RED first recorded that the old projection incorrectly retained passed/unselected/terminal route descriptors. GREEN tests now require actual train-root prediction, no alternate rail light, separate lock truth, pre-RUN fallback, active phases, and terminal clearing.
- Local Godot full runner: `112 cases / 13,513 assertions` PASS on the branch.
- Exact post-064 package candidate: `SX60-POC-ACCEPT-004` from `main@58b99f261c3576150ab275bb041d744c69b83538`; workflow run `33190345143`, PCK 500/500 integrity PASS, and no-launch package verification PASS.
- No correct live Switchy editor instance was available and headless frame capture did not produce an eligible same-state composite. Pixel composite, Windows/device, audio-perceptual, human comprehension, Player Experience, release, and production-cutover evidence are `NOT_RUN`.

## Acceptance gates before status promotion

1. Exact-head PR CI and a safe merge must pass before `MERGED_MAIN_VERIFIED` is written.
2. Satisfied: Candidate 004 is the only exact package candidate; Candidate 003 is historical pre-SX-DEC-064 evidence.
3. A same-state actual Switchy runtime render at supported gameplay scale must verify that only the current route glows, the dim alternate remains an input target, and the lock does not obscure the selected direction.
4. No automated/package result may be relabeled as human or Player Experience proof.

## Visual and provenance boundary

No image asset is created for this decision. The user-approved `SX-VIS-061-CORE-SYSTEMS-BOARD-EXPLORATION-002B` is preserved separately at `docs/visual-references/sx-vis-061-core-systems-board-exploration-002b.png` as a planning reference only. It is not a runtime consumer, UI implementation, or evidence for this decision.
