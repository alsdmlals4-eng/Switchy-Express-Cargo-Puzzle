# SX-DEC-052 Local Tooling & Asset-Vault Reconciliation Implementation Plan

> **For execution:** follow Superpowers TDD, executing-plans, verification-before-completion, and continuous-work inherited merge authority. GitHub is the only patch/merge surface.

**Goal:** contain the currently tracked local-only asset vault without deleting user work, synchronize the tracked Godot AI addon from exact upstream v3.1.2 parity to v3.1.3, and canonically record the user's approved Godot AI/Hera/GUT editor-tooling state.

**Baseline:** project `60f7834659b026494fa927c1b5aa5c9c41a2e489`; Base `2a6ced23f6d6de1fb6e0a281c7138beb03f1a13b`.

**Safety boundary:** do not delete/untrack existing `.asset-vault` bytes in this plan. Phase C remains blocked on a local preservation attestation.

## Task 1 — Freeze a RED contract for local-only containment and tooling state

Create `tests/python/test_local_tooling_reconciliation.py` and wire it plus `tools/validate_local_tooling_reconciliation.py` into `.github/workflows/project-contract.yml`.

RED requirements:
- `.gitignore` contains `.asset-vault/` and `assets/_vault_local/`.
- legacy allowlist equals the currently tracked `.asset-vault` blob paths.
- no tracked `assets/_vault_local` path.
- validator rejects tracked local-only paths outside the frozen legacy set.
- tooling state manifest records Godot AI 3.1.3, GUT 9.7.1, and Hera user-approved with local version unverified.
- `addons/godot_ai/plugin.cfg` reports 3.1.3.
- GUT remains 9.7.1 and Godot AI/GUT remain enabled in `project.godot`.
- preservation preflight is inventory-only and rejects output inside local-only roots.

Commit test/workflow first and observe expected Project Contract RED before implementation.

## Task 2 — Implement non-destructive vault containment

Modify `.gitignore`; create `docs/tooling/asset_vault_legacy_tracked_allowlist.txt` and `tools/validate_local_tooling_reconciliation.py`.

- Freeze the exact 14 currently tracked `.asset-vault` PNG paths; do not delete them.
- Validator uses `git ls-files -- .asset-vault assets/_vault_local`.
- Permit only allowlisted `.asset-vault` paths; reject every tracked `assets/_vault_local` path and every future non-allowlisted `.asset-vault` path.
- Expose pure `validate_tracked_paths(tracked_paths, allowed_paths)` for unit testing.
- Report `LEGACY_TRACKED_PRESERVED`, never full cleanup.

## Task 3 — Add read-only local preservation preflight

Create `tools/asset_vault_preservation_preflight.py`.

- Scan `.asset-vault/library` if present.
- Emit stable JSON with Decision ID, `inventory_only`, relative path, size, SHA-256.
- Optional `--output` must resolve outside `.asset-vault/` and `assets/_vault_local/`.
- Never delete, move, rename, or alter vault bytes and never claim backup completion.
- If the vault is absent, emit explicit absent/unverified status.

## Task 4 — Reconcile Godot AI / Hera / GUT authority state

Modify `addons/godot_ai/plugin.cfg`; create `docs/tooling/local_godot_tooling_state.json`.

Evidence:
- project Godot AI subtree `a7d1e2fe8564cc385d683ec50d15fc66e1a17a35`;
- upstream v3.1.2 addon subtree is the same SHA: full addon parity PASS;
- upstream v3.1.3 tag commit `22678e5f9b038d7203d6b43b0aae20a5417c500e`;
- v3.1.3 addon delta is only `plugin.cfg` 3.1.2→3.1.3.

Implementation:
- change only Godot AI plugin manifest version to 3.1.3;
- leave GUT 9.7.1/vendor and project plugin enablement unchanged;
- do not add Hera vendor bytes; record `LOCAL_VERSION_UNVERIFIED`.

## Task 5 — GREEN validation and adversarial review

Fresh evidence on implementation head:
- focused pytest;
- validator;
- Project Contract;
- GUT 9.7.1 Tests;
- Godot Tests;
- Validate Thin Adapter Migration.

Adversarial review checks no vault deletion, no Scene/Resource/Theme/Animation/signal/gameplay changes, no Hera files, unchanged GUT, exact one-line Godot AI upstream delta, no future local-only expansion loophole, and no destructive preflight path.

## Task 6 — Canonical audit and same-ID synchronization

Update Decision and create `기획서/50_제작_검증/SX_AUD_037_LOCAL_TOOLING_ASSET_VAULT_RECONCILIATION.md` with RED/GREEN heads, CI runs, upstream identities, 14-file boundary, and deferred gates:
`ASSET_VAULT_UNTRACK_DEFERRED_EXTERNAL_EXECUTOR`, `VAULT_LOCAL_STATE_UNVERIFIED`, `HERA_LOCAL_VERSION_UNVERIFIED`, plus runtime/POC/device/human gates.

## Task 7 — PR closure and merged-main verification

Open draft PR after RED; progress to GREEN and audit; require fresh final test-merge Contract/GUT/Godot/Thin PASS; adversarially review files/comments/threads/reviews; mark Ready and squash merge using `expected_head_sha`; re-read merged main and regression; make docs-only same-ID closure only if needed; then sync Hub, SX-DEC-052, SX-AUD-037, CURRENT-17 in Google Sheet.

**Completion classification:** `DELIVERED_WITH_DEFERRED_EXTERNAL_PRESERVATION_GATE`, not full vault cleanup.
