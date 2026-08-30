# SX-DEC-063 Core Board Visual Readability Repair Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:executing-plans` task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Correct the three observed Build-board rendering defects while finishing the previously approved curve refinement: an opaque white placement preview, visibly separated curve/switch ports, and cargo markers that compete with stations for attention.

**Architecture:** `ProductBoardRenderer` remains the sole visual owner. The approved fourteen v02 PNGs and their manifest entries remain byte-for-byte unchanged. The repair changes only how that renderer composes the already-approved textures: compact semantic badge rather than a full-cell overlay, three-pixel seam underlay overlap for curved and switch tiles, and a centered square cargo target smaller than the station target.

**Tech Stack:** Godot 4.7.1-stable, GDScript, CanvasItem drawing, custom Godot test runner, GUT 9.7.1, Hera runtime inspection.

**Spec:** `docs/decisions/SX_DEC_063_HYBRID_MINIATURE_DIORAMA_VISUAL_PRODUCTION_ALIGNMENT.md`

## Global Constraints

- Preserve v02 PNG bytes, manifest SHA-256 values, all fourteen renderer asset paths, v01 rollback sources, and the SX-DEC-063 visual-only boundary.
- Do not change `TrackPiece`, graph/port data, map data, train movement, route selection, station service, cargo loading, LIFO/TOP, input mapping, locale, audio, score, progression, or protected PR #174.
- Use the existing `ProductBoardRenderer` consumer only; no new bitmap, shader, scene, asset-manifest entry, or gameplay decision is authorized.
- Record local machine/runtime verification separately from physical Windows, Android-device, human-comprehension, and release gates.

## Task 1: Lock the observed presentation defects with renderer contracts

- [x] Add RED tests proving that:
  - curve seams use a 90-degree ellipse arc instead of unrelated center spokes;
  - curve and switch seam geometry extends exactly 3px past the internal texture rect on every tile edge;
  - ghost fill/track opacity is limited and semantic feedback occupies only a small in-cell badge;
  - cargo remains centered but uses a square footprint materially smaller than the station footprint.
- [x] Run the custom Godot runner in RED state.
  - Observed failure: 2 cases / 4 targeted assertion failures, each for the missing compact ghost, seam-target, and cargo sizing contracts.
  - The first test attempt used an unsupported assertion helper and was corrected before accepting the RED result; it did not reach production code.

## Task 2: Implement the visual-only composition repair

- [x] Replace the curve's center-spoke underlay with a rectangular-tile-aware 90-degree ellipse arc and increase its drawing fidelity to 24 segments.
- [x] Expand both curve and three-way switch seam underlays 3px beyond their inset source-texture rect, overlapping adjacent track artwork without changing any ports or topology.
- [x] Keep semantic placement state/path resolution intact, but render its existing approved overlay as a compact corner badge; lower ghost fill to 0.08 and rail preview opacity to 0.46.
- [x] Separate marker rectangles: stations retain their existing inset footprint; cargo uses a centered 0.62× minimum-cell-dimension square target.
- [x] Run the custom Godot runner in GREEN state: 112 cases / 0 failed / 13,563 assertions.

## Task 3: Live verification and final regression

- [x] Reload the actual `ProductFiniteSlice` in the isolated worktree and capture a 1280×720 BUILD board with a visible selection preview, a curve, a switch, cargo, stations, grid, and HUD.
- [x] Inspect the capture for selection translucency, seam continuity at curve/switch ports, cargo/station hierarchy, rotation behavior, text legibility, and clipping.
- [x] Run contract validation, full custom suite, Python suite, the repository GUT command, headless parse/import, and post-reload Hera diagnostics.
- [x] Complete five adversarial lenses: topology/input isolation; rotation/seam continuity; visual hierarchy/readability; asset/provenance/no-new-bitmap; and evidence-ceiling accuracy.
- [x] Update the runtime-verification record with exact command results, screenshots, no-asset-byte-change proof, and remaining physical/device/human gates.
- [x] Commit only the bounded renderer/tests/verification-plan/evidence changes and create normal PR #255; do not touch PR #174 or unrelated open PRs.
- [x] Repair the first exact-head CI findings without changing game scope: route the current SX-DEC-063 state through its canonical freshness test, and provide the downloaded CI Godot binary to the platform-neutral image-resize contract.
- [ ] Obtain fresh exact-head hosted CI after the CI-repair commit; only then consider review/merge and post-merge readback.
