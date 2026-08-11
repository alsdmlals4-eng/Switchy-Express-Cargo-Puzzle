# SX-DEC-052 · Godot AI 3.1.4 Reconciliation Amendment

**Decision ID:** `SX-DEC-052`  
**Status:** `USER_UPDATED_MAIN · EXACT_UPSTREAM_V3_1_4_ADDON_TREE_VERIFIED · TOOLING_AUTHORITY_RECONCILIATION`  
**Date:** 2026-08-11 KST

## Purpose

This amendment updates only the current Godot AI version/provenance portion of `SX-DEC-052`. The original `SX_DEC_052_LOCAL_TOOLING_ASSET_VAULT_RECONCILIATION.md` remains historical evidence for the earlier 3.1.3 adoption, GUT 9.7.1, Hera v1.0.0 headless compatibility patch, and asset-vault containment.

The user's direct `main` update at:

`5f65dcf2a21db4a0215ee0dfbc44cfbe63d3a633`

replaced the tracked Godot AI addon with v3.1.4. This is preserved and reconciled rather than reverted.

## Current Godot AI authority

```yaml
decision_id: SX-DEC-052
repo_version: 3.1.4
user_local_version: 3.1.4
upstream_repository: hi-godot/godot-ai
upstream_tag: v3.1.4
upstream_commit: 96cc8b8c3d25ce487e24801d01d5214fea150349
upstream_addon_tree_sha: 69010571e11123dfc4e09483f80cb9e6ca93511a
project_addon_tree_sha: 69010571e11123dfc4e09483f80cb9e6ca93511a
parity: EXACT_UPSTREAM_V3_1_4_ADDON_TREE_PARITY
user_enabled_approved: true
```

Official v3.1.4 is a non-prerelease upstream release. The project `addons/godot_ai` tree at the user's update commit exactly matches upstream `plugin/addons/godot_ai` for tag v3.1.4, so the current repository does not carry an unidentified partial plugin copy.

## Preserved boundaries

This amendment does not change:

- `GMB-002` gameplay/product authority;
- `SX-DEC-055` Runtime Semantic POC implementation;
- GUT `9.7.1` authority or enabled state;
- Hera v1.0.0 tracked adoption and `HEADLESS_EARLY_RETURN` compatibility patch;
- the 14-path legacy asset-vault containment boundary;
- product PNGs, maps, save authority, scoring, rulesets, input semantics, or export content contract;
- `SX-DEC-056~058` implementation authority.

Physical Windows runtime, Android device validation, connected physical editor validation, human comprehension, and production cutover remain separate evidence gates.

## TDD / reconciliation evidence

Before this amendment, current `main` already contained Godot AI v3.1.4 while the local-tooling contract still required v3.1.3.

Observed RED:

- source main: `5f65dcf2a21db4a0215ee0dfbc44cfbe63d3a633`;
- Project Contract run `#1254` failed at `Validate local tooling and asset-vault reconciliation`;
- exact failure: `test_godot_ai_repo_manifest_is_3_1_3` expected `version="3.1.3"` while `plugin.cfg` contained `version="3.1.4"`.

The minimal GREEN target is to reconcile the machine-readable tooling state and its contract test to the verified v3.1.4 tag/commit/tree without modifying the already-updated addon bytes.

## Current consumers

- `addons/godot_ai/plugin.cfg`
- `docs/tooling/local_godot_tooling_state.json`
- `tests/python/test_local_tooling_reconciliation.py`
- `docs/decisions/SX_DEC_052_LOCAL_TOOLING_ASSET_VAULT_RECONCILIATION.md` as historical adoption evidence
- this amendment as the current Godot AI version/provenance override for `SX-DEC-052`

If these surfaces disagree, the exact upstream-tree comparison and the machine-readable tooling state must be reconciled before an acceptance build is assigned.
