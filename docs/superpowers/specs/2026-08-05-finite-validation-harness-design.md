# Finite Validation Harness Design

```yaml
status: APPROVED_RECOMMENDED_APPROACH · TECHNICAL_MECHANISM_CORRECTED
approval: user approved recommended A on 2026-08-05
product_authority: GMB-002 · SX-DEC-027~036
execution_authority: FP-DOR-001 · EV-USER-021
source_main: 94bdc5e97d21d261db22559ada51ad43594ebf74
current_audit: SX-AUD-017
scope: validation-only launcher · stack readability fixtures · Android debug export preset · invariance tests
production_cutover: forbidden
```

## 1. Goal

Create a reproducible, non-product validation package that allows the approved Android smoke matrix and five-person comprehension test to run without changing the production default entrypoint or introducing campaign/content authority.

The package supports two validation surfaces:

1. **Proof Slice mode** — launches the real `res://game/finite/main/finite_slice.tscn` so testers can build, run, fail, retry, pause, load, and switch.
2. **Stack Readability mode** — displays presenter/view-owned cargo stacks of exactly 8, 16, or 32 tokens so rear/TOP readability can be tested without fabricating product maps or mutating delivery-domain state.

## 2. Selected approach

Use an independent validation launcher and presenter fixtures.

- Keep the base `run/main_scene="res://game/main/main.tscn"` unchanged.
- Reuse the real finite proof Slice for interaction checks.
- Use presenter-generated stack models for 8/16/32 display checks.
- Add no campaign content, save data, delivery rules, or product rewards.
- Fail closed when a mode or scene is invalid.

Rejected alternatives:

- Three high-cargo authored maps would expand validation into content and balance work.
- Local uncommitted entrypoint replacement would produce a non-reproducible APK.

## 3. Architecture

### 3.1 Validation launcher

Add:

```text
tools/validation/finite/finite_validation_launcher.tscn
tools/validation/finite/finite_validation_launcher.gd
```

The launcher owns only mode selection and child mounting. It must not own build, rail, cargo, timer, unload, retry, or persistence rules.

Public contract:

```gdscript
configure_mode(mode: StringName) -> bool
active_mode() -> StringName
active_scene_path() -> String
stack_fixture_size() -> int
last_error() -> StringName
mounted_child() -> Node
```

Supported modes:

```text
PROOF
STACK_8
STACK_16
STACK_32
```

Unknown modes return `false`, set `INVALID_MODE`, and mount nothing.

### 3.2 Proof mode

`PROOF` instantiates `res://game/finite/main/finite_slice.tscn` unchanged. The launcher does not inject a route, loading mode, hidden solution, timer value, or runtime mutation.

### 3.3 Stack readability modes

The launcher instantiates the real `finite_slice_view.tscn` and applies a model created through `FiniteSlicePresenter.show_run()` with a deterministic repeating sequence of the three canonical cargo types.

Requirements:

- exact token count: 8, 16, or 32
- exactly one TOP token
- TOP is the final/rear token
- every token contains cargo type, color, shape, label, index, and top flag
- view commands are not connected to product-domain state
- no artificial cargo is written to map data, `FiniteCargoStack`, save state, or run sessions

A focused `ValidationRunStateFixture` supplies only `phase()`, `elapsed_seconds()`, and `time_limit_seconds()` to the presenter.

### 3.4 Mode selection

The launcher reads Godot user arguments after `--`:

```text
--validation-mode=proof
--validation-mode=stack8
--validation-mode=stack16
--validation-mode=stack32
```

No argument defaults to `PROOF`.

## 4. Android export mechanism

Godot export presets do not independently own a main-scene field. The validation build therefore uses Godot's official custom-feature and project-setting override mechanism.

`export_presets.cfg` defines:

```text
preset name: Android Validation
custom feature: validation_harness
package id: com.alsdmlals4.switchyexpress.validation
```

`project.godot` keeps the production default and adds only a feature-specific override:

```ini
[application]
run/main_scene="res://game/main/main.tscn"
run/main_scene.validation_harness="res://tools/validation/finite/finite_validation_launcher.tscn"
```

Normal editor runs and exports without the `validation_harness` feature continue to use the legacy product main. The validation preset activates only the feature-specific override.

Command-line export contract:

```bash
godot --headless --path . --export-debug "Android Validation" builds/switchy-express-validation.apk
```

The preset contains no keystore secret, password, machine-specific Android SDK path, or production package identity. Repository tests verify configuration structure; an actual APK PASS still requires installed export templates and Android tooling.

## 5. Production invariants

- Base `run/main_scene` remains `res://game/main/main.tscn`.
- `game/main/main.tscn` is not modified.
- Feature override points only to the validation launcher.
- Validation files live under `tools/validation/finite/`.
- Production gameplay code does not reference validation files.
- Validation modes do not read or write saves.
- Existing finite and legacy rules remain unchanged.
- Only `VALIDATION_PREP` may become PASS; Android and HUMAN remain `NOT_RUN`.

## 6. Error handling

- Unknown mode: `INVALID_MODE`, no child.
- Missing or invalid packed scene: `MISSING_SCENE`, no child.
- Invalid stack size: reject values outside 8, 16, 32.
- Reconfiguration: detach and free the previous child before mounting the new child.
- Preset parse failure, missing custom feature, package collision, or entrypoint drift: automated test failure.
- No fallback launches production main or a legacy scene.

## 7. Test strategy

### Launcher and stack tests

- launcher scene and script exist
- default mode mounts proof Slice
- all four modes mount the expected scene type
- invalid mode fails closed
- reconfiguration replaces the prior child
- stack modes expose exactly 8/16/32 tokens
- each stack has exactly one TOP at the final index
- every descriptor preserves color + shape + text redundancy

### Invariance tests

- base project main remains `res://game/main/main.tscn`
- feature override points to the validation launcher
- `game/main/main.tscn` content hash remains the approved baseline
- Android preset has `custom_features="validation_harness"`
- validation package identifier is distinct from production
- preset contains no keystore password or local SDK path

### Regression gates

Run the complete Godot suite and Project Contract workflow. Existing finite and legacy tests must remain green.

Implementation completion changes only:

```text
VALIDATION_PREP: BLOCKED → PASS
ANDROID: NOT_RUN
HUMAN: NOT_RUN
PRODUCTION CUTOVER: BLOCKED
```

## 8. Files

New files:

```text
tools/validation/finite/finite_validation_launcher.gd
tools/validation/finite/finite_validation_launcher.tscn
tools/validation/finite/validation_run_state_fixture.gd
tests/finite/validation/test_finite_validation_launcher.gd
tests/finite/validation/test_validation_stack_modes.gd
tests/finite/validation/test_validation_entrypoint_invariance.gd
export_presets.cfg
```

Modified files:

```text
project.godot
tests/run_tests.gd
docs/superpowers/specs/2026-08-05-finite-validation-harness-design.md
기획서/50_제작_검증/FP_01_02_IMPLEMENTATION_AUDIT.md
기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md
기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md
```

No production scene or gameplay-domain file is in scope.

## 9. Acceptance criteria

1. All four validation modes boot through the launcher.
2. Stack modes produce exact 8/16/32 presenter token counts with one rear TOP.
3. Proof mode mounts the real finite Slice without injecting a solution.
4. Invalid modes fail closed.
5. Android validation preset is committed without secrets or local paths.
6. Base production main and `game/main/main.tscn` remain unchanged.
7. Full tests and Project Contract pass.
8. Authority documents and the correct Google Sheet record `VALIDATION_PREP_PASS`, while Android/HUMAN stay `NOT_RUN`.

## 10. Self-review

- No placeholders or ambiguous ownership remain.
- The custom-feature mechanism is supported by Godot export behavior.
- The launcher is isolated from product-domain ownership.
- Stack fixtures validate presentation rather than fake gameplay completion.
- Production cutover remains a separate approval and PR.
