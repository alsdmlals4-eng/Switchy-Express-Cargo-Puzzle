# Task 2 implementation report

Status: DONE_WITH_CONCERNS (machine verification complete; live pixel review belongs to Task 3)

Commits:

- `fef77fb` (`feat: compose topdown product shell art`)
- `0bb8ce4` (`fix: keep shell objects readable`)

## Authority and scope readback

- Work mode: approved-contract continuation on `codex/topdown-family-runtime-20260912`.
- Project route: `switchy-express-design`, visual-readability / first-session validation mode.
- Read and followed the current `AGENTS.md`, project operating-contract validator, project adapter/snapshot, `CURRENT_CONFIRMED_DECISIONS.md`, `ACTIVE_CONTEXT.md`, the Task 2 brief, plan Global Constraints, current top-down evidence README and the core-preserved design owner.
- `python tools/validate_project_contract.py`: `project operating contract: PASS`.
- Baseline before Task 2: `b44536fb71be6a88ed8d2e2ef65d339fe6bbbc4e` (Task 1 committed and review-approved).
- Preserved the approximately 216 pre-existing dirty/import/QA files. In particular, controller-owned `art/product_assets/ed_hybrid_v2/manifest.json` and `tests/python/test_sx_dec_069_transparent_wayside_assets.py` remained unstaged and were not committed.

## What was implemented

- Replaced all five legacy `ed_hybrid_v1/shells/shell_*` hero selections in `ProductShellArt` with texture composition using only the registered selected slate, v04 straight rail, overhead train and approved `topdown_v1` object/decor family.
- Preserved the existing `Control`, exported `mode`, `set_lesson_id`, `set_result_outcome`, `asset_paths_for_test` and `loaded_asset_count_for_test` API. The scene and flow controller were not changed.
- Added one shared 10x4 square virtual grid for every shell mode. Each connected rail run occupies adjacent equal square cells whose edges meet exactly after any resize.
- Kept cargo target rectangles at `0.62` of one virtual cell. No transparent-padding enlargement or source-pixel edit was performed.
- TITLE uses a lower rail/yard corridor and right-edge accents while leaving the top row free as readable negative space behind the existing title UI/wordmark.
- LESSON uses overhead cargo on rail and an off-track station. T2 identifies one service rail cell and places the station center exactly one cardinal unit above it; cargo remains on the rail row and never occupies the station cell.
- RESULT success and failure use different approved color/shape families (`station_blue`/`cargo_blue` versus `station_disposal`/`cargo_waste`) with the existing train/rail/slate, without asserting an actual attempt cause or writing gameplay state.
- Distributed the five decor families modestly across title, lesson and result variants rather than crowding the title.
- Set `mouse_filter = MOUSE_FILTER_IGNORE`, `clip_contents = true`, nearest texture filtering and resize redraw. All computed target/draw rectangles stay within the Control.
- Aspect-preserving foreground placement uses contained draw rectangles. Slate background uses an aspect-preserving cover source crop. `_draw` performs texture draws only; there is no `FileAccess`, `DirAccess`, save or render-time file write.
- Added a dedicated 522-assertion shell contract plus updated prior first-session/POC tests from brittle old HeroArt-path expectations to observable top-down composition behavior.

## RED evidence

Command:

```powershell
& 'C:/Users/user/Downloads/Godot_v4.7.1-stable_win64.exe/Godot_v4.7.1-stable_win64_console.exe' --headless --path . --script res://tests/run_tests.gd
```

Raw log: `.superpowers/sdd/2026-09-12-approved-topdown-family-runtime/task-2-red.log`

Observed before implementation:

```text
FAIL: res://tests/demo/test_product_shell_art.gd
  - TITLE clips composition to its Control
  - TITLE exposes computed placement diagnostics
  - TITLE has no legacy shell hero consumer
  - T2 uses an approved top-down station
  - T2 uses matching approved top-down cargo
  - RESULT success/failure ...
FAIL: res://tests/demo/test_first_session_flow_controller.gd
FAIL: res://tests/demo/test_first_session_end_to_end.gd
FAIL: res://tests/demo/test_playable_poc_visual_integration.gd
TEST SUMMARY: cases=122 failed=4 assertions=14568
```

The failures were expected because the pre-change renderer still selected one oblique HeroArt texture per title/lesson/result state, did not expose placement diagnostics, and did not clip composed content.

## GREEN evidence

After the first implementation run, only the new T2 test's semantic-role fallback was wrong; production geometry already had the intended roles. The test was corrected to fall back from an empty `semantic_role` to `role`, then the unchanged production geometry was rerun.

Command:

```powershell
& 'C:/Users/user/Downloads/Godot_v4.7.1-stable_win64.exe/Godot_v4.7.1-stable_win64_console.exe' --headless --path . --script res://tests/run_tests.gd
```

Raw logs:

- `.superpowers/sdd/2026-09-12-approved-topdown-family-runtime/task-2-green-focused.log`
- `.superpowers/sdd/2026-09-12-approved-topdown-family-runtime/task-2-green-iteration.log`

Final unchanged-code result used for commit evidence:

```text
PASS: res://tests/demo/test_product_shell_art.gd (522 assertions)
TEST SUMMARY: cases=122 failed=0 assertions=15055
```

Python full regression command:

```powershell
python -m pytest tests/python -q
```

Raw log: `.superpowers/sdd/2026-09-12-approved-topdown-family-runtime/task-2-python-full.log`

Result:

```text
271 passed, 1 skipped in 9.70s
```

The Python run intentionally included the controller's current unstaged manifest/test corrections while excluding them from this commit.

## Files committed

- `game/demo/presentation/product_shell_art.gd`
- `tests/demo/test_product_shell_art.gd`
- `tests/demo/test_first_session_flow_controller.gd`
- `tests/demo/test_first_session_end_to_end.gd`
- `tests/demo/test_playable_poc_visual_integration.gd`
- `tests/run_tests.gd`

No bitmap, scene, map, finite-core, Task 1 source, asset catalog or controller-owned file was committed.

## Self-review and adversarial passes

1. Scope / gameplay-authority attack: searched the renderer for file/save/domain calls; it only computes rectangles and draws textures. No finite rule, map coordinate, flow, result, retry/edit or wordmark owner changed.
2. Consumer / provenance attack: active shell paths were enumerated and tests assert every unique path loads as `Texture2D`; repository search found no remaining GDScript/TSCN consumer expectation for the five legacy hero paths. Only already registered asset paths are used.
3. Geometry / meaning attack: every rail target is the same square grid unit and adjacent rail edges are asserted at both 1280x720 and smaller controls. T2 asserts Manhattan center distance exactly one unit, axis alignment, cargo-on-rail and station-not-on-track.
4. Responsive / interaction attack: normalized target rectangles, contained pixel rectangles, layer-family stability and recomputed grid scale are asserted at 1280x720 and 320x140. Input ignore and clipping are asserted for title, lesson, success and failure.
5. Evidence / workspace attack: cached diff check was clean; explicit-path commit contains exactly six Task 2 files. Controller edits and all pre-existing dirty/import/QA files remain unstaged. Automated evidence is reported separately from live/human appearance.

## Concerns and evidence ceiling

- Automated geometry/import/flow evidence is complete for Task 2, but actual live pixels at 1280x720 and the small supported layout were not visually inspected in this worker. The controller owns Task 3 exact-session capture and title/T2/success/failure pixel review.
- Success/failure are deliberately illustrative families, not evidence of the player's actual failed cargo or failure cause. Existing UI copy remains the only attempt-specific authority.
- Godot output includes the existing plugin registration line (`[godot_ai game_helper] registered mcp capture ...`); there were no test failures or new script warnings.
- Final user appearance approval, screenshot/PDF refresh, package/physical/device/release evidence and merge status remain separate and unclaimed.

## Fix round 1 — actual consumer readability

Review outcome: `Needs fixes · Important`. Exact live captures from source `fef77fb` at
`evidence/runtime/topdown-family-20260912/{title,lesson-t2,result,failure}.png` confirmed the
review finding.

### Root cause

The initial square-grid rule was correct, but one universal `10x4` grid was applied to both the
full-screen title and the shallow shell controls. At the actual `LessonArt 632x150` and
`ResultArt 512x145` sizes, four virtual rows limited the cell unit to about `33.5` and `32.25`
logical pixels. The required `0.62` cargo target therefore became about `20–21` logical pixels,
with only about `8–10` visibly opaque pixels in the approved texture. The title cargo occupied
grid cell `(2,2)`, leaving part of its target behind the left title panel.

### RED regression

Added hand-derived readability thresholds and actual consumer sizes before changing production:

- major cargo target: at least `38` logical pixels;
- station target: at least `54` logical pixels;
- title cargo target begins to the right of the known left-quarter panel envelope;
- every title/lesson/T2/success/failure state is checked at its normal size and `320x140`;
- responsive behavior now changes the actual `Control.size`, observes its `resized` signal and
  recomputes layout from the Control's readback size.

Command:

```powershell
& 'C:/Users/user/Downloads/Godot_v4.7.1-stable_win64.exe/Godot_v4.7.1-stable_win64_console.exe' --headless --path . --script res://tests/run_tests.gd
```

Raw log: `.superpowers/sdd/2026-09-12-approved-topdown-family-runtime/task-2-fix1-red.log`

Observed against `fef77fb`:

```text
FAIL: res://tests/demo/test_product_shell_art.gd
  - title cargo stays outside the known left-panel envelope
  - lesson actual consumer keeps major cargo at least 38 logical pixels
  - lesson actual consumer keeps station target at least 54 logical pixels
  - T2 actual consumer keeps major cargo at least 38 logical pixels
  - T2 actual consumer keeps station target at least 54 logical pixels
  - result success actual consumer keeps major cargo at least 38 logical pixels
  - result success actual consumer keeps station target at least 54 logical pixels
  - result failure actual consumer keeps major cargo at least 38 logical pixels
  - result failure actual consumer keeps station target at least 54 logical pixels
TEST SUMMARY: cases=122 failed=1 assertions=15281
```

### Fix

- Kept TITLE on its `10x4` composition and moved cargo from cell `(2,2)` to `(4,2)`, the uncovered
  central corridor between the title decks.
- Changed LESSON, T2, RESULT success and RESULT failure to a compact `6x2` square grid.
- Rebased connected rail cells to row `1`, stations to row `0`, and kept T2's station exactly one
  cell above its identified service rail.
- Preserved the same asset paths, cargo scale `0.62`, station scale, aspect fit, layer ordering,
  input-ignore/clipping behavior and presentation-only authority.

At the actual consumers, the compact layout derives `67px` lesson cells and `64.5px` result cells.
That yields cargo targets of `41.54px` / `39.99px` and station targets of `58.96px` / `56.76px`,
above the independent thresholds without changing the approved texture bytes.

### GREEN and regression

Godot command: same custom runner as RED.

Raw log: `.superpowers/sdd/2026-09-12-approved-topdown-family-runtime/task-2-fix1-green-godot.log`

```text
PASS: res://tests/demo/test_product_shell_art.gd (748 assertions)
TEST SUMMARY: cases=122 failed=0 assertions=15281
```

Python command:

```powershell
python -m pytest tests/python -q
```

Raw log: `.superpowers/sdd/2026-09-12-approved-topdown-family-runtime/task-2-fix1-python-full.log`

```text
271 passed, 1 skipped in 10.98s
```

The Python run again included but did not stage the controller-owned manifest/test correction.

### Fix-round self-review

- Diff is limited to `product_shell_art.gd` scene coordinates/grid dimensions and the dedicated
  shell test; no caller, UI, wordmark, bitmap, domain or catalog changed.
- All rail runs remain contiguous equal-size squares at normal and small sizes.
- T2 retained exact cardinal adjacency and station-off-track semantics.
- All five scene states retain bounded/aspect-preserving loaded Texture2D layers and real resize
  notification coverage.
- `git diff --check` is clean. Final live pixel recapture remains the controller's next evidence.
