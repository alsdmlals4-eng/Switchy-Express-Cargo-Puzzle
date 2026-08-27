# SX-DEC-061 Operating Gate Cross-Platform Evidence Recheck

Status: `RESOLVED_FOR_CURRENT_PR · 2026-08-28 KST`

Tracking: GitHub Issue #228, PR #229

## Incident

The protected-path validator uses raw Git/LF bytes in Linux CI. A first local Windows check used the working-tree copies after `core.autocrlf` conversion and therefore produced different SHA-256 values for three health-evidence sources. Treating those Windows CRLF values as canonical would have made the PR fail in CI.

## Solution

- Verified the three source hashes against the exact Git/LF bytes used by CI:
  - `docs/BASE_RULES_VERSION.md`
  - `docs/operations/SWITCHY_ADAPTER_MIGRATION_STATE_2026-08-06.json`
  - `docs/operations/SWITCHY_SHEET_AUTHORITY_EVIDENCE_2026-08-06.json`
- Restored the health record to those canonical Git/LF values; gate statuses, maturity levels, product evidence boundaries, and product scope are unchanged.
- Rechecked the two derived operating views with the exact Base v9.4.3 validation snapshot:
  - `docs/PROJECT_OPERATING_DASHBOARD.html`
  - `.agents/skills/switchy-express-cargo-puzzle-workflow-router/SKILL.md`
- Updated the existing protected-change approval manifest to include the user-approved `SX-DEC-061` documentation-only correction and the exact 41 detected protected paths. No policy, baseline, runtime code, or Decision scope was weakened.

## Lesson

Raw-byte evidence hashes are live integrity pointers, not descriptive metadata. On Windows, they must be computed from the canonical Git blob or a clean LF checkout whenever CI validates raw bytes; the converted working-tree copy is not an authority source.

## Base Promotion Assessment

`NO_BASE_PROMOTION` — Base already rejects stale raw-byte evidence and stale generated views. The affected source paths and the historical baseline are specific to Switchy Express.

## Verification Boundary

The exact Base validation snapshot accepted the restored health record and generated views when evaluated against canonical Git/LF bytes with external approval metadata simulated locally. This is operating-contract evidence only; it does not alter or prove Godot runtime, Windows/Android, audio, accessibility, human comprehension, or player experience.
