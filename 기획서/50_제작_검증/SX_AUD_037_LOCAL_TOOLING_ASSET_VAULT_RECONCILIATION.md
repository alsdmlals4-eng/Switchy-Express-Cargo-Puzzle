# SX-AUD-037 · Local Tooling & Asset-Vault Reconciliation Audit

**Decision:** `SX-DEC-052`  
**Status:** `IMPLEMENTATION_HEAD_AUTOMATED_PASS · FINAL_HEAD_RECHECK_REQUIRED · VAULT_UNTRACK_DEFERRED_EXTERNAL_EXECUTOR`  
**Date:** 2026-08-09 KST

## Scope

Non-destructive containment of project-local asset-vault tracking plus repository authority reconciliation for the user's approved Godot AI / Hera / GUT editor tooling state.

No gameplay, Scene, Resource, Theme, Animation, signal, product-asset promotion, runtime/POC, or user-local deletion is in scope.

## Fresh authority baseline

- Project baseline: `60f7834659b026494fa927c1b5aa5c9c41a2e489`.
- Base: `2a6ced23f6d6de1fb6e0a281c7138beb03f1a13b`.
- Base policy: `.asset-vault/` and `assets/_vault_local/` are LOCAL ONLY and must be gitignored.
- Baseline project `.gitignore` lacked both roots while the project tree contained 14 PNG blobs under `.asset-vault/library/gpt-imports/...`.

## User tooling evidence

User reported and approved:
- Godot AI local update to `3.1.3`;
- Hera plugin enabled and approved;
- GUT plugin enabled and approved.

Repository evidence:
- GUT remains `9.7.1` and is enabled in `project.godot`;
- Hera is not repository-tracked and the exact local Hera version is not visible to this session, therefore `LOCAL_VERSION_UNVERIFIED` is retained;
- Godot AI repository addon was `3.1.2` at baseline.

## Godot AI exact vendor evidence

Project baseline `addons/godot_ai` subtree SHA:
`a7d1e2fe8564cc385d683ec50d15fc66e1a17a35`

Official upstream `hi-godot/godot-ai` tag `v3.1.2` addon subtree SHA:
`a7d1e2fe8564cc385d683ec50d15fc66e1a17a35`

Verdict: `FULL_ADDON_TREE_V3_1_2_PARITY_PASS`.

Official upstream `v3.1.3` tag commit:
`22678e5f9b038d7203d6b43b0aae20a5417c500e`

The v3.1.3 addon delta from the proven-parity v3.1.2 tree changes only `plugin.cfg` version `3.1.2` → `3.1.3`; the project applies only that addon delta.

## TDD evidence

### Initial RED

Head: `e835af9412cc5b6d4c693fb18b7ab12abde4f467`  
Project Contract run: `31282794028` → expected FAILURE.

Focused contract result: 6 tests, 5 expected failures:
- local-only ignore rules absent;
- Godot AI repository version still 3.1.2;
- legacy allowlist absent;
- validator absent;
- preservation preflight absent.

Existing GUT 9.7.1 + enabled state passed.

### Integration RED / adversarial correction

At implementation head `676015a54fca1aaba5d3e127a8fefda985421c0e`, focused 6/6 passed but the CI validator failed because index-oriented path discovery did not observe the legacy files in the PR checkout path.

A direct test-merge tree read confirmed the 14 legacy blobs still existed. A new focused test was added to require current-HEAD discovery. At head `48ec79637d6ba541edcf91d91ab9a0e9f03311a6`, that seventh test failed because Git's quoted-path presentation escaped Korean filenames.

The minimal correction uses `git ls-tree -r -z --name-only HEAD` and NUL-delimited UTF-8 path decoding. No allowlist weakening or asset deletion was used.

### GREEN

Head: `bc87f6e4e7f952b7bd5d5f3c4d631acb2d44788c`  
PR test merge observed by Project Contract: `5de1a6c8b47bf798c4bca213f7597d72102597ac`.

Project Contract run `31283023924` PASS:
- focused reconciliation contract: 7/7 PASS;
- vault validator: `legacy_tracked=14 · assets/_vault_local_tracked=0 · LEGACY_TRACKED_PRESERVED` PASS;
- project contract and existing canonical checks PASS.

Also PASS on the GREEN head:
- GUT 9.7.1 Tests `31283023932`;
- Godot Tests `31283023954`;
- Validate Thin Adapter Migration `31283023928`;
- Validate Base Shared External AI Adapter `31283023972`.

Windows Demo Export `31283023994` was still running when this audit text was created and is not claimed here.

## Implemented containment

- `.gitignore` now blocks new untracked `.asset-vault/` and `assets/_vault_local/` additions.
- Exact 14 existing tracked vault PNG paths are frozen in `docs/tooling/asset_vault_legacy_tracked_allowlist.txt`.
- CI rejects new tracked local-only paths beyond that legacy set.
- `tools/asset_vault_preservation_preflight.py` inventories local vault files with size + SHA-256 and never claims backup completion.
- report output inside either local-only root is rejected.
- current 14 tracked vault bytes are intentionally preserved; this PR does not delete them.

## Deferred preservation gate

`ASSET_VAULT_UNTRACK_DEFERRED_EXTERNAL_EXECUTOR`

A future same-ID cleanup may untrack the 14 files only after a local executor proves:
- local inventory,
- per-file SHA-256,
- backup/preservation outside the repository or equivalent,
- post-backup hash equality,
- repository removal will not destroy the only remaining copies.

Until then:
- `VAULT_LOCAL_STATE_UNVERIFIED` remains true from this remote session;
- 14 tracked legacy paths remain preserved;
- no claim of full vault cleanup is allowed.

## Hera / GUT boundary

- Hera: `USER_ENABLED_APPROVED · LOCAL_VERSION_UNVERIFIED · REPO_NOT_TRACKED`; no Hera bytes were added or overwritten.
- GUT: `USER_ENABLED_APPROVED · REPO_9.7.1_ENABLED`; vendor bytes and enablement remain unchanged.

## Current verdict

`NONDESTRUCTIVE_CONTAINMENT_IMPLEMENTED · GODOT_AI_REPO_3_1_3 · LEGACY_14_TRACKED_PRESERVED · HERA_LOCAL_VERSION_UNVERIFIED · VAULT_UNTRACK_DEFERRED_EXTERNAL_EXECUTOR · FINAL_PR_HEAD_RECHECK_REQUIRED`
