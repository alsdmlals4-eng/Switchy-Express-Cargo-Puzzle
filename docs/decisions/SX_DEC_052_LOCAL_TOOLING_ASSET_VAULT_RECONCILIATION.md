# SX-DEC-052 · Local Tooling & Asset-Vault Reconciliation

**Status:** `USER_APPROVED · HERA_REPO_ADOPTION_RECOVERY_IN_PROGRESS · GODOT_AI_3_1_3_SYNCED · HERA_TRACKED_V1_0_0_USER_ADOPTED · VAULT_UNTRACK_DEFERRED_EXTERNAL_EXECUTOR · PHASE1_FINAL_HEAD_RECHECK_REQUIRED`  
**Date:** 2026-08-09 KST  
**Original project baseline:** `60f7834659b026494fa927c1b5aa5c9c41a2e489`  
**Original product merge/main anchor:** `2a51ec9391b0cd78efa9b99ebf504bf6f1390fe7`  
**Original canonical closure/main:** `c8eb8c47d620a7a7aa478e0559ec3d70bd8f6858`  
**Concurrent Hera-adoption main:** `0a2bfc0f11e77ddaa09c5c45a83599c745375789`  
**Base:** `2a6ced23f6d6de1fb6e0a281c7138beb03f1a13b`

## Decision

Adopt a non-destructive reconciliation for local Godot tooling and the project-local asset vault. GitHub remains the only patch/merge surface. Existing user-local vault bytes must not be deleted by remote cleanup.

This same Decision ID also owns reconciliation of the later user-authored Hera repository adoption because that change updates the exact tooling authority originally recorded here; it does not create a new gameplay/product decision.

## User-approved local tooling evidence

User-provided evidence remains authoritative for local approval state:

- Godot AI: updated locally to **3.1.3** and approved.
- Hera Agent Godot: plugin **enabled and approved**.
- GUT: plugin **enabled and approved**.

Remote/GitHub evidence is tracked separately from physical editor evidence.

## Original PR #115/#116 repository authority

At canonical closure `c8eb8c47d620a7a7aa478e0559ec3d70bd8f6858`:

- Godot AI tracked manifest: **3.1.3**;
- GUT tracked manifest: **9.7.1** and enabled in `project.godot`;
- Hera: user-approved but **repo-untracked** at that historical point;
- exact Hera local physical version: `LOCAL_VERSION_UNVERIFIED` from the remote session.

That repo-untracked Hera statement is historical, not current authority after the later user adoption.

## Later user Hera repository adoption

User-authored commit:

`614fbdce2b1517b8ef34eadb156bf058ecf59b1d · Enable Hera and GitHub tracking`

was later merged with the project line into:

`0a2bfc0f11e77ddaa09c5c45a83599c745375789`.

That change intentionally:

- tracks `addons/hera_agent_godot/`;
- enables `res://addons/hera_agent_godot/plugin.cfg` in `project.godot`;
- persists `HeraGameInspector` as an autoload;
- retains Godot AI 3.1.3 and GUT 9.7.1.

The user change is preserved. It must not be reverted merely to recover CI.

## Hera provenance

Official upstream:

- repository: `NotNull92/hera-agent-godot`;
- tag: `v1.0.0`;
- tag commit: `10f245ddae9e7a5d569150302acbde0d78f2aa03`;
- official addon subtree: `6cb87ac8ba768de1d924447f385fba6d80bcde68`.

The user-vendored project `addons/hera_agent_godot` subtree at `0a2bfc0f...` has the exact same tree SHA:

`6cb87ac8ba768de1d924447f385fba6d80bcde68`.

Therefore the tracked vendor begins from exact upstream Hera **v1.0.0** bytes.

## Bounded project compatibility patch

The project's strict Godot `--headless` import/test tiers are different from Hera's live-editor operating tier. Exact upstream v1.0.0 starts its editor HTTP server during strict headless import, which produced shutdown leak/error lines that this project's CI correctly rejects.

The selected bounded compatibility rule is:

- keep Hera tracked and enabled for normal editor use;
- maintain exactly one documented project compatibility patch in `addons/hera_agent_godot/hera_agent_plugin.gd`;
- at the beginning of `_enter_tree()`, return before editor UI/autoload/server setup when `DisplayServer.get_name() == "headless"`;
- normal non-headless editor behavior remains upstream v1.0.0 behavior.

Current tooling authority records this patch as:

`addons/hera_agent_godot/hera_agent_plugin.gd:HEADLESS_EARLY_RETURN`.

The committed `HeraGameInspector` autoload is also normalized to the clean-clone-stable path:

`HeraGameInspector="*res://addons/hera_agent_godot/runtime/game_inspector.gd"`

rather than the UID form that failed during clean-checkout direct headless startup before the imported UID cache was available.

This is tooling/configuration reconciliation only. It does not authorize gameplay, Scene, Resource, Theme, Animation, signal, or product-asset mutation.

## Godot AI synchronization basis

Baseline project `addons/godot_ai` subtree and official upstream `v3.1.2` addon subtree share exact tree SHA:

`a7d1e2fe8564cc385d683ec50d15fc66e1a17a35`.

Official upstream v3.1.3 tag commit:

`22678e5f9b038d7203d6b43b0aae20a5417c500e`.

The upstream v3.1.3 addon delta changes only `plugin.cfg` version `3.1.2` → `3.1.3`; the project applied only that delta. This remains unchanged by the Hera adoption recovery.

## Asset-vault rule and containment

Base authority requires:

- `.asset-vault/` = LOCAL ONLY, gitignored;
- `assets/_vault_local/` = LOCAL ONLY, gitignored;
- generated/in-review candidates are not repository assets before explicit promotion.

The earlier project state incorrectly tracked 14 PNG files under `.asset-vault/library/gpt-imports/...` while lacking those ignore rules.

Merged reconciliation remains:

1. `.asset-vault/` and `assets/_vault_local/` are ignored.
2. The exact existing 14 tracked `.asset-vault` paths are frozen as a temporary legacy allowlist.
3. CI rejects every new tracked local-only path beyond that set using raw UTF-8 paths from the current HEAD tree.
4. A read-only preservation preflight inventories local vault files with size and SHA-256.
5. Project-internal preflight output is restricted to `test-results/`; local-only roots are forbidden and report files use exclusive-create so existing files cannot be overwritten.
6. The 14 tracked bytes remain intentionally preserved until local hash-verified preservation attestation exists.

Hera adoption does not alter this gate.

## Original containment TDD history

Initial RED head `e835af9412cc5b6d4c693fb18b7ab12abde4f467`:

- Project Contract `31282794028` expected FAILURE;
- focused 6 tests: 5 intended failures for missing containment/tooling implementation.

Integration RED exposed Git HEAD-tree/Unicode quoted-path assumptions; the validator was corrected to use NUL-delimited UTF-8 `git ls-tree`.

Adversarial safety RED head `3f5ecb14233d2308a563fb8821f06e91e0d482e6`:

- Project Contract `31283223964` expected FAILURE;
- proved preservation preflight could otherwise accept an existing project file as an output target.

Safety GREEN head `06d2cb61d15f2b4c9e6a5b5b89e00ea1356a544e`:

- Project Contract `31283266229` PASS after output restriction/exclusive-create behavior.

PR #115 final test merge `c2470b47cb01572c5a4e5ceeef96ae6703774c38` passed Contract/GUT/Godot/Thin/adapter/Windows gates and merged as `2a51ec9391b0cd78efa9b99ebf504bf6f1390fe7`.

PR #116 canonical closure merged as `c8eb8c47d620a7a7aa478e0559ec3d70bd8f6858`; final-main Contract/GUT/Godot/Pilot passed.

## Hera adoption recovery RED/GREEN evidence

Current-main integration RED at `0a2bfc0f11e77ddaa09c5c45a83599c745375789`:

- Project Contract `31284627677` FAILURE;
- GUT `31284627676` FAILURE;
- Godot Tests `31284627671` FAILURE;
- Validate Godot Live-Editor Pilot `31284627904` FAILURE.

Root causes are recorded in `SX-AUD-039` and are bounded to stale Pilot/plugin authority plus Hera strict-headless side effects; product test assertions themselves were not the failing product behavior.

Focused legitimate RED:

- head `a89cde3abbea20759ea225bc182afb4d3b34f186`;
- exact PR test merge `086b6ad51c69e49db30a05af053ed47ea66706a8`;
- Project Contract `31285424677` expected FAILURE;
- Hera focused tests 3/3 failed for the intended missing state: no headless guard, UID autoload form, and stale `repo_tracked=false` authority.

Intermediate implementation head `cb3d2916d58f95e3cc5c2a5c0b9d9927e474d31e` proved:

- Hera focused recovery tests PASS;
- existing local-tooling/vault contract PASS;
- GUT `31285499877` PASS;
- Thin `31285499880` PASS;
- Godot product tests complete **92 cases / 11,494 assertions / failed=0** with the invalid Hera autoload error removed;
- the remaining Godot/Contract/Windows failures at that head are all attributable to the deliberately not-yet-refreshed Pilot `project.godot` source baseline, not a Windows export or gameplay assertion failure.

Pilot source baseline was then refreshed for the normalized Hera-enabled `project.godot` using:

- baseline implementation commit `cb3d2916d58f95e3cc5c2a5c0b9d9927e474d31e`;
- `project.godot` Git blob `1923e0733fbf884f6507b9f2a8a59d302d10f56b`;
- raw SHA-256 `65cf1cec990d54b6a4e319b8ba76a805be4da2242fd4a8001091dd3784dbb385`.

Final Phase 1 merge authority still requires a fresh exact-head/test-merge verification after all authority docs are included.

## Authority boundary

No Scene/Resource/Theme/Animation/signal authoring, gameplay change, runtime/POC claim, product-asset promotion, physical Hera connectivity claim, or user-local vault deletion is authorized or claimed by this Decision.

Hera's repository version is verified as tracked v1.0.0. The remote session still does not independently read a separate physical local-editor package/version outside the tracked repository.

## Deferred gate

`ASSET_VAULT_UNTRACK_DEFERRED_EXTERNAL_EXECUTOR`

The remaining 14 tracked vault paths may be untracked only after local preservation attestation proves hash-verified copies exist outside the destructive pull path. Until then:

- `VAULT_LOCAL_STATE_UNVERIFIED` remains true from this remote session;
- `LEGACY_14_TRACKED_PRESERVED` remains true;
- no claim of full vault cleanup is allowed.

Runtime/POC, Windows physical runtime, Android device, connected physical editor, human validation, and final product-asset approval remain separate deferred gates.
