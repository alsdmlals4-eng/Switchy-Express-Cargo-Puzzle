# SX-DEC-069 · Transparent Wayside Cutouts and Speed-Transition Presentation

**Status:** `USER_APPROVED · MERGED_MAIN_VERIFIED · PR_276 · REMOTE_CI_7_GREEN · SX60-POC-ACCEPT-010_PREPARED_PACKAGE_VERIFIED · FINAL_USER_REVIEW_NOT_RUN`
**Date:** 2026-09-01 KST
**Approval source:** The user approved the existing title screen, directed that the Route Book 02 wayside images must have transparent object-only backgrounds rather than embedded terrain, and directed a distinct visual treatment for caution entry and normal-speed recovery.

## Decision

Keep the approved main-title wordmark and the finite-delivery rules unchanged. Replace only the eight Route Book 02 runtime-connected image candidates whose generated pixels contained a ground/terrain presentation, then add renderer-local feedback that distinguishes entering a caution segment from leaving it.

```text
existing board terrain remains the sole terrain layer
→ v02 wayside/cargo/disposal assets render as transparent named-object cutouts
→ normal → caution: amber inward brake bars
→ caution → normal: cyan forward speed streaks
→ caution → caution: no repeated transition cue
```

## Fixed boundary

```yaml
title_screen_and_wordmark: UNCHANGED · SX-TITLE-WORDMARK-001 remains canonical
replaced_runtime_slots: 8
new_gameplay_rules: 0
map_schema_and_route_book_stage_ids: UNCHANGED
caution_speed_multiplier: 0.55 · UNCHANGED
speed_authority: existing FiniteRunController only
presentation_authority: ProductBoardRenderer snapshot delta only
reduced_motion: static, bounded equivalent; no continuous visual motion
v01_candidates: RETAINED_HISTORICAL_PROVENANCE · SUPERSEDED_BY_V02_CANDIDATES
v02_candidate_pixel_status: USER_REVIEW_PENDING · NOT_CANON
```

The renderer never writes run speed, route state, map state, cargo state, or save state. It compares the previous and next render snapshots: an entry into a caution cell produces `DECELERATE`; a departure from a caution cell to a normal cell produces `ACCELERATE`; consecutive caution cells produce no repeat. The feedback layer draws below the train.

## Image and consumer record

The eight v02 files are genuine RGBA cutouts with transparent corners and less than 75% nontransparent coverage. Their SHA-256 values, OpenAI generation receipts, dimensions, exact `ProductBoardRenderer::PRODUCT_VISUAL_ASSET_PATHS[...]` consumer slots, and pending pixel-review state are in `art/product_assets/ed_hybrid_v2/manifest.json` and `docs/ASSET_RIGHTS_AND_PROVENANCE_RECORD.md`.

The scene renderer remains the only production consumer. This preserves the player-readable global board terrain while preventing a second mini-terrain rectangle from appearing beneath a tree, boulder, timber stack, waterway, lantern fence, caution signal, waste crate, or disposal yard.

## Local verification readback

```yaml
godot_import: PASS · Godot 4.7.1 imported all 8 v02 PNGs as project textures
transparent_asset_contract: PASS · 1 test / 8 exact candidate entries
godot_full_regression: PASS · 120 cases · 14,133 assertions · 0 failed
route_book_02_runtime_navigation: PASS · title → Stage Book → Route Book 02 → RB08 build board
runtime_readback: PASS · local Hera RB08 build-board observation; no new tracked screenshot artifact
runtime_log_diagnostics: PASS · 0 errors · 0 warnings at observed build state
```

The local runtime readback proves that the v02 objects are connected on the actual RB08 board and do not draw a rectangular terrain background. Automated renderer diagnostics prove the entry/recovery distinction, non-repetition across contiguous caution cells, renderer-local playback ownership, and draw order below the train. The short 0.28-second in-motion cue was not frame-captured, so its visual appearance is not elevated beyond automated renderer coverage. This does not constitute a physical-device result, user pixel approval, audio-perceptual result, accessibility result, release approval, or package/export verification.

## Five focused adversarial review loops

| Review focus | Finding | Resolution |
| --- | --- | --- |
| Consumer/path mismatch | A replacement could leave one v01 image selected. | The contract enumerates all eight slots, hashes each v02 path, and the renderer test asserts each exact path. **PASS** |
| False transparency / background halo | A PNG can report alpha yet retain a full-frame terrain composition. | The asset test checks RGBA mode, four transparent corners, and coverage below 75%; local RB08 runtime readback confirms object-only placement. **PASS** |
| Board readability | The cue or cutout could obscure a cargo/station or draw above the train. | Candidate assets remain below grid/route/markers; transition layer is explicitly below train. **PASS** |
| Repeated or motion-heavy feedback | Contiguous caution cells could flash repeatedly or reduced-motion could keep animating. | Transition fires only on boundary crossing; reduced-motion uses one static bounded cue. **PASS** |
| Evidence inflation | Local import/test/capture could be misreported as human or release validation. | Candidate, machine, runtime, user-pixel, physical, audio, device, and release states remain separate. **PASS_WITH_BOUNDARY_RETAINED** |

## Candidate and next gate

`SX60-POC-ACCEPT-009` is valid immutable evidence only for its exact pre-SX-DEC-069 source bytes. `SX60-POC-ACCEPT-010` now binds exact merged `main@79323ff0175b674c594d18dfd6d28a8e9951f5bd`: Windows Demo Export run `33415291733`, artifact `9766817524`, API/download ZIP digest `e90e735e6f3571e6e10e075759983021bec006d5636f8f292a5437775a2beefc`, Windows PCK digest `e326a7fab45e939d912d1c4ceed37e9cd959eed769530e8972b39c8a1c3468d3`, runtime JSON proofs, and an independent 591-entry PCK audit all passed. Candidate 010 is the only exact candidate eligible for a later final user review of the changed bytes; the v02 pixels remain `USER_PIXEL_REVIEW_PENDING`.

## Owners

- Runtime renderer: `game/demo/presentation/product_board_renderer.gd`
- Reduced-motion forwarding: `game/demo/product_finite_slice.gd`
- Candidate registry: `art/product_assets/ed_hybrid_v2/manifest.json`
- Asset provenance: `docs/ASSET_RIGHTS_AND_PROVENANCE_RECORD.md`
- Automated coverage: `tests/demo/test_product_board_renderer.gd`, `tests/python/test_sx_dec_069_transparent_wayside_assets.py`
- User-facing Route Book 02 rules: `docs/decisions/SX_DEC_067_WAYSIDE_HAZARDS_SALVAGE_AND_ROUTE_BOOK_02.md`
