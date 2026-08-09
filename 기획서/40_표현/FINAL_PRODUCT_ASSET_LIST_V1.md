# Final Product Asset List V1

Decision: `SX-DEC-053`  
Direction: `E+D HYBRID · NEO-ARCADE READABILITY`  
Status: `DISPOSITION_31_COMPLETE · FIRST_PRODUCT_ASSET_BATCH_PARTIAL · 23_PROMOTED · RUNTIME_NOT_INTEGRATED`

## Production hierarchy

- Blue locomotive = hero anchor.
- Red/blue/yellow trailing cargo wagons = `0.74` visual scale in current v02 product assets.
- Domain collision/route geometry is unchanged.
- Color semantics always retain shape/marker redundancy.
- No localized copy is baked into reusable PNGs.

## Promotion summary

| Group | Current product status | Notes |
|---|---|---|
| locomotive | REVISION_PENDING | source PNG IDAT corrupt; preserve approved design, create import-safe revision later |
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
| controls 7 states | REVISION_PENDING | source atlas PNG stream corrupt; no broken product promotion |
| VFX atlas | PENDING_REVISION | source healthy; causal role split still needed |
| success / failure shells | PROMOTED | text-safe exact sources |
| progress/meta | PROMOTED | text-safe exact source |

## Counts

- SX-DEC-051 source candidates: **31**
- dispositions complete: **31 / 31**
- `PROMOTE_AS_IS`: **18**
- `PROMOTE_AFTER_REVISION`: **13**
- `REPLACE`: **0**
- product PNGs currently manifested: **23**
- corrupt source candidates detected by deep PNG health scan: **2** (`locomotive`, `controls atlas`)

## Product root

`art/product_assets/ed_hybrid_v1/`

Manifest:

`art/product_assets/ed_hybrid_v1/manifest.json`

The manifest is authoritative for actual promoted PNGs. Files that remain pending do not count as product assets merely because a candidate exists.

## Acceptance / next batch

Before later runtime integration:

1. create an import-safe locomotive revision without changing the approved hero silhouette;
2. replace/re-encode the corrupt controls source and recover all seven reusable control states;
3. complete stack-HUD states, especially next-unload-group readability;
4. reconcile the train cargo strip with the smaller-wagon rule;
5. only name/split load states after their semantics are authoritative;
6. complete BUILD and VFX state separation;
7. keep all later Scene/Resource/Theme/Animation/signal/runtime/device/human gates separate.
