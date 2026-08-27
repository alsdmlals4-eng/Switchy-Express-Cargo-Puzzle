# SX-DEC-061 Operating Gate Recovery

Status: `RESOLVED_FOR_CURRENT_PR · 2026-08-28 KST`

Tracking: GitHub Issue #228, PR #229

## Incident

The protected-path validator correctly read the current adapter baseline, but three entries in `docs/PROJECT_OPERATING_HEALTH.json` retained raw-byte SHA-256 values from older source files. This made the static gate evidence invalid, reduced verified operating evidence to zero, and prevented the PR from reaching its normal approval check.

## Solution

- Recomputed the three source hashes from the current tracked bytes only:
  - `docs/BASE_RULES_VERSION.md`
  - `docs/operations/SWITCHY_ADAPTER_MIGRATION_STATE_2026-08-06.json`
  - `docs/operations/SWITCHY_SHEET_AUTHORITY_EVIDENCE_2026-08-06.json`
- Preserved all gate statuses, maturity levels, product evidence boundaries, and user-facing product scope; the recovery changes provenance pointers only.
- Regenerated the two derived operating views from the exact Base v9.4.3 validation snapshot:
  - `docs/PROJECT_OPERATING_DASHBOARD.html`
  - `.agents/skills/switchy-express-cargo-puzzle-workflow-router/SKILL.md`
- Updated the existing protected-change approval manifest to include the user-approved `SX-DEC-061` documentation-only correction and the exact 41 detected protected paths. No policy, baseline, runtime code, or Decision scope was weakened.

## Lesson

Raw-byte evidence hashes are live integrity pointers, not descriptive metadata. When a referenced source changes through an approved reconciliation, its health record and every derived view must be refreshed before a later protected PR is considered mergeable.

## Base Promotion Assessment

`NO_BASE_PROMOTION` — Base already rejects stale raw-byte evidence and stale generated views. The affected source paths and the historical baseline are specific to Switchy Express.

## Verification Boundary

The exact Base validation snapshot accepted the recovered health record and generated views with external approval metadata simulated locally. This is operating-contract evidence only; it does not alter or prove Godot runtime, Windows/Android, audio, accessibility, human comprehension, or player experience.
