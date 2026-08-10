# Final Product Asset List V1

Decisions: `SX-DEC-053` · `SX-DEC-054`  
Direction: `E+D HYBRID · NEO-ARCADE READABILITY`  
Status: `SX-DEC-053_39_PRODUCT_PNGS · SX-DEC-054_RUN_2A_20_SEMANTIC_PNGS · SX-DEC-054_BUILD_2B_8_SEMANTIC_PNGS · 67_TOTAL_PRODUCT_PNGS · DISJOINT_MANIFEST_OWNERSHIP · RUNTIME_NOT_INTEGRATED`

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

Expected physical product PNG total after BUILD 2B merge: **67**.

The dedicated BUILD sidecar intentionally preserves the already-verified RUN Batch 2A sidecar without reserialization. Shared ownership validation requires all three sets to be unique, pairwise disjoint, and together equal the physical product-root PNG set.

## Promotion summary

| Group | Current product status | Notes |
|---|---|---|
| locomotive | RECOVERED / PRODUCT | import-safe hero recovered from exact approved E+D reference; corrupt candidate preserved as provenance |
| 3 cargo wagons | PROMOTED v02 | centered deterministic 0.74 scale |
| 3 cargo stars | PROMOTED | exact candidate bytes |
| 3 stations | PROMOTED | exact candidate bytes |
| 4 committed rails | PROMOTED | exact candidate bytes; also reused as BUILD palette/preview form identity |
| start / route-end marker | PROMOTED | exact route marker sources |
| switch direction | BASE + RUN_2A_SEMANTIC | existing left-selected/locked crops remain 053 provenance/product; 054 adds selected/unselected/occupied-locked/inactive state-style overlays and reuses procedural direction authority |
| stack HUD | BASE + RUN_2A_SEMANTIC | 053 retains `empty`, `32plus`, `unloading`, `top_highlight`; 054 adds `compact`, `8plus`, `16plus`, distinct predicted `unload_group`, `paused` |
| train cargo strip | RUN_2A_SEMANTIC | shell / `+N` badge / unload-transition primitives compose empty, 1–3 token, compressed `+N`, unload-transition states |
| load mode | RUN_2A_SEMANTIC | shell/marker/overlay primitives compose `manual_idle`, `manual_held`, `auto_off`, `auto_on`, `paused_disabled`, `input_received` |
| combo static | PROMOTED | Reduced Motion-compatible exact source |
| BUILD placement preview | BASE + BUILD_2B_SEMANTIC | 053 retains four exact named candidate slices; 054 BUILD adds valid/invalid/rotate/replacement state overlays without assigning meaning to unnamed atlas regions |
| BUILD track palette | BUILD_2B_COMPOSITION | 4 forms × 5 interaction states = 20 semantic compositions using existing 4 committed rail silhouettes + existing UI interaction frames; **0** new form×interaction PNGs |
| BUILD preflight | BUILD_2B_SEMANTIC | neutral shell + primary/multi/focused markers compose `clear`, `primary_issue`, `multi_issue_summary`, `focused_location`; no gameplay outcome invented |
| ghost route | PROMOTED | exact source |
| cost HUD | PROMOTED | exact source |
| controls 7 states | RECOVERED / PRODUCT | normal/hover/pressed/selected/disabled/locked/focus recovered from exact approved E+D UI reference; BUILD palette reuses normal/selected/disabled/focus/pressed |
| VFX atlas | PENDING_REVISION | source healthy; causal role split pending as VFX Batch 2C |
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

No unnamed region of an atlas is promoted or assigned a new semantic name. `run_stack_unloading_v01` remains source-authoritative `unloading`, not the distinct predicted next-unload-group state.

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

Directional arrow geometry is not duplicated into Batch 2A. The compositions retain `SX-DEC-042 · SX-DEC-046 · VIS-014` as procedural direction authority.

## SX-DEC-054 BUILD Batch 2B semantic package

### Placement preview · 4 physical overlays / 4 compositions

- `build_placement_valid_overlay_v01.png`;
- `build_placement_invalid_overlay_v01.png`;
- `build_placement_rotate_preview_overlay_v01.png`;
- `build_placement_replacement_preview_overlay_v01.png`.

Each composition is `preview_only` and accepts the four committed core rail products as form authority. The existing four 053 authoritative placement crops remain preserved as provenance/product assets; the new states do not claim unnamed atlas regions.

### Track palette · 0 new form×interaction PNGs / 20 compositions

Forms:
- straight;
- curve;
- switch;
- crossing.

Interaction states:
- idle → existing `normal` UI frame;
- selected → existing `selected` UI frame;
- unavailable → existing `disabled` UI frame;
- keyboard-focus → existing `focus` UI frame;
- touch-pressed → existing `pressed` UI frame.

The semantic matrix is exactly 4 × 5 = **20** composition records. Form identity comes from existing committed core rail silhouettes. This explicitly avoids a 20-file binary cross product.

`art/production_candidates/ed_hybrid_v1/build/build_track_palette_v01.png` remains `PRESERVE_REFERENCE_ONLY_NO_STATE_MAPPING`.

### Preflight · 4 physical primitives / 4 compositions

- `build_preflight_shell_v01.png`;
- `build_preflight_primary_issue_marker_v01.png`;
- `build_preflight_multi_issue_marker_v01.png`;
- `build_preflight_focused_location_marker_v01.png`.

Compositions:
- `clear` → shell;
- `primary_issue` → shell + primary marker;
- `multi_issue_summary` → shell + multi marker;
- `focused_location` → shell + focused-location marker.

No ready/warning/blocking gameplay outcome is created, and optional-target/leaderboard misses are not represented as general run failure.

## Counts

- SX-DEC-051 source candidates: **31**
- dispositions complete: **31 / 31**
- `PROMOTE_AS_IS`: **18**
- `PROMOTE_AFTER_REVISION`: **11**
- `REPLACE`: **2**
- SX-DEC-053 product PNG ownership: **39**
- SX-DEC-054 RUN Batch 2A semantic PNG ownership: **20**
- SX-DEC-054 BUILD Batch 2B semantic PNG ownership: **8**
- expected physical product PNG total after BUILD merge: **67**
- BUILD Batch 2B semantic compositions: **28** = placement 4 + palette 20 + preflight 4
- BUILD palette new form×interaction physical PNG count: **0**
- SX-DEC-053 authoritative slice batch 1: **8** product PNGs
- corrupt source candidates detected by deep PNG health scan: **2** (`locomotive`, `controls atlas`)
- corrupt source candidates overwritten: **0**

## Product root

`art/product_assets/ed_hybrid_v1/`

Ownership manifests:

- `art/product_assets/ed_hybrid_v1/manifest.json` — `SX-DEC-053` baseline product ownership;
- `art/product_assets/ed_hybrid_v1/semantic_manifest_sx_dec_054.json` — `SX-DEC-054` RUN Batch 2A ownership/compositions;
- `art/product_assets/ed_hybrid_v1/semantic_manifest_sx_dec_054_build_2b.json` — `SX-DEC-054` BUILD Batch 2B ownership/compositions.

Validators require exact physical-file agreement and pairwise-disjoint ownership. The BUILD sidecar references the RUN sidecar but does not rewrite it. `REPLACE` records in the 053 manifest retain corrupt source-candidate provenance plus exact approved-reference recovery provenance.

## Remaining asset work before later runtime integration

1. complete VFX causal state separation for cargo pickup/unload, combo, route selection, success/failure, `ROUTE_END`, `TIME_EXPIRED`;
2. provide Reduced Motion information-equivalent presentation for every meaning-bearing VFX event;
3. keep all later Scene/Resource/Theme/Animation/signal/runtime/device/human gates separate.

RUN Batch 2A remains merged-main verified. BUILD Batch 2B is implemented and exact-head validation/merge is pending. All semantic packages remain `runtime_integrated=false`; Windows physical runtime, Android device, connected physical editor, and human comprehension/playtest remain `NOT_RUN`.