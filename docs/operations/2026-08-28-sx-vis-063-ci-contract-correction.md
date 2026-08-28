# SX-VIS-063 CI contract correction · incident / solution / lesson

**Status:** `SECOND_ROOT_CAUSE_CORRECTED_ON_PR_244_HEAD_PENDING_REMOTE_RERUN`

## Incident

PR #244 initially failed three remote checks even though local Godot import and the full gameplay runner passed.

- The project adapter's required protected PR baseline advanced from `c20a0b571a066ce07e9e55fa324aa0ff1112b138` to the actual PR base `9c3be67cf99221d5007f0332be6935e81a6954bb`, while three migration/freshness tests still asserted the former value.
- The new protected-change approval replaced the historical `SX-DEC-060` and `SX-DEC-062` decision identifiers instead of preserving them; the historical evidence contract correctly rejected that loss.

## Root cause evidence

- Remote `contract`, `validate`, and `export-windows-demo` logs all reported the exact old/new baseline mismatch.
- The export contract additionally reported absence of `SX-DEC-060` from `decision_ids`.
- A local experiment that returned the adapter to the old hash made the legacy tests green but failed the current Base operating-contract check. The authoritative requirement is therefore the exact current PR base, not the obsolete test value.

## Solution

- Retained the adapter baseline at the actual PR base `9c3be67cf99221d5007f0332be6935e81a6954bb`.
- Updated the three hard-coded migration/freshness test fixtures to the same current baseline.
- Restored `SX-DEC-060` and `SX-DEC-062` alongside `SX-DEC-063` in the protected approval manifest.
- Corrected the operating-health raw-byte hashes from Windows checkout bytes to the canonical Git blob bytes that CI validates. The initial local check was insufficient because the repository's line-ending conversion changed the bytes read from disk.

## Verification

- Focused historical and migration suites: PASS.
- Python contracts: `220 passed, 1 skipped`.
- Base operating-contract validation and project contract validation: PASS locally; the exact clean-checkout rerun remains required after the raw-byte correction.
- This record does not alter the terrain runtime boundary; v02 remains `APPROVED_GITHUB_PRESERVED_RUNTIME_NOT_CONNECTED`.

## Lesson and promotion decision

When a protected baseline changes, update every project-local exact-hash assertion in the same review and preserve historical decision IDs required by retained evidence. When an evidence manifest stores raw-byte hashes, calculate them from Git blobs (or a clean checkout with conversion disabled), not a line-ending-converted Windows worktree. `NO_BASE_PROMOTION`: this is an interaction between Switchy's legacy compatibility tests, historical manifest, and Windows checkout conversion, while Base already requires exact contract validation.
