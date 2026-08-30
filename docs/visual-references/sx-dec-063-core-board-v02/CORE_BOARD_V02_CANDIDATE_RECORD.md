# SX-DEC-063 Core Board v02 candidate record

> **Status:** `BRIEF_READY · USER_APPROVED_FOR_CANDIDATE_GENERATION · NO_RUNTIME_PATH_CHANGE`
>
> **Decision and consumer:** `SX-DEC-063` → `game/demo/presentation/product_board_renderer.gd::PRODUCT_VISUAL_ASSET_PATHS`
>
> **User direction:** 2026-08-30 — create the missing rail and station images, connect Godot and its plugin, and implement the approved Core Board v02 direction.
>
> **Candidate-promotion gate:** A generated image is `GENERATED_CANDIDATE · NOT_RUNTIME_ASSET` until the user approves the assembled Core Board v02 pixels. No file is promoted into `art/product_assets/`, and no renderer path changes, before that disposition.

## Scope and preserved rules

This record defines only the missing normal-state image family for the existing fourteen `ProductBoardRenderer` visual slots. The already user-approved `SX-BOARD-TERRAIN-002` remains the v02 terrain candidate and rollback v01 binaries remain on disk.

- Existing consumer slots only: terrain, locomotive, straight/curve/crossing/switch rail, start/route-end markers, three off-track stations, and three cargo stars.
- The game stays a finite delivery puzzle: rectangular grid, exact-cell cargo contact, cardinal-adjacent station service, LIFO/TOP, Manual/Auto, direct route/switch control, occupied lock, and current T1–T6/capstone flow remain unchanged.
- Service frames, selected/alternate/locked routes, HUD, localization, labels, and interaction feedback remain procedural Godot layers; this family has only normal-state sprites.
- The reference is project-owned HGB r02 document candidate `SX-HGB-VIS-004`, stored at `docs/visual-references/human-game-blueprint/r02/sx-hgb-vis-004-rail-station-language-candidate.png`. It is a material-language reference only: do not crop, embed, ship, copy its framed sheet, or reproduce its object arrangement.
- No third-party screenshot, game, asset pack, character, logo, or creator style is an input.

## Common image-model prompt contract

Use this prefix unchanged for every individual generation request, followed by exactly one subject suffix below.

```text
Use case: stylized-concept
Asset type: one original Godot Core Board v02 sprite for Switchy Express: Cargo Puzzle
Input image: the approved in-project Human Game Blueprint rail/station sheet is a style reference only; do not crop it, copy its framed board layout, or reproduce its object arrangement.
Style/medium: premium cozy miniature railway diorama, restrained 2.5D elevated cues within a rectangular-grid game piece, rounded readable silhouette, timber sleepers, dark steel rails, stone edging, modest moss, warm brass hardware, soft contact shadow, upper-left warm practical light, thin dark brown/navy separation.
Composition: one centered object only, generous transparent margin, designed to remain unmistakable when rendered inside a 64-pixel game cell unless a different target size is stated.
Constraints: genuine transparent background; no text, letters, numbers, logo, watermark, UI panel, frame, terrain backdrop, train wagon, coin, score, save symbol, fuel, boost, capacity symbol, or diagonal-station-service implication; no third-party art, trademark, or identifiable reference layout.
```

## Candidate matrix

| Candidate ID | Exact target path | Exact subject suffix | Target size | Candidate state |
| --- | --- | --- | --- | --- |
| `SX-VIS-063-CORE-TRAIN-001` | `art/product_assets/ed_hybrid_v2/core/core_train_locomotive_blue_normal_v02.png` | `Subject: compact navy-blue locomotive facing right, short engine body only, brass lamp, no cargo wagon. Target render footprint: 128×96.` | 128×96 | `BRIEF_READY` |
| `SX-VIS-063-CORE-RAIL-STRAIGHT-001` | `art/product_assets/ed_hybrid_v2/core/core_rail_straight_normal_v02.png` | `Subject: straight rail tile with exactly two clear ports centered on the left and right edges. Target render footprint: 64×64.` | 64×64 | `BRIEF_READY` |
| `SX-VIS-063-CORE-RAIL-CURVE-001` | `art/product_assets/ed_hybrid_v2/core/core_rail_curve_normal_v02.png` | `Subject: quarter-turn rail tile with exactly two clear ports centered on the left and top edges. Target render footprint: 64×64.` | 64×64 | `BRIEF_READY` |
| `SX-VIS-063-CORE-RAIL-CROSSING-001` | `art/product_assets/ed_hybrid_v2/core/core_rail_crossing_normal_v02.png` | `Subject: crossing rail tile with exactly four clear ports centered on all edges; north-south and east-west rails cross at one central point. Target render footprint: 64×64.` | 64×64 | `BRIEF_READY` |
| `SX-VIS-063-CORE-RAIL-SWITCH-001` | `art/product_assets/ed_hybrid_v2/core/core_rail_switch_three_way_normal_v02.png` | `Subject: three-way rail switch with exact ports centered left, top, and right; one compact manual switch lever at the lower-right, no route arrows or lock icon. Target render footprint: 64×64.` | 64×64 | `BRIEF_READY` |
| `SX-VIS-063-CORE-START-001` | `art/product_assets/ed_hybrid_v2/core/core_marker_start_normal_v02.png` | `Subject: small brass-and-navy circular start marker with a simple forward arrow, visually distinct from cargo and station, no letters. Target render footprint: 64×64.` | 64×64 | `BRIEF_READY` |
| `SX-VIS-063-CORE-END-001` | `art/product_assets/ed_hybrid_v2/core/core_marker_route_end_normal_v02.png` | `Subject: small crimson route-end beacon on a stone plinth, visually distinct from cargo and station, no letters. Target render footprint: 64×64.` | 64×64 | `BRIEF_READY` |
| `SX-VIS-063-CORE-STATION-RED-001` | `art/product_assets/ed_hybrid_v2/core/core_station_red_normal_v02.png` | `Subject: compact red off-track station building on its own stone plinth, with no rail through its footprint and no service-ring graphics. Target render footprint: 64×64.` | 64×64 | `BRIEF_READY` |
| `SX-VIS-063-CORE-STATION-BLUE-001` | `art/product_assets/ed_hybrid_v2/core/core_station_blue_normal_v02.png` | `Subject: compact blue off-track station building on its own stone plinth, with no rail through its footprint and no service-ring graphics. Target render footprint: 64×64.` | 64×64 | `BRIEF_READY` |
| `SX-VIS-063-CORE-STATION-YELLOW-001` | `art/product_assets/ed_hybrid_v2/core/core_station_yellow_normal_v02.png` | `Subject: compact yellow off-track station building on its own stone plinth, with no rail through its footprint and no service-ring graphics. Target render footprint: 64×64.` | 64×64 | `BRIEF_READY` |
| `SX-VIS-063-CORE-CARGO-RED-001` | `art/product_assets/ed_hybrid_v2/core/core_cargo_star_red_normal_v02.png` | `Subject: red five-point cargo star token with a thick dark outline and small brass cargo clasp, no text. Target render footprint: 64×64.` | 64×64 | `BRIEF_READY` |
| `SX-VIS-063-CORE-CARGO-BLUE-001` | `art/product_assets/ed_hybrid_v2/core/core_cargo_star_blue_normal_v02.png` | `Subject: blue five-point cargo star token with a thick dark outline and small brass cargo clasp, no text. Target render footprint: 64×64.` | 64×64 | `BRIEF_READY` |
| `SX-VIS-063-CORE-CARGO-YELLOW-001` | `art/product_assets/ed_hybrid_v2/core/core_cargo_star_yellow_normal_v02.png` | `Subject: yellow five-point cargo star token with a thick dark outline and small brass cargo clasp, no text. Target render footprint: 64×64.` | 64×64 | `BRIEF_READY` |

## Candidate review contract

Before images are shown to the user, each native output and its 64×64 or 128×96 Godot-scale preview must pass all five review attacks.

| Loop | Review attack | Required disposition |
| --- | --- | --- |
| 1 | Consumer mismatch or non-runtime composition | One centered sprite matches its named existing slot; no board sheet, scene, panel, or unexplained use. |
| 2 | Cardinal rail-port or station-footprint violation | Rail ports match the named edges exactly; stations contain no rail or service-ring graphics. |
| 3 | Low-resolution silhouette/readability failure | Object remains distinguishable at its final target footprint with transparent outer space and safe edge clearance. |
| 4 | Style/reference/provenance or embedded-text drift | Warm miniature materials align; no text, logo, watermark, third-party source, copied frame, or reference layout appears. |
| 5 | Accidental gameplay, UI, evidence, or scope claim | No cargo wagon, route/lock cue, HUD, metric, station-service implication, or runtime/physical/human completion claim is embedded. |

Any failure requires a targeted regeneration of only the defective subject, followed by a fresh five-loop review of that candidate.

## Promotion receipt — pending actual generation

| Field | Current truth |
| --- | --- |
| Image-model outputs | `NOT_GENERATED_YET` |
| Candidate image locations | `NOT_GENERATED_YET` |
| User pixel approval | `PENDING_ASSEMBLED_BUNDLE` |
| Files in `art/product_assets/ed_hybrid_v2/core/` | `0_NEW_FILES` |
| `ProductBoardRenderer` v02 paths | `NOT_CHANGED` |
| Godot runtime / physical / human evidence | `NOT_RUN` |
