# SX-DEC-060 · Cardinal Station Service and Reachable Network

Status: `USER_APPROVED_CORE_DELTA · DESIGN_RECORDED · MERGED_MAIN_VERIFIED · PR #188`
Decision date: `2026-08-26 KST`
Project baseline: `GMB-002 · FINITE_DELIVERY_PUZZLE_BASELINE`
Supersedes only the conflicting station-contact / all-required-anchor reachability semantics of the pre-SX-DEC-060 finite runtime. It does not reactivate legacy endless/fuel/BOOST/capacity-8/cargo-slowdown/pickup-respawn/switch-auto-reset behavior.

## 1. User-approved rule

The delivery service rule is exact and intentionally small:

```text
station service distance = abs(train_cell.x - station_cell.x)
                         + abs(train_cell.y - station_cell.y)

DELIVERY_SERVICEABLE iff distance == 1
```

Therefore:

- the four cardinal cells immediately **up / right / down / left** of a station are service cells;
- diagonal cells are not service cells;
- distance 2+ is not serviceable;
- cargo pickup remains exact same-cell contact and keeps the current Manual / Auto load semantics;
- a matching station still unloads only the contiguous same-type group from the LIFO TOP;
- a mismatching TOP still unloads nothing.

The player also does **not** have to connect every placed rail piece into one global network. A disconnected rail island that is irrelevant to the active RUN solution must not by itself invalidate RUN.

## 2. Player promise after this Decision

```text
read cargo + station placement
→ build only the rail network needed by the intended run
→ make that reachable network contact required cargo cells
→ make it pass cardinally adjacent to each required station
→ create the desired unlimited LIFO order
→ execute persistent switches during RUN
→ unload matching contiguous TOP groups while passing station service cells
→ retry or redesign
```

The core remains a finite cargo-order puzzle. The change removes unnecessary "rail must occupy the station tile / every rail island must globally connect" constraints so that route geometry serves encounter order and LIFO planning rather than topology housekeeping.

## 3. Technical representation default

The approved gameplay rule needs one unambiguous runtime representation. The implementation default is:

```yaml
station_role: OFF_TRACK_SERVICE_OBJECT
station_cell_player_track: FORBIDDEN
station_service_metric: MANHATTAN_DISTANCE
station_service_distance: 1
cargo_role: ON_TRACK_CONTACT_OBJECT
cargo_contact_distance: 0
map_schema_target: FiniteMapDefinition_v3
```

Rationale:

- keeping a rail anchor underneath a station while delivery happens only beside it creates two contradictory meanings for one tile;
- a dedicated off-track station footprint makes the visual and gameplay contract agree;
- schema v3 makes the semantic migration explicit instead of silently changing the meaning of schema v2 historical data.

This is an implementation representation, not a new radius/custom-zone feature. Arbitrary service radii, diagonals, per-station radii, and shaped catchment areas are `OUT_OF_SCOPE`.

## 4. Preflight contract

Preflight validates the **RUN-reachable component from the authored start state**, not global connectedness of every rail piece.

A layout may PASS only when all of the following are true:

1. the start/incoming state forms a valid RUN entry;
2. every required cargo cell is in the RUN-reachable component;
3. for every required station, at least one of its four in-bounds cardinal service cells is in the RUN-reachable component;
4. crossing/switch structure that can actually participate in the RUN-reachable component is usable under current routing semantics;
5. no reachable traversal state violates the applicable route-end/trap contract.

A fully unreachable player-built rail island that contains no required cargo and is not needed as a station service cell is ignored by RUN preflight. It remains a paid/placed BUILD artifact and may still be edited or removed by the player.

### Failure ownership

Recommended deterministic codes:

```text
UNREACHABLE_CARGO
UNREACHABLE_STATION_SERVICE
```

The existing `DISCONNECTED_REQUIRED_POINT` may remain only as a compatibility alias if tests or presentation need a migration window. New semantics must distinguish cargo contact from station service coverage.

## 5. Delivery resolution contract

`FiniteDeliveryLoop` remains the gameplay integration owner. The runtime should index stations by their four cardinal service cells rather than by the station footprint itself.

When the train enters one cell:

1. resolve cargo pickup on that exact train cell using existing Manual / Auto rules;
2. resolve candidate station services for that train cell;
3. for a matching station, apply existing `Station.try_unload()` TOP-group semantics;
4. emit one deterministic delivery event using current evidence-safe fields.

If authored content can make one train cell service multiple stations, content validation should reject ambiguous overlapping service ownership unless a later Decision explicitly defines multi-station priority. Do not invent closest/first/random priority.

## 6. Data / migration contract

`FiniteMapDefinition` schema v2 remains historical input semantics. SX-DEC-060 implementation should introduce schema v3 rather than reinterpret v2 bytes in place.

For schema v3:

- station placements do not require `rail_anchor`;
- station cells are excluded from player-buildable cells;
- cargo placements keep current direct-contact track semantics;
- helpers expose deterministic cardinal service cells;
- validation rejects station footprints outside the board and rejects ambiguous service ownership where one reachable rail cell would service multiple stations;
- current product maps and first-session maps migrate as explicit map revisions/ruleset revisions;
- deterministic solution witnesses are recomputed against migrated map bytes.

## 7. Visual / asset consumer contract

This Decision does **not** authorize explanatory image sheets or speculative bitmap production.

Current `ProductBoardRenderer` already consumes approved station textures:

```text
art/product_assets/ed_hybrid_v1/core/core_station_red_normal_v01.png
art/product_assets/ed_hybrid_v1/core/core_station_blue_normal_v01.png
art/product_assets/ed_hybrid_v1/core/core_station_yellow_normal_v01.png
```

Therefore:

- existing station PNGs remain the station art consumer source;
- the four service cells should first be expressed procedurally in `ProductBoardRenderer` (outline / corner ticks / low-alpha service emphasis) from runtime snapshot data;
- the service indicator must not obscure rail geometry, cargo identity, switch state, preflight problem outline, or train position;
- no new production image is created unless a future implementation introduces a concrete texture slot/path/key and procedural treatment is proven insufficient.

`NEW_BITMAP_ASSETS_REQUIRED_BY_SX_DEC_060 = 0` at design time.

The merged SX-DEC-060 implementation keeps that exact zero-new-bitmap fact. For a later verified runtime consumer, the current user policy is:

```yaml
automatic_consumer_image_policy: USER_APPROVED_2026_08_26
approved_image_dual_storage: PROJECT_LOCAL_AND_NOTION
visual_continuity: existing E+D Hybrid / Neo-Arcade visual language
```

Generate only the required bitmap, preserve the tracked project-local file and Notion Visual/Asset record with provenance/SHA-256/readback, and do not request a separate per-image approval.

## 8. Benchmark / trade study

Three materially different approaches were compared:

### A. Keep station as rail anchor and add adjacent unloading

Rejected. Lowest code churn but leaves one tile with contradictory semantics: the station remains a required rail anchor while service happens beside it. It also preserves unnecessary global-anchor assumptions.

### B. Off-track station + exact cardinal service cells — ADOPTED

Adopted. It makes the station a service object beside the route, keeps cargo as direct track contact, and lets route design focus on cargo encounter order / LIFO / switch execution. It is small enough to test exhaustively.

### C. Generic radius / arbitrary service-area schema

Rejected for now. It is more flexible but adds data, UI, validation, tutorial, migration, and ambiguity cost without a current player need. This would violate YAGNI.

External reference comparison:

- Railbound emphasizes connecting/severing railways as the direct puzzle object; Switchy should preserve its own stronger differentiation around cargo encounter order + LIFO + switch execution rather than make global connectivity an end in itself.
- OpenTTD demonstrates a transport-domain precedent for separating a station/service area from the exact cargo-producing/accepting tile.
- Factorio's Train Stop is a useful contrast: it models an exact rail stop. SX-DEC-060 intentionally does **not** adopt that exact-stop model.

References:
- https://store.steampowered.com/app/1967510/Railbound/
- https://wiki.openttd.org/en/Manual/Catchment%20area
- https://wiki.factorio.com/Train_stop

## 9. Compatibility and evidence ceiling

```yaml
pre_sx_dec_060_candidate: SX59-POC-ACCEPT-003
candidate_003_role_after_decision: HISTORICAL_PRE_SX_DEC_060_PHYSICAL_TARGET
post_sx_dec_060_candidate_pointer: evidence/acceptance/post_sx_dec_060_candidate.json
post_sx_dec_060_candidate: SX60-POC-ACCEPT-002 · PREPARED_PACKAGE_VERIFIED · SOURCE_MAIN_0e882764b837d13282a7642b115948d4e061d163
sx60_poc_accept_001: HISTORICAL_SUPERSEDED_BY_PRODUCT_BYTE_CHANGE · PLAYER_FACING_RUNTIME_ROUTE_READABILITY_CHANGE
candidate_003_package_integrity: PRESERVED_HISTORICAL_PASS
candidate_003_physical_visual_recheck: NOT_RUN
sx_dec_060_runtime_implementation: MERGED_MAIN_VERIFIED · PR_188 · main_740b4b9312fa27289fd62baab8dda54c68ead3a7
sx_dec_060_automated_regression: PASS · 111_CASES_13461_ASSERTIONS · CI_7_GREEN
sx_dec_060_five_pass_review: CLOSED · SX-AUD-071
sx_dec_060_notion_readback: PASS
sx_dec_060_packaged_runtime: SX60_POC_ACCEPT_002_PREPARED_PACKAGE_VERIFIED · HISTORICAL_SX60_POC_ACCEPT_001_PRESERVED
sx_dec_060_windows_physical: NOT_RUN_CURRENT_EXACT_CANDIDATE_002
sx_dec_060_android_device: NOT_RUN
sx_dec_060_five_person_comprehension: NOT_RUN
sx_dec_060_player_experience: NOT_RUN
new_bitmap_assets: 0
```

Candidate 003 remains valid historical evidence for its exact pre-SX-DEC-060 bytes. It cannot be promoted as acceptance evidence for the modified gameplay. Human validation should not be spent on stale pre-060 semantics after the new runtime is chosen for implementation.

## 10. Protected boundaries

The implementation must not absorb:

- SX-DEC-056A Route Probe / PB / Fingerprint;
- SX-DEC-056B score / max-combo invention;
- SX-DEC-057 Yard Labs / Mastery;
- SX-DEC-058 challenge generator/pipeline;
- arbitrary station radius or diagonal service;
- solver / optimal route reveal;
- new generated image assets without an actual runtime consumer;
- Base repin;
- changes to pre-existing Draft PR #174.

## 11. Implementation owner and next gate

Actual GDScript / Scene / Resource / map-data / runtime test work is merged-main verified by PR #188 under the active r5.4 project contract.

```text
SX60-POC-ACCEPT-002 isolated visual/input/audio self-run
→ physical/device/human evidence gates
```
