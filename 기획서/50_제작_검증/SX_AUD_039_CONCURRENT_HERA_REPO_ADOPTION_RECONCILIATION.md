# SX-AUD-039 · Concurrent Hera Repo Adoption Reconciliation

**Date:** 2026-08-09 KST  
**Decision:** `SX-DEC-052` same-ID reconciliation  
**Concurrent main baseline:** `0a2bfc0f11e77ddaa09c5c45a83599c745375789`  
**User adoption commit:** `614fbdce2b1517b8ef34eadb156bf058ecf59b1d`  
**Base:** `2a6ced23f6d6de1fb6e0a281c7138beb03f1a13b`  
**Status:** `PHASE1_IMPLEMENTED · FINAL_HEAD_RECHECK_REQUIRED · PHASE2_PILOT_ADOPTION_SURFACE_PENDING`

## Trigger

During `SX-AUD-038` docs-only closure preparation, project `main` advanced from `c9dc1f0105d69a18dd600480d6e73e439c03c101` to `0a2bfc0f11e77ddaa09c5c45a83599c745375789`.

The new main merged the user-authored commit:

`614fbdce2b1517b8ef34eadb156bf058ecf59b1d · Enable Hera and GitHub tracking`

with the backlog-reconciliation main.

The change is treated as user work and preserved, not reverted.

## Verified user adoption content

The user adoption:

- tracks `addons/hera_agent_godot/**`;
- enables Hera in `project.godot` together with Godot AI and GUT;
- adds `HeraGameInspector` as an autoload;
- retains Godot AI 3.1.3 and GUT 9.7.1.

Official Hera upstream evidence:

- repository: `NotNull92/hera-agent-godot`;
- tag: `v1.0.0`;
- tag commit: `10f245ddae9e7a5d569150302acbde0d78f2aa03`;
- official addon tree: `6cb87ac8ba768de1d924447f385fba6d80bcde68`.

The project Hera addon tree at user-adoption main had the exact same SHA:

`6cb87ac8ba768de1d924447f385fba6d80bcde68`.

Classification:

`EXACT_UPSTREAM_V1_0_0_VENDOR_BEFORE_PROJECT_COMPAT_PATCH`.

## Initial current-main RED evidence

All four primary push gates were red on `0a2bfc0f11e77ddaa09c5c45a83599c745375789`:

- Project Contract `31284627677` FAILURE;
- GUT 9.7.1 Tests `31284627676` FAILURE;
- Godot Tests `31284627671` FAILURE;
- Validate Godot Live-Editor Pilot `31284627904` FAILURE.

### Root cause A · stale Pilot/project tooling authority

The committed Pilot source baseline still pinned pre-Hera `project.godot` bytes. The dedicated adoption test also expected only Godot AI + GUT to be enabled.

This produced source-baseline and plugin-list contract failures after the valid user adoption.

### Root cause B · strict-headless Hera side effects

Exact upstream Hera v1.0.0 starts its EditorPlugin HTTP server during the project's `DisplayServer=headless` import/test tier.

In GUT/import workflow this produced a listening Hera server followed by shutdown leak/error output. The workflow correctly rejected those `ERROR` lines before GUT could be treated as green.

### Root cause C · clean-clone UID autoload timing

The user adoption persisted:

`HeraGameInspector="*uid://c4ug7a211oav8"`

On a direct clean-checkout strict-headless script run, the autoload could be evaluated before imported UID cache resolution, producing invalid Hera autoload errors. The Godot test body itself still reached **92 cases / 11,494 assertions / failed=0**, but workflow error-line policy correctly failed the job.

## Selected recovery

Alternatives rejected:

- disable Hera in `project.godot` — reverses explicit user adoption;
- strip Hera only in CI — tests a configuration different from committed project authority.

Selected bounded recovery:

1. keep Hera repo-tracked and enabled;
2. keep exact upstream v1.0.0 as vendor provenance baseline;
3. maintain one project compatibility patch in `addons/hera_agent_godot/hera_agent_plugin.gd`;
4. in `_enter_tree()`, return immediately under `DisplayServer.get_name() == "headless"` before UI/autoload/server setup;
5. normalize `HeraGameInspector` to direct `res://addons/hera_agent_godot/runtime/game_inspector.gd` for clean-clone stability;
6. refresh Pilot source baseline to the normalized Hera-enabled `project.godot`;
7. reconcile the dedicated Pilot adoption surface in a second PR without weakening its existing four-file scope guard.

## TDD RED evidence

Two harness-order/dependency attempts were discarded as invalid RED evidence:

- legacy local-tooling assertions failed before focused Hera tests executed;
- an initial focused invocation used `pytest` in a workflow that does not install it.

Neither was treated as behavioral proof.

Legitimate RED:

- head `a89cde3abbea20759ea225bc182afb4d3b34f186`;
- exact PR test merge `086b6ad51c69e49db30a05af053ed47ea66706a8`;
- Project Contract `31285424677` expected FAILURE;
- focused Hera contract executed 3 tests and all 3 failed for the intended reasons:
  1. no strict-headless early return;
  2. UID Hera autoload rather than direct `res://` path;
  3. stale tooling authority `repo_tracked=false`.

## Minimal GREEN implementation

Applied on PR #119 branch:

### Hera compatibility patch

`addons/hera_agent_godot/hera_agent_plugin.gd`

adds only the strict-headless early return before normal editor setup:

```gdscript
if DisplayServer.get_name() == "headless":
	print("[hera] plugin disabled in headless mode")
	return
```

Normal editor behavior remains the v1.0.0 upstream path.

### Clean-clone autoload normalization

`project.godot` now persists:

`HeraGameInspector="*res://addons/hera_agent_godot/runtime/game_inspector.gd"`

while keeping all three plugins enabled.

### Tooling state

`docs/tooling/local_godot_tooling_state.json` now records:

- `repo_tracked=true`;
- `repo_enabled=true`;
- `repo_version=1.0.0`;
- upstream tag/commit/tree;
- user adoption commit `614fbdce...`;
- single project compatibility patch marker.

The remote session still does not independently claim a separate physical local-editor package/version beyond the verified tracked repository state.

## Intermediate GREEN evidence

Implementation head:

`cb3d2916d58f95e3cc5c2a5c0b9d9927e474d31e`

Observed:

- focused Hera recovery contract PASS;
- existing local-tooling/asset-vault contract PASS;
- vault validator remains PASS with the original 14-file containment;
- GUT `31285499877` PASS;
- Thin Adapter `31285499880` PASS;
- direct Godot product test step PASS with **92 cases / 11,494 assertions / failed=0**;
- the previous invalid Hera autoload error is absent.

At this intermediate head, remaining Contract/Godot/Windows failures were all caused by the intentionally stale Pilot source baseline:

- Godot test product step passed; only embedded Pilot failed `SOURCE_BASELINE_MISMATCH`;
- Windows export never reached export execution because its Python-contract preflight failed the same Pilot baseline tests;
- therefore no Windows artifact regression is claimed from that intermediate failure.

## Pilot source baseline refresh

The normalized Hera-enabled `project.godot` is pinned using:

- baseline implementation commit: `cb3d2916d58f95e3cc5c2a5c0b9d9927e474d31e`;
- Git blob: `1923e0733fbf884f6507b9f2a8a59d302d10f56b`;
- raw SHA-256: `65cf1cec990d54b6a4e319b8ba76a805be4da2242fd4a8001091dd3784dbb385`.

Target-scene Pilot baseline remains unchanged.

## Backlog closure carried forward

The superseded PR #118 is not merged. Its required authority facts are carried into the active recovery branch instead:

- `SX-AUD-038` is closed to the actual applied state;
- Issue #6 is `closed · not_planned · superseded`;
- Issues #3 and #7 remain open carry-forward gates;
- PR #117 head `8d7bf917...`, test merge `d0ff3037...`, and merge/main `c9dc1f01...` evidence remain preserved.

## Remaining Phase 1 gate

Because authority documents themselves change PR #119 HEAD, earlier green runs are intermediate evidence only.

Phase 1 merge authority requires a **fresh exact final head/test merge** proving:

- Project Contract PASS;
- GUT PASS;
- Godot Tests PASS;
- Thin Adapter PASS;
- Windows Export and other automatically triggered gates do not reveal a new regression;
- user Hera vendor remains preserved;
- only the documented Hera plugin compatibility file diverges from upstream v1.0.0 addon bytes;
- no gameplay/Scene/Resource/Theme/Animation/signal/candidate/vault byte mutation is introduced by the recovery branch.

## Phase 2 gate

After Phase 1 merges, the existing Pilot adoption surface must be reconciled in a separate bounded PR:

- add Hera plugin to `legacy_editor_plugins`;
- add `HeraGameInspector` to `legacy_autoloads`;
- update exact adoption-test expectations;
- keep the existing allowed-path guard unchanged;
- pass the dedicated Validate Godot Live-Editor Pilot workflow on the exact test merge.

## Deferred gates preserved

Unchanged:

`ASSET_VAULT_UNTRACK_DEFERRED_EXTERNAL_EXECUTOR · VAULT_LOCAL_STATE_UNVERIFIED · LEGACY_14_TRACKED_PRESERVED`

Also still not claimed:

- runtime/POC;
- Windows physical runtime;
- Android device;
- connected physical editor/Hera session;
- human validation;
- final product-asset approval.
