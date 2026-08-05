# Switchy Godot Live-Editor Real-Project Pilot Evidence

## Verdict

```yaml
status: PASS
code: OK
runtime_evidence_head: 1984d8b708c6a51a189d45db1c2b604f7d076e15
design_plan_pr: 82
implementation_pr: 85
source_baseline_commit: 925f27909170c5f120df2bcf80943c4ece0f3890
base_adapter_commit: bd72e61722ebb4e29dd66b0885fba9428b1c14fb
production_adapter_ready: false
```

The Runtime evidence was produced by GitHub Actions `Godot Tests` run `31054694053` from the exact Runtime implementation head above. Later documentation-only HEADs must rerun exact-head CI, but do not retroactively change this recorded Runtime artifact.

## Scope

This Pilot validates a disposable full-project copy of Switchy Express. It does not install the addon into the source project and does not change product code, Scenes, data, planning canon or the global Base project pin.

```yaml
actual_scene: res://game/finite/presentation/finite_slice_view.tscn
actual_node: Board/BoardTitle
source_target_scene_git_blob_sha: b400b6f96d37d796033fb8214d500c82fd37c8e9
source_target_scene_raw_sha256: c5f69f957b462a916d424f4487bfc6025901b9254a5425623619952562623f62
source_target_scene_bytes: 7222
protected_source_file_count: 120
source_integrity: PASS
```

## Godot identity

```yaml
godot_version: 4.7.1.stable.official.a13da4feb
godot_executable_sha256: 32f8d7596c4b41185512b1c49d69f2da3be018fd784a53e349fa92a98a97bcde
platform: GitHub-hosted Ubuntu headless Editor
network_listener_enabled: false
```

## Materialization

```yaml
status: PASS
duration_usec: 186811
temporary_project_godot_sha256: b1eeec74dd2d566267fbe681b730835700cad78292d20a0d0da9e21ac57ddef2
temporary_target_scene_sha256: c5f69f957b462a916d424f4487bfc6025901b9254a5425623619952562623f62
temporary_project_fingerprint: fe0a1f125627f93c1f6caa73d44734b8fadf394a92af02ff307831b3e8c9463c
```

The materializer validated the Base byte inventory, source baseline, disabled source Manifest, absent source plugin activation, exact target declaration, copied protected inventory and post-copy source inventory.

## Actual Editor transaction results

```yaml
scene_inspect: PASS
keep_dirty_rename: PASS
dirty_undo: PASS
save_current_scene_rename: PASS
saved_undo_restore: PASS
canonical_result_hash: PASS
ledger_states: [COMPLETED, COMPLETED]
```

The saved mutation changed the temporary Scene bytes:

```yaml
original_scene_sha256: c5f69f957b462a916d424f4487bfc6025901b9254a5425623619952562623f62
saved_mutated_scene_sha256: 4050afc3288a5310c8432b58f3ef69122a591035641c07bdef7856a191cca231
restored_scene_sha256: c5f69f957b462a916d424f4487bfc6025901b9254a5425623619952562623f62
restore_code: TEMPORARY_RESTORE_BYTE_WRITE
final_restore_code: FINAL_REOPENED_FROM_ORIGINAL_BYTES
temporary_scene_byte_restore: PASS
```

Godot semantic Undo restored the node name but reserialized the Scene differently. The Pilot therefore rewrote only the pinned temporary Scene with bytes captured before activation, refreshed the Editor filesystem, reopened the Scene and revalidated the original node name and SHA-256. The source repository was never written.

## Adversarial Runtime cases

```yaml
stale_precondition:
  status: PASS
  code: TARGET_STATE_CONFLICT
request_payload_tamper:
  status: PASS
  code: REQUEST_HASH_MISMATCH
expired_approval:
  status: PASS
  code: APPROVAL_EXPIRED
approval_binding_tamper:
  status: PASS
  code: APPROVAL_BINDING_MISMATCH
```

Rejected mutation requests produced no requested node change, no mutation Ledger record and no execution-pass evidence.

## Queue and efficiency evidence

The Pilot waited for the Editor filesystem scan to finish and required 30 consecutive identical Scene observations before starting the batch.

```yaml
stable_observation: PASS
batch_observation_revision: "1:1"
queue_capacity: 64
request_65: QUEUE_FULL
batch_64_completed: 64
batch_failure_codes: []
batch_64_elapsed_usec: 448518
batch_64_throughput_ops_per_second: 142.69
pilot_elapsed_usec: 900969
editor_process_wall_usec: 6584360
```

These measurements include one-request-per-Editor-frame execution and evidence generation for one Switchy UI Scene. They are not generalized to all project Scenes or production workloads.

## Existing project regression

The existing project suite ran after exact temporary Scene restoration.

```yaml
status: PASS
cases: 65
failed: 0
assertions: 10792
duration_usec: 4252143
```

## Headless renderer observation

Two instances of this exact Godot dummy-renderer thumbnail error were observed during Scene save:

```text
ERROR: Parameter "t" is null.
at: texture_2d_get (./servers/rendering/dummy/storage/texture_storage.h:110)
```

```yaml
headless_dummy_thumbnail_errors_observed: 2
classification: KNOWN_EXACT_GODOT_DUMMY_RENDERER_SAVE_THUMBNAIL_ERROR_ONLY
unexpected_error_markers: 0
script_errors: 0
```

Only the exact message/location pair is classified separately. It was accepted only after Runtime JSON, exact byte restoration, adversarial cases, queue behavior, existing regression and source integrity all passed. Other `ERROR:` and all `SCRIPT ERROR:` output remain fatal.

## TDD and adversarial history

```yaml
initial_test_only_red_commit: cb5cb3dd0d1fb35685141347c6d2e95cee8fe907
initial_static_red: 7_expected_failures
materializer_red: OBSERVED
plugin_contract_red: OBSERVED
runner_contract_red: OBSERVED
headless_error_classifier_red: OBSERVED
exact_byte_restore_red: OBSERVED
batch_stability_red: OBSERVED
```

Important failures found before GREEN:

- required Pilot files were absent;
- Git blob SHA could have been confused with raw file SHA-256;
- direct in-repository output and source/plugin misconfiguration needed fail-closed codes;
- headless Scene saves emitted a narrow dummy-renderer thumbnail error;
- semantic Undo and save did not restore byte-identical `.tscn` serialization;
- Editor root was briefly unavailable after external byte restoration;
- Undo/Redo revision changed after a short quiet period, causing 47 of 64 concurrent read-only requests to be correctly rejected as stale;
- a 30-frame scan-free stable observation window was required before the bounded batch.

## Relation to Base C0

The repository also adopts the Base C0 reusable multi-project Pilot. The layers are distinct:

```yaml
base_c0:
  main_scene: read_only
  mutation_target: runner_owned_scratch_scene
switchy_deep_pilot:
  main_scene: actual_switchy_scene
  mutation_target: approved_leaf_node_in_disposable_full_project_copy
```

The Base C0 adoption files remain main-owned and unchanged by this deep-Pilot diff.

## Unverified boundaries

```yaml
windows_runtime: NOT_RUN
android_device: NOT_RUN
physical_input: NOT_RUN
human_usability: HUMAN_NOT_RUN
external_transport: NOT_IMPLEMENTED
mcp_profile: NOT_IMPLEMENTED
runtime_debugger: NOT_IMPLEMENTED
production_installation: NOT_PERFORMED
second_structurally_different_project_pilot: NOT_RUN
production_adapter_ready: false
```

## Conclusion

The hardened in-process adapter functioned against one actual Switchy Scene in an isolated Godot 4.7.1 Editor project. It completed reversible mutation, exact byte restoration, adversarial rejection, bounded queue execution, project regression and source-integrity verification. This is real-project Pilot evidence for the internal execution layer, not evidence that a usable MCP server or production adapter is complete.
