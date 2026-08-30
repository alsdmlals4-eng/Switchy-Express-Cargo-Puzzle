# SX-DEC-067 · Wayside Hazards, Salvage, and Route Book 02

**Status:** `USER_APPROVED · IMPLEMENTED_LOCAL_MACHINE_RUNTIME_VERIFIED · NOT_MERGED`
**Date:** 2026-08-30 KST
**Approval source:** The user approved the modular board-decoration and Route Book 02 direction, then explicitly approved `CAUTION_TRACK`, `WASTE_CARGO`, and `DISPOSAL_YARD` with “승인”.

## Decision

Add one optional, authored content family without changing the first-session contract or reviving retired systems:

```text
Route Book 02
→ six directly selectable authored maps
→ modular board decorations on blocked terrain cells
→ optional caution-track cells that slow only the departing train segment
→ waste cargo that unloads only at an off-track disposal yard
→ existing Build / Run / LIFO / route control / Result / Retry-or-Edit flow
```

`Route Book 01`, `T1` through `T6`, and `VS_DEMO_01` remain unchanged. Route Book 02 is optional and is never an onboarding gate.

## Fixed rules

```yaml
map_schema: FiniteMapDefinition v3 remains current
new_optional_map_fields:
  caution_track_cells: Array[Vector2i]
  board_decorations: Array[{ kind: StringName, cell: Vector2i }]
new_cargo_type: WASTE_CRATE
new_destination_kind: DISPOSAL_YARD
caution_speed_multiplier: 0.55
caution_stacking: forbidden
caution_source: authored cells only
cargo_count_slowdown: forbidden
disposal_service: Manhattan distance exactly 1
disposal_footprint_and_diagonal: invalid service
waste_destination: DISPOSAL_YARD only
ordinary_destination: normal station only
completion: all map cargo removed and stack empty
retry: same sealed definition/layout, fresh mutable attempt
```

`CAUTION_TRACK` is a visual-and-runtime terrain condition, not a player input, random event, fuel drain, or cargo-capacity penalty. The train uses `base_speed * 0.55` only while departing a listed caution cell, then returns to base speed on the next non-caution departure.

`WASTE_CRATE` remains a normal member of the unlimited LIFO stack. A disposal yard is represented by an off-track station placement with `destination_kind: DISPOSAL_YARD` and `cargo_type: WASTE_CRATE`; the existing contiguous matching TOP-group unload rule therefore remains authoritative. A normal cargo at a disposal yard, or waste at a normal station, does not unload.

## Visual and data boundary

Board decorations are non-gameplay data. They may appear only on `blocked_cells`; they must be inside the board, unique by cell, and use one of the registered modular decoration kinds. They must not overlap buildable cells, cargo, destinations, start/incoming cells, or service cells. The renderer draws them after terrain and before grid/track layers.

`CAUTION_TRACK`, the waste cargo, and the disposal yard have separate registered bitmap slots and redundant non-colour shape/text drawing. A decorative asset must not be used as a gameplay marker, and gameplay markers must not be hidden by a decoration.

## Explicitly rejected

- cargo-count slowdown, capacity limit, fuel, BOOST, respawn, random hazards, damage, lives, or survival loop;
- score, stars, rank, unlock persistence, economy, upgrades, editor, UGC, daily/weekly generation, or route solution reveal;
- diagonal/footprint service, station radius changes, and per-destination arbitrary service geometry;
- changing first-session maps, first-session policy, or the machine-primary validation policy.

## Evidence boundary

Implementation must use RED-first tests for map validation, speed restoration, disposal/LIFO behavior, retry identity, renderer layer ordering, catalog selection, and each Route Book 02 map witness. A local/CI/runtime/package result is machine evidence only. Five-person comprehension and player-experience studies remain `NOT_REQUIRED_BY_USER_VALIDATION_POLICY`; optional final user review must use one unchanged, named post-change candidate.

## Implementation readback · 2026-08-31 KST

```yaml
map_schema_fields: IMPLEMENTED_AND_TESTED
waste_and_disposal_pairing: IMPLEMENTED_AND_TESTED
caution_segment_speed: IMPLEMENTED_AND_TESTED
snapshot_and_renderer_layers: IMPLEMENTED_AND_TESTED
wayside_bitmap_candidates: GENERATED_CANDIDATE · GODOT_IMPORTED · AUTOMATED_RENDERER_TEST_PASS
wayside_bitmap_pixel_review: USER_REVIEW_PENDING
route_book_02_catalog_and_maps: IMPLEMENTED_AND_TESTED
machine_validation_policy: PRIMARY
five_person_and_player_experience_studies: NOT_REQUIRED_BY_USER_VALIDATION_POLICY
```

The generated bitmap family is intentionally recorded as a runtime-connected candidate rather than as an approved canonical final asset. Its provenance and exact hashes are owned by `docs/ASSET_RIGHTS_AND_PROVENANCE_RECORD.md`; the eventual unchanged post-change package candidate remains the only valid target for an optional user visual review.

## Owners

- Core design: `docs/superpowers/specs/2026-08-30-wayside-hazards-and-salvage-design.md`
- Route Book 02 design: `docs/superpowers/specs/2026-08-30-route-book-02-surface-content-design.md`
- Core implementation plan: `docs/superpowers/plans/2026-08-30-wayside-hazards-and-salvage-core.md`
- Content implementation plan: `docs/superpowers/plans/2026-08-30-route-book-02-surface-content.md`
- Content owner: `기획서/20_시스템_콘텐츠/ROUTE_BOOK_02_WAYSIDE_CONTENT_SPEC.md`
