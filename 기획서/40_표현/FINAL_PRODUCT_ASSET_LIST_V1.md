# Final Product Asset List V1

Decision: `SX-DEC-053`  
Direction: `E+D HYBRID · NEO-ARCADE READABILITY`  
Status: `DISPOSITION_31_COMPLETE · 39_IMPORT_SAFE_PRODUCT_PNGS · AUTHORITATIVE_SLICE_BATCH_1_PROMOTED · HERO_CONTROLS_RECOVERED · SEMANTIC_SPLITS_PARTIAL · RUNTIME_NOT_INTEGRATED`

## Production hierarchy

- Blue locomotive = hero anchor.
- Red/blue/yellow trailing cargo wagons = `0.74` visual scale in current v02 product assets.
- Domain collision/route geometry is unchanged.
- Color semantics always retain shape/marker redundancy.
- No localized copy is baked into reusable PNGs.

## Promotion summary

| Group | Current product status | Notes |
|---|---|---|
| locomotive | RECOVERED / PRODUCT | import-safe hero recovered from exact approved E+D reference; corrupt candidate preserved as provenance |
| 3 cargo wagons | PROMOTED v02 | centered deterministic 0.74 scale |
| 3 cargo stars | PROMOTED | exact candidate bytes |
| 3 stations | PROMOTED | exact candidate bytes |
| 4 committed rails | PROMOTED | exact candidate bytes |
| start / route-end marker | PROMOTED | exact candidate bytes |
| switch left-selected / locked | PROMOTED | exact documented atlas crops |
| stack HUD | PARTIAL_PRODUCT | four candidate-manifest-authoritative slices promoted: `empty`, `32plus`, `unloading`, `top_highlight`; full semantic coverage including distinct predicted next-unload-group remains pending |
| train cargo strip | PENDING_REVISION | smaller-wagon composite reconciliation needed |
| load mode | PENDING_REVISION | component authority defines required runtime states, but this source atlas still lacks authoritative slice mapping; no crop meaning guessed |
| combo static | PROMOTED | Reduced Motion-compatible exact source |
| BUILD placement preview | PARTIAL_PRODUCT | four candidate-manifest-authoritative slices promoted: straight valid/invalid ghost, curve valid ghost, left port marker; rotate/replacement/placed and broader state coverage remain pending |
| BUILD track palette / preflight | PENDING_REVISION | complete product state split still needed |
| ghost route | PROMOTED | exact source |
| cost HUD | PROMOTED | exact source |
| controls 7 states | RECOVERED / PRODUCT | normal/hover/pressed/selected/disabled/locked/focus recovered from exact approved E+D UI reference; corrupt atlas preserved |
| VFX atlas | PENDING_REVISION | source healthy; causal role split still needed |
| success / failure shells | PROMOTED | text-safe exact sources |
| progress/meta | PROMOTED | text-safe exact source |

## Authoritative slice batch 1

This batch is deliberately narrower than the full semantic-split backlog. It promotes only slices whose names **and crop bounds were already recorded in the immutable `SX-DEC-051` candidate manifest**.

RUN / Stack HUD:

- `run_stack_empty_v01.png` ← `[70,74,44,18]`;
- `run_stack_32plus_v01.png` ← `[70,16,42,18]`;
- `run_stack_unloading_v01.png` ← `[69,44,45,18]`;
- `run_stack_top_highlight_v01.png` ← `[10,8,42,25]`.

BUILD / Placement preview:

- `build_track_straight_valid_ghost_v01.png` ← `[4,4,36,30]`;
- `build_track_straight_invalid_ghost_v01.png` ← `[46,4,36,30]`;
- `build_track_curve_valid_ghost_v01.png` ← `[88,4,36,30]`;
- `build_port_marker_left_v01.png` ← `[6,53,30,26]`.

No unnamed region of an atlas is promoted in this batch. In particular, `run_stack_unloading_v01` is kept under its source-authoritative name and is **not** relabeled as the distinct predicted next-unload-group state without stronger authority.

## Counts

- SX-DEC-051 source candidates: **31**
- dispositions complete: **31 / 31**
- `PROMOTE_AS_IS`: **18**
- `PROMOTE_AFTER_REVISION`: **11**
- `REPLACE`: **2**
- product PNGs currently manifested: **39**
- authoritative slice batch 1: **8** product PNGs
- corrupt source candidates detected by deep PNG health scan: **2** (`locomotive`, `controls atlas`)
- corrupt source candidates overwritten: **0**

## Product root

`art/product_assets/ed_hybrid_v1/`

Manifest:

`art/product_assets/ed_hybrid_v1/manifest.json`

The manifest is authoritative for actual promoted PNGs. `REPLACE` records explicitly retain the corrupt source-candidate path/blob plus the exact approved-reference recovery provenance. The new batch records `authoritative_slice_name` so validation can bind each crop back to the exact named slice and bounds in `SX-DEC-051`.

## Remaining asset work before later runtime integration

1. complete Stack HUD semantics not proven by the four named source slices, especially distinct predicted next-unload-group readability plus compact/intermediate/paused coverage;
2. complete remaining selected switch directions only from authoritative semantics;
3. reconcile the train cargo strip with the smaller-wagon rule;
4. map/split load-mode atlas regions only after their source meaning is authoritative, while preserving the already approved component states (`manual-idle`, `manual-held`, `auto-off`, `auto-on`, `paused-disabled`, `input-received`);
5. complete remaining BUILD placement states plus track-palette and preflight separation;
6. complete VFX causal state separation and Reduced Motion equivalents;
7. keep all later Scene/Resource/Theme/Animation/signal/runtime/device/human gates separate.
