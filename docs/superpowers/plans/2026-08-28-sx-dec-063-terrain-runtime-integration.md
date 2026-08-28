# SX-DEC-063 Terrain v02 Runtime Integration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:executing-plans` task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace only the `ProductBoardRenderer.board_terrain` runtime path with the user-approved terrain v02 while preserving the rectangular input grid, all finite gameplay rules, the v01 rollback source, and evidence boundaries.

**Architecture:** The existing renderer continues to load exactly one `Texture2D` and draw it below all live semantic layers. The implementation changes only the `board_terrain` value from the v01 path to the pre-preserved v02 path, then changes v02 manifest/provenance state from `NOT_CONNECTED` to `VERIFIED` only after automated runtime loading and same-state viewport evidence exist.

**Tech Stack:** Godot 4.7.1-stable, GDScript, the repository custom runner `tests/run_tests.gd`, Python `unittest`, existing asset manifests.

**Spec:** `docs/superpowers/specs/2026-08-28-sx-dec-063-hybrid-miniature-diorama-production-design.md`

## Global Constraints

- Implement GitHub Issue #243 and SX-DEC-063 only. Read `AGENTS.md`, `CURRENT_CONFIRMED_DECISIONS.md`, `ACTIVE_CONTEXT.md`, SX-DEC-060, SX-DEC-063, the feasibility review, this plan, and `SX_DEC_063_TERRAIN_RUNTIME_INTEGRATION_HANDOFF.md` first.
- Keep GMB-002, cardinal station service, exact-cell cargo pickup, LIFO/TOP, Manual/Auto, direct switch lock, T1→T6→capstone, all map/data/locale/audio behavior, T2 v02, Issue #227, PR #174, and Base pin unchanged.
- Keep `art/product_assets/ed_hybrid_v1/board/board_terrain_playfield_v01.png` in Git. Do not generate or substitute any other asset in this window.
- Current expected import is an opaque `Texture2D` source at 1672×941. Do not introduce alpha, shader, crop, camera, or hit-test conversion.
- Use RED → minimal GREEN → exact-head regression. Do not claim package/physical/audio/Android/human/Player Experience/release PASS without fresh evidence.

---

### Task 1: Lock the v02 consumer path with tests

**Files:**

- Modify: `tests/demo/test_product_board_renderer.gd`
- Modify: `tests/python/test_sx_dec_063_terrain_asset_promotion.py`

**Interfaces:**

- `ProductBoardRenderer.product_visual_asset_paths_for_test()["board_terrain"]` must equal `art/product_assets/ed_hybrid_v2/board/board_terrain_playfield_v02.png` after integration.
- `ProductBoardRenderer.loaded_product_visuals_for_test()["board_terrain"]` must be `true`.
- v02 manifest `runtime_connection_status` becomes `VERIFIED`; v01 is still present as rollback.

- [ ] **Step 1: Write failing consumer assertions**

Append to `tests/demo/test_product_board_renderer.gd` before `renderer.free()`:

```gdscript
assert_equal(
    renderer.product_visual_asset_paths_for_test()["board_terrain"],
    "art/product_assets/ed_hybrid_v2/board/board_terrain_playfield_v02.png",
    "approved terrain v02 must be the only board backdrop path"
)
assert_true(
    renderer.loaded_product_visuals_for_test()["board_terrain"],
    "approved terrain v02 must import as a Texture2D"
)
```

In `tests/python/test_sx_dec_063_terrain_asset_promotion.py`, update the expected manifest state to `APPROVED_GITHUB_PRESERVED_RUNTIME_VERIFIED`, expected `runtime_connection_status` to `VERIFIED`, and renderer expectation to the v02 path.

- [ ] **Step 2: Run and observe RED**

```powershell
& $godot --headless --path . --script res://tests/run_tests.gd
& $py tests/python/test_sx_dec_063_terrain_asset_promotion.py -v
```

Expected: the current v01 path and `NOT_CONNECTED` manifest make only the new v02 assertions fail.

- [ ] **Step 3: Minimal production change**

Replace only this `ProductBoardRenderer` map value:

```gdscript
"board_terrain": "art/product_assets/ed_hybrid_v2/board/board_terrain_playfield_v02.png",
```

Do not change `_draw_board_terrain`, draw order, tint/veil, viewport math, input mapping, or another asset key.

- [ ] **Step 4: Confirm GREEN**

Run the commands above and confirm the complete runner has no added failure. Inspect the imported v02 `.import` metadata only as generated evidence; do not manually edit it.

---

### Task 2: Promote the manifest only after runtime loading is green

**Files:**

- Modify: `art/product_assets/ed_hybrid_v2/manifest.json`
- Modify: `docs/ASSET_RIGHTS_AND_PROVENANCE_RECORD.md`
- Modify: current SX-DEC-063 canon/evidence owners after results exist

**Interfaces:**

- `manifest.status = APPROVED_GITHUB_PRESERVED_RUNTIME_VERIFIED`
- `assets[0].runtime_connection_status = VERIFIED`
- Provenance says `ProductBoardRenderer` v02 path is automated-runtime verified, while physical/human/release gates are still `NOT_RUN`.

- [ ] **Step 1: Make manifest expectations fail first**

Use the updated Python test from Task 1; it must fail before the manifest changes because its runtime state is still `NOT_CONNECTED`.

- [ ] **Step 2: Change only connection state and evidence text**

Set exactly the two manifest strings above and update rights/canon with the exact test/runtime command output. Do not rewrite the source receipt, SHA, asset dimensions, approval, or conditional rights status.

- [ ] **Step 3: Verify metadata and rollback**

Run the Python test, confirm v01 remains tracked, and verify the renderer has no other path change.

---

### Task 3: Same-state visual, package, and adversarial close

**Files:**

- Modify only exact evidence/canon owners created by the previous successful steps.

**Interfaces:**

- Comparison state: 1280×720 BUILD board with the same map/snapshot before and after the path change.
- Required visual elements: grid, blocked cell, rail ports, cargo silhouette, off-track station/cardinal cue, selected/alternate/locked route, train, and HUD stay readable.

- [ ] **Step 1: Capture the actual same-state runtime comparison**

Run the project through its supported Godot runtime path, capture the exact 1280×720 BUILD state before/after (or current v02 exact state with an archived v01 control), and inspect crop, clipping, central contrast, state visibility, and style drift. Do not use a planning image as runtime evidence.

- [ ] **Step 2: Run exact-head regression and package path**

Run the current project contract, SX-DEC-063 promotion test, full Godot runner, all required CI checks, and the official package workflow. If product bytes package successfully, create a new exact candidate; otherwise state `NOT_RUN` without moving the current candidate pointer.

- [ ] **Step 3: Run five full adversarial loops**

Attack: (1) gameplay/input semantics, (2) import/resource/path/rollback, (3) gameplay-scale readability and style drift, (4) provenance/rights/reference similarity, (5) package/physical/human evidence inflation. Fix each valid in-scope finding and repeat the affected regression. Close only with zero unresolved current-scope blockers.

- [ ] **Step 4: Commit and hand off**

```powershell
git add game/demo/presentation/product_board_renderer.gd tests/demo/test_product_board_renderer.gd tests/python/test_sx_dec_063_terrain_asset_promotion.py art/product_assets/ed_hybrid_v2/manifest.json docs/ASSET_RIGHTS_AND_PROVENANCE_RECORD.md
git commit -m "art: connect approved terrain v02"
```

Record exact head, test counts, comparison evidence, candidate/package outcome, remaining human gates, and rollback (`restore the single v01 path; retain v02 source/provenance`).
