# SX-DEC-063 Core Board v02 Asset and Runtime Design

**Status:** `USER_APPROVED_FOR_CANDIDATE_GENERATION`
**Date:** 2026-08-30 KST
**Decision baseline:** `SX-DEC-063 · HYBRID_MINIATURE_DIORAMA_VISUAL_PRODUCTION_ALIGNMENT`
**User direction:** 2026-08-30 — approve the core-board implementation, ask for required images plus Godot integration, and authorize local Godot/Hera activation.
**Candidate-promotion gate:** Generated images are review candidates only. The user must approve the assembled Core Board v02 pixels before any runtime path changes.
**Supersedes:** nothing. This is the next bounded implementation package under SX-DEC-063; it does not replace the terrain-only package until its proposed scope is approved and executed.

## Direction anchor

Use the approved Human Game Blueprint rail/station visual language as an in-project **style reference**, then create a coherent, versioned Core Board v02 asset pack for the exact existing `ProductBoardRenderer` consumers. Keep the rectangular cell grid, input mapping, finite rules, and procedural meaning layers unchanged.

## Problem and outcome

The current board loads v01 terrain and 13 small v01 core PNGs. The approved HGB r02 rail/station image is a document composition rather than an engine sprite sheet: it includes a presentation background, margins, and multiple unrelated objects, so it cannot safely be cropped into runtime art. The current v01 rail/station images consequently remain visually disconnected from the approved miniature-diorama direction.

The intended result is one board family with warm grass/stone/timber/brass material, thin dark brown/navy separation, upper-left warm light, and readable 2.5D depth cues. Gameplay surfaces must remain more legible than ornament at the existing viewport sizes.

## Authority and references

| Role | Owner | Disposition |
| --- | --- | --- |
| Runtime consumer | `game/demo/presentation/product_board_renderer.gd::PRODUCT_VISUAL_ASSET_PATHS` | Reuse the existing 14-slot projection; do not create a new renderer. |
| Existing approved backdrop | `art/product_assets/ed_hybrid_v2/board/board_terrain_playfield_v02.png` | Reuse as the board v02 terrain source; it already has an exact consumer and SHA-256 record. |
| Visual reference | `docs/visual-references/human-game-blueprint/r02/sx-hgb-vis-004-rail-station-language-candidate.png` | `USER_APPROVED_DOCUMENT_VISUAL · REFERENCE_ONLY`; use material/silhouette grammar, never crop or ship pixels from it. |
| Product constraints | `docs/decisions/SX_DEC_063_HYBRID_MINIATURE_DIORAMA_VISUAL_PRODUCTION_ALIGNMENT.md` and `AGENTS.md` | Adapt only within the existing rectangular finite-puzzle product contract. |
| Runtime proof | active Godot 4.7.1 editor session with Hera Agent, headless test runner, and exact build artifacts | Required after integration; no generated image or document preview is runtime proof. |

## Scope

### Included Core Board v02 family

The first candidate bundle uses these explicit existing runtime slots. `v01` remains untouched on disk for rollback.

| Slot | v02 target path | Target render footprint | State family |
| --- | --- | ---: | --- |
| `board_terrain` | `art/product_assets/ed_hybrid_v2/board/board_terrain_playfield_v02.png` | 1672×941 backdrop | existing approved v02 |
| `train` | `art/product_assets/ed_hybrid_v2/core/core_train_locomotive_blue_normal_v02.png` | 128×96 | normal |
| `rail_straight` | `art/product_assets/ed_hybrid_v2/core/core_rail_straight_normal_v02.png` | 64×64 | normal; rotation remains renderer-owned |
| `rail_curve` | `art/product_assets/ed_hybrid_v2/core/core_rail_curve_normal_v02.png` | 64×64 | normal; rotation remains renderer-owned |
| `rail_crossing` | `art/product_assets/ed_hybrid_v2/core/core_rail_crossing_normal_v02.png` | 64×64 | normal |
| `rail_switch` | `art/product_assets/ed_hybrid_v2/core/core_rail_switch_three_way_normal_v02.png` | 64×64 | normal; selected/locked route remains procedural |
| `start_marker` | `art/product_assets/ed_hybrid_v2/core/core_marker_start_normal_v02.png` | 64×64 | normal |
| `route_end_marker` | `art/product_assets/ed_hybrid_v2/core/core_marker_route_end_normal_v02.png` | 64×64 | normal |
| `station_red`, `station_blue`, `station_yellow` | `art/product_assets/ed_hybrid_v2/core/core_station_<color>_normal_v02.png` | 64×64 each | normal; cardinal service remains procedural |
| `cargo_red`, `cargo_blue`, `cargo_yellow` | `art/product_assets/ed_hybrid_v2/core/core_cargo_star_<color>_normal_v02.png` | 64×64 each | normal; color + shape + live label redundancy remains |

Every new core sprite is an original, text-free, logo-free, watermark-free PNG with a genuinely transparent background. Its final source crop keeps all rail ports aligned to the current cell center/edge convention. The image model generates the artwork; deterministic downscaling and import packaging only prepare that generated source for the documented footprint.

### Explicitly excluded

- Any map, schema, track graph, train behavior, cell hit-test, camera, or scene-coordinate change.
- Cardinal-station service semantics, cargo exact-cell pickup, LIFO/TOP, manual/auto mode, route-lock behavior, HUD copy, localization, audio, score, currency, progression, or tutorial changes.
- T2 `shell_lesson_hero_v02.png`, Issue #227, shell art, PR #174, Base repin, third-party art, embedded text, and image-only state feedback.
- Any claim that image generation, a local import, automated tests, or a machine screenshot passes physical Windows/audio, Android, five-person, player-experience, release-rights, or production-cutover gates.

## Art and interaction contract

- **Material grammar:** rounded toy-scale geometry; timber sleepers, metal rails, stone edging, modest moss/grass; gentle occlusion; a common upper-left warm key light.
- **Legibility:** track ports occupy the same semantic directions as v01; stations are visibly off-track; station color is paired with the existing outlined shape and live label; markers never resemble cargo or station service cells.
- **State ownership:** v02 images are normal-state surface art only. The renderer keeps the grid, blocked cells, four-cell service feedback, selected/alternative/locked routes, current train state, and HUD as live procedural/UI layers.
- **Input safety:** `_board_rect()`, `board_cell_from_local()`, cell sizes, rotation quarters, draw order, and `draw_texture_rect()` contracts stay unchanged.

## Candidate, approval, and promotion sequence

1. Create one candidate for each new core slot with the built-in image model, using only the approved project visual references and this specification.
2. Inspect the native images and the 64/128-pixel game footprint for transparency, directionality, rail-port clarity, cropping, text/watermark, visual drift, and independent-origin constraints.
3. Present the assembled Core Board v02 candidate bundle to the user. `GENERATED_CANDIDATE` is not a runtime asset and does not alter the renderer.
4. Only after the user approves or revises the actual candidate bundle, preserve selected binaries under the target Git paths, record model/prompt/SHA-256/provenance and final disposition, then proceed to runtime integration.
5. A user-approved bundle changes the player-facing byte set. Candidate 004 remains preserved historical package evidence and cannot pass the new byte set. A new exact candidate and later physical gates are required.

## Runtime integration contract

After final art approval, `PRODUCT_VISUAL_ASSET_PATHS` switches only the above 14 slots to the versioned v02 locations. `_load_product_visuals()`, `_draw_board_terrain()`, `_draw_track_piece()`, `_draw_marker()`, and the renderer’s published visual layer order remain structurally unchanged.

The manifest adds every approved v02 core asset with its exact consumer, dimensions, SHA-256, source-generation receipt, approval state, and `runtime_connection_status`. Source v01 entries remain in their existing manifest and are never deleted or overwritten.

## Test and runtime-verification contract

1. **RED first:** Extend the GDScript renderer test so it expects all 14 v02 paths, confirms every texture loads as `Texture2D`, confirms no bitmap slot exists for station service/route lock, and preserves the draw-order contract. Extend the Python asset test for manifest parity, SHA-256, alpha/dimensions, import descriptor, v01 rollback presence, and exact consumer strings. Observe both tests fail while the renderer remains v01.
2. **GREEN:** Add selected image candidates only after final asset approval, update the v02 consumer map, then run the focused GDScript and Python tests to green.
3. **Regression:** Re-run the project contract validator, full headless Godot suite, relevant Python suite, and Godot import. Do not hand-edit generated import cache files.
4. **Live runtime:** With the current Hera-connected Godot 4.7.1 editor, launch representative 1280×720 BUILD and RUN snapshots. Inspect route ports, off-track stations, cardinal service frames, cargo, selected/locked routing, train, HUD, crop, and clipping; save captures as evidence rather than human proof.
5. **Package/evidence:** Run the approved package flow only after the exact-head automated gates are green. Record a newly produced exact candidate if successful; otherwise retain `NOT_RUN`.

## Required adversarial close

Five complete review loops must independently attack and resolve:

1. Gameplay/input invariants and renderer-versus-domain ownership.
2. Sprite rotation, rails, transparency, import, missing texture, and one-line v01 rollback.
3. 64/128-pixel readability, visual hierarchy, state distinction, long localized text, safe bounds, and clipping.
4. Provenance, reference similarity, text/watermark, consumer/manifest/hash mismatch, and unapproved candidate promotion.
5. Candidate/package/physical/audio/device/human evidence inflation, protected PRs, and scope drift.

Any valid finding is corrected and the affected full test and review scopes are repeated. No partial visual upgrade is called complete until those five loops are clean for the exact implementation head.

## Rollback

The rollback is a single consumer-map restoration from each v02 path to its retained v01 equivalent, followed by the same focused and full regression. It does not delete v02 assets, provenance, prior candidate receipts, or evidence history.

## Expected before/after and evidence ceiling

| Item | Before | After if this package is completed |
| --- | --- | --- |
| Board art | v01 terrain and core assets have mixed visual language | Approved v02 terrain and core assets share the miniature-diorama grammar. |
| Meaning layers | Grid, service, route, lock, and HUD are live/procedural | Unchanged; their readability is tested against the richer art. |
| Rollback | v01 assets are live | v01 assets remain tracked rollback sources. |
| Candidate evidence | Candidate 004 package is current only for its older bytes | New exact candidate required after v02 runtime paths change. |
| Physical/human evidence | `NOT_RUN` | Still `NOT_RUN` until separately executed on the new exact candidate. |

## Review request

This is a design and verification contract only. It intentionally creates no sprites and changes no Godot code. The next step is a detailed, test-first implementation plan; that plan should be written only after the user confirms this saved specification.
