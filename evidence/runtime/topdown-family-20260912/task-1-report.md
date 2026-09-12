# Task 1 report: approved top-down world family

Status: `DONE`

Branch: `codex/topdown-family-runtime-20260912`
Baseline: `2de6bd6d70335134e5b97f02ed12e35b35239634`
Implementation commit: `b44536fb71be6a88ed8d2e2ef65d339fe6bbbc4e`

## Problem before this task

Only the already approved blue station and blue cargo lid were registered and consumed from
`topdown_v1`. The other eleven user-approved pixels still had no canonical product path, and the
pickup presentation accepted only `BLUE_DIAMOND` while drawing a hard-coded blue lid. The old
oblique station/cargo/decoration paths were therefore still active for those eleven slots.

## Adopted implementation

- Copied the eleven selected candidate PNGs byte-for-byte into
  `art/product_assets/topdown_v1/`; no pixel generation, edit, atlas, Aseprite, deletion, or
  source-catalog mutation was performed.
- Extended the manifest to all thirteen approved assets with exact source, SHA-256, dimensions,
  RGBA/alpha evidence, approval date, and exact
  `ProductBoardRenderer.PRODUCT_VISUAL_ASSET_PATHS.<key>` consumer key.
- Repointed only the eleven existing renderer slots. Board slate, caution overlay, train, rails,
  start/route-end markers, map data, service rules, and shell/wordmark consumers were preserved.
- Extended the pickup animation using the actual domain identifiers `RED_STAR`, `BLUE_DIAMOND`,
  `YELLOW_TRIANGLE`, and `WASTE_CRATE`; each resolves to its matching approved lid. Unsupported
  types cancel and return false. Existing 0.24 s duration, 16% target-marker-height offset,
  0.62 cargo scale, pause/resume, reduced-motion, cancellation, and rapid replacement behavior
  remain covered.
- Current primary/engine behavior made external benchmarking `NOT_MATERIAL`: this was an exact,
  already approved static-byte wiring task with no new design or engine choice.

## Changed files

- Runtime: `game/demo/presentation/product_board_renderer.gd`,
  `game/demo/presentation/cargo_pickup_animation.gd`.
- Registry: `art/product_assets/topdown_v1/manifest.json`.
- Exact new PNGs and Godot-generated import sidecars: `station_red`, `station_yellow`,
  `station_disposal`, `cargo_red`, `cargo_yellow`, `cargo_waste`,
  `decoration_forest_cluster`, `decoration_moss_boulder`, `decoration_timber_stack`,
  `decoration_waterway`, and `decoration_lantern_fence`.
- Godot tests: `tests/demo/test_cargo_pickup_animation.gd`,
  `tests/demo/test_product_board_renderer.gd`,
  `tests/demo/test_playable_poc_visual_integration.gd`.
- Python tests: `tests/python/test_night_workshop_runtime_assets.py`,
  `tests/python/test_sx_dec_063_core_board_asset_promotion.py`,
  `tests/python/test_sx_dec_065_machine_primary_validation_policy.py`, and
  `tests/python/test_sx_dec_069_transparent_wayside_assets.py`.

## RED evidence

Raw locator: Codex Task 1 transcript, RED tool outputs; exact command and failure excerpts are
reproduced here because the initial runs were not redirected to a repository log.

```powershell
python -m unittest tests.python.test_night_workshop_runtime_assets.NightWorkshopRuntimeAssets.test_approved_topdown_family_retires_oblique_lift_consumer -v
```

Output: `FAILED (failures=1)`. The manifest contained only `station_blue` and `cargo_blue`; the
assertion reported the other eleven required keys missing.

```powershell
& 'C:/Users/user/Downloads/Godot_v4.7.1-stable_win64.exe/Godot_v4.7.1-stable_win64_console.exe' --headless --path . --script res://tests/run_tests.gd
```

Output included the intended contract failures before production changes: no `texture_key`, red
pickup start rejected, renderer path dictionary mismatches, and playable-family path mismatches.

## Focused correction and import diagnostic

After the source changes, the first full Godot pass produced `cases=121 failed=2
assertions=14518` with `No loader found` for the eleven newly copied PNGs. This was not a pixel or
path mismatch: the two pre-existing blue files had Godot import sidecars, while the eleven new
files did not. The supported headless editor import was run once:

```powershell
& 'C:/Users/user/Downloads/Godot_v4.7.1-stable_win64.exe/Godot_v4.7.1-stable_win64_console.exe' --headless --editor --quit --path .
```

Output: `IMPORT_EXIT=0 BEFORE=2 AFTER=13`. The eleven generated `.png.import` sidecars are included
with their PNGs; unrelated sidecars touched by the already-running editor remain unstaged.

The first Python full run then reported `3 failed, 268 passed, 1 skipped`: all three failures were
historical tests that still asserted the superseded active renderer paths. Their preservation
assertions remain, while their active-consumer expectations now point to `topdown_v1`. Focused
correction output: `3 passed in 7.52s`.

## GREEN evidence

Raw locator: Codex Task 1 transcript, final GREEN tool outputs; exact summary lines are reproduced
here because these runs were not redirected to a repository log.

```powershell
& 'C:/Users/user/Downloads/Godot_v4.7.1-stable_win64.exe/Godot_v4.7.1-stable_win64_console.exe' --headless --path . --script res://tests/run_tests.gd
```

Output: `TEST SUMMARY: cases=121 failed=0 assertions=14518`; exit 0.

```powershell
python -m pytest tests/python -q
```

Output: `271 passed, 1 skipped in 11.96s`; exit 0.

```powershell
python tools/validate_project_contract.py
```

Output: `project operating contract: PASS`; exit 0.

Final static readback output:

```text
TOPDOWN_FAMILY_REVIEW_1_CONSUMERS: PASS (13/13 exact bytes, hashes, imports, consumer keys)
TOPDOWN_FAMILY_REVIEW_2_PROTECTED_CONSUMERS: PASS (board/caution/train/rails/markers preserved; oblique lift absent)
TOPDOWN_FAMILY_REVIEW_3_ANIMATION: PASS (4 authoritative IDs; duration/offset unchanged; unsupported default empty)
TOPDOWN_FAMILY_REVIEW_4_SCOPE: PASS (no core/maps/shell/protected-family edits)
TOPDOWN_FAMILY_REVIEW_5_STATIC_ASSETS: PASS (no aseprite/atlas; source bytes preserved)
```

## Five-pass adversarial review

1. Consumer/scope: all thirteen manifest entries resolve to exact renderer slots; only eleven
   previously unwired slots changed. No core, map, service, shell, slate, train, rail, marker, or
   wordmark file changed.
2. Provenance/import: every registered target hash equals its selected source hash, all are RGBA
   with declared dimensions/alpha extrema, and all thirteen have Godot import sidecars.
3. Lifecycle: all four authoritative cargo IDs use the matching lid; invalid replacement clears
   the previous pickup; rapid replacement, pause/resume, reduced motion, cancel, duration, offset,
   and 0.62 scale remain asserted.
4. Legacy/fabrication: the old oblique assets remain preserved as historical files but no active
   pickup renderer consumer names `CARGO_LIFT_TEXTURE` or `cargo_lift.png`; no atlas or `.aseprite`
   artifact was introduced.
5. Evidence/safety: full Godot and Python suites are green. Controller-owned Blueprint/catalog,
   shell composition, maps, and `tests/runtime/topdown_family_live_qa.gd` were not staged or edited.

## Baseline diagnostic noise versus new defects

- Known baseline noise: Python remains at one intentional skip. The existing product validators
  may print two deferred historical-candidate PNG CRC diagnostics; those candidates are outside
  the runtime family and were not changed or promoted by Task 1. This is historical diagnostic
  noise, not a new Task 1 defect.
- New defect found and corrected: eleven copied PNGs initially lacked Godot import metadata, so
  runtime `Texture2D` loading failed. The headless editor generated the required sidecars and the
  full suite then passed.
- Line-ending warnings from `git diff` refer both to pre-existing dirty import sidecars and the
  checkout's CRLF conversion policy; scoped `git diff --check` found no whitespace error.

## Evidence ceiling and remaining concerns

Task 1 reaches source/static-byte registration, automated `Texture2D` loading, and headless
machine verification. It does not claim live-editor capture, physical Windows/Android, perceptual
audio, human/player UX, release, or production-cutover PASS. Task 3/controller owns live QA. The
worktree contains substantial pre-existing unrelated dirty and untracked files; the commit is
therefore made with explicit Task 1 paths only and those other files are preserved.
