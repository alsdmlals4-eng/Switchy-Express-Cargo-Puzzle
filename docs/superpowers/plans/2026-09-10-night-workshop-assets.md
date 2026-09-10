# Night Workshop Asset Preparation Plan

> For agentic workers: execute sequentially in the current isolated worktree. Follow `superpowers:executing-plans` for implementation; no additional agent required.

**Goal:** produce reviewable connected-rail and cargo-action candidates from the approved visual direction, with editable Aseprite frames and reproducible metadata.
**Architecture:** image-model pixels stay in the candidate/evidence area. Restricted Aseprite operations create bounded transparent frames and PNG/JSON exports. Existing renderer/catalog paths change only after final candidate approval and exact-main implementation readback.
**Tech Stack:** built-in image generation; local Aseprite 1.3.18.5-dev candidate MCP; existing Godot 4.7.1 renderer; PNG/JSON.
**Spec:** `docs/superpowers/specs/2026-09-10-core-preserved-art-and-experience-replan.md`.

## Global constraints

- Preserve finite/LIFO/cardinal-service rules and current stage IDs.
- Existing images are references; approved direction is not blanket approval of newly generated pixels.
- 64×64 logical rail cell, edge-center ports, constant gauge and tangent continuity remain required.
- No baked terrain in objects/effects; no new gameplay authority in animation callbacks.
- Machine verification primary, final user review separate; no five-person study.

## Task 1: approved direction readback

- [x] Read current branch, latest main, PR checks and current consumer paths.
- [x] Merge approved research/spec PR #282 using ordinary protected workflow and read back main.
- [x] Continue in a new branch from merged main, preserving root local changes.

## Task 2: connected rail master candidate

Files: `evidence/design/night-workshop-assets-20260910/rail-master.png`, candidate receipt in the same directory.
Consumes: four rail slots in `game/demo/presentation/product_board_renderer.gd`.
Produces: a single transparent connected family master for review, not automatically valid tile derivatives.

- [x] Generate the outer rounded route with horizontal/vertical cross routes, four turnouts and a central crossing, matching the approved materials.
- [x] Inspect alpha and actual geometry. Record deviations rather than claim a valid tiling contract from a picture.
- [x] Stage a source copy in the unique Aseprite candidate directory and preserve an editable source.
- [ ] Only extract production tiles after identifying actual ports and proving rotation/adjacency at game scale. A rejected geometry stops tile adoption, not the rest of independent candidate preparation.

## Task 3: cargo action candidate

Files: generated 2×2 source sheet; `cargo-lift.aseprite`; `cargo-lift.png`; `cargo-lift.json`; receipt.
Consumes: future confirmed load/unload presentation through current demo presentation layer; domain mutation is excluded.
Produces: four individually timed transparent frames with constant cell size, explicit pivot and source hash.

- [x] Generate preparation/lift/float/settle poses in four equal source cells; internal painted detail variation remains a visual-review limitation.
- [x] Read actual dimensions1254×1254 and source cells627×627.
- [x] Create the empty Aseprite canvas and all four blank frames before importing any pixels, avoiding copied prior cels.
- [x] Import initial equal cells, measure bounds, then align into a common448×448 motion envelope using exact offsets recorded in the candidate README.
- [x] Set durations to60/60/60/60ms; export untrimmed horizontal PNG plus JSON with2px padding. Fixed pivot `(224,224)` is recorded separately, not falsely claimed as embedded slice data.
- [x] Inspect exported sheet and metadata: four distinct frames, true alpha, no clipped sprite, no secondary sprite, expected duration and cell sizes. Mark visual identity/pose deviations explicitly.

## Task 4: delivery and runtime boundary

- [x] Record generated source, editable source and export hashes; add `.gdignore` to keep candidate art out of engine imports.
- [x] Verify frame metadata and alpha using read-only image analysis; run contract/diff checks before commit.
- [x] Complete five self-review loops covering consumers/scope/clarity/provenance/import/evidence and correct validated findings.
- [x] Candidate-preparation PR #283 merged at 4038ff04420bb9b7e385654d09f63161c1e2036b.
- [ ] After final pixel approval, integrate approved assets in the existing manifest/renderer, add relevant RED→GREEN tests, run Godot import/regression and exact-project runtime captures. The current task does not substitute a generated image for this runtime evidence.

SX-DEC-070 continuation: approved three-object manifest, renderer and pickup timeline implemented;
RED→GREEN full suite 121 cases / 14,152 assertions. Final checkbox stays open until actual
object-board and pickup capture is reviewed. Explicit-PID CLI/addon mismatch is recorded in
the decision owner; do not silently upgrade the provider or mark runtime PASS.
