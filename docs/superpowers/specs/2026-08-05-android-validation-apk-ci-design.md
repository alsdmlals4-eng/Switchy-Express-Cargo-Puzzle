# Android Validation APK CI Design

```yaml
status: USER_SPEC_REVIEW
approval_basis: user approved recommended single-QA-APK approach on 2026-08-05
product_authority: GMB-002 · SX-DEC-027~036
execution_authority: FP-DOR-001 · EV-USER-021
prior_audit: SX-AUD-018
source_main: 1f39ec3ed50c73164aa5d54c6b90618714a23813
scope: validation-mode selector · reproducible Android debug export · artifact evidence
product_cutover: forbidden
android_device_result: NOT_RUN
human_result: NOT_RUN
```

## 1. Goal

Produce one reproducible validation-only Android APK that lets a tester select `PROOF`, `STACK_8`, `STACK_16`, or `STACK_32` on the device, while preserving the product default entrypoint and keeping Android/HUMAN acceptance separate from build success.

The package closes only the `APK_EXPORT` preparation and evidence boundary. It does not approve Android usability, human comprehension, balance, final art, release signing, or production cutover.

## 2. Selected Approach

Use one validation APK with an in-app mode selector and a manually dispatched GitHub Actions export workflow.

- The existing validation launcher remains the only validation entrypoint.
- A small launcher menu exposes four touch-selectable modes.
- The workflow pins the Godot and Android toolchain versions and exports the existing `Android Validation` preset.
- The workflow uploads the APK, SHA-256 manifest, source/build metadata, and build log summary as one evidence bundle.
- The product `run/main_scene` and `game/main/main.tscn` remain unchanged.

### Rejected approaches

#### Four separate APKs

This simplifies each launcher invocation but multiplies installation, artifact, hash, and device-record bookkeeping. It also increases the chance that testers compare different source builds.

#### Local-only manual export

This is useful for debugging but insufficient as canonical evidence because the environment, source SHA, templates, and artifact hash are not independently recorded.

#### Production main cutover for testing

This would collapse validation and release decisions into one change. The validation custom feature already provides the required isolation, so early cutover is prohibited.

## 3. Benchmark and Industry Comparison

The design follows common game-production and CI practice:

- **One QA build, multiple test modes:** internal QA builds commonly expose deterministic test surfaces behind a non-production launcher instead of generating separate binaries for each scenario.
- **Pinned export toolchain:** reproducible builds pin engine, JDK, Android platform/build tools, NDK, and export-template versions rather than relying on mutable runner defaults.
- **Immutable evidence bundle:** source SHA, artifact hash, build metadata, and logs travel with the binary so a device result can be traced to one exact build.
- **Manual workflow dispatch:** expensive platform builds should not run on every documentation or logic PR when their purpose is controlled device acceptance.
- **Separation of build and usability gates:** a successful APK export proves packaging only; it does not prove touch accuracy, layout safety, performance, or player comprehension.

This approach is stricter than a typical hobby-project local export but smaller than a production release pipeline with release keys, Play App Signing, staged rollout, crash analytics, and store delivery.

## 4. Architecture

### 4.1 Validation mode selector

Add a selector layer owned by the validation launcher.

Supported buttons:

```text
PROOF
STACK 8
STACK 16
STACK 32
```

Behavior:

1. The validation launcher boots into a selector state.
2. No product or fixture child is mounted until a valid mode is selected.
3. Selecting a mode calls the existing `configure_mode()` contract.
4. Selecting another mode frees the previous child before mounting the new one.
5. A persistent `Back to Modes` control returns to the selector without restarting the app.
6. An invalid mode continues to fail closed and mounts nothing.

The selector owns no build, rail, cargo, run, result, persistence, or balance state.

### 4.2 Touch and layout contract

- Every mode button and `Back to Modes` control has a minimum interactive area of `48 × 48` logical pixels.
- The selector is usable at the project reference viewport `1920 × 1080` in landscape.
- Text labels are explicit; color is not the only mode distinction.
- The selector must not overlap the mounted proof Slice or stack view.
- Stack fixtures continue using the real presenter/view and exact token counts.

### 4.3 GitHub Actions export workflow

Create a manually dispatched workflow:

```text
.github/workflows/android-validation-apk.yml
```

Trigger:

```yaml
on:
  workflow_dispatch:
```

Pinned toolchain:

```text
Godot: 4.7.1-stable
Java: Temurin 17
Android platform: 35
Android build tools: 35.0.1
Android NDK: r28b
Godot Android export templates: 4.7.1-stable
Runner: ubuntu-latest
```

The workflow performs these stages in order:

1. Checkout the selected commit.
2. Install Java 17.
3. Install the pinned Android SDK components.
4. Download and verify Godot `4.7.1-stable` and matching export templates.
5. Run the complete headless test suite.
6. Validate the production-entrypoint invariants.
7. Export the `Android Validation` debug preset.
8. Fail if the expected APK is missing or empty.
9. Compute SHA-256.
10. Write a machine-readable build manifest.
11. Upload the APK and evidence files as one artifact.
12. Produce an artifact attestation when repository/platform permissions permit it.

### 4.4 Build manifest

The evidence bundle contains `validation-build-manifest.json` with exact fields:

```json
{
  "schema_version": 1,
  "source_commit": "<40-character SHA>",
  "workflow_run_id": "<GitHub run ID>",
  "workflow_run_attempt": "<attempt number>",
  "godot_version": "4.7.1-stable",
  "java_version": "17",
  "android_platform": "35",
  "android_build_tools": "35.0.1",
  "android_ndk": "r28b",
  "export_preset": "Android Validation",
  "package_id": "com.alsdmlals4.switchyexpress.validation",
  "apk_filename": "switchy-express-validation.apk",
  "apk_sha256": "<64 lowercase hex characters>",
  "validation_modes": ["PROOF", "STACK_8", "STACK_16", "STACK_32"],
  "production_main": "res://game/main/main.tscn"
}
```

No secret, token, keystore password, machine-local SDK path, or user directory is written into the manifest or artifact.

### 4.5 Artifact contract

Artifact name:

```text
switchy-express-validation-<short-source-sha>
```

Contents:

```text
switchy-express-validation.apk
switchy-express-validation.apk.sha256
validation-build-manifest.json
validation-build-summary.txt
```

Retention:

```text
14 days
```

The APK remains a debug validation artifact. It is not a release candidate, store upload, or production-signed binary.

## 5. Data Flow

```text
workflow_dispatch at source SHA
→ pinned toolchain installation
→ full tests and invariance checks
→ Godot Android Validation export
→ APK existence/size check
→ SHA-256 calculation
→ manifest and summary generation
→ artifact upload/attestation
→ tester downloads exact evidence bundle
→ tester records device smoke against manifest SHA
```

On-device flow:

```text
validation custom feature
→ finite_validation_launcher.tscn
→ mode selector
→ PROOF or STACK_8/16/32
→ Back to Modes
```

## 6. Failure Handling

The workflow fails closed for any of these conditions:

- toolchain download or checksum failure
- missing matching Godot Android export templates
- headless regression-test failure
- product entrypoint drift
- validation preset or custom feature drift
- export command non-zero exit
- missing or zero-byte APK
- APK SHA-256 not matching 64 lowercase hexadecimal characters
- manifest field mismatch
- artifact upload failure

An attestation permission failure is handled as follows:

- If attestation is configured as required for the repository, fail the workflow.
- If the platform does not expose the required permission, record `ATTESTATION_NOT_AVAILABLE` in the summary without claiming provenance attestation.

No failure may fall back to exporting the product/legacy main, a different preset, or an unpinned engine version.

## 7. Security and Repository Boundaries

- Use only the validation package ID.
- Commit no release key, debug key, keystore file, password, service-account credential, or SDK path.
- Use GitHub-provided ephemeral credentials only for artifact upload and optional attestation.
- Do not upload the APK into the Git repository or Google Sheet.
- Do not modify `game/main/main.tscn`.
- Do not change base `run/main_scene`.
- Do not expose the validation selector in normal product exports.
- Do not add analytics, network, save, or player-profile writes to the validation launcher.

## 8. TDD Strategy

Every implementation task follows RED → GREEN → refactor → full regression.

### 8.1 Selector tests

- launcher boots with selector visible and no mounted child
- four mode buttons exist with explicit labels
- all interactive controls meet the `48 × 48` minimum
- tapping each button mounts exactly the expected mode
- switching modes frees the previous child
- `Back to Modes` clears the mounted child and restores the selector
- invalid mode still fails closed
- stack modes retain exact 8/16/32 token counts and one final TOP

### 8.2 Workflow contract tests

Repository tests inspect the workflow and require:

- `workflow_dispatch` trigger
- pinned Godot/JDK/SDK/build-tools/NDK/template versions
- test-before-export order
- exact `Android Validation` preset
- APK existence and non-empty checks
- SHA-256 generation
- exact manifest fields
- artifact retention of 14 days
- no secret values or local machine paths
- no push, pull-request, schedule, or release trigger

### 8.3 Invariance tests

- base production main remains `res://game/main/main.tscn`
- validation feature override remains the launcher
- `game/main/main.tscn` remains unchanged
- normal product code has no dependency on the validation selector
- validation fixture paths remain under `tools/validation/finite/`

### 8.4 Workflow proof

Static workflow tests are necessary but not sufficient. The package is complete only after one real workflow dispatch produces:

- successful workflow run
- non-empty APK artifact
- valid SHA-256
- valid manifest
- downloadable evidence bundle

That result changes only:

```text
APK_EXPORT: NOT_RUN → PASS
```

It does not change Android or HUMAN to PASS.

## 9. Files

Expected new files:

```text
.github/workflows/android-validation-apk.yml
tools/validation/finite/finite_validation_mode_selector.gd
tools/validation/finite/finite_validation_mode_selector.tscn
tests/finite/validation/test_validation_mode_selector.gd
tests/finite/validation/test_android_validation_workflow_contract.gd
```

Expected modified files:

```text
tools/validation/finite/finite_validation_launcher.gd
tools/validation/finite/finite_validation_launcher.tscn
tests/run_tests.gd
기획서/50_제작_검증/FP_01_02_IMPLEMENTATION_AUDIT.md
기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md
기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md
```

The implementation plan may reduce this list if the existing launcher can own the selector without violating single responsibility. It may not broaden into product UI or release tooling.

## 10. Acceptance Criteria

1. One validation APK exposes all four modes through touch controls.
2. Mode selection does not require command-line arguments on Android.
3. Every selector control meets the minimum touch contract.
4. Switching and returning to the selector leaks no mounted child.
5. Existing validation and finite tests remain green.
6. A manual GitHub Actions workflow exports with the pinned toolchain.
7. The workflow produces the APK, SHA-256, manifest, and summary in one 14-day artifact.
8. The workflow never exports a different preset or product entrypoint.
9. One actual dispatched run proves the artifact can be generated.
10. Product main, gameplay rules, saves, and release signing remain unchanged.
11. `APK_EXPORT` may become PASS only from the real workflow artifact.
12. Android device smoke, five-person comprehension, and production cutover remain `NOT_RUN`/blocked.

## 11. Decision and Approval Boundary

This design contains one approval item and is below the maximum approval batch size of ten.

User approval of the recommended approach authorizes writing this design only. Implementation authority begins after the user reviews this written specification and approves it.

## 12. Self-Review

- No placeholder, TODO, or ambiguous ownership remains.
- The mode selector and export workflow are independently testable.
- Build success is explicitly separated from Android/HUMAN success.
- Versions, artifact fields, retention, package ID, and failure conditions are exact.
- Product entrypoint and release signing remain outside scope.
- The design does not duplicate the existing validation harness; it extends only device usability and reproducible export evidence.
