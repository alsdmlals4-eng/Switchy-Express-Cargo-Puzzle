# Android Validation APK CI Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Extend the existing validation harness with an on-device four-mode selector and a reproducible, manually dispatched Android debug APK workflow that produces traceable build evidence without changing the product entrypoint.

**Architecture:** Keep `FiniteValidationLauncher` as the only validation entrypoint. A focused selector component emits one of four mode identifiers; the launcher owns scene mounting and a back overlay. A separate `workflow_dispatch` GitHub Actions workflow installs a pinned Godot/Android toolchain, runs all tests before export, creates the validation APK, hashes and attests it, then uploads one evidence bundle. APK creation, Android device smoke, HUMAN comprehension, and production cutover remain distinct gates.

**Tech Stack:** Godot `4.7.1-stable`, GDScript, Godot custom-feature export preset, GitHub Actions, Temurin Java 17, Android platform 35, Build Tools `35.0.1`, NDK `28.1.13356709` (`r28b`), Python 3 for manifest generation, SHA-256, `actions/upload-artifact@v4`, `actions/attest@v4`.

## Global Constraints

- Product authority remains `GMB-002 · SX-DEC-027~036`.
- Execution authority remains `FP-DOR-001 · EV-USER-021`; specification approval is `EV-USER-022`.
- Existing validation authority is `SX-AUD-018` and `VALIDATION_PREP_PASS`.
- Supported on-device modes are exactly `PROOF`, `STACK_8`, `STACK_16`, and `STACK_32`.
- The validation launcher remains `res://tools/validation/finite/finite_validation_launcher.tscn`.
- Base `run/main_scene` remains `res://game/main/main.tscn`.
- `game/main/main.tscn` must remain byte-identical to SHA-256 `05f3045700fbef7122606e099a918a6cb59cc06a22ab1b7f826dc368df7bdeb2`.
- Validation code stays under `tools/validation/finite/` and product code must not depend on it.
- All selector controls have at least `48 × 48` logical pixels; use `56` logical pixels as the implementation minimum.
- Invalid mode input fails closed, mounts no validation child, and never falls back to product or proof runtime.
- Workflow trigger is `workflow_dispatch` only.
- Workflow exports only preset `Android Validation` and package ID `com.alsdmlals4.switchyexpress.validation`.
- Commit no keystore, password, release key, SDK path, service credential, or user-directory path.
- Every code/configuration change follows RED → GREEN → refactor → full regression.
- Static workflow tests do not prove an APK was produced.
- `APK_EXPORT` may become PASS only after a real main-branch workflow run produces a non-empty APK, SHA-256 file, manifest, summary, and attestation.
- Android device smoke and five-person comprehension remain `NOT_RUN` after APK export.
- Production cutover remains `BLOCKED`.
- Full local/CI test command:

```bash
./Godot_v4.7.1-stable_linux.x86_64 \
  --headless \
  --path . \
  --script res://tests/run_tests.gd
```

---

## File Responsibility Map

| File | Responsibility |
|---|---|
| `finite_validation_mode_selector.gd` | Emit exact validation mode requests and own only selector visibility. |
| `finite_validation_mode_selector.tscn` | Four explicit mode buttons with accessible minimum touch areas. |
| `finite_validation_launcher.gd` | Own selector state, mounted validation child, back navigation, and fail-closed mode configuration. |
| `finite_validation_launcher.tscn` | Compose mount area, selector instance, and non-product back overlay. |
| `test_validation_mode_selector.gd` | Define selector labels, touch size, emitted modes, and visibility contract. |
| `test_finite_validation_launcher.gd` | Define selector-first boot, explicit CLI mode, navigation, replacement, and invalid-mode contract. |
| `test_android_validation_workflow_contract.gd` | Statically define the only acceptable workflow trigger, pins, ordering, evidence, security, and artifact rules. |
| `android-validation-apk.yml` | Build, test, export, hash, attest, summarize, and upload the validation APK. |
| `tests/run_tests.gd` | Register the two new validation tests. |
| authority documents | Record implementation evidence separately from real APK evidence. |

---

### Task 1: Define the Selector RED Contract

**Files:**
- Create: `tests/finite/validation/test_validation_mode_selector.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Consumes planned scene `res://tools/validation/finite/finite_validation_mode_selector.tscn`.
- Produces required signal `mode_requested(mode: StringName)` and exact node paths consumed by Task 2.

- [ ] **Step 1: Register the new test before production implementation**

Insert after `test_finite_validation_launcher.gd`:

```gdscript
preload("res://tests/finite/validation/test_validation_mode_selector.gd"),
```

- [ ] **Step 2: Write the failing selector test**

Create the following test. It exits safely while the scene is absent, allowing existing tests to prove they remain green.

```gdscript
extends "res://tests/test_case.gd"

const SELECTOR_SCENE := "res://tools/validation/finite/finite_validation_mode_selector.tscn"


func run() -> void:
    assert_true(
        ResourceLoader.exists(SELECTOR_SCENE, "PackedScene"),
        "validation mode selector scene must exist"
    )
    if not ResourceLoader.exists(SELECTOR_SCENE, "PackedScene"):
        return

    var packed: PackedScene = load(SELECTOR_SCENE)
    var selector: Control = packed.instantiate()
    var tree := Engine.get_main_loop() as SceneTree
    assert_not_null(tree, "selector test requires SceneTree")
    if tree == null:
        selector.free()
        return
    tree.root.add_child(selector)

    var expected := {
        "Panel/Margin/Modes/ProofButton": [&"PROOF", "PROOF"],
        "Panel/Margin/Modes/Stack8Button": [&"STACK_8", "STACK 8"],
        "Panel/Margin/Modes/Stack16Button": [&"STACK_16", "STACK 16"],
        "Panel/Margin/Modes/Stack32Button": [&"STACK_32", "STACK 32"],
    }
    var emitted: Array[StringName] = []
    selector.mode_requested.connect(func(mode: StringName) -> void: emitted.append(mode))

    assert_true(selector.is_selector_visible(), "selector must start visible")
    for path: String in expected:
        var button := selector.get_node(path) as Button
        assert_not_null(button, "%s must exist" % path)
        if button == null:
            continue
        assert_equal(button.text, expected[path][1], "%s must have exact label" % path)
        assert_greater_equal(int(button.custom_minimum_size.x), 48, "%s width must meet touch contract" % path)
        assert_greater_equal(int(button.custom_minimum_size.y), 48, "%s height must meet touch contract" % path)
        button.emit_signal("pressed")
        assert_equal(emitted[-1], expected[path][0], "%s must emit exact mode" % path)

    selector.hide_selector()
    assert_false(selector.is_selector_visible(), "hide_selector must hide selector")
    selector.show_selector()
    assert_true(selector.is_selector_visible(), "show_selector must restore selector")
    selector.queue_free()
```

- [ ] **Step 3: Run the full test suite and verify RED**

Expected result:

```text
Project Contract: PASS
Godot Tests: FAIL
existing 63 cases: PASS
new selector case: FAIL because selector scene does not exist
```

- [ ] **Step 4: Commit the RED state**

```bash
git add tests/finite/validation/test_validation_mode_selector.gd tests/run_tests.gd
git commit -m "test: define validation mode selector contract"
```

---

### Task 2: Implement the Focused Mode Selector

**Files:**
- Create: `tools/validation/finite/finite_validation_mode_selector.gd`
- Create: `tools/validation/finite/finite_validation_mode_selector.tscn`
- Test: `tests/finite/validation/test_validation_mode_selector.gd`

**Interfaces:**
- Consumes no product-domain API.
- Produces:

```gdscript
signal mode_requested(mode: StringName)
func show_selector() -> void
func hide_selector() -> void
func is_selector_visible() -> bool
```

- [ ] **Step 1: Add the selector script**

```gdscript
class_name FiniteValidationModeSelector
extends Control

signal mode_requested(mode: StringName)

const MODE_PROOF: StringName = &"PROOF"
const MODE_STACK_8: StringName = &"STACK_8"
const MODE_STACK_16: StringName = &"STACK_16"
const MODE_STACK_32: StringName = &"STACK_32"

@onready var _proof_button := get_node("Panel/Margin/Modes/ProofButton") as Button
@onready var _stack_8_button := get_node("Panel/Margin/Modes/Stack8Button") as Button
@onready var _stack_16_button := get_node("Panel/Margin/Modes/Stack16Button") as Button
@onready var _stack_32_button := get_node("Panel/Margin/Modes/Stack32Button") as Button


func _ready() -> void:
    _proof_button.pressed.connect(_emit_mode.bind(MODE_PROOF))
    _stack_8_button.pressed.connect(_emit_mode.bind(MODE_STACK_8))
    _stack_16_button.pressed.connect(_emit_mode.bind(MODE_STACK_16))
    _stack_32_button.pressed.connect(_emit_mode.bind(MODE_STACK_32))
    show_selector()


func show_selector() -> void:
    visible = true
    mouse_filter = Control.MOUSE_FILTER_STOP


func hide_selector() -> void:
    visible = false
    mouse_filter = Control.MOUSE_FILTER_IGNORE


func is_selector_visible() -> bool:
    return visible


func _emit_mode(mode: StringName) -> void:
    mode_requested.emit(mode)
```

- [ ] **Step 2: Add the selector scene**

Use a full-screen centered panel. The exact node names are test and launcher contracts.

```ini
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://tools/validation/finite/finite_validation_mode_selector.gd" id="1_selector"]

[node name="FiniteValidationModeSelector" type="Control"]
layout_mode = 3
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
grow_horizontal = 2
grow_vertical = 2
mouse_filter = 0
script = ExtResource("1_selector")

[node name="Panel" type="PanelContainer" parent="."]
layout_mode = 1
anchors_preset = 8
anchor_left = 0.5
anchor_top = 0.5
anchor_right = 0.5
anchor_bottom = 0.5
offset_left = -240.0
offset_top = -210.0
offset_right = 240.0
offset_bottom = 210.0
grow_horizontal = 2
grow_vertical = 2

[node name="Margin" type="MarginContainer" parent="Panel"]
layout_mode = 2
theme_override_constants/margin_left = 32
theme_override_constants/margin_top = 32
theme_override_constants/margin_right = 32
theme_override_constants/margin_bottom = 32

[node name="Modes" type="VBoxContainer" parent="Panel/Margin"]
layout_mode = 2
theme_override_constants/separation = 16

[node name="Title" type="Label" parent="Panel/Margin/Modes"]
layout_mode = 2
text = "VALIDATION MODE"
horizontal_alignment = 1
theme_override_font_sizes/font_size = 26

[node name="ProofButton" type="Button" parent="Panel/Margin/Modes"]
custom_minimum_size = Vector2(280, 56)
layout_mode = 2
text = "PROOF"

[node name="Stack8Button" type="Button" parent="Panel/Margin/Modes"]
custom_minimum_size = Vector2(280, 56)
layout_mode = 2
text = "STACK 8"

[node name="Stack16Button" type="Button" parent="Panel/Margin/Modes"]
custom_minimum_size = Vector2(280, 56)
layout_mode = 2
text = "STACK 16"

[node name="Stack32Button" type="Button" parent="Panel/Margin/Modes"]
custom_minimum_size = Vector2(280, 56)
layout_mode = 2
text = "STACK 32"
```

- [ ] **Step 3: Run tests and verify selector GREEN**

Expected: the selector test passes; all previous tests remain green.

- [ ] **Step 4: Review isolation**

Run:

```bash
grep -R "FiniteCargo\|FiniteRun\|Save\|Analytics\|HTTP" tools/validation/finite/finite_validation_mode_selector.*
```

Expected: no findings.

- [ ] **Step 5: Commit**

```bash
git add tools/validation/finite/finite_validation_mode_selector.*
git commit -m "feat: add on-device validation mode selector"
```

---

### Task 3: Integrate Selector-First Launcher Navigation

**Files:**
- Modify: `tests/finite/validation/test_finite_validation_launcher.gd`
- Modify: `tools/validation/finite/finite_validation_launcher.gd`
- Modify: `tools/validation/finite/finite_validation_launcher.tscn`
- Regression: `tests/finite/validation/test_validation_stack_modes.gd`

**Interfaces:**
- Consumes `FiniteValidationModeSelector.mode_requested` and existing `configure_mode(mode)`.
- Produces:

```gdscript
const MODE_SELECTOR: StringName = &"SELECTOR"
func show_selector() -> void
func selector_visible() -> bool
func back_control_visible() -> bool
```

- [ ] **Step 1: Change launcher expectations to RED**

Replace the old default-proof assertions with selector-first assertions and retain explicit CLI proof support:

```gdscript
assert_equal(
    launcher_script.mode_from_user_args(PackedStringArray()),
    &"SELECTOR",
    "missing validation argument must open selector"
)
assert_equal(
    launcher_script.mode_from_user_args(PackedStringArray(["--validation-mode=proof"])),
    &"PROOF",
    "explicit proof argument must remain supported"
)
assert_equal(launcher.active_mode(), &"SELECTOR", "launcher must boot in selector state")
assert_true(launcher.selector_visible(), "selector must be visible at boot")
assert_false(launcher.back_control_visible(), "back control must be hidden at selector")
assert_equal(launcher.mounted_child(), null, "selector state must mount no product or fixture child")
```

Then exercise a full navigation cycle:

```gdscript
assert_true(launcher.configure_mode(&"STACK_8"), "stack8 must configure")
var first_child: Node = launcher.mounted_child()
assert_false(launcher.selector_visible(), "selector must hide after mode selection")
assert_true(launcher.back_control_visible(), "back control must appear in a mode")
launcher.show_selector()
assert_equal(launcher.mounted_child(), null, "returning must clear mounted child")
assert_false(is_instance_valid(first_child), "returning must free prior child")
assert_true(launcher.selector_visible(), "selector must return")
```

Keep invalid-mode assertions:

```gdscript
assert_false(launcher.configure_mode(&"UNKNOWN"), "unknown mode must fail closed")
assert_equal(launcher.last_error(), &"INVALID_MODE", "unknown mode must expose stable error")
assert_equal(launcher.mounted_child(), null, "invalid mode must leave no child mounted")
assert_true(launcher.selector_visible(), "invalid mode must return to safe selector")
```

- [ ] **Step 2: Run tests and verify launcher RED**

Expected: selector component test passes, launcher test fails because no selector state/back API exists.

- [ ] **Step 3: Compose selector and back overlay into launcher scene**

Add two ext resources and these nodes after `Mount`:

```ini
[ext_resource type="PackedScene" path="res://tools/validation/finite/finite_validation_mode_selector.tscn" id="2_selector"]

[node name="Selector" parent="." instance=ExtResource("2_selector")]
layout_mode = 1

[node name="BackOverlay" type="MarginContainer" parent="."]
visible = false
layout_mode = 1
anchors_preset = 1
anchor_left = 1.0
anchor_right = 1.0
offset_left = -220.0
offset_top = 20.0
offset_right = -20.0
offset_bottom = 84.0
grow_horizontal = 0
mouse_filter = 1

[node name="BackButton" type="Button" parent="BackOverlay"]
custom_minimum_size = Vector2(200, 56)
layout_mode = 2
text = "BACK TO MODES"
```

Ensure `Mount` is declared before `Selector` so the selector renders above mounted content only while visible. `BackOverlay` remains above both.

- [ ] **Step 4: Implement selector state in launcher**

Add:

```gdscript
const MODE_SELECTOR: StringName = &"SELECTOR"
const SelectorScript := preload("res://tools/validation/finite/finite_validation_mode_selector.gd")

@onready var _selector := get_node("Selector") as FiniteValidationModeSelector
@onready var _back_overlay := get_node("BackOverlay") as Control
@onready var _back_button := get_node("BackOverlay/BackButton") as Button
```

Replace `_ready()` and the no-argument parser result:

```gdscript
func _ready() -> void:
    _selector.mode_requested.connect(_on_mode_requested)
    _back_button.pressed.connect(show_selector)
    var requested := mode_from_user_args(OS.get_cmdline_user_args())
    if requested == MODE_SELECTOR:
        show_selector()
    else:
        configure_mode(requested)


static func mode_from_user_args(args: PackedStringArray) -> StringName:
    for argument: String in args:
        if not argument.begins_with("--validation-mode="):
            continue
        var value := argument.trim_prefix("--validation-mode=").to_lower()
        match value:
            "proof": return MODE_PROOF
            "stack8": return MODE_STACK_8
            "stack16": return MODE_STACK_16
            "stack32": return MODE_STACK_32
            _: return MODE_INVALID
    return MODE_SELECTOR
```

Add safe-state API:

```gdscript
func show_selector() -> void:
    _clear_mounted_child()
    _active_mode = MODE_SELECTOR
    _active_scene_path = ""
    _stack_fixture_size = 0
    _last_error = &""
    _selector.show_selector()
    _back_overlay.visible = false


func selector_visible() -> bool:
    return _selector.is_selector_visible()


func back_control_visible() -> bool:
    return _back_overlay.visible


func _on_mode_requested(mode: StringName) -> void:
    configure_mode(mode)
```

At the beginning of `configure_mode()`, clear previous state. On invalid or mounting failure, preserve the error and call a private safe UI helper rather than falling back:

```gdscript
func _show_safe_selector_preserving_error() -> void:
    _active_mode = MODE_INVALID
    _active_scene_path = ""
    _stack_fixture_size = 0
    _selector.show_selector()
    _back_overlay.visible = false
```

After successful mount:

```gdscript
_selector.hide_selector()
_back_overlay.visible = true
_active_mode = mode
return true
```

- [ ] **Step 5: Run complete regression**

Expected:

```text
selector-first launcher: PASS
explicit CLI modes: PASS
invalid mode fail-closed: PASS
STACK_8/16/32 token contracts: PASS
all finite and legacy tests: PASS
```

- [ ] **Step 6: Commit**

```bash
git add tools/validation/finite/finite_validation_launcher.* \
  tests/finite/validation/test_finite_validation_launcher.gd
git commit -m "feat: add selector-first validation navigation"
```

---

### Task 4: Define the Android Workflow RED Contract

**Files:**
- Create: `tests/finite/validation/test_android_validation_workflow_contract.gd`
- Modify: `tests/run_tests.gd`

**Interfaces:**
- Consumes planned `.github/workflows/android-validation-apk.yml`.
- Produces a static, fail-closed contract for trigger, pinned toolchain, execution order, export target, evidence bundle, attestation, and security.

- [ ] **Step 1: Register workflow contract test**

Insert after `test_validation_entrypoint_invariance.gd`:

```gdscript
preload("res://tests/finite/validation/test_android_validation_workflow_contract.gd"),
```

- [ ] **Step 2: Write exact workflow assertions**

```gdscript
extends "res://tests/test_case.gd"

const WORKFLOW_PATH := "res://.github/workflows/android-validation-apk.yml"


func run() -> void:
    assert_true(FileAccess.file_exists(WORKFLOW_PATH), "Android validation APK workflow must exist")
    if not FileAccess.file_exists(WORKFLOW_PATH):
        return
    var text := FileAccess.get_file_as_string(WORKFLOW_PATH)

    assert_true(text.contains("workflow_dispatch:"), "workflow must be manually dispatched")
    assert_false(text.contains("pull_request:"), "workflow must not run on pull requests")
    assert_false(text.contains("schedule:"), "workflow must not be scheduled")
    assert_false(text.contains("release:"), "workflow must not be release-triggered")
    assert_false(text.contains("branches:"), "workflow must not add push branch triggers")

    var required := [
        "GODOT_VERSION: 4.7.1-stable",
        "JAVA_VERSION: '17'",
        "ANDROID_PLATFORM: android-35",
        "ANDROID_BUILD_TOOLS: 35.0.1",
        "ANDROID_NDK_VERSION: 28.1.13356709",
        "uses: actions/checkout@v4",
        "uses: actions/setup-java@v4",
        "distribution: temurin",
        "uses: android-actions/setup-android@v3",
        "platforms;android-35",
        "build-tools;35.0.1",
        "ndk;28.1.13356709",
        "--script res://tests/run_tests.gd",
        "--export-debug \"Android Validation\"",
        "test -s builds/switchy-express-validation.apk",
        "sha256sum builds/switchy-express-validation.apk",
        "validation-build-manifest.json",
        "validation-build-summary.txt",
        "uses: actions/attest@v4",
        "subject-path: builds/switchy-express-validation.apk",
        "uses: actions/upload-artifact@v4",
        "retention-days: 14",
    ]
    for token: String in required:
        assert_true(text.contains(token), "workflow must contain %s" % token)

    var test_index := text.find("name: Run complete headless test suite")
    var invariant_index := text.find("name: Verify product entrypoint invariants")
    var export_index := text.find("name: Export Android validation APK")
    var hash_index := text.find("name: Generate build evidence")
    var attest_index := text.find("name: Attest APK provenance")
    var upload_index := text.find("name: Upload validation evidence bundle")
    assert_true(
        test_index >= 0 and test_index < invariant_index and invariant_index < export_index
        and export_index < hash_index and hash_index < attest_index and attest_index < upload_index,
        "workflow steps must execute tests, invariants, export, evidence, attestation, upload in order"
    )

    var lowered := text.to_lower()
    assert_false(lowered.contains("keystore"), "workflow must not contain keystore configuration")
    assert_false(lowered.contains("storepass"), "workflow must not contain signing password")
    assert_false(text.contains("C:\\"), "workflow must not contain Windows user paths")
    assert_false(text.contains("/Users/"), "workflow must not contain macOS user paths")
```

- [ ] **Step 3: Run full CI and verify RED**

Expected: all selector and prior tests pass; only workflow-contract test fails because the workflow file is absent.

- [ ] **Step 4: Commit RED**

```bash
git add tests/finite/validation/test_android_validation_workflow_contract.gd tests/run_tests.gd
git commit -m "test: define Android validation APK workflow contract"
```

---

### Task 5: Implement Reproducible Android APK Workflow

**Files:**
- Create: `.github/workflows/android-validation-apk.yml`
- Test: `tests/finite/validation/test_android_validation_workflow_contract.gd`
- Regression: `tests/finite/validation/test_validation_entrypoint_invariance.gd`

**Interfaces:**
- Consumes preset `Android Validation`, custom feature `validation_harness`, and the complete test suite.
- Produces artifact `switchy-express-validation-<short-sha>` containing APK, SHA-256, JSON manifest, and text summary.

- [ ] **Step 1: Add the workflow header and pinned environment**

```yaml
name: Android Validation APK

on:
  workflow_dispatch:

permissions:
  contents: read
  id-token: write
  attestations: write

env:
  GODOT_VERSION: 4.7.1-stable
  JAVA_VERSION: '17'
  ANDROID_PLATFORM: android-35
  ANDROID_BUILD_TOOLS: 35.0.1
  ANDROID_NDK_VERSION: 28.1.13356709
  GODOT_BINARY: Godot_v4.7.1-stable_linux.x86_64
  GODOT_ARCHIVE: Godot_v4.7.1-stable_linux.x86_64.zip
  GODOT_TEMPLATES_ARCHIVE: Godot_v4.7.1-stable_export_templates.tpz
  APK_PATH: builds/switchy-express-validation.apk

jobs:
  build-validation-apk:
    runs-on: ubuntu-latest
    timeout-minutes: 30
    steps:
      - uses: actions/checkout@v4
```

- [ ] **Step 2: Install Java and Android SDK components**

```yaml
      - uses: actions/setup-java@v4
        with:
          distribution: temurin
          java-version: ${{ env.JAVA_VERSION }}

      - uses: android-actions/setup-android@v3

      - name: Install pinned Android SDK components
        shell: bash
        run: |
          set -euo pipefail
          yes | sdkmanager --licenses >/dev/null
          sdkmanager \
            "platforms;android-35" \
            "build-tools;35.0.1" \
            "ndk;28.1.13356709"
```

- [ ] **Step 3: Download Godot and matching templates**

```yaml
      - name: Install Godot and Android export templates
        shell: bash
        run: |
          set -euo pipefail
          base_url="https://github.com/godotengine/godot-builds/releases/download/${GODOT_VERSION}"
          curl --fail --location --retry 3 --output "${GODOT_ARCHIVE}" \
            "${base_url}/${GODOT_ARCHIVE}"
          curl --fail --location --retry 3 --output "${GODOT_TEMPLATES_ARCHIVE}" \
            "${base_url}/${GODOT_TEMPLATES_ARCHIVE}"
          unzip -q "${GODOT_ARCHIVE}"
          chmod +x "${GODOT_BINARY}"
          template_dir="${HOME}/.local/share/godot/export_templates/4.7.1.stable"
          mkdir -p "${template_dir}" template-unpack
          unzip -q "${GODOT_TEMPLATES_ARCHIVE}" -d template-unpack
          cp -a template-unpack/templates/. "${template_dir}/"
          "./${GODOT_BINARY}" --version | tee godot-version.txt
          test -f "${template_dir}/android_debug.apk"
```

- [ ] **Step 4: Run tests before export**

```yaml
      - name: Run complete headless test suite
        shell: bash
        run: |
          set +e
          output=$(timeout 45s "./${GODOT_BINARY}" \
            --headless \
            --path . \
            --script res://tests/run_tests.gd 2>&1)
          status=$?
          set -e
          printf '%s\n' "$output" | tee validation-test-output.txt
          if printf '%s\n' "$output" | grep -E 'SCRIPT ERROR:|(^|[[:space:]])ERROR:'; then
            exit 1
          fi
          exit "$status"
```

- [ ] **Step 5: Verify entrypoint and preset invariants independently**

```yaml
      - name: Verify product entrypoint invariants
        shell: bash
        run: |
          set -euo pipefail
          grep -F 'run/main_scene="res://game/main/main.tscn"' project.godot
          grep -F 'run/main_scene.validation_harness="res://tools/validation/finite/finite_validation_launcher.tscn"' project.godot
          grep -F 'name="Android Validation"' export_presets.cfg
          grep -F 'custom_features="validation_harness"' export_presets.cfg
          grep -F 'package/unique_name="com.alsdmlals4.switchyexpress.validation"' export_presets.cfg
          printf '%s  %s\n' \
            '05f3045700fbef7122606e099a918a6cb59cc06a22ab1b7f826dc368df7bdeb2' \
            'game/main/main.tscn' | sha256sum --check --strict
```

- [ ] **Step 6: Export and validate the APK**

```yaml
      - name: Export Android validation APK
        shell: bash
        run: |
          set -euo pipefail
          mkdir -p builds
          "./${GODOT_BINARY}" \
            --headless \
            --path . \
            --export-debug "Android Validation" \
            "${APK_PATH}" 2>&1 | tee validation-export-output.txt
          test -s builds/switchy-express-validation.apk
```

- [ ] **Step 7: Generate exact evidence files**

```yaml
      - name: Generate build evidence
        id: evidence
        shell: bash
        run: |
          set -euo pipefail
          apk_sha=$(sha256sum builds/switchy-express-validation.apk | awk '{print $1}')
          [[ "$apk_sha" =~ ^[0-9a-f]{64}$ ]]
          printf '%s  %s\n' "$apk_sha" 'switchy-express-validation.apk' \
            > builds/switchy-express-validation.apk.sha256
          short_sha="${GITHUB_SHA:0:8}"
          echo "short_sha=${short_sha}" >> "$GITHUB_OUTPUT"
          export APK_SHA="$apk_sha"
          python - <<'PY'
          import json
          import os
          from pathlib import Path

          source = os.environ['GITHUB_SHA']
          apk_sha = os.environ['APK_SHA']
          if len(source) != 40 or any(c not in '0123456789abcdef' for c in source):
              raise SystemExit('invalid GITHUB_SHA')
          if len(apk_sha) != 64 or any(c not in '0123456789abcdef' for c in apk_sha):
              raise SystemExit('invalid APK SHA-256')
          manifest = {
              'schema_version': 1,
              'source_commit': source,
              'workflow_run_id': os.environ['GITHUB_RUN_ID'],
              'workflow_run_attempt': os.environ['GITHUB_RUN_ATTEMPT'],
              'godot_version': '4.7.1-stable',
              'java_version': '17',
              'android_platform': '35',
              'android_build_tools': '35.0.1',
              'android_ndk': 'r28b',
              'export_preset': 'Android Validation',
              'package_id': 'com.alsdmlals4.switchyexpress.validation',
              'apk_filename': 'switchy-express-validation.apk',
              'apk_sha256': apk_sha,
              'validation_modes': ['PROOF', 'STACK_8', 'STACK_16', 'STACK_32'],
              'production_main': 'res://game/main/main.tscn',
          }
          Path('builds/validation-build-manifest.json').write_text(
              json.dumps(manifest, ensure_ascii=False, indent=2) + '\n',
              encoding='utf-8',
          )
          PY
          {
            echo "source_commit=${GITHUB_SHA}"
            echo "workflow_run_id=${GITHUB_RUN_ID}"
            echo "workflow_run_attempt=${GITHUB_RUN_ATTEMPT}"
            echo "apk_sha256=${apk_sha}"
            echo "godot_version=4.7.1-stable"
            echo "android_platform=35"
            echo "android_build_tools=35.0.1"
            echo "android_ndk=r28b"
            echo "package_id=com.alsdmlals4.switchyexpress.validation"
          } > builds/validation-build-summary.txt
```

- [ ] **Step 8: Attest and upload**

```yaml
      - name: Attest APK provenance
        uses: actions/attest@v4
        with:
          subject-path: builds/switchy-express-validation.apk

      - name: Upload validation evidence bundle
        uses: actions/upload-artifact@v4
        with:
          name: switchy-express-validation-${{ steps.evidence.outputs.short_sha }}
          retention-days: 14
          if-no-files-found: error
          path: |
            builds/switchy-express-validation.apk
            builds/switchy-express-validation.apk.sha256
            builds/validation-build-manifest.json
            builds/validation-build-summary.txt
```

- [ ] **Step 9: Run PR CI and verify static GREEN**

Expected:

```text
Project Contract: PASS
Godot Tests: PASS
workflow contract: PASS
actual APK export: still NOT_RUN because workflow_dispatch is not executed on the PR
```

- [ ] **Step 10: Adversarially review workflow**

Check:

```bash
grep -nE 'pull_request:|schedule:|release:|keystore|storepass|C:\\|/Users/|/home/' \
  .github/workflows/android-validation-apk.yml
```

Expected: no findings.

Verify step order and that all version strings occur once in authority positions. Confirm `actions/attest@v4` uses the APK path, not the ZIP artifact.

- [ ] **Step 11: Commit**

```bash
git add .github/workflows/android-validation-apk.yml \
  tests/finite/validation/test_android_validation_workflow_contract.gd \
  tests/run_tests.gd
git commit -m "ci: add reproducible Android validation APK build"
```

---

### Task 6: Implementation PR Review and Merge

**Files:**
- Modify: PR body only before merge.
- Do not change authority documents to `APK_EXPORT_PASS` yet.

**Interfaces:**
- Consumes final implementation head, CI runs, changed-file inventory, and review state.
- Produces a main-branch workflow eligible for real `workflow_dispatch`.

- [ ] **Step 1: Run complete final verification on the exact head**

Required evidence:

```text
Project Contract: PASS
Godot Tests: PASS
all new selector/workflow tests: PASS
unresolved review threads: 0
REQUEST_CHANGES: 0
```

- [ ] **Step 2: Confirm scope**

Allowed code/configuration files:

```text
.github/workflows/android-validation-apk.yml
tools/validation/finite/finite_validation_mode_selector.gd
tools/validation/finite/finite_validation_mode_selector.tscn
tools/validation/finite/finite_validation_launcher.gd
tools/validation/finite/finite_validation_launcher.tscn
tests/finite/validation/test_validation_mode_selector.gd
tests/finite/validation/test_android_validation_workflow_contract.gd
tests/finite/validation/test_finite_validation_launcher.gd
tests/run_tests.gd
```

No product-domain, save, campaign, release-signing, or product main file may appear.

- [ ] **Step 3: Merge with squash after review Gate**

Record the resulting main SHA as `APK_WORKFLOW_SOURCE_MAIN`. Do not claim APK export PASS from the merge alone.

---

### Task 7: Execute the Real APK Evidence Gate

**Files:**
- No source file change during dispatch.
- Generated workflow artifact only.

**Interfaces:**
- Consumes workflow on `main` and exact main source SHA.
- Produces the first canonical `APK_EXPORT_PASS` evidence bundle.

- [ ] **Step 1: Dispatch from main**

With GitHub CLI:

```bash
gh workflow run android-validation-apk.yml --ref main
```

Record the run ID returned by:

```bash
gh run list --workflow android-validation-apk.yml --branch main --limit 1 \
  --json databaseId,headSha,status,conclusion,url
```

- [ ] **Step 2: Watch to terminal state**

```bash
gh run watch <RUN_ID> --exit-status
```

Expected: completed/success. A failed or cancelled run leaves `APK_EXPORT` as `NOT_RUN` or `FAIL`; never mark PASS.

- [ ] **Step 3: Download and verify the evidence bundle**

```bash
mkdir -p .validation-evidence/<RUN_ID>
gh run download <RUN_ID> --dir .validation-evidence/<RUN_ID>
cd .validation-evidence/<RUN_ID>/switchy-express-validation-<SHORT_SHA>
sha256sum --check switchy-express-validation.apk.sha256
python -m json.tool validation-build-manifest.json >/dev/null
```

Verify:

```text
manifest source_commit == workflow headSha
manifest apk_sha256 == computed APK SHA-256
APK size > 0
manifest validation_modes == PROOF, STACK_8, STACK_16, STACK_32
package_id == com.alsdmlals4.switchyexpress.validation
production_main == res://game/main/main.tscn
```

- [ ] **Step 4: Verify provenance attestation**

```bash
gh attestation verify switchy-express-validation.apk \
  -R alsdmlals4-eng/Switchy-Express-Cargo-Puzzle
```

Expected: verification success referencing the same repository, workflow, and source commit.

- [ ] **Step 5: Record evidence identifiers only**

Record run URL, run ID, source SHA, APK SHA-256, artifact name, artifact ID, attestation result, and expiration date. Do not commit or upload the APK to Git or Google Sheet.

---

### Task 8: Authority and Sheet Closure for APK Export

**Files:**
- Create: `기획서/50_제작_검증/SX_AUD_019_ANDROID_APK_EXPORT_AUDIT.md`
- Modify: `기획서/50_제작_검증/FP_01_02_IMPLEMENTATION_AUDIT.md`
- Modify: `기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md`
- Modify: `기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md`
- Modify: correct Google Sheet tabs after GitHub merge.

**Interfaces:**
- Consumes exact implementation merge SHA and real workflow artifact evidence.
- Produces `SX-AUD-019`, `APK_EXPORT_PASS`, and the next Gate `ANDROID_SMOKE` while Android/HUMAN remain `NOT_RUN`.

- [ ] **Step 1: Write audit with exact evidence**

Required header:

```yaml
audit_id: SX-AUD-019
evidence_id: EV-FP-APK-001
source_main: <40-char implementation merge SHA>
workflow_run_id: <decimal run ID>
workflow_run_url: <GitHub Actions run URL>
artifact_name: switchy-express-validation-<8-char SHA>
apk_sha256: <64 lowercase hex>
attestation: PASS
status: APK_EXPORT_PASS
android_device_smoke: NOT_RUN
human_comprehension: NOT_RUN
production_cutover: BLOCKED
```

The body must distinguish:

```text
Build/export reproducibility: PASS
Installation/touch/layout/performance: NOT_RUN
Human LIFO comprehension: NOT_RUN
Production readiness: BLOCKED
```

- [ ] **Step 2: Update current authority**

Set:

```yaml
current_audit: SX-AUD-019
manual_gate_state: APK_EXPORT_PASS · ANDROID_NOT_RUN · HUMAN_NOT_RUN
next_gate: ANDROID_SMOKE → FIVE_PERSON_COMPREHENSION
cutover_state: BLOCKED
```

Do not change the default entrypoint.

- [ ] **Step 3: Run document PR CI and review**

Expected Project Contract and Godot Tests PASS. Changed files are authority documents only. No APK binary is committed.

- [ ] **Step 4: Synchronize the correct Google Sheet**

Update at minimum:

```text
00_프로젝트_허브
01_작업순서
03_근거_라이브러리
04_누락_충돌_감사
50_제작_검증
```

Use the same `SX-AUD-019 · EV-FP-APK-001`, source SHA, workflow run ID, and APK SHA-256. Re-read all updated ranges and confirm Android/HUMAN remain `NOT_RUN`.

- [ ] **Step 5: Merge closure PR**

After CI, review threads, Sheet readback, and evidence agreement all pass, squash merge. Record final closure main SHA separately from the APK source SHA.

---

## Plan Self-Review

- Spec coverage: selector, touch size, navigation, workflow pins, tests-before-export, APK validation, SHA-256, manifest, summary, artifact retention, attestation, invariants, real workflow proof, and authority closure are each assigned to a Task.
- Placeholder scan: all implementation values, paths, identifiers, versions, node names, mode names, artifact fields, and commands are explicit.
- Type consistency: selector emits `StringName`; launcher accepts `StringName`; modes match existing constants; manifest source values match GitHub environment variables.
- Scope: no product gameplay, save, campaign, final art, release signing, store delivery, Android device result, HUMAN result, or production cutover is included.
- TDD: every code/configuration package starts with a failing repository test and requires exact RED/GREEN evidence.
- Approval batching: this package contains one implementation approval and remains below the maximum batch size of ten.
