# Switchy Express Godot Live-Editor Real-Project Pilot Design

## Status

```yaml
status: DESIGN_APPROVED
user_approval: current_conversation_2026-08-06T01:46+09:00
implementation: NOT_STARTED
implementation_authorization: NOT_GRANTED
next_gate: WRITTEN_SPEC_USER_REVIEW
repository: alsdmlals4-eng/Switchy-Express-Cargo-Puzzle
baseline_main: ce278d17c536e9cc017c3f9c1bc429deb853a5fc
engine: Godot 4.7.1-stable
base_project_contract: 9.4.3
base_live_editor_source_commit: bd72e61722ebb4e29dd66b0885fba9428b1c14fb
production_adapter_ready: false
```

## Purpose

Base의 강화된 Godot live-editor v2 adapter가 작은 전용 fixture뿐 아니라 실제 Switchy Express 프로젝트 구조에서도 안전하게 동작하는지 검증한다.

이 Pilot의 핵심은 **원본 프로젝트를 직접 수정하지 않는 것**이다. 저장소에는 self-contained Pilot 도구, `NOT_CONFIGURED` source manifest, byte-pinned Base adapter snapshot, 계약 테스트와 증거 문서만 둔다. 실제 Plugin 활성화, configured manifest 생성, Scene mutation, save와 복구는 모두 저장소 밖의 임시 복제본에서만 수행한다.

이 작업은 게임 규칙, 콘텐츠, Scene 설계 또는 제품 구현이 아니다. Google Sheet GDD와 게임 기획 정본을 변경하지 않는다.

## Selected approach

### Isolated materialized real-project Pilot

```text
verified repository source
→ protected-path hash snapshot
→ repository-outside temporary copy
→ exact Base adapter snapshot verification
→ temporary addon installation
→ temporary project.godot plugin activation
→ temporary configured v2 manifest generation
→ actual Switchy Scene Editor transaction Pilot
→ existing project regression tests
→ source protected-path hash readback
→ bounded evidence and cleanup
```

### Rejected alternatives

1. **Direct project integration**
   - 실제성이 가장 높지만 `project.godot`과 `game/**` 보호 경로를 즉시 변경한다.
   - Pilot 단계에서 production adoption과 검증을 혼합하므로 채택하지 않는다.

2. **Standalone synthetic fixture only**
   - 안전하지만 실제 Switchy Scene import, script loading, save와 기존 테스트 호환성을 증명하지 못한다.
   - Base의 기존 격리 fixture와 중복되므로 채택하지 않는다.

## Authority and constraints

### Project authority

- `AGENTS.md`
- `skills/PROJECT_BASE_ADAPTER.json`
- actual repository code, Scene, Resource and tests
- Base live-editor adapter at exact commit `bd72e61722ebb4e29dd66b0885fba9428b1c14fb`

### Protected source paths

The Pilot implementation PR must not modify:

```text
project.godot
game/**
assets/**
기획서/**
```

Runtime execution must also prove that these source paths have identical SHA-256 inventories before and after the Pilot.

### Base version boundary

Switchy remains globally pinned to Base `9.4.3`. This Pilot does not upgrade `skills/PROJECT_BASE_ADAPTER.json` and does not claim adoption of a newer Base release.

The live-editor payload is a Pilot-only, byte-identical snapshot of the adapter at Base commit `bd72e61722ebb4e29dd66b0885fba9428b1c14fb`. It is not a project-owned fork and is never installed under the source project's top-level `addons/` directory.

A provenance manifest must record every vendored path and raw-byte SHA-256. Static tests fail if any vendored file changes without an updated exact Base source commit and complete hash inventory.

## Target Scene and reversible mutation

### Actual project target

```yaml
scene: res://game/finite/presentation/finite_slice_view.tscn
source_git_blob_sha: b400b6f96d37d796033fb8214d500c82fd37c8e9
target_node: Board/BoardTitle
original_name: BoardTitle
```

The Git blob SHA is the approved design-time identity anchor. The implementation plan must compute and record the raw-file SHA-256 from the then-current fresh baseline; the materializer and Runtime use that raw-file SHA-256 rather than treating a Git blob SHA as a file-content SHA-256.

`Board/BoardTitle` is an owned leaf Label in the actual finite-slice UI Scene. The current Scene script does not access this node by path, while operational nodes such as `Board`, `TopBar`, `BuildTools`, `RunTools` and `ResultPanel` are path-addressed and therefore excluded from mutation.

The materializer must fail closed if the source Scene blob or target structure no longer matches this design. It must not silently choose a different node.

### Runtime sequence

1. Open the actual finite-slice UI Scene in the temporary Editor project.
2. Run `scene.inspect` and validate the canonical result hash and evidence.
3. Rename `Board/BoardTitle` to `BoardTitlePilotDirty` with `KEEP_DIRTY`.
4. Confirm dirty state, then perform Editor Undo and confirm the original node name.
5. Rename the same node to `BoardTitlePilotSaved` with `SAVE_CURRENT_SCENE`.
6. Confirm physical temporary Scene byte SHA-256 changed and equals the result evidence.
7. Perform Editor Undo, save the temporary Scene again, refresh the Editor filesystem and confirm the Scene byte SHA-256 returns exactly to the original copied source SHA-256.
8. Confirm the original repository Scene remained byte-identical throughout.

A Runtime PASS requires the temporary project to end with the original target name and original Scene bytes. Leaving the temporary project mutated is a failure even though the directory is disposable.

## Components

### 1. Pilot source package

Proposed root:

```text
tools/godot-live-editor-pilot/
```

It contains:

- `BASE_SOURCE.json`: Base repository, exact commit and per-file SHA-256 inventory.
- `vendor/base_live_editor_adapter/`: exact byte snapshot from Base.
- `GODOT_LIVE_EDITOR_CAPABILITY_MANIFEST.source.json`: `NOT_CONFIGURED`, disabled source template.
- `pilot_plugin/plugin.cfg` and `pilot_plugin/plugin.gd`: test orchestrator only.
- `README.md`: execution, recovery, boundaries and evidence states.

The source package cannot be enabled by the source `project.godot` and cannot open a network listener.

### 2. Materializer

Proposed command:

```text
python tools/materialize_switchy_godot_live_editor_pilot.py --output <outside-repository-path>
```

Responsibilities:

- resolve repository root and reject an output inside it;
- verify exact source `project.godot` and target Scene hashes;
- hash every file under protected source paths;
- copy the repository while excluding `.git/`, `.godot/`, source artifacts, caches and prior temporary output;
- verify the copied protected-path inventory matches the source inventory;
- verify the vendored Base adapter provenance inventory;
- install the adapter and Pilot plugin only into the temporary copy;
- modify only the temporary `project.godot` to enable the Pilot plugin;
- generate a configured v2 manifest with the temporary copy's exact normalized path, `project.godot` SHA-256, project fingerprint and in-process endpoint identity;
- write a machine-readable materialization report.

The source tree is rehashed after materialization. Any source change aborts the run.

### 3. Runtime orchestrator

The temporary Pilot plugin extends the Base adapter and runs only under Editor mode. It must reject normal game/runtime mode.

It performs:

- availability and exact transport-profile checks;
- actual Scene open and target validation;
- success sequence for inspect, dirty rename, Undo, saved rename, saved Undo and byte restoration;
- negative cases;
- bounded queue test;
- evidence consolidation;
- clean Editor shutdown.

### 4. Runner

Proposed command:

```text
python tools/run_switchy_godot_live_editor_pilot.py --godot <exact-4.7.1-executable>
```

It must:

- verify Godot reports `4.7.1`;
- record executable SHA-256;
- create a fresh temporary directory outside the repository;
- call the materializer;
- run Godot `--editor --headless` with bounded timeout;
- parse the Runtime result;
- run the existing project test command in the temporary copy after restoration;
- rehash source protected paths;
- emit a consolidated JSON report;
- delete the temporary copy unless `--preserve-failure` is explicitly supplied.

No hard performance PASS threshold is introduced. Timing is evidence, not a product requirement.

## Security and adversarial cases

The actual Godot Runtime must verify all of the following before this Pilot can pass:

```yaml
stale_precondition: TARGET_STATE_CONFLICT
request_payload_tamper: REQUEST_HASH_MISMATCH
expired_approval: APPROVAL_EXPIRED
approval_binding_tamper: APPROVAL_BINDING_MISMATCH
queue_capacity: 64
request_65: QUEUE_FULL
network_listener_enabled: false
```

For every rejected mutation request:

- target node name remains unchanged;
- no mutation ledger entry is created;
- no Scene bytes are changed;
- no evidence claims `EXECUTION_PASS`.

The Pilot must also reject:

- wrong Godot version;
- changed Base snapshot bytes;
- changed source target Scene hash;
- missing target node;
- output directory within the repository;
- source manifest already configured;
- source `project.godot` already enabling either Pilot addon;
- Runtime result lacking canonical result hashes or RFC 3339 timestamps.

## Testing strategy

### Static TDD gate

A test-only RED commit precedes implementation. It requires the intended files and contracts before they exist.

Static tests cover:

- source manifest is `NOT_CONFIGURED` and transport-disabled;
- source `project.godot` does not enable the adapter or Pilot plugin;
- Base provenance inventory is complete and exact;
- materializer refuses in-repository output;
- protected source path inventory is stable;
- target Scene and node contract is exact;
- no product or planning protected paths are changed by the PR;
- Runner reports Runtime as `SKIPPED_NOT_CONFIGURED` when `GODOT_BIN` is absent rather than claiming PASS.

### Actual Godot Runtime

Required executable:

```text
Godot 4.7.1 stable
```

Runtime assertions:

- actual Switchy Scene imports and opens;
- inspect and both rename modes work;
- Editor Undo works after dirty and saved mutation;
- final temporary Scene bytes equal original source bytes;
- canonical request/result hashes validate;
- stale/hash/approval adversarial cases are blocked;
- 64-request read-only batch completes and request 65 is rejected;
- network listener remains disabled;
- operation/evidence ledgers are complete and bounded;
- source protected paths remain byte-identical;
- existing project contract tests pass after Pilot restoration.

### Existing project regression

The Pilot must not count its own success as product behavior success. After the temporary Scene is restored, run the repository's existing Godot test suite:

```text
godot --headless --path <temporary-copy> --script res://tests/run_tests.gd
```

The baseline record is `9 cases / 6915 assertions / 0 failures`; the implementation plan must first discover the current expected count and use the current repository result as authority.

## Evidence model

The implementation PR may add a bounded evidence document under:

```text
docs/evidence/godot-live-editor/
```

Required states remain separated:

```yaml
contract_validation: PASS_OR_FAIL
materialization: PASS_OR_FAIL
editor_runtime: PASS_OR_FAIL
project_regression: PASS_OR_FAIL
protected_source_integrity: PASS_OR_FAIL
performance_measurement: MEASURED_NOT_GENERALIZED
windows_runtime: NOT_RUN
android_device: NOT_RUN
physical_input: NOT_RUN
human_usability: HUMAN_NOT_RUN
production_adapter_ready: NOT_READY
```

Generated temporary project files and runtime ledgers are not committed. The checked-in evidence document records hashes, command lines, result summaries and explicit limitations without embedding machine-specific absolute paths or credentials.

## Performance boundary

Metrics recorded:

- source repository copy duration;
- Editor startup duration;
- inspect duration;
- dirty rename/Undo duration;
- saved rename/Undo/save restoration duration;
- 64-request batch duration and throughput;
- target Scene byte size;
- evidence and ledger byte sizes.

No result from this one Scene is generalized to all Switchy Scenes or Android runtime performance. The Pilot runs in the Editor and provides no Android device or physical-input evidence.

## Error handling and cleanup

- All checks fail closed with stable machine-readable codes.
- A Runtime timeout is `RUNTIME_TIMEOUT`, not PASS.
- Missing Godot is `SKIPPED_NOT_CONFIGURED`, not failure and not PASS.
- Cleanup runs in `finally` after result capture.
- Temporary output is preserved only with explicit `--preserve-failure` and its path is not committed.
- If source protected hashes differ after any phase, the final verdict is `SOURCE_INTEGRITY_FAILURE` regardless of other successes.
- The runner never attempts to repair or reset the source working tree.

## Definition of Ready for implementation

Implementation may begin only when all are true:

```yaml
written_design_reviewed_by_user: true
implementation_plan_committed: true
implementation_plan_approved_by_user: true
fresh_main_sha_recorded: true
base_adapter_commit_pinned: true
protected_paths_unchanged_in_planned_diff: true
runtime_target_scene_and_node_pinned: true
no_other_conflicting_open_implementation_pr: true
```

The open design/plan PR for this same Pilot is not considered a conflicting implementation PR.

## Definition of Done for Pilot PR

```yaml
static_red_then_green_history: REQUIRED
exact_head_project_ci: PASS
actual_godot_4_7_1_runtime: PASS
source_protected_integrity: PASS
temporary_scene_restored_byte_exact: PASS
existing_project_regression: PASS
unresolved_review_threads: 0
project_godot_source_changed: false
game_source_changed: false
planning_source_changed: false
google_sheet_changed: false
production_adoption: NOT_PERFORMED
production_adapter_ready: false
```

## Explicit non-goals

- production Plugin installation in Switchy;
- global Base version upgrade;
- external transport, MCP, HTTP or WebSocket;
- Runtime debugger integration;
- game rules, UI, balance, content or save changes;
- Android build or device smoke;
- physical input or human usability validation;
- second-project Pilot;
- production readiness declaration.

## Follow-up sequence

After this design receives written-spec approval:

1. write a detailed TDD implementation plan;
2. obtain separate implementation approval;
3. implement on a fresh branch from then-current `main`;
4. complete exact-head CI and actual Godot Runtime Pilot;
5. submit a Draft PR with evidence and adversarial review;
6. decide whether a second structurally different project Pilot is warranted;
7. only after both Pilots decide whether production adoption or external transport should be designed.
