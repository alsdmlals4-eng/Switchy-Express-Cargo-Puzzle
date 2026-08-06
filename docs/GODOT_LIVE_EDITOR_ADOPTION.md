# Godot Live-Editor Pilot Adoption

## Status

```yaml
adoption_mode: TEMPORARY_COPY_ONLY
main_scene_policy: MAIN_SCENE_READ_ONLY
mutation_policy: SCRATCH_SCENE_MUTATION_ONLY
source_integrity: SOURCE_TREE_UNCHANGED
legacy_godot_ai: ABSENT
base_pilot_pin_state: DRAFT_CANDIDATE_EXACT_HEAD
base_pilot_commit: a764dcada13ec69c02bb290794a3979ba981e806
evidence_bundle: SELF_CONTAINED_EVIDENCE_BUNDLE
PRODUCTION_ADAPTER_READY: NOT_READY
```

This Draft PR temporarily pins the exact unmerged Base C0.3 candidate commit `a764dcada13ec69c02bb290794a3979ba981e806`. All four adoption files bind the same candidate SHA. This is real-project validation evidence, not merge authorization or a production release pin.

The repository does not permanently install the Base editor addon into the product project.

## What the Pilot does

The reusable workflow checks out the exact pinned Base candidate and verifies the closed project descriptor. It inventories the immutable source, creates a disposable full-project copy, removes declared legacy mutation authority, and stages the disabled Base and Pilot plugin files before the bounded Godot Editor import and parse.

The existing `res://tests/run_tests.gd` behavior check runs in the same prepared workspace while the staged Pilot remains disabled. Only after project import and the behavior check pass does the runner activate the already imported Pilot and build the configured manifest.

The Pilot matches open Scene paths and roots by index, selects the requested Scene target through `EditorInterface.edit_node()`, and waits until the configured edited Scene path and target Node remain stable for three consecutive editor frames before submitting queued operations. It opens `res://game/main/main.tscn` only for inspection under `MAIN_SCENE_READ_ONLY`. Rename, Editor Undo, save, ledger recording, and physical SHA-256 verification occur only in the runner-owned `res://.godot-live-editor-pilot/scratch.tscn` under `SCRATCH_SCENE_MUTATION_ONLY`.

The workflow inventories Git-tracked source bytes before and after execution. Any difference violates `SOURCE_TREE_UNCHANGED` and fails the Pilot.

## Evidence and physical hashes

The bounded artifact exports a self-contained three-file bundle after a successful Pilot:

```text
project-pilot-evidence.json
runtime-result.json
scratch.tscn
```

Failed runtime verification exposes only bounded fixed diagnostic fields in the failure code. The Pilot binds the first failed operation code into that bounded payload; arbitrary runtime free text is not copied into trusted evidence.

Before the disposable workspace is removed, Base recomputes the runtime-result and saved scratch Scene SHA-256 values, copies the two source files into the artifact bundle, and recomputes their destination hashes. Any source or copied-byte mismatch fails closed with `ARTIFACT_BYTE_HASH_MISMATCH`.

The evidence JSON records the exact repository commit, exact Base commit, source inventory digests, main Scene inspection result, scratch Scene operation results, ledger state, network-listener state, and physical SHA-256 values. A reviewer can independently hash `runtime-result.json` and `scratch.tscn` and compare them with the evidence JSON rather than trusting the recorded values alone.

A GitHub Actions artifact is review evidence with limited retention. It is not itself a production-readiness declaration. After Base C0.3 is approved and merged, this Draft must be repinned to the merged immutable SHA and executed again before project adoption can be considered merge-ready.

## What the Pilot does not do

This adoption does not:

- change `project.godot`, product Scenes, Resources, GDScript, data, inputs, saves, export presets, or Google Sheets;
- install a permanent addon, Autoload, MCP server, socket, HTTP endpoint, WebSocket, or other network listener;
- validate Android-device execution, physical input, accessibility, performance, release readiness, or human usability;
- authorize arbitrary Scene, Node, property, script, shell, or project mutation;
- replace the existing project test or release workflows.

No Android Device Smoke PASS, physical-input PASS, performance PASS, or human-usability PASS is claimed.

## Program B and Program C exclusions

Program B authenticated local STDIO MCP transport is not implemented by this PR. Program C opt-in runtime debugger is also not implemented. Both require independent design, approval, TDD, adversarial review, and merge gates.

## Removal

Rollback is performed by reverting the four adoption files only:

```text
.godot-live-editor/project-pilot.json
docs/GODOT_LIVE_EDITOR_ADOPTION.md
tests/test_godot_live_editor_adoption.py
.github/workflows/validate-godot-live-editor-pilot.yml
```

No product file must be edited to remove this Pilot.
