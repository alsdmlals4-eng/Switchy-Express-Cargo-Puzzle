# Cargo Pickup Marker Visibility Design

**Decision ID:** SX-DEC-049  
**Date:** 2026-08-08 KST  
**Status:** USER_APPROVED_DESIGN · SHEET_SYNCED  
**Base authority:** `alsdmlals4-eng/Base@fa69a77a14f923a756064f6ae151d34cadb374f7`  
**Project baseline:** `main@21a98f534c4479d710a3ec33972c8eda73ca6805`

## Decision

When the train successfully picks up a map cargo marker such as the RED star, that marker disappears from the board immediately. Cargo that was not picked up remains visible. `Retry Same Layout` and a fresh run restore the authored cargo markers to their original cells.

This behavior is presentation state derived from the authoritative runtime cargo field; it does not change cargo rules, station rules, scoring, route behavior, map authoring, or authored placement data.

## User evidence carried forward

The user physically re-opened Godot 4.7.1 and confirmed all four previously pending current-main F5 checks as working:

1. three switch-direction arrows are visible,
2. BLUE cargo skipped -> BLUE terminal ends as `FAILURE / ROUTE_END` without assertion/process termination,
3. direct arrow selection, U-turn, and occupied-switch lock work,
4. final required delivery at a route end resolves SUCCESS before ROUTE_END.

This evidence closes the local current-main retest gap for SX-DEC-041, SX-DEC-042, and SX-DEC-046. It does not by itself close Windows export, Android-device, connected-HiGodot, or broader human-validation gates.

## Current behavior and root cause

`FixedCargoField.collect(cell)` already removes collected cargo from `_remaining_by_cell`, and `remaining_cells()` exposes the authoritative cells that still contain cargo.

`FiniteSliceSessionController._build_render_snapshot()` currently copies `_definition.cargo_placements` into `snapshot["cargo_placements"]` for every phase. `ProductBoardRenderer._draw_fixed_markers()` then draws every placement in that snapshot. Therefore the domain state correctly removes picked-up cargo while the board presentation continues drawing the authored marker.

## Considered approaches

### A. Filter the render snapshot from `FixedCargoField.remaining_cells()` — selected

Keep `_definition.cargo_placements` immutable. During an active run, derive `snapshot["cargo_placements"]` by filtering authored placements to cells still reported by the run session's cargo field. Outside an active run, keep the authored placements unchanged.

Benefits:
- uses the existing domain source of truth,
- keeps renderer presentation-only,
- preserves retry/reset semantics,
- requires no Scene/Resource/Theme/signal/project-setting edits,
- minimizes product-code surface.

### B. Mutate `_definition.cargo_placements` on pickup — rejected

This would mix authored map definition with per-attempt runtime state and make retry/fresh-run restoration more fragile.

### C. Let `ProductBoardRenderer` query the run session directly — rejected

This would couple a presentation component to gameplay/session internals and bypass the existing render-snapshot boundary.

## Architecture

The data flow remains:

`FiniteDeliveryLoop` -> `FixedCargoField` -> `FiniteSliceSessionController` -> render snapshot -> `ProductBoardRenderer`.

The controller gains one focused helper that returns visible cargo placements:

- if `_definition == null`: return `[]`,
- if `_run_session == null`: return authored `_definition.cargo_placements`,
- otherwise read `_run_session.delivery_loop.cargo_field().remaining_cells()` and keep only authored placements whose cells remain present.

`_build_render_snapshot()` uses that helper instead of copying the authored array unconditionally.

No new signal is required. Pickup already causes `FiniteDeliveryLoop` to emit a delivery event after collection; `_on_delivery_event_created()` already republishes state, so the next snapshot can remove the collected marker immediately.

## Retry and phase behavior

- **BUILD:** all authored cargo markers are visible.
- **RUNNING / UNLOADING:** only uncollected cargo markers are visible.
- **SUCCESS / FAILURE:** the final attempt state remains visible; already collected markers stay absent.
- **Retry Same Layout:** `FiniteRunSessionFactory.retry()` creates a new attempt, and `create_attempt()` constructs a fresh `FixedCargoField` from authored placements, so all markers reappear before subsequent pickups.
- **Edit Layout:** returning to BUILD shows authored markers again.
- **Fresh run/session initialization:** authored markers begin visible.

## Rendering contract

`ProductBoardRenderer` remains unchanged. It continues to draw exactly the `cargo_placements` supplied in the render snapshot.

Station markers are unaffected. A skipped cargo marker remains visible because it remains in `FixedCargoField.remaining_cells()`.

## Tests

Test-first coverage must prove:

1. initial render snapshot contains authored cargo placements,
2. successful pickup removes exactly the collected placement from the next render snapshot,
3. an uncollected/skipped placement remains visible,
4. `Retry Same Layout` restores the removed placement,
5. station placements are unchanged,
6. existing route-end, switch-direction, board-renderer, and full regression suites remain green.

The preferred regression location is a focused GUT integration test around `FiniteSliceSessionController`, because the defect is the session-to-render-snapshot boundary rather than `FixedCargoField.collect()` itself.

## Authority boundaries

This feature is GDScript/test/documentation work only. It must not directly edit:

- `.tscn` scenes,
- Godot Resources,
- Themes,
- Animations,
- signal wiring,
- `project.godot` settings,
- binary visual/audio assets.

Therefore the HiGodot single-authoring-authority gate is preserved and no connected HiGodot authoring session is required for this change.

## Acceptance criteria

SX-DEC-049 is complete when all of the following are true:

- collecting the RED star makes that board marker disappear on the next published runtime frame/snapshot,
- skipped/uncollected cargo stays visible,
- retry/fresh attempt restores authored cargo markers,
- no cargo-domain semantics are changed,
- automated focused and regression tests pass on the exact implementation head,
- the user physically confirms the behavior in Godot 4.7.1 F5 after syncing the merged main,
- GitHub authority evidence and the Google Sheet use the same `SX-DEC-049` identifier.
