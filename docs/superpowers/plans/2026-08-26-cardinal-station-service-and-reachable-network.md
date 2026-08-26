# SX-DEC-060 Cardinal Station Service and Reachable Network Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement exact four-direction, one-cell station delivery service and start-reachable-network preflight while preserving Switchy Express LIFO/cargo/switch semantics and requiring no new bitmap assets.

**Architecture:** Migrate current finite maps to `FiniteMapDefinition` schema v3, where stations are off-track service objects and cargo remains a direct-contact object. Derive cardinal service cells in the domain/data layer, consume the same meaning in delivery and preflight, and project it procedurally in the current board renderer. Only the start-reachable RUN component is safety-critical; irrelevant disconnected rail islands do not block RUN.

**Tech Stack:** Godot 4.7.1-stable, GDScript, repository custom headless test runner, Python contract tests, JSON finite maps, existing E+D Hybrid product textures.

**Spec:** `docs/superpowers/specs/2026-08-26-cardinal-station-service-and-reachable-network-design.md`

## Global Constraints

- Decision authority: `SX-DEC-060`.
- Delivery service iff `abs(dx) + abs(dy) == 1`.
- Diagonal, station-cell, and distance-2+ contacts do not service a station.
- Cargo pickup remains exact-cell Manual/Auto contact.
- Unlimited LIFO and contiguous same-type TOP-group unload stay unchanged.
- `SX-DEC-056~058` implementation remains unauthorized.
- No score/max-combo invention.
- No Base repin.
- No generated image asset. Reuse current station PNG consumers and procedural service overlay.
- Pre-existing Draft PR `#174` is read-only.
- Pre-SX-DEC-060 Candidate 003 evidence remains historical and does not transfer to post-060 bytes.
- Actual Godot product implementation owner: `CODEX_GODOT_PRODUCT_IMPLEMENTATION_HANDOFF`.
- Use RED → GREEN TDD for each runtime task. Never report an unexecuted command as PASS.

---

### Task 1: Introduce explicit v3 station-service data semantics

**Files:**
- Modify: `game/finite/map/finite_map_definition.gd`
- Modify: `game/finite/map/finite_map_loader.gd`
- Test: `tests/finite/map/test_finite_map_definition.gd`
- Test: the existing map-loader test file discovered by repository search before editing

**Interfaces:**
- Produces: `FiniteMapDefinition.SCHEMA_VERSION == 3`
- Produces: `station_service_cells(station_cell: Vector2i) -> Array[Vector2i]`
- Produces: `station_service_cells_for_placement(placement: Dictionary) -> Array[Vector2i]`
- Produces: `required_cargo_cells() -> Array[Vector2i]`
- Consumes later: Preflight, delivery factory validation, renderer snapshot tests.

- [ ] **Step 1: Write RED schema/service-cell tests**

Add assertions equivalent to:

```gdscript
var definition := FiniteMapDefinitionScript.create({
    "definition_schema_version": 3,
    "map_id": "SERVICE_TEST",
    "map_revision": 1,
    "ruleset_version": "fp_core_v2",
    "board_size": [7, 7],
    "start_cell": [1, 3],
    "incoming_cell": [0, 3],
    "buildable_cells": [[2, 3], [3, 2], [3, 4], [4, 3]],
    "blocked_cells": [],
    "station_placements": [{"cell": [3, 3], "cargo_type": "RED_STAR"}],
    "cargo_placements": [{
        "cell": [4, 3],
        "cargo_type": "BLUE_DIAMOND",
        "rail_anchor": {"geometry": "STRAIGHT", "rotation_quarters": 0}
    }],
    "time_limit_seconds": 90.0,
})

assert_equal(definition.validation_errors(), [])
assert_equal(
    definition.station_service_cells(Vector2i(3, 3)),
    [Vector2i(3, 2), Vector2i(4, 3), Vector2i(3, 4), Vector2i(2, 3)]
)
```

Also test edge clipping and overlapping service ownership rejection.

- [ ] **Step 2: Run the custom Godot suite and confirm RED**

```bash
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tests/run_tests.gd
```

Expected: new schema/service assertions fail because current `SCHEMA_VERSION` is `2`, stations are still anchor-like, and helper methods do not exist.

- [ ] **Step 3: Implement minimal v3 definition behavior**

Implement deterministic service helpers and split station/cargo validation. The station branch must not require `rail_anchor` in v3. Keep cargo validation compatible with the active current data contract.

Recommended core:

```gdscript
const SCHEMA_VERSION := 3
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

func station_service_cells_for_placement(placement: Dictionary) -> Array[Vector2i]:
    return station_service_cells(_read_cell(placement.get("cell", [])))

func required_cargo_cells() -> Array[Vector2i]:
    var result: Array[Vector2i] = []
    for placement: Dictionary in cargo_placements:
        result.append(_read_cell(placement.get("cell", [])))
    return result
```

Validate overlapping station service cells deterministically before accepting the definition.

- [ ] **Step 4: Make loader exclude v3 station footprints from buildable cells**

Change `FiniteMapLoader.load_from_dictionary()` so station footprints are always excluded for v3. Do not exclude cargo solely because it is a marker when the current product expects player-built rail through cargo contact cells.

- [ ] **Step 5: Run Godot tests until Task 1 is GREEN**

Expected: schema/helper/loader tests PASS; unrelated map fixtures may now fail because active map JSON is still v2. Those failures are expected migration pressure and must remain visible until Task 5.

- [ ] **Step 6: Commit Task 1**

```bash
git add game/finite/map tests/finite/map
git commit -m "feat: add cardinal station service schema"
```

---

### Task 2: Move station delivery from footprint contact to cardinal service contact

**Files:**
- Modify: `game/station/station.gd`
- Modify: `game/finite/delivery/finite_delivery_loop.gd`
- Modify if needed: `game/finite/run/finite_run_session_factory.gd`
- Test: `tests/finite/delivery/test_finite_delivery_loop.gd`

**Interfaces:**
- Produces: `Station.services(train_cell: Vector2i) -> bool`
- Produces: `Station.service_cells() -> Array[Vector2i]`
- `FiniteDeliveryLoop.handle_cell_entered(cell, event_time)` signature remains unchanged.

- [ ] **Step 1: Write RED four-direction and exclusion tests**

Create a fresh loop per direction so one unload does not consume the next assertion's stack:

```gdscript
for service_cell: Vector2i in [
    station.cell + Vector2i.UP,
    station.cell + Vector2i.RIGHT,
    station.cell + Vector2i.DOWN,
    station.cell + Vector2i.LEFT,
]:
    var setup := _loop_with_stack([A, A])
    var event: Variant = setup.loop.handle_cell_entered(service_cell, 5.0)
    assert_equal(event.unload_count, 2)
```

Add negative tests:

```gdscript
assert_equal(_event_at(station.cell).unload_count, 0)
assert_equal(_event_at(station.cell + Vector2i(1, 1)).unload_count, 0)
assert_equal(_event_at(station.cell + Vector2i(2, 0)).unload_count, 0)
```

Preserve mismatched TOP and contiguous-group tests.

- [ ] **Step 2: Run tests and confirm RED**

Expected: exact station-cell current tests pass old semantics while new cardinal tests fail.

- [ ] **Step 3: Implement Station service predicate**

```gdscript
func services(train_cell: Vector2i) -> bool:
    var delta := train_cell - cell
    return absi(delta.x) + absi(delta.y) == 1
```

Expose service cells in deterministic cardinal order.

- [ ] **Step 4: Replace delivery-loop station-footprint index**

Use a service-cell index. Constructor/configuration must reject duplicate ownership rather than overwrite:

```gdscript
var _stations_by_service_cell: Dictionary = {}

func _index_station(station: Variant) -> bool:
    for service_cell: Vector2i in station.service_cells():
        if _stations_by_service_cell.has(service_cell):
            return false
        _stations_by_service_cell[service_cell] = station
    return true
```

If current constructor cannot return failure, add `validation_errors()` or a deterministic configuration validity flag consumed by the session factory. Do not silently choose one station.

- [ ] **Step 5: Preserve contact transition order**

Keep current pickup transition first, then station service unload, then event snapshot. Do not change `Station.try_unload()` LIFO logic.

- [ ] **Step 6: Run delivery and full Godot tests**

Expected: cardinal-only delivery tests GREEN. Record any map/preflight migration failures for later tasks; do not hide them.

- [ ] **Step 7: Commit Task 2**

```bash
git add game/station game/finite/delivery game/finite/run tests/finite/delivery
git commit -m "feat: deliver cargo beside stations"
```

---

### Task 3: Scope preflight to the start-reachable RUN component

**Files:**
- Modify: `game/finite/build/preflight_validator.gd`
- Modify: `tests/fixtures/finite/preflight_fixtures.gd`
- Modify: `tests/finite/build/test_preflight_validator.gd`
- Modify any presenter/copy mapping for new preflight codes discovered by search.

**Interfaces:**
- New code: `UNREACHABLE_CARGO`
- New code: `UNREACHABLE_STATION_SERVICE`
- Existing graph/search state remains internal to `PreflightValidator`.

- [ ] **Step 1: Add RED fixtures**

Add fixture cases for:

```text
unreachable_cargo                  → UNREACHABLE_CARGO
station_service_cardinal_reachable → PASS
station_service_diagonal_only      → UNREACHABLE_STATION_SERVICE
disconnected_unused_island         → PASS
disconnected_required_cargo        → UNREACHABLE_CARGO
invalid_reachable_switch            → INVALID_SWITCH_EXIT
invalid_unreachable_island          → PASS
```

Keep the existing 100-repeat determinism check.

- [ ] **Step 2: Run tests and confirm RED**

Expected: current `_disconnected_required_cells()` and global crossing/switch scans conflict with new fixtures.

- [ ] **Step 3: Split cargo and station coverage validation**

Implement helpers equivalent to:

```gdscript
func _unreachable_cargo_cells(definition: Variant, reachable_cells: Dictionary) -> Array[Vector2i]
func _unserviceable_station_cells(definition: Variant, reachable_cells: Dictionary) -> Array[Vector2i]
```

For station failure, report the station footprint cell as `problem_cells`.

- [ ] **Step 4: Scope structural checks to reachable graph cells/states**

Crossing and switch cell validation should receive or derive `reachable_cells` and skip cells outside it. Trap checks already consume reachable traversal states; preserve that scope.

Do not delete unreachable pieces from the sealed layout or cost calculation. They are simply not RUN blockers.

- [ ] **Step 5: Preserve current product-route/open-terminal behavior**

Do not reintroduce `DANGLING_EDGE`/`PERMANENT_TRAP` rules on product maps that currently allow open terminals after required traversal. The new Decision changes global connectedness, not current route-end authority.

- [ ] **Step 6: Run preflight and full Godot suites**

Expected: new fixtures GREEN and previous reachable safety cases remain GREEN.

- [ ] **Step 7: Commit Task 3**

```bash
git add game/finite/build tests/finite/build tests/fixtures/finite
git commit -m "feat: validate reachable delivery network"
```

---

### Task 4: Remove station footprints from the rail graph

**Files:**
- Modify: `game/finite/rail/finite_track_graph_builder.gd`
- Modify: `tests/finite/rail/test_finite_track_graph.gd`
- Modify: `tests/gut/integration/test_one_sided_station_parity.gd`
- Modify: `tests/finite/integration/test_one_sided_station_terminal.gd` if still current.

**Interfaces:**
- A v3 station placement never produces a `TrackPiece`.
- Cargo remains on the contact network according to current map mode.

- [ ] **Step 1: Write RED graph test**

Assert a v3 station cell is absent from `graph.has_cell(station_cell)` while one chosen cardinal service track cell is present and traversable.

- [ ] **Step 2: Run and confirm RED**

Current builder may still conflate marker station/cargo anchor behavior.

- [ ] **Step 3: Split fixed-marker graph treatment**

Remove station placement from authored/player marker track insertion for v3. Preserve cargo graph behavior required by current maps.

- [ ] **Step 4: Rewrite one-sided-station integration semantics**

Replace exact station-terminal assertions with cardinal service assertions. Historical tests may be renamed only if all references are updated in the same change.

- [ ] **Step 5: Run full Godot suite**

Expected: graph + integration tests GREEN, with remaining failures limited to unmigrated active map data/copy.

- [ ] **Step 6: Commit Task 4**

```bash
git add game/finite/rail tests/finite/rail tests/finite/integration tests/gut/integration
git commit -m "feat: separate stations from rail graph"
```

---

### Task 5: Migrate all active finite maps and deterministic witnesses

**Files:**
- Modify: `data/maps/fp_core_proof_01.json`
- Modify: `data/maps/vs_demo_01.json`
- Modify: `data/maps/tutorial/tut_01_02.json`
- Modify: `data/maps/tutorial/tut_03_lifo.json`
- Modify: `data/maps/tutorial/tut_04_selective_load.json`
- Modify: `data/maps/tutorial/tut_05_auto_load.json`
- Modify: `data/maps/tutorial/tut_06_switch.json`
- Modify: every active witness/fixture that binds map revision, ruleset, layout signature, or solution identity discovered by repository search.

**Interfaces:**
- All current runtime-consumed finite maps use schema v3.
- Every station has at least one intended cardinal service track cell.
- Every first-session lesson remains demonstrable.

- [ ] **Step 1: Inventory active map consumers before editing**

Search exact current main for `data/maps/`, every map ID, `definition_schema_version`, `map_revision`, `ruleset_version`, and solution/witness signatures. Record all consumers in the implementation PR description.

- [ ] **Step 2: Migrate one map at a time with RED/GREEN witness updates**

For each map:

```text
bump schema to 3
→ move station footprint off-track
→ ensure cardinal service cell on intended route
→ preserve cargo order lesson
→ bump map revision
→ update ruleset if required
→ run map/witness tests
```

Do not bulk coordinate-shift without validating the route lesson.

- [ ] **Step 3: Explicitly validate T1/T2 and capstone**

T2 must visibly teach direct cargo contact versus adjacent station service. `VS_DEMO_01` must still require LIFO/switch reasoning rather than become a trivial shortest-route solution.

- [ ] **Step 4: Run full Godot suite after every logical map group**

Stop on witness mismatch and correct the map or witness from actual current behavior. Never update expected hashes/signatures blindly.

- [ ] **Step 5: Commit migrated content**

```bash
git add data/maps tests game/first_session
git commit -m "content: migrate finite maps to station service v3"
```

---

### Task 6: Add procedural service-range presentation using existing station assets

**Files:**
- Modify: `game/demo/presentation/product_board_renderer.gd`
- Modify: existing board-renderer test file discovered by repository search
- No files under `art/product_assets/**` are created or modified.

**Interfaces:**
- Produces test descriptor: `station_service_descriptors_for_test() -> Array[Dictionary]`
- Uses existing station texture keys `station_red`, `station_blue`, `station_yellow`.

- [ ] **Step 1: Write RED descriptor tests**

Given one station at `[3,3]`, assert descriptors expose exactly `[3,2], [4,3], [3,4], [2,3]` and no diagonal.

Also assert `PRODUCT_VISUAL_ASSET_PATHS` contains no new SX-DEC-060 bitmap key.

- [ ] **Step 2: Run renderer tests and confirm RED**

Expected: descriptor/draw pass does not exist.

- [ ] **Step 3: Implement procedural service-range draw pass**

Add a read-only helper and draw pass. Use static outline/corner ticks with low visual priority. The renderer may derive cells from snapshot station placement, but gameplay must not read this renderer result.

- [ ] **Step 4: Re-run visual semantic tests**

Verify station product textures remain loaded, color+shape+text identity remains, preflight problem emphasis remains stronger, and no raw key/placeholder is introduced.

- [ ] **Step 5: Commit presentation change**

```bash
git add game/demo/presentation tests
git commit -m "ui: show cardinal station service range"
```

---

### Task 7: Update first-session copy and localization for the new mental model

**Files:**
- Modify: `game/first_session/first_session_copy.gd`
- Modify: `tests/first_session/test_first_session_copy.gd`
- Modify any first-session definition/policy file only if current copy keys require it.

**Interfaces:**
- Supported current locales stay `ko / en / ja / zh-Hans`.
- No raw localization key may reach player-facing UI.

- [ ] **Step 1: Add RED semantic copy tests**

Ensure T2 copy in all four locales communicates the two distinct contacts:

```text
cargo = pass through the cargo tile
station = pass beside it in one of four directions
```

Tests should assert key availability/fallback and semantic tokens owned by the current test style, not brittle full prose unless the suite already uses exact strings.

- [ ] **Step 2: Run tests and confirm RED**

- [ ] **Step 3: Update copy without adding a new tutorial stage**

T2 teaches station service; T3 remains LIFO. Do not expand T1→T6 scope.

- [ ] **Step 4: Run first-session tests**

Expected: all locale/copy contracts GREEN with no raw key.

- [ ] **Step 5: Commit copy change**

```bash
git add game/first_session tests/first_session
git commit -m "content: teach adjacent station delivery"
```

---

### Task 8: Reconcile structured current canon after runtime behavior is GREEN

**Files:**
- Modify: `기획서/00_프로젝트_허브/FINITE_DELIVERY_PUZZLE_BASELINE.md`
- Modify: `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
- Modify: `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
- Modify: `기획서/00_프로젝트_허브/START_HERE.md`
- Modify: `기획서/00_프로젝트_허브/ROADMAP.md`
- Modify: `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md`
- Modify: `기획서/20_시스템_콘텐츠/CORE_SYSTEMS.md` and/or `기획서/10_경험/CORE_GAMEPLAY.md` only where they actively own the superseded rule.
- Modify: `skills/switchy-express-design/SKILL.md`
- Test: add/update Python canonical-freshness contract for SX-DEC-060.

**Interfaces:**
- Current decision span becomes `SX-DEC-027~060`.
- Runtime status is promoted only to the evidence actually obtained in Tasks 1–7.

- [ ] **Step 1: Write/update canonical freshness test first**

The test should fail if current owner docs still claim exact-station delivery, all-station-anchor connectivity, Candidate 003 as current post-change validation target, or Decision span ending at 059.

- [ ] **Step 2: Run the canonical test and confirm RED**

- [ ] **Step 3: Update only active current owners**

Historical SX-DEC-059 plans/audits/candidate records remain unchanged as provenance. Current docs explain that Candidate 003 is pre-060 historical evidence.

- [ ] **Step 4: Re-run canonical freshness and static project contracts**

```bash
python tools/validate_project_contract.py
python tests/python/test_v48_current_authority_migration.py -v
# plus the exact new/updated SX-DEC-060 freshness test
```

Expected: GREEN. Do not rewrite unrelated history just to remove old phrases.

- [ ] **Step 5: Commit current canon reconciliation**

```bash
git add 기획서 skills tests/python
git commit -m "docs: reconcile SX-DEC-060 runtime authority"
```

---

### Task 9: Full regression, package proof, and evidence-safe candidate transition

**Files:**
- Modify only existing evidence/candidate owners required by the current package workflow.
- Do not overwrite Candidate 003 records.

**Interfaces:**
- A new post-060 candidate identity is required if packaging succeeds.
- Package/CI PASS does not imply physical/device/human PASS.

- [ ] **Step 1: Run full headless Godot regression**

```bash
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tests/run_tests.gd
```

Record exact assertion/case counts from output.

- [ ] **Step 2: Run all current project Python/static contracts**

Use repository/current CI workflow commands rather than inventing a subset. Record exact commands and results.

- [ ] **Step 3: Validate all migrated map identities/witnesses from exact HEAD**

No expected hash/signature may be changed without demonstrating why the new bytes are the intended v3 puzzle.

- [ ] **Step 4: Build/package through current official workflow**

If package proof is GREEN, mint a new post-060 candidate ID. Preserve Candidate 003 unchanged as historical pre-060 evidence.

- [ ] **Step 5: Keep evidence ceiling exact**

At this point allowed claims can include automated/package facts actually run. Keep these `NOT_RUN` until physically performed:

```text
Windows physical runtime
Android physical device
Audio perceptual QA
Five-person comprehension
Player experience
```

- [ ] **Step 6: Commit evidence pointer changes if required**

Use exact generated candidate IDs/hashes from the official workflow; do not hand-invent them.

---

### Task 10: Five-pass adversarial review and merge gate

**Files:**
- Modify only files required to fix findings.
- Record review evidence in the current SX-DEC-060 audit/handoff owner if project convention requires it.

- [ ] **Step 1: Pass 1 — semantic truth**

Attack exact-cardinal math, diagonal exclusion, station-cell exclusion, cargo direct contact, LIFO preservation, and current outcome semantics.

- [ ] **Step 2: Pass 2 — topology/preflight**

Attack reachable/unreachable component boundaries, invalid reachable switches/crossings, disconnected required cargo, station service coverage, and deterministic error cells.

- [ ] **Step 3: Pass 3 — data/migration**

Attack schema v2/v3 confusion, active map inventory completeness, map revisions/ruleset/identity, witness freshness, and Retry identity.

- [ ] **Step 4: Pass 4 — UX/assets/localization**

Attack station range readability, overlap with track/cargo/train/preflight/switch overlays, color-only dependence, raw keys, missing locale parity, and accidental new bitmap assets.

- [ ] **Step 5: Pass 5 — governance/evidence**

Attack stale current docs, accidental 056–058 absorption, Candidate 003 evidence inflation, PR #174 mutation, Base repin, Notion mismatch, and unrun physical/human PASS claims.

- [ ] **Step 6: Re-run exact-head tests after the final fix**

Do not treat tests from an earlier commit as final-head evidence.

- [ ] **Step 7: Update current task PR and merge only if all required checks/rulesets are clean**

After merge, re-fetch project `main`, current Decision owners, and Notion before declaring `MERGED_MAIN_VERIFIED`.

---

## Self-review result

- Spec coverage: cardinal delivery, off-track station, reachable network, data migration, delivery, preflight, graph, presentation, copy, current canon, packaging, evidence, and adversarial review all have explicit tasks.
- Placeholder scan: no `TBD`, `TODO`, or unspecified "write tests" step remains.
- Type consistency: station service helper names and `Vector2i` contracts are consistent between design and tasks. `handle_cell_entered()` remains the runtime contact boundary.
- YAGNI check: arbitrary range/diagonal/multi-station priority/new bitmap remain excluded.

## Execution handoff

Implementation is ready for the project Codex Godot product implementation route after this canon package is merged and Notion readback is synchronized. Codex must fresh-read merged `main` and the exact project Notion Home before executing Task 1.
