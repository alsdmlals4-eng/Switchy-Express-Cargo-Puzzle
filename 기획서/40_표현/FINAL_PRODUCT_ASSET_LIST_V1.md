# Final Product Asset List V1

Decisions: `SX-DEC-053` · `SX-DEC-054`  
Direction: `E+D HYBRID · NEO-ARCADE READABILITY`  
Status: `SX-DEC-053_39_PRODUCT_PNGS · SX-DEC-054_RUN_2A_20_SEMANTIC_PNGS · DISJOINT_MANIFEST_OWNERSHIP · RUNTIME_NOT_INTEGRATED`

## Production hierarchy

- Blue locomotive = hero anchor.
- Red/blue/yellow trailing cargo wagons = `0.74` visual scale in current v02 product assets.
- Domain collision/route geometry is unchanged.
- Color semantics always retain shape/marker redundancy.
- No localized copy is baked into reusable PNGs.
- `SX-DEC-054` semantic completion reuses the existing E+D visual language and approved component-state contracts; it does not open a new art direction.

## Ownership model

The shared product root contains two disjoint owners:

- `art/product_assets/ed_hybrid_v1/manifest.json` → `SX-DEC-053`, exactly **39** product PNGs;
- `art/product_assets/ed_hybrid_v1/semantic_manifest_sx_dec_054.json` → `SX-DEC-054` RUN Batch 2A, exactly **20** semantic PNG primitives.

Current physical product PNG total: **59**.

No path is owned by both manifests. Existing 39 `SX-DEC-053` product files remain the baseline product package; the 20 `SX-DEC-054` files are independently authored semantic primitives/composition inputs, not relabeled hidden slices from ambiguous legacy atlases.

## Promotion summary

| Group | Current product status | Notes |
|---|---|---|
| locomotive | RECOVERED / PRODUCT | import-safe hero recovered from exact approved E+D reference; corrupt candidate preserved as provenance |
| 3 cargo wagons | PROMOTED v02 | centered deterministic 0.74 scale |
| 3 cargo stars | PROMOTED | exact candidate bytes |
| 3 stations | PROMOTED | exact candidate bytes |
| 4 committed rails | PROMOTED | exact candidate bytes |
| start / route-end marker | PROMOTED | exact route marker sources |
| switch direction | BASE + RUN_2A_SEMANTIC | existing left-selected/locked crops remain 053 provenance/product; 054 adds selected/unselected/occupied-locked/inactive state-style overlays and reuses procedural `SX-DEC-042 · SX-DEC-046 · VIS-014` direction authority |
| stack HUD | BASE + RUN_2A_SEMANTIC | 053 retains `empty`, `32plus`, `unloading`, `top_highlight`; 054 adds `compact`, `8plus`, `16plus`, distinct predicted `unload_group`, `paused` |
| train cargo strip | RUN_2A_SEMANTIC | shell / `+N` badge / unload-transition primitives compose empty, 1–3 token, compressed `+N`, unload-transition states with existing cargo tokens and smaller-wagon hierarchy |
| load mode | RUN_2A_SEMANTIC | explicit shell/marker/overlay primitives compose `manual_idle`, `manual_held`, `auto_off`, `auto_on`, `paused_disabled`, `input_received`; old atlas remains reference-only |
| combo static | PROMOTED | Reduced Motion-compatible exact source |
| BUILD placement preview | PARTIAL_PRODUCT | four candidate-manifest-authoritative slices promoted: straight valid/invalid ghost, curve valid ghost, left port marker; rotate/replacement/placed and broader state coverage remain pending |
| BUILD track palette / preflight | PENDING_REVISION | complete product state split still needed |
| ghost route | PROMOTED | exact source |
| cost HUD | PROMOTED | exact source |
| controls 7 states | RECOVERED / PRODUCT | normal/hover/pressed/selected/disabled/locked/focus recovered from exact approved E+D UI reference; corrupt atlas preserved |
| VFX atlas | PENDING_REVISION | source healthy; causal role split still needed |
| success / failure shells | PROMOTED | text-safe exact sources |
| progress/meta | PROMOTED | text-safe exact source |

## SX-DEC-053 authoritative slice batch 1

This batch remains deliberately narrower than semantic completion. It promotes only slices whose names **and crop bounds were already recorded in the immutable `SX-DEC-051` candidate manifest**.

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

No unnamed region of an atlas is promoted in this batch. `run_stack_unloading_v01` remains source-authoritative `unloading` and is not relabeled as the distinct predicted next-unload-group state.

## SX-DEC-054 RUN Batch 2A semantic package

### Stack HUD · 5 physical assets

- `run_stack_compact_v01.png`;
- `run_stack_8plus_v01.png`;
- `run_stack_16plus_v01.png`;
- `run_stack_unload_group_v01.png`;
- `run_stack_paused_v01.png`.

### Train cargo strip · 3 reusable primitives / 4 compositions

- `run_train_cargo_strip_shell_v01.png`;
- `run_train_cargo_strip_plus_badge_v01.png`;
- `run_train_cargo_strip_unload_transition_v01.png`.

Compositions: `empty`, `tokens_1_3`, `compressed_plus_n`, `unload_transition`.

### Load mode · 8 reusable primitives / 6 compositions

- `run_load_mode_shell_v01.png`;
- `run_load_mode_manual_marker_v01.png`;
- `run_load_mode_auto_marker_v01.png`;
- `run_load_mode_held_marker_v01.png`;
- `run_load_mode_off_marker_v01.png`;
- `run_load_mode_on_marker_v01.png`;
- `run_load_mode_disabled_overlay_v01.png`;
- `run_load_mode_input_received_v01.png`.

Compositions: `manual_idle`, `manual_held`, `auto_off`, `auto_on`, `paused_disabled`, `input_received`.

### Switch presentation · 4 reusable overlays / 5 compositions

- `run_switch_state_selected_overlay_v01.png`;
- `run_switch_state_unselected_overlay_v01.png`;
- `run_switch_state_occupied_locked_overlay_v01.png`;
- `run_switch_state_inactive_overlay_v01.png`.

Compositions: `three_visible`, `selected`, `unselected`, `occupied_locked`, `inactive`.

Directional arrow geometry is not duplicated into Batch 2A. The compositions retain `SX-DEC-042 · SX-DEC-046 · VIS-014` as the procedural direction authority.

The legacy train-strip/load-mode/switch atlases remain explicitly `PRESERVE_REFERENCE_ONLY_NO_STATE_MAPPING` and are not used as unnamed pixel/crop authority for the new semantic meanings.

## Counts

- SX-DEC-051 source candidates: **31**
- dispositions complete: **31 / 31**
- `PROMOTE_AS_IS`: **18**
- `PROMOTE_AFTER_REVISION`: **11**
- `REPLACE`: **2**
- SX-DEC-053 product PNG ownership: **39**
- SX-DEC-054 RUN Batch 2A semantic PNG ownership: **20**
- current physical product PNG total: **59**
- SX-DEC-053 authoritative slice batch 1: **8** product PNGs
- corrupt source candidates detected by deep PNG health scan: **2** (`locomotive`, `controls atlas`)
- corrupt source candidates overwritten: **0**

## Product root

`art/product_assets/ed_hybrid_v1/`

Ownership manifests:

- `art/product_assets/ed_hybrid_v1/manifest.json` — `SX-DEC-053` baseline product ownership;
- `art/product_assets/ed_hybrid_v1/semantic_manifest_sx_dec_054.json` — `SX-DEC-054` RUN Batch 2A semantic ownership/compositions.

The validators require disjoint ownership and exact physical-file agreement. `REPLACE` records in the 053 manifest retain corrupt source-candidate provenance plus exact approved-reference recovery provenance. The 054 sidecar records independent semantic derivation and does not claim ambiguous atlas regions as authority.

## Remaining asset work before later runtime integration

1. complete remaining BUILD placement semantics including rotate/replacement plus track-palette interaction split;
2. complete BUILD preflight semantic presentation without inventing gameplay outcomes;
3. complete VFX causal state separation and Reduced Motion information-equivalent presentations;
4. keep all later Scene/Resource/Theme/Animation/signal/runtime/device/human gates separate.

RUN Batch 2A remains `runtime_integrated=false`. Automated/static validation is product-package evidence only; Windows physical runtime, Android device, connected physical editor, and human comprehension/playtest remain `NOT_RUN`.