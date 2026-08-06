# SX-DEC-047 — Local Exact-HEAD Verification Fallback

```yaml
decision_id: SX-DEC-047
approval_batch_id: GMB-005
audit_id: SX-AUD-028
approved_by: user
approved_at: 2026-08-07 KST
status: APPROVED_ACTIVE_TEMPORARY
base_sha: a18b9fd52734f1884286bc3d0830e337d0c800c9
```

## Decision

When GitHub-hosted Actions cannot run because the current GitHub Actions budget is unavailable, validation may execute on the user's Windows checkout or another controlled external environment. The execution venue changes, but the exact HEAD, test-first, GUT 9.7.1, JUnit, production mutation, review-thread, mergeability, and merged-main readback gates remain mandatory.

Commits created during the constraint use `[skip actions]` so hosted workflows are not started. A skipped workflow is `NOT_RUN`, never PASS.

## Required implementation

- repository-owned Python verification core
- Windows PowerShell entry point
- exact 40-character SHA comparison
- clean worktree check before execution
- exact Godot 4.7.1 version check
- Python project contract and regression execution
- GUT minimum discovery of six tests and JUnit readback
- production mutation hash comparison
- machine-readable evidence manifest outside the repository
- PR comment binding the manifest SHA-256 to the exact PR HEAD

## Authority boundary

This decision does not authorize direct edits to `project.godot`, `.tscn`, `.tres`, `.res`, Scene wiring, or Resource ownership. HiGodot remains the sole author for those surfaces. It does not authorize GUT to modify production files. It does not change `SX-DEC-040~046`.

## Merge policy

The repository currently has no branch protection, Required Status Check, or Ruleset. Therefore an exact-HEAD PR may merge after local evidence and review even when hosted checks are skipped. Branch protection or repository policy must never be disabled to use this fallback.

## Expiration and restoration

The fallback remains active only while GitHub-hosted Actions execution is unavailable. Once hosted execution resumes, hosted checks return as the primary PR evidence. The local verifier remains a preflight and emergency fallback.
