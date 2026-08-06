# Local Exact-HEAD Verification

```yaml
decision_id: SX-DEC-047
audit_id: SX-AUD-028
status: ACTIVE_TEMPORARY_FALLBACK
reason: GITHUB_HOSTED_ACTIONS_BUDGET_UNAVAILABLE
replaces: execution venue only
preserves:
  - exact HEAD
  - TDD
  - GUT 9.7.1 discovery and JUnit
  - legacy regression during migration
  - production mutation guard
  - diff and review-thread inspection
```

## Purpose

This procedure runs the same project validation responsibilities outside GitHub-hosted Actions when hosted minutes or budget are unavailable. It does not delete workflows, relax gameplay acceptance criteria, or convert an untested branch into a PASS.

Commits and merge commits made while the budget constraint is active use `[skip actions]`. This prevents hosted workflow consumption; it is not a success signal. The proof source is the generated exact-HEAD manifest plus the PR diff and review readback.

## Prerequisites

- Windows checkout of `alsdmlals4-eng/Switchy-Express-Cargo-Puzzle`
- clean working tree
- full 40-character PR HEAD SHA
- Python 3.12 available as `python`
- exact Godot `4.7.1-stable` executable
- GUT 9.7.1 present at `res://addons/gut`
- formal GUT consumers under `res://tests/gut`

The output directory defaults to the Windows temporary directory and stays outside the repository.

## Command

```powershell
Set-Location "C:/Users/user/Documents/GitHub/Ninza/Switchy-Express-Cargo-Puzzle"

git fetch --prune origin
git switch <pr-branch>
git pull --ff-only origin <pr-branch>
$ExpectedHead = git rev-parse HEAD

./tools/run_local_exact_head_verification.ps1 `
  -ExpectedHead $ExpectedHead `
  -GodotExecutable "C:/path/to/Godot_v4.7.1-stable_win64.exe"
```

Do not use a short SHA for `-ExpectedHead`. The wrapper writes:

```text
%TEMP%/SwitchyExpress/local-exact-head/<head-prefix>/local-verification.json
%TEMP%/SwitchyExpress/local-exact-head/<head-prefix>/gut-junit.xml
```

## Verification sequence

1. `git rev-parse HEAD` equals the supplied exact SHA.
2. `git status --porcelain` is empty.
3. Godot `--version` starts with `4.7.1`.
4. Python unittests pass.
5. `tools/validate_project_contract.py` passes.
6. Existing `res://tests/run_tests.gd` regression passes during migration.
7. GUT 9.7.1 runs `res://tests/gut`, creates JUnit, and discovers at least six tests.
8. Production hashes are identical before and after all commands.
9. `local-verification.json` is written with exact SHA, commands, versions, counts, hashes, timestamps, and limitations.

## Stable failure codes

| Code | Meaning |
|---|---|
| `HEAD_MISMATCH` | checked-out commit differs from the reviewed PR HEAD |
| `DIRTY_WORKTREE` | tracked or untracked repository changes exist before validation |
| `GODOT_VERSION_MISMATCH` | executable is not Godot 4.7.1 |
| `COMMAND_FAILED` | one validation command returned non-zero |
| `GUT_JUNIT_MISSING` | GUT did not create the report |
| `GUT_DISCOVERY_BELOW_MINIMUM` | fewer than six formal GUT tests were discovered |
| `GUT_JUNIT_FAILURE` | JUnit reports failures or errors |
| `PRODUCTION_MUTATION` | tests changed a protected production file |
| `ARTIFACT_DIR_NOT_IGNORED` | an in-repository artifact path is not ignored |

## PR evidence comment

After a PASS, post the following values on the PR without committing the artifact and changing HEAD:

```text
LOCAL_EXACT_HEAD_VERIFICATION: PASS
HEAD: <40-character SHA>
GODOT: <manifest godot_version>
GUT: discovered=<n> failures=0 errors=0
PRODUCTION_MUTATION: false
MANIFEST_SHA256: <sha256 of local-verification.json>
LIMITATIONS: HIGODOT_CONNECTION_NOT_VERIFIED; WINDOWS_RUNTIME_SMOKE_NOT_INCLUDED; ANDROID_DEVICE_NOT_RUN; HUMAN_COMPREHENSION_NOT_RUN
```

A comment for an older SHA is invalid. Any commit requires a fresh run and a new manifest hash.

## Review and merge gate

The fallback PR is mergeable only when:

- reviewed exact HEAD equals current PR HEAD
- manifest status is PASS for that SHA
- full changed-file inventory is within approved scope
- no production Scene, Resource, `project.godot`, or gameplay file changed without its authority
- unresolved review threads are zero
- no P0/P1 finding remains
- mergeability is true

The repository currently has no Required Status Check or Ruleset. This fact allows the fallback but does not replace evidence.

## Restoration

When GitHub-hosted Actions budget becomes available again:

1. stop adding `[skip actions]` to new commits
2. run hosted checks on the next PR exact HEAD
3. compare hosted results with the local manifest
4. retain the local verifier as a developer preflight and incident fallback
5. do not delete existing workflow files as part of restoration
