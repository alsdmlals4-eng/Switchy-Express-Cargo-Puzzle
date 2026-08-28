# SX-DEC-063 Hybrid Miniature-Diorama Production Design

**Status:** USER_APPROVED_DIRECTION · TERRAIN_V02_APPROVED_GITHUB_PRESERVED · RUNTIME_INTEGRATION_CONTRACT_READY · GODOT_RUNTIME_UNCHANGED
**Decision:** SX-DEC-063
**Issue:** #239
**Authority:** docs/decisions/SX_DEC_063_HYBRID_MINIATURE_DIORAMA_VISUAL_PRODUCTION_ALIGNMENT.md

## Direction anchor

The finite cargo puzzle continues to use a rectangular 2D interaction grid. Production art adds coherent elevated miniature-diorama depth **inside** those real consumer bounds, making route and stack choices warmer and easier to read without remapping any player input.

## Before / after

| Area | Current verified state | Intended production state |
| --- | --- | --- |
| Board interaction | Rectangular cells, direct input, real semantic overlays | Unchanged. No camera-coordinate conversion. |
| Board material | Warm terrain backdrop plus a separately readable pixel/black-outline object family | Terrain, rail, train, cargo, station, and markers share one toy-scale material, light direction, contour weight, and depth cue. |
| Shells | Real text-free assets with sparse control-deck framing | Same live text/controls, but better crop support and a more intentional navy/brass framing relationship. |
| Rules | Current finite puzzle / cardinal service / LIFO | Unchanged and never embedded in art. |

## Consumer and asset map

### Board family — SX-VIS-063-RQ-001

| Slot key | Current source | Proposed candidate path |
| --- | --- | --- |
| board_terrain | board/board_terrain_playfield_v01.png | ed_hybrid_v2/board/board_terrain_playfield_v02.png |
| train | core_train_locomotive_blue_normal_v01.png | core_train_locomotive_blue_normal_v02.png |
| rail_straight, rail_curve, rail_crossing, rail_switch | v01 core rail set | same filenames with v02 |
| start_marker, route_end_marker | v01 marker set | same filenames with v02 |
| station_red, station_blue, station_yellow | v01 station set | same filenames with v02 |
| cargo_red, cargo_blue, cargo_yellow | v01 cargo-star set | same filenames with v02 |

### Shell family — SX-VIS-063-RQ-002

| Consumer | Current path | Proposed candidate path | Protected condition |
| --- | --- | --- | --- |
| Title | shell_title_hero_v01.png | shell_title_hero_v02.png | Live title/subtitle/actions remain Godot UI. |
| Shared non-T2 Lesson | shell_lesson_hero_v01.png | shell_lesson_hero_v03.png | T2 stays on its exact v02 Hero. |
| Success Result | shell_result_success_v02.png | shell_result_success_v03.png | Result truth/copy/actions remain Godot UI. |
| Failure Result | shell_result_failure_v02.png | shell_result_failure_v03.png | No invented score, economy, or false cause. |

## Art technique card

~~~yaml
style_name: SWITCHY_HYBRID_MINIATURE_DIORAMA
world_materials: warm grass, soil, rounded stone, timber sleepers, brass hardware, navy enamel, subtle soft shadow
outline_policy: thin dark navy/brown separation only; no universal heavy pure-black pixel contour
lighting: upper-left warm practical light, soft occlusion beneath objects, readable mid-value playfield
camera_policy: 3/4 elevation cues inside a rectangular cell projection; no perspective hit-test transformation
silhouette_policy: train compact and forward-readable; station visibly off-track; cargo keeps type silhouette; rail ports stay clear
ui_policy: deep navy/charcoal panels, small brass trim, live localized text, purposefully grouped controls
hard_exclusions:
  - text, pseudo-text, logo, watermark, fake interface
  - long train as LIFO representation
  - coin, score, save, leaderboard, progression
  - diagonal/footprint station service claim
  - direct stylistic imitation or copied layout from the reference collage
~~~

## Candidate sequence

1. SX-VIS-063-CANDIDATE-001 — board terrain v02, generated, machine-reviewed, and user-promoted to `art/product_assets/ed_hybrid_v2/board/board_terrain_playfield_v02.png` (Issue #243); runtime remains v01.
2. The approved v02 must be compared at the real 1672×941 backdrop crop and 1280×720 BUILD consumer during the dedicated integration contract.
3. Each subsequent board or shell candidate receives its own brief, generation, review, GitHub provenance, and promotion/revise/reject disposition.
4. `기획서/50_제작_검증/SX_DEC_063_TERRAIN_RUNTIME_INTEGRATION_HANDOFF.md` owns the one-asset integration-only window: versioned consumer-path update, manifest/provenance status update, tests, Godot runtime comparison, package invalidation/new candidate, and five-pass review.

No candidate sequence step implicitly authorizes the next one.

## First exact image brief

~~~text
Create one text-free 1672×941 landscape terrain backdrop for the actual Switchy Express BUILD/RUN board consumer. It is a cozy premium-casual miniature railway clearing seen with subtle elevated 3/4 depth cues but designed to sit under a rectangular Godot grid. Use warm grass, soft dirt paths, rounded grey stones, small conifers at the outer edges, timber/brass mood details, a warm upper-left practical light, and soft occlusion. Keep the central 70% of the image calm, open, medium-value, and free of rails, train, station, cargo, marker, UI, text, logo, watermark, coins, score, save symbols, or branded/source-specific objects. The artwork must support—not compete with—live grid, route, cargo, station, and HUD overlays.
~~~

## Validation and evidence ceiling

- Before integration: visual candidate QA, consumer-size crop review, GitHub provenance, SHA-256, and GitHub remote readback.
- During later integration: focused asset path/manifest tests, full Godot suite, all supported viewport hierarchy checks, live runtime screenshots, same-state comparison, package candidate regeneration, and five-pass review.
- Not proof: image generation, source-file presence, or a machine capture alone.
- Still NOT_RUN until separately performed: Windows physical/audio, Android device, five-person comprehension, Player Experience, release-rights conclusion, production cutover.

## Rollback

Keep existing v01/v02 files and current consumers intact until the later integration PR passes. Reverting candidate integration means restoring the existing consumer paths; it does not delete preserved assets or provenance.
