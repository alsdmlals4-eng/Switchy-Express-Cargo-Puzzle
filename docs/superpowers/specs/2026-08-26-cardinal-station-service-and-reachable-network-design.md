# Cardinal Station Service and Reachable Network Design

**Decision:** `SX-DEC-060`
**Status:** `DESIGN_COMPLETE · IMPLEMENTATION_NOT_YET_EXECUTED`
**Date:** `2026-08-26 KST`
**Canonical decision:** `docs/decisions/SX_DEC_060_CARDINAL_STATION_SERVICE_AND_REACHABLE_NETWORK.md`

## Problem

The current finite runtime couples three concepts that SX-DEC-060 separates:

1. a station placement is treated as a required rail anchor;
2. unloading happens only when the train enters the exact station cell;
3. preflight asks the start-reachable graph to contain every required anchor and applies structural checks broadly across the graph.

The approved player rule is instead: a station unloads from exactly one cardinal tile away, diagonals do not count, and unused disconnected track islands need not invalidate the route. The implementation must change the data, validation, delivery, presentation, map content, and evidence contracts together.

## Goals

- Deliver when train/station Manhattan distance is exactly `1`.
- Exclude diagonals and the station cell itself from delivery service.
- Keep cargo pickup exact-cell contact with existing Manual / Auto semantics.
- Preserve unlimited LIFO and contiguous matching TOP-group unload semantics.
- Make station footprint an off-track/non-buildable service object for the new schema.
- Validate the start-reachable RUN component against required cargo and station service coverage.
- Allow irrelevant disconnected player-built rail islands.
- Reuse current station PNGs; represent service range procedurally first.
- Migrate current product/tutorial maps explicitly and recompute deterministic witnesses.
- Keep pre-SX-DEC-060 Candidate 003 as historical exact-byte evidence only.

## Non-goals

- arbitrary catchment radius;
- diagonal station service;
- per-station service range;
- multi-station priority rules;
- score/combo design;
- Route Probe / PB / Fingerprint;
- Yard Labs / Mastery;
- fixed-seed challenge pipeline;
- new image generation;
- solver or auto-route answer reveal;
- changing LIFO, Manual/Auto, occupied switch lock, Retry/Edit, or finite outcome ownership.

## Architecture choice

### Chosen: off-track station + derived cardinal service cells

`FiniteMapDefinition` owns station placement and deterministic service-cell derivation. `PreflightValidator` owns whether the RUN-reachable component covers required service. `FiniteDeliveryLoop` owns runtime contact/unload integration. `ProductBoardRenderer` owns only the visual projection of the service range.

```text
FiniteMapDefinition v3
  station cell
    ↓ derive
  [UP, RIGHT, DOWN, LEFT] in-board service cells
    ├── PreflightValidator: at least one reachable?
    ├── FiniteDeliveryLoop: train entered one?
    └── ProductBoardRenderer: procedural service indication
```

No presentation object becomes gameplay authority.

## Data contract

### Schema version

Use `FiniteMapDefinition.SCHEMA_VERSION = 3` for migrated current finite maps.

Schema v2 is historical semantics and must not be silently reinterpreted. Current active product maps are migrated to v3 in the same implementation slice.

### Station placement

Canonical v3 station entry:

```json
{
  "cell": [8, 9],
  "cargo_type": "RED_STAR"
}
```

A v3 station does not accept or require `rail_anchor`.

### Cargo placement

Cargo remains a contact object. Existing placement shape and any rail/contact semantics required by current maps stay intact unless a migration test proves a smaller safe representation.

### Buildable surface

For v3, `FiniteMapLoader` always excludes:

```text
start_cell
incoming_cell
blocked_cells
station_placement cells
```

from player-buildable cells.

Cargo cells follow the existing `marker_tracks_player_built` policy because the train must still contact them.

### Service helper interface

Add one deterministic owner in `FiniteMapDefinition`:

```gdscript
const CARDINAL_DIRECTIONS: Array[Vector2i] = [
    Vector2i.UP,
    Vector2i.RIGHT,
    Vector2i.DOWN,
    Vector2i.LEFT,
]

func station_service_cells(station_cell: Vector2i) -> Array[Vector2i]:
    var result: Array[Vector2i] = []
    for direction: Vector2i in CARDINAL_DIRECTIONS:
        var candidate := station_cell + direction
        if _inside_board(candidate):
            result.append(candidate)
    return result
```

Order is fixed `UP → RIGHT → DOWN → LEFT` for deterministic tests/readback. Gameplay must not use order as a priority rule.

Add:

```gdscript
func station_service_cells_for_placement(placement: Dictionary) -> Array[Vector2i]
func required_cargo_cells() -> Array[Vector2i]
```

Do not keep a generic `required_anchor_cells()` contract that treats stations and cargo as identical reachable objects. If compatibility requires the method temporarily, make its name/behavior clearly legacy and remove current callers in this slice.

### Ambiguous service ownership

One rail cell must not be an authored service cell for two stations in the current product because no priority behavior is approved.

Definition validation should detect overlapping cardinal service cells between distinct stations and report a deterministic validation error such as:

```text
station service cells must not overlap
```

This is fail-closed content validation, not runtime selection.

## Graph contract

`FiniteTrackGraphBuilder` must no longer create an authored track piece for a v3 station placement.

For v3:

- start/incoming fixed pieces remain;
- cargo fixed-anchor behavior remains only where current cargo data requires it;
- station placements never become graph pieces;
- player layout pieces remain graph pieces.

If current `marker_tracks_player_built` conflates station and cargo track behavior, split the behavior semantically rather than adding another broad boolean whose name hides the distinction.

## Preflight contract

### Reachable component first

Preflight begins from the same authored incoming/start state and computes traversal states reachable from that state. This is the authoritative RUN component.

### Required cargo

Every required cargo cell must be present in `reachable_cells`.

Recommended failure:

```text
UNREACHABLE_CARGO
```

`problem_cells` contains the unreachable cargo cells in current deterministic row-major sort order.

### Required station service

For each station placement:

```gdscript
var serviceable := false
for service_cell: Vector2i in definition.station_service_cells_for_placement(placement):
    if reachable_cells.has(service_cell):
        serviceable = true
        break
```

If false, fail with:

```text
UNREACHABLE_STATION_SERVICE
```

`problem_cells` contains station footprint cells, not all four service cells, so current preflight presentation can reinforce the actual station identity without covering its neighboring track geometry.

### Disconnected unused track

A disconnected component is allowed when it:

- is not reachable from the start state;
- contains no required cargo contact;
- does not provide the only service cell for a required station.

Structural errors entirely confined to such an unreachable island do not block RUN. This includes dangling ends or malformed switch/crossing pieces that the train can never enter from the start component. BUILD may still show neutral/edit feedback, but RUN preflight is not a global topology linter.

### Reachable structural validation

Crossing/switch/trap validation must scope to cells or traversal states reachable from the active start component. The validator must not downgrade safety on the component the train can actually enter.

Keep open-terminal behavior already authorized by current product maps. Do not revive legacy closed-network constraints.

## Delivery runtime contract

### Station service index

Replace exact footprint indexing:

```gdscript
_stations_by_cell[station.cell] = station
```

with an index of service cells, for example:

```gdscript
var _stations_by_service_cell: Dictionary = {}
```

Prefer constructing the index from `Station.service_cells()` or a shared pure helper whose semantics are unit-tested. Avoid duplicating cardinal math in three gameplay classes.

Recommended `Station` interface:

```gdscript
const CARDINAL_DIRECTIONS: Array[Vector2i] = [
    Vector2i.UP,
    Vector2i.RIGHT,
    Vector2i.DOWN,
    Vector2i.LEFT,
]

func service_cells() -> Array[Vector2i]:
    var result: Array[Vector2i] = []
    for direction: Vector2i in CARDINAL_DIRECTIONS:
        result.append(cell + direction)
    return result

func services(train_cell: Vector2i) -> bool:
    var delta := train_cell - cell
    return absi(delta.x) + absi(delta.y) == 1
```

If duplicate cardinal constants become a maintenance risk, extract a small pure domain helper under `game/station/` and have both data/runtime call it. Do not make renderer code the shared owner.

### Contact order

Within `handle_cell_entered(cell, event_time)`:

1. evaluate cargo pickup at `cell` using existing input + stack rules;
2. evaluate station service at `cell`;
3. apply matching TOP-group unload;
4. construct current `FiniteDeliveryEvent`.

This preserves the existing single-cell event boundary and deterministic state transition.

### Multiple station candidates

Current content validation forbids one service cell from belonging to multiple stations. Runtime should also fail closed during construction/configuration if a duplicate service-cell key is encountered. Do not silently overwrite dictionary entries.

## Presentation contract

### Existing actual bitmap consumers

Keep these existing product assets:

```text
core_station_red_normal_v01.png
core_station_blue_normal_v01.png
core_station_yellow_normal_v01.png
```

`ProductBoardRenderer` already loads them through `PRODUCT_VISUAL_ASSET_PATHS`. No new station bitmap is required.

### Service-range visualization

Add a procedural renderer pass, e.g.:

```gdscript
func _draw_station_service_ranges(rect: Rect2, board_size: Vector2i) -> void
```

called after grid/block surface and before dynamic train/state overlays.

For each station, draw a subtle non-color-only service cue on the four in-board cardinal neighbor cells. Recommended first implementation:

- 2–3 px low-alpha outline or corner ticks;
- cargo-type color may reinforce but not solely encode service;
- no filled opaque tile;
- station sprite/shape/text remains the identity owner;
- preflight problem outline remains stronger than service range;
- occupied switch/route state remains stronger than service range;
- reduced-motion requires no special branch because the indicator is static.

Expose a descriptor for deterministic tests instead of screenshot-only assertions:

```gdscript
func station_service_descriptors_for_test() -> Array[Dictionary]
```

Each descriptor should include station cell, cargo type, and derived in-board service cells.

No new bitmap path/key is added in this slice.

## First-session / copy impact

Current T1/T2 language that implies "connect rail directly into the station" becomes stale.

Copy must teach:

```text
Cargo: pass through its tile to load.
Station: pass along one of the four adjacent tiles to deliver.
Diagonal adjacency does not deliver.
```

The tutorial must demonstrate this visually in T2 before LIFO complexity in T3. T1 should teach route construction without implying global network connectedness beyond the active solution.

Keep locales `ko / en / ja / zh-Hans`; `zh-Hant` stays deferred. Existing localization fallback and raw-key prohibitions remain.

## Current map migration

Search current runtime-consumed `data/maps/**` files and migrate all active finite maps in one coherent slice. Known current map owners include:

```text
data/maps/fp_core_proof_01.json
data/maps/vs_demo_01.json
data/maps/tutorial/tut_01_02.json
data/maps/tutorial/tut_03_lifo.json
data/maps/tutorial/tut_04_selective_load.json
data/maps/tutorial/tut_05_auto_load.json
data/maps/tutorial/tut_06_switch.json
```

For each map:

1. bump `definition_schema_version` to `3`;
2. bump map revision;
3. bump ruleset from `fp_core_v1` to an SX-DEC-060-specific current value such as `fp_core_v2` only if all consumers use exact ruleset equality consistently;
4. move each station to a non-buildable/off-track cell whose cardinal service tile can be reached by the intended route;
5. preserve intended cargo encounter/LIFO lesson;
6. recompute deterministic witness/layout bytes and any expected identity/signature;
7. run each first-session stage from a fresh attempt.

Do not mechanically move station coordinates without re-validating the puzzle lesson. Station placement affects route geometry and therefore is product content.

## Test design

### Map definition

Add/modify `tests/finite/map/test_finite_map_definition.gd` and loader tests to prove:

- schema v3 accepts station without rail anchor;
- station cell is excluded from buildable cells;
- cardinal service cells are exact and deterministic;
- edge/corner stations return only in-board service cells;
- overlapping station service cells are rejected;
- cargo placement semantics remain valid;
- stale schema v2 bytes are not silently treated as v3 current semantics.

### Delivery

Modify `tests/finite/delivery/test_finite_delivery_loop.gd` to prove for each direction:

```text
UP    → unload
RIGHT → unload
DOWN  → unload
LEFT  → unload
```

and prove:

```text
same station cell → no service
diagonal          → no service
distance 2        → no service
mismatched TOP    → no unload
matching TOP group→ current contiguous-group behavior preserved
```

### Preflight

Modify `tests/finite/build/test_preflight_validator.gd` and fixtures to prove:

- cargo unreachable from start → fail;
- station has no reachable cardinal service cell → fail;
- one reachable cardinal station service cell → pass;
- diagonal-only proximity → fail;
- disconnected irrelevant rail island → pass;
- disconnected island containing required cargo → fail;
- invalid reachable switch/crossing remains fail;
- invalid unreachable island does not block RUN;
- results remain deterministic over repeated validation.

### Graph / integration

Update graph builder and integration tests to prove station footprint is not a graph piece for v3 and train never needs to enter the station cell.

Update one-sided station parity tests because the old exact-terminal model is superseded by cardinal service.

### Presentation

Renderer tests prove:

- existing station PNG paths still load;
- no new image key is required by SX-DEC-060;
- service descriptors are exactly cardinal, not diagonal;
- marker identity remains color + shape + text;
- service overlay is not the gameplay authority.

### First session / package

Run the repository custom Godot test runner, current Python contract tests, first-session deterministic witness tests, and Windows/Android package workflows required by the active project gates.

## Migration safety

### Identity

Changing map schema/revision/ruleset changes finite solution identity. Do not compare post-060 attempts to pre-060 solution identity as if they were the same puzzle bytes.

### Acceptance evidence

`SX59-POC-ACCEPT-003` is pre-060. Preserve its hashes and records unchanged as historical evidence. The first post-060 build requires a new candidate ID and fresh package/runtime/human evidence.

### Save compatibility

If current runtime has no durable user save containing finite layout identity, no migration layer is needed. If a save consumer is found during implementation, stop and add an explicit compatibility task rather than guessing.

## Failure handling

Fail closed when:

- definition has overlapping station service ownership;
- delivery-loop construction detects duplicate service-cell ownership;
- current map migration leaves a station without an in-board service cell;
- required cargo/service coverage is unreachable;
- any migrated first-session witness no longer demonstrates its intended lesson;
- presentation requires a new bitmap but no concrete runtime consumer contract exists.

## Evidence ceiling

Before implementation:

```text
DESIGN_COMPLETE
USER_RULE_RECORDED
RUNTIME_NOT_IMPLEMENTED
AUTOMATED_REGRESSION_NOT_RUN
PACKAGED_RUNTIME_NOT_RUN
PHYSICAL_NOT_RUN
HUMAN_NOT_RUN
NEW_BITMAP_ASSETS_0
```

After implementation, every higher claim must bind to exact commit/build/candidate evidence. No previous Candidate 003 physical or package fact automatically transfers to post-060 bytes.
