# SX-AUD-065 · PR #157 Validation Repair

```yaml
audit_id: SX-AUD-065
pr: 157
status: VALIDATION_REPAIR_APPLIED · FINAL_EXACT_HEAD_CHECKS_PENDING
scope: PLANNING_CANON_TOOLING_EVIDENCE_ONLY
product_build: NOT_STARTED
human_evidence: NOT_RUN
```

PR #157의 첫 exact-head validation에서 두 종류의 실패를 분리해 root-cause-first로 처리했다. 실패를 문서-only PR이라는 이유로 무시하거나 checks를 우회하지 않았다.

## 1. Platform / Release / Asset Rights validation

### Symptom

`test_project_agents_routes_platform_review_to_current_contract` failed because `AGENTS.md` no longer named the required platform/release/asset-rights owner paths.

### Root cause

v4.7/SX-DEC-059용 `AGENTS.md`를 재구성하면서 기존 필수 consumer routing을 누락했다. 이는 현재 작업이 만든 `OMISSION` 회귀다.

### Fix

`AGENTS.md`에 다음 current owners를 복구했다.

```text
docs/PLATFORM_RELEASE_AND_ASSET_RIGHTS_PROFILE.md
docs/ASSET_RIGHTS_AND_PROVENANCE_RECORD.md
docs/GAME_RELEASE_COMPLIANCE_EVIDENCE_PACK.md
기획서/50_제작_검증/PLATFORM_RELEASE_AND_ASSET_RIGHTS_PLAN.md
```

이 수정은 platform/legal/store Gate를 PASS로 승격하지 않는다. 단지 current routing을 복구한다.

## 2. Project Contract / local tooling reconciliation

### Symptom

`test_local_tooling_reconciliation.py` expected Godot AI `3.1.3`, while the repository's actual `addons/godot_ai/plugin.cfg` already reported `3.1.4` on the pre-059 project main.

The same test also forced `user_local_version=3.1.3`, even though no fresh local machine read occurred in this chat.

### Root cause

The repository had already advanced the vendored plugin manifest to 3.1.4, but the tooling-state consumer/test remained pinned to the earlier SX-DEC-052 3.1.3 closure snapshot. Rolling the repository back merely to satisfy the stale assertion would have made the code fit the test instead of repairing the contract.

### Primary-source evidence

- project repository commit `5f65dcf2a21db4a0215ee0dfbc44cfbe63d3a633` contains `plugin.cfg version="3.1.4"`;
- upstream `hi-godot/godot-ai` commit `96cc8b8c3d25ce487e24801d01d5214fea150349` is titled `Bump version to 3.1.4`;
- upstream main was separately observed at version 3.1.5 / `09a1e3311015153d967710fbe6502ac519585a9b`.

A version-bump commit does not prove full project-vendored-tree parity to one upstream commit/tag, so full parity remains unverified.

### Fix

- keep project repo plugin at observed 3.1.4;
- update machine-readable tooling state to distinguish:
  - repository version = 3.1.4 observed;
  - upstream 3.1.4 version-bump commit observed;
  - prior exact release basis = v3.1.3;
  - user-local version/tree = `REVERIFY_IN_FRESH_POWERSHELL`;
  - full tree parity = unverified until execution preflight;
- update the tooling reconciliation test to verify the current evidence model instead of hard-coding historical 3.1.3/local state;
- add `SX_DEC_052_TOOLING_VERSION_ADDENDUM_2026_08_20.md` rather than rewriting the original 2026-08-09 historical closure.

## 3. Protected boundaries

The repair does not:

- change game code, scenes, resources, map JSON, or product PNGs;
- upgrade Godot AI to upstream main 3.1.5;
- claim user-local 3.1.4 parity without reading it;
- alter PR #154;
- implement SX-DEC-056/057/058;
- start Codex/Godot BUILD;
- claim physical/human PASS.

## 4. Final validation gate

After this repair commit, require a new exact-head run of:

```text
Project Contract
Validate Thin Adapter Migration
Validate platform release and asset rights
Godot Tests
GUT 9.7.1 Tests
Windows Demo Export
```

Do not merge based on the failed/superseded earlier head.
