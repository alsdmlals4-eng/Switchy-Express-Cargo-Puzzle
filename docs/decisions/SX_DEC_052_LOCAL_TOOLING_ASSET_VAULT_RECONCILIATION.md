# SX-DEC-052 · Local Tooling & Asset-Vault Reconciliation

**Status:** `USER_APPROVED · CONTINUOUS_WORK_ACTIVE · IMPLEMENTATION_PENDING`
**Date:** 2026-08-09 KST
**Project baseline:** `60f7834659b026494fa927c1b5aa5c9c41a2e489`
**Base:** `2a6ced23f6d6de1fb6e0a281c7138beb03f1a13b`

## Decision

Adopt a non-destructive reconciliation for local Godot tooling and the project-local asset vault. GitHub remains the only patch/merge surface. Existing user-local vault bytes must not be deleted by remote cleanup.

## User-approved local tooling evidence

- Godot AI: user reports updated to **3.1.3**.
- Hera Agent Godot: user reports plugin **enabled and approved**.
- GUT: user reports plugin **enabled and approved**.

Repository evidence at the baseline:
- Godot AI tracked manifest: **3.1.2** → repository sync required.
- GUT tracked manifest: **9.7.1** and enabled in `project.godot` → already aligned.
- Hera addon: not tracked in repository → local approval is recorded, exact local version is not inferred.

## Asset-vault rule

Base authority requires:
- `.asset-vault/` = LOCAL ONLY, gitignored;
- `assets/_vault_local/` = LOCAL ONLY, gitignored;
- generated/in-review candidates are not repository assets before explicit promotion.

Current main violates the first rule by tracking `.asset-vault/library/gpt-imports/...`.

## Reconciliation choice

1. **Contain first:** add ignore rules and block any expansion beyond the frozen currently tracked legacy set.
2. **Preserve before untrack:** do not delete current tracked vault bytes until a local hash-verified preservation attestation exists.
3. **Godot AI exact sync:** reconcile tracked Godot AI to upstream v3.1.3 only after exact release comparison and CI.
4. **Hera evidence-first:** keep user approval as valid local evidence, but do not vendor/overwrite Hera until the local version is attested.
5. **GUT unchanged:** preserve GUT 9.7.1 unless fresh evidence proves drift.

## Authority boundary

No Scene/Resource/Theme/Animation/signal authoring, gameplay changes, runtime/POC claims, product-asset promotion, or user-local deletion is authorized by this Decision.

## Deferred gate

`ASSET_VAULT_UNTRACK = DEFERRED_EXTERNAL_EXECUTOR` until local preservation attestation proves remote deletion will not destroy the user's only copies.