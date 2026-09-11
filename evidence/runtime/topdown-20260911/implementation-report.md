# Task 1 report: approved blue top-down consumers and overhead motion

## Status

`IMPLEMENTED_MACHINE_VERIFIED_ON_BRANCH` at base/starting HEAD
`f236de79761eff2cde281f3c3ef4f4e31e456701`. No push, merge, live-editor
operation, runtime capture, or human pixel review was performed by this task.
Initial implementation commit: `af49284`; Retry cancellation correction: `cab1b55`.
This report was relocated from temporary SDD scratch into the permanent runtime evidence owner.

## Authority and execution route

- Project operating contract: `python tools/validate_project_contract.py` -> `project operating contract: PASS`.
- Work mode: bounded Godot product implementation continuation.
- Selected routes: project-local `switchy-express-design`; Base shared
  `maintaining-project-context-and-handoff`, `auditing-and-refining-ui-art`,
  `reviewing-and-validating-project-changes`, and
  `running-adversarial-review-and-refinement`; Superpowers TDD.
- Exact task authority: Task 1 of `docs/superpowers/plans/2026-09-11-topdown-unification.md`.
- Existing project worktree remained dirty. Only files listed below were staged.

## Implemented result

- Copied the user-approved blue station and cargo candidate bytes, unchanged,
  into `art/product_assets/topdown_v1/`.
- Added a family manifest recording user approval, exact source paths, SHA-256,
  RGBA dimensions/alpha, concrete consumer, unchanged semantic anchors, and
  the existing cargo marker scale ceiling (`0.62`).
- Connected `ProductBoardRenderer` `station_blue` and `cargo_blue` slots to the
  new family.
- Removed the active `CARGO_LIFT_TEXTURE`/atlas-region consumer. Historical
  `night_workshop_v1/cargo_lift.png` bytes and manifest remain preserved.
- Replaced frame selection with a 0.24-second presentation-only timeline:
  static approved top lid, local upward position offset (maximum 0.16 of the
  unchanged cargo marker target) and opacity fade. Reduced motion has zero
  displacement and opacity-only feedback.
- Preserved pause, replacement, retry/edit cancellation, local pickup cell,
  domain event timing, map coordinates, renderer-only authority, and the
  unchanged `CARGO_MARKER_SCALE` target. Transparent padding is not trimmed or
  compensated by enlargement.
- Updated the existing runtime QA helper to sample position/opacity instead of
  obsolete atlas frame indices; it was not executed because runtime capture is
  controller-owned.

## TDD evidence

### RED

Command:

```text
python -m unittest tests.python.test_night_workshop_runtime_assets -v
```

Observed result before production changes:

```text
FAILED (errors=1)
FileNotFoundError: art/product_assets/topdown_v1/manifest.json
```

The failure was caused by the missing approved top-down family/consumer
implementation, not by a test syntax error.

### GREEN and focused checks

```text
python -m unittest tests.python.test_night_workshop_runtime_assets -v
Ran 3 tests ... OK
```

Exact copied-byte readback:

```text
station_blue.png SHA-256 4837c23361147da72bae9f88c5c15372f57ef0fa8e804b48c0297bdb2cc50a6e
cargo_blue.png   SHA-256 58ed699689e88f0f8f3cdd14cd20f28611ea235e049a5182bef087fd09df2360
```

## Full regression

The controller confirmed the Godot slot was clear before both runs.

First full Godot run (expected integration finding after raw binary copy):

```text
Godot 4.7.1 --headless --path . --script res://tests/run_tests.gd
TEST SUMMARY: cases=121 failed=2 assertions=14500
```

Only `station_blue` and `cargo_blue` Texture2D load checks failed because their
new `.import` descriptors did not yet exist. An isolated headless editor import
generated their two descriptors. It also refreshed pre-existing/untracked
workspace imports, none of which are owned or staged by this task.

Second full Godot run:

```text
TEST SUMMARY: cases=121 failed=0 assertions=14500
```

Full Python run first exposed one expected stale consumer assertion in
`test_sx_dec_063_core_board_asset_promotion.py`; the assertion was updated to
preserve the historical v04 asset evidence while recognizing the approved new
blue consumers. Final run:

```text
python -m unittest discover -s tests/python -p 'test_*.py' -q
Ran 262 tests in 11.134s
OK (skipped=1)
```

The existing skip remains a skip, not a PASS. Existing two corrupt deferred
candidate-source diagnostics were printed by the suite and remain outside this
task; the final E+D promotion validator still reported PASS for its bounded
contract.

Additional checks:

```text
python tools/validate_project_contract.py
project operating contract: PASS

git diff --check -- <owned files>
PASS (no whitespace errors; only existing Windows LF/CRLF notices)

rg -n "CARGO_LIFT_TEXTURE|cargo_lift\.png|frame_index\(" game tests -g '*.gd' -g '*.py'
Only negative-regression assertions mention CARGO_LIFT_TEXTURE/cargo_lift.png;
no active GDScript consumer or frame_index call remains.
```

## Five-pass adversarial self-review

1. Consumer/scope: verified only blue station/cargo paths and the pickup
   presentation changed; red/yellow/waste, rail, train, gameplay data, and
   domain timing are untouched. Finding: stale tests; corrected and regressed.
2. Visual/scale: verified the renderer reuses `_marker_target_rect(false, ...)`
   unchanged and does not grow/trim the 1254x1254 source. The faint alpha-noise
   bounding box was not treated as a tight extent. No finding remains.
3. Motion/accessibility: verified normal position+opacity, reduced-motion zero
   position, pause freeze, rapid replacement, expiration, and edit/retry
   cancellation. No finding remains.
4. Provenance/import: verified exact source/target byte equality, SHA-256,
   RGBA alpha extrema, manifest consumer paths, and both Texture2D imports.
   Finding: missing new `.import` descriptors; generated and regressed.
5. Evidence/legacy: verified historical oblique atlas bytes remain recoverable
   but unconsumed; no runtime/human/release claim is made. Full Godot/Python and
   contract regression are green. No blocking finding remains.

## Files owned by this task

```text
art/product_assets/topdown_v1/cargo_blue.png
art/product_assets/topdown_v1/cargo_blue.png.import
art/product_assets/topdown_v1/station_blue.png
art/product_assets/topdown_v1/station_blue.png.import
art/product_assets/topdown_v1/manifest.json
game/demo/presentation/cargo_pickup_animation.gd
game/demo/presentation/product_board_renderer.gd
tests/demo/test_cargo_pickup_animation.gd
tests/demo/test_playable_poc_visual_integration.gd
tests/demo/test_product_board_renderer.gd
tests/python/test_night_workshop_runtime_assets.py
tests/python/test_sx_dec_063_core_board_asset_promotion.py
tests/runtime/night_workshop_live_qa.gd
evidence/runtime/topdown-20260911/implementation-report.md
```

## Concerns and evidence ceiling

- At the Task 1 handoff, controller-owned live screenshot/runtime review was
  still pending. It subsequently ran on source cab1b55; see the adjacent
  review.md and receipt.json for real-board-scale evidence and its limits.
  Automated Texture2D loading is not human visual approval.
- This task implements only the approved blue representative pair. Other
  colors, disposal/waste, train/rails, decorations, and shell scenic art remain
  separate top-down-unification work.
- Historical `cargo_lift.png` remains in `night_workshop_v1` as recoverable
  provenance; the regression prevents active renderer reintroduction.
- No new reusable Base rule was identified (`NO_NEW_REUSE_LEARNING`).

## Review fix round 1/5

Reviewer finding: the normal suite entered `PAUSED` and then `BUILD` without
proving a resumed pickup advances, and its cancellation assertion covered only
renderer `BUILD` application rather than the actual `RETRY_SAME_LAYOUT`
command path.

RED-first test additions:

- `test_cargo_pickup_animation.gd` now records offset/opacity, proves both are
  frozen while paused, returns to `RUNNING`, and proves opacity progresses.
- `test_vertical_slice_end_to_end.gd` starts a pending pickup presentation at
  the result boundary, dispatches the actual `RETRY_SAME_LAYOUT` command, and
  requires it to be inactive afterward.

RED command/result:

```text
Godot 4.7.1 --headless --path . --script res://tests/run_tests.gd
FAIL: res://tests/demo/test_vertical_slice_end_to_end.gd
  - actual retry command cancels pending pickup presentation
TEST SUMMARY: cases=121 failed=1 assertions=14505
```

Minimal implementation: added
`ProductBoardRenderer.cancel_cargo_pickup_presentation()` and invoked it from
the existing `ProductFiniteSlice` START/RETRY/EDIT recovery command group,
beside the already-existing semantic/effect cancellation. It cancels only the
pickup presentation and preserves an independently active speed transition.

GREEN command/result:

```text
Godot 4.7.1 --headless --path . --script res://tests/run_tests.gd
TEST SUMMARY: cases=121 failed=0 assertions=14505
```

Review disposition: `IMPORTANT_FIXED`. The actual retry path is now protected;
pause/resume and cancellation are separate deterministic assertions in the
normal suite. Added owned files for this fix:
`game/demo/product_finite_slice.gd` and
`tests/demo/test_vertical_slice_end_to_end.gd`.
