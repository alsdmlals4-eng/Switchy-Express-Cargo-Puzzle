# Wayside Hazards and Salvage Design

**Decision:** `SX-DEC-067`
**Status:** `USER_APPROVED · READY_FOR_TDD_IMPLEMENTATION`

## Goal

Give authored Route Book maps two new, inspectable planning constraints: time cost on a known caution segment and a LIFO disposal destination for waste cargo. Preserve every current finite-delivery invariant and keep existing maps semantically identical.

## Interfaces

### `FiniteMapDefinition v3`

The schema version remains `3`. Missing new fields normalize to empty arrays so all existing map JSON remains valid.

```gdscript
var caution_track_cells: Array[Vector2i] = []
var board_decorations: Array[Dictionary] = []
const CAUTION_SPEED_MULTIPLIER := 0.55
const VALID_BOARD_DECORATION_KINDS: Array[StringName] = [
	&"FOREST_CLUSTER", &"MOSS_BOULDER", &"TIMBER_STACK",
	&"WATERWAY", &"LANTERN_FENCE",
]
```

Validation is fail-closed:

- each caution cell is unique, inside the board, and contained in `buildable_cells`;
- each decoration has a valid kind and a unique, inside-board cell contained in `blocked_cells`;
- decoration cells cannot overlap an authored destination, cargo, start/incoming cell, or any destination service cell;
- `destination_kind` is `STATION` when omitted, and only `STATION` or `DISPOSAL_YARD` when supplied;
- `WASTE_CRATE` requires `DISPOSAL_YARD`, and `DISPOSAL_YARD` requires `WASTE_CRATE`.

`to_dictionary()` includes both new arrays and the optional placement `destination_kind`, so sealed-session duplication and Retry preserve the same authored data.

### Cargo and service destination

`CargoType` gains `WASTE_CRATE`, whose redundant identity is violet + hexagon + `WASTE`. `Station` remains the service primitive: its `cargo_type` is `WASTE_CRATE` at a disposal yard and existing `try_unload()` retains contiguous TOP-group semantics. No secondary unload system is added.

### Movement

`FiniteRunSessionFactory` passes `definition.caution_track_cells` to `FiniteRunController.configure`. The controller stores a dictionary/set of caution cells and exposes `effective_speed_for_cell(cell: Vector2i) -> float` for tests.

`_apply_effective_speed()` sets zero if not actively RUNNING, otherwise uses base speed for a normal current cell and `base_speed * 0.55` for a caution current cell. It is invoked after `start`, `resume`, cell-entry processing, and unloading completion. Pause and terminal transitions continue to set speed to zero.

This definition makes every segment deterministic: the train's current cell determines the speed of the segment leaving that cell. The run clock already advances against actual elapsed seconds, so no second timer or penalty ledger is introduced.

### Render snapshot and board

`FiniteSliceSessionController._build_render_snapshot()` copies `caution_track_cells` and `board_decorations` from the definition. `ProductBoardRenderer` inserts exactly two layers:

```text
TERRAIN → DECORATION → GRID → BLOCKED → CAUTION → FIXED_TRACK → LAYOUT
→ STATION_SERVICE → ROUTE → MARKERS → START → STATE → TRAIN
```

Decorations draw beneath the grid and every gameplay marker. Caution cells draw beneath rails but above the grid. All marker drawing keeps existing color + shape + text redundancy.

## Asset consumers

The implementation adds concrete `ProductBoardRenderer::PRODUCT_VISUAL_ASSET_PATHS` consumers before recording assets in the v2 manifest:

```text
board_decor_forest        → art/product_assets/ed_hybrid_v2/board/board_decor_forest_cluster_v01.png
board_decor_boulder       → art/product_assets/ed_hybrid_v2/board/board_decor_moss_boulder_v01.png
board_decor_timber        → art/product_assets/ed_hybrid_v2/board/board_decor_timber_stack_v01.png
board_decor_waterway      → art/product_assets/ed_hybrid_v2/board/board_decor_waterway_v01.png
board_decor_lantern       → art/product_assets/ed_hybrid_v2/board/board_decor_lantern_fence_v01.png
caution_track             → art/product_assets/ed_hybrid_v2/board/board_caution_track_overlay_v01.png
cargo_waste               → art/product_assets/ed_hybrid_v2/core/core_cargo_waste_crate_normal_v01.png
station_disposal          → art/product_assets/ed_hybrid_v2/core/core_disposal_yard_normal_v01.png
```

All eight are image-model candidates first. They must contain no readable text, logo, watermark, rail geometry, normal station, normal cargo, or UI panel. Their tracked provenance includes dimensions, SHA-256, prompt receipt, exact consumer, and status. Candidate generation/registration is not runtime or human evidence.

## Non-goals

No map solver, score, time bonus, global route optimization, additional onboarding lesson, new audio system, or user-generated placement appears in this scope.
