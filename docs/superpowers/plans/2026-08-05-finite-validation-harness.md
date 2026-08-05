# Finite Validation Harness Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a validation-only Godot launcher with real proof-Slice mode, exact 8/16/32 presenter stack modes, and an Android debug preset that selects the launcher through a custom feature without changing the production default entrypoint.

**Architecture:** Keep gameplay authority unchanged. A small launcher under `tools/validation/finite/` mounts either the real finite Slice or the real finite view with presenter-generated stack fixtures. The Android preset supplies `validation_harness`; `project.godot` uses a feature-specific `application/run/main_scene` override while preserving the base legacy main.

**Tech Stack:** Godot 4.7.1-stable, GDScript, `PackedScene`, `FiniteSlicePresenter`, custom test harness, Godot export preset `ConfigFile` format.

## Global Constraints

- Product authority is `GMB-002 · SX-DEC-027~036`.
- Execution authority is `FP-DOR-001 · EV-USER-021`.
- Validation preparation must not change build, rail, cargo, delivery, timer, retry, save, or campaign rules.
- Base `run/main_scene` remains `res://game/main/main.tscn`.
- `game/main/main.tscn` must not change.
- Validation files live under `tools/validation/finite/`.
- Supported modes are exactly `PROOF`, `STACK_8`, `STACK_16`, and `STACK_32`.
- Invalid modes fail closed and mount no child.
- Stack fixtures use presenter descriptors and do not write product runtime state.
- Android preset custom feature is exactly `validation_harness`.
- Android validation package ID is `com.alsdmlals4.switchyexpress.validation`.
- No keystore password, secret, or machine-specific Android SDK path may be committed.
- Completion changes `VALIDATION_PREP` only; Android/HUMAN remain `NOT_RUN`, cutover remains `BLOCKED`.
- Full test command:

```bash
./Godot_v4.7.1-stable_linux.x86_64 --headless --path . --script res://tests/run_tests.gd
```

---

### Task 1: Register RED Validation Contracts

**Files:**
- Create: `tests/finite/validation/test_finite_validation_launcher.gd`
- Create: `tests/finite/validation/test_validation_stack_modes.gd`
- Create: `tests/finite/validation/test_validation_entrypoint_invariance.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Consumes: planned launcher path `res://tools/validation/finite/finite_validation_launcher.tscn`.
- Produces: failing tests that define launcher, stack, and configuration contracts.

- [ ] **Step 1: Add three test preloads**

Insert after `test_finite_adversarial_cases.gd`:

```gdscript
preload("res://tests/finite/validation/test_finite_validation_launcher.gd"),
preload("res://tests/finite/validation/test_validation_stack_modes.gd"),
preload("res://tests/finite/validation/test_validation_entrypoint_invariance.gd"),
```

- [ ] **Step 2: Write launcher RED test**

Required assertions:

```gdscript
extends "res://tests/test_case.gd"

const LAUNCHER_SCENE := "res://tools/validation/finite/finite_validation_launcher.tscn"

func run() -> void:
    assert_true(ResourceLoader.exists(LAUNCHER_SCENE, "PackedScene"), "validation launcher scene must exist")
    if not ResourceLoader.exists(LAUNCHER_SCENE, "PackedScene"):
        return
    var packed: PackedScene = load(LAUNCHER_SCENE)
    var launcher: Control = packed.instantiate()
    var tree := Engine.get_main_loop() as SceneTree
    assert_not_null(tree, "launcher test requires SceneTree")
    if tree == null:
        launcher.free()
        return
    tree.root.add_child(launcher)
    assert_equal(launcher.active_mode(), &"PROOF", "launcher must default to proof mode")
    assert_equal(launcher.active_scene_path(), "res://game/finite/main/finite_slice.tscn", "proof mode must mount the real finite slice")
    assert_not_null(launcher.mounted_child(), "proof mode must mount a child")
    assert_true(launcher.configure_mode(&"STACK_8"), "stack mode must configure")
    assert_equal(launcher.stack_fixture_size(), 8, "stack8 must report exact fixture size")
    assert_false(launcher.configure_mode(&"UNKNOWN"), "unknown mode must fail closed")
    assert_equal(launcher.last_error(), &"INVALID_MODE", "unknown mode must expose stable error")
    assert_equal(launcher.mounted_child(), null, "invalid mode must leave no child mounted")
    launcher.queue_free()
```

- [ ] **Step 3: Write stack RED test**

For each `{STACK_8: 8, STACK_16: 16, STACK_32: 32}`:

```gdscript
assert_true(launcher.configure_mode(mode), "%s must configure" % mode)
var child: Node = launcher.mounted_child()
assert_true(child.has_method("last_model"), "stack fixture must mount the real finite view")
var model: Dictionary = child.last_model()
var tokens: Array = model.get("stack_tokens", [])
assert_equal(tokens.size(), expected_size, "%s must expose exact tokens" % mode)
var top_count := 0
for index: int in range(tokens.size()):
    var token: Dictionary = tokens[index]
    top_count += 1 if bool(token.get("top", false)) else 0
    assert_not_equal(StringName(token.get("color", &"")), &"", "token must expose color")
    assert_not_equal(StringName(token.get("shape", &"")), &"", "token must expose shape")
    assert_not_equal(str(token.get("label", "")), "", "token must expose text label")
    assert_equal(int(token.get("index", -1)), index, "token index must be stable")
assert_equal(top_count, 1, "%s must have exactly one TOP" % mode)
assert_true(bool(tokens[-1].get("top", false)), "%s TOP must be final/rear" % mode)
```

Also assert `FiniteCargoStack` and map/session classes are never instantiated by checking the mounted child is `FiniteSliceView`, not `FiniteSlice`.

- [ ] **Step 4: Write entrypoint/preset RED test**

Read text using `FileAccess.get_file_as_string()` and assert:

```gdscript
assert_true(project_text.contains("run/main_scene=\"res://game/main/main.tscn\""), "base production main must remain legacy")
assert_true(project_text.contains("run/main_scene.validation_harness=\"res://tools/validation/finite/finite_validation_launcher.tscn\""), "feature override must target validation launcher")
assert_true(preset_text.contains("name=\"Android Validation\""), "validation preset name must exist")
assert_true(preset_text.contains("custom_features=\"validation_harness\""), "preset must activate validation feature")
assert_true(preset_text.contains("package/unique_name=\"com.alsdmlals4.switchyexpress.validation\""), "validation package ID must be isolated")
assert_false(preset_text.to_lower().contains("password"), "preset must not commit passwords")
assert_false(preset_text.contains("C:\\"), "preset must not commit Windows SDK paths")
assert_false(preset_text.contains("/Users/"), "preset must not commit macOS user paths")
assert_false(preset_text.contains("/home/"), "preset must not commit Linux user paths")
```

Pin the current approved `game/main/main.tscn` SHA-256 by reading bytes with `HashingContext` and comparing to the baseline computed in this task's RED commit.

- [ ] **Step 5: Run CI and verify RED**

Expected:

```text
Project Contract: PASS
Godot Tests: FAIL
```

The new tests should fail because launcher files, feature override, and `export_presets.cfg` do not exist. Existing 60 tests must remain green.

- [ ] **Step 6: Commit**

```bash
git add tests/finite/validation tests/run_tests.gd
git commit -m "test: define finite validation harness contracts"
```

---

### Task 2: Implement the Isolated Validation Launcher

**Files:**
- Create: `tools/validation/finite/validation_run_state_fixture.gd`
- Create: `tools/validation/finite/finite_validation_launcher.gd`
- Create: `tools/validation/finite/finite_validation_launcher.tscn`
- Test: `tests/finite/validation/test_finite_validation_launcher.gd`
- Test: `tests/finite/validation/test_validation_stack_modes.gd`

**Interfaces:**
- Consumes: `FiniteSlicePresenter.show_run(run_state, load_order, auto_load_active, final_cost)` and the two real scenes.
- Produces: `configure_mode()`, `active_mode()`, `active_scene_path()`, `stack_fixture_size()`, `last_error()`, and `mounted_child()`.

- [ ] **Step 1: Add run-state presentation fixture**

```gdscript
class_name ValidationRunStateFixture
extends RefCounted

func phase() -> StringName:
    return &"RUNNING"

func elapsed_seconds() -> float:
    return 0.0

func time_limit_seconds() -> float:
    return 90.0
```

This class contains no mutation or domain logic.

- [ ] **Step 2: Add launcher scene**

```ini
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://tools/validation/finite/finite_validation_launcher.gd" id="1_launcher"]

[node name="FiniteValidationLauncher" type="Control"]
layout_mode = 3
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
grow_horizontal = 2
grow_vertical = 2
script = ExtResource("1_launcher")

[node name="Mount" type="Control" parent="."]
layout_mode = 1
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
grow_horizontal = 2
grow_vertical = 2
```

- [ ] **Step 3: Implement launcher constants and argument parsing**

Use exact constants:

```gdscript
class_name FiniteValidationLauncher
extends Control

const MODE_PROOF: StringName = &"PROOF"
const MODE_STACK_8: StringName = &"STACK_8"
const MODE_STACK_16: StringName = &"STACK_16"
const MODE_STACK_32: StringName = &"STACK_32"
const PROOF_SCENE_PATH := "res://game/finite/main/finite_slice.tscn"
const VIEW_SCENE_PATH := "res://game/finite/presentation/finite_slice_view.tscn"
```

`mode_from_user_args(args: PackedStringArray) -> StringName` maps `proof`, `stack8`, `stack16`, and `stack32`; no recognized argument returns `PROOF`.

- [ ] **Step 4: Implement fail-closed reconfiguration**

`configure_mode()` must:

1. remove and `queue_free()` the previous child;
2. clear active fields;
3. reject unknown modes with `INVALID_MODE`;
4. load the expected `PackedScene` or return `MISSING_SCENE`;
5. mount proof or stack view;
6. set active fields only after successful mounting.

Do not fall back from a failed requested mode to proof.

- [ ] **Step 5: Build stack presentation models**

Create a repeating load order from:

```gdscript
[&"RED_STAR", &"BLUE_DIAMOND", &"YELLOW_TRIANGLE"]
```

Call:

```gdscript
var presenter := FiniteSlicePresenter.new()
presenter.show_run(ValidationRunStateFixture.new(), load_order, false, 0)
view.apply_model(presenter.model())
```

Expose exact fixture size but do not expose or instantiate cargo-domain state.

- [ ] **Step 6: Run CI and verify launcher GREEN**

Expected launcher and stack tests pass. Entrypoint/preset test remains RED until Task 3.

- [ ] **Step 7: Commit**

```bash
git add tools/validation/finite tests/finite/validation
git commit -m "feat: add isolated finite validation launcher"
```

---

### Task 3: Add Android Feature Override and Export Preset

**Files:**
- Create: `export_presets.cfg`
- Modify: `project.godot`
- Test: `tests/finite/validation/test_validation_entrypoint_invariance.gd`

**Interfaces:**
- Consumes: launcher scene from Task 2.
- Produces: an `Android Validation` debug export preset that activates `validation_harness`.

- [ ] **Step 1: Add feature-specific main-scene override**

Under `[application]`, preserve the existing base line and add:

```ini
run/main_scene="res://game/main/main.tscn"
run/main_scene.validation_harness="res://tools/validation/finite/finite_validation_launcher.tscn"
```

Do not modify `game/main/main.tscn`.

- [ ] **Step 2: Add minimal Android validation preset**

Use this provider-neutral structure:

```ini
[preset.0]

name="Android Validation"
platform="Android"
runnable=false
advanced_options=false
dedicated_server=false
custom_features="validation_harness"
export_filter="all_resources"
include_filter=""
exclude_filter=""
export_path="builds/switchy-express-validation.apk"
encryption_include_filters=""
encryption_exclude_filters=""
encrypt_pck=false
encrypt_directory=false
script_export_mode=2

[preset.0.options]

custom_template/debug=""
custom_template/release=""
gradle_build/use_gradle_build=false
gradle_build/export_format=0
architectures/arm64-v8a=true
architectures/armeabi-v7a=false
architectures/x86=false
architectures/x86_64=false
version/code=1
version/name="0.1-validation"
package/unique_name="com.alsdmlals4.switchyexpress.validation"
package/name="Switchy Express Validation"
package/signed=true
```

Do not add passwords, keystore paths, Android SDK paths, or user-directory paths.

- [ ] **Step 3: Add ConfigFile semantic assertions**

In addition to text checks, load the preset with `ConfigFile` and assert:

```gdscript
assert_equal(config.load("res://export_presets.cfg"), OK, "export preset must parse")
assert_equal(config.get_value("preset.0", "name", ""), "Android Validation", "preset name must match CLI contract")
assert_equal(config.get_value("preset.0", "platform", ""), "Android", "preset platform must be Android")
assert_equal(config.get_value("preset.0", "custom_features", ""), "validation_harness", "preset must activate validation feature")
assert_equal(config.get_value("preset.0.options", "package/unique_name", ""), "com.alsdmlals4.switchyexpress.validation", "package ID must be isolated")
```

- [ ] **Step 4: Run full CI and verify GREEN**

Expected:

```text
Project Contract: PASS
Godot Tests: PASS
new validation failures: 0
existing regressions: 0
```

Do not claim an APK export was executed.

- [ ] **Step 5: Commit**

```bash
git add project.godot export_presets.cfg tests/finite/validation/test_validation_entrypoint_invariance.gd
git commit -m "build: add Android validation export path"
```

---

### Task 4: Adversarial Review and Authority Closure

**Files:**
- Modify: `기획서/50_제작_검증/FP_01_02_IMPLEMENTATION_AUDIT.md`
- Modify: `기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md`
- Modify: `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
- Modify: PR body and correct Google Sheet after merge

**Interfaces:**
- Consumes: exact final head SHA, CI runs, changed-file inventory, review threads.
- Produces: `SX-AUD-018` validation-preparation evidence and next manual Gate state.

- [ ] **Step 1: Run adversarial checks**

Confirm:

- invalid mode does not fall back to proof;
- stack modes mount view, not product runtime;
- no save or domain class is referenced by validation launcher;
- base production main is unchanged;
- `game/main/main.tscn` hash is unchanged;
- only validation feature activates launcher;
- preset contains no secret/local path;
- Android/HUMAN remain `NOT_RUN`.

Add a focused regression test if any gap is found.

- [ ] **Step 2: Update authority documents**

Record:

```text
VALIDATION_PREP: PASS
ANDROID: NOT_RUN
HUMAN: NOT_RUN
PRODUCTION CUTOVER: BLOCKED
```

Use new audit ID `SX-AUD-018`; preserve `SX-AUD-017` as Task 12/manual-plan audit evidence.

- [ ] **Step 3: Run final CI on exact head**

Record Project Contract and Godot run numbers, test cases, assertions, unresolved threads, and REQUEST_CHANGES count.

- [ ] **Step 4: Commit closure docs**

```bash
git add docs/superpowers/specs/2026-08-05-finite-validation-harness-design.md \
  docs/superpowers/plans/2026-08-05-finite-validation-harness.md \
  기획서/50_제작_검증/FP_01_02_IMPLEMENTATION_AUDIT.md \
  기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md \
  기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md
git commit -m "docs: record validation preparation evidence"
```

- [ ] **Step 5: Merge only with clean review state**

Required:

```text
Project Contract PASS
Godot Tests PASS
unresolved review threads 0
REQUEST_CHANGES 0
Critical/Important findings 0
```

- [ ] **Step 6: Sync the correct Google Sheet after merge**

Update the same `SX-AUD-018` and merge SHA in:

```text
00_프로젝트_허브
01_작업순서
03_근거_라이브러리
04_누락_충돌_감사
50_제작_검증
```

Read back all modified ranges. Do not modify the wrong `19Ff...` spreadsheet.

---

## Plan Self-Review

### Spec coverage

- Isolated launcher and proof mode: Task 2.
- 8/16/32 presenter stack fixtures: Tasks 1–2.
- Fail-closed behavior: Tasks 1–2 and Task 4 adversarial review.
- Custom feature and main-scene override: Task 3.
- Android preset without secrets/local paths: Task 3.
- Production entrypoint and scene invariance: Tasks 1 and 3.
- Full regression and authority closure: Task 4.

### Placeholder scan

No TBD, TODO, unspecified method, or unnamed status remains.

### Type consistency

- Launcher mode and error values are `StringName`.
- `active_scene_path()` returns `String`.
- `stack_fixture_size()` returns `int`.
- `mounted_child()` returns `Node` or `null`.
- Presenter receives `Array[StringName]` and the fixture methods match its existing calls.

## Execution Handoff

Execution mode is **Inline Execution** because this environment has no independent code subagent runtime. Follow red → green → adversarial review with CI checkpoints on the isolated branch `agent/fp-validation-harness`.
