# SX-AUD-028 — Local Exact-HEAD Fallback Audit

```yaml
audit_id: SX-AUD-028
decision_id: SX-DEC-047
approval_batch_id: GMB-005
date: 2026-08-07
project_main: a18b9fd52734f1884286bc3d0830e337d0c800c9
base_main_observed: 4f98f968a377f7b6a11aafa4fc94d11bddbebedc
trigger: USER_REPORTED_GITHUB_ACTIONS_BUDGET_UNAVAILABLE
```

## Entry readback

```yaml
project_default_branch: main
open_pull_requests: 0
main_protected: false
required_status_checks: []
rulesets: []
google_sheet_phase: GUT_FORMAL_ADOPTION_PHASE_B_NEXT
```

## Finding

GitHub-hosted Actions cannot be relied on for the current batch. The repository does not technically require hosted status checks, so direct merging is possible, but merging without replacement evidence would violate the active v4.3 contract.

## Approved correction

Create a repository-owned local exact-HEAD verifier and use external execution evidence instead of hosted runner evidence. Preserve all objective gates and record skipped hosted workflows as `NOT_RUN`.

## Scope

```yaml
GAMEPLAY_UNCHANGED: true
PROJECT_GODOT_UNCHANGED: true
SCENE_RESOURCE_UNCHANGED: true
EXISTING_WORKFLOWS_UNCHANGED: true
NEW_BINARY_ASSETS: false
WINDOWS_FULL_PROJECT_NOT_RUN: true
ANDROID_DEVICE_NOT_RUN: true
HIGODOT_CONNECTION_NOT_VERIFIED: true
```

## Test-first evidence

```yaml
red_1: missing Python verifier file
red_2: missing hash, JUnit and evidence APIs
red_3: missing PowerShell wrapper
red_4: missing operator/canon/audit documents
green_target: Python unittest module and compileall
```

## Residual risk

- The current remote execution environment cannot clone the full repository or run Godot.
- Full project verification must therefore run on the user Windows checkout after this tooling is merged.
- A local PASS for one SHA cannot be reused after any commit.
- Windows visual runtime, Android device, human comprehension, and HiGodot connection remain separate gates.

## Current status

```text
LOCAL_VERIFIER_IMPLEMENTED_AND_UNIT_TESTED
→ TOOLING_PR_EXACT_DIFF_REVIEW
→ MERGED_MAIN_READBACK
→ WINDOWS_FULL_PROJECT_EXACT_HEAD_RUN
→ GUT_PHASE_B_AND_GAMEPLAY_TDD
```
