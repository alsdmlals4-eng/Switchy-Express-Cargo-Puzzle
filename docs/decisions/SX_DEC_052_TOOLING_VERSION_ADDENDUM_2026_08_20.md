# SX-DEC-052 · Tooling Version Addendum · 2026-08-20

```yaml
parent_decision: SX-DEC-052_LOCAL_TOOLING_ASSET_VAULT_RECONCILIATION
status: CURRENT_EVIDENCE_ADDENDUM
historical_parent_state: GODOT_AI_3_1_3_SYNCED_AT_2026_08_09_CLOSURE
current_project_repo_plugin: 3.1.4
current_user_local_version: UNVERIFIED
build_gate: VERIFY_LOCAL_REPO_TREE_PARITY_BEFORE_GODOT_AUTHORING
```

`SX_DEC_052_LOCAL_TOOLING_ASSET_VAULT_RECONCILIATION.md`의 3.1.3 기록은 **2026-08-09 당시 병합/검증된 역사 증거**로 보존한다. 이 addendum은 그 역사 기록을 삭제하지 않고, 이후 프로젝트 main이 실제로 3.1.4 plugin manifest를 포함하게 된 현재 상태만 덧붙인다.

## Current observed repository evidence

```yaml
project_plugin_cfg_version: 3.1.4
project_commit_with_3_1_4_present: 5f65dcf2a21db4a0215ee0dfbc44cfbe63d3a633
project_main_observed_2026_08_20: 0a88f707e1e4131ae4372929f2871d2b8a3a74b7
upstream_3_1_4_version_bump_commit: 96cc8b8c3d25ce487e24801d01d5214fea150349
upstream_main_observed_version: 3.1.5
upstream_main_observed_commit: 09a1e3311015153d967710fbe6502ac519585a9b
prior_exact_release_basis: v3.1.3
prior_exact_release_commit: 22678e5f9b038d7203d6b43b0aae20a5417c500e
```

The upstream `Bump version to 3.1.4` commit proves a 3.1.4 upstream version transition exists. It does **not** by itself prove that every byte in the project's current vendored addon tree is an exact copy of one upstream tag/commit.

## Current authority

The machine-readable owner is:

`docs/tooling/local_godot_tooling_state.json`

Interpret it as:

```text
repo plugin version 3.1.4: OBSERVED
upstream 3.1.4 version-bump commit: OBSERVED
user-local addon version/tree: NOT_RUN / UNVERIFIED
project repo ↔ user-local exact tree parity: NOT_RUN
project repo ↔ one exact upstream 3.1.4 tree parity: UNVERIFIED
```

Therefore do not:
- roll the project manifest back to 3.1.3 merely to satisfy stale tests;
- claim the user's local installation is 3.1.4 without reading it;
- claim exact upstream-tree parity from a version string alone;
- auto-upgrade the project to upstream main 3.1.5 without a separate approved tooling decision.

## Fresh execution requirement

Before persistent Godot authoring:

1. resolve the actual project checkout;
2. preserve/inspect user changes;
3. read local `addons/godot_ai/plugin.cfg` and relevant tree identity;
4. compare local vs repository current addon state;
5. if exact upstream provenance matters for the task, compare against a concrete upstream commit/tree;
6. record the observed result rather than inferring it.

Until then:

`PROJECT_3_1_4_REPO_PRESENT · LOCAL_PARITY_REVERIFY_REQUIRED`.
