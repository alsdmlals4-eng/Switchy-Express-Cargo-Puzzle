# Strict top-down visual correction - representative candidates

User instruction: everything should be seen from a top view; mixed perspectives feel inconsistent.
Source baseline: 4107517b9fc30eda1458e3bd5a85831482f353de. Core rules unchanged.
Work mode: bounded visual-direction correction; candidate review, NOT runtime replacement.

## Common view contract

- Exactly vertical 90-degree orthographic/nadir camera; no isometric/three-quarter elevation.
- Stations show roof footprints, cargo shows top lids, train shows its top, trees show crowns.
- Shared restrained upper-left lighting, short shadows, navy/ivory/brass material family.
- Station/cargo IDs remain redundant color + star/diamond/triangle/waste glyph + live UI text.
  Put glyphs flat on top surfaces, never add front-facing signboards to recover visibility.
- No visible facade, long wall face, horizon, foreshortened footprint or camera tilt in motion.
- Preserve current graph/cell/service coordinates; changing art is not a map/semantic migration.
- Caution/speed effects remain on the board plane. Load motion must preserve overhead orientation.
- Apply to all world-object depictions, including shell scenic art. Plain text/buttons remain flat UI.

## Existing consumers and dispositions

| Family | Consumer | Required action |
|---|---|---|
| Terrain | ProductBoardRenderer board_terrain | Keep selected slate pixels; flat board |
| Train / four rail slots | ProductBoardRenderer PRODUCT_VISUAL_ASSET_PATHS | Verify overhead geometry/joins before reuse; no automatic reslice |
| Four stations | station_red/blue/yellow/disposal | Replace facade/elevation art with roof or yard plans |
| Four cargo types | cargo_red/blue/yellow/waste | Replace oblique bodies with lid/open-bin top views |
| Five decorations | forest_cluster/moss_boulder/timber_stack/waterway/lantern_fence | Audit and replace visible side-view silhouettes |
| Pickup motion | CARGO_LIFT_TEXTURE / CargoPickupAnimation | Retire oblique lift frames after top-view replacement is approved |
| Main/result scenic images | Existing ProductShellArt consumers | Plan top-down compositions; retain title identity and real UI text |

## Generated candidates

Both images generated with built-in image model; no local background-removal or pixel painting.
Both measured RGBA 1254x1254, alpha extrema 0..255. Visual view inspection: top faces only.
Status: GENERATED_CANDIDATE, GEOMETRY_VISUALLY_REVIEWED, ALPHA_PRESENT; USER_PIXEL_APPROVAL_PENDING.
Not a packed atlas, not Aseprite frame evidence, not runtime readability or implementation proof.

| File | Source generation | SHA-256 |
|---|---|---|
| station-blue-candidate.png | exec-330a438c-7234-4876-800a-890753a73f88.png | 4837c23361147da72bae9f88c5c15372f57ef0fa8e804b48c0297bdb2cc50a6e |
| cargo-blue-candidate.png | exec-5ac01286-b719-4077-9212-04ac770d1ece.png | 58ed699689e88f0f8f3cdd14cd20f28611ea235e049a5182bef087fd09df2360 |

Generation briefs: strict 90-degree orthographic isolated navy/brass miniature. Station: rectangular
hipped slate roof, horizontal brass ridge, chimney top opening only, flat ivory/blue rooftop diamond,
no facades/doors/windows. Cargo: square navy wood lid, brass corner caps, flat ivory diamond,
no side face. Both: genuine transparent background, no checkerboard/ground/text, common upper-left light.

Earlier two station edit outputs were rejected: first retained a front-facing gable; correction
removed the gable but remained RGB with baked checkerboard. Neither entered runtime or this folder.
Fresh generation passed alpha inspection; this does not prove all future generations will.

Research: ADAPT Aseprite explicit frame offsets/padding for future motion packing
(https://www.aseprite.org/docs/sprite-sheet/); ADOPT joined-geometry rail validation from Factorio
(https://www.factorio.com/blog/post/fff-377), REJECT copying its directions/topology or using
appearance alone as connectivity proof. Existing material colors reused; oblique geometry rejected.

Next: user pixel disposition of representative family, other types/decorations, overhead motion
packing/pivot verification, consumer integration, full regression/live scale review, derived PDF refresh.
Existing approved runtime assets remain in place until those gates. Current 51-page PDF predates
this top-view instruction and is not evidence of the new full-family direction being implemented.
