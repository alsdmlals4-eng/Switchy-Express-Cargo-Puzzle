# GUT 9.7.1 Formal Adoption Specification

## Status

```yaml
spec_id: GUT-SPEC-001
approval_batch_id: GMB-004
decision_id: SX-DEC-044
planning_audit_id: SX-AUD-027
implementation_audit_id: SX-AUD-030
contract: PROJECT_TOTAL_PLANNING_IMPLEMENTATION_AND_DELIVERY_INSTRUCTION_v4.3
state: PHASE_B_EXACT_HEAD_GREEN_MERGE_REVIEW_PENDING
spec_only: false
installation_authorized: true
formal_authority: PR_VALIDATED_NOT_YET_MERGED
implementation_baseline: 281bc7b3aa8d66b8f39547475540ab8fcd88b4c5
validated_head: a556d58abc68aa1b4885a34e806443301bafd7a0
```

GUT 9.7.1 is now exercised as a parallel formal test authority on PR #105. The existing `res://addons/gut` install was not deleted or overwritten. Formal authority is not a merged-main fact until PR #105 passes final review and is merged.

## Pinned source

```yaml
framework: GUT
version: "9.7.1"
canonical_repository: "bitwes/Gut"
source_branch_or_release: "godot_4_7"
pinned_commit_sha: aeb5d4f3f7f0a6c9b5e178876d6c99b791fda605
pinned_addon_tree_sha: 5d6893836af4917ee62b1a395125a7530b1f239d
license: MIT
official_license_path: addons/gut/LICENSE.md
official_license_blob_sha: a38ac231fed3febe257c9e5fc31efb8ec7a39f90
godot_target: "4.7.x"
project_expected_godot: "4.7.1-stable"
plugin_install_path: "res://addons/gut"
```

The exact-head workflow downloads this commit on every run and compares its complete `addons/gut` tree with the project install.

## Existing project reconciliation

```yaml
project_addon_tree_sha: 09d040309bbed0e07420ad72c4aa69cbd0e58190
project_license_matches_official: true
project_plugin_version: "9.7.1"
project_plugin_enabled: true
compared_path_count: 259
exact_byte_match_count: 241
explicit_first_line_load_steps_paths: 17
frozen_binary_divergence_paths: 1
missing_paths: 0
extra_paths: 0
unclassified_source_divergence: 0
vendor_overwrite_performed: false
```

The two trees are not described as byte-identical. Seventeen explicit `.tscn`/`.tres` paths differ only by a first-line `load_steps=<n>` token. `source_code_pro.fnt` is a pre-existing binary divergence accepted only by a frozen local/official SHA-256 and size pair. All GDScript, CLI, license, plugin, `.uid`, configuration, and other paths remain exact-byte requirements. The authoritative path list and hash pair are in `GUT_9_7_1_PHASE_B_VENDOR_MANIFEST.md`.

## Authority and non-overlap

```text
Codex
- production `.gd`, GUT test `.gd`, GUT config, CI, mutation guard and docs.
- does not directly modify `project.godot`, `.tscn`, `.tres`, `.res`, signal, NodePath, owner, autoload, or InputMap.

HiGodot
- sole authoring authority for Scene, Node, Resource, Theme, Animation, signal wiring, and project settings.
- target changes require a HIGODOT_AUTHORING_MANIFEST.

GUT 9.7.1
- formal unit/integration/regression execution and assertion authority for shared production results.
- never edits production files.

CI
- runs exact-head discovery, import, GUT, JUnit, vendor reconciliation, and mutation gates.
- does not auto-fix production files.
```

HiGodot self-diagnostics do not replace the GUT required check. The legacy custom runner remains active during migration and is not counted as a GUT consumer.

## Adopted vendor method

```yaml
vendor_method: PRESERVE_EXISTING_INSTALL_WITH_PINNED_FULL_TREE_RECONCILIATION
integrity_evidence: test-results/gut/vendor-reconciliation.json
license_file_path: addons/gut/LICENSE.md
plugin_enablement_change: NONE
scene_resource_vendor_change: NONE
rollback_authority: PR_HEAD_AND_PINNED_MANIFEST
```

Blind copy, delete, or bulk overwrite is forbidden. Any future exception change requires an explicit manifest update, RED test, exact-head hosted evidence, and HiGodot authority when a Godot-authored asset would change.

## Initial formal consumers

The initial suite contains four GUT scripts and eight tests:

1. RED_STAR one-sided station final success.
2. BLUE_DIAMOND one-sided station final success.
3. exact-limit final delivery SUCCESS priority after unloading.
4. post-limit final delivery FAILURE.
5. switch approach traffic follows its selected exit.
6. both branch directions route reciprocally to the approach.
7. occupied route control rejects input and reports `locked=true`.
8. route-control state round-trips through the overlay snapshot contract.

```yaml
test_root_paths:
  - res://tests/gut/unit
  - res://tests/gut/integration
  - res://tests/gut/regression
test_naming_rules:
  - test_*.gd
minimum_discovered_test_count: 6
validated_test_count: 8
validated_assert_count: 60
```

The regression directory is tracked even before its first dedicated regression script is promoted, so configured discovery never emits a missing-directory framework error.

The following gameplay requirements are intentionally deferred to later production TDD and are not claimed complete by Phase B:

- route-end FAILURE ordering under `SX-DEC-041`;
- direct three-direction route selection and incoming-direction U-turn UI under `SX-DEC-042`.

## Verified configuration and commands

```yaml
gut_config_path: res://.gutconfig.json
junit_artifact: test-results/gut/junit.xml
junit_timestamp: false
production_mutation_guard_paths:
  - project.godot
  - game/
  - scenes/
  - data/
  - assets/ when present
```

Verified command sequence on standard hosted Ubuntu with Godot `4.7.1.stable.official.a13da4feb`:

```text
<Godot-4.7.1> --headless --import --path .
<Godot-4.7.1> --headless --path . --script res://addons/gut/gut_cmdln.gd -gexit
```

The import step is mandatory because GUT global class names must be registered before CLI execution.

## Exact-head evidence

```yaml
validated_head: a556d58abc68aa1b4885a34e806443301bafd7a0
gut_run: 31134358839
godot_tests_run: 31134358827
project_contract_run: 31134358833
thin_adapter_run: 31134358837
gut_version: "9.7.1"
godot_version: "4.7.1"
gut_scripts: 4
gut_tests: 8
gut_passing_tests: 8
gut_asserts: 60
junit_tests: 8
junit_failures: 0
junit_errors: 0
junit_skipped: 0
protected_files_before: 173
protected_files_after: 173
protected_changed: []
protected_added: []
protected_removed: []
```

Artifacts:

- `gut-junit`, artifact `8977314352`;
- `gut-phase-b-evidence`, artifact `8977314810`.

## CI design

The dedicated `GUT 9.7.1 Tests` check runs:

```text
checkout PR merge ref for exact head
→ static contracts and Python compileall
→ install exact Godot 4.7.1
→ download pinned official GUT commit
→ reconcile all 259 vendor paths
→ import Godot class names
→ snapshot protected production paths
→ run GUT CLI
→ reject SCRIPT ERROR, GUT ERROR, generic ERROR, and non-zero framework error summaries
→ validate JUnit minimum/failure/error counts
→ verify protected tree even when GUT fails
→ upload JUnit and diagnostic evidence
```

`Godot Tests`, `Project Contract`, and `Validate Thin Adapter Migration` remain independent exact-head gates.

## Attack-review correction

An earlier diagnostic HEAD executed all eight tests successfully but logged one GUT framework error because `res://tests/gut/regression` did not exist. JUnit reported zero test errors, so the first workflow version could have accepted a false positive. Phase B corrected this by:

- tracking the configured regression directory;
- statically asserting every configured GUT directory exists;
- rejecting `[GUT ERROR]:` lines;
- rejecting a non-zero `Errors` run-summary count;
- rerunning all exact-head gates.

The validated head contains this correction.

## Windows and Android shared-core coverage

GUT validates platform-neutral domain and state transitions. Windows and Android adapter, input, responsive UI, lifecycle, export, and physical-device behavior remain separate gates.

```yaml
windows_execution: HEADLESS_SHARED_CORE_PLUS_EXPORT_AND_RUNTIME_SEPARATE_GATE
android_shared_core_coverage: SAME_GUT_CORE_TESTS_PLUS_ANDROID_DEVICE_ADAPTER_SMOKE
platform_logic_duplication: FORBIDDEN
windows_physical_runtime: NOT_RUN
android_device: NOT_RUN
```

A hosted Windows export check is not evidence of physical Windows runtime behavior.

## HiGodot prerequisites

Scene, Resource, Theme, signal, or project-setting work remains blocked until the pinned HiGodot source and an actual authoring connection are verified and a target manifest is produced. Phase B changed none of those authorities.

## Upgrade process

1. Verify the new official release and Godot compatibility table.
2. Approve a separate Decision/spec change for source commit, tree, license, and exceptions.
3. Run current GUT suite and rollback dry-run at exact HEAD.
4. Do not change the vendor or required check before approval.

## Removal process

1. Approve a separate removal Decision and protected scope.
2. Replace, archive, or remove GUT-only tests.
3. Remove the GUT CI job, report paths, and required check.
4. Use HiGodot for plugin-enablement changes.
5. Remove addon/config references only after residual-search and clean-import evidence.
6. Revalidate production and shared-core regressions.

## Rollback conditions

- pinned source/tree/license cannot be reproduced;
- a vendor path is missing, extra, or outside the explicit exception policy;
- Godot 4.7.1 import or GUT parse fails;
- discovery is below six;
- GUT/JUnit reports a failure, error, or framework error;
- production mutation occurs;
- HiGodot authority is crossed;
- legacy coverage is removed before an explicit migration decision;
- Windows and Android shared-core results diverge.

## Phase gates

```text
GUT_SPEC_MERGED_MAIN_VERIFIED
→ GUT_INSTALLATION_AUTHORIZED
→ PHASE_B_IMPLEMENTATION_PR_OPEN
→ PHASE_B_EXACT_HEAD_GREEN
→ PHASE_B_ATTACK_REVIEW_COMPLETE
→ PHASE_B_MERGED_MAIN_VERIFIED
```

Current state is `PHASE_B_EXACT_HEAD_GREEN_MERGE_REVIEW_PENDING`; merged-main verification and Sheet post-merge synchronization remain open.
