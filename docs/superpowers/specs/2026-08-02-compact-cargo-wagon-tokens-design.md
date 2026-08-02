# Compact Cargo Wagon Tokens Design

Status: `APPROVED_PLANNING_SPEC · IMPLEMENTATION_NOT_STARTED`
Decision ID: `SX-DEC-015`
Evidence ID: `EV-USER-003`
Date: `2026-08-02`
Scope: `VS-03B product presentation and spawn-occupancy contract`

## Decision

Each loaded cargo item is represented by one compact wagon token.

```text
cargo_stack.size() == compact_wagon_token_count
0 cargo → locomotive only
1 cargo → locomotive + 1 compact wagon token
8 cargo → locomotive + 8 compact wagon tokens
```

The tokens remain visually small and tightly spaced so the train does not stretch across eight rail cells and reduce route readability.

## Player-facing purpose

- Make cargo weight and remaining capacity readable in the game world.
- Preserve a visible one-to-one relationship between cargo count and train load.
- Reinforce LIFO by making the most recently loaded cargo the rearmost token and therefore the first token removed on unload.
- Avoid a long full-sized wagon chain that hides switches, stations, pickups, and route previews on a 15×10 mobile board.

## Visual and ordering contract

- Tokens are world-space miniature cargo wagons following the locomotive path.
- Front-to-back token order equals CargoStack bottom-to-top order.
- The rearmost token is the CargoStack top and the next item to unload.
- Loading appends one token at the rear.
- A valid station unload removes the matching consecutive rear token group.
- Every token carries the cargo type's color and shape signal:
  - red + star
  - blue + diamond
  - yellow + triangle
- Empty wagon slots are not displayed.

## Authority and event order

CargoStack is authoritative.

1. Pickup or unload updates CargoStack.
2. The same domain transaction updates the logical token count and ordering ViewModel.
3. Train footprint and cargo-spawn exclusion are recalculated immediately.
4. Visual add/remove motion renders the committed result only.

Animation completion, tween callbacks, particles, audio, and haptics must never own cargo count, token count, spawn occupancy, score, fuel, Combo, or save outcomes.

## Compact geometry — TEST_VALUE

Initial recommended test values:

```text
compact_token_body_length = 0.22 rail-cell
compact_token_center_spacing = 0.28 rail-cell
max_compact_chain_length_at_8 = 2.18 rail-cells
max_reserved_trailing_footprint = 3 rail-cells
```

These values are `TEST_VALUE`, not final art measurements. They may be tuned in VS-03B without changing `SX-DEC-015`, provided all eight cargo tokens remain individually recognizable and the reserved trailing footprint does not exceed three rail cells.

## Spawn occupancy contract

- Do not reserve one whole rail cell per cargo token.
- Spawn exclusion uses the rail cells intersected by the locomotive and compressed token chain.
- The compressed trailing footprint is bounded to at most three rail cells at eight cargo.
- Existing forward safety exclusion remains independent.
- Cargo spawning must not treat eight loaded cargo as an eight-cell full-size train.
- If a token is still animating, committed domain positions and the compressed footprint remain authoritative.

## Curves and dense states

- Tokens sample bounded path history at fractional offsets; they do not cut across corners.
- On tight turns, ordering must remain stable and tokens must not visually swap.
- Z-order or mild overlap may be used, but color+shape and the rearmost LIFO token must remain readable.
- Eight-token state must not obscure a switch's active route, a station marker, or the next-route preview.

## HUD relationship

- The HUD Unload Order mirrors token order from rear to front.
- The first HUD unload item equals the rearmost world token and CargoStack top.
- A valid group unload removes the same cargo types from the world token chain and HUD in the same event.
- HUD remains the precise ordering reference when world-space tokens overlap on curves.

## Required tests

### Domain and ordering

- token count equals CargoStack size for 0 through 8.
- front-to-back tokens equal stack bottom-to-top.
- last loaded token is rearmost and first unloaded.
- group unload removes exactly the matching rear group.
- invalid or empty-station arrival changes no token.

### Geometry and occupancy

- eight tokens fit within the configured maximum compact chain length.
- spawn exclusion reserves no more than three trailing rail cells at capacity eight.
- token count changes recalculate occupied cells in the same domain step.
- curve sampling preserves order and does not cut corners.
- no cargo spawns inside the committed compact train footprint or existing forward exclusion.

### Presentation

- 0, 1, 4, and 8 cargo representative captures.
- red/star, blue/diamond, yellow/triangle remain distinguishable without relying on color alone.
- route preview, station, pickup, and switch state remain readable at eight cargo.
- Reduced Motion and instant-complete modes preserve count and ordering.

## Non-goals

- Full-sized one-cell wagons per cargo.
- Eight always-visible empty wagons.
- Multiple cargo items represented by one ambiguous wagon.
- Cargo-token collision or physics simulation.
- Final pixel dimensions, animation duration, camera zoom, or art asset selection.

## Risks and validation

| Risk | Mitigation |
|---|---|
| Tokens become too small to identify | color+shape, HUD parity, 0/1/4/8 capture review |
| Compressed chain overlaps on curves | fractional path history, stable ordering, bounded overlap |
| Spawn fairness changes | explicit compressed-footprint tests and 10-minute soak |
| LIFO appears reversed | rear token = stack top invariant and HUD parity tests |
| Motion duplicates state changes | domain-first, animation-non-authoritative contract |

## Implementation boundary

This document authorizes planning and test contracts only. Product code remains unchanged until `G3P_TOTAL_PLANNING_AND_REVIEW_COMPLETE` and the VS-03 Goal is promoted to `READY_FOR_BUILD`.
