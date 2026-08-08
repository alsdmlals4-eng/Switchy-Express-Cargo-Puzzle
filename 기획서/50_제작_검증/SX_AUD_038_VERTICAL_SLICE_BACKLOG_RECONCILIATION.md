# SX-AUD-038 · Vertical Slice Backlog Reconciliation

**Date:** 2026-08-09 KST  
**Project baseline:** `c8eb8c47d620a7a7aa478e0559ec3d70bd8f6858`  
**Base:** `2a6ced23f6d6de1fb6e0a281c7138beb03f1a13b`  
**Scope:** GitHub backlog authority cleanup only. No gameplay/runtime/asset mutation.

## Trigger

The project has advanced through `SX-DEC-050`, `SX-DEC-051`, and `SX-DEC-052`, while three older Vertical Slice issues remain open with planning text last updated before those decisions.

Fresh recovery at this audit baseline shows:

- project default branch: `main`;
- project main: `c8eb8c47d620a7a7aa478e0559ec3d70bd8f6858`;
- open pull requests: `0`;
- Base main: `2a6ced23f6d6de1fb6e0a281c7138beb03f1a13b`;
- configured Google Sheet Hub/Decision/Audit/Production state matches the project main and still marks runtime/POC, device/human validation, and final product-asset approval as deferred/not run.

## Issue classification

### #3 · `[EPIC] Switchy Express Vertical Slice`

**Classification:** `KEEP_OPEN · CURRENT_AUTHORITY_NOTE_REQUIRED`

Reason:

- Its top-level completion gates still include real outstanding evidence: representative runtime evidence, 10-minute soak, and a `PASS / REVISE / PIVOT / STOP` playtest review.
- Closing the epic would incorrectly imply those gates are complete.
- Its original execution-order comments are historical and must not be used as current package routing.

Action:

- preserve the issue body/history;
- add a current-authority checkpoint pointing to `SX-DEC-050~052` and this audit;
- keep the issue open.

### #6 · `[VS-03] Staged local survival vertical slice`

**Classification:** `SUPERSEDED · CLOSE_NOT_PLANNED`

Reason:

- The body still declares `VS03-03_ONLY`, `READY_FOR_BUILD`, and a staged package order as current authority.
- That routing predates the later finite visual planning, production-candidate asset package, and local tooling/vault reconciliation decisions.
- Keeping it open as the current implementation queue conflicts with the current Sheet/Decision state, which explicitly defers runtime/POC and instead names local preservation attestation/product-asset promotion as later gates.
- Historical completed package evidence in the body/comments remains useful and should be preserved.

Action:

- add a supersession note;
- close as `not_planned`, not `completed`;
- do not delete or rewrite historical evidence.

### #7 · `[VS-04] 텔레메트리·10분 soak·플레이테스트·적대적 검토`

**Classification:** `KEEP_OPEN · CARRY_FORWARD_QUALITY_GATE`

Reason:

- Several responsibilities remain genuinely unverified: 10-minute soak, Android/device performance/touch/safe-area checks, representative runtime capture, accessibility/device observations, and 5+ first-experience human playtests.
- The issue currently says it is blocked by #6, but #6's staged implementation routing is superseded. That dependency must no longer be treated as authoritative.
- Product/runtime integration is currently deferred, so this quality gate is not ready to execute yet; it remains a future gate rather than a current implementation package.

Action:

- preserve the issue body/history;
- add a carry-forward note that #6 is no longer an active prerequisite;
- retain the still-valid quality gates;
- keep the issue open until product/runtime integration and required physical/human evidence exist.

## Deferred local-only blocker

`SX-DEC-052` remains unchanged:

`ASSET_VAULT_UNTRACK_DEFERRED_EXTERNAL_EXECUTOR · VAULT_LOCAL_STATE_UNVERIFIED`

The 14 legacy tracked `.asset-vault` PNGs must not be untracked from this remote session until a local hash-verified preservation attestation proves safe copies exist outside the destructive pull path.

This blocker is local to vault cleanup and does not prevent independent backlog reconciliation.

## Non-goals

This audit does **not**:

- approve final product assets;
- promote production-candidate art into Godot runtime assets;
- change gameplay logic;
- author Scene/Resource/Theme/Animation/signal/project state;
- claim runtime/POC completion;
- claim Windows physical, Android device, connected physical editor, soak, accessibility, or human validation;
- vendor Hera into the repository;
- untrack or delete user-local vault files.

## Expected post-reconciliation backlog

Open issues should be:

- #3 · Vertical Slice epic — umbrella gate;
- #7 · carry-forward quality/validation gate.

Issue #6 should be closed as superseded/not-planned.

## Status

`AUDIT_RECORDED · ISSUE_MUTATION_PENDING_MERGED_AUDIT · NO_PRODUCT_MUTATION`
