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

This package closes only the `APK_EXPORT` preparation and evidence boundary. It does not approve Android usability, human comprehension, balance, final art, release signing, or production cutover.

## 2. Selected Approach

Use one validation APK with an in-app mode selector and a manually dispatched GitHub Actions export workflow.

- The existing validation launcher remains the only validation entrypoint.
- A dedicated selector component exposes four touch-selectable modes.
- The workflow pins the Godot and Android toolchain versions and exports the existing `Android Validation` preset.
- The workflow uploads the APK, SHA-256 file, build manifest, and build summary as one evidence bundle.
- The product `run/main_scene` and `game/main/main.tscn` remain unchanged.

### Rejected approaches

#### Four separate APKs

This multiplies installation, artifact, hash, and device-record bookkeeping and increases the chance that testers compare different source builds.

#### Local-only manual export

This is useful for debugging but insufficient as canonical evidence because the environment, source SHA, templates, and artifact hash are not independently recorded.

#### Production main cutover for testing

This would collapse validation and release decisions into one change. The validation custom feature already provides isolation, so early cutover is prohibited.

## 3. Benchmark and Industry Comparison

The design follows common game-production and CI practice:

- **One QA build, multiple test modes:** deterministic QA surfaces remain behind a non-production launcher instead of separate binaries.
- **Pinned export toolchain:** engine, JDK, Android platform/build tools, NDK, and export templates do not depend on mutable runner defaults.
- **Immutable evidence bundle:** source SHA, artifact hash, build metadata, and summary travel with the binary.
- **Manual workflow dispatch:** the platform build runs for controlled acceptance rather than every documentation or logic PR.
- **Separate build and usability gates:** export success proves packaging only, not touch accuracy, layout safety, performance, or comprehension.

This is stricter than a hobby-project local export but intentionally smaller than a production release pipeline with release keys, Play App Signing, staged rollout, crash analytics, and store delivery.

## 4. Architecture

### 4.1 Validation mode selector

Create a focused selector component:

```text
tools/validation/finite/finite_validation_mode_selector.gd
tools/validation/finite/finite_validation_mode_selector.tscn
```

The selector is mounted by `FiniteValidationLauncher` and exposes these buttons:

```text
PROOF
STACK 8
STACK 16
STACK 32
```

Behavior:

1. The validation launcher boots into selector state.
2. No product or fixture child is mounted until a valid mode is selected.
3. A button emits its exact `StringName` mode to the launcher.
4. The launcher calls the existing `configure_mode()` contract.
5. Selecting another mode frees the previous child before mounting the new one.
6. A persistent `Back to Modes` control clears the mounted child and restores selector state.
7. Invalid modes continue to fail closed and mount nothing.

The selector owns no build, rail, cargo, run, result, persistence, or balance state.

### 4.2 Touch and layout contract

- Every mode button and `Back to Modes` control has a minimum interactive area of `48 × 48` logical pixels.
- The selector is usable at the project reference viewport `1920 × 1080` in landscape.
- Labels are explicit; color is not the only distinction.
- The selector is hidden while a selected mode is mounted.
- `Back to Modes` is displayed in a dedicated overlay that does not cover the core board interaction area.
- Stack fixtures continue using the real presenter/view and exact token counts.

### 4.3 GitHub Actions export workflow

Create:

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

The workflow executes in this exact order:

1. Checkout the dispatched source commit.
2. Install Temurin Java 17.
3. Install Android platform 35, build tools 35.0.1, and NDK r28b.
4. Download Godot `4.7.1-stable` and its matching Android export templates.
5. Verify the downloaded engine version and template paths.
6. Run the complete headless test suite.
7. Validate product-entrypoint invariants.
8. Export the `Android Validation` debug preset.
9. Fail when the expected APK is absent or zero bytes.
10. Compute the APK SHA-256.
11. Generate the machine-readable manifest and text summary.
12. Upload one 14-day artifact bundle.
13. Generate artifact attestation when GitHub exposes the required permission; otherwise record `ATTESTATION_NOT_AVAILABLE` without claiming attestation.

### 4.4 Build manifest

The workflow writes `validation-build-manifest.json`. Values come from these exact sources:

| Field | Value source |
|---|---|
| `schema_version` | integer `1` |
| `source_commit` | `GITHUB_SHA`; exactly 40 lowercase hexadecimal characters |
| `workflow_run_id` | decimal string from `GITHUB_RUN_ID` |
| `workflow_run_attempt` | decimal string from `GITHUB_RUN_ATTEMPT` |
| `godot_version` | literal `4.7.1-stable` |
| `java_version` | literal `17` |
| `android_platform` | literal `35` |
| `android_build_tools` | literal `35.0.1` |
| `android_ndk` | literal `r28b` |
| `export_preset` | literal `Android Validation` |
| `package_id` | literal `com.alsdmlals4.switchyexpress.validation` |
| `apk_filename` | literal `switchy-express-validation.apk` |
| `apk_sha256` | first field from `sha256sum builds/switchy-express-validation.apk`; exactly 64 lowercase hexadecimal characters |
| `validation_modes` | exact array `PROOF`, `STACK_8`, `STACK_16`, `STACK_32` |
| `production_main` | literal `res://game/main/main.tscn` |

No secret, token, keystore password, machine-local SDK path, or user directory is written into the manifest or artifact.

### 4.5 Artifact contract

The workflow derives `SHORT_SHA` by taking characters 1–8 of `GITHUB_SHA` and uploads:

```text
artifact name: switchy-express-validation-${SHORT_SHA}
retention: 14 days
```

Contents:

```text
switchy-express-validation.apk
switchy-express-validation.apk.sha256
validation-build-manifest.json
validation-build-summary.txt
```

The APK is a debug validation artifact. It is not a release candidate, store upload, or production-signed binary.

## 5. Data Flow

```text
workflow_dispatch at one source SHA
→ pinned toolchain installation
→ full tests and invariance checks
→ Android Validation export
→ APK existence and size check
→ SHA-256 calculation
→ manifest and summary generation
→ artifact upload and optional attestation
→ tester downloads one exact evidence bundle
→ tester records device smoke against source SHA and APK SHA-256
```

On-device flow:

```text
validation custom feature
→ finite_validation_launcher.tscn
→ selector
→ PROOF or STACK_8/16/32
→ Back to Modes
→ selector
```

## 6. Failure Handling

The workflow fails closed for:

- toolchain download or checksum failure
- missing matching Godot Android export templates
- headless regression-test failure
- product entrypoint drift
- validation preset or custom-feature drift
- export command non-zero exit
- missing or zero-byte APK
- malformed APK SHA-256
- manifest field mismatch
- artifact upload failure

Attestation handling:

- When repository permissions support attestation and the attestation step fails, the workflow fails.
- When the platform does not provide the required permission, the summary records `ATTESTATION_NOT_AVAILABLE`; no attestation claim is made.

No failure may fall back to the product/legacy main, a different preset, or an unpinned engine version.

## 7. Security and Repository Boundaries

- Use only `com.alsdmlals4.switchyexpress.validation`.
- Commit no release key, debug key, keystore file, password, service-account credential, or SDK path.
- Use GitHub-provided ephemeral credentials only for artifact upload and optional attestation.
- Do not upload the APK into Git or Google Sheet.
- Do not modify `game/main/main.tscn`.
- Do not change base `run/main_scene`.
- Do not expose the selector in normal product exports.
- Do not add analytics, network, save, or player-profile writes to validation code.

## 8. TDD Strategy

Every implementation task follows RED → GREEN → refactor → full regression.

### 8.1 Selector tests

- launcher boots with selector visible and no mounted child
- four buttons exist with exact labels
- every interactive control meets the `48 × 48` minimum
- tapping each button mounts exactly the expected mode
- switching modes frees the previous child
- `Back to Modes` clears the child and restores selector state
- invalid mode still fails closed
- stack modes retain exact 8/16/32 token counts and one final TOP

### 8.2 Workflow contract tests

Repository tests require:

- only `workflow_dispatch` trigger
- pinned Godot/JDK/SDK/build-tools/NDK/template versions
- tests and invariance checks before export
- exact `Android Validation` preset
- APK existence and non-empty checks
- SHA-256 generation
- all manifest fields and value sources
- artifact retention of 14 days
- no secret values or local machine paths
- no push, pull-request, schedule, or release trigger

### 8.3 Invariance tests

- base product main remains `res://game/main/main.tscn`
- validation feature override remains the validation launcher
- `game/main/main.tscn` remains byte-identical to the approved baseline
- product code has no dependency on the selector
- validation files remain under `tools/validation/finite/`

### 8.4 Real workflow proof

Static tests are insufficient. The package is complete only after one actual workflow dispatch produces:

- successful run
- non-empty APK artifact
- valid SHA-256 file
- valid manifest
- downloadable evidence bundle

That evidence changes only:

```text
APK_EXPORT: NOT_RUN → PASS
```

It does not change Android or HUMAN to PASS.

## 9. Files

New files:

```text
.github/workflows/android-validation-apk.yml
tools/validation/finite/finite_validation_mode_selector.gd
tools/validation/finite/finite_validation_mode_selector.tscn
tests/finite/validation/test_validation_mode_selector.gd
tests/finite/validation/test_android_validation_workflow_contract.gd
```

Modified files:

```text
tools/validation/finite/finite_validation_launcher.gd
tools/validation/finite/finite_validation_launcher.tscn
tests/run_tests.gd
기획서/50_제작_검증/FP_01_02_IMPLEMENTATION_AUDIT.md
기획서/50_제작_검증/VERTICAL_SLICE_CONTRACT.md
기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md
```

No product scene, gameplay-domain file, save system, release-signing file, or store-delivery file is in scope.

## 10. Acceptance Criteria

1. One validation APK exposes all four modes through touch controls.
2. Android mode selection requires no command-line argument.
3. Every selector control meets the minimum touch contract.
4. Switching and returning leak no mounted child.
5. Existing validation, finite, and legacy tests remain green.
6. A manual workflow exports with the pinned toolchain.
7. The workflow produces APK, SHA-256, manifest, and summary in one 14-day artifact.
8. The workflow cannot export another preset or product entrypoint.
9. One actual dispatched run proves artifact generation.
10. Product main, gameplay rules, saves, and release signing remain unchanged.
11. `APK_EXPORT` becomes PASS only from the actual workflow artifact.
12. Android smoke, five-person comprehension, and production cutover remain `NOT_RUN` or blocked.

## 11. Decision and Approval Boundary

This design contains one approval item and is below the maximum approval batch size of ten.

User approval of the recommended approach authorized writing this design. Implementation authority begins only after the user reviews this committed specification and approves it.

## 12. Self-Review

- No TODO, incomplete section, or undefined ownership remains.
- Manifest values have exact runtime sources rather than generic placeholders.
- Selector files and responsibilities are fixed rather than optional.
- Build success is separated from Android/HUMAN success.
- Versions, artifact fields, retention, package ID, and failure conditions are exact.
- Product entrypoint and release signing remain outside scope.
- The design extends the existing validation harness without duplicating it.
