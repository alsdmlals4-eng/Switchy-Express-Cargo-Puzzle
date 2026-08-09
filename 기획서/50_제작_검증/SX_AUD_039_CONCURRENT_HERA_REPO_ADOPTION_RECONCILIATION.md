# SX-AUD-039 · Concurrent Hera Repo Adoption Reconciliation

**Date:** 2026-08-09 KST  
**Decision:** `SX-DEC-052` same-ID reconciliation  
**Concurrent adoption baseline:** `0a2bfc0f11e77ddaa09c5c45a83599c745375789`  
**User adoption commit:** `614fbdce2b1517b8ef34eadb156bf058ecf59b1d`  
**Phase 1 merge:** `afd92d6f7e5c0c3c73bc7f6c919b43b60dff6bd6`  
**Phase 2 merge/main:** `0ae85cc44caf4c2e5c37662ffce05dad09fe9ea0`  
**Base:** `2a6ced23f6d6de1fb6e0a281c7138beb03f1a13b`  
**Status:** `RECOVERED · HERA_TRACKED_V1_0_0_USER_ADOPTED · HEADLESS_COMPAT_PASS · PILOT_ADOPTION_RECONCILED · MERGED_MAIN_0AE85_AUTOMATED_PASS · VAULT_UNTRACK_DEFERRED_EXTERNAL_EXECUTOR`

## Trigger

During `SX-AUD-038` backlog closure preparation, project `main` advanced from `c9dc1f0105d69a18dd600480d6e73e439c03c101` to `0a2bfc0f11e77ddaa09c5c45a83599c745375789`.

The new main merged the user-authored commit:

`614fbdce2b1517b8ef34eadb156bf058ecf59b1d · Enable Hera and GitHub tracking`.

The change was treated as user work and preserved rather than reverted.

## Verified user adoption

The adoption:

- tracks `addons/hera_agent_godot/**`;
- enables Hera in `project.godot` together with Godot AI and GUT;
- adds `HeraGameInspector` as an autoload;
- retains Godot AI 3.1.3 and GUT 9.7.1.

Official Hera upstream evidence:

- repository: `NotNull92/hera-agent-godot`;
- tag: `v1.0.0`;
- tag commit: `10f245ddae9e7a5d569150302acbde0d78f2aa03`;
- official addon tree: `6cb87ac8ba768de1d924447f385fba6d80bcde68`.

The project Hera addon tree at the user-adoption baseline had the exact same tree SHA:

`6cb87ac8ba768de1d924447f385fba6d80bcde68`.

Classification:

`EXACT_UPSTREAM_V1_0_0_VENDOR_BEFORE_PROJECT_COMPAT_PATCH`.

## Initial integration RED

All four primary push gates were red on `0a2bfc0f11e77ddaa09c5c45a83599c745375789`:

- Project Contract `31284627677` FAILURE;
- GUT 9.7.1 Tests `31284627676` FAILURE;
- Godot Tests `31284627671` FAILURE;
- Validate Godot Live-Editor Pilot `31284627904` FAILURE.

### Root cause A · stale Pilot/tooling authority

The Pilot source baseline still pinned pre-Hera `project.godot` bytes, and the dedicated adoption test still expected only Godot AI + GUT.

### Root cause B · strict-headless Hera side effects

Exact upstream Hera v1.0.0 started its EditorPlugin HTTP server during this project's `DisplayServer=headless` import/test tier. Shutdown leak/error output was correctly rejected by CI.

### Root cause C · clean-clone UID autoload timing

The user adoption persisted:

`HeraGameInspector="*uid://c4ug7a211oav8"`.

Direct clean-checkout strict-headless startup could evaluate that autoload before the imported UID cache was available. Godot product tests still reached **92 cases / 11,494 assertions / failed=0**, but workflow error policy correctly failed the job.

## Selected recovery

Rejected:

- disabling Hera in `project.godot`, because that reverses the explicit user adoption;
- stripping Hera only inside CI, because that tests a configuration different from committed authority.

Selected:

1. keep Hera repo-tracked and enabled;
2. preserve exact upstream v1.0.0 as provenance base;
3. maintain one bounded project compatibility patch in `addons/hera_agent_godot/hera_agent_plugin.gd`;
4. return from `_enter_tree()` under strict `DisplayServer=headless` before UI/autoload/server setup;
5. normalize `HeraGameInspector` to direct `res://addons/hera_agent_godot/runtime/game_inspector.gd`;
6. refresh the Pilot source baseline to the normalized Hera-enabled `project.godot`;
7. reconcile Hera into the dedicated Pilot temporary-copy disable surface without weakening its existing four-file PR guard.

## TDD · Phase 1

Two invalid RED attempts were discarded as evidence:

- an older local-tooling assertion failed before the new focused Hera tests ran;
- an initial focused command used `pytest` in a workflow that does not install it.

Legitimate RED:

- head `a89cde3abbea20759ea225bc182afb4d3b34f186`;
- exact test merge `086b6ad51c69e49db30a05af053ed47ea66706a8`;
- Project Contract `31285424677` expected FAILURE;
- focused Hera contract 3/3 failed for the intended reasons: missing strict-headless guard, UID autoload form, stale `repo_tracked=false` tooling authority.

Minimal GREEN implementation:

- `addons/hera_agent_godot/hera_agent_plugin.gd`: one strict-headless early return;
- `project.godot`: Hera autoload UID → direct `res://` path, all three plugins remain enabled;
- `docs/tooling/local_godot_tooling_state.json`: Hera repo-tracked/enabled v1.0.0 authority + upstream tag/commit/tree + user adoption commit + one compatibility patch marker;
- focused recovery contract becomes Project Contract-consumed;
- Pilot source baseline refreshed for the normalized `project.godot`.

Pilot source baseline values:

- implementation commit: `cb3d2916d58f95e3cc5c2a5c0b9d9927e474d31e`;
- `project.godot` Git blob: `1923e0733fbf884f6507b9f2a8a59d302d10f56b`;
- raw SHA-256: `65cf1cec990d54b6a4e319b8ba76a805be4da2242fd4a8001091dd3784dbb385`.

## Phase 1 final evidence · PR #119

Final head:

`5a22817daf260c3382bca1dde26009c1149f16d4`

Exact PR test merge:

`c800020d36c2c292e0948b4a0b37ab344c7f9266 = Merge 5a22817d… into 0a2bfc0f…`

PASS:

- Project Contract `31285701721`;
- GUT `31285701756`;
- Godot Tests `31285701745`;
- Thin Adapter `31285701722`;
- Windows Demo Export `31285702360`.

Behavioral evidence:

- Hera focused contract 3/3 PASS;
- local-tooling/vault contract 7/7 PASS;
- legacy `.asset-vault` tracked count remains `14`, `assets/_vault_local` tracked count remains `0`;
- GUT strict-headless import logs `[hera] plugin disabled in headless mode` and completes 19/19 tests, 144 assertions PASS without Hera leak errors;
- Godot completes 92/92 cases, 11,494 assertions, `failed=0`, then embedded Pilot PASS;
- Windows workflow executes and passes both `Export Windows demo` and package verification.

Adversarial diff result:

- user Hera vendor preserved;
- only `hera_agent_plugin.gd` diverges from the upstream v1.0.0 addon baseline;
- `project.godot` change relative to user-adoption main is only the Hera autoload normalization;
- no gameplay/Scene/Resource/Theme/Animation/signal/candidate/vault-byte mutation.

PR #119 was expected-head squash merged as:

`afd92d6f7e5c0c3c73bc7f6c919b43b60dff6bd6`.

## TDD · Phase 2 Pilot adoption surface

Phase 2 starts from exact Phase 1 merged main.

RED:

- test-only head `1ceb5a299f548a2b6a4cafeb362e261aad836c34`;
- dedicated Pilot run `31285954589`;
- adoption contract: 1 intended failure / 5 pass;
- sole mismatch: descriptor still declared two legacy editor plugins and one autoload while the recovered committed project requires three plugins and two tooling autoloads.

Minimal GREEN:

- `.godot-live-editor/project-pilot.json` adds `res://addons/hera_agent_godot/plugin.cfg` to `legacy_editor_plugins` and `HeraGameInspector` to `legacy_autoloads`;
- `tests/test_godot_live_editor_adoption.py` expects the same exact three plugins/two autoloads;
- existing `ALLOWED_PATHS` and workflow scope guard remain unchanged;
- adoption documentation required no count-specific edit.

Final head:

`2e5dd80e237c2b5c9afd6de3bfa35da2468a7a8d`

Exact test merge:

`9c1b9865a219527b5ac0c0cdc04834a7c6970858 = Merge 2e5dd80e… into afd92d6f…`

Diff relative to Phase 1 main: exactly two files, both inside the pre-existing Pilot adoption surface.

PASS:

- Project Contract `31286031234`;
- GUT `31286031225`;
- Godot Tests `31286031219`;
- Thin Adapter `31286031221`;
- Validate Godot Live-Editor Pilot `31286031372`.

Dedicated Pilot evidence:

- adoption contract 6/6 PASS;
- reusable `project-pilot` job PASS;
- bounded evidence artifact uploaded;
- source-mutation/scope guards preserved.

PR #120 was expected-head squash merged as:

`0ae85cc44caf4c2e5c37662ffce05dad09fe9ea0`.

## Merged-main regression

At `main 0ae85cc44caf4c2e5c37662ffce05dad09fe9ea0`:

- Project Contract `31286161671` PASS;
- GUT `31286161663` PASS;
- Godot Tests `31286161684` PASS;
- Validate Godot Live-Editor Pilot `31286161842` PASS.

This closes the automated Hera adoption/headless/Pilot recovery. It does **not** constitute physical Hera/editor/device validation.

## Backlog state carried forward

`SX-AUD-038` remains authoritative for stale Vertical Slice backlog reconciliation:

- Issue #6: `closed · not_planned · superseded`;
- Issues #3 and #7: open carry-forward gates.

The Hera recovery does not change those issue classifications.

## Deferred gates preserved

Unchanged:

`ASSET_VAULT_UNTRACK_DEFERRED_EXTERNAL_EXECUTOR · VAULT_LOCAL_STATE_UNVERIFIED · LEGACY_14_TRACKED_PRESERVED`

Also still not claimed:

- runtime/POC;
- final product-asset approval/promotion;
- Windows physical runtime;
- Android device;
- connected physical editor/Hera session;
- human validation.

## Authority sync state

GitHub implementation and automated recovery are complete through `0ae85cc44caf4c2e5c37662ffce05dad09fe9ea0`.

The canonical Decision/Audit documentation is being reconciled to that already-verified implementation state. Google Sheet synchronization must use the final canonical main after this documentation reconciliation and must preserve all deferred gates above.
