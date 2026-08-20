# SX-DEC-059 First-Session Vertical Slice Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the user-approved release-near first session `T1 → T6 → VS_DEMO_01` on the existing finite-delivery core without changing gameplay authority, while preserving the standalone historical demo and producing automated evidence before any human-experience claim.

**Architecture:** Keep `FiniteSliceSessionController` and all finite gameplay rules authoritative. Add a small first-session sidecar (`FirstSessionDefinition`, `FirstSessionStagePolicy`, `FirstSessionDirector`) and opt it into the existing `DemoFlowController` only when the `game/main/main.tscn` instance enables first-session mode. Every player command still converges on `ProductFiniteSlice._dispatch_command()`, so the stage policy is enforced once at that presentation boundary for HUD, keyboard, board, and route-control inputs.

**Tech Stack:** Godot `4.7.1-stable`, GDScript, existing custom headless suite, GUT `9.7.1`, current E+D Hybrid semantic assets, JSON data, existing `ProductFiniteSlice`/`DemoFlowController` presentation stack.

**Spec:**
- `기획서/50_제작_검증/SX_DEC_059_RELEASE_NEAR_FIRST_SESSION_VERTICAL_SLICE.md`
- `기획서/20_시스템_콘텐츠/FIRST_SESSION_STAGE_CONTENT_SPEC_V1.md`
- `기획서/30_UI_UX/FIRST_SESSION_SCREEN_CONTENT_DATA_CONTRACT.md`
- `기획서/30_UI_UX/FIRST_SESSION_LOCALIZATION_COPY_MATRIX_V1.md`
- `기획서/40_표현/SX_DEC_059_VISUAL_REQUIREMENT_BRIEFS.md`
- `기획서/50_제작_검증/SX_DEC_059_FIRST_SESSION_PLAYTEST_DELTA.md`

## Global Constraints

- Product baseline remains `GMB-002`.
- `FiniteMapDefinition` remains schema v2.
- Manual load default remains `false`; auto load default remains `false`.
- No change to LIFO, load eligibility, unload grouping, route topology/cycle/U-turn/occupied-lock, timer, failure, save, score, ruleset semantics.
- Do not implement SX-DEC-056A/056B/057/058 as part of 059.
- Do not modify, vendor, or absorb unmerged PR #154.
- Do not reactivate endless/fuel/BOOST/capacity-8/cargo-slowdown/pickup-respawn/switch-auto-reset.
- Existing 73 semantic product PNGs are reuse-first; no image generation task exists in this plan.
- `VS_DEMO_01` bytes and authored solution semantics remain unchanged unless a separately validated blocker proves otherwise.
- Player-facing failure copy may use only current `FiniteRunSummary` truth; no station-mismatch trace invention.
- New first-session copy is key/data driven. Current first release-near Chinese target is `zh-Hans`; add `zh-Hant` only when a later release profile requires it.
- Responsive meaning must remain equivalent across 1280×720, 1600×900, 1920×1080, wide-PC sanity, and mobile-landscape sanity.
- Every production behavior task obeys `RED → verify expected failure → minimal GREEN → focused GREEN → full regression GREEN`.
- Existing standalone `res://game/demo/vertical_slice_demo.tscn` behavior remains available with `first_session_enabled=false`.
- Actual physical Windows/Android and human evidence remain `NOT_RUN` until executed separately.

## Execution Preflight — perform before Task 1, do not commit preflight output

From a **fresh PowerShell** in the actual user checkout:

```powershell
$ErrorActionPreference = 'Stop'
$Repo = 'C:\Users\user\Documents\GitHub\Ninza\Switchy-Express-Cargo-Puzzle'
Write-Host '[0/6 LOCATION]'
Set-Location $Repo
Write-Host (Get-Location)

Write-Host '[1/6 GIT]'
git fetch origin --prune
git status --short --branch
git rev-parse HEAD
git rev-parse origin/main

Write-Host '[2/6 WORKTREE SAFETY]'
if (git status --porcelain) {
  Write-Host '[BLOCKED][DIRTY_WORKTREE] Preserve user changes; do not reset or overwrite.'
  exit 20
}

Write-Host '[3/6 GODOT]'
$godot = Get-Command godot -ErrorAction SilentlyContinue
if (-not $godot) { $godot = Get-Command Godot_v4.7.1-stable_win64.exe -ErrorAction SilentlyContinue }
if (-not $godot) { Write-Host '[BLOCKED][GODOT_NOT_FOUND]'; exit 21 }
& $godot.Source --version

Write-Host '[4/6 ADDON EVIDENCE]'
Get-Content .\addons\godot_ai\plugin.cfg | Select-String 'version='
Get-Content .\docs\tooling\local_godot_tooling_state.json

Write-Host '[5/6 BASELINE TEST]'
& $godot.Source --headless --path . --script res://tests/run_tests.gd
if ($LASTEXITCODE -ne 0) { Write-Host '[BLOCKED][BASELINE_TEST_RED]'; exit $LASTEXITCODE }

Write-Host '[6/6 READY]'
Write-Host '[PASS][PREFLIGHT_READY]'
```

Expected before implementation:

```text
project main/current implementation base is fresh
working tree clean
Godot reports 4.7.1-stable
project plugin.cfg reports 3.1.4
custom suite baseline GREEN
```

If local `HEAD`, `origin/main`, open PR state, or addon provenance differs from the planning snapshot, stop only the overlapping task, recover current authority, and update this plan's execution notes before editing production files.

---

## Planned File Structure

### New first-session owners

```text
game/first_session/first_session_definition.gd
    Load + validate first-session sequence data. No gameplay authority.

game/first_session/first_session_stage_policy.gd
    Immutable per-lesson UI visibility + command allow-list policy.

game/first_session/first_session_director.gd
    Lesson order and transition logic only.

game/first_session/first_session_copy.gd
    First-session localization lookup and fallback only.

data/first_session/first_session_v1.json
    T1~T6 + CAPSTONE sequence/policy data.

data/localization/first_session_v1.json
    ko/en/ja/zh-Hans copy values keyed by canonical IDs.
```

### New tutorial content

```text
data/maps/tutorial/tut_01_02.json
data/maps/tutorial/tut_03_lifo.json
data/maps/tutorial/tut_04_selective_load.json
data/maps/tutorial/tut_05_auto_load.json
data/maps/tutorial/tut_06_switch.json
```

### New deterministic test fixtures

```text
tests/fixtures/first_session/tut_01_02_solution.gd
tests/fixtures/first_session/tut_03_solution.gd
tests/fixtures/first_session/tut_04_solution_driver.gd
tests/fixtures/first_session/tut_05_solution_driver.gd
tests/fixtures/first_session/tut_06_solution_driver.gd
```

These fixtures are test-only private witnesses. They must never be read by player-facing runtime code.

### Existing seams to modify

```text
game/demo/product_finite_slice.gd
game/demo/presentation/product_hud.gd
game/demo/demo_flow_controller.gd
game/demo/vertical_slice_demo.tscn
game/main/main.tscn
game/finite/presentation/finite_slice_presenter.gd
tests/run_tests.gd
```

Do not modify `FiniteMapDefinition`, `UnlimitedCargoStack`, `FiniteDeliveryLoop`, `FiniteRunController`, track graph routing, or station unload authority unless a failing contract proves an existing read-only seam is insufficient and the finding is separately reviewed.

---

### Task 1: Sequence data and StagePolicy authority

**Files:**
- Create: `tests/first_session/test_first_session_definition.gd`
- Create: `tests/first_session/test_first_session_stage_policy.gd`
- Modify: `tests/run_tests.gd`
- Create: `game/first_session/first_session_definition.gd`
- Create: `game/first_session/first_session_stage_policy.gd`
- Create: `data/first_session/first_session_v1.json`

**Interfaces:**
- Produces: `FirstSessionDefinition.load_from_path(path: String) -> Variant`
- Produces: `definition.lesson_ids() -> Array[StringName]`
- Produces: `definition.lesson(lesson_id: StringName) -> Dictionary`
- Produces: `FirstSessionStagePolicy.create(lesson: Dictionary) -> Variant`
- Produces: `policy.allows_command(command: StringName, phase: StringName, payload: Variant = null) -> bool`
- Produces: `policy.feature_visible(feature: StringName) -> bool`
- Produces: `policy.context_key() -> StringName`

- [ ] **Step 1: Register the two new tests in `tests/run_tests.gd` and write the first RED definition test**

```gdscript
extends "res://tests/test_case.gd"

const DefinitionScript := preload("res://game/first_session/first_session_definition.gd")
const PATH := "res://data/first_session/first_session_v1.json"

func run() -> void:
    var definition: Variant = DefinitionScript.load_from_path(PATH)
    assert_not_null(definition, "first-session definition must load")
    if definition == null:
        return
    assert_equal(
        definition.lesson_ids(),
        [&"T1", &"T2", &"T3", &"T4", &"T5", &"T6", &"CAPSTONE"],
        "approved lesson order must remain canonical"
    )
    assert_equal(
        str(definition.lesson(&"T1").get("map_path", "")),
        str(definition.lesson(&"T2").get("map_path", "")),
        "T1/T2 must share one map"
    )
    assert_equal(
        str(definition.lesson(&"CAPSTONE").get("map_path", "")),
        "res://data/maps/vs_demo_01.json",
        "capstone must reuse VS_DEMO_01"
    )
```

- [ ] **Step 2: Run the custom suite and verify RED for missing first-session owners**

```bash
godot --headless --path . --script res://tests/run_tests.gd
```

Expected: FAIL because `first_session_definition.gd` / data do not exist. A parse typo or unrelated baseline failure is not an accepted RED.

- [ ] **Step 3: Author `data/first_session/first_session_v1.json` with the exact approved policy data**

```json
{
  "schema_version": 1,
  "sequence_id": "FIRST_SESSION_V1",
  "lessons": [
    {
      "lesson_id": "T1",
      "map_path": "res://data/maps/tutorial/tut_01_02.json",
      "completion_evidence": "PREFLIGHT_PASS",
      "objective_key": "SX_T1_OBJECTIVE",
      "context_key": "",
      "share_runtime_with_next": true,
      "visible_features": ["BOARD", "STRAIGHT", "CURVE", "ROTATE", "REMOVE", "CLEAR", "PREFLIGHT"],
      "allowed_build_tools": ["STRAIGHT", "CURVE"],
      "allowed_build_commands": ["BUILD_TOOL", "BOARD_CELL", "CANCEL_SELECTION", "ROTATE", "REMOVE", "CLEAR"],
      "allowed_run_commands": []
    },
    {
      "lesson_id": "T2",
      "map_path": "res://data/maps/tutorial/tut_01_02.json",
      "completion_evidence": "SUCCESS",
      "objective_key": "SX_T2_OBJECTIVE",
      "context_key": "SX_T2_LOAD_CUE",
      "share_runtime_with_next": false,
      "visible_features": ["BOARD", "LOAD", "CARGO_STATION"],
      "allowed_build_tools": [],
      "allowed_build_commands": ["START"],
      "allowed_run_commands": ["LOAD_ACTIVE", "PAUSE", "RESUME"]
    },
    {
      "lesson_id": "T3",
      "map_path": "res://data/maps/tutorial/tut_03_lifo.json",
      "completion_evidence": "SUCCESS",
      "objective_key": "SX_T3_OBJECTIVE",
      "context_key": "SX_T3_TOP_RULE",
      "share_runtime_with_next": false,
      "visible_features": ["BOARD", "STRAIGHT", "CURVE", "ROTATE", "REMOVE", "CLEAR", "PREFLIGHT", "LOAD", "STACK_TOP"],
      "allowed_build_tools": ["STRAIGHT", "CURVE"],
      "allowed_build_commands": ["BUILD_TOOL", "BOARD_CELL", "CANCEL_SELECTION", "ROTATE", "REMOVE", "CLEAR", "START"],
      "allowed_run_commands": ["LOAD_ACTIVE", "PAUSE", "RESUME"]
    },
    {
      "lesson_id": "T4",
      "map_path": "res://data/maps/tutorial/tut_04_selective_load.json",
      "completion_evidence": "SUCCESS",
      "objective_key": "SX_T4_OBJECTIVE",
      "context_key": "SX_T4_SKIP_CUE",
      "share_runtime_with_next": false,
      "visible_features": ["BOARD", "STRAIGHT", "CURVE", "ROTATE", "REMOVE", "CLEAR", "PREFLIGHT", "LOAD", "STACK_TOP"],
      "allowed_build_tools": ["STRAIGHT", "CURVE"],
      "allowed_build_commands": ["BUILD_TOOL", "BOARD_CELL", "CANCEL_SELECTION", "ROTATE", "REMOVE", "CLEAR", "START"],
      "allowed_run_commands": ["LOAD_ACTIVE", "PAUSE", "RESUME"]
    },
    {
      "lesson_id": "T5",
      "map_path": "res://data/maps/tutorial/tut_05_auto_load.json",
      "completion_evidence": "SUCCESS",
      "objective_key": "SX_T5_OBJECTIVE",
      "context_key": "SX_T5_AUTO_ON",
      "share_runtime_with_next": false,
      "visible_features": ["BOARD", "STRAIGHT", "CURVE", "ROTATE", "REMOVE", "CLEAR", "PREFLIGHT", "LOAD", "AUTO_LOAD", "STACK_TOP"],
      "allowed_build_tools": ["STRAIGHT", "CURVE"],
      "allowed_build_commands": ["BUILD_TOOL", "BOARD_CELL", "CANCEL_SELECTION", "ROTATE", "REMOVE", "CLEAR", "START"],
      "allowed_run_commands": ["LOAD_ACTIVE", "AUTO_TOGGLE", "PAUSE", "RESUME"]
    },
    {
      "lesson_id": "T6",
      "map_path": "res://data/maps/tutorial/tut_06_switch.json",
      "completion_evidence": "SUCCESS",
      "objective_key": "SX_T6_OBJECTIVE",
      "context_key": "SX_T6_PRESET_CUE",
      "share_runtime_with_next": false,
      "visible_features": ["BOARD", "STRAIGHT", "CURVE", "SWITCH", "ROTATE", "REMOVE", "CLEAR", "PREFLIGHT", "LOAD", "AUTO_LOAD", "STACK_TOP", "SWITCH_STATE"],
      "allowed_build_tools": ["STRAIGHT", "CURVE", "SWITCH"],
      "allowed_build_commands": ["BUILD_TOOL", "BOARD_CELL", "CANCEL_SELECTION", "ROTATE", "REMOVE", "CLEAR", "START"],
      "allowed_run_commands": ["LOAD_ACTIVE", "AUTO_TOGGLE", "BOARD_CELL", "SWITCH", "PAUSE", "RESUME"]
    },
    {
      "lesson_id": "CAPSTONE",
      "map_path": "res://data/maps/vs_demo_01.json",
      "completion_evidence": "SUCCESS_FINAL",
      "objective_key": "SX_CAPSTONE_OBJECTIVE",
      "context_key": "",
      "share_runtime_with_next": false,
      "visible_features": ["BOARD", "STRAIGHT", "CURVE", "SWITCH", "CROSSING", "ROTATE", "REMOVE", "CLEAR", "PREFLIGHT", "LOAD", "AUTO_LOAD", "STACK_TOP", "SWITCH_STATE", "TIME"],
      "allowed_build_tools": ["STRAIGHT", "CURVE", "SWITCH", "CROSSING"],
      "allowed_build_commands": ["BUILD_TOOL", "BOARD_CELL", "CANCEL_SELECTION", "ROTATE", "REMOVE", "CLEAR", "START"],
      "allowed_run_commands": ["LOAD_ACTIVE", "AUTO_TOGGLE", "BOARD_CELL", "SWITCH", "PAUSE", "RESUME"]
    }
  ]
}
```

`recommended layout` is intentionally absent from first-session features; standalone demo keeps its existing button.

- [ ] **Step 4: Implement `FirstSessionDefinition` as a strict read-only loader**

Requirements:

```gdscript
class_name FirstSessionDefinition
extends RefCounted

const SCHEMA_VERSION := 1
const REQUIRED_IDS: Array[StringName] = [&"T1", &"T2", &"T3", &"T4", &"T5", &"T6", &"CAPSTONE"]

static func load_from_path(path: String) -> Variant:
    # FileAccess → JSON.parse_string → create(data)
    pass

static func create(data: Dictionary) -> Variant:
    # reject wrong schema, missing/duplicate/out-of-order lesson IDs,
    # missing map paths, invalid command arrays, T1/T2 map mismatch,
    # capstone path drift
    pass

func lesson_ids() -> Array[StringName]:
    pass

func lesson(lesson_id: StringName) -> Dictionary:
    pass
```

Implementation must return defensive copies from public getters.

- [ ] **Step 5: Write RED StagePolicy tests before production policy code**

Assert at minimum:

```gdscript
var t1 := FirstSessionStagePolicy.create(definition.lesson(&"T1"))
assert_true(t1.allows_command(&"BUILD_TOOL", &"BUILD", &"STRAIGHT"))
assert_true(t1.allows_command(&"BUILD_TOOL", &"BUILD", &"CURVE"))
assert_false(t1.allows_command(&"BUILD_TOOL", &"BUILD", &"SWITCH"))
assert_false(t1.allows_command(&"START", &"BUILD"))
assert_false(t1.allows_command(&"AUTO_TOGGLE", &"RUNNING"))

var t5 := FirstSessionStagePolicy.create(definition.lesson(&"T5"))
assert_true(t5.allows_command(&"AUTO_TOGGLE", &"RUNNING"))
assert_false(t5.allows_command(&"SWITCH", &"RUNNING"))

var capstone := FirstSessionStagePolicy.create(definition.lesson(&"CAPSTONE"))
assert_true(capstone.allows_command(&"BUILD_TOOL", &"BUILD", &"CROSSING"))
assert_true(capstone.allows_command(&"BOARD_CELL", &"RUNNING"))
```

- [ ] **Step 6: Run and verify the StagePolicy test is RED for the missing class**

- [ ] **Step 7: Implement immutable StagePolicy**

`allows_command()` rules:

```text
BUILD_TOOL → command must be in build allow-list AND payload geometry in allowed_build_tools
BUILD phase → allowed_build_commands
RUNNING/UNLOADING → allowed_run_commands
PAUSED → only RESUME when listed
other → false
```

`feature_visible()` checks `visible_features`. Unknown feature returns false.

- [ ] **Step 8: Run focused + full custom suite GREEN**

- [ ] **Step 9: Commit**

```bash
git add tests/run_tests.gd tests/first_session game/first_session data/first_session
git commit -m "feat: add first-session sequence and stage policy"
```

---

### Task 2: Enforce StagePolicy at `ProductFiniteSlice` boundary

**Files:**
- Create: `tests/demo/test_first_session_product_policy.gd`
- Modify: `tests/run_tests.gd`
- Modify: `game/demo/product_finite_slice.gd`
- Modify: `game/demo/presentation/product_hud.gd`

**Interfaces:**
- Consumes: `FirstSessionStagePolicy`
- Produces: `ProductFiniteSlice.set_stage_policy(policy: Variant) -> void`
- Produces signal: `product_model_changed(model: Dictionary)`
- Produces: `ProductHUD.apply_stage_visibility(visible_features: Array) -> void`

- [ ] **Step 1: Write RED policy-bypass test**

Test a product scene with T1 policy and assert all four routes are blocked consistently:

```text
request_command("START")                    → phase remains BUILD
dispatch_action("demo_auto", true)          → no controller AUTO_TOGGLE
direct BUILD_TOOL payload SWITCH             → selection stays unchanged
apply_recommended_layout()                    → false
```

Then apply CAPSTONE policy and assert existing allowed commands still work.

- [ ] **Step 2: Verify RED because ProductFiniteSlice has no stage-policy seam**

- [ ] **Step 3: Add neutral-by-default policy state**

In `ProductFiniteSlice`:

```gdscript
signal product_model_changed(model: Dictionary)
var _stage_policy: Variant = null

func set_stage_policy(policy: Variant) -> void:
    _stage_policy = policy
    if is_instance_valid(_hud):
        _hud.apply_stage_visibility(_visible_features())

func _command_allowed(command: StringName, payload: Variant = null) -> bool:
    if _stage_policy == null:
        return true
    return bool(_stage_policy.allows_command(command, _controller.phase(), payload))
```

At the first line of `_dispatch_command`, return if not allowed. Do not alter `FiniteSliceSessionController` command meanings.

- [ ] **Step 4: Guard `apply_recommended_layout()` independently**

When a first-session policy exists, return false unless the policy explicitly exposes `RECOMMENDED_LAYOUT`. No current first-session lesson exposes it.

- [ ] **Step 5: Forward controller model changes without changing model ownership**

Replace the direct `model_changed.connect(_apply_model)` with a wrapper:

```gdscript
func _on_controller_model_changed(model: Dictionary) -> void:
    _apply_model(model)
    product_model_changed.emit(model.duplicate(true))
```

- [ ] **Step 6: Add HUD visibility API**

`ProductHUD.apply_stage_visibility()` must only hide/show current controls; it must not invent domain state. Explicit mappings:

```text
SWITCH → BuildToolbar/SwitchButton
CROSSING → BuildToolbar/CrossingButton
RECOMMENDED_LAYOUT → BuildToolbar/RecommendButton
LOAD → RunToolbar/LoadButton + ManualSemanticBadge
AUTO_LOAD → RunToolbar/AutoButton + AutoSemanticBadge
STACK_TOP → StackPanel
TIME → TopStatus/TimeLabel prominence/visibility
```

Base `apply_model()` phase visibility remains the first gate; stage visibility is the second gate.

- [ ] **Step 7: Run focused test GREEN, then full custom suite GREEN**

- [ ] **Step 8: Commit**

```bash
git add game/demo/product_finite_slice.gd game/demo/presentation/product_hud.gd tests/demo/test_first_session_product_policy.gd tests/run_tests.gd
git commit -m "feat: enforce first-session policy at product boundary"
```

---

### Task 3: Localization resolver and exact first-session copy data

**Files:**
- Create: `tests/first_session/test_first_session_copy.gd`
- Modify: `tests/run_tests.gd`
- Create: `game/first_session/first_session_copy.gd`
- Create: `data/localization/first_session_v1.json`

**Interfaces:**
- Produces: `FirstSessionCopy.load_default() -> bool`
- Produces: `copy.text(key: StringName, locale: String = "") -> String`
- Produces: `copy.format(key: StringName, values: Dictionary, locale: String = "") -> String`
- Supported locales: `ko`, `en`, `ja`, `zh-Hans`

- [ ] **Step 1: Write RED tests for all canonical keys and fallback**

Assertions:

```text
all keys in FIRST_SESSION_LOCALIZATION_COPY_MATRIX_V1 resolve in four locales
unknown locale falls back to English, then Korean if English missing
unknown key returns a safe empty string, never the raw key
format replaces {count} for result count keys
TOP remains literal TOP in all four locales
```

- [ ] **Step 2: Verify RED for missing copy owner**

- [ ] **Step 3: Author `data/localization/first_session_v1.json` by transcribing the approved matrix exactly**

Use canonical JSON shape:

```json
{
  "schema_version": 1,
  "locales": ["ko", "en", "ja", "zh-Hans"],
  "strings": {
    "SX_FS_START": {
      "ko": "첫 배송 시작",
      "en": "Start First Delivery",
      "ja": "最初の配送を始める",
      "zh-Hans": "开始首次配送"
    }
  }
}
```

Populate every matrix key, including Result copy. Do not shorten or rewrite approved meaning during implementation.

- [ ] **Step 4: Implement the resolver with locale normalization**

Normalize `zh`, `zh_CN`, `zh-CN` → `zh-Hans`. Do not claim `zh-Hant` support.

- [ ] **Step 5: Run focused + full custom suite GREEN**

- [ ] **Step 6: Commit**

```bash
git add game/first_session/first_session_copy.gd data/localization/first_session_v1.json tests/first_session/test_first_session_copy.gd tests/run_tests.gd
git commit -m "feat: add first-session localized copy data"
```

---

### Task 4: FirstSessionDirector state machine

**Files:**
- Create: `tests/first_session/test_first_session_director.gd`
- Modify: `tests/run_tests.gd`
- Create: `game/first_session/first_session_director.gd`

**Interfaces:**
- Consumes: `FirstSessionDefinition`
- Produces: `configure(definition: Variant) -> bool`
- Produces: `current_lesson_id() -> StringName`
- Produces: `current_lesson() -> Dictionary`
- Produces: `current_policy() -> Variant`
- Produces: `observe_model(model: Dictionary) -> Dictionary`
- Produces: `observe_terminal(summary: Variant) -> Dictionary`
- Produces: `reset() -> void`

Transition result shape:

```gdscript
{
    "changed": bool,
    "sequence_complete": bool,
    "preserve_gameplay_instance": bool,
    "previous_lesson": StringName,
    "current_lesson": StringName,
}
```

- [ ] **Step 1: Write RED transition tests**

Required transitions:

```text
boot → T1
T1 BUILD model with start_enabled=false → stay T1
T1 BUILD model with start_enabled=true → advance T2 + preserve gameplay
T2 SUCCESS → advance T3 + do not preserve gameplay
T3/T4/T5/T6 SUCCESS → advance one lesson
any FAILURE → stay same lesson
CAPSTONE SUCCESS → sequence_complete=true, stay CAPSTONE for final Result
reset → T1
```

- [ ] **Step 2: Verify RED**

- [ ] **Step 3: Implement pure director with no Scene/Godot input mutation**

The director must not call controller commands, touch cargo/route state, or inspect recommended solutions. It only interprets current model/terminal result and sequence data.

- [ ] **Step 4: Run focused + full suite GREEN**

- [ ] **Step 5: Commit**

```bash
git add game/first_session/first_session_director.gd tests/first_session/test_first_session_director.gd tests/run_tests.gd
git commit -m "feat: add first-session lesson director"
```

---

### Task 5: Opt-in first-session mode in existing demo shell

**Files:**
- Create: `tests/demo/test_first_session_flow_controller.gd`
- Modify: `tests/run_tests.gd`
- Modify: `game/demo/demo_flow_controller.gd`
- Modify: `game/demo/vertical_slice_demo.tscn`
- Modify: `game/main/main.tscn`

**Interfaces:**
- `DemoFlowController.@export var first_session_enabled: bool = false`
- Existing standalone demo behavior when false remains unchanged.
- `game/main/main.tscn` instance sets `first_session_enabled = true`.

- [ ] **Step 1: Write RED compatibility test**

Instantiate `res://game/demo/vertical_slice_demo.tscn` directly and assert:

```text
first_session_enabled == false
existing TITLE → BRIEFING → GAMEPLAY path still initializes VS_DEMO_01
existing controls/result actions remain callable
```

Instantiate `res://game/main/main.tscn` and assert its demo child has `first_session_enabled == true`.

- [ ] **Step 2: Verify RED because opt-in property does not exist**

- [ ] **Step 3: Add first-session boot path without deleting old flow**

When `first_session_enabled=false`, execute existing code path byte-for-byte in behavior.

When true on `_ready()`:

```text
load FirstSessionDefinition
configure FirstSessionDirector
load FirstSessionCopy
Title Start label = SX_FS_START
hide internal "PC VERTICAL SLICE" badge
BriefingScreen becomes compact Lesson Card
```

Do not add a second full shell scene.

- [ ] **Step 4: Set map path before adding ProductFiniteSlice child**

Refactor `_ensure_gameplay_instance()` to accept a path:

```gdscript
func _ensure_gameplay_instance(map_path: String = "res://data/maps/vs_demo_01.json") -> Control:
    if is_instance_valid(_gameplay):
        return _gameplay
    _gameplay = ProductScene.instantiate()
    _gameplay.name = "ProductFiniteSlice"
    _gameplay.map_path = map_path
    _gameplay.set_stage_policy(_first_session_director.current_policy() if first_session_enabled else null)
    container.add_child(_gameplay)
    ...
```

Set `map_path` before `add_child()` so `_ready()` initializes the correct definition.

- [ ] **Step 5: Connect `product_model_changed` only in first-session mode**

When T1 reaches `start_enabled=true`, call director `observe_model()`; transition to T2 Lesson Card **without freeing the gameplay instance**. Apply the new T2 policy to the same instance.

- [ ] **Step 6: Handle terminal results**

```text
FAILURE → existing ResultOverlay; do not advance lesson
SUCCESS T2~T6 → director advances; free old gameplay; show next Lesson Card
SUCCESS CAPSTONE → existing final ResultOverlay; sequence complete
```

T1 is completed by preflight, not terminal.

- [ ] **Step 7: Populate Lesson Card dynamically**

Use copy keys. In first-session mode:

- Title label = lesson title key.
- Objective label = objective key.
- Rules label hidden unless current lesson needs one one-line contextual rule.
- Begin button = locale-appropriate continue/start copy from existing matrix or a new key added in Task 3 with translations in all four locales.

Do not show a multi-rule wall.

- [ ] **Step 8: Run existing demo-flow tests plus new first-session-flow test GREEN**

- [ ] **Step 9: Full custom suite GREEN**

- [ ] **Step 10: Commit**

```bash
git add game/demo/demo_flow_controller.gd game/demo/vertical_slice_demo.tscn game/main/main.tscn tests/demo/test_first_session_flow_controller.gd tests/run_tests.gd
git commit -m "feat: add opt-in first-session flow to product entry"
```

---

### Task 6: Author MAP-01 and MAP-02 with deterministic private witnesses

**Files:**
- Create: `tests/first_session/test_tutorial_maps_t1_t3.gd`
- Modify: `tests/run_tests.gd`
- Create: `data/maps/tutorial/tut_01_02.json`
- Create: `data/maps/tutorial/tut_03_lifo.json`
- Create: `tests/fixtures/first_session/tut_01_02_solution.gd`
- Create: `tests/fixtures/first_session/tut_03_solution.gd`

**Interfaces:**
- Map files use existing `FiniteMapDefinition` schema v2 only.
- Fixture scripts expose `static func pieces() -> Array[Variant]`.

- [ ] **Step 1: Write RED structural assertions before map files**

T1/T2 contract:

```text
one cargo RED_STAR
one station RED_STAR
no switch/crossing required by private witness
private witness uses at least one CURVE
witness preflight PASS
same witness RUN with manual-load active at cargo contact reaches SUCCESS
```

T3 contract:

```text
cargo RED_STAR + BLUE_DIAMOND
station RED_STAR + BLUE_DIAMOND
no SWITCH/CROSSING in private witness
private successful pickup order is BLUE_DIAMOND → RED_STAR
first required unload target is RED_STAR
all cargo can be loaded; no selective skip required
SUCCESS under current LIFO authority
```

- [ ] **Step 2: Run and verify RED because map files are absent**

- [ ] **Step 3: Author the smallest handcrafted JSON and private fixtures satisfying those invariants**

Do not add a generator. Use the current `vs_demo_01.json` field shape:

```json
{
  "definition_schema_version": 2,
  "map_id": "TUT_01_02",
  "map_revision": 1,
  "ruleset_version": "fp_core_v1",
  "marker_tracks_player_built": true,
  "allow_open_terminals_after_required": true,
  "board_size": [7, 5],
  "start_cell": [1, 2],
  "incoming_cell": [0, 2],
  "time_limit_seconds": 60.0,
  "buildable_rects": [{"minimum": [1, 1], "maximum": [6, 4]}],
  "blocked_cells": [],
  "station_placements": [{"cell": [5, 3], "cargo_type": "RED_STAR"}],
  "cargo_placements": [{"cell": [3, 2], "cargo_type": "RED_STAR"}]
}
```

Use this as the first T1/T2 candidate; the private witness test is the authority on whether the selected cells/ports are valid. If it fails due to track geometry, change only tutorial data/fixture values, not finite-domain rules.

For T3, start with a compact `9×7` buildable board and place two cargo + two stations so a single non-switch path can encounter BLUE before RED and later visit RED station before BLUE station. The RED test must prove the final authored cells and witness, so the final committed JSON is not accepted until the exact run is GREEN.

- [ ] **Step 4: Verify focused tests GREEN**

- [ ] **Step 5: Full custom suite GREEN**

- [ ] **Step 6: Commit**

```bash
git add data/maps/tutorial tests/fixtures/first_session tests/first_session/test_tutorial_maps_t1_t3.gd tests/run_tests.gd
git commit -m "feat: add track and LIFO tutorial maps"
```

---

### Task 7: Author T4 selective-manual and T5 load-mode maps

**Files:**
- Create: `tests/first_session/test_tutorial_maps_t4_t5.gd`
- Modify: `tests/run_tests.gd`
- Create: `data/maps/tutorial/tut_04_selective_load.json`
- Create: `data/maps/tutorial/tut_05_auto_load.json`
- Create: `tests/fixtures/first_session/tut_04_solution_driver.gd`
- Create: `tests/fixtures/first_session/tut_05_solution_driver.gd`

**Interfaces:**
- Test drivers operate only through existing `input_state`, `run_controller`, graph/train read-only state, and current commands.
- No production solver or tutorial-only cargo flag.

- [ ] **Step 1: Write RED T4 behavioral contract**

Private witness must prove:

```text
Cargo A is loaded on first encounter
Cargo B is encountered but intentionally not loaded on first encounter
Cargo B remains in FixedCargoField
A is unloaded before B is later picked up
Cargo B is picked on a later revisit
final phase SUCCESS
```

Also prove `auto_load_enabled == false` for the successful witness.

- [ ] **Step 2: Write RED T5 behavioral contract**

Private witness must prove:

```text
AUTO_TOGGLE is enabled in RUN
at least two safe cargo pickups occur while auto=true
auto is toggled off before the ordering-sensitive cargo contact
that cargo is skipped while auto=false and manual=false
final run later succeeds using current load rules
```

Also keep a manual-only success witness to prove auto is convenience, not a new eligibility rule.

- [ ] **Step 3: Verify RED because T4/T5 maps/drivers are absent**

- [ ] **Step 4: Author compact loop/revisit maps using only STRAIGHT/CURVE**

Rules:

```text
T4: no SWITCH/CROSSING; route itself revisits the skipped cargo
T5: no SWITCH/CROSSING; one safe repeated-pickup segment then one selection-sensitive cargo
```

If the first authored topology cannot produce the required revisit under current graph rules, revise only the tutorial map and private fixture until the RED assertions become GREEN.

- [ ] **Step 5: Run focused tests GREEN and inspect event history assertions**

- [ ] **Step 6: Full suite GREEN**

- [ ] **Step 7: Commit**

```bash
git add data/maps/tutorial tests/fixtures/first_session tests/first_session/test_tutorial_maps_t4_t5.gd tests/run_tests.gd
git commit -m "feat: add selective and auto-load tutorial maps"
```

---

### Task 8: Author T6 switch-execution map

**Files:**
- Create: `tests/first_session/test_tutorial_map_t6.gd`
- Modify: `tests/run_tests.gd`
- Create: `data/maps/tutorial/tut_06_switch.json`
- Create: `tests/fixtures/first_session/tut_06_solution_driver.gd`

- [ ] **Step 1: Write RED contract**

The private test must prove:

```text
exactly one required player switch control at introduction complexity
both selected exits are visually/queryably distinguishable through existing route-control state
preselecting before arrival changes the next route
attempted cycle while train occupies the switch is rejected/locked by existing authority
no switch auto-reset occurs
a deterministic legal sequence reaches SUCCESS
```

- [ ] **Step 2: Verify RED**

- [ ] **Step 3: Author the smallest current-schema map + private route driver**

Reuse existing `tests/fixtures/finite/three_direction_switch_driver.gd` logic only if its contract fits without leaking a solution into production. Otherwise create a first-session-specific test fixture; do not modify production switch rules.

- [ ] **Step 4: Focused GREEN + full regression GREEN**

- [ ] **Step 5: Commit**

```bash
git add data/maps/tutorial/tut_06_switch.json tests/fixtures/first_session/tut_06_solution_driver.gd tests/first_session/test_tutorial_map_t6.gd tests/run_tests.gd
git commit -m "feat: add switch execution tutorial map"
```

---

### Task 9: Evidence-safe Result copy

**Files:**
- Create: `tests/finite/presentation/test_sx_dec_059_result_summary.gd`
- Create: `tests/demo/test_first_session_result_copy.gd`
- Modify: `tests/run_tests.gd`
- Modify: `game/finite/presentation/finite_slice_presenter.gd`
- Modify: `game/demo/demo_flow_controller.gd`

**Interfaces:**
- Presenter model adds read-only `remaining_map_cargo` and `stack_size` in result state.
- First-session shell formats only approved summary facts.

- [ ] **Step 1: Write RED presenter test**

Given `FiniteRunSummary(FAILURE, ..., remaining=2, stack=1, ROUTE_END)`, assert result model contains:

```gdscript
model["primary_reason"] == &"ROUTE_END"
model["remaining_map_cargo"] == 2
model["stack_size"] == 1
```

- [ ] **Step 2: Write RED first-session Result copy test**

Assert output contains localized `SX_RESULT_ROUTE_END`, `SX_RESULT_MAP_CARGO`, `SX_RESULT_STACK_CARGO`, and exact numeric values. Assert it does **not** contain guessed cargo type/station names or strings `optimal`, `recommended`, `solution`.

- [ ] **Step 3: Verify RED**

- [ ] **Step 4: Add only summary projections in presenter**

Do not change `FiniteRunSummary` or `FiniteRunController`.

- [ ] **Step 5: Update first-session `_update_result_copy()` branch**

For first-session mode:

```text
SUCCESS → SX_RESULT_SUCCESS + existing completion/cost facts if desired
ROUTE_END → reason + map count + train count
TIME_EXPIRED → reason + map count + train count
```

Standalone demo branch keeps existing legacy copy behavior unless a test-proven shared-safe simplification is made.

- [ ] **Step 6: Focused GREEN + full regression GREEN**

- [ ] **Step 7: Commit**

```bash
git add game/finite/presentation/finite_slice_presenter.gd game/demo/demo_flow_controller.gd tests/finite/presentation/test_sx_dec_059_result_summary.gd tests/demo/test_first_session_result_copy.gd tests/run_tests.gd
git commit -m "feat: add evidence-safe first-session result summary"
```

---

### Task 10: Full first-session E2E + capstone transfer

**Files:**
- Create: `tests/demo/test_first_session_end_to_end.gd`
- Modify: `tests/run_tests.gd`
- Modify only if RED proves needed: first-session/demo presentation files from Tasks 1–9

- [ ] **Step 1: Write RED E2E sequence test**

The test must drive the public first-session flow enough to prove:

```text
F5-equivalent main scene boots first-session Title
T1 enters MAP-01 and START is policy-blocked
T1 valid preflight advances to T2 without replacing gameplay/layout identity
T2 success advances to T3 with a new gameplay instance/map
T3 → T4 → T5 → T6 → CAPSTONE lesson order is exact
CAPSTONE map_id == VS_DEMO_01
standalone vertical_slice_demo.tscn still boots old single-demo behavior
```

Use private fixtures for deterministic route completion; never expose fixtures to runtime.

- [ ] **Step 2: Verify RED**

- [ ] **Step 3: Minimal integration fixes only**

Do not widen into campaign selection, save progression, Daily/Weekly, Lab/Mastery, or scoring.

- [ ] **Step 4: Assert `VS_DEMO_01` integrity**

Keep a test that compares the expected map identity/revision/content invariants and existing alpha/beta solution proofs. Do not rewrite the map.

- [ ] **Step 5: Focused GREEN + full custom suite GREEN**

- [ ] **Step 6: Commit**

```bash
git add tests/demo/test_first_session_end_to_end.gd tests/run_tests.gd game/first_session game/demo game/main
git commit -m "feat: integrate first-session vertical slice flow"
```

---

### Task 11: Responsive, Reduced Motion, and accessibility regression

**Files:**
- Create: `tests/demo/test_first_session_responsive_accessibility.gd`
- Modify: `tests/run_tests.gd`
- Modify only as RED proves necessary: `game/demo/presentation/product_hud.gd`, `game/demo/vertical_slice_demo.tscn`

- [ ] **Step 1: Write RED/extension tests for semantic visibility rather than pixel snapshots**

At 1280×720, 1600×900, 1920×1080 assert first-session RUN retains:

```text
board visible
Stack/TOP visible when lesson policy says STACK_TOP
Load visible from T2 onward when policy says LOAD
Auto hidden before T5, visible T5+
Switch state hidden before T6, visible T6+
Result Retry/Edit reachable
```

- [ ] **Step 2: Add a wide-PC and mobile-landscape layout sanity**

Assert controls remain inside viewport and minimum interactive size retains the existing 48px contract for relevant visible buttons.

- [ ] **Step 3: Reduced Motion test**

Enable `ProductFiniteSlice.set_reduced_motion(true)` and assert information keys/state remain identical while motion presentation can differ.

- [ ] **Step 4: Non-color redundancy test**

Assert cargo/station descriptors still expose shape/text identity and TOP/switch lock have non-color meaning.

- [ ] **Step 5: Run GREEN + full regression**

- [ ] **Step 6: Commit**

```bash
git add tests/demo/test_first_session_responsive_accessibility.gd tests/run_tests.gd game/demo
git commit -m "test: protect first-session responsive accessibility"
```

---

### Task 12: Formal GUT product-entry smoke

**Files:**
- Create: `tests/gut/unit/test_sx_dec_059_first_session.gd`

- [ ] **Step 1: Write GUT test before any GUT-specific production change**

Use scene load/instantiation to assert:

```text
main scene resolves
main scene opts into first_session_enabled
first-session definition loads
T1/T2 same map
CAPSTONE resolves to VS_DEMO_01
```

This is a formal consumer smoke, not a duplicate of detailed custom-suite domain tests.

- [ ] **Step 2: Run GUT exactly like CI**

```bash
godot --headless --path . --script res://addons/gut/gut_cmdln.gd -gexit
```

Expected: GREEN with no `SCRIPT ERROR`, `[GUT ERROR]`, or nonzero Errors summary.

- [ ] **Step 3: Run custom suite again**

```bash
godot --headless --path . --script res://tests/run_tests.gd
```

- [ ] **Step 4: Commit**

```bash
git add tests/gut/unit/test_sx_dec_059_first_session.gd
git commit -m "test: add formal GUT first-session smoke"
```

---

### Task 13: Package / entrypoint / no-scope-creep verification

**Files:**
- Modify only if a failing contract proves packaging needs data inclusion: export/project packaging owner already used by current project.
- Create: `기획서/50_제작_검증/SX_AUD_059_IMPLEMENTATION_EVIDENCE.md` only during actual BUILD execution, populated with real results.

- [ ] **Step 1: Run static Python/project-contract checks used by current workflows**

Use repository-current workflow commands; do not copy stale command names if the workflow changed after handoff.

- [ ] **Step 2: Run Godot import and fail on script/runtime errors**

```bash
godot --headless --import --path .
```

- [ ] **Step 3: Run custom suite**

```bash
godot --headless --path . --script res://tests/run_tests.gd
```

- [ ] **Step 4: Run formal GUT**

```bash
godot --headless --path . --script res://addons/gut/gut_cmdln.gd -gexit
```

- [ ] **Step 5: Verify changed paths against approved scope**

Reject the implementation if the diff changes any of the following without a separately validated reason:

```text
game/finite/cargo/unlimited_cargo_stack.gd
game/finite/delivery/* gameplay semantics
game/finite/run/finite_run_controller.gd route/time/failure semantics
game/finite/rail/* routing semantics
data/maps/vs_demo_01.json
art/product_assets/ed_hybrid_v1/*.png
SX-DEC-056~058 implementation owners
game/reuse/* from unmerged PR #154
```

- [ ] **Step 6: Verify first-session data is packaged**

Export/package proof must include:

```text
data/first_session/first_session_v1.json
data/localization/first_session_v1.json
data/maps/tutorial/*.json
```

Use the project's existing exported-pack proof approach rather than adding a second packaging authority.

- [ ] **Step 7: Windows export/package evidence**

Run the repository-current Windows export workflow/command and record exact artifact identity. This is package evidence only.

- [ ] **Step 8: Developer self-run after automated GREEN**

Run the exact scenarios from `SX_DEC_059_FIRST_SESSION_PLAYTEST_DELTA.md`:

```text
T1→T6→Capstone happy path
T3 wrong order → Edit → recovery
T4 overload → skip/revisit recovery
T5 Auto ON → OFF decision
T6 occupied lock + route success
Capstone Retry
Capstone Edit
Reduced Motion
```

Record `NOT_RUN` for any scenario not actually executed.

- [ ] **Step 9: Do not run/claim first-contact human PASS in Codex implementation**

Human acceptance requires later exact-build physical smoke + Five-person sessions.

- [ ] **Step 10: Commit real evidence doc only with actual command/run IDs/results**

```bash
git add 기획서/50_제작_검증/SX_AUD_059_IMPLEMENTATION_EVIDENCE.md
git commit -m "docs: record SX-DEC-059 implementation evidence"
```

---

## Final implementation review before PR

Run this self-review on the exact candidate head:

### Spec coverage

```text
T1 track connection              → Tasks 5,6,10
T2 basic pickup/station          → Tasks 1,5,6,10
T3 LIFO reverse planning         → Tasks 1,6,10
T4 selective non-load/revisit    → Tasks 1,7,10
T5 auto convenience/decision     → Tasks 1,7,10
T6 switch planning/lock          → Tasks 1,8,10
Capstone                         → Tasks 1,10
StagePolicy bypass protection    → Task 2
Localization                    → Task 3
Evidence-safe Result            → Task 9
Responsive/Reduced Motion       → Task 11
Formal GUT                      → Task 12
Package/scope/evidence          → Task 13
```

### Forbidden-placeholder scan

Implementation commits may not contain player-facing `TBD`, `TODO`, dummy cargo/station labels, raw localization keys, placeholder art, or fake evidence values.

### Authority regression

Confirm:

```text
GMB-002 unchanged
056~058 not implemented
PR #154 delta not absorbed
VS_DEMO_01 unchanged
73 semantic assets unchanged
manual/auto/LIFO/switch rules unchanged
human evidence still NOT_RUN unless separately executed
```

## Rollback

Because 059 is sidecar-first, rollback is bounded:

```text
restore game/main/main.tscn first_session opt-in
remove first-session sidecar/data/tutorial maps/tests
restore ProductFiniteSlice/HUD/DemoFlow presentation seams
keep finite core / VS_DEMO_01 / 73 assets untouched
```

Do not rollback by resetting unrelated user changes or PR #154.

## Package Definition of Ready

The implementation package is ready for Codex handoff only when all are true:

```yaml
user_planning_complete: GRANTED
phase_c_final_review: PASS
current_canon_sync: PASS
notion_readback: PASS
protected_pr_154: READ_ONLY_CONFIRMED
v4_7_adapter: CURRENT
Godot_AI_3_1_4_provenance: REVERIFY_AT_EXECUTION_PREFLIGHT
baseline_tests: MUST_PASS_AT_FRESH_POWERSHELL_PREFLIGHT
human_evidence_requirement: NOT_REQUIRED_TO_START_BUILD
codex_handoff_trigger: USER_REQUESTED_CODEX_HANDOFF
```

Until the final trigger is present: `PACKAGE_READY · BUILD_NOT_STARTED`.
