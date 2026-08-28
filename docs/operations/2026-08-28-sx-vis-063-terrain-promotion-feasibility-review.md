# SX-VIS-063 terrain v02 promotion · feasibility and adversarial review

**Status:** `PASS_FOR_GITHUB_ASSET_PROMOTION_ONLY · RUNTIME_NOT_CONNECTED`

## Fresh evidence

- Project completed main: `9c3be67cf99221d5007f0332be6935e81a6954bb`.
- Base latest completed main read: `af870522d15abf391a0b13553de690514ac8579a`.
- Open/draft PR read: only Draft PR #174; untouched.
- Current actual consumer: `ProductBoardRenderer::PRODUCT_VISUAL_ASSET_PATHS[board_terrain]`, loaded as `Texture2D` and drawn by `CanvasItem.draw_texture_rect()` before live grid/rail/station/cargo/route/train layers.
- Candidate: PNG, RGB, 1672×941, 2,672,198 bytes, SHA-256 `1b8cdeda06a940e70bf462e0e59b71e4130eeb1b266f606d7cd484ab5d145d0d`; PNG chunk scan contains no text chunk; central 70% mean RGB is `(156.71, 126.55, 41.19)`.
- Godot 4.7.1 `--headless --import` completed with exit `0`, producing the tracked v02 `CompressedTexture2D` import descriptor and local `.ctex` cache. A subsequent headless suite completed with exit `0`: `112` cases, `13,512` assertions, `0` failures. This proves source import and current-regression feasibility only; the renderer still points to v01.
- Project operating-contract validation passes after correcting three stale evidence hashes and regenerating its exact generated views using the CI-pinned Base contract snapshot `2828a74f60c1ed09546171040f4178c8848ea686`.

## Official implementation research

| Question | Current primary evidence | Disposition |
| --- | --- | --- |
| Can the current renderer display this source? | [Godot CanvasItem `draw_texture_rect`](https://docs.godotengine.org/en/stable/classes/class_canvasitem.html) takes a `Texture2D` and the current renderer already retains the loaded texture. | `ADOPT`: preserve the same one-texture backdrop path. |
| Is PNG suitable for the target import? | [Godot image import documentation](https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_images.html) supports 8-bit PNG and defaults to an imported `Texture2D`; this 1672×941 image is below the documented 4096 mobile size-limit example and 16384 texture maximum. | `ADOPT`: RGB opaque terrain is compatible; no alpha transformation. |
| Can ownership be claimed without further caveat? | [OpenAI service terms](https://openai.com/policies/terms-of-use/) state output ownership only as permitted by law and do not remove third-party-rights obligations. | `ADAPT`: record conditional rights; do not claim release clearance. |

## Five adversarial loops

| Loop | Attack | Result / correction |
| --- | --- | --- |
| 1 · consumer/scope | Could the image be a planning board with no real consumer? | Rejected: one exact `ProductBoardRenderer.board_terrain` consumer is read in code. Promotion remains unconnected, preventing a silent runtime change. |
| 2 · import/runtime feasibility | Could opaque RGB or dimensions break Godot import/loading? | Corrected from inference to machine evidence: Godot 4.7.1 headless import completed successfully and produced `CompressedTexture2D`; the full current runner is green. Runtime load is intentionally not claimed until Phase 2 because the renderer remains v01. |
| 3 · visual/readability | Could edge dressing or warm values hide grid/game objects? | Central field is open and text-free; however same-viewport runtime composite is still required before switching the path. No asset-promotion blocker. |
| 4 · rights/provenance | Could a generated candidate be mistaken for cleared shipping art? | Corrected: SHA, generation receipt, user promotion, exact consumer, and conditional rights record are versioned. Release review remains `NOT_RUN`. |
| 5 · evidence/scope | Could promotion be misreported as Godot, human, or batch completion? | Corrected: manifest state is `RUNTIME_NOT_CONNECTED`; v01 remains the runtime asset; only one terrain binary is added. |

## Outcome and next boundary

`SX-BOARD-TERRAIN-002` is eligible to be called `APPROVED_GITHUB_PRESERVED_RUNTIME_NOT_CONNECTED`. It is not yet a runtime, package, physical/audio, Android, human, Player Experience, release-rights, or production-cutover pass. The only next runtime action is the bounded handoff at `기획서/50_제작_검증/SX_DEC_063_TERRAIN_RUNTIME_INTEGRATION_HANDOFF.md`.

## Base promotion decision

`NO_BASE_PROMOTION`: Base already mandates official/primary research, actual evidence, and five-pass adversarial review. This finding depends on Switchy's exact terrain slot and does not provide repeated cross-project evidence for a new Base rule.
