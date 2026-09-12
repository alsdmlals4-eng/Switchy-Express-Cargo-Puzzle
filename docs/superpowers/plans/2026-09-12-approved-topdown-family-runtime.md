# Approved top-down family runtime completion

Spec: docs/superpowers/specs/2026-09-10-core-preserved-art-and-experience-replan.md,
top-view amendment; current Decisions September 12 approval. Baseline main 2de6bd6.

## Global Constraints

- Only exact approved thirteen PNGs in evidence/design/topdown-20260911/candidates.json.
- Preserve finite core, map coordinates, selected slate board, joined rails, overhead train, wordmark.
- No new pixel editing, no rejected scenic images, no primitive substitute art. Compose existing textures.
- Keep cargo target scale 0.62; no transparent-padding enlargement. Shared top-view lighting/orientation.
- Lifecycle: pause, reduced motion, start/retry/edit cancellation; presentation cannot own gameplay.
- Existing dirty files and other PRs protected. Explicit-path staging. No direct deletion.
- Game, automated, screenshot, PDF and final user approval remain distinct evidence.

## Task 1: Register and connect approved world family

Copy eleven exact selected candidates to art/product_assets/topdown_v1/ (snake_case names).
Extend existing manifest with all thirteen hashes, source paths, approval dates, dimensions,
alpha and exact ProductBoardRenderer consumer keys. Connect all eleven existing keys in renderer.
No .aseprite or atlas fabrication: source pixels are static. Extend current blue-only pickup
presentation to RED_STAR, BLUE_DIAMOND, YELLOW_TRIANGLE and WASTE using their matching approved
lid, existing DURATION 0.24 and offset 0.16; unsupported types fail closed. Check actual domain
cargo ids first, use authoritative identifiers if they differ from this prose. Preserve
pause/resume/reduced-motion/cancel behavior and scale0.62, including rapidly replaced pickups.
RED-first regression: exact consumer paths, loaded Texture2D family, static byte equality,
all supported cargo types matching texture and lifecycle, no old oblique runtime consumer.
Own renderer/animation, art/product_assets/topdown_v1/, relevant existing tests only.
Do not edit candidate source catalog/authority docs (controller owns), shell renderer or live editor.
Run full custom Godot tests/run_tests.gd and Python suite once after focused corrections.
Godot console path C:/Users/user/Downloads/Godot_v4.7.1-stable_win64.exe/Godot_v4.7.1-stable_win64_console.exe.
Self-review and commit explicit files; no push. Report commands/output RED and GREEN, files, concerns.

## Task 2: Compose consistent top-down shell scenes

Replace ProductShellArt's five legacy oblique hero-image selections with a presentation-only
composition of existing approved slate/rail/train and registered topdown family. Keep same Control,
mode/set_lesson_id/set_result_outcome API and ignore input. Layout texture layers in normalized
rectangles within available region, aspect-preserving and clipped to control; no render-time file writes.
TITLE: overhead yard with readable negative space. LESSON: overhead cargo on rail and station
beside rail; T2 depicts cardinal adjacency rather than station-on-track. RESULT success/failure
must remain visibly distinct without inventing mechanics; composition remains illustration, not
actual attempt proof. Retain existing UI text/buttons/wordmark and flow authority.
Use a shared square-unit layout for any connected rail illustration so resizing cannot create
unequal tile scale or disconnected joins. T2 station center is one cardinal tile from service rail.
Use modest decorative accents, not oversized cargo or fields of props. Include five decor family
keys in meaningful shell consumption if existing board map data uses only a subset. No new bitmap.
RED-first tests for all modes/outcomes/T2, no legacy hero paths, loaded textures, aspect-preserving
bounded placements at 1280x720 and smaller controls, responsive resize, mouse_filter IGNORE.
Own product_shell_art.gd, shell-focused tests/necessary callers only. Do not alter Task1 domain logic.
Full custom Godot and Python suite after changes. Commit explicit files, no push; report evidence.

## Task 3: Runtime evidence, human Blueprint, review and delivery

Controller uses exact project session only, captures board including red/yellow/disposal/decor,
title, lesson/T2, success/failure and motion/pause/retry. Inspect pixels at actual viewport.
Correct validated in-scope findings through implementer. Update existing source owners/candidate
catalog to actual implemented state. Refresh existing human Blueprint generator/output with new
asset/runtime evidence, inspect rendered pages; no new parallel GDD owner. Five-pass full-scope
review, final independent branch review, exact-head required checks, normal merge/readback.
Preserve local dirty main and active editor. Finished scratch goes to user deletion holding,
never directly deleted. Final user appearance and release validation remain separate.
