# Human blueprint preparation evidence — 2026-09-11

Status: INTERMEDIATE_REVIEW_NOT_IMPLEMENTATION_READY. Do not request final implementation
approval from this intermediate publication. Runtime and PR merge remain held.

`publication.json` binds the Korean editorial companion, generated PDF, actual runtime/source
images and existing map bytes. This receipt is not a runtime or human acceptance result.

`object-family.png` is a REJECTED_PRODUCTION_CANDIDATE: RGB 1536x1024, no alpha channel.
The apparent checkerboard is baked into the pixels. It must not be registered as game-ready.
Generated from the approved blue-station visual reference, not the Ten Paces PDF artwork.
Image model attempts: initial six-object family clipped at borders; spacing correction added
baked checkerboard; background-extraction retry retained RGB checkerboard. No background
removal is claimed. Restricted Aseprite batch tools cannot remove this background; exporting
to RGBA alone would not fix it. Originals remain in the image tool's local generated-image folder.

Retained last attempt: exec-9f85bb33-024c-42a5-ae6a-5b716d3fb70d.png. No runtime consumer changed.
Prompt intent: red-star/yellow-triangle depots, charcoal disposal depot, corresponding crates,
consistent miniature brass/cream family, separated six objects and true transparency.

Fresh primary references: Aseprite CLI docs for PNG/JSON frames/padding;
Godot AtlasTexture docs for region/filter_clip; Factorio FFF-377 for rail geometry/art coupling.
These do not prove our rail master meets edge-center ports.

Review passes actually performed:
1. Authority: new image permission supersedes old hold; implementation remains held.
2. Semantics: pickup before unload; YELLOW_TRIANGLE and WASTE_CRATE must be exhaustive.
3. Assets: failed alpha exposed, no candidate-to-runtime promotion.
4. Scope/provenance: example structure only; existing approved/historical sources preserved.
5. Evidence: current captures versus target wireframes versus candidates labelled separately;
   rail geometry and complete preparation not inflated to PASS.

PDF validation: 44/44 pages rendered with Poppler; 44/44 inspected in the host image viewer.
Korean font, tables, images and captions remain within page bounds. Two Chinese wireframe
title words were corrected to Korean and those pages re-rendered/reviewed. All pages contain
extractable text; PDF and all image/map source hashes match publication.json. This is bounded
document render/readability evidence, not complete blueprint coverage or implementation readiness.
The large text-native wireframes still need detailed component/state annotation, and the atlas
still lacks final target main/select/pause compositions. Those remain open content findings.
