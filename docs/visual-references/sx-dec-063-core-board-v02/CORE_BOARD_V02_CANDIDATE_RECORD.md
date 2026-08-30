# SX-DEC-063 Core Board v02 candidate record

> **Status:** `USER_APPROVED · GITHUB_PROMOTED · RUNTIME_VERIFIED_AUTOMATED · PHYSICAL_HUMAN_NOT_RUN`
>
> **Decision and consumer:** `SX-DEC-063` → `game/demo/presentation/product_board_renderer.gd::PRODUCT_VISUAL_ASSET_PATHS`
>
> **User direction:** 2026-08-30 — create the missing rail and station images, connect Godot and its plugin, and implement the approved Core Board v02 direction.
>
> **Promotion disposition:** The user approved the assembled 13-image pixels and the narrow visual-only curve/switch seam underlay on 2026-08-30. The selected final binaries are now preserved in the stated v02 paths and loaded by the existing renderer; physical and human gates remain separate and unrun.

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
| `SX-VIS-063-CORE-TRAIN-001` | `art/product_assets/ed_hybrid_v2/core/core_train_locomotive_blue_normal_v02.png` | `Subject: compact navy-blue locomotive facing right, short engine body only, brass lamp, no cargo wagon. Target render footprint: 128×96.` | 128×96 | `USER_APPROVED · PROMOTED · AUTOMATED_RUNTIME_VERIFIED` |
| `SX-VIS-063-CORE-RAIL-STRAIGHT-001` | `art/product_assets/ed_hybrid_v2/core/core_rail_straight_normal_v02.png` | `Subject: straight rail tile with exactly two clear ports centered on the left and right edges. Target render footprint: 64×64.` | 64×64 | `USER_APPROVED · PROMOTED · AUTOMATED_RUNTIME_VERIFIED` |
| `SX-VIS-063-CORE-RAIL-CURVE-001` | `art/product_assets/ed_hybrid_v2/core/core_rail_curve_normal_v02.png` | `Subject: quarter-turn rail tile with exactly two clear ports centered on the left and top edges. Target render footprint: 64×64.` | 64×64 | `USER_APPROVED · PROMOTED · AUTOMATED_RUNTIME_VERIFIED · SEAM_UNDERLAY` |
| `SX-VIS-063-CORE-RAIL-CROSSING-001` | `art/product_assets/ed_hybrid_v2/core/core_rail_crossing_normal_v02.png` | `Subject: crossing rail tile with exactly four clear ports centered on all edges; north-south and east-west rails cross at one central point. Target render footprint: 64×64.` | 64×64 | `USER_APPROVED · PROMOTED · AUTOMATED_RUNTIME_VERIFIED` |
| `SX-VIS-063-CORE-RAIL-SWITCH-001` | `art/product_assets/ed_hybrid_v2/core/core_rail_switch_three_way_normal_v02.png` | `Subject: three-way rail switch with exact ports centered left, top, and right; one compact manual switch lever at the lower-right, no route arrows or lock icon. Target render footprint: 64×64.` | 64×64 | `USER_APPROVED · PROMOTED · AUTOMATED_RUNTIME_VERIFIED · SEAM_UNDERLAY` |
| `SX-VIS-063-CORE-START-001` | `art/product_assets/ed_hybrid_v2/core/core_marker_start_normal_v02.png` | `Subject: small brass-and-navy circular start marker with a simple forward arrow, visually distinct from cargo and station, no letters. Target render footprint: 64×64.` | 64×64 | `USER_APPROVED · PROMOTED · AUTOMATED_RUNTIME_VERIFIED` |
| `SX-VIS-063-CORE-END-001` | `art/product_assets/ed_hybrid_v2/core/core_marker_route_end_normal_v02.png` | `Subject: small crimson route-end beacon on a stone plinth, visually distinct from cargo and station, no letters. Target render footprint: 64×64.` | 64×64 | `USER_APPROVED · PROMOTED · AUTOMATED_RUNTIME_VERIFIED` |
| `SX-VIS-063-CORE-STATION-RED-001` | `art/product_assets/ed_hybrid_v2/core/core_station_red_normal_v02.png` | `Subject: compact red off-track station building on its own stone plinth, with no rail through its footprint and no service-ring graphics. Target render footprint: 64×64.` | 64×64 | `USER_APPROVED · PROMOTED · AUTOMATED_RUNTIME_VERIFIED` |
| `SX-VIS-063-CORE-STATION-BLUE-001` | `art/product_assets/ed_hybrid_v2/core/core_station_blue_normal_v02.png` | `Subject: compact blue off-track station building on its own stone plinth, with no rail through its footprint and no service-ring graphics. Target render footprint: 64×64.` | 64×64 | `USER_APPROVED · PROMOTED · AUTOMATED_RUNTIME_VERIFIED` |
| `SX-VIS-063-CORE-STATION-YELLOW-001` | `art/product_assets/ed_hybrid_v2/core/core_station_yellow_normal_v02.png` | `Subject: compact yellow off-track station building on its own stone plinth, with no rail through its footprint and no service-ring graphics. Target render footprint: 64×64.` | 64×64 | `USER_APPROVED · PROMOTED · AUTOMATED_RUNTIME_VERIFIED` |
| `SX-VIS-063-CORE-CARGO-RED-001` | `art/product_assets/ed_hybrid_v2/core/core_cargo_star_red_normal_v02.png` | `Subject: red five-point cargo star token with a thick dark outline and small brass cargo clasp, no text. Target render footprint: 64×64.` | 64×64 | `USER_APPROVED · PROMOTED · AUTOMATED_RUNTIME_VERIFIED` |
| `SX-VIS-063-CORE-CARGO-BLUE-001` | `art/product_assets/ed_hybrid_v2/core/core_cargo_star_blue_normal_v02.png` | `Subject: blue five-point cargo star token with a thick dark outline and small brass cargo clasp, no text. Target render footprint: 64×64.` | 64×64 | `USER_APPROVED · PROMOTED · AUTOMATED_RUNTIME_VERIFIED` |
| `SX-VIS-063-CORE-CARGO-YELLOW-001` | `art/product_assets/ed_hybrid_v2/core/core_cargo_star_yellow_normal_v02.png` | `Subject: yellow five-point cargo star token with a thick dark outline and small brass cargo clasp, no text. Target render footprint: 64×64.` | 64×64 | `USER_APPROVED · PROMOTED · AUTOMATED_RUNTIME_VERIFIED` |

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

## Historical pre-promotion receipt

| Field | Current truth |
| --- | --- |
| Image-model outputs | `HISTORICAL_PRE_PROMOTION_PLACEHOLDER` |
| Candidate image locations | `HISTORICAL_PRE_PROMOTION_PLACEHOLDER` |
| User pixel approval | `HISTORICAL_PRE_PROMOTION_PLACEHOLDER` |
| Files in `art/product_assets/ed_hybrid_v2/core/` | `HISTORICAL_PRE_PROMOTION_PLACEHOLDER` |
| `ProductBoardRenderer` v02 paths | `HISTORICAL_PRE_PROMOTION_PLACEHOLDER` |
| Godot runtime / physical / human evidence | `HISTORICAL_PRE_PROMOTION_PLACEHOLDER` |

## 2026-08-30 generated candidate receipt

The following are built-in image-model outputs. They remain outside the repository's product-asset paths under `C:/Users/user/.codex/generated_images/01a04af4-2ebb-7912-80d3-e4bfa4f1efe0/`; the displayed review copies are deterministic Godot `Image.INTERPOLATE_LANCZOS` reductions in its `sx063-core-board-v02-previews/` subfolder. No candidate source or preview has been copied into `art/product_assets/`.

| Candidate ID | Selected image-model output | SHA-256 | Review preview | Disposition |
| --- | --- | --- | --- | --- |
| `SX-VIS-063-CORE-TRAIN-001` | `exec-eb29fe34-ca5b-423b-9699-962cad5592ef.png` | `4b1ecccda212790e9b9b26d28032fd03e3a726f0c7c6b11e63b79fcdffb66b97` | `SX-VIS-063-CORE-TRAIN-001-alpha-128x96.png` | `GENERATED_CANDIDATE · PASS` |
| `SX-VIS-063-CORE-RAIL-STRAIGHT-001` | `exec-95b28d77-dfa4-43f9-92cc-40d9439e99a8.png` | `9d43427a3e96ad2e7e871faa79c34fc8fcceb51c0306032642ab3a63c5050ecf` | `rail-straight-alt-b-64x64.png` | `GENERATED_CANDIDATE · PASS_WITH_SEAM_REVIEW` |
| `SX-VIS-063-CORE-RAIL-CURVE-001` | `exec-5185a5bf-5907-4282-bcb0-feac95b9104d.png` | `445be8b43563ba639a1d7fbdde5bf6163267c00d516f9feb0de96dd043c4d792` | `SX-VIS-063-CORE-RAIL-CURVE-001-alpha-64x64.png` | `GENERATED_CANDIDATE · PARTIAL_PORT_ALIGNMENT` |
| `SX-VIS-063-CORE-RAIL-CROSSING-001` | `exec-0d0307f1-1e34-45fd-8b6e-9410bf859248.png` | `20858d990ae1bfa1a06e1858826866c98ab7e798ff8fc862c15662a7e2c925fa` | `SX-VIS-063-CORE-RAIL-CROSSING-001-alpha-64x64.png` | `GENERATED_CANDIDATE · PASS_WITH_SEAM_REVIEW` |
| `SX-VIS-063-CORE-RAIL-SWITCH-001` | `exec-52ac3317-0621-48b1-a837-550edeb6e5ab.png` | `d616d4ce8be8d3daa3a24687405a98c2576759e4ba2a9ad14e5a50c068d8a2e7` | `SX-VIS-063-CORE-RAIL-SWITCH-001-alpha-64x64.png` | `GENERATED_CANDIDATE · PARTIAL_PORT_ALIGNMENT` |
| `SX-VIS-063-CORE-START-001` | `exec-3c8e8c35-d79b-4da4-b59b-f31338e71f1f.png` | `c2f2d6d0202ee1eefd0034375eac6be8887d5ee9eb0ce35712377241ed2b73af` | `SX-VIS-063-CORE-START-001-64x64.png` | `GENERATED_CANDIDATE · PASS` |
| `SX-VIS-063-CORE-END-001` | `exec-8f14bfa3-a06d-42e8-98dc-7a8b369187fe.png` | `0055dc4e3e45dbc4fc778443a81cc86edc889297360894c659d0fb217d3972e1` | `SX-VIS-063-CORE-END-001-64x64.png` | `GENERATED_CANDIDATE · PASS` |
| `SX-VIS-063-CORE-STATION-RED-001` | `exec-a5842278-90f2-4964-8c0a-215f0ec0fab6.png` | `fa7e880593bc35c20462266650895f6243c7c9817e770ea49b2937449c93ed07` | `SX-VIS-063-CORE-STATION-RED-001-alpha-64x64.png` | `GENERATED_CANDIDATE · PASS` |
| `SX-VIS-063-CORE-STATION-BLUE-001` | `exec-c3748987-887a-4209-a222-26ade19b7eab.png` | `9e48821d85921c0b4e8d4f595b11ce084c86cdd199d25b74dad83d30c896260e` | `SX-VIS-063-CORE-STATION-BLUE-001-64x64.png` | `GENERATED_CANDIDATE · PASS` |
| `SX-VIS-063-CORE-STATION-YELLOW-001` | `exec-c9e9af7e-2139-4bb6-ba9a-c54abeeadae8.png` | `d41cd8308744ff6ee10270e7d8b87e6d8fb9567474015664c3da77f60ed8c436` | `SX-VIS-063-CORE-STATION-YELLOW-001-64x64.png` | `GENERATED_CANDIDATE · PASS` |
| `SX-VIS-063-CORE-CARGO-RED-001` | `exec-fca9e1d1-fd36-4d79-9e77-08b51f46b66d.png` | `157eb9c4058191d35c2b22d148c7a6c8af2241ac87d05ec65d69259d691007f0` | `SX-VIS-063-CORE-CARGO-RED-001-64x64.png` | `GENERATED_CANDIDATE · PASS` |
| `SX-VIS-063-CORE-CARGO-BLUE-001` | `exec-382a8f00-8c25-415b-872b-df80c7124ee6.png` | `5d16101bf845bdb3947de85bce354b382a38f94d2014ba71a38fa418f66e22b6` | `SX-VIS-063-CORE-CARGO-BLUE-001-alpha-64x64.png` | `GENERATED_CANDIDATE · PASS` |
| `SX-VIS-063-CORE-CARGO-YELLOW-001` | `exec-cdee6143-289f-41fe-979f-c9ce33add219.png` | `baa2ad58f48fa0dbd90aa583f1cc3d20466001f43354439449029d44395481bc` | `SX-VIS-063-CORE-CARGO-YELLOW-001-64x64.png` | `GENERATED_CANDIDATE · PASS` |

### Candidate-only five-pass review

| Loop | Observed result | Current result |
| --- | --- | --- |
| 1 · Consumer boundary | Every candidate maps to one existing `ProductBoardRenderer` slot. No board, UI, sheet, terrain, scene, or new consumer has been introduced. | `PASS` |
| 2 · Rule and geometry attack | All three stations are off-track and contain no rail or service-ring image. Straight and crossing rail intent reads correctly. Curve and switch exits are not mathematically exact in the source image alone, so the user approved a narrow visual-only underlay copied from the already-authored ports. | `PASS_WITH_APPROVED_VISUAL_SEAM_UNDERLAY` |
| 3 · Target-footprint readability | The selected locomotive is recognizable at 128×96; station roofs, star cargo colors, and start/end silhouettes remain distinct at 64×64. The approved underlay closes curve/switch port seams while the generated rail sprites remain the visible art. | `PASS_WITH_APPROVED_VISUAL_SEAM_UNDERLAY` |
| 4 · Provenance and embedded-content attack | The common prompt prohibited third-party art, reference-layout copying, text, logos, watermarks, UI, and frames. Visual review found none. Three candidates with opaque background corners were image-model edited to transparent alpha and rechecked; the selected final candidates have transparent corners. | `PASS_FOR_CANDIDATE_REVIEW · RELEASE_RIGHTS_NOT_APPROVED` |
| 5 · Scope and evidence attack | Promotion changed only the existing fourteen renderer paths, generated v02 assets, their provenance/manifest, and matching contracts. It did not change gameplay rules, input, map/data, service, routing, locks, protected PRs, package candidate, or physical/device/audio/human evidence. | `PASS_FOR_APPROVED_IMPLEMENTATION_SCOPE` |

### User disposition and implementation receipt

The 2026-08-30 message **“승인”** accepted the displayed 13-image bundle and the recommended narrow procedural seam-underlay strategy. The final deterministic Godot reductions are now in the listed `art/product_assets/ed_hybrid_v2/core/` paths, with their exact hashes in `art/product_assets/ed_hybrid_v2/manifest.json` and `docs/ASSET_RIGHTS_AND_PROVENANCE_RECORD.md`.

`ProductBoardRenderer` now switches only its existing fourteen visual slots to v02. For `CURVE` and `SWITCH` only, it draws a muted rail-bed/metal underlay from the same authored port directions immediately below the texture. This corrects visual adjacency without adding an input area, changing track graph data, route selection, station service, train behavior, or lock semantics.

Automated runtime verification on 2026-08-30 passed the full Godot runner (`112` cases, `13,534` assertions) and confirms that all fourteen v02 slots load as `Texture2D`. A local isolated-branch Windows debug export plus Windows/Android PCK proof parsed the v02 manifest and passed PCK integrity; it is not a GitHub exact-head candidate. Hosted Windows CI, physical Windows/audio, Android device, human/player-experience, and release-rights evidence remain `NOT_RUN`.
