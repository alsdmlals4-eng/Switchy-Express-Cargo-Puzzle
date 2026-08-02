# VS03-05A Minimal Playable Core Surface Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the first product scene that makes LIFO loading, route preparation, compact rear-token meaning, survival pressure, and BOOST tradeoffs visible and playable before Profile/meta systems are implemented.

**Architecture:** `Main` hosts one `PlayScene`; `PlayScene` is the runtime composition root and receives a fully configured `RunSession` from `RunSessionFactory`. Pure read models convert authoritative domain state into immutable Dictionaries. Node2D/Control presentation consumes those snapshots and sends semantic input intents only. `FULL_MAP_READY` gates `RunController.start()`; no Profile, result transaction, record, reward, cosmetic, collection, or browser authority exists in this package.

**Tech Stack:** Godot 4.7.1, GDScript, Node2D/Control/Camera2D, repository custom headless runner, existing RailGraph/TrainController/CargoStack/RunController APIs plus VS03-02 compact token/footprint and VS03-03 RunSession APIs.

## Global Constraints

- Start only after `VS03-03` and `VS03-R1` are merged and synchronized.
- Do not implement Profile/save/records/rewards/unlocks/cosmetics/result insight/map browser/onboarding.
- `RunController`, `CargoStack`, `RailGraph`, `TrainFootprint`, `DifficultyDirector`, and `RunSession` remain authoritative.
- Scene, Tween, Camera, HUD, animation, and button callbacks are non-authoritative.
- `FULL_MAP_READY` must occur before `RunController.start()`.
- Active run uses a fixed full-map camera; no free pan/zoom.
- Reduced Motion may skip the PREP animation but must produce the same authoritative trace.
- Controls must be single-pointer/no-chord: LOAD, BOOST, and switch cycle never require simultaneous pointer targets.
- Use primitive/procedural placeholder visuals only; no final art claim.
- Existing headless suites must remain green; Android/human evidence remains `NOT_RUN`.
- Use the repository test contract: `func run() -> void` and static registration in `tests/run_tests.gd`.

---

## Required Upstream Interfaces

`VS03-03` must expose the following before this plan begins. If names differ on merged main, adapt this plan once to the merged API and record the mapping in the PR body; do not add a second competing session API.

```gdscript
# RunSessionFactory
func create(selection_request: Variant) -> Dictionary
# success: {"status": &"SESSION_CREATED", "session": RunSession}
# failure: {"status": StringName, "reason": StringName}

# RunSession
func graph() -> Variant
func stations() -> Array
func cargo_spawner() -> Variant
func cargo_stack() -> Variant
func input_state() -> Variant
func train() -> Variant
func train_footprint() -> Variant
func token_state() -> Variant
func run_controller() -> Variant
func map_definition() -> Variant
func generation_id() -> int
```

`VS03-02` must expose:

```gdscript
# CompactWagonTokenState
func token_types() -> Array[StringName] # bottom -> top / front -> rear
func rear_type() -> StringName
func token_count() -> int

# TrainFootprint
func occupied_cells() -> Array[Vector2i]
func token_positions(cell_size: Vector2 = Vector2.ONE) -> Array[Vector2]
```

---

## File Responsibility Map

### Create

```text
game/play/play_scene.gd
game/play/play_scene.tscn
game/play/play_read_model.gd
game/play/play_input_router.gd
game/rail/rail_board_view.gd
game/rail/switch_view.gd
game/train/train_view.gd
game/train/compact_wagon_token_view.gd
game/camera/camera_presentation_state.gd
game/camera/game_camera_controller.gd
game/ui/game_hud.gd
game/ui/game_hud.tscn
game/ui/game_controls.gd
game/ui/game_controls.tscn
tests/play/test_play_read_model.gd
tests/play/test_play_input_router.gd
tests/camera/test_camera_presentation_state.gd
tests/ui/test_game_hud.gd
tests/smoke/test_play_scene_smoke.gd
tests/integration/test_full_map_ready_run_gate.gd
```

### Modify

```text
game/main/main.gd
game/main/main.tscn
tests/smoke/test_project_boot.gd
tests/run_tests.gd
project.godot only if an actual project setting is required; main scene remains game/main/main.tscn
```

### Explicitly Do Not Create

```text
game/profile/**
game/result/**
game/cosmetics/**
game/progression/**
game/map/*browser*
game/ui/result_panel.*
game/ui/collection_panel.*
game/ui/map_browser_panel.*
game/onboarding/**
```

---

## Immutable Presentation Snapshot Contracts

### HUD snapshot

```gdscript
{
    "phase": StringName,
    "score": int,
    "fuel": float,
    "fuel_max": float,
    "speed": float,
    "elapsed_seconds": float,
    "last_combo": int,
    "max_combo": int,
    "rear_cargo_type": StringName,
    "cargo_count": int,
    "difficulty_band": StringName,
}
```

### Board snapshot

```gdscript
{
    "rail_cells": Array[Vector2i],
    "rail_edges": Array[Dictionary], # {"from": Vector2i, "to": Vector2i}
    "switches": Array[Dictionary],   # cell/current_exit/preview_cells/state_count
    "stations": Array[Dictionary],   # cell/cargo_type
    "pickups": Array[Dictionary],    # cell/cargo_type
    "locomotive_position": Vector2,
    "token_positions": Array[Vector2],
    "token_types": Array[StringName],
    "occupied_cells": Array[Vector2i],
}
```

Snapshots are duplicated values/arrays. Presentation must not receive mutable domain collections by reference.

---

### Task 1: Build Pure Read Models Before Nodes

**Files:**
- Create: `game/play/play_read_model.gd`
- Create: `tests/play/test_play_read_model.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Consumes: one fully configured `RunSession`.
- Produces: immutable `hud_snapshot()` and `board_snapshot()` Dictionaries.

- [ ] **Step 1: Write the failing read-model existence and HUD parity test**

```gdscript
extends "res://tests/test_case.gd"

const READ_MODEL_PATH := "res://game/play/play_read_model.gd"

func run() -> void:
    assert_true(ResourceLoader.exists(READ_MODEL_PATH, "Script"), "PlayReadModel script must exist")
    if not ResourceLoader.exists(READ_MODEL_PATH, "Script"):
        return
    var fixture: Variant = load("res://tests/support/run_session_fixture.gd").build_started_session()
    fixture.cargo_stack().push(&"RED_STAR")
    fixture.cargo_stack().push(&"BLUE_DIAMOND")
    fixture.token_state().synchronize(fixture.cargo_stack())
    var model: Variant = load(READ_MODEL_PATH).new(fixture)
    var hud: Dictionary = model.hud_snapshot()
    assert_equal(hud.score, fixture.run_controller().run_state().score(), "HUD score must match RunState")
    assert_equal(hud.cargo_count, 2, "HUD cargo count must match CargoStack")
    assert_equal(hud.rear_cargo_type, &"BLUE_DIAMOND", "HUD rear type must equal LIFO top")
    assert_equal(hud.difficulty_band, fixture.run_controller().difficulty_director().pressure_band(), "HUD band must match director")
```

If `VS03-03` uses a differently named shared fixture, use that merged fixture rather than creating a duplicate full session builder.

- [ ] **Step 2: Run and verify RED**

Expected: `PlayReadModel` does not exist.

- [ ] **Step 3: Implement `PlayReadModel`**

```gdscript
class_name PlayReadModel
extends RefCounted

var _session: Variant

func _init(session: Variant) -> void:
    assert(session != null, "PlayReadModel requires a RunSession")
    _session = session

func hud_snapshot() -> Dictionary:
    var controller: Variant = _session.run_controller()
    var state: Variant = controller.run_state()
    return {
        "phase": _phase_name(state),
        "score": state.score(),
        "fuel": state.fuel(),
        "fuel_max": state.fuel_max(),
        "speed": _session.train().speed,
        "elapsed_seconds": state.elapsed_seconds(),
        "last_combo": state.last_combo(),
        "max_combo": state.max_combo(),
        "rear_cargo_type": _session.token_state().rear_type(),
        "cargo_count": _session.token_state().token_count(),
        "difficulty_band": controller.difficulty_director().pressure_band(),
    }
```

Implement `_phase_name()` with explicit mapping to `READY`, `ACTIVE`, `PAUSED`, and `ENDED`; do not expose the enum integer to UI.

For `board_snapshot()`, iterate `graph.all_cells()` and emit each undirected edge once by comparing cell coordinates. Duplicate every Array before returning.

- [ ] **Step 4: Add board parity assertions**

```gdscript
var board: Dictionary = model.board_snapshot(Vector2(64.0, 64.0))
assert_equal(board.rail_cells, fixture.graph().all_cells(), "board rail cells must match graph")
assert_equal(board.token_types, fixture.token_state().token_types(), "token types must preserve bottom-to-top order")
assert_equal(board.token_positions.size(), board.token_types.size(), "each token requires one path-sampled position")
assert_equal(board.occupied_cells, fixture.train_footprint().occupied_cells(), "board footprint must match authority")
```

- [ ] **Step 5: Register, run, and commit**

```bash
git add game/play/play_read_model.gd tests/play/test_play_read_model.gd tests/run_tests.gd
git commit -m "feat: add immutable playable core read models"
```

---

### Task 2: Implement Semantic Input Routing

**Files:**
- Create: `game/play/play_input_router.gd`
- Create: `tests/play/test_play_input_router.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Consumes: session `GameplayInputState`, `RailGraph`, and current `TrainController`.
- Produces: LOAD/BOOST hold intents and switch-cycle intent; no direct movement or score mutation.

- [ ] **Step 1: Write failing input tests**

```gdscript
var fixture: Variant = load("res://tests/support/run_session_fixture.gd").build_ready_session()
var router: Variant = load("res://game/play/play_input_router.gd").new(fixture)
router.set_load_pressed(true)
assert_true(fixture.input_state().is_loading(), "LOAD intent must reach GameplayInputState")
router.set_boost_pressed(true)
assert_true(fixture.input_state().is_boosting(), "BOOST intent must reach GameplayInputState")
assert_false(fixture.input_state().is_loading(), "BOOST priority must continue to block LOAD")
router.set_boost_pressed(false)
assert_true(fixture.input_state().is_loading(), "releasing BOOST must restore held LOAD intent")
```

For switch routing, use a graph fixture with a known switch and assert `graph.next_cell()` changes only after `cycle_switch()`.

- [ ] **Step 2: Run and verify RED**

Expected: input router absent.

- [ ] **Step 3: Implement minimal router**

```gdscript
class_name PlayInputRouter
extends RefCounted

var _session: Variant

func _init(session: Variant) -> void:
    _session = session

func set_load_pressed(pressed: bool) -> void:
    _session.input_state().set_load_requested(pressed)

func set_boost_pressed(pressed: bool) -> void:
    _session.input_state().set_boost_requested(pressed)

func cycle_switch(cell: Vector2i) -> bool:
    var graph: Variant = _session.graph()
    if not graph.switch_cells().has(cell):
        return false
    graph.cycle_switch(cell, _incoming_for_switch(cell))
    return true
```

`_incoming_for_switch()` must derive approach from the locked train route when the train is approaching that switch; otherwise use the map/session-defined deterministic approach. Do not use screen position to infer topology.

- [ ] **Step 4: Prove input is semantic only**

Add assertions that LOAD/BOOST calls do not directly change score, fuel, elapsed time, cargo count, or train cell until the authoritative controller/DeliveryLoop advances.

- [ ] **Step 5: Register, run, and commit**

```bash
git add game/play/play_input_router.gd tests/play/test_play_input_router.gd tests/run_tests.gd
git commit -m "feat: route playable core semantic inputs"
```

---

### Task 3: Add Camera State and FULL_MAP_READY Gate

**Files:**
- Create: `game/camera/camera_presentation_state.gd`
- Create: `game/camera/game_camera_controller.gd`
- Create: `tests/camera/test_camera_presentation_state.gd`
- Create: `tests/integration/test_full_map_ready_run_gate.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Consumes: preparation request, reduced-motion preference, map bounds.
- Produces: one idempotent `full_map_ready` signal; never advances run time itself.

- [ ] **Step 1: Write failing pure state tests**

```gdscript
var state: Variant = load("res://game/camera/camera_presentation_state.gd").new()
assert_equal(state.phase(), &"PREP", "camera starts in PREP")
assert_false(state.is_full_map_ready(), "run gate starts closed")
assert_true(state.mark_full_map_ready(), "first ready transition succeeds")
assert_false(state.mark_full_map_ready(), "ready transition is idempotent")
assert_equal(state.phase(), &"ACTIVE_FULL_MAP", "ready transition fixes full-map phase")
```

- [ ] **Step 2: Run and verify RED**

- [ ] **Step 3: Implement pure state and Node controller**

`CameraPresentationState` owns only presentation phase and ready idempotency.

`GameCameraController`:

```gdscript
signal full_map_ready

func configure(camera: Camera2D, map_rect: Rect2, reduced_motion: bool) -> void
func begin_preparation(locomotive_position: Vector2) -> void
func force_full_map_ready() -> void
```

Rules:

- normal mode: start at `1.20x` TEST_VALUE around locomotive, transition for `0.75s` TEST_VALUE, then frame the whole 15×10 board and emit once;
- reduced motion: frame full map immediately and emit once;
- no call to `RunController.advance_time()`;
- Tween completion may request `mark_full_map_ready()` but the idempotent state owns whether the signal is emitted.

- [ ] **Step 4: Write the run-gate integration test**

Use a fake camera controller with an explicit `emit_ready()` method:

```gdscript
var scene: Variant = load("res://game/play/play_scene.gd").new()
scene.configure(fake_factory, fake_camera, false)
scene.start_initial_run(auto_request)
assert_true(session.run_controller().run_state().is_ready(), "session must remain READY before FULL_MAP_READY")
fake_camera.emit_ready()
assert_true(session.run_controller().run_state().is_active(), "FULL_MAP_READY must start the run")
fake_camera.emit_ready()
assert_true(session.run_controller().run_state().is_active(), "duplicate ready must not restart the run")
```

This test may initially remain RED until Task 6 creates `PlayScene`; commit the camera unit test GREEN first and carry the integration test as the next task’s RED.

- [ ] **Step 5: Commit camera unit**

```bash
git add game/camera tests/camera tests/integration/test_full_map_ready_run_gate.gd tests/run_tests.gd
git commit -m "feat: define full-map camera readiness gate"
```

---

### Task 4: Build Primitive Board, Train, Token, and Switch Views

**Files:**
- Create: `game/rail/rail_board_view.gd`
- Create: `game/rail/switch_view.gd`
- Create: `game/train/train_view.gd`
- Create: `game/train/compact_wagon_token_view.gd`
- Extend: `tests/play/test_play_read_model.gd`

**Interfaces:**
- Consumes: immutable board snapshot only.
- Produces: draw calls and switch-hit semantic signals; no domain mutation.

- [ ] **Step 1: Add failing View API existence assertions**

```gdscript
assert_true(ResourceLoader.exists("res://game/rail/rail_board_view.gd", "Script"), "board view script must exist")
assert_true(ResourceLoader.exists("res://game/train/compact_wagon_token_view.gd", "Script"), "token view script must exist")
```

- [ ] **Step 2: Implement `RailBoardView` as a snapshot renderer**

```gdscript
class_name RailBoardView
extends Node2D

signal switch_pressed(cell: Vector2i)

func apply_snapshot(snapshot: Dictionary) -> void:
    _snapshot = snapshot.duplicate(true)
    queue_redraw()
```

Draw rails from `rail_edges`, stations and pickups with cargo color+shape, switch current exit and preview route, locomotive, tokens, and optional occupied-cell debug overlay disabled by default.

No draw method may call `cycle_switch()`, `CargoStack.push()`, `RunController.advance_time()`, or any Profile method.

- [ ] **Step 3: Implement color+shape token primitives**

Use `CargoType.color_for()` and `CargoType.shape_for()` to draw:

```text
RED_STAR       → red + star polygon
BLUE_DIAMOND   → blue + diamond polygon
YELLOW_TRIANGLE→ yellow + triangle polygon
```

Rear token receives a non-color-only outline/chevron marker. Do not rely on saturation alone.

- [ ] **Step 4: Implement switch hit targets**

`SwitchView` maps each switch cell to a screen-space `Rect2` no smaller than the current 48dp design target after viewport scaling. Pointer release inside one target emits `switch_pressed(cell)`; it does not mutate the graph itself.

- [ ] **Step 5: Add snapshot immutability test**

After `apply_snapshot()`, mutate the source Dictionary and assert the view’s stored debug/readback snapshot remains unchanged. Expose a test-only `snapshot_for_test() -> Dictionary` returning a duplicate; do not expose mutable internal state.

- [ ] **Step 6: Run and commit**

```bash
git add game/rail game/train/compact_wagon_token_view.gd game/train/train_view.gd tests/play/test_play_read_model.gd
git commit -m "feat: render readable rail and compact token snapshots"
```

---

### Task 5: Build Minimal HUD and Single-Pointer Controls

**Files:**
- Create: `game/ui/game_hud.gd`
- Create: `game/ui/game_hud.tscn`
- Create: `game/ui/game_controls.gd`
- Create: `game/ui/game_controls.tscn`
- Create: `tests/ui/test_game_hud.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Consumes: HUD snapshot.
- Produces: `load_pressed(bool)` and `boost_pressed(bool)` signals.

- [ ] **Step 1: Write failing HUD formatting tests**

```gdscript
var hud: Variant = load("res://game/ui/game_hud.gd").new()
var view: Dictionary = hud.format_snapshot({
    "score": 1260,
    "fuel": 34.6,
    "fuel_max": 100.0,
    "speed": 2.43,
    "elapsed_seconds": 75.4,
    "last_combo": 3,
    "max_combo": 4,
    "rear_cargo_type": &"BLUE_DIAMOND",
    "cargo_count": 6,
    "difficulty_band": &"BUSY",
})
assert_equal(view.score_text, "1,260", "score formatting")
assert_equal(view.fuel_text, "35 / 100", "fuel formatting rounds for display only")
assert_equal(view.combo_text, "COMBO ×3", "last combo label")
assert_equal(view.max_combo_text, "MAX ×4", "max combo label")
assert_equal(view.rear_type, &"BLUE_DIAMOND", "HUD rear item preserves type")
assert_equal(view.band_text, "BUSY", "difficulty band remains qualitative")
```

- [ ] **Step 2: Run and verify RED**

- [ ] **Step 3: Implement HUD as a read-only Control**

`format_snapshot()` returns display strings without mutating source data. `apply_snapshot()` updates Labels, ProgressBar, and the rear cargo icon. Do not display internal threshold formulas or next exact pressure timestamp.

- [ ] **Step 4: Create controls scene**

Required node tree:

```text
GameControls (Control)
├── LoadButton (Button)
└── BoostButton (Button)
```

Use `button_down`/`button_up` to emit hold states. Minimum target size is represented in scene properties. Buttons must not require simultaneous pressing; BOOST priority remains in `GameplayInputState`.

- [ ] **Step 5: Test control semantics without viewport automation**

Instantiate `GameControls`, invoke the button signal handlers directly, and assert emitted sequences:

```text
LOAD down → true
BOOST down → true
BOOST up → false
LOAD up → false
```

- [ ] **Step 6: Run and commit**

```bash
git add game/ui tests/ui tests/run_tests.gd
git commit -m "feat: add minimal survival HUD and semantic controls"
```

---

### Task 6: Compose PlayScene and Keep Main as Host

**Files:**
- Create: `game/play/play_scene.gd`
- Create: `game/play/play_scene.tscn`
- Modify: `game/main/main.gd`
- Modify: `game/main/main.tscn`
- Modify: `tests/integration/test_full_map_ready_run_gate.gd`
- Create: `tests/smoke/test_play_scene_smoke.gd`
- Modify: `tests/smoke/test_project_boot.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Consumes: injected `RunSessionFactory`, semantic AUTO_NEW_RUN request, camera readiness.
- Produces: one live session connected to board/HUD/controls.

- [ ] **Step 1: Write the failing scene smoke test**

```gdscript
assert_true(ResourceLoader.exists("res://game/play/play_scene.tscn", "PackedScene"), "PlayScene resource must exist")
var packed: PackedScene = load("res://game/play/play_scene.tscn")
var scene: Node = packed.instantiate()
assert_not_null(scene.get_node_or_null("Board"), "PlayScene must contain Board")
assert_not_null(scene.get_node_or_null("GameCamera"), "PlayScene must contain GameCamera")
assert_not_null(scene.get_node_or_null("CanvasLayer/HUD"), "PlayScene must contain HUD")
assert_not_null(scene.get_node_or_null("CanvasLayer/Controls"), "PlayScene must contain Controls")
scene.free()
```

- [ ] **Step 2: Run and verify RED**

- [ ] **Step 3: Create exact PlayScene node tree**

```text
PlayScene (Node2D, play_scene.gd)
├── Board (RailBoardView)
├── GameCamera (Camera2D, game_camera_controller.gd)
└── CanvasLayer
    ├── HUD (GameHUD instance)
    └── Controls (GameControls instance)
```

- [ ] **Step 4: Implement composition lifecycle**

```gdscript
func configure(session_factory: Variant, camera_controller: Variant, reduced_motion: bool) -> void
func start_initial_run(selection_request: Variant) -> StringName
func active_session() -> Variant
func advance_presentation(delta_seconds: float) -> void
```

`start_initial_run()` order:

```text
factory.create(request)
→ reject failure explicitly
→ store fully configured session
→ create PlayReadModel + PlayInputRouter
→ connect controls and switch_pressed
→ apply initial board/HUD snapshot
→ begin PREP camera
→ wait for full_map_ready
→ run_controller.start() exactly once
```

`_process(delta)` may call `run_controller.advance_time(delta)` only after the controller is ACTIVE, then refresh snapshots. Presentation refresh must not alter the returned domain events.

- [ ] **Step 5: Make Main host only**

`main.tscn` contains one `PlayScene` child. `main.gd` may obtain/configure app dependencies but contains no score, fuel, map generation, Profile, result, or tutorial logic.

For automated tests, `PlayScene.configure()` accepts injected factory/camera dependencies. Production dependency construction may remain a small factory method in `PlayScene` or a dedicated future composition provider; do not place domain formulas in `Main`.

- [ ] **Step 6: Complete the FULL_MAP_READY integration test**

Prove:

```text
session created → RunState READY
PREP presentation ticks → elapsed remains 0
full_map_ready emitted → start() once
active presentation tick → elapsed increases
second ready signal → no reset/restart
reduced motion → immediate ready with the same first active trace
```

- [ ] **Step 7: Run and commit**

```bash
git add game/play game/main tests/smoke tests/integration/test_full_map_ready_run_gate.gd tests/run_tests.gd
git commit -m "feat: compose the first playable core scene"
```

---

### Task 7: Core-Fun Parity and Package Gate

**Files:**
- Modify only owned files if tests expose defects.
- Update package audit/current consumers after implementation, not in the feature commits.

**Interfaces:**
- Consumes: completed 05A branch.
- Produces: automated core-surface evidence and Issue #7 device/human handoff.

- [ ] **Step 1: Add an end-to-end headless smoke flow**

Using a deterministic fixture session:

```text
PlayScene configured
→ FULL_MAP_READY
→ LOAD held over pickup
→ token count/rear HUD updates
→ switch cycle changes preview and actual next route consistently
→ matching station unloads rear group
→ HUD Combo/score/fuel match RunState
→ BOOST raises speed and drain while LOAD remains blocked
→ fuel zero ends run
→ scene shows ended HUD state only; no result panel or Profile transaction exists
```

- [ ] **Step 2: Add presentation-off parity**

Run the same deterministic input trace:

1. directly against the domain session;
2. through `PlayScene` with camera animation enabled;
3. through `PlayScene` with Reduced Motion.

Compare final:

```text
elapsed
score
fuel
last/max Combo
cargo stack
train current/previous/target cells
difficulty snapshot
end reason
```

All must match.

- [ ] **Step 3: Perform adversarial scope scan**

Reject merge if any of the following is present:

```text
Profile/save/record/reward code
result cause analysis
collection or map browser
animation completion mutates gameplay
screen coordinates determine rail topology
UI directly pushes/pops CargoStack
free pan/zoom during active run
FULL_MAP_READY starts more than once
raw seed shown in HUD
Android/human PASS claim
```

- [ ] **Step 4: Run repository checks**

```bash
python tools/validate_project_contract.py
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tests/run_tests.gd
```

- [ ] **Step 5: Prepare representative capture checklist without claiming completion**

Issue #7 handoff must request captures for:

```text
0 tokens
1 token
4 mixed tokens
8 mixed tokens
rear token + matching HUD item
2-state switch preview
3-state switch preview
CALM/BUSY/INTENSE band
minimum Android landscape resolution
Reduced Motion
```

Mark all device captures and human interpretation as `NOT_RUN` until actually performed.

- [ ] **Step 6: Open exact-head package PR**

PR body must include:

```text
package VS03-05A
decisions consumed SX-DEC-002/003/005/013~015/018/022
prerequisites VS03-02, VS03-03, VS03-R1
changed files
public snapshot/input interfaces
FULL_MAP_READY evidence
presentation-off/reduced-motion parity
rollback: revert 05A PR; domain packages remain
NOT_RUN evidence
```

---

## Self-Review Result

- Spec coverage: PlayScene, board, train/tokens, switches, semantic inputs, minimal HUD, PREP/FULL_MAP_READY, fixed active camera, difficulty band, and Reduced Motion are covered.
- Explicit exclusions: Profile, result, records, rewards, collection, browser, onboarding, Android/human PASS are excluded in tasks and gate.
- Placeholder scan: no TBD/TODO/“similar to” step remains.
- Type consistency: `RunSession`, `PlayReadModel`, `PlayInputRouter`, HUD/board snapshots, and `full_map_ready` names are consistent throughout.
- Core-fun order: visibility and playability are proven before meta/persistence work begins.
