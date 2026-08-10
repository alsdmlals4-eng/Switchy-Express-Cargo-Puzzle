# Final Product Asset List V1

Decisions: `SX-DEC-053` · `SX-DEC-054`  
Direction: `E+D HYBRID · NEO-ARCADE READABILITY`  
Status: `SX-DEC-053_39_PRODUCT_PNGS · SX-DEC-054_RUN_2A_20_SEMANTIC_PNGS · SX-DEC-054_BUILD_2B_8_SEMANTIC_PNGS · 67_TOTAL_PRODUCT_PNGS · RUN_2A_AND_BUILD_2B_MERGED_MAIN_VERIFIED · VFX_2C_PENDING · RUNTIME_NOT_INTEGRATED`

## Production hierarchy

- Blue locomotive = hero anchor.
- Red/blue/yellow trailing cargo wagons = `0.74` visual scale in current v02 product assets.
- Domain collision/route geometry is unchanged.
- Color semantics always retain shape/marker redundancy.
- No localized copy is baked into reusable PNGs.
- `SX-DEC-054` semantic completion reuses the existing E+D visual language and approved component-state contracts; it does not open a new art direction.

## Ownership model

The shared product root has three pairwise-disjoint owners:

- `art/product_assets/ed_hybrid_v1/manifest.json` → `SX-DEC-053`, exactly **39** product PNGs;
- `art/product_assets/ed_hybrid_v1/semantic_manifest_sx_dec_054.json` → `SX-DEC-054` RUN Batch 2A, exactly **20** semantic PNG primitives;
- `art/product_assets/ed_hybrid_v1/semantic_manifest_sx_dec_054_build_2b.json` → `SX-DEC-054` BUILD Batch 2B, exactly **8** semantic PNG primitives.

Current physical product PNG total: **67**.

The BUILD sidecar preserves the already-verified RUN sidecar without reserialization. Shared ownership validation proves all three sets are unique, pairwise disjoint, and together equal the physical product-root PNG set.

## Promotion summary

| Group | Current product status | Notes |
|---|---|---|
| locomotive | RECOVERED / PRODUCT | import-safe hero recovered from exact approved E+D reference; corrupt candidate preserved as provenance |
| 3 cargo wagons | PROMOTED v02 | centered deterministic 0.74 scale |
| 3 cargo stars | PROMOTED | exact candidate bytes |
| 3 stations | PROMOTED | exact candidate bytes |
| 4 committed rails | PROMOTED | exact candidate bytes; reused as BUILD palette/preview form identity |
| start / route-end marker | PROMOTED | exact route marker sources |
| switch direction | BASE + RUN_2A_SEMANTIC | existing left-selected/locked crops remain 053 provenance/product; 054 adds state-style overlays and keeps procedural direction authority |
| stack HUD | BASE + RUN_2A_SEMANTIC | 053 retains `empty`, `32plus`, `unloading`, `top_highlight`; 054 adds `compact`, `8plus`, `16plus`, distinct `unload_group`, `paused` |
| train cargo strip | RUN_2A_SEMANTIC | 3 primitives compose empty, 1–3 token, compressed `+N`, unload-transition states |
| load mode | RUN_2A_SEMANTIC | 8 primitives compose `manual_idle`, `manual_held`, `auto_off`, `auto_on`, `paused_disabled`, `input_received` |
| combo static | PROMOTED | Reduced Motion-compatible exact source |
| BUILD placement preview | BASE + BUILD_2B_SEMANTIC | 053 retains four exact named crops; 054 BUILD adds valid/invalid/rotate/replacement overlays without unnamed atlas mapping |
| BUILD track palette | BUILD_2B_COMPOSITION | 4 forms × 5 interaction states = 20 compositions using existing committed rails + UI frames; **0** new form×interaction PNGs |
| BUILD preflight | BUILD_2B_SEMANTIC | neutral shell + issue/focus markers compose the approved four presentation states |
| ghost route | PROMOTED | exact source |
| cost HUD | PROMOTED | exact source |
| controls 7 states | RECOVERED / PRODUCT | normal/hover/pressed/selected/disabled/locked/focus recovered from exact approved E+D UI reference |
| VFX atlas | PENDING_REVISION | causal role split remains VFX Batch 2C |
| success / failure shells | PROMOTED | text-safe exact sources |
| progress/meta | PROMOTED | text-safe exact source |

## SX-DEC-053 authoritative slice batch 1

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

No unnamed region of an atlas is promoted or assigned a new semantic name.

## SX-DEC-054 RUN Batch 2A

Physical semantic assets: **20**.

Coverage:
- Stack HUD: 5 new primitives;
- train cargo strip: 3 primitives / 4 compositions;
- load mode: 8 primitives / 6 compositions;
- switch presentation: 4 overlays / 5 compositions.

Directional switch geometry remains under `SX-DEC-042 · SX-DEC-046 · VIS-014`. Ambiguous historical RUN atlases remain reference-only/no-state-mapping.

Product PR #129:
- exact head `34ab2b907190f69775ace8e89c32f689ba17bc35`;
- merge/main `35b93f3a15f35780b12cd4e8887c8e06f8ade72b`;
- exact-head Contract/GUT/Godot/Thin/Windows: PASS.

## SX-DEC-054 BUILD Batch 2B

### Placement preview · 4 physical overlays / 4 compositions

- `build_placement_valid_overlay_v01.png`;
- `build_placement_invalid_overlay_v01.png`;
- `build_placement_rotate_preview_overlay_v01.png`;
- `build_placement_replacement_preview_overlay_v01.png`.

Each composition is `preview_only` and accepts the four committed core rail products as form authority.

### Track palette · 0 new form×interaction PNGs / 20 compositions

Forms: straight, curve, switch, crossing.

Interaction reuse:
- idle → existing normal UI frame;
- selected → existing selected UI frame;
- unavailable → existing disabled UI frame;
- keyboard-focus → existing focus UI frame;
- touch-pressed → existing pressed UI frame.

The semantic matrix is exactly 4 × 5 = **20** composition records. `build_track_palette_v01.png` remains `PRESERVE_REFERENCE_ONLY_NO_STATE_MAPPING`.

### Preflight · 4 physical primitives / 4 compositions

- `build_preflight_shell_v01.png`;
- `build_preflight_primary_issue_marker_v01.png`;
- `build_preflight_multi_issue_marker_v01.png`;
- `build_preflight_focused_location_marker_v01.png`.

States: `clear`, `primary_issue`, `multi_issue_summary`, `focused_location`.

No ready/warning/blocking gameplay outcome is created, and optional-target/leaderboard misses are not represented as general run failure.

Product PR #131:
- baseline `fb229b2ef522fb29c70f43787549fb2e20bf89b0`;
- exact head `6efe4c71e88799f886f136c98d0c4a4396e58808`;
- merge/main `77276ec9b60aa91afd13f994ded8e0925e68be08`;
- Project Contract `31343802460`: PASS;
- GUT `31343802437`: PASS;
- Godot `31343802472`: PASS;
- Thin `31343802445`: PASS;
- Windows Demo Export `31343802461`: PASS packaging only;
- review threads 0;
- behind 0 / mergeable true.

## Counts

- SX-DEC-051 source candidates: **31**
- dispositions complete: **31 / 31**
- `PROMOTE_AS_IS`: **18**
- `PROMOTE_AFTER_REVISION`: **11**
- `REPLACE`: **2**
- SX-DEC-053 product PNG ownership: **39**
- SX-DEC-054 RUN Batch 2A semantic PNG ownership: **20**
- SX-DEC-054 BUILD Batch 2B semantic PNG ownership: **8**
- current physical product PNG total: **67**
- BUILD Batch 2B semantic compositions: **28** = placement 4 + palette 20 + preflight 4
- BUILD palette new form×interaction physical PNG count: **0**
- SX-DEC-053 authoritative slice batch 1: **8** product PNGs
- corrupt source candidates detected by deep PNG health scan: **2** (`locomotive`, `controls atlas`)
- corrupt source candidates overwritten: **0**

## Remaining asset work before later runtime integration

1. VFX Batch 2C: cargo pickup/unload, combo, route selection, success/failure, `ROUTE_END`, `TIME_EXPIRED`;
2. Reduced Motion information-equivalent presentation for every meaning-bearing VFX event;
3. later Scene/Resource/Theme/Animation/signal/runtime/device/human gates remain separate.

RUN Batch 2A and BUILD Batch 2B are merged-main verified. All semantic packages remain `runtime_integrated=false`; Windows physical runtime, Android device, connected physical editor, and human comprehension/playtest remain `NOT_RUN`.