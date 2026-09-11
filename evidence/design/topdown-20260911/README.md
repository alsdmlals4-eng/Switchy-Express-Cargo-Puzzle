# Strict top-down visual correction - representative candidates

User instruction: everything should be seen from a top view; mixed perspectives feel inconsistent.
Source baseline: 4107517b9fc30eda1458e3bd5a85831482f353de. Core rules unchanged.
Work mode: approved-contract continuation after user "좋아 그렇게 통일해".
The exact representative blue pair is pixel-approved; other new pixels remain review candidates.

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
Blue pair status: USER_APPROVED_CANON_REGISTERED_IMPLEMENTED; exact approved bytes preserved in
art/product_assets/topdown_v1/. Runtime and regression receipts are separately recorded below.
Other eleven sprites: REVIEWED_USER_DISPOSITION_PENDING. Metadata, prompts and exact hashes:
candidates.json. No packed atlas is claimed; these are single-frame sources.

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

## Approved pair implementation and remaining candidate batch

Blue consumers use the approved roof/lid without pixel editing or transparent-padding enlargement.
Pickup now moves/fades the same overhead lid (0.24 seconds), instead of selecting oblique frames.
The existing cargo marker scale 0.62, cell/service coordinates and core remain unchanged.
Restricted Aseprite readback: both sources import as one 1254-square frame; pixel (0,0) alpha=0.
Static PNG + Godot position/opacity was selected; a fabricated duplicate-frame atlas was rejected.

New review candidates: red/yellow roof stations, disposal yard, red/yellow/waste lids, forest crowns,
moss boulders, timber, waterway and lantern fence. All eleven have real RGBA alpha 0..255.
Waste and lantern initial outputs retained side faces and were replaced before selection.
See candidates.json for exact selected bytes and rejected source identities.
The eleven new candidates await the user's batch disposition; none is silently promoted.

Research reused prior top-view/rail comparison and fresh-read official Aseprite sprite-sheet and
Godot CanvasItem documentation (https://docs.godotengine.org/en/stable/classes/class_canvasitem.html).
ADOPT source-texture motion: preserves pixel identity and avoids cross-frame camera drift.
ADAPT Aseprite for single-frame/alpha inspection; packed frames only when artwork actually changes.
REJECT retaining the oblique lift, and REJECT generating redundant identical animation frames.
Base main 2f93e872d9ed4fa18018ac759b01acd7d34e9b58 observed; compatibility pin unchanged.
Project GitHub-only/consumer batch rules override the older shared Notion/one-image default;
this is the explicitly approved top-view family continuation, not unrelated gap-driven generation.

Live source cab1b55: build, four motion samples, success, pause/resume and same-layout Retry/Edit
captured under evidence/runtime/topdown-20260911/. Programmatic signals/manual domain stepping,
not human play testing. Exact captures are not proof of new unimplemented candidate pixels.
New overall scene illustrations are reviewed separately; mismatched station footprints/side-view
props must not enter runtime. Selected slate board, overhead train and connected rail geometry remain.
Current 51-page PDF predates this top-view instruction and is not full-family implementation proof.
Next: finish independent review, obtain new-family disposition, integrate approved remainder,
correct shell scenic/lesson assets, verify actual scale and refresh the derived human PDF.
