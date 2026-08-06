# PC Vertical Slice Demo Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a PC-capable, high-polish, single-stage Vertical Slice Demo that reuses the validated finite-delivery domain, preserves Android validation evidence, and completes Title → Briefing → BUILD → RUN → Result with mouse, keyboard, and existing touch command paths.

**Architecture:** Extract the application orchestration currently embedded in `FiniteSlice` into one reusable `FiniteSliceSessionController`. Keep the current finite scene as a compatibility wrapper for validation, while a separate `game/demo/` product shell consumes the same controller through a product board renderer, Korean HUD, desktop input adapter, effects, and audio director. Do not change the default entrypoint or canonical Android validation harness during this plan.

**Tech Stack:** Godot 4.7.1-stable, GDScript, Control/CanvasItem/Tween/AudioStreamGenerator APIs, the repository custom headless test runner, JSON authored maps, GitHub Actions, Windows Desktop debug export.

## Global Constraints

- Decision authority: `SX-DEC-037 · EV-USER-023`.
- Approved spec: `docs/superpowers/specs/2026-08-06-pc-vertical-slice-demo-design.md`.
- Engine: Godot `4.7.1-stable`; language: GDScript.
- One representative stage only; first-play target approximately 5–10 minutes.
- Existing `res://data/maps/fp_core_proof_01.json` remains unchanged.
- New product map path: `res://data/maps/vs_demo_01.json`.
- Existing validation scene path remains `res://game/finite/main/finite_slice.tscn`.
- New demo scene path: `res://game/demo/vertical_slice_demo.tscn`.
- `project.godot` `run/main_scene` remains `res://game/main/main.tscn`.
- Android validation preset, package ID, launcher, canonical APK hash, and evidence remain unchanged.
- Android Device Smoke remains `NOT_RUN`; Five-person Comprehension remains `NOT_RUN`; Production Cutover remains `BLOCKED`.
- Domain state is authoritative. UI, animation, audio, and transitions never determine track state, cargo state, branch state, time, delivery, success, failure, retry identity, or edit identity.
- Color is always paired with shape and text for cargo and stations.
- Mouse-first controls: left click primary, right click cancel/remove, `R` rotate, `Space` start/pause/resume, `Shift` hold load, `A` auto-load toggle, `1`–`4` tools, `Esc` cancel/pause, `Enter` confirm.
- Existing touch buttons and board-cell command path remain supported.
- No gamepad, online, leaderboard, monetization, save progression, multi-stage campaign, or default-entrypoint cutover in this plan.
- Every production-code change follows RED → verify RED → minimal GREEN → full regression → commit.

---

## File Structure

### Shared finite application layer

```text
game/finite/main/finite_slice_session_controller.gd
    Owns finite map/build/run lifecycle, command dispatch, presenter model,
    immutable render snapshots, retry/edit, and delivery history.

game/finite/main/finite_slice.gd
    Thin compatibility Control that connects the existing validation View to
    FiniteSliceSessionController and delegates the existing public test API.
```

### Demo shell and product presentation

```text
game/demo/vertical_slice_demo.tscn
    F6-runnable product demo root.

game/demo/demo_flow_controller.gd
    TITLE, BRIEFING, GAMEPLAY, PAUSE, RESULT and controls-overlay flow only.

game/demo/product_finite_slice.tscn
game/demo/product_finite_slice.gd
    Connects one FiniteSliceSessionController to renderer, HUD, input,
    effects and audio; emits terminal and title-navigation signals.

game/demo/input/desktop_input_adapter.gd
    Maps InputMap events to the same finite command names used by touch UI.

game/demo/presentation/product_board_renderer.gd
    Draws board, terrain, anchors, track, hover, selection, ghost, problems,
    train, cargo, stations, switches and lock/readability states.

game/demo/presentation/product_hud.tscn
game/demo/presentation/product_hud.gd
    Korean BUILD/RUN/RESULT controls and status.

game/demo/presentation/demo_palette.gd
    Central semantic colors and dimensions; no gameplay state.

game/demo/presentation/demo_effects.gd
    Tween-only feedback for selection, build, unload, success and failure.

game/demo/audio/demo_audio_director.gd
    Procedural audio cues and train loop; no timing authority.
```

### Product content and export

```text
data/maps/vs_demo_01.json
    Product demo map with separate identity from proof map.

tests/fixtures/finite/vs_demo_solution_alpha.gd
tests/fixtures/finite/vs_demo_solution_beta.gd
    Two successful authored route variants.

export_presets.cfg
    Existing Android Validation preset unchanged; add Windows Demo preset.

.github/workflows/windows-demo-export.yml
    Pinned Godot 4.7.1 tests and Windows debug export artifact.
```

---

### Task 1: Extract the reusable finite session controller

**Files:**
- Create: `game/finite/main/finite_slice_session_controller.gd`
- Create: `tests/finite/presentation/test_finite_slice_session_controller.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Produces class `FiniteSliceSessionController extends RefCounted`.
- Produces signals:
  - `model_changed(model: Dictionary)`
  - `render_snapshot_changed(snapshot: Dictionary)`
  - `delivery_event_created(event: Variant)`
  - `terminal_reached(summary: Variant)`
- Produces methods:
  - `initialize(map_path: String, recommended_cost: int = 4500, base_speed: float = 2.0) -> bool`
  - `request_command(command: StringName, payload: Variant = null) -> void`
  - `advance_time(delta_seconds: float) -> void`
  - `phase() -> StringName`
  - `model() -> Dictionary`
  - `render_snapshot() -> Dictionary`
  - `domain_ready() -> bool`
  - `current_layout_signature() -> String`
  - `current_summary() -> Variant`
  - `delivery_history() -> Array`
  - `last_command() -> StringName`
  - `last_payload() -> Variant`

- [ ] **Step 1: Write the failing controller contract test**

```gdscript
extends "res://tests/test_case.gd"

const ControllerScript := preload(
    "res://game/finite/main/finite_slice_session_controller.gd"
)

func run() -> void:
    var controller: RefCounted = ControllerScript.new()
    assert_true(
        controller.initialize("res://data/maps/fp_core_proof_01.json"),
        "controller must initialize the proof map"
    )
    assert_true(controller.domain_ready(), "controller must expose domain readiness")
    assert_equal(controller.phase(), &"BUILD", "controller must boot BUILD")
    assert_equal(controller.model()["phase"], &"BUILD", "model must boot BUILD")
    var snapshot: Dictionary = controller.render_snapshot()
    assert_equal(snapshot["map_id"], &"FP_CORE_PROOF_01", "snapshot keeps map identity")
    assert_equal(snapshot["board_size"], Vector2i(11, 9), "snapshot exposes board size")
    assert_true(snapshot["layout_pieces"] is Array, "snapshot exposes immutable pieces")
```

- [ ] **Step 2: Register and run RED**

Add the test preload to `tests/run_tests.gd`, then run:

```bash
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tests/run_tests.gd
```

Expected: script load failure because `finite_slice_session_controller.gd` does not exist.

- [ ] **Step 3: Implement the minimum controller by moving orchestration, not copying rules**

Create the controller as a `RefCounted`. Move the current `FiniteSlice` constants, map/build/run fields, command match, build/run handlers, unload handling, presenter calls and retry/edit logic into it. Replace View access with signal emissions.

The render snapshot must have this stable shape:

```gdscript
{
    "map_id": StringName,
    "map_revision": int,
    "board_size": Vector2i,
    "start_cell": Vector2i,
    "incoming_cell": Vector2i,
    "buildable_cells": Array[Vector2i],
    "blocked_cells": Array[Vector2i],
    "station_placements": Array[Dictionary],
    "cargo_placements": Array[Dictionary],
    "layout_pieces": Array,
    "selected_cell": Vector2i,
    "selected_geometry": StringName,
    "problem_cells": Array[Vector2i],
    "phase": StringName,
    "train_cell": Vector2i,
    "train_next_cell": Vector2i,
    "switch_cells": Array[Vector2i],
    "stack_tokens": Array[Dictionary],
    "delivery_count": int,
}
```

All arrays and dictionaries returned from `model()`, `render_snapshot()` and `delivery_history()` must be duplicates.

- [ ] **Step 4: Run GREEN and full regression**

Expected: new controller test PASS and all pre-existing tests PASS.

- [ ] **Step 5: Commit**

```bash
git add game/finite/main/finite_slice_session_controller.gd \
        tests/finite/presentation/test_finite_slice_session_controller.gd \
        tests/run_tests.gd
git commit -m "refactor: extract finite slice session controller"
```

---

### Task 2: Convert the existing finite scene into a compatibility wrapper

**Files:**
- Modify: `game/finite/main/finite_slice.gd`
- Test: `tests/finite/presentation/test_finite_slice_commands.gd`
- Test: `tests/finite/integration/test_build_to_delivery_slice.gd`
- Create: `tests/finite/validation/test_finite_wrapper_controller_parity.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Consumes `FiniteSliceSessionController` from Task 1.
- Preserves existing `FiniteSlice` public methods and scene path.
- Produces `session_controller() -> RefCounted` for integration inspection without exposing private run fields.

- [ ] **Step 1: Write parity test before changing the wrapper**

The test must instantiate `finite_slice.tscn`, assert that `session_controller()` exists, build the alpha fixture through existing View signals, run to success, and compare wrapper and controller values:

```gdscript
assert_equal(slice.phase(), slice.session_controller().phase(), "phase parity")
assert_equal(
    slice.current_layout_signature(),
    slice.session_controller().current_layout_signature(),
    "layout identity parity"
)
assert_equal(
    slice.presenter_model(),
    slice.session_controller().model(),
    "model parity"
)
```

- [ ] **Step 2: Run RED**

Expected: failure because `session_controller()` does not exist and the wrapper still owns orchestration.

- [ ] **Step 3: Replace orchestration with delegation**

`finite_slice.gd` must only:

1. instantiate one controller in `_init()`;
2. initialize the proof map in `_ready()`;
3. connect the current View signals to `request_command()`;
4. apply `model_changed` to `View.apply_model()`;
5. delegate current public methods;
6. call `advance_time(delta)` from `_process()`.

Do not rename existing View signals or node paths.

- [ ] **Step 4: Remove tests that inspect `_run_session` directly**

Update `test_build_to_delivery_slice.gd` to use:

```gdscript
var runtime: Variant = slice.session_controller().active_run_session_for_test()
```

Expose `active_run_session_for_test()` only under the controller and document it as test support; it returns the current object reference but production presentation must use `render_snapshot()`.

- [ ] **Step 5: Run full suite and verify proof semantics**

Expected:
- A/B/A/A pickup order unchanged.
- 2→1→1 unload sequence unchanged.
- retry and edit tests unchanged.
- validation launcher tests unchanged.

- [ ] **Step 6: Commit**

```bash
git add game/finite/main/finite_slice.gd tests/finite tests/run_tests.gd
git commit -m "refactor: preserve finite validation wrapper on shared controller"
```

---

### Task 3: Add the demo flow state machine and F6 scene

**Files:**
- Create: `game/demo/demo_flow_controller.gd`
- Create: `game/demo/vertical_slice_demo.tscn`
- Create: `tests/demo/test_demo_flow_controller.gd`
- Create: `tests/demo/test_vertical_slice_demo_boot.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Produces states: `TITLE`, `CONTROLS`, `BRIEFING`, `GAMEPLAY`, `PAUSED`, `RESULT`.
- Produces methods:
  - `state() -> StringName`
  - `start_demo() -> void`
  - `open_controls() -> void`
  - `close_controls() -> void`
  - `begin_build() -> void`
  - `set_paused(paused: bool) -> void`
  - `show_result(summary: Variant) -> void`
  - `return_to_title() -> void`
- Produces signal `state_changed(state: StringName)`.

- [ ] **Step 1: Write state transition tests**

```gdscript
var flow := FlowScript.new()
assert_equal(flow.state(), &"TITLE", "demo boots at title")
flow.start_demo()
assert_equal(flow.state(), &"BRIEFING", "start opens briefing")
flow.begin_build()
assert_equal(flow.state(), &"GAMEPLAY", "briefing begins gameplay")
flow.set_paused(true)
assert_equal(flow.state(), &"PAUSED", "pause overlays gameplay")
flow.set_paused(false)
assert_equal(flow.state(), &"GAMEPLAY", "resume returns gameplay")
flow.show_result({"outcome": &"SUCCESS"})
assert_equal(flow.state(), &"RESULT", "terminal summary opens result")
flow.return_to_title()
assert_equal(flow.state(), &"TITLE", "result returns title")
```

Also assert invalid transitions do nothing, such as `begin_build()` from `TITLE`.

- [ ] **Step 2: Run RED**

Expected: scripts and scene missing.

- [ ] **Step 3: Implement flow and minimal scene hierarchy**

Scene nodes must include:

```text
VerticalSliceDemo
├─ Background
├─ TitleScreen
│  ├─ StartButton
│  ├─ ControlsButton
│  └─ QuitButton
├─ ControlsOverlay
├─ BriefingScreen
│  └─ BeginButton
├─ GameplayContainer
├─ PauseOverlay
└─ ResultOverlay
```

All screen visibility must derive from `DemoFlowController.state()`.

- [ ] **Step 4: Verify scene boots headlessly without changing `run/main_scene`**

The boot test loads and instantiates `res://game/demo/vertical_slice_demo.tscn`, then asserts `project.godot` still points to `res://game/main/main.tscn`.

- [ ] **Step 5: Commit**

```bash
git add game/demo tests/demo tests/run_tests.gd
git commit -m "feat: add vertical slice demo flow shell"
```

---

### Task 4: Add desktop InputMap actions and command adapter

**Files:**
- Create: `game/demo/input/desktop_input_adapter.gd`
- Create: `tests/demo/test_desktop_input_adapter.gd`
- Modify: `project.godot`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Produces signal `command_requested(command: StringName, payload: Variant)`.
- Produces pure method:
  - `command_for_action(action: StringName, pressed: bool, phase: StringName) -> Dictionary`
- Returned dictionary:

```gdscript
{"accepted": bool, "command": StringName, "payload": Variant}
```

- [ ] **Step 1: Write the action mapping test**

Required assertions:

```text
demo_tool_straight press → BUILD_TOOL / STRAIGHT in BUILD
demo_tool_curve press → BUILD_TOOL / CURVE in BUILD
demo_tool_switch press → BUILD_TOOL / SWITCH in BUILD
demo_tool_crossing press → BUILD_TOOL / CROSSING in BUILD
demo_rotate press → ROTATE in BUILD
demo_primary press → START in BUILD
demo_primary press → PAUSE in RUNNING/UNLOADING
demo_primary press → RESUME in PAUSED
demo_load press/release → LOAD_ACTIVE true/false in RUNNING/UNLOADING
demo_auto press → AUTO_TOGGLE in RUNNING/UNLOADING
demo_cancel press → CANCEL_SELECTION in BUILD
demo_cancel press → PAUSE in RUNNING/UNLOADING
demo_confirm press → FLOW_CONFIRM for shell consumption
```

Actions must be rejected in invalid phases.

- [ ] **Step 2: Run RED**

Expected: missing adapter and InputMap entries.

- [ ] **Step 3: Add exact InputMap actions**

Add these sections to `project.godot` using Godot event resources:

```text
demo_tool_straight = Key 1
demo_tool_curve = Key 2
demo_tool_switch = Key 3
demo_tool_crossing = Key 4
demo_rotate = Key R
demo_primary = Key Space
demo_load = Key Shift
demo_auto = Key A
demo_cancel = Key Escape
demo_confirm = Key Enter
```

Do not change `[application] run/main_scene`.

- [ ] **Step 4: Implement adapter using `_unhandled_input`**

Ignore keyboard echo events. When controls overlay or title/briefing consumes input, gameplay command emission must be disabled through `set_gameplay_enabled(enabled: bool)`.

- [ ] **Step 5: Run full suite and commit**

```bash
git add project.godot game/demo/input tests/demo tests/run_tests.gd
git commit -m "feat: add desktop finite command adapter"
```

---

### Task 5: Author the independent demo map and two successful route fixtures

**Files:**
- Create: `data/maps/vs_demo_01.json`
- Create: `tests/fixtures/finite/vs_demo_solution_alpha.gd`
- Create: `tests/fixtures/finite/vs_demo_solution_beta.gd`
- Create: `tests/finite/map/test_vs_demo_map.gd`
- Create: `tests/finite/integration/test_vs_demo_authored_solutions.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Map identity: `VS_DEMO_01@1`.
- Ruleset: `fp_core_v1`.
- Time limit: `120.0` seconds.
- Cargo contact intent: A → B → A → A.
- Must contain at least one persistent switch and allow two distinct successful initial switch configurations.

- [ ] **Step 1: Write map contract test**

Assert:

```gdscript
assert_equal(definition.identity_key(), "VS_DEMO_01@1", "independent map identity")
assert_equal(definition.board_size, Vector2i(11, 9), "16:9-friendly board")
assert_equal(definition.time_limit_seconds, 120.0, "demo time limit")
assert_equal(definition.cargo_placements.size(), 4, "four authored cargo")
assert_equal(definition.station_placements.size(), 2, "two station types")
assert_true(definition.validation_errors().is_empty(), "demo map validates")
```

Also assert the proof file SHA/content is untouched by reading both files and verifying different `map_id` values.

- [ ] **Step 2: Write authored solution integration test**

For alpha and beta fixtures:

1. initialize controller with `vs_demo_01.json`;
2. install pieces through `request_command()`;
3. assert preflight passes;
4. start run;
5. enable auto load;
6. advance until terminal;
7. assert `SUCCESS`;
8. assert solution identities differ.

- [ ] **Step 3: Run RED**

Expected: map and fixtures missing.

- [ ] **Step 4: Add exact map data**

Use the validated proof surface and placements as the starting topology but change identity and time limit; do not alter the proof file. The exact JSON must be:

```json
{
  "definition_schema_version": 2,
  "map_id": "VS_DEMO_01",
  "map_revision": 1,
  "ruleset_version": "fp_core_v1",
  "board_size": [11, 9],
  "start_cell": [1, 4],
  "incoming_cell": [0, 4],
  "time_limit_seconds": 120.0,
  "buildable_rects": [{"minimum": [1, 1], "maximum": [10, 8]}],
  "blocked_cells": [[4, 3], [6, 3], [4, 5], [6, 5]],
  "station_placements": [
    {"cell": [8, 5], "cargo_type": "RED_STAR", "rail_anchor": {"geometry": "STRAIGHT", "rotation_quarters": 1}},
    {"cell": [10, 7], "cargo_type": "BLUE_DIAMOND", "rail_anchor": {"geometry": "CURVE", "rotation_quarters": 3}}
  ],
  "cargo_placements": [
    {"cell": [9, 4], "cargo_type": "RED_STAR", "rail_anchor": {"geometry": "STRAIGHT", "rotation_quarters": 0}},
    {"cell": [10, 5], "cargo_type": "BLUE_DIAMOND", "rail_anchor": {"geometry": "STRAIGHT", "rotation_quarters": 1}},
    {"cell": [10, 6], "cargo_type": "RED_STAR", "rail_anchor": {"geometry": "STRAIGHT", "rotation_quarters": 1}},
    {"cell": [9, 7], "cargo_type": "RED_STAR", "rail_anchor": {"geometry": "STRAIGHT", "rotation_quarters": 0}}
  ]
}
```

Alpha and beta may share geometry but must differ in the initial exit of the first persistent switch, mirroring the proof fixtures without importing them.

- [ ] **Step 5: Run GREEN, full suite, and commit**

```bash
git add data/maps/vs_demo_01.json tests/fixtures/finite tests/finite tests/run_tests.gd
git commit -m "feat: add representative vertical slice demo map"
```

---

### Task 6: Build the product board renderer

**Files:**
- Create: `game/demo/presentation/demo_palette.gd`
- Create: `game/demo/presentation/product_board_renderer.gd`
- Create: `tests/demo/test_product_board_renderer.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Consumes controller `render_snapshot()`.
- Produces signals:
  - `cell_primary_requested(cell: Vector2i)`
  - `cell_secondary_requested(cell: Vector2i)`
  - `hover_changed(cell: Vector2i)`
- Produces methods:
  - `apply_snapshot(snapshot: Dictionary) -> void`
  - `board_cell_from_local(local: Vector2, board_size: Vector2i) -> Vector2i`
  - `snapshot_for_test() -> Dictionary`

- [ ] **Step 1: Write mapping and immutability tests**

Test center and edge mapping for 11×9, rejection outside the board, primary/secondary signal payload, and that modifying the source dictionary after `apply_snapshot()` does not change `snapshot_for_test()`.

- [ ] **Step 2: Run RED**

Expected: renderer missing.

- [ ] **Step 3: Implement self-contained CanvasItem drawing**

Use `_draw()` primitives only for this slice:

- cream map board and subtle grid;
- blocked cells with hatch/diagonal marks;
- fixed anchors with large station/cargo silhouettes;
- track geometry from piece geometry and rotation;
- hover outline, selected fill, ghost transparency;
- red problem-cell border and icon;
- switches with active-exit arrow;
- train body and direction triangle;
- cargo symbols: red/star and blue/diamond with text labels.

Use semantic constants from `demo_palette.gd`; do not hardcode gameplay values or mutate the controller.

- [ ] **Step 4: Add mouse and touch board input**

Left mouse/touch emits primary. Right mouse emits secondary. Input handling must not dispatch when the local position is outside the board.

- [ ] **Step 5: Run full suite and commit**

```bash
git add game/demo/presentation tests/demo tests/run_tests.gd
git commit -m "feat: render product finite board states"
```

---

### Task 7: Build the Korean product HUD and accessible state copy

**Files:**
- Create: `game/demo/presentation/product_hud.tscn`
- Create: `game/demo/presentation/product_hud.gd`
- Create: `tests/demo/test_product_hud.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Consumes controller model dictionary.
- Produces the same finite command signals as the validation View:
  - `build_tool_selected(tool: StringName)`
  - `rotate_requested()`
  - `remove_requested()`
  - `clear_requested()`
  - `start_requested()`
  - `load_active_changed(active: bool)`
  - `auto_toggle_requested()`
  - `pause_requested()`
  - `resume_requested()`
  - `retry_requested()`
  - `edit_requested()`
- Adds shell signal `title_requested()`.

- [ ] **Step 1: Write HUD phase tests**

Required Korean copy assertions:

```text
BUILD: 건설 단계 / 운행 시작 / 현재 비용 / 권장 기준
RUNNING: 운행 중 / 남은 시간 / 수동 적재 / 자동 적재 / 화물 TOP
UNLOADING: 하역 중
PAUSED: 일시정지 / 노선 확인 중
SUCCESS: 배송 완료
FAILURE: 배송 실패 / 제한 시간 종료
```

Assert no visible text contains `PHASE`, `CLOCK`, `STACK`, `SUCCESS`, `FAILURE`, `Train running`, or `Time expired`.

- [ ] **Step 2: Run RED**

Expected: scene/script missing.

- [ ] **Step 3: Implement phase-specific groups**

Scene must contain:

```text
ProductHUD
├─ TopStatus
├─ BuildToolbar
├─ RunToolbar
├─ StackPanel
├─ ProblemBanner
├─ PausePanel
└─ ResultPanel
```

Every primary touch target must have a minimum size of 48×48 logical pixels. Shortcut hints appear beside labels on desktop but do not replace button labels.

- [ ] **Step 4: Translate preflight reasons without hiding detail**

Map known primary codes to Korean headings and append the domain message as secondary diagnostic text. Unknown codes display `노선을 확인해 주세요` plus the original code.

- [ ] **Step 5: Run full suite and commit**

```bash
git add game/demo/presentation tests/demo tests/run_tests.gd
git commit -m "feat: add Korean product HUD for finite demo"
```

---

### Task 8: Integrate ProductFiniteSlice and complete retry/edit/title behavior

**Files:**
- Create: `game/demo/product_finite_slice.tscn`
- Create: `game/demo/product_finite_slice.gd`
- Modify: `game/demo/vertical_slice_demo.tscn`
- Modify: `game/demo/demo_flow_controller.gd`
- Create: `tests/demo/test_product_finite_slice_commands.gd`
- Create: `tests/demo/test_vertical_slice_end_to_end.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Product scene exports `map_path := "res://data/maps/vs_demo_01.json"`.
- Produces signals:
  - `terminal_reached(summary: Variant)`
  - `title_requested()`
  - `pause_changed(paused: bool)`
- Produces methods for tests:
  - `session_controller() -> RefCounted`
  - `install_layout_for_test(pieces: Array) -> bool`
  - `advance_time(delta_seconds: float) -> void`

- [ ] **Step 1: Write command-path parity test**

Assert HUD buttons, desktop adapter, left board click and touch all reach the same controller command names and payload types.

- [ ] **Step 2: Write end-to-end success test**

The test must:

1. instantiate `vertical_slice_demo.tscn`;
2. move TITLE → BRIEFING → GAMEPLAY;
3. install alpha layout;
4. start and enable auto load;
5. advance to SUCCESS;
6. choose same-layout retry and assert layout signature unchanged but attempt identity changed;
7. finish/fail and choose edit-layout;
8. assert phase is BUILD and the preserved layout signature is restored;
9. return to title and assert the old gameplay node/controller is freed.

- [ ] **Step 3: Run RED**

Expected: product scene and integration methods missing.

- [ ] **Step 4: Implement wiring**

`ProductFiniteSlice` owns exactly one controller. Connect renderer/HUD/input to controller commands, controller model/snapshot to View, terminal signal to shell, and shell pause/result actions back to commands. Right-click behavior:

```text
BUILD + selected cell containing track → REMOVE
BUILD + empty/no selected cell → CANCEL_SELECTION
RUNNING/UNLOADING → no track mutation
```

Add `CANCEL_SELECTION` to the controller as a presentation-safe command that only clears selected cell and geometry, then refreshes model/snapshot.

- [ ] **Step 5: Run full suite and commit**

```bash
git add game/demo game/finite/main tests/demo tests/run_tests.gd
git commit -m "feat: integrate complete product vertical slice flow"
```

---

### Task 9: Add non-authoritative effects and procedural audio

**Files:**
- Create: `game/demo/presentation/demo_effects.gd`
- Create: `game/demo/audio/demo_audio_director.gd`
- Create: `tests/demo/test_demo_effects_authority.gd`
- Create: `tests/demo/test_demo_audio_director.gd`
- Modify: `game/demo/product_finite_slice.tscn`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Effects methods:
  - `play_build(cell: Vector2i) -> void`
  - `play_remove(cell: Vector2i) -> void`
  - `play_unload(count: int) -> void`
  - `play_success() -> void`
  - `play_failure() -> void`
  - `cancel_all() -> void`
- Audio methods:
  - `play_cue(cue: StringName) -> void`
  - `set_train_loop_active(active: bool) -> void`
  - `set_paused(paused: bool) -> void`
  - `stop_all() -> void`

- [ ] **Step 1: Write authority tests**

Capture controller model/layout/summary, call every effect and cue method, advance Tweens/audio processing, then assert all captured domain values are unchanged.

- [ ] **Step 2: Run RED**

Expected: files missing.

- [ ] **Step 3: Implement Tween feedback**

Use short bounded Tweens:

```text
hover pulse: 0.18 s
build pop: 0.16 s
remove fade: 0.12 s
unload token stagger: total ≤ 1.0 s
success panel: 0.35 s
failure panel: 0.25 s
```

All Tweens must be killed on retry, edit, title return, or scene exit.

- [ ] **Step 4: Implement procedural cues with AudioStreamGenerator**

Generate short tones for `button`, `build`, `remove`, `switch`, `pickup`, `unload`, `success`, `failure`. The train loop is a low-volume repeating mechanical pulse active only in RUNNING/UNLOADING. Audio completion never triggers gameplay commands.

- [ ] **Step 5: Record provenance**

Update `docs/ASSET_RIGHTS_AND_PROVENANCE_RECORD.md` with a row stating that demo UI shapes and audio are generated in-engine from repository code, with no external asset dependency.

- [ ] **Step 6: Run full suite and commit**

```bash
git add game/demo tests/demo tests/run_tests.gd docs/ASSET_RIGHTS_AND_PROVENANCE_RECORD.md
git commit -m "feat: add non-authoritative demo effects and audio"
```

---

### Task 10: Verify responsive 16:9 layout and touch parity

**Files:**
- Create: `tests/demo/test_demo_responsive_layout.gd`
- Create: `tests/demo/test_demo_touch_parity.gd`
- Modify: `game/demo/vertical_slice_demo.tscn`
- Modify: `game/demo/product_finite_slice.tscn`
- Modify: `game/demo/presentation/product_hud.tscn`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Test viewports: 1280×720, 1600×900, 1920×1080.
- Safe-area contract: all critical controls remain within root rect and minimum 48×48.

- [ ] **Step 1: Write layout bounds test**

For each viewport size, instantiate the scene, set root size, process one frame, and assert these nodes are inside the root rect:

```text
TitleScreen/StartButton
BriefingScreen/BeginButton
GameplayContainer/ProductFiniteSlice/HUD/BuildToolbar
GameplayContainer/ProductFiniteSlice/HUD/RunToolbar
GameplayContainer/ProductFiniteSlice/HUD/StackPanel
PauseOverlay
ResultOverlay
```

- [ ] **Step 2: Write touch parity test**

Simulate one touch at a known board-cell center and compare the resulting controller command/payload with the mouse-primary request for the same cell. Compare LoadButton down/up with `Shift` press/release command payloads.

- [ ] **Step 3: Run RED**

Expected: bounds or touch parity failures before anchor/minimum-size correction.

- [ ] **Step 4: Correct anchors and containers**

Use anchors and container sizing rather than per-resolution offsets. Keep the board aspect readable and place the HUD in top/right/bottom bands without covering required anchors.

- [ ] **Step 5: Run full suite and commit**

```bash
git add game/demo tests/demo tests/run_tests.gd
git commit -m "test: verify responsive demo layout and touch parity"
```

---

### Task 11: Add a separate Windows Demo export without touching Android evidence

**Files:**
- Modify: `export_presets.cfg`
- Create: `.github/workflows/windows-demo-export.yml`
- Create: `tests/python/test_windows_demo_export_contract.py`
- Create: `tests/python/test_android_validation_preset_invariance.py`

**Interfaces:**
- New preset name: `Windows Demo`.
- Export path: `builds/windows/SwitchyExpressVerticalSlice.exe`.
- Custom feature: `vertical_slice_demo`.
- Artifact name: `switchy-express-windows-demo-${{ github.sha }}`.

- [ ] **Step 1: Write RED contract tests**

The Windows test parses `export_presets.cfg` and asserts the exact name, platform, path and feature. The Android invariance test captures and asserts these existing values remain unchanged:

```text
name = Android Validation
platform = Android
custom_features = validation_harness
export_path = builds/switchy-express-validation.apk
package/unique_name = com.alsdmlals4.switchyexpress.validation
architectures/arm64-v8a = true
```

- [ ] **Step 2: Run RED**

```bash
python -m pytest tests/python/test_windows_demo_export_contract.py \
    tests/python/test_android_validation_preset_invariance.py -q
```

Expected: Windows preset missing; Android invariance test passes.

- [ ] **Step 3: Add the Windows preset**

Append a Windows Desktop preset. Do not edit the Android preset block.

- [ ] **Step 4: Add pinned export workflow**

Workflow steps:

1. checkout;
2. download Godot 4.7.1 Linux binary;
3. download Godot 4.7.1 export templates;
4. install templates under `~/.local/share/godot/export_templates/4.7.1.stable`;
5. run headless test suite;
6. export `Windows Demo` with `--path . --headless --export-debug`;
7. assert `.exe` and `.pck` exist and are non-empty;
8. write SHA-256 manifest;
9. upload artifact.

- [ ] **Step 5: Run local contract tests and full Godot suite**

Do not claim Windows executable runtime PASS until the artifact is downloaded and launched on Windows.

- [ ] **Step 6: Commit**

```bash
git add export_presets.cfg .github/workflows/windows-demo-export.yml tests/python
git commit -m "ci: export isolated Windows vertical slice demo"
```

---

### Task 12: Final adversarial verification, documentation and handoff

**Files:**
- Create: `기획서/50_제작_검증/SX_AUD_020_PC_VERTICAL_SLICE_IMPLEMENTATION_AUDIT.md`
- Modify: `README.md`
- Modify: `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
- Modify: `기획서/00_프로젝트_허브/ACTIVE_CONTEXT.md`
- Modify: `기획서/00_프로젝트_허브/DEVELOPMENT_GATES.md`
- Modify: `기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md`

**Interfaces:**
- Audit result must distinguish automated, Windows-artifact, manual Windows runtime, Android, human and production gates.

- [ ] **Step 1: Run all automated checks from a clean checkout**

```bash
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tests/run_tests.gd
python -m pytest tests/python -q
```

Expected: zero Godot failures, no `SCRIPT ERROR`, zero pytest failures.

- [ ] **Step 2: Inspect PR diff for protected-boundary violations**

Reject the implementation if any of these occur:

```text
project.godot run/main_scene changed
finite proof map changed
Android validation launcher changed
Android package ID changed
canonical APK hash claimed as regenerated
Android/HUMAN/production gate marked PASS
View or effects mutate domain objects
multiple product stages added
```

- [ ] **Step 3: Execute manual PC checklist on Windows**

Record exact observations for:

```text
F6 scene launch
Title→Briefing→BUILD→RUN→Result
mouse left/right click
1–4, R, Space, Shift, A, Esc, Enter
success and failure
retry same layout
edit layout
return to title
1280×720 and 1920×1080
focus loss and Shift release
mute-independent information
Windows exported executable launch
```

Any unexecuted item remains `NOT_RUN`.

- [ ] **Step 4: Write `SX-AUD-020`**

Required conclusion fields:

```yaml
automated_tests: PASS | FAIL
windows_export_artifact: PASS | FAIL | NOT_RUN
windows_runtime_smoke: PASS | FAIL | NOT_RUN
android_device_smoke: NOT_RUN | prior truthful state
five_person_comprehension: NOT_RUN | prior truthful state
default_entrypoint: LEGACY
production_cutover: BLOCKED
p0_open: integer
p1_open: integer
```

- [ ] **Step 5: Update docs without overstating readiness**

README instructions must say:

```text
Open res://game/demo/vertical_slice_demo.tscn and press F6.
The default F5 entrypoint remains legacy until a separate cutover decision.
```

- [ ] **Step 6: Run final verification and commit**

```bash
git add README.md 기획서
git commit -m "docs: audit PC vertical slice demo implementation"
```

---

## Self-Review

### Spec coverage

- Single stage and 5–10 minute target: Task 5.
- Title, briefing, gameplay, pause and result: Tasks 3 and 8.
- Shared controller and no duplicate state: Tasks 1 and 2.
- Mouse and keyboard controls: Task 4.
- Touch preservation: Tasks 7, 8 and 10.
- Product board readability: Task 6.
- Korean product HUD: Task 7.
- Retry, edit and title return: Task 8.
- Effects and sound with no authority: Task 9.
- 1280×720, 1600×900, 1920×1080: Task 10.
- Windows debug export: Task 11.
- Android/default-entrypoint invariance: Tasks 3, 11 and 12.
- Rights/provenance: Task 9.
- Automated and manual adversarial review: Task 12.

### Placeholder scan

No `TBD`, `TODO`, `implement later`, unspecified tests, or unnamed files remain. Every task names concrete files, interfaces, RED command, GREEN expectation and commit boundary.

### Type consistency

- `FiniteSliceSessionController.model()` and `render_snapshot()` return duplicated `Dictionary` values in all consumers.
- Commands remain `StringName` with `Variant` payloads.
- `ProductFiniteSlice.session_controller()` returns the same controller contract used by compatibility tests.
- Flow states and finite phases remain separate `StringName` domains.
- Retry/edit semantics use existing run factory and layout snapshot APIs rather than UI state.

## Execution Order

Use an isolated worktree created from the latest `main`, then implement Tasks 1–12 sequentially. A task may not begin until its RED failure is observed and the prior task's full regression is green. Request code review after Tasks 2, 5, 8, 11 and 12.

Recommended execution mode: `superpowers:subagent-driven-development`, one fresh implementer per task with specification review and code-quality review between tasks.
