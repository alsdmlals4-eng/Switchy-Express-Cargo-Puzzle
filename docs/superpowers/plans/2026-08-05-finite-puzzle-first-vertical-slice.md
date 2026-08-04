# Finite Puzzle First Vertical Slice Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the approved `FP-01 + FP-02` minimum playable Vertical Slice in which a player constructs rails, controls loading and switches, solves LIFO delivery order, and succeeds or fails under a finite clock.

**Architecture:** Keep the current endless runtime intact while a new finite runtime is built under `game/finite/`. Reuse only stable movement and station semantics through narrow interfaces. Represent rail traversal by `(previous_cell, current_cell)` so crossings remain independent and switches persist until changed. Cut over `game/main/main.tscn` only after all automated, Android, and human gates pass.

**Tech Stack:** Godot `4.7.1-stable`, GDScript, JSON authored map data, the repository's custom `TestCase` headless harness, Android landscape `1920×1080` reference viewport.

## Global Constraints

- Product authority: `GMB-002 · SX-DEC-027~036`.
- Approved DoR: `FP-DOR-001`, evidence `EV-USER-020`.
- LIFO is a hard constraint; FIFO is forbidden.
- Cargo and stations use color plus shape, never color alone.
- Build time is paused; track editing during a run is forbidden.
- First Slice track geometries are `STRAIGHT`, `CURVE`, `SWITCH`, and `CROSSING` only.
- First Slice excludes acceleration, economy, one-way, turnaround, bridge, tunnel, Combo rewards, stars, leaderboards, tutorial chapters, daily/weekly services, UGC, and final art.
- All balance numbers remain `TEST_VALUE`.
- Legacy fuel, BOOST, capacity 8, cargo slowdown, respawn, difficulty pressure, and switch auto-reset must not influence finite results.
- Existing endless tests remain historical regression tests and must not be counted as finite-product evidence.
- New files use focused responsibilities; do not add future hooks for excluded features.
- Every task follows red → green → refactor and ends with a commit.
- Full test command:

```bash
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tests/run_tests.gd
```

- CI must also pass `.github/workflows/project-contract.yml` and `.github/workflows/godot-tests.yml`.

---

## PR and Review Sequence

| PR | Tasks | Merge condition |
|---|---|---|
| `FP-01A` | 1–3 | authored identity, layout, and editing tests pass |
| `FP-01B` | 4–5 | traversal and preflight adversarial tests pass |
| `FP-01C` | 6 | proof map and build-domain acceptance pass |
| `FP-02A` | 7–8 | fixed loading and unlimited LIFO pass |
| `FP-02B` | 9–10 | finite clock, unload, retry, and pause pass |
| `FP-02C` | 11–12 | playable surface, acceptance, device/human evidence, and cutover pass |

Do not combine PRs merely to reduce review count. Each PR must be independently revertible.

---

### Task 1: Add Authored MapDefinition v2

**Files:**
- Create: `game/finite/map/finite_map_definition.gd`
- Create: `tests/finite/map/test_finite_map_definition.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Consumes: plain `Dictionary` loaded from authored JSON.
- Produces: `FiniteMapDefinition.create(data: Dictionary) -> Variant`, `validation_errors() -> Array[String]`, `identity_key() -> String`, `required_anchor_cells() -> Array[Vector2i]`, `to_dictionary() -> Dictionary`.

- [ ] **Step 1: Register a failing test**

Add this preload to `tests/run_tests.gd` immediately after the existing map tests:

```gdscript
preload("res://tests/finite/map/test_finite_map_definition.gd"),
```

Create the test with these required assertions:

```gdscript
extends "res://tests/test_case.gd"

const DEFINITION_PATH := "res://game/finite/map/finite_map_definition.gd"

func run() -> void:
    assert_true(ResourceLoader.exists(DEFINITION_PATH, "Script"), "finite map definition must exist")
    if not ResourceLoader.exists(DEFINITION_PATH, "Script"):
        return
    var script: Script = load(DEFINITION_PATH)
    var definition: Variant = script.create({
        "definition_schema_version": 2,
        "map_id": "FP_TEST",
        "map_revision": 1,
        "ruleset_version": "fp_core_v1",
        "board_size": [7, 5],
        "start_cell": [1, 2],
        "incoming_cell": [0, 2],
        "buildable_cells": [[2, 1], [2, 2], [2, 3]],
        "blocked_cells": [[4, 2]],
        "station_placements": [{
            "cell": [5, 1],
            "cargo_type": "RED_STAR",
            "rail_anchor": {"geometry": "STRAIGHT", "rotation_quarters": 0}
        }],
        "cargo_placements": [{
            "cell": [3, 1],
            "cargo_type": "RED_STAR",
            "rail_anchor": {"geometry": "STRAIGHT", "rotation_quarters": 0}
        }],
        "time_limit_seconds": 90.0
    })
    assert_equal(definition.validation_errors(), [], "valid authored definition must pass")
    assert_equal(definition.identity_key(), "FP_TEST@1", "map identity must exclude player layout")
    assert_equal(definition.definition_schema_version, 2, "finite pipeline must require schema v2")
    assert_equal(definition.required_anchor_cells().size(), 4, "start, incoming, station, and cargo anchors are required")

    var legacy: Variant = script.create({"definition_schema_version": 1})
    assert_true(legacy.validation_errors().has("definition_schema_version must equal 2"), "schema v1 must not be silently upgraded")
```

- [ ] **Step 2: Run the test and verify red**

Run the full test command. Expected: script load failure for `finite_map_definition.gd` or the new test reports failure.

- [ ] **Step 3: Implement the minimal class**

Use this public shape:

```gdscript
class_name FiniteMapDefinition
extends RefCounted

const SCHEMA_VERSION := 2

var definition_schema_version: int = 0
var map_id: StringName = &""
var map_revision: int = 0
var ruleset_version: StringName = &""
var board_size: Vector2i = Vector2i.ZERO
var start_cell: Vector2i = Vector2i.ZERO
var incoming_cell: Vector2i = Vector2i.ZERO
var buildable_cells: Array[Vector2i] = []
var blocked_cells: Array[Vector2i] = []
var station_placements: Array[Dictionary] = []
var cargo_placements: Array[Dictionary] = []
var time_limit_seconds: float = 0.0

static func create(data: Dictionary) -> FiniteMapDefinition:
    var value := FiniteMapDefinition.new()
    value.definition_schema_version = int(data.get("definition_schema_version", 0))
    value.map_id = StringName(data.get("map_id", &""))
    value.map_revision = int(data.get("map_revision", 0))
    value.ruleset_version = StringName(data.get("ruleset_version", &""))
    value.board_size = _read_cell(data.get("board_size", []))
    value.start_cell = _read_cell(data.get("start_cell", []))
    value.incoming_cell = _read_cell(data.get("incoming_cell", []))
    value.buildable_cells = _read_cells(data.get("buildable_cells", []))
    value.blocked_cells = _read_cells(data.get("blocked_cells", []))
    value.station_placements = data.get("station_placements", []).duplicate(true)
    value.cargo_placements = data.get("cargo_placements", []).duplicate(true)
    value.time_limit_seconds = float(data.get("time_limit_seconds", 0.0))
    return value

func identity_key() -> String:
    return "%s@%d" % [map_id, map_revision]
```

Validation must reject: schema other than 2, empty IDs, non-positive revision, empty ruleset, non-positive board size/time, equal start/incoming cells, cells outside the board, duplicate authored placements, buildable/blocked overlap, missing or invalid cargo type, and missing anchor geometry/rotation.

- [ ] **Step 4: Run tests and verify green**

Expected: all existing tests and `test_finite_map_definition.gd` pass.

- [ ] **Step 5: Commit**

```bash
git add game/finite/map/finite_map_definition.gd tests/finite/map/test_finite_map_definition.gd tests/run_tests.gd
git commit -m "feat: add finite authored map identity"
```

---

### Task 2: Add TrackPiece and TrackLayout Identity

**Files:**
- Create: `game/finite/build/track_piece.gd`
- Create: `game/finite/build/track_layout.gd`
- Create: `tests/finite/build/test_track_layout.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Consumes: player piece definitions.
- Produces: `TrackPiece.create(cell, geometry, rotation_quarters, switch_initial_exit)`, `ports()`, `approach_port()`, `switch_exits()`, and `TrackLayout.put_piece()`, `remove_piece()`, `piece_at()`, `pieces()`, `build_cost()`, `canonical_string()`, `layout_signature()`, `duplicate_layout()`.

- [ ] **Step 1: Write failing identity and cost tests**

Test exact rules:

```gdscript
var straight: Variant = piece_script.create(Vector2i(2, 2), &"STRAIGHT", 0, Vector2i.ZERO)
var curve: Variant = piece_script.create(Vector2i(3, 2), &"CURVE", 1, Vector2i.ZERO)
var switch_piece: Variant = piece_script.create(Vector2i(4, 2), &"SWITCH", 0, Vector2i.RIGHT)
var crossing: Variant = piece_script.create(Vector2i(5, 2), &"CROSSING", 0, Vector2i.ZERO)

var first: Variant = layout_script.new()
assert_true(first.put_piece(switch_piece), "switch must be accepted")
assert_true(first.put_piece(straight), "straight must be accepted")
assert_true(first.put_piece(curve), "curve must be accepted")
assert_true(first.put_piece(crossing), "crossing must be accepted")
assert_equal(first.build_cost(), 600, "100+100+200+200 test values must sum")

var second: Variant = layout_script.new()
second.put_piece(crossing)
second.put_piece(curve)
second.put_piece(straight)
second.put_piece(switch_piece)
assert_equal(first.layout_signature(), second.layout_signature(), "installation order must not affect identity")

var changed: Variant = second.duplicate_layout()
changed.put_piece(piece_script.create(Vector2i(3, 2), &"CURVE", 2, Vector2i.ZERO))
assert_not_equal(first.layout_signature(), changed.layout_signature(), "rotation must affect identity")
```

- [ ] **Step 2: Run and verify red**

Expected: missing `track_piece.gd` or `track_layout.gd`.

- [ ] **Step 3: Implement exact geometry rules**

Use cardinal rotation helpers. Base geometry at rotation 0:

```gdscript
STRAIGHT: [Vector2i.LEFT, Vector2i.RIGHT]
CURVE: [Vector2i.UP, Vector2i.RIGHT]
SWITCH: approach Vector2i.LEFT, exits [Vector2i.RIGHT, Vector2i.UP]
CROSSING: [Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT]
```

Rotate every port clockwise `rotation_quarters` times. `CROSSING` canonicalizes rotation to `0`; `STRAIGHT` canonicalizes to `0` or `1`. Reject invalid geometry, invalid rotation, and a switch exit not contained in the rotated exit set.

`TrackLayout.canonical_string()` must sort by `y`, then `x`, then geometry and serialize:

```text
x,y:GEOMETRY:rotation:switch_exit_x,switch_exit_y
```

Hash with `HashingContext.HASH_SHA256`.

- [ ] **Step 4: Run and verify green**

Also run the test 100 times in a loop and assert one signature value.

- [ ] **Step 5: Commit**

```bash
git add game/finite/build/track_piece.gd game/finite/build/track_layout.gd tests/finite/build/test_track_layout.gd tests/run_tests.gd
git commit -m "feat: add finite track layout identity"
```

---

### Task 3: Add Transactional Track Editing

**Files:**
- Create: `game/finite/build/track_edit_result.gd`
- Create: `game/finite/build/track_layout_editor.gd`
- Create: `tests/finite/build/test_track_layout_editor.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Consumes: `FiniteMapDefinition`, `TrackLayout`, requested edit command.
- Produces: `place_piece(piece)`, `rotate_piece(cell, delta_quarters)`, `replace_piece(piece)`, `remove_piece(cell)`, `clear_layout()`, each returning `TrackEditResult` with `success`, `code`, `message`, `affected_cells`, `cost_before`, and `cost_after`.

- [ ] **Step 1: Write failing transactional tests**

Cover these cases:

```gdscript
var editor: Variant = editor_script.new(definition, layout)
var before_signature: String = layout.layout_signature()
var invalid: Variant = editor.place_piece(piece_script.create(Vector2i(4, 2), &"STRAIGHT", 0, Vector2i.ZERO))
assert_false(invalid.success, "blocked cell placement must fail")
assert_equal(invalid.code, &"BLOCKED_CELL", "blocked reason must be stable")
assert_equal(layout.layout_signature(), before_signature, "failed edit must not mutate layout")

var placed: Variant = editor.place_piece(piece_script.create(Vector2i(2, 2), &"STRAIGHT", 0, Vector2i.ZERO))
assert_true(placed.success, "buildable placement must pass")
assert_equal(placed.cost_after, 100, "place must add current cost")

var removed: Variant = editor.remove_piece(Vector2i(2, 2))
assert_true(removed.success, "remove must pass")
assert_equal(removed.cost_after, 0, "remove must fully refund")
```

Also test duplicate placement, authored anchor edits, out-of-board cells, invalid rotations, replacement cost delta, and clear-layout refund.

- [ ] **Step 2: Run and verify red**

- [ ] **Step 3: Implement command validation before mutation**

`TrackLayoutEditor` must validate the full command first, then mutate once. Use codes:

```text
PASS
OUTSIDE_BOARD
NOT_BUILDABLE
BLOCKED_CELL
AUTHORED_ANCHOR
OCCUPIED_CELL
EMPTY_CELL
INVALID_PIECE
```

No command records cumulative spending.

- [ ] **Step 4: Run and verify green**

- [ ] **Step 5: Commit**

```bash
git add game/finite/build/track_edit_result.gd game/finite/build/track_layout_editor.gd tests/finite/build/test_track_layout_editor.gd tests/run_tests.gd
git commit -m "feat: add transactional track editing"
```

---

### Task 4: Build an Entry-Direction-Aware FiniteTrackGraph

**Files:**
- Create: `game/finite/rail/finite_track_switch.gd`
- Create: `game/finite/rail/finite_track_graph.gd`
- Create: `game/finite/rail/finite_track_graph_builder.gd`
- Create: `tests/finite/rail/test_finite_track_graph.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Consumes: authored anchor pieces plus `TrackLayout`.
- Produces a graph compatible with the stable movement subset: `has_cell()`, `neighbors()`, `next_cell(current, previous)`, `preview_route()`, `switch_cells()`, `cycle_switch(cell) -> bool`, `set_switch_locked_cell(cell)`, `reset_switch_states()`, `commit_switch_passage(cell)` as a no-op.

- [ ] **Step 1: Write failing traversal tests**

Required crossing proof:

```gdscript
assert_equal(graph.next_cell(Vector2i(3, 3), Vector2i(2, 3)), Vector2i(4, 3), "west entry must exit east")
assert_equal(graph.next_cell(Vector2i(3, 3), Vector2i(3, 2)), Vector2i(3, 4), "north entry must exit south")
```

Required switch proof:

```gdscript
var first_exit: Vector2i = graph.next_cell(switch_cell, approach_cell)
assert_true(graph.cycle_switch(switch_cell), "unoccupied switch must cycle")
var second_exit: Vector2i = graph.next_cell(switch_cell, approach_cell)
assert_not_equal(first_exit, second_exit, "switch state must change")
graph.commit_switch_passage(switch_cell)
assert_equal(graph.next_cell(switch_cell, approach_cell), second_exit, "passage must not auto-reset")
graph.set_switch_locked_cell(switch_cell)
assert_false(graph.cycle_switch(switch_cell), "occupied switch must lock")
```

Also assert that entering a switch from either exit merges to the approach and never crosses to the other exit.

- [ ] **Step 2: Run and verify red**

- [ ] **Step 3: Implement traversal by incoming direction**

Do not model crossing as a four-way junction. Store piece geometry by cell and compute the next cell from the incoming port.

```gdscript
func next_cell(current: Vector2i, previous: Vector2i) -> Vector2i:
    var piece: Variant = _pieces_by_cell.get(current)
    var incoming_port: Vector2i = previous - current
    match piece.geometry:
        &"STRAIGHT", &"CURVE":
            return current + _other_port(piece.ports(), incoming_port)
        &"CROSSING":
            return current - incoming_port
        &"SWITCH":
            return current + _switches[current].exit_for(incoming_port)
    return current
```

`neighbors()` may return all physically connected port neighbors for compatibility, but `next_cell()` and structural validation remain entry-direction aware.

- [ ] **Step 4: Run and verify green**

Retain existing `TrainController` tests unchanged. Do not modify `game/rail/rail_graph.gd` or `game/rail/rail_switch.gd` in this task.

- [ ] **Step 5: Commit**

```bash
git add game/finite/rail tests/finite/rail/test_finite_track_graph.gd tests/run_tests.gd
git commit -m "feat: add finite rail traversal graph"
```

---

### Task 5: Add Structural Preflight Validation

**Files:**
- Create: `game/finite/build/preflight_result.gd`
- Create: `game/finite/build/preflight_validator.gd`
- Create: `tests/finite/build/test_preflight_validator.gd`
- Create: `tests/fixtures/finite/preflight_fixtures.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Consumes: `FiniteMapDefinition`, `TrackLayout`, `FiniteTrackGraphBuilder`.
- Produces: `validate(definition, layout) -> PreflightResult` with `passed`, `primary_code`, `problem_cells`, `message`, and `graph` only when passed.

- [ ] **Step 1: Write one failing test per result code**

Fixture names and expected codes:

```text
empty_layout → EMPTY_LAYOUT
invalid_start → INVALID_START
dangling_edge → DANGLING_EDGE
disconnected_required_point → DISCONNECTED_REQUIRED_POINT
crossing_turned_as_junction → INVALID_CROSSING
switch_exit_dead_end → INVALID_SWITCH_EXIT
reachable_degree_one → PERMANENT_TRAP
closed_valid_network → PASS
```

Assert deterministic primary-code priority in the listed order and sorted unique problem cells.

- [ ] **Step 2: Run and verify red**

- [ ] **Step 3: Implement a traversal-state search**

Use state `(previous_cell, current_cell)`, not cell-only connectivity. For structural reachability, a switch approached from its approach port exposes both exits; an exit entry exposes only the approach. A crossing exposes only the opposite port.

```gdscript
func _state_key(previous: Vector2i, current: Vector2i) -> String:
    return "%d,%d>%d,%d" % [previous.x, previous.y, current.x, current.y]
```

Reject any reachable non-terminal traversal state with zero legal forward successors. Since the first Slice has no terminal, every reachable route must remain in a closed network.

The validator must not inspect cargo order, loading timing, switch input sequence, time feasibility, cost optimum, or unload group optimum.

- [ ] **Step 4: Run and verify green**

Run every fixture 100 times and assert identical result codes and cell order.

- [ ] **Step 5: Commit**

```bash
git add game/finite/build/preflight_result.gd game/finite/build/preflight_validator.gd tests/finite/build/test_preflight_validator.gd tests/fixtures/finite/preflight_fixtures.gd tests/run_tests.gd
git commit -m "feat: validate finite track layouts"
```

---

### Task 6: Author FP_CORE_PROOF_01 and the Build Domain Harness

**Files:**
- Create: `data/maps/fp_core_proof_01.json`
- Create: `game/finite/map/finite_map_loader.gd`
- Create: `game/finite/build/finite_build_session.gd`
- Create: `tests/finite/map/test_fp_core_proof_map.gd`
- Create: `tests/finite/integration/test_finite_build_session.gd`
- Create: `tests/fixtures/finite/fp_core_solution_alpha.gd`
- Create: `tests/fixtures/finite/fp_core_solution_beta.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Consumes: authored JSON and edit commands.
- Produces: a deterministic `FiniteMapDefinition`, mutable `TrackLayout`, current cost, current preflight result, and `seal_for_run() -> Dictionary` containing immutable definition/layout/signatures.

- [ ] **Step 1: Write the authored-map acceptance test**

Assert the loaded map has:

```text
map_id FP_CORE_PROOF_01
schema 2
ruleset fp_core_v1
four cargo placements in authored order A, B, A, A
one A station and one B station
at least one switch opportunity
at least one crossing opportunity
at least four blocked cells
time limit 90.0 TEST_VALUE
```

Load `fp_core_solution_alpha.gd` and `fp_core_solution_beta.gd`, build each layout, and assert both preflight PASS with different layout signatures.

- [ ] **Step 2: Run and verify red**

- [ ] **Step 3: Write the exact authored data contract**

The JSON must use these top-level values:

```json
{
  "definition_schema_version": 2,
  "map_id": "FP_CORE_PROOF_01",
  "map_revision": 1,
  "ruleset_version": "fp_core_v1",
  "board_size": [11, 9],
  "start_cell": [1, 4],
  "incoming_cell": [0, 4],
  "time_limit_seconds": 90.0,
  "blocked_cells": [[4, 3], [4, 4], [4, 5], [6, 3], [6, 5]],
  "station_placements": [
    {"cell": [9, 2], "cargo_type": "RED_STAR", "rail_anchor": {"geometry": "STRAIGHT", "rotation_quarters": 0}},
    {"cell": [9, 6], "cargo_type": "BLUE_DIAMOND", "rail_anchor": {"geometry": "STRAIGHT", "rotation_quarters": 0}}
  ],
  "cargo_placements": [
    {"cell": [3, 2], "cargo_type": "RED_STAR", "rail_anchor": {"geometry": "STRAIGHT", "rotation_quarters": 0}},
    {"cell": [5, 4], "cargo_type": "BLUE_DIAMOND", "rail_anchor": {"geometry": "STRAIGHT", "rotation_quarters": 0}},
    {"cell": [7, 6], "cargo_type": "RED_STAR", "rail_anchor": {"geometry": "STRAIGHT", "rotation_quarters": 0}},
    {"cell": [7, 2], "cargo_type": "RED_STAR", "rail_anchor": {"geometry": "STRAIGHT", "rotation_quarters": 0}}
  ]
}
```

The loader may expand authoring rectangles into canonical `buildable_cells`, but `FiniteMapDefinition` must store only the expanded cell list. Exclude blocked and authored-anchor cells from editable cells.

The two solution fixtures are test-only explicit piece arrays. They must produce different signatures and both preserve the A/B/A/A revisit possibility. Adjust fixture pieces, not product rules, until both pass.

- [ ] **Step 4: Implement and verify green**

`FiniteBuildSession.seal_for_run()` must refuse when preflight is not PASS and must duplicate the layout so later edits cannot mutate a running attempt.

- [ ] **Step 5: Commit**

```bash
git add data/maps/fp_core_proof_01.json game/finite/map/finite_map_loader.gd game/finite/build/finite_build_session.gd tests/finite/map/test_fp_core_proof_map.gd tests/finite/integration/test_finite_build_session.gd tests/fixtures/finite tests/run_tests.gd
git commit -m "feat: add finite core proof build session"
```

---

### Task 7: Add Finite Loading Input and Unlimited CargoStack

**Files:**
- Create: `game/finite/input/finite_gameplay_input_state.gd`
- Create: `game/finite/cargo/unlimited_cargo_stack.gd`
- Create: `tests/finite/input/test_finite_gameplay_input_state.gd`
- Create: `tests/finite/cargo/test_unlimited_cargo_stack.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Consumes: load-button press/release and auto-load toggle.
- Produces: `is_manual_load_active()`, `is_auto_load_enabled()`, `should_load_on_contact()`, `set_paused()`, and unlimited stack methods `push()`, `peek()`, `pop_matching_group()`, `load_order()`, `unload_order()`, `size()`, `clear()`.

- [ ] **Step 1: Write failing input tests**

```gdscript
var input: Variant = input_script.new()
assert_false(input.should_load_on_contact(), "manual load defaults inactive")
input.set_manual_load_active(true)
assert_true(input.should_load_on_contact(), "hold must load")
input.set_manual_load_active(false)
input.toggle_auto_load()
assert_true(input.should_load_on_contact(), "auto mode must load without hold")
input.set_paused(true)
assert_false(input.should_load_on_contact(), "pause must suppress contact input")
assert_false(input.toggle_auto_load(), "pause must reject mode changes")
```

- [ ] **Step 2: Write failing 32-cargo LIFO tests**

Push 32 alternating valid cargo types, assert size 32, no `capacity` property, correct TOP, correct unload order, and matching-group pop behavior. Invalid cargo types must still be rejected.

- [ ] **Step 3: Run and verify red**

- [ ] **Step 4: Implement without touching legacy input/stack**

Do not modify `game/input/gameplay_input_state.gd` or `game/cargo/cargo_stack.gd`. The finite classes must not expose BOOST or capacity.

```gdscript
func should_load_on_contact() -> bool:
    return not _paused and (_auto_load_enabled or _manual_load_active)
```

- [ ] **Step 5: Run, commit, and preserve legacy regression tests**

```bash
git add game/finite/input game/finite/cargo tests/finite/input tests/finite/cargo tests/run_tests.gd
git commit -m "feat: add finite loading and unlimited lifo"
```

---

### Task 8: Add Fixed CargoField and FiniteDeliveryLoop

**Files:**
- Create: `game/finite/cargo/fixed_cargo_field.gd`
- Create: `game/finite/delivery/finite_delivery_event.gd`
- Create: `game/finite/delivery/finite_delivery_loop.gd`
- Create: `tests/finite/cargo/test_fixed_cargo_field.gd`
- Create: `tests/finite/delivery/test_finite_delivery_loop.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Consumes: train cell entry, fixed cargo placements, finite input, unlimited stack, existing `Station` objects.
- Produces: immutable delivery events with `cell`, `event_time`, `picked_up`, `pickup_type`, `unload_count`, `unloaded_items`, `remaining_map_cargo`, and `stack_size`.

- [ ] **Step 1: Write failing fixed-field tests**

Assert cargo remains when manual hold is inactive, disappears once loaded, and never respawns after arbitrary time progression. Assert field reset restores the authored set.

- [ ] **Step 2: Write failing delivery tests**

Use contact order `A, B, A, A` and assert:

```text
stack [A, B, A, A TOP]
A station unload_count 2
B station unload_count 1
A station unload_count 1
```

Assert mismatched station contact produces `unload_count == 0` and no stop request.

- [ ] **Step 3: Run and verify red**

- [ ] **Step 4: Implement event-only domain logic**

`FiniteDeliveryLoop.handle_cell_entered(cell, event_time)` performs contact decisions only. It does not advance time, spawn cargo, award fuel, award score, or animate.

```gdscript
if _cargo_field.has_cargo(cell) and _input_state.should_load_on_contact():
    var cargo_type: StringName = _cargo_field.collect(cell)
    _cargo_stack.push(cargo_type)

if _stations_by_cell.has(cell):
    var result: Dictionary = _stations_by_cell[cell].try_unload(_cargo_stack)
```

Reuse `game/station/station.gd` unchanged.

- [ ] **Step 5: Run and commit**

```bash
git add game/finite/cargo/fixed_cargo_field.gd game/finite/delivery tests/finite/cargo/test_fixed_cargo_field.gd tests/finite/delivery/test_finite_delivery_loop.gd tests/run_tests.gd
git commit -m "feat: add fixed finite delivery contacts"
```

---

### Task 9: Add Finite Run State, Clock, Unload Sequence, and Seals

**Files:**
- Create: `game/finite/run/finite_run_state.gd`
- Create: `game/finite/run/unload_sequence.gd`
- Create: `game/finite/run/finite_run_summary.gd`
- Create: `game/finite/run/finite_run_controller.gd`
- Create: `tests/finite/run/test_finite_run_state.gd`
- Create: `tests/finite/run/test_unload_sequence.gd`
- Create: `tests/finite/run/test_finite_run_controller.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Consumes: stable `TrainController`, `FiniteDeliveryLoop`, finite input, map time limit and authored total cargo.
- Produces: states `READY`, `RUNNING`, `UNLOADING`, `PAUSED`, `SUCCESS`, `FAILURE`; `advance_time(delta)`, `pause()`, `resume()`, and a frozen summary.

- [ ] **Step 1: Write failing state-machine tests**

Assert valid transitions only:

```text
READY → RUNNING
RUNNING → PAUSED → RUNNING
RUNNING → UNLOADING
UNLOADING → PAUSED → UNLOADING
RUNNING|UNLOADING → SUCCESS|FAILURE
SUCCESS|FAILURE reject all mutation
```

- [ ] **Step 2: Write exact timing tests**

Required cases:

```text
last unload commit at 89.999 with 90.0 limit → pending SUCCESS, shown after animation
last unload commit at 90.000 with 90.0 limit → pending SUCCESS
last unload commit at 90.001 with 90.0 limit → FAILURE
pause during unload → clock and unload remaining unchanged
32-item unload → total duration > 0 and <= 1.0
mismatched station → train speed unchanged and no UNLOADING state
```

- [ ] **Step 3: Run and verify red**

- [ ] **Step 4: Implement segmented time advancement**

Remove all finite dependencies on `RunBalance`, `DifficultyDirector`, fuel, BOOST, cargo slowdown, and endless summary.

Use:

```gdscript
unload_duration = minf(1.0, maxf(0.12, 0.08 * float(unload_count)))
```

This is a `TEST_VALUE`; every cargo remains represented by the view sequence while the domain pop is already committed.

At a final unload event, store `final_delivery_commit_time`. Success eligibility uses that timestamp; presentation waits for `UnloadSequence` completion.

- [ ] **Step 5: Run and commit**

```bash
git add game/finite/run tests/finite/run tests/run_tests.gd
git commit -m "feat: add finite run lifecycle"
```

---

### Task 10: Add Attempt Identity, Same-Layout Retry, and Reset Integrity

**Files:**
- Create: `game/finite/run/finite_solution_identity.gd`
- Create: `game/finite/run/finite_run_session.gd`
- Create: `game/finite/run/finite_run_session_factory.gd`
- Create: `tests/finite/run/test_finite_solution_identity.gd`
- Create: `tests/finite/integration/test_failed_run_preserves_layout.gd`
- Create: `tests/finite/integration/test_solution_identity_retry.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Consumes: sealed build result and attempt serial.
- Produces: `map_identity`, `solution_identity`, `attempt_identity`, fresh runtime objects, and preserved immutable TrackLayout for retries.

- [ ] **Step 1: Write failing identity tests**

```gdscript
assert_equal(first.solution_identity, second.solution_identity, "same map and layout must keep solution identity")
assert_not_equal(first.attempt_identity, second.attempt_identity, "retry must increment attempt identity")
```

Changing map revision, ruleset version, geometry, rotation, or switch initial exit must change solution identity. Changing edit history without changing final pieces must not.

- [ ] **Step 2: Write failing reset tests**

After failure, assert:

```text
same MapDefinition object value
same TrackLayout signature
fresh train position
fresh fixed cargo field
empty stack
initial switch states
clock 0
manual mode with auto off
```

- [ ] **Step 3: Run and verify red**

- [ ] **Step 4: Implement factory-owned runtime recreation**

The factory receives duplicated sealed inputs and constructs new graph, train, field, stack, input, loop, state, and controller for every attempt. It must never reuse mutable run objects.

- [ ] **Step 5: Run and commit**

```bash
git add game/finite/run tests/finite/run/test_finite_solution_identity.gd tests/finite/integration/test_failed_run_preserves_layout.gd tests/finite/integration/test_solution_identity_retry.gd tests/run_tests.gd
git commit -m "feat: preserve finite solutions across retries"
```

---

### Task 11: Add the Minimal Build/Run/Result Product Surface

**Files:**
- Create: `game/finite/presentation/finite_slice_view.tscn`
- Create: `game/finite/presentation/finite_slice_view.gd`
- Create: `game/finite/presentation/finite_slice_presenter.gd`
- Create: `game/finite/main/finite_slice.tscn`
- Create: `game/finite/main/finite_slice.gd`
- Create: `tests/finite/presentation/test_finite_slice_presenter.gd`
- Create: `tests/finite/smoke/test_finite_slice_scene_boot.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Consumes: `FiniteBuildSession` and `FiniteRunSession` state snapshots.
- Produces: build commands, load hold, auto toggle, switch tap, pause/resume, retry, edit return, and read-only HUD state.

- [ ] **Step 1: Write a failing scene boot test**

Load and instantiate `res://game/finite/main/finite_slice.tscn`, add it to a temporary scene tree, and assert there are no script errors and the presenter starts in BUILD.

- [ ] **Step 2: Write failing presenter tests**

Required UI state assertions:

```text
preflight fail → Start disabled and one primary reason
preflight pass → Start enabled
RUNNING → editing buttons disabled
PAUSED → switch/load/auto controls disabled
UNLOADING → cargo tokens leave one-by-one
FAILURE → Retry Same Layout and Edit Layout visible
SUCCESS → completion time and final build cost visible
```

- [ ] **Step 3: Run and verify red**

- [ ] **Step 4: Build a temporary but usable landscape surface**

Use standard Godot `Control`, `Button`, `Label`, and `_draw()` primitives. Minimum touch target is `48dp` equivalent at the 1920×1080 reference viewport. Cargo icons combine color and geometric silhouette. The stack HUD renders bottom-to-TOP order and labels TOP explicitly.

Do not add final art, animation packages, profile, rewards, records browser, or online UI.

- [ ] **Step 5: Run and commit**

```bash
git add game/finite/presentation game/finite/main tests/finite/presentation tests/finite/smoke tests/run_tests.gd
git commit -m "feat: add finite slice product surface"
```

---

### Task 12: Prove the Core Loop, Validate Devices and Humans, Then Cut Over

**Files:**
- Create: `tests/finite/integration/test_build_to_delivery_slice.gd`
- Create: `tests/finite/integration/test_lifo_revisit_proof.gd`
- Create: `tests/finite/integration/test_pause_integrity.gd`
- Create: `tests/finite/integration/test_finite_adversarial_cases.gd`
- Create: `기획서/50_제작_검증/FP_01_02_IMPLEMENTATION_AUDIT.md`
- Modify only after all gates pass: `game/main/main.tscn`
- Modify only after all gates pass: `game/main/main.gd`
- Modify: `tests/run_tests.gd`
- Modify after merge evidence exists: `기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md`
- Modify after merge evidence exists: `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`

**Interfaces:**
- Consumes: all prior finite packages.
- Produces: one complete playable proof, validation receipts, a reversible default-entrypoint cutover, and an explicit handoff to ChatGPT for Sheet closure.

- [ ] **Step 1: Write the failing A/B/A/A proof**

The integration test must execute this domain sequence through the actual graph, train, input, delivery loop, and run controller:

```text
encounter A → B → A → A
stack [A][B][A][A TOP]
A station unload 2
B station unload 1
A station unload 1
final animation complete → SUCCESS
```

Assert no fuel, BOOST, difficulty, capacity, respawn, or cargo slowdown field appears in events or summary.

- [ ] **Step 2: Add adversarial integration coverage**

Cover disconnected anchors, crossing lane leakage, switch dead-end, repeated pause/resume, auto toggle immediately before contact, exact-limit success/failure, 32-cargo stack, failed-run retry, and two different passing layouts.

- [ ] **Step 3: Run all automated gates**

Run the full suite and record exact case/assertion counts. Open the implementation PRs and require:

```text
Project Contract PASS
Godot Tests PASS
new finite failures 0
unresolved review threads 0
REQUEST_CHANGES 0
```

Do not mark Android or human checks PASS from headless output.

- [ ] **Step 4: Perform Android smoke and record evidence**

On an Android device or official emulator in landscape, record PASS/FAIL for:

```text
place, rotate, replace, remove, clear
preflight problem-cell feedback
manual load hold
switch tap while load is held
switch lock while occupied
auto-load toggle
TOP readability at 8, 16, and 32 cargo
pause during movement and unload
failure preserving layout
same-layout retry
```

Attach screenshots or video references to `FP_01_02_IMPLEMENTATION_AUDIT.md`. Unrun checks remain `NOT_RUN`.

- [ ] **Step 5: Perform five-person comprehension validation**

Without revealing the solution, require:

```text
4/5 explain that the last loaded cargo is TOP
4/5 explain why A must be revisited in A/B/A/A
4/5 edit and retry after a failure
successful players attribute success to route/loading/LIFO rather than reflex speed
```

Record participant count, build SHA, device, outcome, and observed misunderstanding. Do not store unnecessary personal data.

- [ ] **Step 6: Cut over only if every gate passes**

Replace the empty `game/main/main.tscn` root with an instance of `res://game/finite/main/finite_slice.tscn`. Keep the previous entrypoint change revertible in one commit.

```bash
git add game/main/main.tscn game/main/main.gd
git commit -m "feat: cut over to finite delivery slice"
```

Do not delete legacy files. Do not run old and finite product rules in one player-facing session.

- [ ] **Step 7: Update audit and hand off canonical closure**

The audit must distinguish:

```text
AUTOMATED
ANDROID
HUMAN
BALANCE
ONLINE
```

Only the first three are relevant to this Slice. Balance beyond the representative map and all online services remain `NOT_RUN`.

After implementation PR merge, ChatGPT performs the authority closure:

1. record merge SHAs and test runs,
2. update current GitHub authority,
3. mark old default runtime `[대체됨 · 역사 증거]`,
4. write the same IDs and SHAs to the correct Google Sheet,
5. read back all 12 tabs,
6. close only with thread 0 and `REQUEST_CHANGES 0`.

- [ ] **Step 8: Final commit for evidence documents**

```bash
git add tests/finite/integration tests/run_tests.gd 기획서/50_제작_검증/FP_01_02_IMPLEMENTATION_AUDIT.md 기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md 기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md
git commit -m "docs: record finite slice implementation evidence"
```

---

## Plan Self-Review

### Spec coverage

- Authored MapDefinition/TrackLayout identity: Tasks 1–2.
- Editing, costs, refund: Task 3.
- Switch/crossing graph semantics: Task 4.
- Reachability and permanent traps: Task 5.
- Representative authored map and two solutions: Task 6.
- Manual/auto loading and unlimited LIFO: Tasks 7–8.
- Station skip, visible unload, finite success/failure, pause: Task 9.
- Same-layout retry and immutable identity: Task 10.
- Build/Run/Result HUD and accessibility minimum: Task 11.
- Full core proof, Android, human validation, rollback, cutover, and sync: Task 12.

### Type consistency

- `FiniteMapDefinition` is the only schema-v2 authored map model.
- `TrackLayout.layout_signature()` is the only solution-layout hash.
- `FiniteTrackGraph` is traversal-state aware and remains compatible with stable `TrainController` movement calls.
- `FiniteDeliveryLoop` commits cargo domain events; `FiniteRunController` owns time, unload presentation state, and result seals.
- `FiniteRunSessionFactory` owns fresh mutable runtime creation per attempt.

### Scope protection

The plan contains no acceleration/economy/one-way/turnaround/tunnel/bridge implementation, Combo reward, stars, leaderboard, tutorial campaign, online challenge, UGC, or final-art tasks.

## Execution Handoff

Plan status is `USER_PLAN_REVIEW`. No product code implementation is authorized by the existence of this file.

Recommended execution mode is **Codex Subagent-Driven Development**: one fresh worker per task, TDD first, adversarial review between tasks, and a separate review Gate for each PR.

Alternative mode is **Codex Inline Execution** using `superpowers:executing-plans`, processing tasks in small batches with review checkpoints.
