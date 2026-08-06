# Local Exact-HEAD Verification Fallback Design

## Status

```yaml
approval_batch_id: GMB-005
decision_id: SX-DEC-047
audit_id: SX-AUD-028
approved_by: user
approved_at: 2026-08-07 KST
base_sha: a18b9fd52734f1884286bc3d0830e337d0c800c9
scope: validation infrastructure only
production_gameplay_changes: forbidden
```

## Problem

GitHub-hosted Actions cannot be used for the current work because the user reports no available GitHub Actions budget. The repository currently has no branch protection, Required Status Check, or Ruleset, so a PR can technically merge without hosted checks. The v4.3 evidence contract still requires TDD, exact-HEAD verification, production mutation detection, review, and merged-main readback. The fallback therefore replaces only the execution venue; it does not weaken the validation content.

## Decision

Use a repository-owned local verification bundle that runs on an exact checked-out PR HEAD and produces a machine-readable evidence manifest. Commit and PR messages for work performed during the budget constraint include `[skip actions]` so hosted workflows do not consume budget. The fallback is temporary and does not delete or redefine existing workflows.

## Architecture

- `tools/local_exact_head_verification.py` owns cross-platform validation orchestration, production hashing, command result capture, JUnit readback, and final evidence manifest generation.
- `tools/run_local_exact_head_verification.ps1` is the Windows entry point. It resolves the repository root and exact Godot executable, then invokes the Python verifier.
- `tests/python/test_local_exact_head_verification.py` verifies head mismatch rejection, dirty worktree rejection, mutation detection, JUnit discovery floors, deterministic hashing, and successful manifest output.
- `docs/testing/LOCAL_EXACT_HEAD_VERIFICATION.md` documents the operator command, evidence fields, failure modes, PR comment format, and restoration path when hosted Actions become available.

## Exact-HEAD Contract

The verifier fails closed unless all of the following are true:

1. `git rev-parse HEAD` equals `--expected-head`.
2. The worktree is clean before validation.
3. Godot reports `4.7.1-stable` or an explicitly equivalent `4.7.1` build string.
4. Every configured command exits with code 0.
5. GUT JUnit exists and has at least the configured minimum discovered tests.
6. Production file hashes before and after validation are identical.
7. Test artifacts are written only beneath the configured artifact directory.
8. The evidence manifest records exact HEAD, tool versions, commands, exit codes, hashes, timestamps, and limitations.

## Default Validation Sequence

```text
git exact-head and clean-tree gate
→ exact Godot version gate
→ Python unittest discovery
→ project contract validator
→ legacy Godot regression runner
→ GUT 9.7.1 CLI with JUnit output
→ production hash comparison
→ evidence manifest
```

The existing legacy runner remains during Phase B migration and is labeled separately from formal GUT authority. A legacy PASS is not counted toward the GUT discovery floor.

## Production Mutation Scope

The default hash inventory includes:

```text
project.godot
**/*.tscn
**/*.tres
**/*.res
data/**
assets/**
game/**
```

The verifier excludes `.git`, `.godot`, the configured artifact directory, and test-only paths from the production hash inventory. Tests may write only to the artifact directory or `user://` managed by Godot.

## GitHub Process Without Hosted Actions

```text
branch from verified main
→ TDD implementation
→ commit with [skip actions]
→ PR
→ exact PR HEAD readback
→ execute local verifier against that SHA
→ post manifest summary and SHA-256 to PR
→ GPT diff/review-thread/mergeability attack review
→ merge with [skip actions]
→ main readback
→ Sheet same-ID sync
```

A manifest generated for an older HEAD is invalid. Any new commit requires a new verifier run.

## Security and Integrity

- No branch protection or Ruleset is disabled because neither is currently configured.
- Existing workflows remain unchanged and can be restored as the primary execution venue without migration.
- The verifier never edits production files.
- The output directory is required to be untracked or ignored before execution.
- Secrets, tokens, credentials, and absolute user paths are not written into the evidence manifest.

## Evidence Ceiling

This fallback enables local exact-HEAD evidence but does not itself prove Windows runtime, Android device runtime, human comprehension, or HiGodot authoring connection. Those remain `NOT_RUN` until separately observed.
