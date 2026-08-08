# SX-DEC-052 Local Tooling & Asset-Vault Reconciliation Design

**Status:** `USER_APPROVED_DESIGN · CONTINUOUS_WORK_ACTIVE`
**Date:** 2026-08-09 KST
**Baseline:** project `60f7834659b026494fa927c1b5aa5c9c41a2e489` · Base `2a6ced23f6d6de1fb6e0a281c7138beb03f1a13b`

## Goal

Reconcile the project-local tooling state and the mistakenly tracked `.asset-vault/` without deleting user-local work. Preserve the user's approved editor setup while keeping GitHub as the only patch/merge surface.

## Fresh evidence

- User reports local Godot AI **3.1.3** updated.
- User reports **Hera** plugin enabled and approved.
- User reports **GUT** plugin enabled and approved.
- Repository `addons/godot_ai/plugin.cfg` is still **3.1.2**.
- Upstream `hi-godot/godot-ai` release `v3.1.3` exists; plugin manifest is 3.1.3.
- Repository GUT is **9.7.1** and `project.godot` enables both Godot AI and GUT.
- Repository currently has no `addons/hera_agent_godot/` tree.
- Hera identity is `NotNull92/hera-agent-godot`; current stable baseline is **v1.0.0**. The local Hera exact version remains unverified in this session.
- Base `PROJECT_LOCAL_ASSET_VAULT_POLICY.md` states `.asset-vault/` and `assets/_vault_local/` are LOCAL ONLY and gitignored.
- Project main currently tracks files under `.asset-vault/library/gpt-imports/...` while `.gitignore` lacks both local-only paths.

## Architecture

### Phase A — non-destructive containment and authority record

1. Add `.asset-vault/` and `assets/_vault_local/` to `.gitignore`.
2. Do **not** remove any currently tracked `.asset-vault` bytes in this phase.
3. Capture the current tracked `.asset-vault` path set as a bounded legacy baseline.
4. Add a validator that fails if new tracked paths appear under `.asset-vault/` or `assets/_vault_local/`, while tolerating only the frozen legacy baseline until safe untracking is possible.
5. Add a preservation preflight tool that inventories local vault files, hashes them, and can emit an attestation before a future untrack. It must not delete or alter vault bytes.
6. Record local tooling authority state:
   - Godot AI: `USER_LOCAL_3.1.3 · REPO_3.1.2 · SYNC_REQUIRED`
   - GUT: `USER_ENABLED_APPROVED · REPO_9.7.1_ENABLED`
   - Hera: `USER_ENABLED_APPROVED · LOCAL_VERSION_UNVERIFIED · REPO_NOT_TRACKED`

### Phase B — exact plugin reconciliation

1. Compare the repository Godot AI vendor tree against upstream **v3.1.3 release bytes**.
2. If the delta is bounded to the upstream release and project integration remains compatible, update the tracked vendor tree to v3.1.3 and run exact-head CI.
3. Do not vendor Hera until the local addon/CLI version can be attested. Record the stable v1.0.0 upstream identity, but avoid guessing that it matches the local installation.
4. Keep GUT 9.7.1 unchanged unless fresh evidence shows a mismatch.

### Phase C — safe vault untrack

This phase is blocked until a local preservation attestation exists. GitHub removal of tracked `.asset-vault` files would delete those paths on a normal pull, so remote-only deletion is not safe without proof that user-local bytes are preserved elsewhere.

Required attestation before deletion:
- local vault file inventory,
- SHA-256 per file,
- backup destination outside the repository or equivalent proven preservation,
- hash equality after backup,
- explicit statement that repository removal will not be the only remaining copy.

After attestation, a separate same-ID GitHub PR may delete the tracked vault paths while retaining `.gitignore` protection.

## Hard boundaries

- No user-local file deletion.
- No force-push.
- No gameplay changes.
- No Scene/Resource/Theme/Animation/signal authoring.
- No product-asset promotion.
- No runtime/POC claims.
- No Hera vendor overwrite without exact local-version evidence.
- No claim that Hera/HiGodot physical editor connectivity was tested from this session.

## Validation

Phase A acceptance:
- ignore rules present,
- legacy tracked-vault baseline frozen,
- new tracked local-only paths rejected by automated validation,
- preservation preflight is read-only by default,
- GUT remains 9.7.1 and enabled,
- plugin state record matches user/repository evidence.

Phase B Godot AI acceptance:
- repository plugin manifest reports 3.1.3,
- vendor delta is traceable to upstream v3.1.3,
- Project Contract, GUT, Godot Tests, Thin Adapter checks pass at exact PR test-merge head.

Phase C remains `DEFERRED_EXTERNAL_EXECUTOR` until local preservation evidence is available.

## Rollback

Phase A is fully reversible by reverting documentation, validator, preflight tool, and ignore rules; it does not delete vault bytes. Godot AI 3.1.3 vendor sync is independently revertible as one bounded vendor commit.