# SX-DEC-052 · Local Tooling & Asset-Vault Reconciliation

**Status:** `USER_APPROVED · MERGED_MAIN_VERIFIED · GODOT_AI_3_1_3_SYNCED · GUT_9_7_1_PRESERVED · HERA_TRACKED_V1_0_0_USER_ADOPTED · HEADLESS_COMPAT_PASS · PILOT_ADOPTION_RECONCILED · VAULT_UNTRACK_DEFERRED_EXTERNAL_EXECUTOR`  
**Date:** 2026-08-09 KST  
**Original project baseline:** `60f7834659b026494fa927c1b5aa5c9c41a2e489`  
**Original tooling closure/main:** `c8eb8c47d620a7a7aa478e0559ec3d70bd8f6858`  
**Concurrent Hera-adoption main:** `0a2bfc0f11e77ddaa09c5c45a83599c745375789`  
**Phase 1 tooling recovery merge:** `afd92d6f7e5c0c3c73bc7f6c919b43b60dff6bd6`  
**Phase 2 Pilot reconciliation merge/main:** `0ae85cc44caf4c2e5c37662ffce05dad09fe9ea0`  
**Base:** `2a6ced23f6d6de1fb6e0a281c7138beb03f1a13b`

## Decision

Use one same-ID, non-destructive tooling reconciliation for Godot AI, GUT, Hera, and project-local asset-vault policy. GitHub is the patch/merge surface. User-local vault bytes are never deleted from a remote-only session without local preservation evidence.

The later user-authored Hera repository adoption belongs to this Decision because it changes the exact tooling authority originally recorded here. It is preserved rather than reverted.

## Current tooling authority

User-approved local evidence:

- Godot AI: **3.1.3**, enabled and approved;
- GUT: enabled and approved;
- Hera: enabled and approved.

Current repository authority:

- Godot AI tracked manifest: **3.1.3**;
- GUT tracked manifest: **9.7.1**, enabled in `project.godot`;
- Hera: repo-tracked and enabled, **v1.0.0** provenance base;
- `HeraGameInspector`: committed using the clean-clone-stable direct `res://` autoload path;
- Pilot temporary-copy contract disables Godot AI, GUT, Hera, `_mcp_game_helper`, and `HeraGameInspector` without mutating the source project.

The remote session does not claim a separate physical-editor Hera package/version beyond the verified tracked repository state and the user's approval report.

## Godot AI synchronization basis

The project's pre-upgrade `addons/godot_ai` subtree exactly matched official upstream v3.1.2 tree:

`a7d1e2fe8564cc385d683ec50d15fc66e1a17a35`.

Official v3.1.3 tag commit:

`22678e5f9b038d7203d6b43b0aae20a5417c500e`.

The upstream addon delta is only the `plugin.cfg` version `3.1.2` → `3.1.3`; the project applies that bounded delta.

## Hera user adoption and provenance

User-authored adoption commit:

`614fbdce2b1517b8ef34eadb156bf058ecf59b1d · Enable Hera and GitHub tracking`

was merged into project history at:

`0a2bfc0f11e77ddaa09c5c45a83599c745375789`.

Official upstream evidence:

- repository: `NotNull92/hera-agent-godot`;
- tag: `v1.0.0`;
- tag commit: `10f245ddae9e7a5d569150302acbde0d78f2aa03`;
- addon tree: `6cb87ac8ba768de1d924447f385fba6d80bcde68`.

The user-vendored project addon tree at the adoption baseline had that exact same tree SHA. The tracked vendor therefore begins from exact upstream v1.0.0 bytes.

## Bounded Hera project compatibility patch

Strict `DisplayServer=headless` import/test is not Hera's live-editor operating tier. Upstream v1.0.0 started its editor server during those strict headless processes and produced shutdown leak/error lines that this project's CI correctly rejects.

The project preserves Hera ON and maintains one explicit compatibility divergence:

`addons/hera_agent_godot/hera_agent_plugin.gd:HEADLESS_EARLY_RETURN`

At the start of `_enter_tree()`, Hera returns before UI/autoload/server setup when:

```gdscript
DisplayServer.get_name() == "headless"
```

Normal non-headless editor behavior remains on the upstream v1.0.0 path.

The committed autoload is normalized to:

```ini
HeraGameInspector="*res://addons/hera_agent_godot/runtime/game_inspector.gd"
```

so direct clean-checkout headless startup does not depend on an already-imported UID cache.

## Asset-vault containment remains unchanged

Base authority requires `.asset-vault/` and `assets/_vault_local/` to remain LOCAL ONLY and gitignored.

The existing reconciliation remains:

1. both roots are ignored;
2. the 14 already-tracked `.asset-vault` PNGs are frozen as a temporary legacy allowlist;
3. CI rejects every new tracked local-only path beyond that set using raw UTF-8 HEAD-tree paths;
4. preservation preflight inventories local files with size/SHA-256 only;
5. project-internal reports are limited to `test-results/` and exclusive-create, so existing files are not overwritten;
6. the 14 legacy bytes remain intentionally tracked/preserved until local hash-verified preservation attestation exists.

Hera adoption/recovery did not modify those 14 bytes.

## Original containment evidence

Initial containment RED `e835af9412cc5b6d4c693fb18b7ab12abde4f467`:

- Project Contract `31282794028` expected FAILURE.

Adversarial preflight RED `3f5ecb14233d2308a563fb8821f06e91e0d482e6`:

- Project Contract `31283223964` expected FAILURE.

Safety GREEN `06d2cb61d15f2b4c9e6a5b5b89e00ea1356a544e`:

- Project Contract `31283266229` PASS.

PR #115 final test merge `c2470b47cb01572c5a4e5ceeef96ae6703774c38` passed Contract/GUT/Godot/Thin/adapter/Windows gates and merged as `2a51ec9391b0cd78efa9b99ebf504bf6f1390fe7`.

PR #116 closed the original canonical tooling state as `c8eb8c47d620a7a7aa478e0559ec3d70bd8f6858`; final-main Contract/GUT/Godot/Pilot passed.

## Hera adoption integration RED

At concurrent user-adoption main `0a2bfc0f11e77ddaa09c5c45a83599c745375789`:

- Project Contract `31284627677` FAILURE;
- GUT `31284627676` FAILURE;
- Godot Tests `31284627671` FAILURE;
- Live-Editor Pilot `31284627904` FAILURE.

`SX-AUD-039` records the root causes: stale Pilot/tooling authority, Hera strict-headless side effects, and clean-clone UID autoload timing. The Godot product test body itself reached 92 cases / 11,494 assertions / `failed=0`.

## Phase 1 · Hera headless/config recovery

Legitimate focused RED:

- head `a89cde3abbea20759ea225bc182afb4d3b34f186`;
- exact test merge `086b6ad51c69e49db30a05af053ed47ea66706a8`;
- Project Contract `31285424677` expected FAILURE;
- focused Hera contract 3/3 failed for the intended missing state: no headless guard, UID autoload, stale repo-untracked authority.

Final Phase 1 head:

`5a22817daf260c3382bca1dde26009c1149f16d4`

Exact test merge:

`c800020d36c2c292e0948b4a0b37ab344c7f9266`

PASS:

- Project Contract `31285701721`;
- GUT `31285701756`;
- Godot Tests `31285701745`;
- Thin Adapter `31285701722`;
- Windows Demo Export `31285702360`.

Behavioral evidence:

- focused Hera 3/3 PASS;
- local tooling/vault 7/7 PASS, legacy tracked `14`, `_vault_local` tracked `0`;
- strict-headless import logs `[hera] plugin disabled in headless mode`;
- GUT 19/19, 144 assertions PASS;
- Godot 92/92, 11,494 assertions, `failed=0`, embedded Pilot PASS;
- Windows job executed and passed both demo export and package verification.

PR #119 was expected-head squash merged as:

`afd92d6f7e5c0c3c73bc7f6c919b43b60dff6bd6`.

## Phase 2 · Pilot adoption-surface reconciliation

TDD RED:

- test-only head `1ceb5a299f548a2b6a4cafeb362e261aad836c34`;
- dedicated Pilot run `31285954589`;
- adoption contract: 1 intended failure / 5 pass;
- only mismatch was stale descriptor content: 2 legacy plugins / 1 autoload instead of the Hera-aware 3 plugins / 2 autoloads.

Final Phase 2 head:

`2e5dd80e237c2b5c9afd6de3bfa35da2468a7a8d`

Exact test merge:

`9c1b9865a219527b5ac0c0cdc04834a7c6970858`

The diff was exactly two files, both already inside the unchanged four-file Pilot adoption guard:

- `.godot-live-editor/project-pilot.json`;
- `tests/test_godot_live_editor_adoption.py`.

PASS:

- Project Contract `31286031234`;
- GUT `31286031225`;
- Godot Tests `31286031219`;
- Thin Adapter `31286031221`;
- Live-Editor Pilot `31286031372`.

Dedicated Pilot evidence:

- adoption contract 6/6 PASS;
- reusable `project-pilot` job PASS;
- bounded evidence artifact uploaded;
- four-file scope guard remained unchanged.

PR #120 was expected-head squash merged as:

`0ae85cc44caf4c2e5c37662ffce05dad09fe9ea0`.

Merged-main regression at `0ae85cc44caf4c2e5c37662ffce05dad09fe9ea0`:

- Project Contract `31286161671` PASS;
- GUT `31286161663` PASS;
- Godot Tests `31286161684` PASS;
- Live-Editor Pilot `31286161842` PASS.

## Backlog authority preserved

`SX-AUD-038` remains authoritative for stale Vertical Slice backlog cleanup:

- Issue #6: `closed · not_planned · superseded`;
- Issues #3 and #7: open carry-forward gates.

Hera tooling recovery does not alter those classifications.

## Authority boundary

This Decision does **not** claim:

- gameplay changes;
- Scene/Resource/Theme/Animation/signal authoring;
- product-asset promotion;
- runtime/POC completion;
- Windows physical runtime;
- Android device validation;
- connected physical editor/Hera validation;
- human validation;
- user-local vault deletion/untrack completion.

## Remaining deferred gate

`ASSET_VAULT_UNTRACK_DEFERRED_EXTERNAL_EXECUTOR`

The 14 legacy tracked vault paths may be untracked only after local preservation attestation proves hash-verified copies exist outside the destructive pull path. Until then:

- `VAULT_LOCAL_STATE_UNVERIFIED` remains true;
- `LEGACY_14_TRACKED_PRESERVED` remains true;
- no full vault-cleanup claim is allowed.

The next independent product steps remain final production-candidate asset approval/promotion, runtime/POC integration, and later physical/device/human quality gates under their own authority.
