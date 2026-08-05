# Godot Live-Editor Pilot Adoption

## Status

```yaml
adoption_mode: TEMPORARY_COPY_ONLY
main_scene_policy: MAIN_SCENE_READ_ONLY
mutation_policy: SCRATCH_SCENE_MUTATION_ONLY
source_integrity: SOURCE_TREE_UNCHANGED
legacy_godot_ai: ABSENT
base_pilot_pin_state: HOTFIX_CANDIDATE_VALIDATION
PRODUCTION_ADAPTER_READY: NOT_READY
```

This repository currently validates Base Pilot hotfix candidate `2b2c7c6cbd2d700a0737b97ac12397329eddc6f3` in an isolated real-project Pilot. This is not the final adoption pin. After the Base hotfix is approved and squash-merged, all four adoption files must be updated to the resulting immutable merge commit and the Pilot must run again.

The repository does not permanently install the Base editor addon into the product project.

## What the Pilot does

The reusable workflow checks out the exact pinned Base commit, verifies the closed project descriptor, copies this repository into a disposable workspace, and runs the existing `res://tests/run_tests.gd` behavior check.

It opens the configured main Scene `res://game/main/main.tscn` only for inspection under `MAIN_SCENE_READ_ONLY`. Rename, Editor Undo, save, ledger recording, and physical SHA-256 verification occur only in the runner-owned `res://.godot-live-editor-pilot/scratch.tscn` under `SCRATCH_SCENE_MUTATION_ONLY`.

The workflow inventories Git-tracked source bytes before and after execution. Any difference violates `SOURCE_TREE_UNCHANGED` and fails the Pilot.

## Evidence and physical hashes

The uploaded bounded evidence records the exact repository commit, exact Base commit, source inventory digests, main Scene inspection result, scratch Scene operation results, ledger state, network-listener state, and physical SHA-256 values recomputed from saved bytes.

A GitHub Actions artifact is review evidence with limited retention. It is not itself a production-readiness declaration. The final post-merge `main` artifact must later be physically reverified before Base C1 can promote its bounded result.

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
