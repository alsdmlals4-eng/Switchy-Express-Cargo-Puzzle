# SX-AUD-049 · Benchmark Approval and Post-Phase-B Scope Reconciliation

Status: `USER_APPROVAL_RECONCILED · CANON_SYNC_CHANGESET · MERGE_REQUIRES_EXACT_HEAD_PASS`

Date: `2026-08-11 KST`

## Trigger

User approved the recommendation to adopt `SX-BMK-001 BMK-R01~R08` and keep `BMK-R09~R10` on post-validation hold.

## Fresh-start evidence

At start of this approval pass:

```yaml
project_default_branch: main
project_main: b842e9b89c08ecf0806891d3d08b56721ff9747c
project_open_prs: 0
base_main: 315c66eea9614c284b9c11c4d522141065dfa4b0
base_open_prs: 0
project_base_pin: v9.4.3
base_current_main_role: REFERENCE_ONLY
sheet_title: Switchy Express: Cargo Puzzle
sheet_timezone: Asia/Seoul
```

The configured Sheet and GitHub current authority both still showed the benchmark as proposed before the user's approval. No pre-existing `SX-DEC-056+` row or authority existed.

## Decision split

The approved benchmark subset is split by product responsibility rather than one oversized Decision.

### SX-DEC-056

`Route Causality Learning and Result Feedback`

Owns:

- BMK-R01 core positioning/feature triage;
- BMK-R02 request-only Route Probe / Encounter Strip;
- BMK-R03 Prediction → Execution → Debrief;
- BMK-R07 independent Fastest/Cheapest/Highest Score PBs + Route Fingerprint.

### SX-DEC-057

`Yard Labs and Mastery Curriculum`

Owns:

- BMK-R04 Stack/Switch/Builder Yard Labs;
- BMK-R05 optional Mastery Spur;
- BMK-R06 refinement layered on the already-approved Tutorial 1~10 sequence.

### SX-DEC-058

`Fixed-Seed Challenge Quality Policy`

Owns:

- BMK-R08 publication-quality refinement of the already-approved fixed-seed procedural Daily/Weekly lane.

### Hold

- BMK-R09 Shareable Route Card → `POST_VALIDATION_HOLD · NO_DECISION_ID`.
- BMK-R10 Editor/Workshop → `POST_VALIDATION_HOLD · NO_DECISION_ID`.

## Phase-B authority reconciliation

Important boundary:

`SX-AUD-047` authorized the exact `SX-DEC-055` runtime semantic POC implementation scope after Phase B. The new Decisions were approved **after** that Phase B review.

Therefore:

```text
SX-DEC-055
→ existing Phase-B BUILD authority remains valid
→ first implementation step remains Task 1 / Step 1.1 RED

SX-DEC-056~058
→ USER_APPROVED planning/product authority
→ implementation NOT authorized by SX-AUD-047
→ require post-Phase-B delta DoR / final planning review before coding/content implementation
```

This prevents the user's product approval from becoming an implicit scope expansion of an already-reviewed implementation package.

## Conflict review

### Product conflicts

`0 P0/P1 product conflicts` identified in the approved split.

Reason:

- SX-DEC-056 adds read-only prediction/debrief/result memory, not a new domain rule.
- SX-DEC-057 preserves the exact Tutorial 1~10 order and existing chapter progression.
- SX-DEC-058 preserves fixed-seed procedural Daily/Weekly and cosmetic-only fairness.
- R09/R10 are not activated.

### Protected scope

The following remain unchanged:

- GMB-002 finite authored campaign core;
- unlimited LIFO;
- manual/auto load;
- contiguous TOP unload;
- free build + piece cost + full refund;
- current switch/cycle/U-turn/lock authority;
- pause allowed;
- current success/failure/scoring authority;
- Base pin v9.4.3;
- semantic product asset provenance;
- `.asset-vault` deferred cleanup;
- physical/device/human validation ceiling;
- production cutover block.

## Verification gate

This change set is planning/canon only. Before merge, the exact PR head must satisfy the repository-required planning regression/engine checks. No merge may be claimed until fresh exact-head results are read.

The configured Sheet must then be updated under the same `SX-DEC-056`, `SX-DEC-057`, `SX-DEC-058`, and `SX-AUD-049` identifiers and read back after the merge-main SHA is known.
