# Switchy Godot Live-Editor Real-Project Pilot Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Prove that the hardened Base Godot live-editor v2 adapter can inspect, reversibly rename, save, restore, reject adversarial requests, and preserve product integrity in a materialized copy of the actual Switchy Express project.

**Architecture:** The source repository receives only a self-contained Pilot package, deterministic materializer, bounded runner, tests, CI wiring, and evidence. The original `project.godot`, `game/**`, `assets/**`, and `기획서/**` remain byte-identical. The adapter and Pilot plugin are activated only in an outside-repository temporary copy, where the actual `finite_slice_view.tscn` Scene is exercised and restored byte-for-byte.

**Tech Stack:** Python 3.12 standard library, Godot 4.7.1-stable, GDScript, `unittest`, GitHub Actions.

## Global Constraints

- Implementation starts on a new branch from the then-current `main`; do not implement on PR #82's design branch.
- First implementation commit is test-only RED.
- Source protected paths are immutable: `project.godot`, `game/**`, `assets/**`, `기획서/**`.
- The global project Base pin stays at v9.4.3; `skills/PROJECT_BASE_ADAPTER.json` is not changed.
- Base live-editor payload is pinned to commit `bd72e61722ebb4e29dd66b0885fba9428b1c14fb` and verified by per-file SHA-256.
- Actual target Scene is `res://game/finite/presentation/finite_slice_view.tscn`.
- Actual target node is `Board/BoardTitle`; fail closed rather than selecting another node.
- The source Manifest is always `NOT_CONFIGURED` with disabled transport.
- Adapter and Pilot activation occur only in a temporary copy outside the repository.
- No external transport, MCP, HTTP, WebSocket, runtime debugger, Autoload, Android build, physical-input, or human-usability work is included.
- No Google Sheet or product-planning canon change is included.
- Runtime evidence is separated from production readiness; `production_adapter_ready` stays `false`.
- Any HEAD change invalidates prior CI and review evidence.
- Merge is not authorized by this plan; stop at a reviewed Draft PR unless the user explicitly approves merge.

---

## Planned File Map

### Create

- `tools/godot-live-editor-pilot/pilot_contract.py` — shared hashing, inventory, path-safety, provenance and result-contract helpers.
- `tools/godot-live-editor-pilot/BASE_SOURCE.json` — exact Base source commit and per-file raw SHA-256 inventory.
- `tools/godot-live-editor-pilot/SOURCE_BASELINE.json` — fresh implementation-base commit, Git blob SHA and raw SHA-256 pins for `project.godot` and the target Scene.
- `tools/godot-live-editor-pilot/GODOT_LIVE_EDITOR_CAPABILITY_MANIFEST.source.json` — disabled, `NOT_CONFIGURED` source Manifest.
- `tools/godot-live-editor-pilot/vendor/base_live_editor_adapter/*` — byte-identical Base adapter snapshot.
- `tools/godot-live-editor-pilot/pilot_plugin/plugin.cfg` — temporary-only Pilot plugin declaration.
- `tools/godot-live-editor-pilot/pilot_plugin/plugin.gd` — actual Switchy Scene Pilot orchestrator.
- `tools/godot-live-editor-pilot/README.md` — execution, recovery, evidence and non-goal boundaries.
- `tools/materialize_switchy_godot_live_editor_pilot.py` — deterministic outside-repository materializer.
- `tools/run_switchy_godot_live_editor_pilot.py` — Godot runner, regression runner, integrity verifier and consolidated reporter.
- `tests/python/test_switchy_godot_live_editor_pilot_contract.py` — static contract and fail-closed tests.
- `tests/python/test_switchy_godot_live_editor_pilot_runtime.py` — Runtime skip/configuration and actual Godot assertions.
- `docs/evidence/godot-live-editor/2026-08-06-switchy-real-project-pilot.md` — bounded final evidence and limitations.

### Modify

- `.github/workflows/project-contract.yml` — run static Pilot contract tests.
- `.github/workflows/godot-tests.yml` — run the exact Godot Pilot after existing project tests and upload the machine-readable report.

### Must Remain Unchanged

- `project.godot`
- `game/**`
- `assets/**`
- `기획서/**`
- `skills/PROJECT_BASE_ADAPTER.json`
- existing product tests and default entrypoints

---

### Task 1: Establish Test-Only RED Contract

**Files:**
- Create: `tests/python/test_switchy_godot_live_editor_pilot_contract.py`
- Create: `tests/python/test_switchy_godot_live_editor_pilot_runtime.py`
- Modify: `.github/workflows/project-contract.yml`

**Interfaces:**
- Consumes: approved design at `docs/superpowers/specs/2026-08-06-switchy-godot-live-editor-real-project-pilot-design.md`.
- Produces: executable RED assertions for every required source file, provenance rule, materialization boundary, Runtime gate and protected-path rule.

- [ ] **Step 1: Create the static failing test module**

Implement a `unittest.TestCase` with these exact test methods:

```python
class SwitchyGodotLiveEditorPilotContractTests(unittest.TestCase):
    def test_required_pilot_files_exist(self) -> None: ...
    def test_source_manifest_is_not_configured_and_disabled(self) -> None: ...
    def test_source_project_does_not_enable_pilot_plugins(self) -> None: ...
    def test_base_source_inventory_matches_vendored_bytes(self) -> None: ...
    def test_source_baseline_pins_git_blob_and_raw_sha256(self) -> None: ...
    def test_materializer_rejects_output_inside_repository(self) -> None: ...
    def test_target_scene_and_node_contract_is_exact(self) -> None: ...
    def test_protected_source_inventory_is_stable_after_materialization(self) -> None: ...
    def test_pilot_sources_contain_no_network_or_shell_primitive(self) -> None: ...
```

Use these constants exactly:

```python
ROOT = Path(__file__).resolve().parents[2]
PILOT_ROOT = ROOT / "tools/godot-live-editor-pilot"
TARGET_SCENE = ROOT / "game/finite/presentation/finite_slice_view.tscn"
TARGET_NODE = "Board/BoardTitle"
PROTECTED_ROOTS = (
    ROOT / "project.godot",
    ROOT / "game",
    ROOT / "assets",
    ROOT / "기획서",
)
```

The forbidden primitive scan covers all `.py` and `.gd` files under `tools/godot-live-editor-pilot/` and rejects:

```python
FORBIDDEN = (
    "TCPServer",
    "WebSocketPeer",
    "HTTPServer",
    "PacketPeerUDP",
    "Thread.new",
    "OS.execute",
    "subprocess.Popen(shell=True",
    "eval(",
    "exec(",
)
```

- [ ] **Step 2: Create the Runtime gate test module**

Implement these exact methods:

```python
class SwitchyGodotLiveEditorPilotRuntimeTests(unittest.TestCase):
    def test_runner_reports_skipped_not_configured_without_godot(self) -> None: ...

    @unittest.skipUnless(
        os.environ.get("GODOT_BIN"),
        "SKIPPED_NOT_CONFIGURED: set GODOT_BIN to exact Godot 4.7.1 executable",
    )
    def test_actual_switchy_editor_pilot(self) -> None: ...
```

The first test runs the runner without `--godot` and requires JSON output:

```json
{
  "status": "SKIPPED_NOT_CONFIGURED",
  "code": "GODOT_BIN_REQUIRED",
  "production_adapter_ready": false
}
```

The actual Runtime test requires all booleans below to be `true`:

```python
REQUIRED_RUNTIME_FLAGS = (
    "scene_inspect_pass",
    "dirty_rename_pass",
    "dirty_undo_pass",
    "saved_rename_pass",
    "saved_undo_restore_pass",
    "stale_state_block_pass",
    "request_hash_block_pass",
    "expired_approval_block_pass",
    "approval_binding_block_pass",
    "result_hash_pass",
    "queue_capacity_pass",
    "batch_64_pass",
    "source_integrity_pass",
    "temporary_scene_byte_restore_pass",
    "project_regression_pass",
)
```

- [ ] **Step 3: Add static test execution to Project Contract CI**

Append this step after Android smoke canonical freshness validation:

```yaml
      - name: Validate Switchy Godot live-editor Pilot contract
        run: python tests/python/test_switchy_godot_live_editor_pilot_contract.py -v
```

Do not add the actual Runtime to this workflow.

- [ ] **Step 4: Run RED tests**

Run:

```bash
python tests/python/test_switchy_godot_live_editor_pilot_contract.py -v
python tests/python/test_switchy_godot_live_editor_pilot_runtime.py -v
```

Expected:

```text
static contract: FAIL because Pilot files do not exist
runtime contract: first skip-contract test FAIL because runner does not exist
actual Runtime test: SKIPPED_NOT_CONFIGURED
```

Reject the RED commit if it fails because of syntax errors, import errors unrelated to missing implementation, or modifications to protected paths.

- [ ] **Step 5: Commit RED only**

```bash
git add tests/python/test_switchy_godot_live_editor_pilot_contract.py \
        tests/python/test_switchy_godot_live_editor_pilot_runtime.py \
        .github/workflows/project-contract.yml
git commit -m "test: define Switchy live-editor Pilot contract"
```

---

### Task 2: Pin Source Baseline and Base Provenance

**Files:**
- Create: `tools/godot-live-editor-pilot/pilot_contract.py`
- Create: `tools/godot-live-editor-pilot/BASE_SOURCE.json`
- Create: `tools/godot-live-editor-pilot/SOURCE_BASELINE.json`
- Create: `tools/godot-live-editor-pilot/GODOT_LIVE_EDITOR_CAPABILITY_MANIFEST.source.json`
- Create: `tools/godot-live-editor-pilot/vendor/base_live_editor_adapter/*`
- Test: `tests/python/test_switchy_godot_live_editor_pilot_contract.py`

**Interfaces:**
- Produces:
  - `sha256_file(path: Path) -> str`
  - `inventory(root: Path, targets: Iterable[Path]) -> dict[str, str]`
  - `protected_inventory(root: Path) -> dict[str, str]`
  - `load_json(path: Path) -> dict[str, Any]`
  - `validate_base_snapshot(root: Path) -> list[str]`
  - `validate_source_baseline(root: Path) -> list[str]`

- [ ] **Step 1: Implement shared hashing and inventory helpers**

`sha256_file()` reads in 64 KiB chunks. `inventory()` sorts relative POSIX paths and hashes file bytes. `protected_inventory()` includes `project.godot` and every file under `game/`, `assets/`, and `기획서/`, excluding `.godot`, caches and generated artifacts.

Use this exact result shape:

```python
{
    "project.godot": "<64 lowercase hex generated by sha256_file>",
    "game/finite/presentation/finite_slice_view.tscn": "<64 lowercase hex generated by sha256_file>",
}
```

The implementation writes actual generated hashes; do not commit angle-bracket strings.

- [ ] **Step 2: Vendor the exact Base adapter snapshot**

Copy these exact paths from Base commit `bd72e61722ebb4e29dd66b0885fba9428b1c14fb`:

```text
templates/project-operations/godot-live-editor/addons/base_live_editor_adapter/plugin.cfg
templates/project-operations/godot-live-editor/addons/base_live_editor_adapter/plugin.gd
templates/project-operations/godot-live-editor/addons/base_live_editor_adapter/request_queue.gd
templates/project-operations/godot-live-editor/addons/base_live_editor_adapter/runtime_contract_guard.gd
templates/project-operations/godot-live-editor/addons/base_live_editor_adapter/editor_state_probe.gd
templates/project-operations/godot-live-editor/addons/base_live_editor_adapter/capability_registry.gd
templates/project-operations/godot-live-editor/addons/base_live_editor_adapter/operation_ledger.gd
templates/project-operations/godot-live-editor/addons/base_live_editor_adapter/evidence_writer.gd
templates/project-operations/godot-live-editor/addons/base_live_editor_adapter/editor_transaction_executor.gd
templates/project-operations/godot-live-editor/addons/base_live_editor_adapter/README.md
```

Destination is `tools/godot-live-editor-pilot/vendor/base_live_editor_adapter/` preserving filenames.

- [ ] **Step 3: Generate and commit `BASE_SOURCE.json`**

Run a deterministic Python command that imports `pilot_contract.py`, hashes every vendored file and writes:

```json
{
  "repository": "alsdmlals4-eng/Base",
  "commit": "bd72e61722ebb4e29dd66b0885fba9428b1c14fb",
  "source_root": "templates/project-operations/godot-live-editor/addons/base_live_editor_adapter",
  "files": {
    "README.md": "actual raw SHA-256",
    "capability_registry.gd": "actual raw SHA-256",
    "editor_state_probe.gd": "actual raw SHA-256",
    "editor_transaction_executor.gd": "actual raw SHA-256",
    "evidence_writer.gd": "actual raw SHA-256",
    "operation_ledger.gd": "actual raw SHA-256",
    "plugin.cfg": "actual raw SHA-256",
    "plugin.gd": "actual raw SHA-256",
    "request_queue.gd": "actual raw SHA-256",
    "runtime_contract_guard.gd": "actual raw SHA-256"
  }
}
```

Replace each descriptive string with the generated lowercase 64-character value before commit.

- [ ] **Step 4: Generate and commit `SOURCE_BASELINE.json` from fresh implementation main**

Record the implementation branch base commit, current Git blob SHA and raw file SHA-256 separately:

```json
{
  "repository": "alsdmlals4-eng/Switchy-Express-Cargo-Puzzle",
  "baseline_commit": "the exact implementation-branch parent SHA",
  "project_godot": {
    "path": "project.godot",
    "raw_sha256": "generated lowercase 64-character SHA-256"
  },
  "target_scene": {
    "path": "game/finite/presentation/finite_slice_view.tscn",
    "git_blob_sha": "fresh Git blob SHA from the implementation baseline",
    "raw_sha256": "generated lowercase 64-character SHA-256",
    "target_node": "Board/BoardTitle",
    "original_name": "BoardTitle"
  }
}
```

The generation command reads the branch parent with `git rev-parse HEAD^` for the RED-parent baseline and reads the target blob with `git rev-parse HEAD^:game/finite/presentation/finite_slice_view.tscn`. Abort if the implementation branch is not based on the then-current `main`.

- [ ] **Step 5: Create disabled source Manifest**

Use this invariant:

```json
{
  "schema_version": 2,
  "artifact_role": "GODOT_LIVE_EDITOR_CAPABILITY_MANIFEST",
  "configuration_state": "NOT_CONFIGURED",
  "transport": {
    "kind": "DISABLED",
    "enabled": false,
    "bind_host": null,
    "endpoint_identity": null
  },
  "capabilities": []
}
```

Include the remaining required v2 fields with explicit `NOT_CONFIGURED`, `NOT_RUN`, or `null` values. The source Manifest must fail authorization and must never be rewritten in place by the materializer.

- [ ] **Step 6: Run provenance tests and commit**

Run:

```bash
python tests/python/test_switchy_godot_live_editor_pilot_contract.py -v
```

Expected: provenance and source-baseline tests PASS; materializer, plugin and runner tests remain RED.

Commit:

```bash
git add tools/godot-live-editor-pilot tests/python/test_switchy_godot_live_editor_pilot_contract.py
git commit -m "build: pin Switchy Pilot source provenance"
```

---

### Task 3: Implement Fail-Closed Materialization

**Files:**
- Create: `tools/materialize_switchy_godot_live_editor_pilot.py`
- Modify: `tools/godot-live-editor-pilot/pilot_contract.py`
- Test: `tests/python/test_switchy_godot_live_editor_pilot_contract.py`

**Interfaces:**
- Produces:
  - `materialize(source_root: Path, output: Path) -> MaterializationReport`
  - `MaterializationReport.to_dict() -> dict[str, Any]`
  - CLI: `python tools/materialize_switchy_godot_live_editor_pilot.py --output <absolute-outside-repository-path>`

- [ ] **Step 1: Add failing materializer tests**

Cover these stable error codes:

```python
OUTPUT_INSIDE_REPOSITORY
OUTPUT_ALREADY_EXISTS
SOURCE_BASELINE_MISMATCH
BASE_SNAPSHOT_MISMATCH
SOURCE_MANIFEST_CONFIGURED
SOURCE_PLUGIN_ALREADY_ENABLED
TARGET_SCENE_CONTRACT_MISMATCH
COPY_INTEGRITY_MISMATCH
SOURCE_INTEGRITY_FAILURE
```

Use temporary directories and copy only the minimal repository structure needed by each unit test. Do not mutate the working repository during tests.

- [ ] **Step 2: Implement repository-boundary checks**

Resolve both paths and reject when `output == source_root` or `output.is_relative_to(source_root)`. Also reject an existing output directory. No force or overwrite flag is allowed.

- [ ] **Step 3: Verify source before copying**

The materializer must:

1. validate `BASE_SOURCE.json` against vendored bytes;
2. validate `SOURCE_BASELINE.json` against source bytes;
3. confirm source Manifest is `NOT_CONFIGURED` and disabled;
4. confirm source `project.godot` contains no `[editor_plugins]` entry enabling either Pilot plugin;
5. confirm the target Scene contains exactly one `[node name="BoardTitle" type="Label" parent="Board"]` declaration;
6. capture a full protected inventory.

- [ ] **Step 4: Copy the repository with exact exclusions**

Exclude only:

```python
EXCLUDED_NAMES = {".git", ".godot", "__pycache__", ".pytest_cache"}
EXCLUDED_TOP_LEVEL = {"artifacts"}
```

Do not exclude `game`, `assets`, `기획서`, tests or project tooling.

- [ ] **Step 5: Install temporary addons**

Copy:

```text
tools/godot-live-editor-pilot/vendor/base_live_editor_adapter/
→ <temporary>/addons/base_live_editor_adapter/

tools/godot-live-editor-pilot/pilot_plugin/
→ <temporary>/addons/switchy_live_editor_pilot/
```

Modify only the temporary `project.godot` by appending:

```ini
[editor_plugins]

enabled=PackedStringArray("res://addons/base_live_editor_adapter/plugin.cfg", "res://addons/switchy_live_editor_pilot/plugin.cfg")
```

Abort if the copied file already has `[editor_plugins]`.

- [ ] **Step 6: Generate the configured temporary Manifest**

Write only `<temporary>/GODOT_LIVE_EDITOR_CAPABILITY_MANIFEST.json`. It must contain:

```yaml
schema_version: 2
configuration_state: CONFIGURED
project_identity.normalized_project_path: exact temporary absolute POSIX path
project_identity.project_godot_sha256: SHA-256 of modified temporary project.godot
project_identity.project_fingerprint: SHA-256 of normalized path + newline + project_godot_sha256
engine_compatibility.minimum_version: 4.7.0
engine_compatibility.maximum_exclusive_version: 4.8.0
transport.kind: PROJECT_DEFINED
transport.enabled: true
transport.bind_host: null
transport.endpoint_identity: in-process-editor-plugin
capabilities: [scene.inspect, node.rename]
```

Capability input/output Schemas are closed objects with `additionalProperties: false`. `node.rename` requires approval, preconditions, ledger and `EDITOR_UNDO_REDO` rollback.

- [ ] **Step 7: Verify copy and source integrity**

Before returning, compare:

- source protected inventory before vs after;
- copied protected inventory before addon activation vs source inventory;
- copied target Scene raw SHA-256 vs source target Scene raw SHA-256.

Write `<temporary>/artifacts/godot-live-editor/materialization_report.json` with hashes and no credentials.

- [ ] **Step 8: Run tests and commit**

Run:

```bash
python tests/python/test_switchy_godot_live_editor_pilot_contract.py -v
```

Expected: materializer tests PASS; Runtime plugin and runner tests remain RED or skipped.

Commit:

```bash
git add tools/materialize_switchy_godot_live_editor_pilot.py \
        tools/godot-live-editor-pilot/pilot_contract.py \
        tests/python/test_switchy_godot_live_editor_pilot_contract.py
git commit -m "feat: materialize isolated Switchy editor Pilot"
```

---

### Task 4: Implement the Actual Switchy Editor Pilot Plugin

**Files:**
- Create: `tools/godot-live-editor-pilot/pilot_plugin/plugin.cfg`
- Create: `tools/godot-live-editor-pilot/pilot_plugin/plugin.gd`
- Modify: `tests/python/test_switchy_godot_live_editor_pilot_contract.py`

**Interfaces:**
- Temporary addon path: `res://addons/switchy_live_editor_pilot/`.
- Extends: `res://addons/base_live_editor_adapter/plugin.gd`.
- Writes: `res://artifacts/godot-live-editor/switchy_real_project_pilot_result.json`.

- [ ] **Step 1: Add source-contract tests for the plugin**

Require exact constants:

```gdscript
const TARGET_SCENE := "res://game/finite/presentation/finite_slice_view.tscn"
const TARGET_NODE := NodePath("Board/BoardTitle")
const ORIGINAL_NAME := "BoardTitle"
const DIRTY_NAME := "BoardTitlePilotDirty"
const SAVED_NAME := "BoardTitlePilotSaved"
const BATCH_SIZE := 64
```

Require these result fields in source:

```text
scene_inspect_pass
dirty_rename_pass
dirty_undo_pass
saved_rename_pass
saved_undo_restore_pass
stale_state_block_pass
request_hash_block_pass
expired_approval_block_pass
approval_binding_block_pass
result_hash_pass
queue_capacity_pass
batch_64_pass
temporary_scene_byte_restore_pass
network_listener_enabled
```

- [ ] **Step 2: Implement startup and target validation**

`_enter_tree()` calls `super._enter_tree()` and defers `_run_pilot()`. `_run_pilot()` verifies Editor mode, adapter availability, exact in-process transport, `network_listener_enabled == false`, opens the target Scene and rejects any target mismatch with stable code `TARGET_SCENE_CONTRACT_MISMATCH`.

- [ ] **Step 3: Implement the reversible success sequence**

Execute in this order:

1. `scene.inspect`;
2. rename to `BoardTitlePilotDirty` with `KEEP_DIRTY`;
3. assert dirty state and target name;
4. use the correct object history `UndoRedo` to undo;
5. assert original name;
6. rename to `BoardTitlePilotSaved` with `SAVE_CURRENT_SCENE`;
7. assert result physical SHA-256 equals the temporary Scene bytes;
8. undo the saved mutation;
9. save the Scene again;
10. refresh the filesystem;
11. assert final node name is `BoardTitle` and final temporary Scene raw SHA-256 equals the materialized original SHA-256.

A failure after mutation must still attempt restoration before writing the final result.

- [ ] **Step 4: Implement adversarial rejection cases**

Require exact codes:

```yaml
stale_precondition: TARGET_STATE_CONFLICT
request_payload_tamper: REQUEST_HASH_MISMATCH
expired_approval: APPROVAL_EXPIRED
approval_binding_tamper: APPROVAL_BINDING_MISMATCH
```

For each rejected mutation, assert target name unchanged, target Scene bytes unchanged, no mutation Ledger record and no `EXECUTION_PASS` evidence.

- [ ] **Step 5: Implement bounded queue exercise**

Submit 64 `scene.inspect` requests without awaiting individual completion. The 65th request must return `QUEUE_FULL`. Drain results for at most 124 frames, require all 64 canonical result hashes, record elapsed microseconds and do not impose a performance threshold.

- [ ] **Step 6: Write a canonical bounded result**

The result JSON includes:

```yaml
status: PASS_OR_FAIL
code: stable-code
engine_version: exact string
editor_instance_id: non-empty
all required boolean flags
saved_scene_sha256: 64 lowercase hex or null
original_scene_sha256: 64 lowercase hex
restored_scene_sha256: 64 lowercase hex
ledger_states: [COMPLETED, COMPLETED]
batch_64_completed: 64
batch_64_elapsed_usec: positive integer
network_listener_enabled: false
elapsed_usec: positive integer
production_adapter_ready: false
```

Do not write absolute source paths, tokens or credentials.

- [ ] **Step 7: Run static tests and commit**

Run:

```bash
python tests/python/test_switchy_godot_live_editor_pilot_contract.py -v
```

Commit:

```bash
git add tools/godot-live-editor-pilot/pilot_plugin \
        tests/python/test_switchy_godot_live_editor_pilot_contract.py
git commit -m "feat: add Switchy real-project editor Pilot"
```

---

### Task 5: Implement the Bounded Runner and Regression Gate

**Files:**
- Create: `tools/run_switchy_godot_live_editor_pilot.py`
- Modify: `tools/godot-live-editor-pilot/pilot_contract.py`
- Modify: `tests/python/test_switchy_godot_live_editor_pilot_runtime.py`

**Interfaces:**
- CLI:

```text
python tools/run_switchy_godot_live_editor_pilot.py \
  --godot <path-to-exact-4.7.1-executable> \
  --report <json-report-path> \
  [--preserve-failure]
```

- Exit codes:
  - `0`: complete PASS or `SKIPPED_NOT_CONFIGURED` when no Godot path is supplied;
  - `1`: contract, Runtime, regression or integrity failure;
  - `2`: timeout.

- [ ] **Step 1: Add failing runner tests**

Cover:

```text
GODOT_BIN_REQUIRED
GODOT_BIN_NOT_FOUND
GODOT_VERSION_MISMATCH
MATERIALIZATION_FAILED
RUNTIME_TIMEOUT
RUNTIME_RESULT_MISSING
RUNTIME_RESULT_INVALID
PROJECT_REGRESSION_FAILED
SOURCE_INTEGRITY_FAILURE
```

Mock subprocess calls for unit cases. The actual Runtime test remains guarded by `GODOT_BIN`.

- [ ] **Step 2: Implement Godot identity verification**

Run `<godot> --version` with a 30-second timeout, require substring `4.7.1`, and record executable SHA-256. Reject 4.7.0, 4.8.x and custom strings without `4.7.1`.

- [ ] **Step 3: Materialize a fresh temporary copy**

Use `tempfile.TemporaryDirectory(prefix="switchy-live-editor-pilot-")` outside the repository. Invoke the materializer as a Python function, not a shell string. Capture materialization duration.

- [ ] **Step 4: Run the Editor Pilot**

Run:

```bash
<godot> --editor --headless --path <temporary-copy> --quit-after 900
```

Use a 240-second subprocess timeout. Capture stdout and stderr. Any `SCRIPT ERROR:` or standalone `ERROR:` line is failure even when exit status is zero.

- [ ] **Step 5: Validate the Runtime result**

Load `artifacts/godot-live-editor/switchy_real_project_pilot_result.json`. Require every Runtime flag defined in Task 1, exact failure codes for adversarial cases, 64 completed batch results, disabled network listener and restored temporary Scene bytes.

- [ ] **Step 6: Run existing project regression after restoration**

Run:

```bash
<godot> --headless --path <temporary-copy> --script res://tests/run_tests.gd
```

Use a 60-second timeout. Parse:

```regex
TEST SUMMARY: cases=(?P<cases>\d+) failed=(?P<failed>\d+) assertions=(?P<assertions>\d+)
```

Require exit code 0, `failed == 0`, and no Godot error markers. Record the discovered current case/assertion counts rather than hard-coding the historical `9 / 6915` value.

- [ ] **Step 7: Rehash source protected paths**

Compare the current source protected inventory against the pre-run inventory. Any difference overrides all other results with `SOURCE_INTEGRITY_FAILURE`.

- [ ] **Step 8: Write consolidated report and clean up**

Report fields:

```yaml
status
code
source_commit
base_adapter_commit
godot_version
godot_executable_sha256
materialization
editor_runtime
project_regression
protected_source_integrity
performance_measurement
limitations
production_adapter_ready: false
```

Delete the temporary copy in `finally`. Preserve it only on failure when `--preserve-failure` is explicitly supplied.

- [ ] **Step 9: Run unit/skip tests and commit**

Run:

```bash
python tests/python/test_switchy_godot_live_editor_pilot_contract.py -v
python tests/python/test_switchy_godot_live_editor_pilot_runtime.py -v
```

Expected without `GODOT_BIN`: static PASS, skip-contract PASS, actual Runtime SKIPPED_NOT_CONFIGURED.

Commit:

```bash
git add tools/run_switchy_godot_live_editor_pilot.py \
        tools/godot-live-editor-pilot/pilot_contract.py \
        tests/python/test_switchy_godot_live_editor_pilot_runtime.py
git commit -m "feat: run isolated Switchy editor Pilot"
```

---

### Task 6: Wire Exact Godot Runtime into CI

**Files:**
- Modify: `.github/workflows/godot-tests.yml`
- Test: `tests/python/test_switchy_godot_live_editor_pilot_contract.py`

**Interfaces:**
- Consumes the same downloaded `Godot_v4.7.1-stable_linux.x86_64` executable already used by existing tests.
- Produces artifact `switchy-godot-live-editor-pilot-report` containing one JSON report.

- [ ] **Step 1: Add workflow contract assertions**

Static tests require the workflow to contain:

```text
run_switchy_godot_live_editor_pilot.py
--godot ./Godot_v4.7.1-stable_linux.x86_64
actions/upload-artifact@v4
switchy-godot-live-editor-pilot-report
```

Also require the existing `res://tests/run_tests.gd` step to remain present and earlier than the Pilot step.

- [ ] **Step 2: Add the actual Pilot step**

After the existing headless project tests, add:

```yaml
      - name: Run Switchy real-project live-editor Pilot
        run: |
          mkdir -p artifacts/godot-live-editor-ci
          python tools/run_switchy_godot_live_editor_pilot.py \
            --godot ./Godot_v4.7.1-stable_linux.x86_64 \
            --report artifacts/godot-live-editor-ci/switchy-pilot-report.json
```

- [ ] **Step 3: Upload the bounded report**

Add:

```yaml
      - name: Upload Switchy live-editor Pilot report
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: switchy-godot-live-editor-pilot-report
          path: artifacts/godot-live-editor-ci/switchy-pilot-report.json
          if-no-files-found: error
```

Do not upload the temporary project, ledgers, `.godot` cache or user paths.

- [ ] **Step 4: Run static workflow checks and commit**

Run:

```bash
python tests/python/test_switchy_godot_live_editor_pilot_contract.py -v
git diff --check
```

Commit:

```bash
git add .github/workflows/godot-tests.yml \
        tests/python/test_switchy_godot_live_editor_pilot_contract.py
git commit -m "ci: run Switchy live-editor Pilot"
```

---

### Task 7: Execute GREEN Runtime, Record Evidence and Adversarial Review

**Files:**
- Create: `tools/godot-live-editor-pilot/README.md`
- Create: `docs/evidence/godot-live-editor/2026-08-06-switchy-real-project-pilot.md`
- Modify only when required by verified findings: Pilot tooling and its tests.

**Interfaces:**
- Consumes exact implementation HEAD and exact Godot 4.7.1 executable.
- Produces reviewable evidence without machine-specific absolute paths.

- [ ] **Step 1: Run the full local verification set**

Run:

```bash
python tools/validate_project_contract.py
python -m unittest tests.test_base_v94_ai_operations_adoption -v
python tests/python/test_android_smoke_canonical_freshness_contract.py -v
python tests/python/test_switchy_godot_live_editor_pilot_contract.py -v
python tests/python/test_switchy_godot_live_editor_pilot_runtime.py -v
<GODOT_BIN> --headless --path . --script res://tests/run_tests.gd
python tools/run_switchy_godot_live_editor_pilot.py \
  --godot <GODOT_BIN> \
  --report /tmp/switchy-pilot-report.json
git diff --check
```

Replace `<GODOT_BIN>` with the exact executable path in the command invocation; do not write the absolute path into committed evidence.

- [ ] **Step 2: Verify protected source paths are absent from the PR diff**

Run:

```bash
git diff --name-only origin/main...HEAD
```

Fail review if any result equals `project.godot` or starts with `game/`, `assets/`, `기획서/`, or `skills/PROJECT_BASE_ADAPTER.json`.

- [ ] **Step 3: Perform adversarial review**

Attack these cases manually and through tests:

- output path symlink or path traversal;
- changed target Scene bytes after baseline capture;
- missing `Board/BoardTitle`;
- source Manifest accidentally configured;
- source project already enabling a Pilot addon;
- Base vendor file altered without provenance update;
- Godot 4.7.0 and 4.8 version rejection;
- Editor exit 0 with script error text;
- Runtime timeout with no result;
- mutation succeeds but restoration fails;
- regression suite passes while source inventory changed;
- 65th request accepted;
- failed approval request creates Ledger or evidence;
- report leaks source absolute path.

Every finding is either fixed with a new RED→GREEN regression or recorded as an explicit non-production limitation.

- [ ] **Step 4: Write README and bounded evidence**

README documents commands, stable codes, recovery and cleanup. Evidence records:

```yaml
implementation_head
implementation_base_main
godot_version
godot_executable_sha256
source_target_scene_git_blob_sha
source_target_scene_raw_sha256
runtime_flags
adversarial_codes
batch_64_elapsed_usec
project_regression_case_count
project_regression_assertion_count
protected_source_integrity
exact_head_ci
windows_runtime: NOT_RUN
android_device: NOT_RUN
physical_input: NOT_RUN
human_usability: HUMAN_NOT_RUN
production_adapter_ready: false
```

- [ ] **Step 5: Commit evidence closure**

```bash
git add tools/godot-live-editor-pilot/README.md \
        docs/evidence/godot-live-editor/2026-08-06-switchy-real-project-pilot.md \
        tests/python \
        tools/godot-live-editor-pilot \
        tools/materialize_switchy_godot_live_editor_pilot.py \
        tools/run_switchy_godot_live_editor_pilot.py
git commit -m "docs: record Switchy live-editor Pilot evidence"
```

---

### Task 8: Draft PR Completion and Exact-HEAD Gate

**Files:**
- No new product files.
- PR body and review evidence only after code is final.

**Interfaces:**
- Produces one independent Draft implementation PR from fresh `main`.

- [ ] **Step 1: Open the implementation Draft PR**

The PR body must state:

```yaml
design_pr: 82
protected_source_changed: false
production_installation: false
actual_godot_runtime: PASS_OR_NOT_RUN
project_regression: PASS_OR_NOT_RUN
source_integrity: PASS_OR_NOT_RUN
windows_runtime: NOT_RUN
android_device: NOT_RUN
human_usability: HUMAN_NOT_RUN
production_adapter_ready: false
merge_authorization: NOT_GRANTED
```

- [ ] **Step 2: Wait for all exact-HEAD workflows**

Required workflows include at least:

- Project Contract
- Godot Tests
- existing Base adapter adoption checks
- any additional pull-request workflows triggered by the changed paths

Any HEAD change requires rerunning all checks.

- [ ] **Step 3: Validate PR scope and review threads**

Require:

```yaml
unresolved_review_threads: 0
mergeable: true
protected_paths_in_diff: 0
runtime_artifact_available: true
static_red_commit_preserved: true
exact_head_ci: PASS
```

- [ ] **Step 4: Submit final adversarial review**

Record `MUST_FIX: 0` only when Runtime, regression, source integrity and exact-head CI all pass. Keep the PR Draft until that review is recorded.

- [ ] **Step 5: Stop before merge**

Final state:

```yaml
implementation_pr: DRAFT_OR_READY_FOR_OWNER_DECISION
merge: MERGE_NOT_REQUESTED
production_adapter_ready: false
```

Do not merge, enable auto-merge, modify the Google Sheet, install the addon into the source project, or begin the second-project Pilot without explicit user approval.

---

## Self-Review Result

```yaml
spec_coverage:
  isolated_materialization: covered_task_3
  base_provenance: covered_task_2
  source_raw_sha_pin: covered_task_2
  real_scene_runtime: covered_task_4
  adversarial_runtime: covered_tasks_4_and_7
  bounded_queue: covered_task_4
  existing_regression: covered_task_5
  protected_source_integrity: covered_tasks_3_5_7
  exact_head_ci: covered_tasks_6_and_8
  evidence_boundaries: covered_task_7
  production_non_goals: covered_global_constraints_and_task_8
placeholder_scan: PASS
interface_consistency: PASS
implementation_started: false
implementation_authorization: false
```

## Execution Handoff

After explicit implementation approval, execute this plan inline using `superpowers:executing-plans` on a new implementation branch from the then-current `main`. Use review checkpoints after Tasks 1, 3, 5, 6 and 7. Do not reuse approval or CI evidence after a HEAD change.
