# SX-DEC-052 · Local Tooling & Asset-Vault Reconciliation

**Status:** `USER_APPROVED · NONDESTRUCTIVE_CONTAINMENT_IMPLEMENTED · GODOT_AI_REPO_3_1_3 · VAULT_UNTRACK_DEFERRED_EXTERNAL_EXECUTOR`
**Date:** 2026-08-09 KST
**Project baseline:** `60f7834659b026494fa927c1b5aa5c9c41a2e489`
**Base:** `2a6ced23f6d6de1fb6e0a281c7138beb03f1a13b`

## Decision

Adopt a non-destructive reconciliation for local Godot tooling and the project-local asset vault. GitHub remains the only patch/merge surface. Existing user-local vault bytes must not be deleted by remote cleanup.

## User-approved local tooling evidence

- Godot AI: user reports updated locally to **3.1.3** and approved.
- Hera Agent Godot: user reports plugin **enabled and approved**.
- GUT: user reports plugin **enabled and approved**.

Repository authority after implementation:
- Godot AI tracked manifest: **3.1.3**.
- GUT tracked manifest: **9.7.1** and enabled in `project.godot`.
- Hera addon: not tracked; local user approval is valid evidence, but exact local version remains `LOCAL_VERSION_UNVERIFIED` from this session.

## Godot AI synchronization basis

Baseline project `addons/godot_ai` subtree and official upstream `v3.1.2` addon subtree share exact tree SHA:
`a7d1e2fe8564cc385d683ec50d15fc66e1a17a35`.

This proves full v3.1.2 addon parity before synchronization.

Official upstream v3.1.3 tag commit:
`22678e5f9b038d7203d6b43b0aae20a5417c500e`.

The upstream v3.1.3 addon delta changes only `plugin.cfg` version `3.1.2` → `3.1.3`; the project applies only that delta. GUT and Hera vendor bytes are not changed.

## Asset-vault rule and containment

Base authority requires:
- `.asset-vault/` = LOCAL ONLY, gitignored;
- `assets/_vault_local/` = LOCAL ONLY, gitignored;
- generated/in-review candidates are not repository assets before explicit promotion.

The baseline project incorrectly tracked 14 PNG files under `.asset-vault/library/gpt-imports/...` while lacking those ignore rules.

Reconciliation:
1. `.asset-vault/` and `assets/_vault_local/` are now ignored.
2. The exact existing 14 tracked `.asset-vault` paths are frozen as a temporary legacy allowlist.
3. CI rejects every new tracked local-only path beyond that set.
4. A read-only preservation preflight inventories local vault files with size and SHA-256 and cannot write reports inside local-only roots.
5. The current 14 tracked bytes are intentionally **not deleted** by this Decision's current GitHub implementation.

## TDD and automated evidence

Initial RED head `e835af9412cc5b6d4c693fb18b7ab12abde4f467`:
- Project Contract `31282794028` expected FAILURE;
- focused 6 tests: 5 failed for the intended missing containment/tooling implementation, while existing GUT state passed.

Adversarial integration RED exposed Git path-discovery/Unicode quoting assumptions; the validator was corrected without weakening the allowlist.

GREEN implementation head `bc87f6e4e7f952b7bd5d5f3c4d631acb2d44788c`:
- Project Contract `31283023924` PASS;
- focused reconciliation tests 7/7 PASS;
- vault validator PASS with `legacy_tracked=14`, `assets/_vault_local_tracked=0`;
- GUT 9.7.1 Tests `31283023932` PASS;
- Godot Tests `31283023954` PASS;
- Thin Adapter `31283023928` PASS;
- Base Shared External AI Adapter `31283023972` PASS.

The audit/Decision documentation commits change the PR head, so final merge authority depends on a fresh exact final test-merge validation set.

## Authority boundary

No Scene/Resource/Theme/Animation/signal authoring, gameplay changes, runtime/POC claims, product-asset promotion, Hera vendor overwrite, or user-local deletion is authorized by this Decision.

## Deferred gate

`ASSET_VAULT_UNTRACK_DEFERRED_EXTERNAL_EXECUTOR`

The remaining 14 tracked vault paths may be untracked only after a local preservation attestation proves hash-verified copies exist outside the destructive pull path. Until then `VAULT_LOCAL_STATE_UNVERIFIED` and `LEGACY_14_TRACKED_PRESERVED` remain truthful states.
