# Hera Repo Adoption + CI Recovery Design

**Decision:** `SX-DEC-052` same-ID reconciliation  
**Audit:** `SX-AUD-039`  
**Date:** 2026-08-09 KST  
**Baseline main:** `0a2bfc0f11e77ddaa09c5c45a83599c745375789`  
**Base:** `2a6ced23f6d6de1fb6e0a281c7138beb03f1a13b`

## Context

The user previously approved Hera/GUT as enabled local tooling. After `SX-AUD-038` backlog reconciliation merged, user-side commit `614fbdce2b1517b8ef34eadb156bf058ecf59b1d` (`Enable Hera and GitHub tracking`) was merged with project main into `0a2bfc0f11e77ddaa09c5c45a83599c745375789`.

That concurrent change intentionally:

- tracks `addons/hera_agent_godot/`;
- enables Hera in `project.godot`;
- persists `HeraGameInspector` as an autoload;
- keeps Godot AI 3.1.3 and GUT enabled.

The project Hera addon tree SHA is `6cb87ac8ba768de1d924447f385fba6d80bcde68`, exactly equal to official upstream `NotNull92/hera-agent-godot` tag `v1.0.0` commit `10f245ddae9e7a5d569150302acbde0d78f2aa03`. The user adoption therefore begins from exact upstream v1.0.0 addon bytes.

The old `SX-DEC-052` authority still says Hera is repo-untracked, so GitHub and the Sheet are stale relative to current main.

## Reproduced regressions on `0a2bfc0f...`

All four main push gates became red after the concurrent adoption.

### Pilot/adoption contract

The adoption test still expects only Godot AI + GUT in `project.godot`, while Hera is now enabled. The Pilot source baseline also pins the pre-Hera `project.godot` hash.

### Godot direct headless tests

All 92 cases / 11,494 assertions complete with `failed=0`, but startup emits:

- unresolved clean-checkout `HeraGameInspector` autoload from the persisted `uid://...` form;
- `ERROR` lines that the workflow correctly treats as fatal.

### GUT/import path

Hera v1.0.0 starts its localhost editor server during a headless import. The process later reports leaked `ObjectDB` instances/resources. The project workflow correctly rejects emitted `ERROR` lines before GUT executes.

Upstream v1.0.0 deliberately supports a separate live nonvisual editor tier under Xvfb; it does not expose a project setting that suppresses the EditorPlugin server for arbitrary `DisplayServer=headless` import/test commands. The project needs a bounded compatibility boundary for its stricter headless contract.

## Options considered

### A. Disable Hera in `project.godot`

Rejected. It would reverse the user-approved user-side adoption and contradict the explicit `Enable Hera and GitHub tracking` commit.

### B. Strip/disable Hera only inside CI workflows

Rejected. CI would no longer exercise the committed project configuration. It would also spread tool-specific mutation logic across multiple workflows.

### C. Preserve Hera enabled and add one explicit project compatibility patch

**Selected.** Keep the exact v1.0.0 vendor as provenance baseline, then maintain one documented patch in `hera_agent_plugin.gd`: return before editor UI/server/autoload setup when `DisplayServer.get_name() == "headless"`.

For normal GUI/Xvfb editor sessions, Hera remains enabled and behaves as upstream v1.0.0. For the project's strict `--headless` import/script test tiers, Hera stays inert and cannot create a localhost server, heartbeat, UI state, or injected autoload during that process.

## Project configuration normalization

The committed `HeraGameInspector` autoload is normalized from the UID form to:

`HeraGameInspector="*res://addons/hera_agent_godot/runtime/game_inspector.gd"`

Rationale:

- the upstream `.uid` file is present, but direct clean-checkout `--headless --script` can resolve autoloads before the imported UID cache exists;
- a direct `res://` autoload path is stable on a clean clone and keeps the same runtime script identity;
- this is a tooling configuration normalization, not a gameplay/Scene/Resource/Theme change.

Hera remains listed in `[editor_plugins]` with Godot AI and GUT.

## Authority model after recovery

`SX-DEC-052` is amended under the same Decision ID:

- Godot AI: repo `3.1.3`, enabled/approved;
- GUT: repo `9.7.1`, enabled/approved;
- Hera: repo tracked/enabled, upstream base `v1.0.0`, user adopted/approved;
- Hera provenance: exact upstream v1.0.0 addon tree before the project headless compatibility patch;
- Hera local physical editor version is not independently re-read by this remote session, but the user-authored tracked repo version is verified as 1.0.0;
- `.asset-vault` 14-file preservation/untrack gate remains unchanged.

A new audit `SX-AUD-039` records the concurrent user adoption, initial RED main, upstream parity proof, project compatibility patch, and final evidence.

## TDD contract

A focused Python contract is added/extended before implementation to require:

1. Hera exists at repo version `1.0.0` and is enabled in `project.godot`.
2. Tooling authority state records `repo_tracked=true`, `repo_version=1.0.0`, upstream tag/commit/tree, and the project compatibility patch.
3. `HeraGameInspector` uses the clean-clone `res://` autoload path.
4. `hera_agent_plugin.gd` contains an early headless return before `_create_main_screen()`, `_ensure_game_autoload()`, or `_server.start(...)` can execute.
5. Existing Godot AI/GUT and asset-vault containment contracts remain unchanged.

The current red main CI is retained as integration RED evidence; the focused test provides a deterministic regression contract for the desired recovered state.

## Two-phase Pilot recovery

The Pilot adoption workflow intentionally allows only its four adoption-surface files on PRs. That protection will not be weakened.

### Phase 1 — tooling/product compatibility recovery

One PR from `0a2bfc0f...` changes only bounded tooling/config/authority surfaces:

- Hera plugin one-file compatibility patch;
- `project.godot` autoload normalization;
- local-tooling focused test/state/Decision/audit/spec/plan;
- `tools/godot-live-editor-pilot/SOURCE_BASELINE.json` refreshed to the final normalized `project.godot` bytes;
- carry forward the already-applied `SX-AUD-038` closure facts.

Required exact test-merge evidence: Project Contract, GUT, Godot Tests, Thin Adapter, plus any automatically triggered export/adapter gates. The PR does not alter gameplay or product assets.

### Phase 2 — Pilot adoption-surface reconciliation

Immediately after Phase 1 merge, a separate PR changes only the Pilot adoption surface:

- `.godot-live-editor/project-pilot.json` adds Hera to `legacy_editor_plugins` and `HeraGameInspector` to `legacy_autoloads`;
- `tests/test_godot_live_editor_adoption.py` expects the three enabled plugins and both autoloads;
- adoption documentation is updated if required;
- workflow semantics stay unchanged.

This preserves the existing `changed_paths <= adoption surface` guard while allowing the Pilot temporary-copy materializer to disable Hera together with the other editor tooling.

Phase 2 exact-head validation must include the dedicated Validate Godot Live-Editor Pilot workflow as well as normal repository gates.

## Error handling / preservation

- Never revert or delete the user-authored Hera vendor tree.
- If current vendor bytes differ from the verified upstream v1.0.0 baseline before the intended one-file patch, stop that subtask and classify the drift rather than overwrite it.
- Do not modify `.asset-vault` tracked bytes.
- Do not claim physical Hera connectivity from CI/headless evidence.
- If Hera normal GUI behavior is later reported broken, the project compatibility patch is isolated to one file and can be removed/reworked without touching the rest of the vendor tree.

## Success criteria

Recovery is complete only when:

- current main preserves Hera tracked + enabled;
- headless/import tests no longer start the Hera server or emit Hera-induced errors;
- direct Godot headless tests do not emit the invalid Hera autoload error;
- Project Contract/GUT/Godot/Thin pass on exact test-merge;
- Pilot adoption surface is reconciled and its dedicated workflow passes on its own exact test-merge;
- merged-main regression is green;
- `SX-DEC-052`, `SX-AUD-038`, `SX-AUD-039`, Hub, Decision, Audit, and Production Sheet state all agree on final main and Hera tracked state;
- `.asset-vault` untrack remains deferred until local preservation attestation;
- runtime/POC/device/human/product-asset approval remain unclaimed.

## Approval

`[연속작업]` is active. This is an in-scope blocker-recovery design that preserves the user's explicit Hera enable/tracking action rather than expanding product scope. The existing continuous-work approval is therefore inherited for implementation.
