# SX-AUD-035 · Current Decision Registry Stale Summary Conflict

**Date:** 2026-08-08 KST  
**Related Decision:** SX-DEC-050  
**Base:** `fa69a77a14f923a756064f6ae151d34cadb374f7`  
**Current GitHub main at audit start:** `cb6b69360f4ba865cd103573d2a2c22d5c16a1cd`

## Finding

`기획서/00_프로젝트_허브/CURRENT_CONFIRMED_DECISIONS.md` is not current enough to be used as the sole recovered status source for this work turn.

It still records, among other stale values:

- an older verified product main around PR #106,
- pre-PR#110/#111 manual retest requirements,
- switch/route-end local retest language that predates the user's later physical PASS evidence,
- no SX-DEC-049 physical closure,
- no SX-DEC-050 planning package.

The configured Google Sheet and GitHub current main contain newer evidence.

## Handling

Status:

`CONFLICT_REPORTED · NOT_SILENTLY_RECONCILED · SEPARATE_BOUNDED_REFRESH_REQUIRED`

This visual-planning PR does not rewrite the full stale registry because that would mix unrelated historical/runtime authority repair into SX-DEC-050.

For SX-DEC-050 specifically, authority is recorded through:

- `docs/decisions/SX_DEC_050_FINITE_VISUAL_PLANNING_PACKAGE.md`,
- the approved design/plan,
- `FINITE_VISUAL_REQUIREMENT_PACKAGE_V1.md`,
- `FINITE_UI_COMPONENT_CATALOG_V1.md`,
- `FINITE_IMAGE_EXPLORATION_BRIEF_V1.md`,
- the configured Google Sheet using the same Decision ID.

## Required follow-up

A later authority-refresh task should reconcile `CURRENT_CONFIRMED_DECISIONS.md` against current main, PR #110/#111 closure evidence, SX-DEC-049 physical PASS, SX-DEC-050, and the configured Sheet.

Until that refresh is complete, future state recovery must continue to re-read current GitHub main and Sheet rather than trusting this stale registry summary alone.
