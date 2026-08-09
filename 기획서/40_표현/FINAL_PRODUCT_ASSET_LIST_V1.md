# Final Product Asset List V1

Decision: `SX-DEC-053`  
Direction: `E+D HYBRID · NEO-ARCADE READABILITY`  
Status: `DISPOSITION_31_COMPLETE · 31_IMPORT_SAFE_PRODUCT_PNGS · HERO_CONTROLS_RECOVERED · RUNTIME_NOT_INTEGRATED`

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
| stack HUD | PENDING_REVISION | source healthy; complete semantic split still needed |
| train cargo strip | PENDING_REVISION | smaller-wagon composite reconciliation needed |
| load mode | PENDING_REVISION | source healthy; on/off semantic naming not guessed |
| combo static | PROMOTED | Reduced Motion-compatible exact source |
| BUILD placement / palette / preflight | PENDING_REVISION | complete product state split still needed |
| ghost route | PROMOTED | exact source |
| cost HUD | PROMOTED | exact source |
| controls 7 states | RECOVERED / PRODUCT | normal/hover/pressed/selected/disabled/locked/focus recovered from exact approved E+D UI reference; corrupt atlas preserved |
| VFX atlas | PENDING_REVISION | source healthy; causal role split still needed |
| success / failure shells | PROMOTED | text-safe exact sources |
| progress/meta | PROMOTED | text-safe exact source |

## Counts

- SX-DEC-051 source candidates: **31**
- dispositions complete: **31 / 31**
- `PROMOTE_AS_IS`: **18**
- `PROMOTE_AFTER_REVISION`: **11**
- `REPLACE`: **2**
- product PNGs currently manifested: **31**
- corrupt source candidates detected by deep PNG health scan: **2** (`locomotive`, `controls atlas`)
- corrupt source candidates overwritten: **0**

## Product root

`art/product_assets/ed_hybrid_v1/`

Manifest:

`art/product_assets/ed_hybrid_v1/manifest.json`

The manifest is authoritative for actual promoted PNGs. `REPLACE` records explicitly retain the corrupt source-candidate path/blob plus the exact approved-reference recovery provenance.

## Remaining asset work before later runtime integration

1. complete stack-HUD states, especially next-unload-group readability;
2. complete remaining selected switch directions only from authoritative semantics;
3. reconcile the train cargo strip with the smaller-wagon rule;
4. only name/split load states after their semantics are authoritative;
5. complete BUILD placement/palette/preflight state separation;
6. complete VFX causal state separation and Reduced Motion equivalents;
7. keep all later Scene/Resource/Theme/Animation/signal/runtime/device/human gates separate.
