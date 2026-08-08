# SX-AUD-034 · Cargo Pickup Marker Visibility Implementation

**Decision ID:** SX-DEC-049  
**Visual ID:** VIS-015  
**Date:** 2026-08-08 KST  
**PR:** #110 `feat: hide collected cargo markers`  
**Base authority:** `alsdmlals4-eng/Base@fa69a77a14f923a756064f6ae151d34cadb374f7`  
**Project baseline:** `main@21a98f534c4479d710a3ec33972c8eda73ca6805`

## Verdict

`IMPLEMENTED_ON_PR · TDD_RED_GREEN_VERIFIED · AUTOMATED_EXACT_HEAD_PASS_AT_IMPLEMENTATION_COMMIT · PHYSICAL_F5_PICKUP_RETRY_PENDING`

The collected map cargo marker is now derived from the active attempt's authoritative `FixedCargoField` rather than being rendered unconditionally from authored placements. Authored map data remains immutable, skipped cargo remains visible, and retry/fresh attempts restore the authored marker set.

## Root cause

Before SX-DEC-049, `FixedCargoField.collect(cell)` correctly removed picked-up cargo from its runtime `_remaining_by_cell`, but `FiniteSliceSessionController._build_render_snapshot()` always copied `_definition.cargo_placements` into the render snapshot. `ProductBoardRenderer` therefore continued to draw a marker that no longer existed in runtime cargo state.

The renderer itself was not the defect source: it correctly draws the snapshot it receives.

## TDD RED evidence

RED head: `22c16c31bb05429bdda357997cf8caab4d06dcc7`

At this head the PR contained the approved design, implementation plan, and focused GUT integration test, with **no production implementation change**.

Exact-head checks:

- `GUT 9.7.1 Tests` run `31252998342`: **FAILURE — expected RED**
- `Project Contract` run `31252998349`: PASS
- `Validate Thin Adapter Migration` run `31252998336`: PASS
- `Godot Tests` run `31252998373`: PASS

The GUT failure was the intended behavioral defect, not a setup or parse error:

- expected visible cargo count after first pickup: `3`; actual: `4`,
- expected collected pickup cell to be absent; it was still present,
- overall GUT result: `18/19` tests passing, `142/144` assertions passing.

This proves the new test failed against the old production behavior for the exact requested reason before the fix was applied.

## GREEN implementation

Implementation head: `4e3bc4031117dd925ff0120bdf7f691d2ea9eb99`

Production change surface relative to RED head:

- modified only `game/finite/main/finite_slice_session_controller.gd`,
- `+29/-1`,
- replaced unconditional authored `cargo_placements` snapshot publication with `_visible_cargo_placements()`,
- added a small placement-cell normalization helper because map placement cells may be encoded as `Vector2i`, `[x, y]`, or `{x, y}`.

`_visible_cargo_placements()` behavior:

- no definition -> no cargo placements,
- no active run -> authored cargo placements,
- active run -> filter authored placements by `delivery_loop.cargo_field().remaining_cells()`.

No mutation is made to map definition, cargo field, station data, renderer state, route state, or scoring/delivery rules.

## GREEN exact-head evidence

At implementation head `4e3bc4031117dd925ff0120bdf7f691d2ea9eb99`:

- `GUT 9.7.1 Tests` run `31253130298`: PASS
  - Godot `4.7.1`
  - GUT `9.7.1`
  - `19/19` tests PASS
  - `144` assertions PASS
  - focused `test_pickup_hides_marker_and_retry_restores_authored_markers`: `1/1` PASS
  - route-end ordering: `6/6` PASS
  - switch reciprocity: `5/5` PASS
  - one-sided station parity: `2/2` PASS
  - route-control overlay: `3/3` PASS
  - route-control state: `2/2` PASS
  - JUnit discovery/validation PASS
  - protected production-tree mutation verification PASS
- `Project Contract` run `31253130297`: PASS
- `Validate Thin Adapter Migration` run `31253130309`: PASS
- `Godot Tests` run `31253130321`: PASS
  - headless-tests job PASS
  - real-project live-editor Pilot step PASS
- `Windows Demo Export` run `31253130293`: PASS

## Behavioral contract now covered automatically

The focused integration regression verifies in a real finite-session flow:

1. BUILD starts with all 4 authored cargo markers,
2. after the first successful pickup exactly one marker disappears,
3. the collected cell is absent from the next render snapshot,
4. every other not-yet-collected cargo marker remains visible,
5. station placements are unchanged,
6. the canonical run still reaches SUCCESS,
7. `Retry Same Layout` restores all authored cargo markers.

## Full PR scope review

PR #110 was reviewed against `main@21a98f534c4479d710a3ec33972c8eda73ca6805`.

Product behavior code is limited to `game/finite/main/finite_slice_session_controller.gd`. The remaining changed files are the SX-DEC-049 design, implementation plan, focused GUT regression, and this audit.

Not changed:

- `ProductBoardRenderer`,
- `FixedCargoField` / delivery semantics,
- map JSON or map-definition semantics,
- route-end logic,
- switch logic,
- `.tscn` scenes,
- Godot Resources,
- Themes,
- Animations,
- signal wiring,
- `project.godot`,
- binary visual/audio assets.

Therefore the HiGodot single-authoring-authority boundary remains intact; no connected HiGodot authoring session was required for this GDScript/test/documentation change.

## User physical evidence carried forward

The user's 2026-08-08 Godot 4.7.1 current-main F5 evidence for SX-DEC-041/042/046 remains valid and separately recorded:

- 3-direction arrows visible,
- direct selection / U-turn / occupied lock PASS,
- BLUE no-cargo terminal -> `FAILURE / ROUTE_END` without assertion/process termination,
- final required delivery -> SUCCESS priority.

This does **not** constitute physical evidence for the new SX-DEC-049 behavior because that implementation was not on merged main at the time of the user's test.

## Remaining gate

After PR #110 is merged and the user's checkout is synced to the resulting main commit, physical Godot 4.7.1 F5 validation must still confirm:

1. a successfully picked-up RED star disappears immediately,
2. skipped/uncollected cargo remains visible,
3. `Retry Same Layout` restores the authored markers.

Until that evidence is supplied, SX-DEC-049 physical status is:

`PHYSICAL_F5_PICKUP_RETRY_NOT_RUN_AFTER_IMPLEMENTATION`

Windows export automation PASS is packaging/build evidence only; physical Windows launch/visual/input remains a separate gate. Android-device, connected-HiGodot, and broader human validation also remain separate/not run unless independently evidenced.

## Closure handling

This audit commit is documentation-only and therefore changes the PR head after the implementation-head verification above. Required final PR exact-head checks must be re-read after this audit commit before merge. Their final outcomes belong in the PR/Sheet closure record; no PASS may be inferred before those runs complete.
