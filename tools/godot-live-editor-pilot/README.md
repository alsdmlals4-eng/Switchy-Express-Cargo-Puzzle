# Switchy Godot Live-Editor Real-Project Pilot

## Purpose

This package validates the hardened Base Godot live-editor v2 adapter against an actual Switchy Express Scene without installing the adapter into the source project.

The source repository remains unconfigured. All addon activation, configured Manifest generation, Scene mutation, save, exact byte restoration, adversarial requests and project regression tests run inside a disposable full-project copy outside the repository.

This is an in-process Editor adapter Pilot. It is not an MCP server, external transport, runtime debugger or production installation.

## Fixed target

```yaml
scene: res://game/finite/presentation/finite_slice_view.tscn
node: Board/BoardTitle
original_name: BoardTitle
base_adapter_commit: bd72e61722ebb4e29dd66b0885fba9428b1c14fb
```

The materializer fails closed when the pinned source bytes, Base snapshot, target declaration, source Manifest or source plugin state differs.

## Source boundary

The following source paths are hashed before and after execution and are never intentionally changed:

```text
project.godot
game/**
assets/**
기획서/**
```

The source Manifest remains `NOT_CONFIGURED` with disabled transport. The source `project.godot` never enables either Pilot addon.

## Run

Without a configured Godot executable:

```bash
python tools/run_switchy_godot_live_editor_pilot.py \
  --report /tmp/switchy-pilot-report.json
```

Expected result:

```yaml
status: SKIPPED_NOT_CONFIGURED
code: GODOT_BIN_REQUIRED
production_adapter_ready: false
```

With exact Godot 4.7.1:

```bash
python tools/run_switchy_godot_live_editor_pilot.py \
  --godot /path/to/Godot_v4.7.1-stable_linux.x86_64 \
  --report /tmp/switchy-pilot-report.json
```

The runner verifies the executable version and SHA-256, materializes a fresh temporary copy, runs the Editor Pilot, executes the existing project regression suite, rehashes protected source paths and removes the temporary copy.

Use `--preserve-failure` only for local diagnosis. Never commit the preserved workspace or its machine-specific path.

## Runtime sequence

```text
materialize isolated copy
→ activate exact in-process addons only in copy
→ open actual Switchy finite Scene
→ inspect
→ KEEP_DIRTY rename
→ Editor Undo
→ SAVE_CURRENT_SCENE rename
→ Editor Undo and save
→ exact original-byte restoration when Godot serialization differs
→ stale/hash/approval adversarial rejection
→ filesystem scan quiet window
→ bounded 64-request inspect batch
→ final target and byte restoration
→ existing project regression tests
→ source protected-path rehash
```

Exact byte restoration is restricted to the pinned temporary Scene. The Pilot captures its original bytes before activation. When semantic Undo plus Editor save produces equivalent but non-identical serialization, it rewrites only that temporary Scene with the captured bytes, refreshes the Editor filesystem, reopens the Scene and verifies both the node name and SHA-256.

## Stable failure codes

```text
GODOT_BIN_REQUIRED
GODOT_BIN_NOT_FOUND
GODOT_VERSION_MISMATCH
OUTPUT_INSIDE_REPOSITORY
OUTPUT_ALREADY_EXISTS
SOURCE_BASELINE_MISMATCH
BASE_SNAPSHOT_MISMATCH
SOURCE_MANIFEST_CONFIGURED
SOURCE_PLUGIN_ALREADY_ENABLED
TARGET_SCENE_CONTRACT_MISMATCH
COPY_INTEGRITY_MISMATCH
SOURCE_INTEGRITY_FAILURE
MATERIALIZATION_FAILED
RUNTIME_TIMEOUT
RUNTIME_RESULT_MISSING
RUNTIME_RESULT_INVALID
PROJECT_REGRESSION_FAILED
TARGET_STATE_CONFLICT
REQUEST_HASH_MISMATCH
APPROVAL_EXPIRED
APPROVAL_BINDING_MISMATCH
QUEUE_FULL
BATCH_STATE_NOT_STABLE
```

## Headless thumbnail error policy

Godot 4.7.1 headless Editor can emit this exact dummy-renderer error while saving an edited Scene:

```text
ERROR: Parameter "t" is null.
at: texture_2d_get (./servers/rendering/dummy/storage/texture_storage.h:110)
```

The runner classifies only that exact error/location pair separately. It is tolerated only after all of these succeed:

- Runtime result JSON validates;
- target Scene bytes are restored exactly;
- adversarial requests are rejected;
- the 64-request batch completes;
- existing project regression tests pass;
- protected source hashes remain unchanged.

Every other `ERROR:` and every `SCRIPT ERROR:` remains fatal.

## Recovery and cleanup

- The runner removes the temporary copy in `finally`.
- A failed run may be preserved only with `--preserve-failure`.
- The runner never resets or repairs the source working tree.
- Source integrity failure overrides all other results.
- Missing Runtime evidence is never converted to PASS.

## Evidence boundary

A passing Pilot proves only the isolated Linux headless Editor path for this one actual Switchy Scene and the closed `scene.inspect` / `node.rename` capabilities.

It does not prove:

- MCP protocol mapping;
- authenticated external transport;
- Windows Editor operation;
- Android device behavior;
- runtime debugger control;
- physical input;
- human usability;
- production installation;
- production adapter readiness.

`production_adapter_ready` remains `false`.
