# SX-DEC-052 · Local Tooling & Asset-Vault Reconciliation

**Status:** `USER_APPROVED · MERGED_MAIN_VERIFIED · NONDESTRUCTIVE_CONTAINMENT_PASS · GODOT_AI_3_1_3_SYNCED · ADVERSARIAL_PREFLIGHT_SAFETY_PASS · VAULT_UNTRACK_DEFERRED_EXTERNAL_EXECUTOR`
**Date:** 2026-08-09 KST
**Project baseline:** `60f7834659b026494fa927c1b5aa5c9c41a2e489`
**Product merge/main anchor:** `2a51ec9391b0cd78efa9b99ebf504bf6f1390fe7`
**Base:** `2a6ced23f6d6de1fb6e0a281c7138beb03f1a13b`

## Decision

Adopt a non-destructive reconciliation for local Godot tooling and the project-local asset vault. GitHub remains the only patch/merge surface. Existing user-local vault bytes must not be deleted by remote cleanup.

## User-approved local tooling evidence

- Godot AI: user reports updated locally to **3.1.3** and approved.
- Hera Agent Godot: user reports plugin **enabled and approved**.
- GUT: user reports plugin **enabled and approved**.

Repository authority after merge:
- Godot AI tracked manifest: **3.1.3**.
- GUT tracked manifest: **9.7.1** and enabled in `project.godot`.
- Hera addon: not tracked; local user approval is valid evidence, but exact local version remains `LOCAL_VERSION_UNVERIFIED` from this session.

## Godot AI synchronization basis

Baseline project `addons/godot_ai` subtree and official upstream `v3.1.2` addon subtree share exact tree SHA:
`a7d1e2fe8564cc385d683ec50d15fc66e1a17a35`.

This proves full v3.1.2 addon parity before synchronization.

Official upstream v3.1.3 tag commit:
`22678e5f9b038d7203d6b43b0aae20a5417c500e`.

The upstream v3.1.3 addon delta changes only `plugin.cfg` version `3.1.2` → `3.1.3`; the project applies only that delta. GUT and Hera vendor bytes are unchanged.

## Asset-vault rule and containment

Base authority requires:
- `.asset-vault/` = LOCAL ONLY, gitignored;
- `assets/_vault_local/` = LOCAL ONLY, gitignored;
- generated/in-review candidates are not repository assets before explicit promotion.

The baseline project incorrectly tracked 14 PNG files under `.asset-vault/library/gpt-imports/...` while lacking those ignore rules.

Merged reconciliation:
1. `.asset-vault/` and `assets/_vault_local/` are ignored.
2. The exact existing 14 tracked `.asset-vault` paths are frozen as a temporary legacy allowlist.
3. CI rejects every new tracked local-only path beyond that set using raw UTF-8 paths from the current HEAD tree.
4. A read-only preservation preflight inventories local vault files with size and SHA-256.
5. Project-internal preflight report output is restricted to `test-results/`; local-only roots are forbidden and report files are exclusive-create so existing files are never overwritten.
6. The current 14 tracked bytes are intentionally **not deleted** by this Decision.

## TDD and adversarial evidence

Initial RED head `e835af9412cc5b6d4c693fb18b7ab12abde4f467`:
- Project Contract `31282794028` expected FAILURE;
- focused 6 tests: 5 failed for the intended missing containment/tooling implementation, while existing GUT state passed.

Integration RED exposed Git HEAD-tree / Unicode quoted-path assumptions. The validator was corrected to use NUL-delimited UTF-8 `git ls-tree` without weakening the legacy allowlist.

Adversarial safety RED head `3f5ecb14233d2308a563fb8821f06e91e0d482e6`:
- Project Contract `31283223964` expected FAILURE;
- the sole focused failure proved the preflight could accept an existing project file such as `project.godot` as an output target.

Safety GREEN head `06d2cb61d15f2b4c9e6a5b5b89e00ea1356a544e`:
- Project Contract `31283266229` PASS after project-output restriction and exclusive-create report writing.

## Final PR validation and merge

PR `#115`  
Final review head: `f1b241293943aa2e467e74d74efdd6b0921b58c7`  
Concurrent main: `60f7834659b026494fa927c1b5aa5c9c41a2e489`  
Final PR test merge: `c2470b47cb01572c5a4e5ceeef96ae6703774c38`  
Product merge/main anchor: `2a51ec9391b0cd78efa9b99ebf504bf6f1390fe7`

Final PR test-merge PASS:
- Project Contract `31283336212` — focused reconciliation 7/7 PASS and vault validator `legacy_tracked=14 · assets/_vault_local_tracked=0` PASS;
- GUT 9.7.1 Tests `31283336286` PASS;
- Godot Tests `31283336254` PASS;
- Validate Thin Adapter Migration `31283336215` PASS;
- Validate Base Shared External AI Adapter `31283336219` PASS;
- Windows Demo Export `31283336208` PASS.

PR #115 had 12 changed files, zero review threads/comments/submitted reviews, no vault byte deletion, no Hera/GUT vendor change, and no gameplay/Scene/Resource/Theme/Animation/signal mutation. It was squash-merged with expected-head protection.

## Merged-main regression

At merged main `2a51ec9391b0cd78efa9b99ebf504bf6f1390fe7`:
- Project Contract `31283472740` PASS;
- GUT 9.7.1 Tests `31283472738` PASS;
- Validate Godot Live-Editor Pilot `31283472925` PASS;
- Godot Tests run `31283472735` attempt 2 PASS, including headless tests and its embedded real-project live-editor Pilot.

Godot Tests attempt 1 is retained as historical diagnostic evidence: all 92 cases / 11,494 assertions reached `failed=0`, but the Godot process did not exit before the outer 180-second timeout and returned exit 124; the embedded Pilot was therefore skipped. With no source change, attempt 2 passed. Classification: `NONREPRODUCED_GODOT_PROCESS_SHUTDOWN_TIMEOUT · TEST_ASSERTIONS_PASS · RERUN_PASS`.

## Authority boundary

No Scene/Resource/Theme/Animation/signal authoring, gameplay changes, runtime/POC claims, product-asset promotion, Hera vendor overwrite, or user-local deletion is authorized or claimed by this Decision.

## Deferred gate

`ASSET_VAULT_UNTRACK_DEFERRED_EXTERNAL_EXECUTOR`

The remaining 14 tracked vault paths may be untracked only after a local preservation attestation proves hash-verified copies exist outside the destructive pull path. Until then:
- `VAULT_LOCAL_STATE_UNVERIFIED` remains true from this remote session;
- `LEGACY_14_TRACKED_PRESERVED` remains true;
- `HERA_LOCAL_VERSION_UNVERIFIED` remains true;
- no claim of full vault cleanup is allowed.
