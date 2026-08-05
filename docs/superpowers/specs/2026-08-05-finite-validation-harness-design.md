# Finite Validation Harness Design

```yaml
status: APPROVED_RECOMMENDED_APPROACH
approval: user approved recommended A on 2026-08-05
product_authority: GMB-002 · SX-DEC-027~036
execution_authority: FP-DOR-001 · EV-USER-021
source_main: 98ec80129619d4af5dee486ad7ea01dcb9ddaa9a
current_audit: SX-AUD-017
scope: validation-only launcher · stack readability fixtures · Android debug export preset · invariance tests
production_cutover: forbidden
```

## 1. Goal

Create a reproducible, non-product validation package that allows the approved Android smoke matrix and five-person comprehension test to run without changing the production entrypoint or introducing campaign/content authority.

The package must support two validation surfaces:

1. **Proof Slice mode** — launches the real `res://game/finite/main/finite_slice.tscn` so testers can build, run, fail, retry, pause, load, and switch.
2. **Stack Readability mode** — displays presenter/view-owned cargo stacks of exactly 8, 16, or 32 tokens so rear/TOP readability can be tested without fabricating product maps or mutating delivery-domain state.

## 2. Approaches considered

### A. Independent validation launcher and presenter fixtures — selected

- Keeps `project.godot` and `game/main/main.tscn` unchanged.
- Runs as an explicit scene or Android validation export.
- Reuses the real finite proof Slice for interaction checks.
- Uses presenter-generated stack models for 8/16/32 display checks.
- Adds no campaign content and no production save data.

This is the smallest approach that is reproducible and tests the actual product surface where it matters.

### B. Three high-cargo authored gameplay maps — rejected

This would turn a readability check into content design, route balancing, and delivery-domain work. It would expand the First Slice and could falsely make QA fixtures look like approved campaign content.

### C. Local uncommitted entrypoint replacement — rejected

This cannot provide a trustworthy source SHA or reproducible APK. It also risks accidental production cutover.

## 3. Architecture

### 3.1 Validation launcher

Add an isolated scene under `tools/validation/finite/`:

```text
finite_validation_launcher.tscn
finite_validation_launcher.gd
```

The launcher owns only mode selection and child-scene mounting. It must not own build, rail, cargo, timer, or delivery rules.

Public contract:

```gdscript
configure_mode(mode: StringName) -> bool
active_mode() -> StringName
active_scene_path() -> String
stack_fixture_size() -> int
```

Supported modes:

```text
PROOF
STACK_8
STACK_16
STACK_32
```

Unknown modes fail closed and leave no validation child mounted.

### 3.2 Proof mode

`PROOF` instantiates `res://game/finite/main/finite_slice.tscn` unchanged. The launcher does not inject a route, auto-load state, or hidden solution. Human testers receive the same proof surface covered by Task 12 automated tests.

### 3.3 Stack readability modes

The launcher instantiates the real `finite_slice_view.tscn` and applies a validation model created through `FiniteSlicePresenter.show_run()` with a deterministic alternating cargo sequence.

Requirements:

- exact token count: 8, 16, or 32
- exactly one TOP token
- TOP is the final/rear token
- every token contains color, shape, text label, index, and top flag
- the view remains passive; build/run commands are not connected to product-domain state
- no artificial cargo is written to `FiniteCargoStack`, save state, map data, or runtime sessions

The presenter remains the authority for cargo token descriptors. The launcher may create a minimal run-state fixture object only to select RUNNING presentation.

### 3.4 Mode selection

The launcher reads only Godot user arguments after `--`:

```text
--validation-mode=proof
--validation-mode=stack8
--validation-mode=stack16
--validation-mode=stack32
```

No argument defaults to `PROOF`.

Android validation export uses the launcher as the export preset's custom main scene, not as the project's production main scene.

## 4. Android export contract

Add `export_presets.cfg` with a single Android debug validation preset named:

```text
Android Validation
```

The preset must:

- export the project with `tools/validation/finite/finite_validation_launcher.tscn` as the validation main scene
- use landscape orientation inherited from project settings
- use a validation package identifier distinct from a future production package
- contain no keystore secrets or machine-specific SDK paths
- be usable with Godot editor command line:

```bash
godot --headless --path . --export-debug "Android Validation" builds/switchy-express-validation.apk
```

The repository can verify preset structure and selected scene, but it cannot claim a successful APK build unless export templates and Android SDK tooling are actually present.

## 5. Production invariants

The package must enforce all of the following:

- `project.godot` keeps `run/main_scene="res://game/main/main.tscn"`.
- `game/main/main.tscn` is not modified.
- validation files are under `tools/validation/finite/`.
- no validation scene is referenced by production gameplay code.
- no existing finite or legacy rule is changed.
- validation modes do not create or update user saves.
- Android and HUMAN Gate states remain `NOT_RUN` after implementation; only `VALIDATION_PREP` may become PASS.

## 6. Error handling

- Unknown validation mode: return `false`, expose `INVALID_MODE`, mount nothing.
- Missing packed scene: return `false`, expose `MISSING_SCENE`, mount nothing.
- Invalid stack size: reject values other than 8, 16, 32.
- Reconfiguration: remove the previous validation child before mounting the new one.
- Export preset parse failure or production entrypoint drift: test failure.

No fallback may silently launch production main or a legacy scene.

## 7. Test strategy

### 7.1 RED-first launcher tests

Add focused tests for:

- launcher scene and script existence
- default mode boots proof Slice
- all four modes mount the expected scene type
- invalid mode fails closed
- reconfiguration replaces the prior child
- stack modes expose exactly 8/16/32 tokens
- each stack has exactly one TOP at the final index
- token descriptors preserve color + shape + text redundancy

### 7.2 Invariance tests

Add tests that read repository text and assert:

- `project.godot` production main remains `res://game/main/main.tscn`
- `game/main/main.tscn` remains unchanged by the package
- Android validation preset references only the validation launcher
- validation package identifier is not the future production identifier

### 7.3 Regression gates

Run the complete Godot suite and Project Contract workflow. Existing finite and legacy tests must remain green.

### 7.4 Manual gates after implementation

Implementation completion changes only:

```text
VALIDATION_PREP: BLOCKED → PASS
```

It does not change:

```text
ANDROID: NOT_RUN
HUMAN: NOT_RUN
PRODUCTION CUTOVER: BLOCKED
```

## 8. Files

Expected new files:

```text
tools/validation/finite/finite_validation_launcher.gd
tools/validation/finite/finite_validation_launcher.tscn
tools/validation/finite/validation_run_state_fixture.gd
tests/finite/validation/test_finite_validation_launcher.gd
tests/finite/validation/test_validation_stack_modes.gd
tests/finite/validation/test_validation_entrypoint_invariance.gd
export_presets.cfg
```

Expected modified files:

```text
tests/run_tests.gd
기획서/50_제작_검증/FP_01_02_IMPLEMENTATION_AUDIT.md
기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md
기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md
```

No production scene or gameplay-domain file is in scope.

## 9. Acceptance criteria

The package is complete when:

1. all four validation modes boot through the launcher;
2. stack modes produce exact 8/16/32 presenter token counts with one rear TOP;
3. proof mode mounts the real finite Slice without injecting a solution;
4. invalid modes fail closed;
5. Android validation preset is committed without secrets or local paths;
6. production main scene and legacy default remain unchanged;
7. full tests and Project Contract pass;
8. authority documents and the correct Google Sheet record `VALIDATION_PREP_PASS`, while Android/HUMAN stay `NOT_RUN`.

## 10. Self-review

- No placeholders or TBD values remain.
- The launcher is isolated from product-domain ownership.
- Stack fixtures test presentation readability rather than fake gameplay completion.
- The export preset enables reproducible validation without claiming an APK was built.
- Production cutover remains a separate approval and PR.
