# Transparent Wayside Assets and Speed Transitions Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the terrain-backed Route Book 02 wayside candidates with transparent-object v02 candidates, and make caution-entry deceleration and caution-exit normal-speed recovery visually distinct without changing game rules.

**Architecture:** `ProductBoardRenderer` remains the sole owner of the short-lived visual transition. It compares consecutive immutable render snapshots, derives an entry or exit descriptor, then uses a bounded CanvasItem redraw window to draw line-based cues above route state and below the train. The existing maps and `FiniteRunController` continue to own caution cells and the 0.55 speed multiplier; no gameplay state is written by the renderer.

**Tech Stack:** Godot 4.7.1, GDScript, project SceneTree test runner, Pillow-backed Python PNG validator, built-in image generation, project-local PNG assets.

**Spec:** `docs/decisions/SX_DEC_067_WAYSIDE_HAZARDS_SALVAGE_AND_ROUTE_BOOK_02.md` plus the user-approved 2026-09-01 transparent-background and distinct-speed-transition direction.

## Global Constraints

- Preserve the user-approved title shell and `SX-TITLE-WORDMARK-001` unchanged.
- Keep `FiniteRunController` caution behavior exactly at `base_speed * 0.55`; no boost, fuel, score, map-rule, or route-rule change.
- Replace only the eight existing runtime-connected generated candidates with v02 siblings; v01 candidates remain tracked as historical rollback/provenance records until a later explicit disposition.
- Each v02 bitmap must have genuine RGBA transparency and contain only its named object or rail-side signal: no grass, dirt, rocks, terrain tile, opaque rectangle, background, label, or extra prop.
- New bitmaps stay `GENERATED_CANDIDATE_RUNTIME_CONNECTED_NOT_CANON` pending pixel review; generation/import/test PASS is not user visual approval.
- Reduced Motion keeps the same deceleration/normal-speed-recovery meaning using static color and shape, without motion-driven state changes.
- Candidate 009 remains current only for its already-merged `main` bytes while this branch is pending; it becomes historical once the changed player-facing bytes merge. Create a new exact machine-verification candidate only after all checks and GitHub post-merge readback.

---

### Task 1: Lock the new renderer contract with RED tests

**Files:**
- Modify: `tests/demo/test_product_board_renderer.gd:127-286`
- Create: `tests/python/test_sx_dec_069_transparent_wayside_assets.py`

**Interfaces:**
- Consumes: `ProductBoardRenderer.PRODUCT_VISUAL_ASSET_PATHS` and the existing render snapshot keys `train_cell`, `train_previous_cell`, and `caution_track_cells`.
- Produces: exact v02 asset-path requirements and `ProductBoardRenderer.speed_transition_descriptor_for_test(previous_snapshot, next_snapshot)` diagnostics.

- [x] **Step 1: Write the failing Godot renderer test**

Add an expectation that the eight affected slots use these exact paths:

```gdscript
"decoration_forest_cluster": "art/product_assets/ed_hybrid_v2/board/board_decor_forest_cluster_v02.png",
"decoration_moss_boulder": "art/product_assets/ed_hybrid_v2/board/board_decor_moss_boulder_v02.png",
"decoration_timber_stack": "art/product_assets/ed_hybrid_v2/board/board_decor_timber_stack_v02.png",
"decoration_waterway": "art/product_assets/ed_hybrid_v2/board/board_decor_waterway_v02.png",
"decoration_lantern_fence": "art/product_assets/ed_hybrid_v2/board/board_decor_lantern_fence_v02.png",
"caution_track": "art/product_assets/ed_hybrid_v2/board/board_caution_track_overlay_v02.png",
"station_disposal": "art/product_assets/ed_hybrid_v2/core/core_disposal_yard_normal_v02.png",
"cargo_waste": "art/product_assets/ed_hybrid_v2/core/core_cargo_waste_crate_normal_v02.png",
```

Add focused descriptor assertions:

```gdscript
var deceleration := RendererScript.speed_transition_descriptor_for_test(
	{"train_cell": Vector2i(2, 3), "caution_track_cells": [Vector2i(3, 3)]},
	{"train_cell": Vector2i(3, 3), "caution_track_cells": [Vector2i(3, 3)]}
)
assert_equal(deceleration["kind"], &"DECELERATE", "normal-to-caution entry must show braking")
assert_equal(deceleration["cell"], Vector2i(3, 3), "braking cue belongs at the entered caution cell")

var acceleration := RendererScript.speed_transition_descriptor_for_test(
	{"train_cell": Vector2i(3, 3), "caution_track_cells": [Vector2i(3, 3)]},
	{"train_cell": Vector2i(4, 3), "caution_track_cells": [Vector2i(3, 3)]}
)
assert_equal(acceleration["kind"], &"ACCELERATE", "caution exit must show normal-speed recovery")
assert_equal(acceleration["direction"], Vector2i.RIGHT, "recovery cue must follow train travel direction")
assert_equal(
	RendererScript.speed_transition_descriptor_for_test(
		{"train_cell": Vector2i(3, 3), "caution_track_cells": [Vector2i(3, 3), Vector2i(4, 3)]},
		{"train_cell": Vector2i(4, 3), "caution_track_cells": [Vector2i(3, 3), Vector2i(4, 3)]}
	),
	{},
	"consecutive caution cells must not replay a speed transition"
)
```

- [x] **Step 2: Write the failing PNG/provenance validator**

Create a Pillow-backed Python unittest that asserts all eight v02 files exist, are RGBA, have fully transparent corner pixels, do not cover the full raster with opaque pixels, have manifest entries under `generated_candidates`, and are the exact renderer consumers.

- [x] **Step 3: Run the tests to verify RED**

Run:

```powershell
& 'C:\Users\user\Downloads\Godot_v4.7.1-stable_win64.exe\Godot_v4.7.1-stable_win64_console.exe' --headless --path . --script res://tests/run_tests.gd
python tests/python/test_sx_dec_069_transparent_wayside_assets.py
```

Expected: the renderer test fails because `speed_transition_descriptor_for_test` and v02 paths do not yet exist; the Python test fails because no v02 candidate files or manifest records exist.

### Task 2: Implement bounded visual-only speed transitions

**Files:**
- Modify: `game/demo/presentation/product_board_renderer.gd:19-264`
- Modify: `tests/demo/test_product_board_renderer.gd:127-286`

**Interfaces:**
- Consumes: consecutive render snapshots only.
- Produces: `func speed_transition_descriptor_for_test(previous_snapshot: Dictionary, next_snapshot: Dictionary) -> Dictionary`, `func set_reduced_motion(enabled: bool) -> void`, and a `SPEED_TRANSITION` draw layer.

- [x] **Step 1: Implement snapshot-derived descriptor logic**

Add a static helper that compares the prior and next `train_cell`, normalizes caution-cell arrays using `snapshot_cell`, and returns exactly one of:

```gdscript
{}
{"kind": &"DECELERATE", "cell": entered_cell, "direction": travel_direction}
{"kind": &"ACCELERATE", "cell": exited_to_cell, "direction": travel_direction}
```

It must return `{}` for invalid or unchanged train cells, normal-to-normal movement, caution-to-caution movement, and maps that have no caution cells.

- [x] **Step 2: Implement renderer-owned bounded playback**

In `apply_snapshot`, derive the descriptor before replacing `_snapshot`. For a non-empty descriptor, start one renderer-local transition with a fixed, private duration no greater than 0.30 seconds, enable `_process`, and call `queue_redraw()`. In `_process(delta)`, decrease remaining time, redraw only while active, and clear the descriptor plus disable processing at completion. Do not emit signals or call controller/domain code.

- [x] **Step 3: Draw two non-overlapping visual languages**

Insert `SPEED_TRANSITION` after `STATE` and before `TRAIN` in `visual_layer_order_for_test()` and `_draw()`.

```gdscript
# DECELERATE: amber perpendicular brake bars drawn toward the train center.
# ACCELERATE: cyan longitudinal travel streaks that open ahead of the train.
```

Use only `draw_line`, `draw_circle`, and existing local cell geometry. Draw a static full-strength version when Reduced Motion is enabled. The two cues must use both distinct hue and distinct orientation; they must never obscure the train texture or change its transform.

- [x] **Step 4: Run the focused GREEN test**

Run:

```powershell
& 'C:\Users\user\Downloads\Godot_v4.7.1-stable_win64.exe\Godot_v4.7.1-stable_win64_console.exe' --headless --path . --script res://tests/run_tests.gd
```

Expected: all SceneTree tests pass; the existing finite-controller tests demonstrate that the 0.55 caution speed domain contract is unchanged.

### Task 3: Generate and connect transparent v02 candidates

**Files:**
- Create: `art/product_assets/ed_hybrid_v2/board/board_decor_forest_cluster_v02.png`
- Create: `art/product_assets/ed_hybrid_v2/board/board_decor_moss_boulder_v02.png`
- Create: `art/product_assets/ed_hybrid_v2/board/board_decor_timber_stack_v02.png`
- Create: `art/product_assets/ed_hybrid_v2/board/board_decor_waterway_v02.png`
- Create: `art/product_assets/ed_hybrid_v2/board/board_decor_lantern_fence_v02.png`
- Create: `art/product_assets/ed_hybrid_v2/board/board_caution_track_overlay_v02.png`
- Create: `art/product_assets/ed_hybrid_v2/core/core_disposal_yard_normal_v02.png`
- Create: `art/product_assets/ed_hybrid_v2/core/core_cargo_waste_crate_normal_v02.png`
- Modify: `game/demo/presentation/product_board_renderer.gd:19-42`
- Modify: `art/product_assets/ed_hybrid_v2/manifest.json`
- Modify: `docs/ASSET_RIGHTS_AND_PROVENANCE_RECORD.md`

**Interfaces:**
- Consumes: the eight existing runtime slots and the project E+D Hybrid / Neo-Arcade visual language.
- Produces: v02 `GENERATED_CANDIDATE_RUNTIME_CONNECTED_NOT_CANON` image records with reproducible SHA-256, prompt receipt, actual path, and exact consumer.

- [x] **Step 1: Generate only the named cutout objects**

Generate each v02 image with a genuine transparent alpha background. Preserve its named object silhouette and miniature diorama material language, but prohibit ground, grass, dirt, rocks, terrain, tiles, scenery background, labels, or additional props. The caution image is a narrow rail-side warning signal only, not a filled board cell.

- [x] **Step 2: Inspect alpha and visual composition before runtime connection**

Verify each candidate has transparent corners and no full-frame background; visually inspect every source image on a neutral checkerboard before copying it to the project-local v02 paths.

- [x] **Step 3: Update exact consumers and provenance**

Switch only the eight named `PRODUCT_VISUAL_ASSET_PATHS` values to v02. Add each new SHA-256, generation receipt, dimensions, candidate status, pixel review status `USER_REVIEW_PENDING`, and `SUPERSEDED_BY_V02_CANDIDATE` status for each retained v01 entry. Do not alter title, terrain, rail, station-color, or normal cargo entries.

- [x] **Step 4: Import and run the asset validators**

Run:

```powershell
& 'C:\Users\user\Downloads\Godot_v4.7.1-stable_win64.exe\Godot_v4.7.1-stable_win64_console.exe' --headless --import --path .
python tests/python/test_sx_dec_069_transparent_wayside_assets.py
& 'C:\Users\user\Downloads\Godot_v4.7.1-stable_win64.exe\Godot_v4.7.1-stable_win64_console.exe' --headless --path . --script res://tests/run_tests.gd
```

Expected: every v02 PNG imports as `Texture2D`, the new Python asset contract passes, and all SceneTree tests pass.

### Task 4: Record the approved scope and verification boundary

**Files:**
- Modify: `docs/decisions/SX_DEC_067_WAYSIDE_HAZARDS_SALVAGE_AND_ROUTE_BOOK_02.md`
- Modify: `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
- Modify: `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
- Modify: `기획서/50_제작_검증/SX_DEC_060_CODEX_HANDOFF_PACKAGE.md`

**Interfaces:**
- Consumes: the user approval, produced asset hashes, test counts, runtime capture paths, and final source commit.
- Produces: a current decision record that distinguishes user direction, generated candidates, automated verification, runtime observation, and later optional pixel review.

- [x] **Step 1: Record the visual-only boundary**

Document that the title screen remains canonical, v02 assets remove embedded terrain, caution entry uses deceleration feedback, caution exit uses normal-speed-recovery feedback, and the map/domain multiplier remains 0.55.

- [x] **Step 2: Record evidence ceilings**

Record that Candidate 009 remains current only for merged `main` while this branch is pending and becomes `HISTORICAL_AFTER_PLAYER_FACING_CHANGE` on merge. Do not claim final user, device, accessibility, audio perceptual, or release PASS. Set the next exact package candidate to `PREPARED` only after merge and package checks begin.

### Task 5: Runtime readback, adversarial review, and GitHub sync

**Files:**
- Modify only if review produces an in-scope correction: files from Tasks 2–4.

**Interfaces:**
- Consumes: imported project, selected Route Book 02 map that contains decoration/caution cells, and the existing live Godot authoring connection.
- Produces: stored before/after captures, five review findings with resolution status, a clean commit, pushed branch, PR, and post-merge readback.

- [ ] **Step 1: Run Godot live/editor verification**

Use the project-local Hera connection only. Capture the Route Book 02 board at normal motion and Reduced Motion, then inspect that no terrain patch appears below v02 objects and the two speed cues are distinct, bounded, readable, and below the train.

**Current readback:** the local connection reached RB08 build and confirmed transparent object placement with clean diagnostics. The 0.28-second motion cue was not frame-captured, so this step remains open for final user-facing live visual review; automated descriptor, playback, reduced-motion, and draw-order coverage is green.

- [x] **Step 2: Perform five focused adversarial checks**

Check consumer/path mismatch, transparent-background/halo failure, route and marker readability, transition repeat/interruption/reduced-motion behavior, and evidence/provenance inflation. Correct every verified in-scope issue and rerun the relevant tests.

- [ ] **Step 3: Commit, push, open/update PR, and read back remote state**

Use one focused commit on `codex/transparent-wayside-speed-transitions`, push it, open a separate PR without touching #174 or #254, wait for required CI, merge only when all project gates permit it, then fetch `origin/main` and compare exact source bytes. Record only verified results.

## Plan Self-Review

- Spec coverage: Tasks 1–3 cover transparent candidates and distinct visual transitions; Task 4 preserves evidence boundaries; Task 5 covers runtime, five-pass review, and GitHub synchronization.
- Placeholder scan: no `TBD`, deferred code, or unspecified test behavior remains.
- Type consistency: all renderer tests consume the declared `speed_transition_descriptor_for_test(previous_snapshot, next_snapshot)` dictionary interface; asset tests consume the same eight slot names used by `PRODUCT_VISUAL_ASSET_PATHS`.
